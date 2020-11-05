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



--------------------------------------
------------ ACTIVATE PVP ------------
--------------------------------------
AddEventHandler("playerSpawned", function(spawn)
	SetCanAttackFriendly(GetPlayerPed(-1), true, false)
	NetworkSetFriendlyFireOption(true)
end)

---------------------------------------
-------- CAN'T FALL AT LOADING --------
---------------------------------------
Citizen.CreateThread(function()
    local health = GetEntityHealth(PlayerPedId())
    if health > 0 then
        SetEntityInvincible(GetPlayerPed(-1),true)
        Citizen.Wait(30000)
        SetEntityInvincible(GetPlayerPed(-1),false)
    end
end)


-------------------------------------------
-------- CAN'T MOVE TO DRIVER SEAT --------
-------------------------------------------

local disableMTDS = true -- MoveToDriverSeat
local shouldStopMTDS = nil

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3000)
		local playerPed = GetPlayerPed(-1)
		local veh = GetVehiclePedIsIn(playerPed, false)
		shouldStopMTDS = veh ~= 0 and disableMTDS and GetPedInVehicleSeat(veh, 0) == playerPed
	end
end)


Citizen.CreateThread(function()
	while true do
        Citizen.Wait(100)
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
