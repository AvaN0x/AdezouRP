-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local isSettled = false
local IsDead = false
local lastCoords = nil

AddEventHandler("ava_core:client:playerDeath", function()
    if isSettled then
        StandUp()
    end
    IsDead = true
end)
AddEventHandler("ava_deaths:client:playerRevived", function(spawn)
    IsDead = false
end)

local function LoadInteracts()
    for model, data in pairs(AVAConfig.Props) do
        if data.offset then
            exports.ava_interact:addModel(model, {
                label = GetString("sit_down"),
                offset = data.offset.xyz,
                event = "ava_chairs:client:sitDown",
                control = "F",
                canInteract = function(entity)
                    return not isSettled
                end,
                distance = data.isBed and 2.0
            })
        elseif data.offsets then
            for i = 1, #data.offsets do
                exports.ava_interact:addModel(model, {
                    label = GetString("sit_down"),
                    offset = data.offsets[i].xyz,
                    metadata = i,
                    event = "ava_chairs:client:sitDown",
                    control = "F",
                    canInteract = function(entity)
                        return not isSettled
                    end
                })
            end
        end
    end
end

Citizen.CreateThread(function()
    LoadInteracts()
end)
AddEventHandler("onResourceStart", function(resource)
    if resource == "ava_interact" then
        LoadInteracts()
    end
end)

local function StandUp()
    TriggerServerEvent("ava_chairs:server:standUp")
    local playerPed = PlayerPedId()

    ClearPedTasksImmediately(playerPed)
    FreezeEntityPosition(playerPed, false)
    if lastCoords then
        SetEntityCoords(playerPed, lastCoords.x, lastCoords.y, lastCoords.z - 0.98)
    end
    lastCoords = nil
    isSettled = false
end

local function SettleDown(playerPed, coords, anim)
    if isSettled then return end

    isSettled = true
    if anim.dict ~= nil then
        SetEntityCoords(playerPed, coords.x, coords.y, coords.z)
        SetEntityHeading(playerPed, coords.w or 0.0)

        exports.ava_core:RequestAnimDict(anim.dict)
        TaskPlayAnim(playerPed, anim.dict, anim.anim, 8.0, 1.0, -1, 1, 0, 0, 0, 0)
        RemoveAnimDict(anim.dict)

        FreezeEntityPosition(playerPed, true)
    else
        TaskStartScenarioAtPosition(playerPed, anim.scenario, coords.x, coords.y, coords.z, coords.w, 0, true, true)
    end

    Citizen.CreateThread(function()
        while isSettled do
            Wait(0)
            BeginTextCommandDisplayHelp("STRING")
            AddTextComponentSubstringPlayerName(GetString("stand_up"))
            EndTextCommandDisplayHelp(0, false, true, -1)

            DisableControlAction(0, 23, true) -- INPUT_ENTER
            if IsDisabledControlJustPressed(0, 23) then -- INPUT_ENTER
                StandUp()
            end
        end
    end)
end

AddEventHandler("ava_chairs:client:sitDown", function(entity, data, model)
    if not IsDead and not isSettled then
        if AVAConfig.Props[model] then
            local propData <const> = AVAConfig.Props[model]
            local offset = propData.offset
            if not offset then
                offset = propData.offsets[data.metadata]
                if not offset then return end
            end

            local offsetCoords = GetOffsetFromEntityInWorldCoords(entity, offset.x, offset.y,
                offset.z)
            local coords = vector4(offsetCoords.x, offsetCoords.y, offsetCoords.z,
                GetEntityHeading(entity) + (offset.w or 0.0))

            if not
                exports.ava_core:TriggerServerCallback("ava_chairs:server:settle", coords.x, coords.y, coords.z,
                    data.metadata) then
                return
            end


            local playerPed = PlayerPedId()
            lastCoords = GetEntityCoords(playerPed)
            if propData.isChair then
                SettleDown(playerPed, coords, AVAConfig.SitAnims[IsPedMale(playerPed) and "Male" or "Female"])
            elseif propData.isBed then
                SettleDown(playerPed, coords, AVAConfig.LayAnims[IsPedMale(playerPed) and "Male" or "Female"])
            end
        end
    end
end)


AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() and isSettled then
        StandUp()
    end
end)
