-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_ava_clotheshop:pay')
AddEventHandler('esx_ava_clotheshop:pay', function(name)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerEvent('esx_statejob:getTaxed', name, Config.Price * 10, function(toSociety) -- *10 for having 100% going to the government
	end)

	xPlayer.removeMoney(Config.Price)
	TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. Config.Price)
end)

ESX.RegisterServerCallback('esx_ava_clotheshop:checkMoney', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= Config.Price then
		print("true")
		cb(true)
	else
		print("false")
		cb(false)
	end
end)

-- * outfits
ESX.RegisterServerCallback('esx_ava_clotheshop:getPlayerOutfit', function(source, cb, num)
	local xPlayer  = ESX.GetPlayerFromId(source)
	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local outfit = store.get('dressing', num)
		cb(outfit.skin)
	end)
end)

ESX.RegisterServerCallback('esx_ava_clotheshop:getPlayerDressing', function(source, cb)
	local xPlayer  = ESX.GetPlayerFromId(source)
	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local count    = store.count('dressing')
		local labels   = {}
		for i=1, count, 1 do
			local entry = store.get('dressing', i)
			table.insert(labels, entry.label)
		end
		cb(labels)
	end)
end)

RegisterServerEvent('esx_ava_clotheshop:saveOutfit')
AddEventHandler('esx_ava_clotheshop:saveOutfit', function(label, skin)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local dressing = store.get('dressing')
		if dressing == nil then
			dressing = {}
		end
		table.insert(dressing, {
			label = label,
			skin  = skin
		})
		store.set('dressing', dressing)
	end)
end)

RegisterServerEvent('esx_ava_clotheshop:deleteOutfit')
AddEventHandler('esx_ava_clotheshop:deleteOutfit', function(label)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local dressing = store.get('dressing')

		if dressing == nil then
			dressing = {}
		end
		label = label
		table.remove(dressing, label)

		store.set('dressing', dressing)
	end)
end)
