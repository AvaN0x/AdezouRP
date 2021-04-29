-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', Config.JobName, _U('job_client', Config.LabelName), true, true)
TriggerEvent('esx_society:registerSociety', Config.JobName, Config.LabelName, Config.SocietyName, Config.SocietyName, Config.SocietyName, {type = 'private'})

RegisterServerEvent('esx_ava_fabriquearme:getStockItem')
AddEventHandler('esx_ava_fabriquearme:getStockItem', function(itemName, count)

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_ava_inventories:getSharedInventory', Config.SocietyName, function(inventory)

		local item = inventory.getItem(itemName)

		if item.count >= count then
			inventory.removeItem(itemName, count)
			xPlayer.addInventoryItem(itemName, count)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn') .. count .. ' ' .. item.label)

	end)

end)

ESX.RegisterServerCallback('esx_ava_fabriquearme:getStockItems', function(source, cb)

	TriggerEvent('esx_ava_inventories:getSharedInventory', Config.SocietyName, function(inventory)
		cb(inventory.items)
	end)

end)

RegisterServerEvent('esx_ava_fabriquearme:putStockItems')
AddEventHandler('esx_ava_fabriquearme:putStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)
  local sourceItem = xPlayer.getInventoryItem(itemName)

  TriggerEvent('esx_ava_inventories:getSharedInventory', Config.SocietyName, function(inventory)

    local inventoryItem = inventory.getItem(itemName)

    if sourceItem.count >= count and count > 0 then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('added') .. count .. ' ' .. item.label)

  end)

end)

ESX.RegisterServerCallback('esx_ava_fabriquearme:getPlayerInventory', function(source, cb)

	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.getInventory().items

	cb({
		items      = items
	})

end)


----------------
-- TRAITEMENT --
----------------

local function canCarryAll(source, items)
	local xPlayer = ESX.GetPlayerFromId(source)
	for i=1, #items, 1 do

		local xItem = xPlayer.getInventoryItem(items[i].name)

		if xItem.limit ~= -1 and xItem.count >= xItem.limit then
			TriggerClientEvent('esx:showNotification', source, _U('process_cant_carry'))
			return false
		end
	end
	return true	
end

local function hasEnoughItems(source, items)
	local xPlayer = ESX.GetPlayerFromId(source)
	local result = {}
	for i=1, #items, 1 do
		local xItem = xPlayer.getInventoryItem(items[i].name)
		if xItem.count < items[i].quantity then
			table.insert(result, (items[i].quantity - xItem.count) .. " " .. xItem.label)
		end
	end
	if result[1] then
		TriggerClientEvent('esx:showNotification', source, _U('process_not_enough', table.concat(result, "~s~, ~g~")))
		return false
	else
		return true	
	end

end

ESX.RegisterServerCallback('esx_ava_fabriquearme:canprocess', function(source, cb, v)
    if not playersProcessing[source] then
		if hasEnoughItems(source, v.ItemsGive) and canCarryAll(source, v.ItemsGet) then
			cb(true)
		else
			cb(false)
		end
    else
        print(('%s attempted to exploit processing!'):format(GetPlayerIdentifiers(source)[1]))
    end
end)

RegisterServerEvent('esx_ava_fabriquearme:process')
AddEventHandler('esx_ava_fabriquearme:process', function(v)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	playersProcessing[_source] = true

	Citizen.Wait(v.Delay)
	for i=1, #v.ItemsGive, 1 do
		xPlayer.removeInventoryItem(v.ItemsGive[i].name, v.ItemsGive[i].quantity)
	end
	for i=1, #v.ItemsGet, 1 do
		xPlayer.addInventoryItem(v.ItemsGet[i].name, v.ItemsGet[i].quantity)
	end


	playersProcessing[_source] = nil
end)


function CancelProcessing(playerID)
	if playersProcessing[playerID] then
		playersProcessing[playerID] = nil
	end
end

RegisterServerEvent('esx_ava_fabriquearme:cancelProcessing')
AddEventHandler('esx_ava_fabriquearme:cancelProcessing', function()
	CancelProcessing(source)
end)

AddEventHandler('esx:playerDropped', function(playerID, reason)
	CancelProcessing(playerID)
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	CancelProcessing(source)
end)

------------
-- buying --
------------


RegisterNetEvent('esx_ava_fabriquearme:BuyItems')
AddEventHandler('esx_ava_fabriquearme:BuyItems', function(item,price,count) 
	local xPlayer = ESX.GetPlayerFromId(source)
	while not xPlayer do 
		xPlayer = ESX.GetPlayerFromId(source); 
		Citizen.Wait(0); 
	end
	local xItem = xPlayer.getInventoryItem(item)
	local totalprice = tonumber(count)*tonumber(price)

	if xItem.limit ~= -1 and (xItem.count + count) > xItem.limit then
		TriggerClientEvent('esx:showNotification', source, _U('buy_cant_carry'))
	elseif (xPlayer.getMoney() < totalprice) then
		TriggerClientEvent('esx:showNotification', source, _U('buy_cant_afford'))
	else
		TriggerEvent('esx_statejob:getTaxed', Config.SocietyName, totalprice, function(toSociety)
		end)    
		xPlayer.removeMoney(totalprice)
		xPlayer.addInventoryItem(item, count)
		TriggerClientEvent('esx:showNotification', source, _U('buy_you_paid')..totalprice)
	end
end)

ESX.RegisterServerCallback('esx_ava_fabriquearme:GetBuyElements', function(source, cb, items) 
	local xPlayer = ESX.GetPlayerFromId(source)
	while not xPlayer do 
		xPlayer = ESX.GetPlayerFromId(source); 
		Citizen.Wait(0); 
	end

	local elements = {}
	for k,v in pairs(items) do
		local item = xPlayer.getInventoryItem(v.name)
		table.insert(elements, {itemLabel = item.label, label = item.label..' : $'..v.price, price = v.price, name = v.name})
	end
	cb(elements)
end)


