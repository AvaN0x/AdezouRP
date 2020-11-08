-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('avan0x_lockpicking:LockpickingComplete')
AddEventHandler('avan0x_lockpicking:LockpickingComplete', function(didWin) 
	if didWin then
		if math.random(1, 3) == 1 then
			local xPlayer = ESX.GetPlayerFromId(source)
			xPlayer.removeInventoryItem('lockpick', 1)
		end
	else
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('lockpick', 1)
	end
end)