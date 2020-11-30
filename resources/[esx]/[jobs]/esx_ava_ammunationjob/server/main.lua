-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', Config.JobName, _U('job_client', Config.LabelName), true, true)
TriggerEvent('esx_society:registerSociety', Config.JobName, Config.LabelName, Config.SocietyName, Config.SocietyName, Config.SocietyName, {type = 'private'})

RegisterServerEvent('esx_ava_ammunationjob:getStockItem')
AddEventHandler('esx_ava_ammunationjob:getStockItem', function(itemName, count)

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

ESX.RegisterServerCallback('esx_ava_ammunationjob:getStockItems', function(source, cb)

	TriggerEvent('esx_ava_inventories:getSharedInventory', Config.SocietyName, function(inventory)
		cb(inventory.items)
	end)

end)

RegisterServerEvent('esx_ava_ammunationjob:putStockItems')
AddEventHandler('esx_ava_ammunationjob:putStockItems', function(itemName, count)

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

ESX.RegisterServerCallback('esx_ava_ammunationjob:getPlayerInventory', function(source, cb)

	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.inventory

	cb({
		items      = items
	})

end)













-------------
-- RECOLTE --
-------------

local playersProcessing = {}

ESX.RegisterServerCallback('esx_ava_ammunationjob:canPickUp', function(source, cb, items)
	local xPlayer = ESX.GetPlayerFromId(source)
	local result = false
	for i=1, #items, 1 do

		local xItem = xPlayer.getInventoryItem(items[i].name)

		if not (xItem.limit ~= -1 and xItem.count >= xItem.limit) then
			if not result then
				result = true
			end
		end
	end
	cb(result)
end)

RegisterServerEvent('esx_ava_ammunationjob:pickUp')
AddEventHandler('esx_ava_ammunationjob:pickUp', function(item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem(item.name)

	if xItem.limit ~= -1 and (xItem.count + item.quantity) > xItem.limit then
		if xItem.count < xItem.limit then
			xPlayer.addInventoryItem(xItem.name, xItem.limit - xItem.count)
		end
	else
		xPlayer.addInventoryItem(xItem.name, item.quantity)
	end
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

ESX.RegisterServerCallback('esx_ava_ammunationjob:canprocess', function(source, cb, v)
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

RegisterServerEvent('esx_ava_ammunationjob:process')
AddEventHandler('esx_ava_ammunationjob:process', function(v)
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

RegisterServerEvent('esx_ava_ammunationjob:cancelProcessing')
AddEventHandler('esx_ava_ammunationjob:cancelProcessing', function()
	CancelProcessing(source)
end)

AddEventHandler('esx:playerDropped', function(playerID, reason)
	CancelProcessing(playerID)
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	CancelProcessing(source)
end)




-------------
-- selling --
-------------


RegisterNetEvent('esx_ava_ammunationjob:SellItems')
AddEventHandler('esx_ava_ammunationjob:SellItems', function(item,price,count) 
	local xPlayer = ESX.GetPlayerFromId(source)
	while not xPlayer do 
		xPlayer = ESX.GetPlayerFromId(source); 
		Citizen.Wait(0); 
	end
	local xItem = xPlayer.getInventoryItem(item)
	if xItem.count and xItem.count >= count then
		local totalFromSell = tonumber(count)*tonumber(price)
		local total = nil
		TriggerEvent('esx_statejob:getTaxed', Config.SocietyName, totalFromSell, function(toSociety)
			total = toSociety
		end)
		
		local playerMoney
		local societyMoney

		-- if he is an interim, he must earn less than the society
		if ((xPlayer.job ~= nil and xPlayer.job.name == Config.JobName and xPlayer.job.grade_name == 'interim') 
		or (xPlayer.job2 ~= nil and xPlayer.job2.name == Config.JobName and xPlayer.job2.grade_name == 'interim')) then
			playerMoney = math.floor(total / 100 * 40)
			societyMoney = math.floor(total / 100 * 60)
		else
			playerMoney = math.floor(total / 100 * 60)
			societyMoney = math.floor(total / 100 * 40)
		end

		xPlayer.removeInventoryItem(item, count)
		local societyAccount = nil

		TriggerEvent('esx_addonaccount:getSharedAccount', Config.SocietyName, function(account)
			societyAccount = account
		end)
		if societyAccount ~= nil then
			TriggerEvent('esx_avan0x:logTransaction', xPlayer.identifier, xPlayer.identifier, Config.SocietyName, Config.SocietyName, "job_selling", societyMoney)


			xPlayer.addMoney(playerMoney)
			societyAccount.addMoney(societyMoney)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_earned') .. playerMoney)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. societyMoney)
		end
	end
end)

ESX.RegisterServerCallback('esx_ava_ammunationjob:GetSellElements', function(source, cb, items) 
	local xPlayer = ESX.GetPlayerFromId(source)
	while not xPlayer do 
		xPlayer = ESX.GetPlayerFromId(source); 
		Citizen.Wait(0); 
	end
	local elements = {}
	for k,v in pairs(items) do
		local xItem = xPlayer.getInventoryItem(v.name)
		local itemOwned = 0
		if xItem and xItem.count then 
			itemOwned = xItem.count; 
		end
		table.insert(elements, {itemLabel = xItem.label, label = xItem.label..' : '..itemOwned..' unité(s)', price = v.price, name = v.name, owned = itemOwned})
	end
	cb(elements)
end)






------------
-- buying --
------------


RegisterNetEvent('esx_ava_ammunationjob:BuyItems')
AddEventHandler('esx_ava_ammunationjob:BuyItems', function(item,price,count) 
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

ESX.RegisterServerCallback('esx_ava_ammunationjob:GetBuyElements', function(source, cb, items) 
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


