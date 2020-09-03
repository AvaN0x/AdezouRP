ESX = nil
local playersProcessing = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('caruby_mining:sell')
AddEventHandler('caruby_mining:sell', function(itemName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = config.items[itemName]
	local xItem = xPlayer.getInventoryItem(itemName)

	if not price then
		print(('caruby_mining: %s attempted to sell an invalid!'):format(xPlayer.identifier))
		return
	end

	if xItem.count < amount then
		return
	end

	price = ESX.Math.Round(price * amount)
    local total = nil
    TriggerEvent('esx_statejob:getTaxed', 'MINERAIS', price, function(toSociety)
        total = toSociety
    end)

	xPlayer.addMoney(price)
	-- xPlayer.addMoney(total)

	xPlayer.removeInventoryItem(xItem.name, amount)

end)

RegisterServerEvent('caruby_mining:pickedUpStone')
AddEventHandler('caruby_mining:pickedUpStone', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('stone')

	if xItem.limit ~= -1 and (xItem.count + 1) > xItem.limit then
		--
	else
		xPlayer.addInventoryItem(xItem.name, math.random(1, 5))
	end
end)

ESX.RegisterServerCallback('caruby_mining:canPickUp', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem(item)

	if xItem.limit ~= -1 and xItem.count >= xItem.limit then
		cb(false)
	else
		cb(true)
	end
end)
ESX.RegisterServerCallback('caruby_mining:canDrill', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem('drill')

	if xItem.count >= 1 then
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('caruby_mining:processStone')
AddEventHandler('caruby_mining:processStone', function()
	if not playersProcessing[source] then
		local _source = source

		playersProcessing[_source] = ESX.SetTimeout(10000, function()
			
			local xPlayer = ESX.GetPlayerFromId(_source)
			local xStone, xIron = xPlayer.getInventoryItem('stone'), xPlayer.getInventoryItem('copper'), xPlayer.getInventoryItem('iron'), xPlayer.getInventoryItem('gold'), xPlayer.getInventoryItem('diamond')
			local xMine = math.random(1, 1000)
			if xIron.limit ~= -1 and (xIron.count + 1) > xIron.limit then
				--
			elseif xStone.count < 1 then
				--
			else
				if(xMine >= 1 and xMine < 700) then
				xPlayer.removeInventoryItem('stone', 1)
				xPlayer.addInventoryItem('copper', 1)
				elseif(xMine >= 700 and xMine < 800) then
				xPlayer.removeInventoryItem('stone', 1)
				xPlayer.addInventoryItem('iron', 1)
				elseif(xMine >= 800 and xMine < 950) then
				xPlayer.removeInventoryItem('stone', 1)
				xPlayer.addInventoryItem('gold', 1)
				elseif(xMine >= 950 and xMine < 1000) then
				xPlayer.removeInventoryItem('stone', 1)
				xPlayer.addInventoryItem('diamond', 1)
				end
			end

			playersProcessing[_source] = nil
		end)
	else
		print(('caruby_mining: %s attempted to exploit!'):format(GetPlayerIdentifiers(source)[1]))
	end
end)

function CancelProcessing(playerID)
	if playersProcessing[playerID] then
		ESX.ClearTimeout(playersProcessing[playerID])
		playersProcessing[playerID] = nil
	end
end

RegisterServerEvent('caruby_mining:cancelProcessing')
AddEventHandler('caruby_mining:cancelProcessing', function()
	CancelProcessing(source)
end)

AddEventHandler('esx:playerDropped', function(playerID, reason)
	CancelProcessing(playerID)
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	CancelProcessing(source)
end)
