ESX.RegisterUsableItem('bread', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('bread', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 400000)
	TriggerClientEvent('esx_ava_needs:onEat', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_bread'))
end)

ESX.RegisterUsableItem('cupcake', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('cupcake', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 400000)
	TriggerClientEvent('esx_ava_needs:onEat', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_cupcake'))
end)

ESX.RegisterUsableItem('beef', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('beef', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 600000)
	TriggerClientEvent('esx_ava_needs:onEat', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_beef'))
end)

ESX.RegisterUsableItem('hamburger', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('hamburger', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 600000)
	TriggerClientEvent('esx_ava_needs:onEat', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_hamburger'))
end)

ESX.RegisterUsableItem('pizza', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('pizza', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 600000)
	TriggerClientEvent('esx_ava_needs:onEat', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_pizza'))
end)

ESX.RegisterUsableItem('donut', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('donut', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 600000)
	TriggerClientEvent('esx_ava_needs:onEat', source, "prop_amb_donut")
	TriggerClientEvent('esx:showNotification', source, _U('used_donut'))
end)

ESX.RegisterUsableItem('raisin', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('raisin', 1)

    TriggerClientEvent('esx_status:add', source, 'hunger', 150000)
    TriggerClientEvent('esx_status:add', source, 'thirst', 50000)

	TriggerClientEvent('esx_ava_needs:onEat', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_raisin'))
end)

ESX.RegisterUsableItem('saucisson', function(source)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem('saucisson', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 250000)
	TriggerClientEvent('esx_ava_needs:onEat', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_saucisson'))
end)

ESX.RegisterUsableItem('hotdog', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.removeInventoryItem('hotdog', 1)

    TriggerClientEvent('esx_status:add', source, 'hunger', 300000)
    TriggerClientEvent('esx_ava_needs:onEat', source)
    TriggerClientEvent('esx:showNotification', source, _U('used_hotdog'))
end)

ESX.RegisterUsableItem('nuggets', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('nuggets', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 400000)
	TriggerClientEvent('esx_ava_needs:onEat', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_nuggets'))
end)

ESX.RegisterUsableItem('chickenburger', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('chickenburger', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 400000)
	TriggerClientEvent('esx_ava_needs:onEat', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_chickenburger'))
end)

ESX.RegisterUsableItem('frites', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('frites', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 400000)
	TriggerClientEvent('esx_ava_needs:onEat', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_frites'))
end)

ESX.RegisterUsableItem('potatoes', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('potatoes', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 400000)
	TriggerClientEvent('esx_ava_needs:onEat', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_potatoes'))
end)

ESX.RegisterUsableItem('doublechickenburger', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('doublechickenburger', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 400000)
	TriggerClientEvent('esx_ava_needs:onEat', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_doublechickenburger'))
end)

ESX.RegisterUsableItem('tenders', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('tenders', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 400000)
	TriggerClientEvent('esx_ava_needs:onEat', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_tenders'))
end)

ESX.RegisterUsableItem('chickenwrap', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('chickenwrap', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 400000)
	TriggerClientEvent('esx_ava_needs:onEat', source)
	TriggerClientEvent('esx:showNotification', source, _U('used_chickenwrap'))
end)

