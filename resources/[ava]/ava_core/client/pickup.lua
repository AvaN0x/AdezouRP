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
Citizen.CreateThread(function()
    while true do
        Wait(5000)
        local newPickups = {}
        local count = 0
        for _, v in ipairs(GetGamePool("CObject")) do
            local object = GetObjectIndexFromEntityIndex(v)
            local entity = Entity(object)
            if entity.state.pickup then
                local propCoords = GetEntityCoords(object)
                local distance = #(AVA.Player.playerCoords - propCoords)
                if distance < 15.0 then
                    count = count + 1
                    local _, max = GetModelDimensions(GetEntityModel(object))

                    newPickups[count] = {
                        id = entity.state.id,
                        coords = vector3(propCoords.x, propCoords.y, propCoords.z + max.z + 0.1),
                        label = entity.state.label,
                        object = object,
                    }
                end
            end
        end
        pickups = newPickups
    end
end)

local closestPickupIndex = nil
Citizen.CreateThread(function()
    local r<const>, g<const>, b<const> = 115, 173, 93
    local closestR<const>, closestG<const>, closestB<const> = 255, 133, 85
    while true do
        local wait = 500

        local newClosestPickupIndex = nil
        local closestDistance = nil
        for i = 1, #pickups do
            local pickup<const> = pickups[i]
            if pickup and not pickup.hidden then
                if not DoesEntityExist(pickup.object) then
                    pickup.hidden = true
                end
                local coords<const> = pickup.coords
                local distance<const> = #(AVA.Player.playerCoords - coords)
                if distance < 3.0 then
                    wait = 0
                    -- If is the actual closest
                    if i == closestPickupIndex then
                        AVA.Utils.DrawText3D(coords.x, coords.y, coords.z + 0.2, "[E] " .. pickup.label, nil, closestR, closestG, closestB)
                        DrawMarker(2, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.10, 0.10, 0.10, closestR, closestG, closestB, 155, false,
                            false, 2, true, false, false, false)
                    else
                        AVA.Utils.DrawText3D(coords.x, coords.y, coords.z + 0.2, pickup.label, nil, r, g, b, 196)
                        DrawMarker(2, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.10, 0.10, 0.10, r, g, b, 155, false, false, 2, true,
                            false, false, false)
                    end

                    -- If is valid to be the next closest
                    if distance < 1.2 and (not closestDistance or distance < closestDistance) then
                        closestDistance = distance
                        newClosestPickupIndex = i
                    end
                end
            end
        end
        if closestPickupIndex and IsControlJustPressed(0, 38) and (GetGameTimer() - TimeLastAction) > 500 then -- E
            TimeLastAction = GetGameTimer()
            if pickups[closestPickupIndex] then
                Citizen.CreateThread(function()
                    RequestAnimDict("pickup_object")
                    while not HasAnimDictLoaded("pickup_object") do
                        Wait(0)
                    end
                    TaskPlayAnim(AVA.Player.playerPed, "pickup_object", "pickup_low", 8.0, 1.0, 500, 16, 0, 0, 0, 0)
                    RemoveAnimDict("pickup_object")

                    Wait(500)
                    if pickups[closestPickupIndex] and AVA.TriggerServerCallback("ava_core:server:pickup", pickups[closestPickupIndex].id) then
                        PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                    end

                    -- mandatory wait! (might be less than 200 but it's not an issue)
                    Wait(200)
                    if pickups[closestPickupIndex] then
                        if DoesEntityExist(pickups[closestPickupIndex].object) then
                            pickups[closestPickupIndex].label = Entity(pickups[closestPickupIndex].object).state.label
                        else
                            pickups[closestPickupIndex].hidden = true
                        end
                    end
                end)
            end
        end

        closestPickupIndex = newClosestPickupIndex
        Wait(wait)
    end
end)
