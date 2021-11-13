-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
IsDead = false
-- Contains only name and value of statuses
local PlayerStatus = nil
-- Contain objects handling statuses
local aPlayerStatus = {}

StatusFunctions = {}

Citizen.CreateThread(function()
    PlayerStatus = exports.ava_core:getPlayerData().status

    initStatus(PlayerStatus)
end)

RegisterNetEvent("ava_core:client:playerUpdatedData", function(data)
    for k, v in pairs(data) do
        if k == "status" then
            initStatus(v)
        end
    end
end)

RegisterNetEvent("ava_core:client:playerLoaded", function(data)
    initStatus(data.status)
end)

function initStatus(statusArray)
    for i = 1, #statusArray do
        local status = statusArray[i]
        if aPlayerStatus[status.name] then
            aPlayerStatus[status.name].value = status.value
        else
            local cfgStatus<const> = AVAConfig.Status[status.name]
            if cfgStatus and cfgStatus.update then
                aPlayerStatus[status.name] = CreateStatus(status.name, status.value)
            end
        end
    end

    for name, cfgStatus in pairs(AVAConfig.Status) do
        if not aPlayerStatus[name] then
            local value = cfgStatus.default or 10000
            statusArray[#statusArray + 1] = {name = name, value = value}
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

            -- #region Update status
            local aStatus = aPlayerStatus[status.name]
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

        if playerHealth ~= newHealth then
            SetEntityHealth(playerPed, newHealth)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(AVAConfig.SaveTimeout)
        TriggerServerEvent("ava_status:server:update", PlayerStatus)
    end
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
    if index ~= nil then
        PlayerStatus[index].value = aPlayerStatus[name].set(value)
    end
end)

RegisterNetEvent("ava_status:client:add", function(name, value)
    local index = getStatusIndex(name)
    if index ~= nil then
        PlayerStatus[index].value = aPlayerStatus[name].add(value)
    end
end)

RegisterNetEvent("ava_status:client:remove", function(name, value)
    local index = getStatusIndex(name)
    if index ~= nil then
        PlayerStatus[index].value = aPlayerStatus[name].remove(value)
    end
end)

--------------------------------------
--------------- Events ---------------
--------------------------------------

AddEventHandler("ava_core:client:playerDeath", function()
    IsDead = true
end)

AddEventHandler("playerSpawned", function()
    if IsDead then
        -- Add some to values when respawning
        for name, cfgStatus in pairs(AVAConfig.Status) do
            if cfgStatus.onrespawn then
                if cfgStatus.onrespawn.under and aPlayerStatus[name].value < cfgStatus.onrespawn.under then
                    TriggerEvent("ava_status:client:add", name, cfgStatus.onrespawn.add)
                end
            end
        end
    end

    IsDead = false
end)

RegisterNetEvent("ava_status:client:heal", function()
    local playerPed = PlayerPedId()
    SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
    exports.ava_core:ShowNotification(nil, nil, "ava_core_logo", GetString("healed_by_staff"), nil, nil, "ava_core_logo")
end)

-----------------------------------------------
--------------- Long animations ---------------
-----------------------------------------------

IsAnimated = false
IsLongAnimated = false

function SetLongAnimated(prop)
    Citizen.CreateThread(function()
        IsLongAnimated = true
        local instructionalButtons = exports.ava_core:GetScaleformInstructionalButtons({{control = "~INPUT_VEH_DUCK~", label = GetString("cancel_animation")}})

        while IsLongAnimated do
            Citizen.Wait(0)
            DrawScaleformMovieFullscreen(instructionalButtons, 255, 255, 255, 255)
            if IsControlJustPressed(1, 73) or IsControlJustPressed(1, 24) or IsControlJustPressed(1, 25) then -- X, RMB or LMB
                IsLongAnimated = false
            end
        end
        ClearPedSecondaryTask(PlayerPedId())

        if prop then
            exports.ava_core:DeleteObject(prop)
        end
    end)
end

function StopLongAnimatedIfNeeded()
    if IsLongAnimated then
        IsLongAnimated = false
        Wait(50)
    end
end
