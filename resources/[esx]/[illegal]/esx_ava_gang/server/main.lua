-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-----------------------
-------- ITEMS --------
-----------------------

RegisterServerEvent('esx_ava_gang:getStockItem')
AddEventHandler('esx_ava_gang:getStockItem', function(itemName, count, name)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerEvent('esx_addoninventory:getSharedInventory', name, function(inventory)
		local item = inventory.getItem(itemName)
		if item.count >= count then
			inventory.removeItem(itemName, count)
			xPlayer.addInventoryItem(itemName, count)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn', 'x' .. count .. ' ' .. item.label))
	end)
end)

ESX.RegisterServerCallback('esx_ava_gang:getStockItems', function(source, cb, name)
	TriggerEvent('esx_addoninventory:getSharedInventory', name, function(inventory)
		TriggerEvent('esx_addonaccount:getSharedAccount', name, function(account)
			TriggerEvent('esx_addonaccount:getSharedAccount', name .. "_black", function(accountDirty)
				cb({
					items = inventory.items,
					cash = account.money,
					black_cash = accountDirty.money
				})
			end)
		end)
	end)
end)

RegisterServerEvent('esx_ava_gang:putStockItems')
AddEventHandler('esx_ava_gang:putStockItems', function(itemName, count, name)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)
	TriggerEvent('esx_addoninventory:getSharedInventory', name, function(inventory)
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', 'x' .. count .. ' ' .. sourceItem.label))
	end)
end)

ESX.RegisterServerCallback('esx_ava_gang:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items = xPlayer.inventory
	cb({
		items = items,
		cash = xPlayer.get('money'),
		black_cash = xPlayer.getAccount('black_money').money
	})
end)



-----------------------
-------- MONEY --------
-----------------------

RegisterServerEvent('esx_ava_gang:withdrawMoney')
AddEventHandler('esx_ava_gang:withdrawMoney', function(name, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerEvent('esx_addonaccount:getSharedAccount', name, function(account)
		if amount > 0 and account.money >= amount then
			local new = account.money - amount
			TriggerEvent('esx_ava_gang:saveData', xPlayer, "withdraw", society, amount, new)
			account.removeMoney(amount)
			xPlayer.addMoney(amount)

			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn', amount .. "$"))
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end
	end)
end)

RegisterServerEvent('esx_ava_gang:withdrawMoneyDirty')
AddEventHandler('esx_ava_gang:withdrawMoneyDirty', function(name, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerEvent('esx_addonaccount:getSharedAccount', name .. '_black', function(account)
		if amount > 0 and account.money >= amount then
			account.removeMoney(amount)
			xPlayer.addAccountMoney('black_money', amount)

			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn', amount .. "$"))
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end
	end)
end)

RegisterServerEvent('esx_ava_gang:depositMoney')
AddEventHandler('esx_ava_gang:depositMoney', function(name, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	if amount > 0 and xPlayer.get('money') >= amount then
		TriggerEvent('esx_addonaccount:getSharedAccount', name, function(account)
			xPlayer.removeMoney(amount)
			account.addMoney(amount)
		end)

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', amount .. "$"))
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
	end
end)

RegisterServerEvent('esx_ava_gang:depositMoneyDirty')
AddEventHandler('esx_ava_gang:depositMoneyDirty', function(name, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	if amount > 0 and xPlayer.getAccount('black_money').money >= amount then
		TriggerEvent('esx_addonaccount:getSharedAccount', name .. '_black', function(account)
			xPlayer.removeAccountMoney('black_money', amount)
			account.addMoney(amount)
		end)

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', amount .. "$"))
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
	end
end)




-------------------------
-------- MEMBERS --------
-------------------------

local function GetGang(xPlayer)
	local result = MySQL.Sync.fetchAll('SELECT name, grade FROM user_gang WHERE identifier = @identifier',
	{
		['@identifier'] = xPlayer.identifier
	})
	if result[1] and Config.Gangs[result[1].name] then
		return {name = result[1].name, label = Config.Gangs[result[1].name].Name, grade = result[1].grade}
	else
		return {}
	end
end

ESX.RegisterServerCallback('esx_ava_gang:getGang', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(GetGang(xPlayer))
end)

RegisterServerEvent('esx_ava_gang:gang_hire')
AddEventHandler('esx_ava_gang:gang_hire', function(target, gangName)
	local _source = source
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local targetGang = getGang(targetXPlayer)
	if not targetGang.name then
		MySQL.Sync.execute("INSERT INTO `user_gang`(`identifier`, `name`, `grade`) VALUES (@identifier, @name, 0)", {
			['@identifier'] = targetXPlayer.identifier,
			['@name'] = gangName
		})

		TriggerClientEvent('esx:showNotification', _source, "Vous avez ~g~recruté " .. target .. "~w~.")
	
		TriggerClientEvent('esx_ava_gang:setGang', target, {name = gangName, grade = 0})
		TriggerClientEvent('esx:showNotification', target, "Vous avez été ~g~embauché par " .. _source .. "~w~.")
	end
end)

RegisterServerEvent('esx_ava_gang:gang_fire')
AddEventHandler('esx_ava_gang:gang_fire', function(target, gangName)
	local _source = source
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local targetGang = getGang(targetXPlayer)
	if targetGang and targetGang.name == gangName then
		MySQL.Sync.execute("DELETE FROM `user_gang` WHERE identifier = @identifier", {
			['@identifier'] = targetXPlayer.identifier
		})

		TriggerClientEvent('esx:showNotification', _source, "Vous avez ~r~viré " .. target .. "~w~.")
		TriggerClientEvent('esx_ava_gang:setGang', target, {})
		TriggerClientEvent('esx:showNotification', target, "Vous avez été ~g~viré par " .. _source .. "~w~.")
	else
		TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas ~r~l'autorisation~w~.")
	end
end)


RegisterServerEvent('esx_ava_gang:gang_set_manage')
AddEventHandler('esx_ava_gang:gang_set_manage', function(target, gangName, grade)
	local _source = source
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local targetGang = getGang(targetXPlayer)
	if targetGang and targetGang.name == gangName then
		MySQL.Sync.execute("UPDATE `user_gang` SET `grade` = @grade WHERE `identifier` = @identifier", {
			['@identifier'] = targetXPlayer.identifier,
			['@grade'] = grade
		})

		TriggerClientEvent('esx_ava_gang:setGang', target, getGang(targetXPlayer))
		if grade == 1 then
			TriggerClientEvent('esx:showNotification', _source,  target .. " peut maintenant gérer les membres")
			TriggerClientEvent('esx:showNotification', target, "Vous pouvez maintenant gérer les membres de votre gang")
		else
			TriggerClientEvent('esx:showNotification', _source,  target .. " ne peut plus gérer les membres")
			TriggerClientEvent('esx:showNotification', target, "Vous ne pouvez plus gérer les membres de votre gang")
		end
	else
		TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas ~r~l'autorisation~w~.")
	end
end)

