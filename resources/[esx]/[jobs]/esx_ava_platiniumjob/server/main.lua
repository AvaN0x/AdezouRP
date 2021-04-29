-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', Config.JobName, _U('job_client', Config.LabelName), true, true)
TriggerEvent('esx_society:registerSociety', Config.JobName, Config.LabelName, Config.SocietyName, Config.SocietyName, Config.SocietyName, {type = 'private'})

RegisterServerEvent('esx_ava_platiniumjob:getStockItem')
AddEventHandler('esx_ava_platiniumjob:getStockItem', function(itemName, count)

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

ESX.RegisterServerCallback('esx_ava_platiniumjob:getStockItems', function(source, cb)

	TriggerEvent('esx_ava_inventories:getSharedInventory', Config.SocietyName, function(inventory)
		cb(inventory.items)
	end)

end)

RegisterServerEvent('esx_ava_platiniumjob:putStockItems')
AddEventHandler('esx_ava_platiniumjob:putStockItems', function(itemName, count)

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

ESX.RegisterServerCallback('esx_ava_platiniumjob:getPlayerInventory', function(source, cb)

	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.getInventory().items

	cb({
		items      = items
	})

end)

