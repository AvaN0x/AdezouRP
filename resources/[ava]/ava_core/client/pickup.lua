-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local TimeLastAction = 0
---Generate coords for pickup in front of player
---@return vector3
AVA.GeneratePickupCoords = function()
    -- TODO case if ped is in vehicle
    local playerPed = PlayerPedId()
    local min = GetModelDimensions(GetEntityModel(playerPed))
    local propCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 0.5, -0.70)

    local foundGround, zPos = GetGroundZFor_3dCoord(propCoords.x, propCoords.y, propCoords.z)
    if foundGround then
        propCoords = vector3(propCoords.x, propCoords.y, zPos)
    end
    return propCoords
end
exports("GeneratePickupCoords", AVA.GeneratePickupCoords)

local pickups = {}
local closestPickupIndex = nil
Citizen.CreateThread(function()
    while true do
        Wait(1000)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        local newPickups = {}
        local newClosestPickupIndex = nil
        local closestDistance = nil
        local count = 0
        for _, v in ipairs(GetGamePool("CObject")) do
            local object = GetObjectIndexFromEntityIndex(v)
            if Entity(object).state.pickup then
                local propCoords = GetEntityCoords(object)
                local distance = #(playerCoords - propCoords)
                if distance < 5.0 then
                    count = count + 1
                    local _, max = GetModelDimensions(GetEntityModel(object))

                    newPickups[count] = {
                        id = Entity(object).state.id,
                        coords = vector3(propCoords.x, propCoords.y, propCoords.z + max.z + 0.1),
                        label = Entity(object).state.label,
                    }
                    if distance < 2.0 and (not closestDistance or distance < closestDistance) then
                        closestDistance = distance
                        newClosestPickupIndex = count
                    end
                end

            end
        end
        pickups = newPickups
        closestPickupIndex = newClosestPickupIndex
    end
end)

Citizen.CreateThread(function()
    local r<const>, g<const>, b<const> = 115, 173, 93
    local closestR<const>, closestG<const>, closestB<const> = 255, 133, 85
    while true do
        local wait = 500
        for i = 1, #pickups do
            wait = 0
            local pickup<const> = pickups[i]
            local isClosest<const> = i == closestPickupIndex
            local coords<const> = pickup.coords
            if isClosest then
                AVA.Utils.DrawText3D(coords.x, coords.y, coords.z + 0.2, "[E] " .. pickup.label, nil, closestR, closestG, closestB)
                DrawMarker(2, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.10, 0.10, 0.10, closestR, closestG, closestB, 155, false, false,
                    2, true, false, false, false)
            else
                AVA.Utils.DrawText3D(coords.x, coords.y, coords.z + 0.2, pickup.label, nil, r, g, b)
                DrawMarker(2, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.10, 0.10, 0.10, r, g, b, 155, false, false, 2, true, false, false,
                    false)
            end
        end
        if closestPickupIndex and IsControlJustPressed(0, 38) and (GetGameTimer() - TimeLastAction) > 500 then -- E
            TimeLastAction = GetGameTimer()
            local pickup = pickups[closestPickupIndex]
            Citizen.CreateThread(function()
                RequestAnimDict("pickup_object")
                while not HasAnimDictLoaded("pickup_object") do
                    Wait(0)
                end

                TaskPlayAnim(PlayerPedId(), "pickup_object", "pickup_low", 8.0, 1.0, 500, 16, 0, 0, 0, 0)
                Wait(500)
                if AVA.TriggerServerCallback("ava_core:server:pickup", pickup.id) then
                    PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                end

                RemoveAnimDict("pickup_object")
            end)
        end
        Wait(wait)
    end
end)
