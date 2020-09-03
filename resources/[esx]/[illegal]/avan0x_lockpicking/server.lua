-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('avan0x_lockpicking:LockpickingComplete')
AddEventHandler('avan0x_lockpicking:LockpickingComplete', function(didWin) 
	if not didWin then
		local xPlayer = ESX.GetPlayerFromId(source)
		while not xPlayer do 
			Citizen.Wait(0)
			xPlayer = ESX.GetPlayerFromId(source)
		end
		xPlayer.removeInventoryItem('lockpick', 1)
	end
end)