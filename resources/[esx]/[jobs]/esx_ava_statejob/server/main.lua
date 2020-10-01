ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'state', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'state', _U('state_client'), true, true)
TriggerEvent('esx_society:registerSociety', 'state', 'state', 'society_state', 'society_state', 'society_state', {type = 'public'})

RegisterServerEvent('esx_ava_statejob:getStockItem')
AddEventHandler('esx_ava_statejob:getStockItem', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_state', function(inventory)
		local item = inventory.getItem(itemName)
		local sourceItem = xPlayer.getInventoryItem(itemName)

		-- is there enough in the society?
		if count > 0 and item.count >= count then
		
			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('player_cannot_hold'))
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn', count, item.label))
			end
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end
	end)
end)

ESX.RegisterServerCallback('esx_ava_statejob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_state', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('esx_ava_statejob:putStockItems')
AddEventHandler('esx_ava_statejob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_state', function(inventory)
		local item = inventory.getItem(itemName)

		if item.count >= 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', count, item.label))
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end

	end)

end)

ESX.RegisterServerCallback('esx_ava_statejob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)


------------ sonnette

RegisterServerEvent("esx_ava_statejob:sendSonnette")
AddEventHandler("esx_ava_statejob:sendSonnette", function()
	local _source = source
	local xPlayerSource = ESX.GetPlayerFromId(_source)
	local result = MySQL.Sync.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayerSource.identifier
	})
	local name = (result[1].firstname or 'FIRSTNAME') .. ' ' .. (result[1].lastname or 'LASTNAME')

	local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if (xPlayer.job ~= nil and xPlayer.job.name == 'state') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'state') then
			TriggerClientEvent("esx_ava_statejob:sendRequest", xPlayers[i], name, _source)
		end
	end


end)

RegisterServerEvent("esx_ava_statejob:sendStatusToPeople")
AddEventHandler("esx_ava_statejob:sendStatusToPeople", function(id, status)
	TriggerClientEvent("esx_ava_statejob:sendStatus", id, status)
end)

-- armory

ESX.RegisterServerCallback('esx_ava_statejob:getArmoryWeapons', function(source, cb)
	TriggerEvent('esx_datastore:getSharedDataStore', 'society_state', function(store)
		local weapons = store.get('weapons')
		if weapons == nil then
			weapons = {}
		end
		cb(weapons)
	end)
end)

ESX.RegisterServerCallback('esx_ava_statejob:addArmoryWeapon', function(source, cb, weaponName)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeWeapon(weaponName)
	TriggerEvent('esx_datastore:getSharedDataStore', 'society_state', function(store)
		local weapons = store.get('weapons')
		if weapons == nil then
			weapons = {}
		end
		local foundWeapon = false
		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
			weapons[i].count = weapons[i].count + 1
			foundWeapon = true
			end
		end
		if not foundWeapon then
			table.insert(weapons, {
			name  = weaponName,
			count = 1
			})
		end
		store.set('weapons', weapons)
		cb()
	end)
end)

ESX.RegisterServerCallback('esx_ava_statejob:removeArmoryWeapon', function(source, cb, weaponName)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addWeapon(weaponName, 1000)
	TriggerEvent('esx_datastore:getSharedDataStore', 'society_state', function(store)
		local weapons = store.get('weapons')
		if weapons == nil then
			weapons = {}
		end
		local foundWeapon = false
		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
			weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
			foundWeapon = true
			end
		end
		if not foundWeapon then
			table.insert(weapons, {
			name  = weaponName,
			count = 0
			})
		end
		store.set('weapons', weapons)
		cb()
	end)
end)


----------- taxes

AddEventHandler('esx_statejob:getTaxed', function(sourcejob, total, cb)
	local toState  = math.ceil(total * Config.Taxe)
	local toSociety = math.floor(total * (1 - Config.Taxe))
    local stateAccount = nil

    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_state', function(account)
        stateAccount = account
    end)

    if stateAccount ~= nil then
        stateAccount.addMoney(toState)
	end
	
	TriggerEvent('esx_avan0x:logTransaction', sourcejob, sourcejob, 'society_state', 'society_state', "taxes", toState)

	MySQL.Async.fetchAll('SELECT label FROM addon_account WHERE name = @name', 
	{
		['@name'] = sourcejob
	}, function(result)
		local joblabel = nil
		if result[1] and result[1].label then
			joblabel = result[1].label
		else
			joblabel = sourcejob
		end



		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			-- if (xPlayer.job ~= nil and xPlayer.job.name == 'state' and xPlayer.job.grade_name == 'boss') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'state') then
			if (xPlayer.job ~= nil and xPlayer.job.name == 'state' and xPlayer.job.grade_name == 'boss') then
				TriggerClientEvent("esx:showNotification", xPlayers[i], joblabel.. "\nAjout dans le coffre : $"..toState)
			end
		end

	end)
	cb(toSociety)
end)

-- factures

ESX.RegisterServerCallback('esx_ava_statejob:getBillUnpaid', function (source, cb)
	MySQL.Async.fetchAll('SELECT CONCAT(firstname, " ", lastname) AS name, billing.label AS label, amount, addon_account.label AS target, DATE_FORMAT(date,\'%d/%m/%Y\') AS date, DATEDIFF(CURRENT_DATE, date) AS jours FROM billing JOIN users ON billing.identifier = users.identifier LEFT JOIN addon_account ON target = addon_account.name WHERE target_type = "society" AND DATEDIFF(CURRENT_DATE, date) >= @nbjours', 
		{
			['@nbjours']  = Config.FacturesDays
		}, function(result)
		cb(result)
	end)
end)

-- parkingSlots

ESX.RegisterServerCallback('esx_ava_statejob:getParkingSlots', function (source, cb, search)
	MySQL.Async.fetchAll('SELECT identifier, CONCAT(lastname, " ", firstname) AS name, parking_slots AS parking_slots FROM users WHERE LOWER(CONCAT(lastname, " ", firstname)) LIKE LOWER(CONCAT("%", TRIM(@search), "%")) ORDER BY parking_slots DESC, name ASC', 
		{
			["@search"] = search
		}, function(result)
		cb(result)
	end)
end)

ESX.RegisterServerCallback('esx_ava_statejob:setParkingSlots', function (source, cb, result, value)
	MySQL.Async.execute(
		'UPDATE users SET parking_slots = @value WHERE identifier = @identifier',
		{
			['@value']   = value,
			['@identifier'] = result.identifier,
		},
		function(rowsChanged)
		cb()
	end)
end)


-- get out of pound

ESX.RegisterServerCallback('esx_ava_statejob:getPoundedSocietyVehicles', function (source, cb)
	MySQL.Async.fetchAll('SELECT DISTINCT(owned_vehicles.owner) AS society, addon_account.label FROM owned_vehicles JOIN addon_account ON owned_vehicles.owner = addon_account.name WHERE state = 0 ORDER BY owned_vehicles.owner DESC', 
		{}, function(result)
		cb(result)
	end)
end)





-- Citizen.CreateThread(function()
-- 	Citizen.Wait(10000)
-- 	local items = {
-- 		'mdma',
-- 		'trimmedweed',
-- 		'grapperaisin',
-- 	}
-- 	print('try delete')

-- 	for i=1, #items, 1 do
-- 		print(items[i])
-- 		print('DELETE FROM `items` WHERE name = @item')
-- 		MySQL.Sync.execute("DELETE FROM `items` WHERE name = @item", {
-- 			['@item'] = items[i] 
-- 		})
-- 		print('DELETE FROM `addon_inventory_items` WHERE name = @item')
-- 		MySQL.Sync.execute("DELETE FROM `addon_inventory_items` WHERE name = @item", {
-- 			['@item'] = items[i] 
-- 		})
-- 		print('DELETE FROM `user_inventory` WHERE item = @item')
-- 		MySQL.Sync.execute("DELETE FROM `user_inventory` WHERE item = @item", {
-- 			['@item'] = items[i] 
-- 		})

-- 	end
-- end)