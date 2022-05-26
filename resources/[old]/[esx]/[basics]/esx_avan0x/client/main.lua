-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX	= nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

------------------------------------------------
------------ CHANGE SOME HUD COLORS ------------
------------------------------------------------
Citizen.CreateThread(function()
    ReplaceHudColour(116, 15)
end)

--------------------------------------
------------ ACTIVATE PVP ------------
--------------------------------------
AddEventHandler("playerSpawned", function(spawn)
	SetCanAttackFriendly(PlayerPedId(), true, false)
	NetworkSetFriendlyFireOption(true)
end)

---------------------------------------
-------- CAN'T FALL AT LOADING --------
---------------------------------------
Citizen.CreateThread(function()
    local playerPed = PlayerPedId()
    local health = GetEntityHealth(playerPed)
    if health > 0 then
        FreezeEntityPosition(playerPed, true)
        Citizen.Wait(30000)
        FreezeEntityPosition(playerPed, false)
    end
end)

---------------------------------------
-------- REMOVE STATIC EMITTERS --------
---------------------------------------
Citizen.CreateThread(function()
    local loop = true
    while loop do
        Citizen.Wait(0)
        if NetworkIsSessionStarted() then
            -- Remove unicorn ambiant sound
            SetStaticEmitterEnabled('LOS_SANTOS_VANILLA_UNICORN_01_STAGE', false)
            SetStaticEmitterEnabled('LOS_SANTOS_VANILLA_UNICORN_02_MAIN_ROOM', false)
            SetStaticEmitterEnabled('LOS_SANTOS_VANILLA_UNICORN_03_BACK_ROOM', false)

            -- -- -- -- SetStaticEmitterEnabled("SE_tr_tuner_car_meet_Meet_rm_Music_01", false)
            -- -- -- -- SetStaticEmitterEnabled("SE_tr_tuner_car_meet_Meet_rm_Music_02", false)
            -- -- -- -- SetStaticEmitterEnabled("SE_tr_tuner_car_meet_Meet_rm_Music_03", false)
            -- -- -- -- SetStaticEmitterEnabled("SE_tr_tuner_car_meet_Meet_rm_Music_04", false)
            -- -- -- -- SetStaticEmitterEnabled("SE_tr_tuner_car_meet_Meet_rm_Music_05", false)
            -- -- -- SetStaticEmitterEnabled("SE_tr_tuner_car_meet_Main_rm_Vehicle_Noise_01", false)
            -- -- -- SetStaticEmitterEnabled("SE_tr_tuner_car_meet_Main_rm_Vehicle_Noise_02", false)
            -- -- -- -- SetStaticEmitterEnabled("SE_tr_tuner_car_meet_Meet_rm_Music_Takeover", false)


            SetStaticEmitterEnabled("SE_tr_tuner_car_meet_Main_rm_Vehicle_Noise_01", false)
            SetStaticEmitterEnabled("SE_tr_tuner_car_meet_Main_rm_Vehicle_Noise_02", false)

            SetStaticEmitterEnabled("SE_tr_tuner_car_meet_sandbox_viewer_area_music_01", true)
            SetStaticEmitterEnabled("SE_tr_tuner_car_meet_sandbox_viewer_area_music_02", true)
            SetStaticEmitterEnabled("SE_tr_tuner_car_meet_sandbox_viewer_area_music_01_B", true)
            SetStaticEmitterEnabled("SE_tr_tuner_car_meet_sandbox_viewer_area_music_02_B", true)
            SetStaticEmitterEnabled("SE_tr_tuner_car_meet_sandbox_music_01", true)
            SetStaticEmitterEnabled("SE_tr_tuner_car_meet_sandbox_music_02", true)


            -- SetStaticEmitterEnabled("DLC_Tuner_Car_Meet_Test_Area_Sounds", false)
            -- SetStaticEmitterEnabled("DLC_Tuner_Car_Meet_Scripted_Sounds", false)

            SetAmbientZoneState("AZ_tr_tuner_car_meet_Meet_BG", false, true)
            SetAmbientZoneState("AZ_tr_tuner_car_meet_Meet_BG_2", false, true)

            loop = false
        end
    end
end)


-------------------------------------------
-------- CAN'T MOVE TO DRIVER SEAT --------
-------------------------------------------

local playerPed = nil

local disableMTDS = true -- MoveToDriverSeat
local shouldStopMTDS = nil

Citizen.CreateThread(function()
	while true do
		playerPed = PlayerPedId()
		local veh = GetVehiclePedIsIn(playerPed, false)
		shouldStopMTDS = veh ~= 0 and disableMTDS and GetPedInVehicleSeat(veh, 0) == playerPed
		Citizen.Wait(2000)
	end
end)


Citizen.CreateThread(function()
	while true do
        Citizen.Wait(0)
		if shouldStopMTDS and disableMTDS then
			if GetIsTaskActive(playerPed, 165) then
				SetPedIntoVehicle(playerPed, GetVehiclePedIsIn(playerPed, false), 0)
			end
		end
	end
end)

RegisterNetEvent("esx_avan0x:moveToDriverSeat")
AddEventHandler("esx_avan0x:moveToDriverSeat", function()
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		disableMTDS = false
		Citizen.Wait(5000)
		disableMTDS = true
	else
		CancelEvent()
	end
end)


-----------
-- OTHER --
-----------

RegisterCommand("v", function(source, args, rawCommand)
    local playerPed = PlayerPedId()
	local v = GetVehiclePedIsIn(playerPed, false)

	if v ~= 0 then
        local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
        print(ESX.DumpTable(vehicleProps))
    end
end, false)