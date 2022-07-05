-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
LastActionTimer = 0
PlayerData = {}
playerIsInAction = false
playerPed = nil

Citizen.CreateThread(function()
    PlayerData = exports.ava_core:getPlayerData()

    TriggerServerEvent("ava_heists:server:data:fetch")
end)

RegisterNetEvent("ava_core:client:playerUpdatedData", function(data)
    for k, v in pairs(data) do
        PlayerData[k] = v
    end
end)

RegisterNetEvent("ava_core:client:playerLoaded", function(data)
    PlayerData = data
end)

RegisterNetEvent("ava_heists:client:data:get", function(heists)
    print(json.encode(heists))
    for heistName, heist in pairs(heists) do
        if heist.Started then
            AVAConfig.Heists[heistName].Started = heist.Started
        end
        if heist.CurrentStage then
            AVAConfig.Heists[heistName].CurrentStage = heist.CurrentStage
        end
        if heist.IsAlarmOn and AVAConfig.Heists[heistName].TriggerAlarm then
            AVAConfig.Heists[heistName].TriggerAlarm()
        end
        if heist.Stages then
            for stageIndex, stage in pairs(heist.Stages) do
                if stage.Stealables then
                    for stealableName, stolenArray in pairs(stage.Stealables) do
                        -- stealable is array of stolen items
                        for trayIndex, _ in pairs(stolenArray) do
                            AVAConfig.Heists[heistName].Stages[stageIndex].Stealables[stealableName].Zones[trayIndex].Stolen = true
                        end
                    end
                end
            end
        end
        -- data[heistName].Stages[stageIndex].Stealables[stealableIndex] = stealable.StolenArray
    end
end)

-- * different alarms name
-- local alarms = {
--     -- {name = "PRISON_ALARMS", p2 = 1}, --* prison alarm
--     -- {name = "AGENCY_HEIST_FIB_TOWER_ALARMS", p2 = 0}, --* can be heard at the bottom of the tower
--     -- {name = "AGENCY_HEIST_FIB_TOWER_ALARMS_UPPER", p2 = 1},
--     -- {name = "AGENCY_HEIST_FIB_TOWER_ALARMS_UPPER_B", p2 = 0},
--     -- {name = "BIG_SCORE_HEIST_VAULT_ALARMS", p2 = 0}, --* vector3(-5.45, -693.59, 16.13) gruppe 6
--     -- {name = "FBI_01_MORGUE_ALARMS", p2 = 1}, --* morgue
--     -- {name = "FIB_05_BIOTECH_LAB_ALARMS", p2 = 0}, --* humane lab
--     -- {name = "JEWEL_STORE_HEIST_ALARMS", p2 = 0}, --* vangelico
--     -- {name = "PALETO_BAY_SCORE_ALARM", p2 = 1}, --* paleto bank
--     -- {name = "PALETO_BAY_SCORE_CHICKEN_FACTORY_ALARM", p2 = 0}, --* chicken factory
--     -- {name = "PORT_OF_LS_HEIST_FORT_ZANCUDO_ALARMS", p2 = 1}, --* fort zancudo
--     -- {name = "PORT_OF_LS_HEIST_SHIP_ALARMS", p2 = 0}, --* port of south los santos
--     -- {name = "PROLOGUE_VAULT_ALARMS", p2 = 0},
-- }
-- Citizen.CreateThread(function()
--     for i = 1, #alarms, 1 do
--         while not PrepareAlarm(alarms[i].name) do
--             Wait(100)
--         end
--         print(alarms[i].name, alarms[i].p2)
--         StartAlarm(alarms[i].name, alarms[i].p2)
--     end
-- end)

-- AddEventHandler("onResourceStop", function(resource)
--     if resource == GetCurrentResourceName() then
--         for i = 1, #alarms, 1 do
--             while not PrepareAlarm(alarms[i].name) do
--                 Wait(100)
--             end
--             StopAlarm(alarms[i].name, true)
--         end
--     end
-- end)

Citizen.CreateThread(function()
    local lastInterior = nil
    while AVAConfig.Debug do
        Wait(100)
        local interior = GetInteriorFromEntity(PlayerPedId())
        if lastInterior ~= interior then
            print(interior)
            lastInterior = interior
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        playerPed = PlayerPedId()

        Wait(5000)
    end
end)

local function HasRequiredJob(jobs)
    if PlayerData.jobs then
        for i = 1, #PlayerData.jobs do
            local jobName <const> = PlayerData.jobs[i].name
            for j = 1, #jobs do
                if jobName == jobs[j] then
                    -- TODO be in service
                    return true
                end
            end
        end
    end
    return false
end

Citizen.CreateThread(function()
    -- mandatory wait!
    Wait(1000)

    while true do
        local waitTime = 500

        local playerInterior = GetInteriorFromEntity(playerPed)
        local actualHeistName = nil

        for k, heist in pairs(AVAConfig.Heists) do
            if heist.Disabled then
            elseif heist.InteriorId and playerInterior == heist.InteriorId then
                actualHeistName = k
                waitTime = 0
            elseif heist.InteriorIds then
                for i = 0, #heist.InteriorIds, 1 do
                    if playerInterior == heist.InteriorIds[i] then
                        actualHeistName = k
                        waitTime = 0
                        break
                    end
                end
            end
        end

        if actualHeistName then
            local playerCoords = GetEntityCoords(playerPed)

            local heist = AVAConfig.Heists[actualHeistName]
            local stage = heist.Stages[heist.CurrentStage]
            if stage.Function then
                stage.Function(playerPed)
            end
            if stage.Stealables then
                for stealableName, stealable in pairs(stage.Stealables) do
                    for zoneIndex, zone in pairs(stealable.Zones) do
                        if not zone.Stolen then
                            local distance = #(playerCoords - zone.Coord)
                            if distance < AVAConfig.DrawDistance then
                                if stealable.Marker then
                                    local coord <const> = zone.MarkerCoord or zone.Coord
                                    DrawMarker(stealable.Marker, coord.x, coord.y, coord.z, 0.0, 0.0, 0.0,
                                        stealable.MarkerRotation or vector3(0.0, 0.0, 0.0), stealable.Size.x or 1.0,
                                        stealable.Size.y or 1.0,
                                        stealable.Size.z or 1.0, stealable.Color.r or 255, stealable.Color.g or 255,
                                        stealable.Color.b or 255, 100,
                                        stealable.BobUpAndDown or false, true, 2, false, false, false, false)
                                end

                                if not playerIsInAction and distance < (stealable.Distance or stealable.Size.x or 1.0) then
                                    if stealable.HelpText ~= nil then
                                        BeginTextCommandDisplayHelp("STRING")
                                        AddTextComponentSubstringPlayerName(stealable.HelpText)
                                        EndTextCommandDisplayHelp(0, 0, 1, -1)
                                    end

                                    if IsControlJustReleased(0, 38) -- E
                                        and (GetGameTimer() - LastActionTimer) > 300 then
                                        LastActionTimer = GetGameTimer()

                                        if stealable.Type and stealable.Type == AVAConfig.StealablesType.Tray then
                                            SmashTray(actualHeistName, heist.CurrentStage, stealableName, zoneIndex)
                                        end
                                    end
                                end
                            end
                        else
                            if stealable.Type then
                                if stealable.Type == AVAConfig.StealablesType.Tray and not playerIsInAction then
                                    local object = GetRayfireMapObject(zone.PropCoord, 1.0, zone.RayFireName)
                                    if GetStateOfRayfireMapObject(object) < 6 then
                                        SetStateOfRayfireMapObject(object, 4)
                                        SetStateOfRayfireMapObject(object, 6)
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if heist.Interactables then
                for interactableName, interactable in pairs(heist.Interactables) do
                    if not interactable.JobNeeded or HasRequiredJob(interactable.JobNeeded) then
                        local distance = #(playerCoords - interactable.Coord)
                        if distance < AVAConfig.DrawDistance then
                            if interactable.Marker then
                                DrawMarker(interactable.Marker, interactable.Coord, 0.0, 0.0, 0.0,
                                    interactable.MarkerRotation or vector3(0.0, 0.0, 0.0),
                                    interactable.Size.x or 1.0, interactable.Size.y or 1.0, interactable.Size.z or 1.0,
                                    interactable.Color.r or 255,
                                    interactable.Color.g or 255, interactable.Color.b or 255, 100,
                                    interactable.BobUpAndDown or false, true, 2, false, false,
                                    false, false)
                            end

                            if not playerIsInAction and distance < (interactable.Distance or interactable.Size.x or 1.0) then
                                if interactable.HelpText ~= nil then
                                    BeginTextCommandDisplayHelp("STRING")
                                    AddTextComponentSubstringPlayerName(interactable.HelpText)
                                    EndTextCommandDisplayHelp(0, 0, 1, -1)
                                end

                                if interactable.Action then
                                    if IsControlJustReleased(0, 38) -- E
                                        and (GetGameTimer() - LastActionTimer) > 300 then
                                        LastActionTimer = GetGameTimer()
                                        interactable.Action()

                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        Wait(waitTime)
    end
end)

RegisterNetEvent("ava_heists:client:actionTriggered", function(heistName, options)
    local heist = AVAConfig.Heists[heistName]
    if not heist or heist.Disabled or not options then
        return
    end

    if options.TriggerHeist then
        heist.Started = true
        if heist.TriggerHeist then
            heist.TriggerHeist()
        end
    end
    if options.Stage ~= nil then
        heist.CurrentStage = options.Stage
    end
    if options.TriggerAlarm then
        if heist.TriggerAlarm then
            heist.TriggerAlarm()
        end
    end
    if options.StopAlarm then
        if heist.StopAlarm then
            heist.StopAlarm()
        end
    end
    -- if options.Steal and options.StageIndex and options.StealableName and options.TrayIndex then
    --     local stage = heist.Stages[options.StageIndex]
    --     if stage then
    --         local stealable = stage.Stealables[options.StealableName]
    --         if stealable then
    --             local tray = stealable.Zones[options.TrayIndex]
    --             if tray then
    --                 tray.Stolen = true
    --             end
    --         end
    --     end
    -- end
    if options.SmashTray and options.StageIndex and options.StealableName and options.TrayIndex then
        local stage = heist.Stages[options.StageIndex]
        if stage then
            local stealable = stage.Stealables[options.StealableName]
            if stealable then
                local tray = stealable.Zones[options.TrayIndex]
                if tray then
                    tray.Stolen = true
                    SmashTrayEvent(heistName, options)
                end
            end
        end
    end
    if options.Reset then
        if heist.Reset() then
            heist.Started = false
            heist.CurrentStage = 0
            heist.Reset()
        end
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        for k, heist in pairs(AVAConfig.Heists) do
            if heist.Reset then
                heist.Reset()
            end
            if heist.ClientReset then
                heist.ClientReset()
            end
        end
        if playerIsInAction then
            ClearPedTasks(PlayerPedId())
        end
    end
end)
