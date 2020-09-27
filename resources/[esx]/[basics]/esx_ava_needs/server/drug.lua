ESX.RegisterUsableItem('bagcoke', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('bagcoke', 1)

	TriggerClientEvent('esx_status:add', source, 'drugged', 400000)
	TriggerClientEvent('esx_ava_needs:onSmokeDrug', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_bagcoke'))
end)

ESX.RegisterUsableItem('bagexta', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('bagexta', 1)

	TriggerClientEvent('esx_status:add', source, 'drugged', 300000)
	TriggerClientEvent('esx_ava_needs:onSmokeDrug', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_bagexta'))
end)

ESX.RegisterUsableItem('bagweed', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('bagweed', 1)

	TriggerClientEvent('esx_status:add', source, 'drugged', 200000)
	TriggerClientEvent('esx_ava_needs:onSmokeDrug', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_bagweed'))
end)

ESX.RegisterUsableItem('methamphetamine', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('methamphetamine', 1)

	TriggerClientEvent('esx_status:add', source, 'drugged', 400000)
	TriggerClientEvent('esx_ava_needs:onSmokeDrug', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_methamphetamine'))
end)
