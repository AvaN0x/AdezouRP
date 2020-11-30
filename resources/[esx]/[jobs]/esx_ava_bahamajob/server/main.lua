-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', Config.JobName, _U('job_client', Config.LabelName), true, true)
TriggerEvent('esx_society:registerSociety', Config.JobName, Config.LabelName, Config.SocietyName, Config.SocietyName, Config.SocietyName, {type = 'private'})

RegisterServerEvent('esx_ava_bahamajob:getStockItem')
AddEventHandler('esx_ava_bahamajob:getStockItem', function(itemName, count)

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

ESX.RegisterServerCallback('esx_ava_bahamajob:getStockItems', function(source, cb)

	TriggerEvent('esx_ava_inventories:getSharedInventory', Config.SocietyName, function(inventory)
		cb(inventory.items)
	end)

end)

RegisterServerEvent('esx_ava_bahamajob:putStockItems')
AddEventHandler('esx_ava_bahamajob:putStockItems', function(itemName, count)

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

ESX.RegisterServerCallback('esx_ava_bahamajob:getPlayerInventory', function(source, cb)

	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.getInventory().items

	cb({
		items      = items
	})

end)





------------
-- buying --
------------


RegisterNetEvent('esx_ava_bahamajob:BuyItems')
AddEventHandler('esx_ava_bahamajob:BuyItems', function(item,price,count) 
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

ESX.RegisterServerCallback('esx_ava_bahamajob:GetBuyElements', function(source, cb, items) 
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


