-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
Citizen.CreateThread(function()
    -- Update the teleporters list
    local teleportersInfo = exports.ava_core:TriggerServerCallback("ava_doors:getTeleportersInfo")
    for tpID, state in pairs(teleportersInfo) do
        ConfigTeleports.TeleportersList[tpID].locked = state
    end
end)

AddEventHandler("ava_lock:client:reloadAuthorizations", function()
    SetAllTeleportersAuthorized()
end)

Citizen.CreateThread(function()
    for k, tpID in ipairs(ConfigTeleports.TeleportersList) do
        for k2, tpID2 in ipairs({ tpID.tpEnter, tpID.tpExit }) do
            if not tpID2.distance then
                tpID2.distance = ConfigTeleports.DrawDistance
            end
            if not tpID2.size then
                tpID2.size = ConfigTeleports.DefaultSize
            end
            if not tpID2.color then
                tpID2.color = ConfigTeleports.DefaultColor
            end
        end
    end
end)

Citizen.CreateThread(function()
    Wait(1000)
    while true do
        local waitTime = 500
        local playerCoords = GetEntityCoords(PlayerPedId())
        for k, tpID in ipairs(ConfigTeleports.TeleportersList) do
            for k2, tpID2 in ipairs({ { from = tpID.tpEnter, to = tpID.tpExit },
                { from = tpID.tpExit, to = tpID.tpEnter } }) do
                local distance = #(playerCoords - tpID2.from.pos)

                if distance < tpID2.from.distance then
                    waitTime = 0
                    if not tpID2.from.noMarker then
                        DrawMarker(27, tpID2.from.pos.x, tpID2.from.pos.y, tpID2.from.pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0,
                            tpID2.from.size.x, tpID2.from.size.y,
                            tpID2.from.size.z, tpID2.from.color.r, tpID2.from.color.g, tpID2.from.color.b, 100, false,
                            true, 2, false, false, false, false)
                    end

                    if distance < tpID2.from.size.x then
                        local helpText = GetString("teleports_unlocked")
                        local label = "~g~"
                        if tpID.locked then
                            helpText = GetString("teleports_locked")
                            label = "~r~"
                        end
                        if tpID.authorized then
                            helpText = GetString("teleports_press_button", helpText)
                        end

                        DrawText3D(tpID2.from.pos.x, tpID2.from.pos.y, tpID2.from.pos.z + 0.2, label .. tpID2.from.label
                            , 0.40) -- draw label
                        ShowHelpNotification(helpText)

                        if IsControlJustReleased(0, 38) then -- E
                            if not tpID.locked then
                                Teleport(tpID2.to.pos, tpID.allowVehicles, tpID2.to.heading)
                            end
                        elseif IsControlJustReleased(0, 73) then -- X
                            if tpID.authorized then
                                tpID.locked = not tpID.locked
                                TriggerEvent("ava_lock:client:dooranim")
                                TriggerServerEvent("ava_teleports:updateState", k, tpID.locked) -- Broadcast new state of the door to everyone
                            end
                        end
                    end
                end
            end
        end
        Wait(waitTime)
    end
end)

function SetAllTeleportersAuthorized()
    for k, tpID in ipairs(ConfigTeleports.TeleportersList) do
        tpID.authorized = IsAuthorized(tpID)
    end
end

function IsAuthorized(tpID)
    if not PlayerData or not PlayerData.jobs then
        return false
    end
    local playerJobs = PlayerData.jobs

    if tpID.authorizedJobs then
        for _, jobName in pairs(tpID.authorizedJobs) do
            if table.has(playerJobs, function(i, job)
                return job.name == jobName
            end) then
                return true
            end
        end
    end

    return false
end

-- Set state for a teleporter
RegisterNetEvent("ava_teleports:setState")
AddEventHandler("ava_teleports:setState", function(tpID, state)
    ConfigTeleports.TeleportersList[tpID].locked = state
end)

function Teleport(coords, allowVehicles, heading)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle > 0 and not allowVehicles then
        exports.ava_core:ShowNotification(GetString("teleports_can_t_in_vehicles"))
        return
    end

    RequestCollisionAtCoord(coords.x, coords.y, coords.z)

    DoScreenFadeOut(100)
    Wait(250)
    FreezeEntityPosition(playerPed, true)
    if vehicle > 0 then
        FreezeEntityPosition(vehicle, true)
        SetPedCoordsKeepVehicle(playerPed, coords.x, coords.y, coords.z)
    else
        SetEntityCoords(playerPed, coords.x, coords.y, coords.z)
    end

    if heading then
        SetEntityHeading(playerPed, heading)
    end

    Wait(1000)
    if vehicle > 0 then
        FreezeEntityPosition(vehicle, false)
    end
    FreezeEntityPosition(playerPed, false)
    DoScreenFadeIn(100)
end

-- LOCKPICKING TELEPORT
function FindClosestTeleport()
    local playerCoords = GetEntityCoords(PlayerPedId())
    for k, tpID in ipairs(ConfigTeleports.TeleportersList) do
        for k2, tpID2 in ipairs({ tpID.tpEnter, tpID.tpExit }) do
            local distance = #(playerCoords - tpID2.pos)
            if distance < tpID2.size.x then
                if tpID.locked and not tpID.authorized then
                    return { name = k, teleport = tpID }
                end
            end
        end
    end
    return nil
end

RegisterNetEvent("ava_items:client:useLockpick", function()
    local closestTeleport = FindClosestTeleport()
    if not closestTeleport then
        return
    end

    local playerPed = PlayerPedId()
    TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
    local minigameSuccess <const> = exports.ava_lockpicking:StartMinigame()
    ClearPedTasksImmediately(playerPed)

    if minigameSuccess then
        closestTeleport.teleport.locked = not closestTeleport.teleport.locked
        TriggerServerEvent("ava_teleports:updateState", closestTeleport.name, closestTeleport.teleport.locked)
    end
end)
