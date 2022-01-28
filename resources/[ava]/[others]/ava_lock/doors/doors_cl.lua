-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
Citizen.CreateThread(function()
    local doorsInfo = exports.ava_core:TriggerServerCallback("ava_doors:getDoorsInfo")
    for doorID, state in pairs(doorsInfo) do
        ConfigDoors.DoorList[doorID].locked = state
    end
end)

AddEventHandler("ava_lock:client:reloadAuthorizations", function()
    SetAllDoorsAuthorized()
end)

Citizen.CreateThread(function()
    for k, doorID in ipairs(ConfigDoors.DoorList) do
        if not doorID.distance then
            doorID.distance = ConfigDoors.DefaultDistance
        end
        doorID.checkDistance = doorID.distance * 2
        if doorID.checkDistance > ConfigDoors.ObjectDistance then
            doorID.checkDistance = ConfigDoors.ObjectDistance
        end
        if not doorID.size then
            doorID.size = ConfigDoors.DefaultSize
        end
    end
end)

function DrawEntityBox(entity, r, g, b)
    local coords = GetEntityCoords(entity)
    DrawText3D(coords.x, coords.y, coords.z - 0.1, string.format("%.2f", GetEntityHeading(entity)) or "", 0.3)

    local min, max = GetModelDimensions(GetEntityModel(entity))

    local pad = 0.001;

    -- Bottom
    local bottom1 = GetOffsetFromEntityInWorldCoords(entity, min.x - pad, min.y - pad, min.z - pad)
    local bottom2 = GetOffsetFromEntityInWorldCoords(entity, max.x + pad, min.y - pad, min.z - pad)
    local bottom3 = GetOffsetFromEntityInWorldCoords(entity, max.x + pad, max.y + pad, min.z - pad)
    local bottom4 = GetOffsetFromEntityInWorldCoords(entity, min.x - pad, max.y + pad, min.z - pad)

    -- Top
    local top1 = GetOffsetFromEntityInWorldCoords(entity, min.x - pad, min.y - pad, max.z + pad)
    local top2 = GetOffsetFromEntityInWorldCoords(entity, max.x + pad, min.y - pad, max.z + pad)
    local top3 = GetOffsetFromEntityInWorldCoords(entity, max.x + pad, max.y + pad, max.z + pad)
    local top4 = GetOffsetFromEntityInWorldCoords(entity, min.x - pad, max.y + pad, max.z + pad)

    -- bottom
    DrawLine(bottom1, bottom2, r, g, b, 255)
    DrawLine(bottom1, bottom4, r, g, b, 255)
    DrawLine(bottom2, bottom3, r, g, b, 255)
    DrawLine(bottom3, bottom4, r, g, b, 255)

    -- top
    DrawLine(top1, top2, 255, r, g, b, 255)
    DrawLine(top1, top4, 255, r, g, b, 255)
    DrawLine(top2, top3, 255, r, g, b, 255)
    DrawLine(top3, top4, 255, r, g, b, 255)

    -- bottom to top
    DrawLine(bottom1, top1, r, g, b, 255)
    DrawLine(bottom2, top2, r, g, b, 255)
    DrawLine(bottom3, top3, r, g, b, 255)
    DrawLine(bottom4, top4, r, g, b, 255)

    -- top face
    DrawPoly(top1, top2, top3, r, g, b, 128)
    DrawPoly(top4, top1, top3, r, g, b, 128)

    -- bottom face
    DrawPoly(bottom2, bottom1, bottom3, r, g, b, 128)
    DrawPoly(bottom1, bottom4, bottom3, r, g, b, 128)

    -- back face
    DrawPoly(top2, top1, bottom1, r, g, b, 128)
    DrawPoly(bottom1, bottom2, top2, r, g, b, 128)

    -- front face
    DrawPoly(top4, top3, bottom4, r, g, b, 128)
    DrawPoly(bottom3, bottom4, top3, r, g, b, 128)

    -- right face
    DrawPoly(top3, top2, bottom2, r, g, b, 128)
    DrawPoly(bottom2, bottom3, top3, r, g, b, 128)

    -- left face
    DrawPoly(top1, top4, bottom1, r, g, b, 128)
    DrawPoly(bottom4, bottom1, top4, r, g, b, 128)
end

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while ConfigDoors.Debug do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())

        for k, doorID in ipairs(ConfigDoors.DoorList) do
            local distance = #(playerCoords - (doorID.textCoords or playerCoords))

            if distance < doorID.checkDistance then
                if doorID.doors then
                    for _, v in ipairs(doorID.doors) do
                        if not v.object or not DoesEntityExist(v.object) then
                            v.object = GetClosestObjectOfType(v.objCoords, 1.0, v.objHash, false, false, false)
                        end
                        if distance < doorID.distance then
                            DrawEntityBox(v.object, 255, 255, 255)
                        else
                            DrawEntityBox(v.object, 128, 128, 128)
                        end
                    end
                else
                    if not doorID.object or not DoesEntityExist(doorID.object) then
                        doorID.object = GetClosestObjectOfType(doorID.objCoords, 1.0, doorID.objHash, false, false, false)
                    end
                    if distance < doorID.distance then
                        DrawEntityBox(doorID.object, 255, 255, 255)
                    else
                        DrawEntityBox(doorID.object, 128, 128, 128)
                    end
                end
                if not doorID.textCoords then
                    local min, max = GetModelDimensions(GetEntityModel(doorID.object or doorID.doors[1].object))
                    doorID.textCoords = GetOffsetFromEntityInWorldCoords(doorID.object or doorID.doors[1].object, min.x, 0.0, 0.0)
                    print(k .. " new text coords : " .. doorID.textCoords)
                end

                SetTextColour(255, 255, 255, 255)
                SetTextFont(0)
                SetTextScale(0.34, 0.34)
                SetTextWrap(0.0, 1.0)
                SetTextOutline()
                SetTextEntry("STRING")
                AddTextComponentString("X\t" .. string.format("%.2f", doorID.textCoords.x) .. "\nY\t" .. string.format("%.2f", doorID.textCoords.y) .. "\nZ\t"
                                           .. string.format("%.2f", doorID.textCoords.z))
                DrawText(0.8, 0.88)

                if IsControlJustReleased(0, ConfigDoors.DebugKey) then
                    local offset = tonumber(exports.avan0x:KeyboardInput(_("enter_x_offset"), 0, 10))
                    if type(offset) == "number" or type(offset) == "float" then
                        local min, max = GetModelDimensions(GetEntityModel(doorID.object or doorID.doors[1].object))
                        doorID.textCoords = GetOffsetFromEntityInWorldCoords(doorID.object or doorID.doors[1].object, min.x + offset, 0.0, 0.0)
                        exports.ava_hud:copyToClipboard("vector3(" .. string.format("%.2f", doorID.textCoords.x) .. ", "
                                                            .. string.format("%.2f", doorID.textCoords.y) .. ", " .. string.format("%.2f", doorID.textCoords.z)
                                                            .. ")")
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
        local waitTime = 100
        local playerCoords = GetEntityCoords(PlayerPedId())

        for k, doorID in ipairs(ConfigDoors.DoorList) do
            if doorID.textCoords then
                local distance = #(playerCoords - doorID.textCoords)

                if distance < doorID.checkDistance then
                    waitTime = 0
                    if doorID.doors then
                        for _, v in ipairs(doorID.doors) do
                            if not v.object or not DoesEntityExist(v.object) then
                                v.object = GetClosestObjectOfType(v.objCoords, 1.0, v.objHash, false, false, false)
                            end
                            FreezeEntityPosition(v.object, doorID.locked)

                            if doorID.locked and v.objYaw and GetEntityRotation(v.object).z ~= v.objYaw then
                                SetEntityRotation(v.object, 0.0, 0.0, v.objYaw, 2, true)
                            elseif not doorID.locked and v.objOpenYaw and GetEntityRotation(v.object).z ~= v.objOpenYaw then
                                FreezeEntityPosition(v.object, not doorID.locked)
                                SetEntityRotation(v.object, 0.0, 0.0, v.objYaw, 2, true)
                            end
                        end
                    else
                        if not doorID.object or not DoesEntityExist(doorID.object) then
                            doorID.object = GetClosestObjectOfType(doorID.objCoords, 1.0, doorID.objHash, false, false, false)
                        end
                        FreezeEntityPosition(doorID.object, doorID.locked)

                        if doorID.locked and doorID.objYaw and GetEntityRotation(doorID.object).z ~= doorID.objYaw then
                            SetEntityRotation(doorID.object, 0.0, 0.0, doorID.objYaw, 2, true)
                        elseif not doorID.locked and doorID.objOpenYaw and GetEntityRotation(doorID.object).z ~= doorID.objOpenYaw then
                            FreezeEntityPosition(doorID.object, not doorID.locked)
                            SetEntityRotation(doorID.object, 0.0, 0.0, doorID.objOpenYaw, 2, true)
                        end
                    end

                    if distance < doorID.distance then
                        if doorID.authorized then
                            local displayText = GetString("doors_press_button", doorID.locked and GetString("doors_locked") or GetString("doors_unlocked"))
                            DrawText3D(doorID.textCoords.x, doorID.textCoords.y, doorID.textCoords.z, displayText, doorID.size)
                            if IsControlJustReleased(0, 38) then
                                doorID.locked = not doorID.locked
                                TriggerEvent("ava_lock:client:dooranim")
                                TriggerServerEvent("ava_doors:updateState", k, doorID.locked)
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(waitTime)
    end
end)

function SetAllDoorsAuthorized()
    if ConfigDoors.Debug then
        for k, doorID in ipairs(ConfigDoors.DoorList) do
            doorID.authorized = true
        end
    else
        for k, doorID in ipairs(ConfigDoors.DoorList) do
            doorID.authorized = IsDoorAuthorized(doorID)
        end
    end
end

function IsDoorAuthorized(doorID)
    if not PlayerData or not PlayerData.jobs then
        return false
    end
    local playerJobs = PlayerData.jobs

    if doorID.authorizedJobs then
        for _, jobName in pairs(doorID.authorizedJobs) do
            if TableHasCondition(playerJobs, function(i, job)
                return job.name == jobName
            end) then
                return true
            end
        end
    end

    return false
end

-- Set state for a door
RegisterNetEvent("ava_doors:setState")
AddEventHandler("ava_doors:setState", function(doorID, state)
    ConfigDoors.DoorList[doorID].locked = state
end)

-- LOCKPICKING DOOR
function FindClosestDoor()
    local playerCoords = GetEntityCoords(PlayerPedId())
    for k, doorID in ipairs(ConfigDoors.DoorList) do
        local distance = #(playerCoords - doorID.textCoords)

        if distance < doorID.distance then
            local isAuthorized = IsAuthorized(doorID)
            if doorID.locked and not isAuthorized then
                return {name = k, door = doorID}
            end
        end
    end
    return nil
end

RegisterNetEvent("ava_items:client:useLockpick", function()
    local closestDoor = FindClosestDoor()
    if not closestDoor then
        return
    end

    local playerPed = PlayerPedId()
    TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
    local minigameSuccess<const> = exports.ava_lockpicking:StartMinigame()
    ClearPedTasksImmediately(playerPed)

    if minigameSuccess then
        closestDoor.door.locked = not closestDoor.door.locked
        TriggerServerEvent("ava_doors:updateState", closestDoor.name, closestDoor.door.locked)
    end
end)
