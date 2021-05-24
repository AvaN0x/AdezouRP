-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX.RegisterUsableItem('bproof_vest', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

	TriggerClientEvent('esx_avan0x:bproof_vest', source)
end)

RegisterServerEvent('esx_avan0x:removeBProofVest')
AddEventHandler('esx_avan0x:removeBProofVest', function()
    local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('bproof_vest', 1)
end)

