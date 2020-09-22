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
