-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
IsDead = false
-- Contains only name and value of statuses
local PlayerStatus = {}
-- Contain objects handling statuses
local aPlayerStatus = {}

StatusFunctions = {}

Citizen.CreateThread(function()
    -- mandatory wait!
    Wait(0)

    aPlayerStatus = {}
    initStatus(exports.ava_core:getPlayerData().status)
end)

RegisterNetEvent("ava_core:client:playerUpdatedData", function(data)
    for k, v in pairs(data) do
        if k == "status" then
            print("[ava_status] initStatus playerUpdatedData")
            initStatus(v)
        end
    end
end)

RegisterNetEvent("ava_core:client:playerLoaded", function(data)
    aPlayerStatus = {}
    print("[ava_status] initStatus playerLoaded")
    initStatus(data.status)
end)

RegisterNetEvent("ava_core:client:createChar", function()
    print("[ava_status] initStatus createChar")
    aPlayerStatus = {}
    initStatus()
end)

function initStatus(statusArray)
    if type(statusArray) ~= "table" then
        statusArray = {}
    else
        for i = 1, #statusArray do
            local status = statusArray[i]
            if aPlayerStatus[status.name] then
                aPlayerStatus[status.name].value = status.value
            else
                local cfgStatus <const> = AVAConfig.Status[status.name]
                if cfgStatus and cfgStatus.update then
                    aPlayerStatus[status.name] = CreateStatus(status.name, status.value)
                end
            end
        end
    end

    for name, cfgStatus in pairs(AVAConfig.Status) do
        if type(aPlayerStatus[name]) ~= "table" then
            local value = cfgStatus.default or 10000
            table.insert(statusArray, { name = name, value = value })
            aPlayerStatus[name] = CreateStatus(name, value)
        end
    end

    PlayerStatus = statusArray
end

Citizen.CreateThread(function()
    while true do
        Wait(AVAConfig.Interval)

        local playerPed = PlayerPedId()
        local playerHealth = GetEntityHealth(playerPed)
        local newHealth = playerHealth

        for i = 1, #PlayerStatus do
            local status = PlayerStatus[i]
            local aStatus = aPlayerStatus[status.name]

            if aStatus then
                -- #region Update status
                status.value = aStatus.update()
                local percent = aStatus.getPercent()
                TriggerEvent("ava_hud:client:updateStatus", status.name, percent)
                -- #endregion

                -- #region Trigger status events
                if type(StatusFunctions[status.name]) == "function" then
                    newHealth = StatusFunctions[status.name](status.value, percent, playerHealth, newHealth)
                end
                -- #endregion
            end
        end

        if playerHealth ~= newHealth then
            SetEntityHealth(playerPed, newHealth)
        end
    end
end)

local waitingToSave = false
local function saveStatusWithMaxCooldown()
    -- Only enter if we are not waiting to save
    if not waitingToSave then
        -- prevent spamming the server for data
        -- this will do it with at least AVAConfig.SaveMinInterval between each calls
        waitingToSave = true
        Citizen.CreateThread(function()
            Wait(AVAConfig.SaveMinInterval)
            waitingToSave = false
            -- TODO only send updated data to server, maybe set things as state bags?
            TriggerServerEvent("ava_status:server:update", PlayerStatus)
        end)
    end
end

Citizen.CreateThread(function()
    while true do
        Wait(AVAConfig.SaveTimeout)
        saveStatusWithMaxCooldown()
    end
end)
RegisterNetEvent("ava_core:client:selectChar", function()
    TriggerServerEvent("ava_status:server:update", PlayerStatus)
end)

local function getStatusIndex(name)
    for i = 1, #PlayerStatus do
        if PlayerStatus[i].name == name then
            return i
        end
    end
end

RegisterNetEvent("ava_status:client:set", function(name, value)
    local index = getStatusIndex(name)
    if index ~= nil and type(value) == "number" and value >= 0 then
        PlayerStatus[index].value = aPlayerStatus[name].set(value)
        TriggerEvent("ava_hud:client:updateStatus", name, aPlayerStatus[name].getPercent())
        saveStatusWithMaxCooldown()
    end
end)

RegisterNetEvent("ava_status:client:add", function(name, value)
    local index = getStatusIndex(name)
    if index ~= nil and type(value) == "number" then
        PlayerStatus[index].value = aPlayerStatus[name].add(value)
        TriggerEvent("ava_hud:client:updateStatus", name, aPlayerStatus[name].getPercent())
        saveStatusWithMaxCooldown()
    end
end)

RegisterNetEvent("ava_status:client:remove", function(name, value)
    local index = getStatusIndex(name)
    if index ~= nil and type(value) == "number" then
        PlayerStatus[index].value = aPlayerStatus[name].remove(value)
        TriggerEvent("ava_hud:client:updateStatus", name, aPlayerStatus[name].getPercent())
        saveStatusWithMaxCooldown()
    end
end)

--------------------------------------
--------------- Events ---------------
--------------------------------------

AddEventHandler("ava_core:client:playerDeath", function()
    IsDead = true
end)

AddEventHandler("ava_core:client:playerSpawned", function()
    if IsDead then
        -- Add some to values when respawning
        for name, cfgStatus in pairs(AVAConfig.Status) do
            if aPlayerStatus[name] and cfgStatus.onrespawn then
                if cfgStatus.onrespawn.addUnder and aPlayerStatus[name].value < cfgStatus.onrespawn.addUnder then
                    TriggerEvent("ava_status:client:add", name, cfgStatus.onrespawn.add)
                elseif cfgStatus.onrespawn.add then
                    TriggerEvent("ava_status:client:add", name, cfgStatus.onrespawn.add)
                end
                aPlayerStatus[name].checkValue()
            end
        end
    end

    IsDead = false
end)

RegisterNetEvent("ava_status:client:heal", function()
    local playerPed = PlayerPedId()
    SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
    StopLongAnimatedIfNeeded()
    exports.ava_core:ShowNotification(nil, nil, "ava_core_logo", GetString("healed_by_staff"), nil, nil, "ava_core_logo")
end)
