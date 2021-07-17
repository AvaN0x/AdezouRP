-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX = nil
local GUI = {
    Time = 0
}
PlayerData = {}
playerIsInAction = false


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil or ESX.GetPlayerData().job2 == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()

    TriggerServerEvent("esx_ava_heists:data:fetch")
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	PlayerData.job2 = job2
end)

RegisterNetEvent('esx_ava_heists:data:get')
AddEventHandler('esx_ava_heists:data:get', function(heists)
    print(json.encode(heists))
	for heistName, heist in pairs(heists) do
        if heist.Started then
            Config.Heists[heistName].Started = heist.Started
        end
        if heist.CurrentStage then
            Config.Heists[heistName].CurrentStage = heist.CurrentStage
        end
        if heist.IsAlarmOn and Config.Heists[heistName].TriggerAlarm then
            Config.Heists[heistName].TriggerAlarm()
        end
        if heist.Stages then
            for stageIndex, stage in pairs(heist.Stages) do
                if stage.Stealables then
                    for stealableName, stolenArray in pairs(stage.Stealables) do
                        -- stealable is array of stolen items
                        for trayIndex, _ in pairs(stolenArray) do
                            Config.Heists[heistName].Stages[stageIndex].Stealables[stealableName].Zones[trayIndex].Stolen = true
                        end
                    end
                end
            end
        end
        -- data[heistName].Stages[stageIndex].Stealables[stealableIndex] = stealable.StolenArray
    end
end)


--* different alarms name
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
--             Citizen.Wait(100)
--         end
--         print(alarms[i].name, alarms[i].p2)
--         StartAlarm(alarms[i].name, alarms[i].p2)
--     end
-- end)

-- AddEventHandler("onResourceStop", function(resource)
--     if resource == GetCurrentResourceName() then
--         for i = 1, #alarms, 1 do
--             while not PrepareAlarm(alarms[i].name) do
--                 Citizen.Wait(100)
--             end
--             StopAlarm(alarms[i].name, true)
--         end
--     end
-- end)





-- Citizen.CreateThread(function()
--     local lastInterior = nil
--     while Config.Debug do
--         Citizen.Wait(100)
--         local interior = GetInteriorFromEntity(PlayerPedId())
--         if lastInterior ~= interior then
--             print(interior)
--             lastInterior = interior
--         end
--     end
-- end)


local playerPed = nil

Citizen.CreateThread(function()
	while true do
		playerPed = PlayerPedId()

		Citizen.Wait(5000)
	end
end)


Citizen.CreateThread(function()
	while true do
		local waitTime = 500
        
		local playerInterior = GetInteriorFromEntity(playerPed)
        local actualHeistName = nil

		for k, heist in pairs(Config.Heists) do
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

            local heist = Config.Heists[actualHeistName]
            local stage = heist.Stages[heist.CurrentStage]
            if stage.Function then
                stage.Function(playerPed)
            end
            if stage.Stealables then
                for stealableName, stealable in pairs(stage.Stealables) do
                    for zoneIndex, zone in pairs(stealable.Zones) do
                        if not zone.Stolen then
                            local distance = #(playerCoords - zone.Coord)
                            if distance < Config.DrawDistance then
                                if stealable.Marker then
                                    DrawMarker(stealable.Marker, zone.MarkerCoord or zone.Coord, 0.0, 0.0, 0.0, stealable.MarkerRotation or vector3(0.0, 0.0, 0.0), stealable.Size.x or 1.0, stealable.Size.y or 1.0, stealable.Size.z or 1.0, stealable.Color.r or 255, stealable.Color.g or 255, stealable.Color.b or 255, 100, stealable.BobUpAndDown or false, true, 2, false, false, false, false)
                                end
                                
                                if not playerIsInAction and distance < (stealable.Distance or stealable.Size.x or 1.0) then
                                    if stealable.HelpText ~= nil then
                                        SetTextComponentFormat('STRING')
                                        AddTextComponentString(stealable.HelpText)
                                        DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                                    end
                                    
                                    if IsControlJustReleased(0, 38) -- E
                                        and (GetGameTimer() - GUI.Time) > 300
                                    then
                                        GUI.Time = GetGameTimer()
                                        
                                        if stealable.Type and stealable.Type == Config.StealablesType.Tray then
                                            SmashTray(actualHeistName, heist.CurrentStage, stealableName, zoneIndex)
                                        end
                                    end
                        
                                end
                            end
                        end
                    end

                end
            end
        end

		Citizen.Wait(waitTime)
	end
end)


RegisterNetEvent('esx_ava_heists:clientCallback')
AddEventHandler("esx_ava_heists:clientCallback", function(heistName, options)
    local heist = Config.Heists[heistName]
    if not heist or heist.Disabled or not options then return end

    if options.TriggerHeist and heist.TriggerHeist then
        heist.Started = true
        heist.TriggerHeist()
    end
    if options.Stage ~= nil then
        heist.CurrentStage = options.Stage
    end
    if options.TriggerAlarm and heist.TriggerAlarm then
        heist.TriggerAlarm()
    end
    if options.StopAlarm and heist.StopAlarm then
        heist.StopAlarm()
    end
    if options.Steal and options.StageIndex and options.StealableName and options.TrayIndex then
        local stage = heist.Stages[options.StageIndex]
        if stage then
            local stealable = stage.Stealables[options.StealableName]
            if stealable then
                local tray = stealable.Zones[options.TrayIndex]
                if tray then
                    tray.Stolen = true
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
		for k, heist in pairs(Config.Heists) do
            if heist.Reset then
                heist.Reset()
            end
            if heist.ClientReset then
                heist.ClientReset()
            end
        end
    end
end)

