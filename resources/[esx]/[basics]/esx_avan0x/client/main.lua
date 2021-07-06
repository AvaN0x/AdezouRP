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
            loop = false
        end
    end
end)


-------------------------------------------
-------- CAN'T MOVE TO DRIVER SEAT --------
-------------------------------------------

local disableMTDS = true -- MoveToDriverSeat
local shouldStopMTDS = nil

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		local playerPed = GetPlayerPed(-1)
		local veh = GetVehiclePedIsIn(playerPed, false)
		shouldStopMTDS = veh ~= 0 and disableMTDS and GetPedInVehicleSeat(veh, 0) == playerPed
	end
end)


Citizen.CreateThread(function()
	while true do
        Citizen.Wait(10)
		if shouldStopMTDS and disableMTDS then
			local playerPed = GetPlayerPed(-1)
			if GetIsTaskActive(playerPed, 165) then
				SetPedIntoVehicle(playerPed, GetVehiclePedIsIn(playerPed, false), 0)
			end
		end
	end
end)

RegisterNetEvent("esx_avan0x:moveToDriverSeat")
AddEventHandler("esx_avan0x:moveToDriverSeat", function()
	if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
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
    local playerPed = GetPlayerPed(-1)
	local v = GetVehiclePedIsIn(playerPed, false)

	if v ~= 0 then
        local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
        print(ESX.DumpTable(vehicleProps))
    end
end, false)