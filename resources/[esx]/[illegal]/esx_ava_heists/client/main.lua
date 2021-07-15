-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX = nil
local PlayerData = {}



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