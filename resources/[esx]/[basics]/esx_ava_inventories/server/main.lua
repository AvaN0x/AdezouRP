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
	TriggerEvent('esx_ava_inventories:saveInventories')
end)

function GetInventory(name, identifier)
	for i=1, #Inventories[name], 1 do
		if Inventories[name][i].identifier == identifier then
			return Inventories[name][i]
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


ESX.RegisterServerCallback('esx_ava_inventories:getMyInventories', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local inventories = {}

	for k, nonShared in ipairs(playerInventoriesNames) do
		inventories[nonShared.name] = GetInventory(nonShared.name, xPlayer.identifier)
	end
	print('ava_inventories = ' .. ESX.DumpTable(inventories))
	cb(inventories)
end)



RegisterServerEvent("esx_ava_inventories:saveInventories")
AddEventHandler("esx_ava_inventories:saveInventories", function()
	for k, nonShared in ipairs(playerInventoriesNames) do
		for k2, inv in ipairs(Inventories[nonShared.name]) do
			inv.saveInventory() -- todo
		end
	end

	for k, inv in pairs(SharedInventories) do
		inv.saveInventory() -- todo
	end
end)

