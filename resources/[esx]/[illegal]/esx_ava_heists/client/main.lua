-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX = nil
PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil or ESX.GetPlayerData().job2 == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
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
            if heist.InteriorId and playerInterior == heist.InteriorId then
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
                for k, stealable in pairs(stage.Stealables) do
                    for k, zone in pairs(stealable.Zones) do
                        if not zone.Stealed then
                            local distance = #(playerCoords - zone.Coord)
                            if distance < Config.DrawDistance then
                                if stealable.Marker then
                                    DrawMarker(stealable.Marker, zone.MarkerCoord or zone.Coord, 0.0, 0.0, 0.0, stealable.MarkerRotation or vector3(0.0, 0.0, 0.0), stealable.Size.x or 1.0, stealable.Size.y or 1.0, stealable.Size.z or 1.0, stealable.Color.r or 255, stealable.Color.g or 255, stealable.Color.b or 255, 100, stealable.BobUpAndDown or false, true, 2, false, false, false, false)
                                end
                                
                                if distance < stealable.Distance then

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

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
		for k, heist in pairs(Config.Heists) do
            if heist.Reset then
                heist.Reset()
            end
        end
    end
end)