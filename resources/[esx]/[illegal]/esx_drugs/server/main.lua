ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_illegal:canPickUp', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem(item)

	if xItem.limit ~= -1 and xItem.count >= xItem.limit then
		cb(false)
	else
		cb(true)
	end
end)



ESX.RegisterServerCallback('asEnoughMoney', function(source, cb, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    if (xPlayer.getMoney() >= price) then
		xPlayer.removeMoney(price)
		cb(true)
	else
		cb(false)
    end
end)