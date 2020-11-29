-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
ESX = nil

Items = {}
local playerInventoriesNames = {} -- inventories shared = 0
local Inventories = {}
local SharedInventories = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('onMySQLReady', function()
	local items = MySQL.Sync.fetchAll('SELECT * FROM items') -- get all items
	for i=1, #items, 1 do -- get label and weight for all items
		Items[items[i].name] = {
			label = items[i].label,
			limit = items[i].limit,
			weight = items[i].weight
		}
	end

	local inventories = MySQL.Sync.fetchAll('SELECT * FROM inventories')
	for i=1, #inventories, 1 do
		local name = inventories[i].name -- inventory name
		local label = inventories[i].label
		local max_weight = inventories[i].max_weight
		local shared = inventories[i].shared

		if shared == false then -- player inventory
			table.insert(playerInventoriesNames, {name = name, label = label, max_weight = max_weight})
			Inventories[name] = {}

		else -- group inventory
			local inventories_items = MySQL.Sync.fetchAll('SELECT * FROM inventories_items WHERE name = @name', {
				['@name'] = name
			})
	
			local items = {}

			for j=1, #inventories_items, 1 do
				if Items[inventories_items[j].name] then
					table.insert(items, {
						name  = inventories_items[j].item,
						count = inventories_items[j].count,
						label = Items[inventories_items[j].name].label,
						limit = Items[inventories_items[j].name].limit,
						weight = Items[inventories_items[j].name].weight
					})
				end
			end
			SharedInventories[name] = CreateInventory(name, label, max_weight, nil, items)
		end
	end
	TriggerEvent('esx_ava_inventories:reloadUsableItems')
	TriggerEvent('esx_ava_inventories:saveSharedInventories')
end)

function GetInventory(name, identifier)
	if Inventories[name] then
		for i=1, #Inventories[name], 1 do
			if Inventories[name][i].identifier == identifier then
				return Inventories[name][i]
			end
		end
	end
	return nil
end

function GetSharedInventory(name)
	return SharedInventories[name]
end

AddEventHandler('esx_ava_inventories:getInventory', function(name, identifier, cb)
	cb(GetInventory(name, identifier))
end)

AddEventHandler('esx_ava_inventories:getSharedInventory', function(name, cb)
	cb(GetSharedInventory(name))
end)

AddEventHandler('esx_ava_inventories:reloadUsableItems', function()
	TriggerEvent('esx:getUsableItems', function(items)
		for item, cb in pairs(items) do
			if Items[item] then
				Items[item].usable = true
			end
		end
	end)
end)

AddEventHandler('esx_ava_inventories:setItemUsable', function(itemName)
	if Items[itemName] then
		Items[itemName].usable = true
	end
end)


AddEventHandler('esx:playerLoaded', function(source)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	local ava_inventories = {}

	for i=1, #playerInventoriesNames, 1 do
		local name = playerInventoriesNames[i].name
		local label = playerInventoriesNames[i].label
		local max_weight = playerInventoriesNames[i].max_weight
		local identifier = xPlayer.identifier

		local inventories_items = MySQL.Sync.fetchAll('SELECT * FROM inventories_items WHERE name = @name AND identifier = @identifier', {
			['@name'] = name,
			['@identifier'] = identifier
		})

		local items = {}
		for j=1, #inventories_items, 1 do
			local itemName = inventories_items[j].item

			if Items[itemName] then
				table.insert(items, {
					name  = itemName,
					count = inventories_items[j].count,
					label = Items[itemName].label,
					limit = Items[itemName].limit,
					weight = Items[itemName].weight
				})
			end
		end

		local inventory = CreateInventory(name, label, max_weight, identifier, items)

		table.insert(Inventories[name], inventory)
		table.insert(ava_inventories, inventory) -- add inventory to player inventories
	end

	xPlayer.set('ava_inventories', ava_inventories) -- set inventories to player
end)


-- ESX.RegisterServerCallback('esx_ava_inventories:getMyInventories', function(source, cb)
-- 	local _source = source
-- 	local xPlayer = ESX.GetPlayerFromId(_source)
-- 	local inventories = {}

-- 	for k, nonShared in ipairs(playerInventoriesNames) do
-- 		inventories[nonShared.name] = GetInventory(nonShared.name, xPlayer.identifier)
-- 	end
-- 	print('ava_inventories = ' .. ESX.DumpTable(inventories))
-- 	cb(inventories)
-- end)

ESX.RegisterServerCallback('esx_ava_inventories:getMyInventory', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local inventory = GetInventory('inventory', xPlayer.identifier)
	for k, item in ipairs(inventory.items) do
		if item.count > 0 then
			item.usable = Items[item.name].usable
		end
	end

	cb({
		max_weight = inventory.max_weight,
		actual_weight = inventory.actual_weight,
		label = inventory.label,
		items = inventory.items,
		money = xPlayer.getMoney(),
		accounts = xPlayer.accounts,
		weapons = xPlayer.loadout
	})
end)

TriggerEvent('es:addGroupCommand', 'openinventory', 'mod', function(source, args, user)
	if args[1] ~= nil then
		if GetPlayerName(tonumber(args[1])) ~= nil then
			TriggerClientEvent('esx_ava_inventories:openPlayerInventory', source, tonumber(args[1]))
		end
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end)

ESX.RegisterServerCallback('esx_ava_inventories:getTargetInventory', function(source, cb, target)
	local _target = target
	local xTarget = ESX.GetPlayerFromId(_target)
	local inventory = GetInventory('inventory', xTarget.identifier)
	for k, item in ipairs(inventory.items) do
		if item.count > 0 then
			item.usable = Items[item.name].usable
		end
	end

	cb({
		max_weight = inventory.max_weight,
		actual_weight = inventory.actual_weight,
		label = inventory.label .. " - " .. GetPlayerName(target),
		items = inventory.items,
		money = xTarget.getMoney(),
		accounts = xTarget.accounts,
		weapons = xTarget.loadout
	})
end)

RegisterServerEvent("esx_ava_inventories:saveSharedInventories")
AddEventHandler("esx_ava_inventories:saveSharedInventories", function()
	for k, inv in pairs(SharedInventories) do
		inv.saveInventory()
	end
end)

RegisterServerEvent("esx_ava_inventories:saveInventories")
AddEventHandler("esx_ava_inventories:saveInventories", function(identifier)
	for k, nonShared in ipairs(playerInventoriesNames) do
		local inventory = GetInventory(nonShared.name, identifier)
		inventory.saveInventory()
	end
end)

RegisterServerEvent('esx_ava_inventories:giveItem')
AddEventHandler('esx_ava_inventories:giveItem', function(inventoryName, type, target, itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local playerInventory = GetInventory(inventoryName, xPlayer.identifier)
	local xTarget = ESX.GetPlayerFromId(target)
	local targetInventory = GetInventory(inventoryName, xTarget.identifier)

	if count == nil or count < 1 then
		TriggerClientEvent('esx:showNotification', _source, _('invalid_quantity'))
	elseif type == 'item_standard' then
		if playerInventory.canRemoveItem(itemName, count) then
			if targetInventory.canAddItem(itemName, count) then
				playerInventory.removeItem(itemName, count)
				TriggerClientEvent('esx:inventoryItemNotification', _source, false, itemName, count)
				targetInventory.addItem(itemName, count)
				TriggerClientEvent('esx:inventoryItemNotification', target, true, itemName, count)
			else
				TriggerClientEvent('esx:showNotification', _source, _('target_not_enough_place'))
				TriggerClientEvent('esx:showNotification', target, _('not_enough_place'))
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _('invalid_quantity'))
		end

	elseif type == 'item_money' then
		if xPlayer.getMoney() >= count then
			xPlayer.removeMoney(count)
			xTarget.addMoney(count)

			TriggerClientEvent('esx:inventoryItemNotification', target, true, _('cash'), ESX.Math.GroupDigits(count))
			TriggerClientEvent('esx:inventoryItemNotification', _source, false, _('cash'), ESX.Math.GroupDigits(count))
		else
			TriggerClientEvent('esx:showNotification', _source, _('invalid_quantity'))
		end

	elseif type == 'item_account' then
		local sourceAcc = xPlayer.getAccount(itemName)
		if sourceAcc.money >= count then
			xPlayer.removeAccountMoney(itemName, count)
			xTarget.addAccountMoney(itemName, count)

			print(sourceAcc.label)
			TriggerClientEvent('esx:inventoryItemNotification', target, true, sourceAcc.label, ESX.Math.GroupDigits(count))
			TriggerClientEvent('esx:inventoryItemNotification', _source, false, sourceAcc.label, ESX.Math.GroupDigits(count))
		else
			TriggerClientEvent('esx:showNotification', _source, _('invalid_quantity'))
		end

	elseif type == 'item_weapon' then
		if xPlayer.hasWeapon(itemName) then
			if targetInventory.canAddItem(itemName:lower(), 1) then
				xPlayer.removeWeapon(itemName)
				TriggerClientEvent('esx:inventoryItemNotification', _source, false, itemName:lower(), count)
				targetInventory.addItem(itemName:lower(), 1)
				TriggerClientEvent('esx:inventoryItemNotification', target, true, itemName:lower(), count)
			else
				TriggerClientEvent('esx:showNotification', _source, _('target_not_enough_place'))
				TriggerClientEvent('esx:showNotification', target, _('not_enough_place'))
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _('invalid_quantity'))
		end

	end
end)

RegisterServerEvent('esx_ava_inventories:dropItem')
AddEventHandler('esx_ava_inventories:dropItem', function(inventoryName, type, itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local inventory = GetInventory(inventoryName, xPlayer.identifier)

	if count == nil or count < 1 then
		TriggerClientEvent('esx:showNotification', _source, _('invalid_quantity'))
	elseif type == 'item_standard' then
		if inventory.canRemoveItem(itemName, count) then
			inventory.removeItem(itemName, count)
			TriggerClientEvent('esx:inventoryItemNotification', _source, false, itemName, count)

			local item = inventory.getItem(itemName)
			ESX.CreatePickup(type, itemName, count, ('~y~%s~s~ [~b~%s~s~]'):format(item.label, count), _source)
		else
			TriggerClientEvent('esx:showNotification', _source, _('invalid_quantity'))
		end

	elseif type == 'item_money' then
		local playerCash = xPlayer.getMoney()

		if (count > playerCash or playerCash < 1) then
			TriggerClientEvent('esx:showNotification', _source, _('invalid_quantity'))
		else
			xPlayer.removeMoney(count)

			local pickupLabel = ('~y~%s~s~ [~g~%s~s~]'):format(_('cash'), _('cash_amount', ESX.Math.GroupDigits(count)))
			ESX.CreatePickup('item_money', 'money', count, pickupLabel, _source)
		end

	elseif type == 'item_account' then
		local account = xPlayer.getAccount(itemName)

		if (count > account.money or account.money < 1) then
			TriggerClientEvent('esx:showNotification', _source, _('invalid_quantity'))
		else
			xPlayer.removeAccountMoney(itemName, count)

			local pickupLabel = ('~y~%s~s~ [~g~%s~s~]'):format(account.label, _('cash_amount', ESX.Math.GroupDigits(count)))
			ESX.CreatePickup('item_account', itemName, count, pickupLabel, _source)
		end

	elseif type == 'item_weapon' then
		local loadout = xPlayer.getLoadout()

		if xPlayer.hasWeapon(itemName) then
			for k, wea in ipairs(loadout) do
				if wea.name == itemName then
					count = wea.ammo
					break
				end
			end
			local weaponLabel, weaponPickup = ESX.GetWeaponLabel(itemName), 'PICKUP_' .. string.upper(itemName)

			xPlayer.removeWeapon(itemName)
			TriggerClientEvent('esx:pickupWeapon', _source, weaponPickup, itemName, count > 0 and count or 1)
		end

	end
end)