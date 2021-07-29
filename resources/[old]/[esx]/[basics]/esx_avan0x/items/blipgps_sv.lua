-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX.RegisterUsableItem('balisegps', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

	TriggerClientEvent('esx_avan0x:blipgps', source)
end)

RegisterServerEvent('esx_avan0x:useBlipgps')
AddEventHandler('esx_avan0x:useBlipgps', function()
    local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('balisegps', 1)
end)

