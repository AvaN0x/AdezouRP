-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local playersProcessing = {}

Citizen.CreateThread(function()
    for jobName, job in pairs(Config.Jobs) do
        TriggerEvent('esx_phone:registerNumber', jobName, _U('job_client', job.LabelName), true, true)
        TriggerEvent('esx_society:registerSociety', jobName, Config.LabelName, job.SocietyName, job.SocietyName, job.SocietyName, {type = 'private'})
    end
end)








-- -------------
-- -- RECOLTE --
-- -------------


-- ESX.RegisterServerCallback('esx_ava_vigneronjob:canPickUp', function(source, cb, items)
-- 	local xPlayer = ESX.GetPlayerFromId(source)
-- 	local result = false
-- 	for i=1, #items, 1 do

-- 		local xItem = xPlayer.getInventoryItem(items[i].name)

-- 		if not (xItem.limit ~= -1 and xItem.count >= xItem.limit) then
-- 			if not result then
-- 				result = true
-- 			end
-- 		end
-- 	end
-- 	cb(result)
-- end)

-- RegisterServerEvent('esx_ava_vigneronjob:pickUp')
-- AddEventHandler('esx_ava_vigneronjob:pickUp', function(item)
-- 	local xPlayer = ESX.GetPlayerFromId(source)
-- 	local xItem = xPlayer.getInventoryItem(item.name)

-- 	if xItem.limit ~= -1 and (xItem.count + item.quantity) > xItem.limit then
-- 		if xItem.count < xItem.limit then
-- 			xPlayer.addInventoryItem(xItem.name, xItem.limit - xItem.count)
-- 		end
-- 	else
-- 		xPlayer.addInventoryItem(xItem.name, item.quantity)
-- 	end
-- end)



-- ----------------
-- -- TRAITEMENT --
-- ----------------

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
    local inventory = xPlayer.getInventory()

	local result = {}
	for i=1, #items, 1 do
		local xItem = inventory.getItem(items[i].name)
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

ESX.RegisterServerCallback('esx_ava_jobs:canprocess', function(source, cb, process)
    if not playersProcessing[source] then
		if hasEnoughItems(source, process.ItemsGive) and canCarryAll(source, process.ItemsGet) then
			cb(true)
		else
			cb(false)
		end
    else
        print(('%s attempted to exploit processing!'):format(GetPlayerIdentifiers(source)[1]))
    end
end)

RegisterServerEvent('esx_ava_jobs:process')
AddEventHandler('esx_ava_jobs:process', function(process)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local inventory = xPlayer.getInventory()

	playersProcessing[_source] = true

	Citizen.Wait(process.Delay)
	for i=1, #process.ItemsGive, 1 do
		inventory.removeItem(process.ItemsGive[i].name, process.ItemsGive[i].quantity)
	end
	for i=1, #process.ItemsGet, 1 do
		inventory.addItem(process.ItemsGet[i].name, process.ItemsGet[i].quantity)
	end


	playersProcessing[_source] = nil
end)


function CancelProcessing(playerID)
	if playersProcessing[playerID] then
		playersProcessing[playerID] = nil
	end
end

RegisterServerEvent('esx_ava_jobs:cancelProcessing')
AddEventHandler('esx_ava_jobs:cancelProcessing', function()
	CancelProcessing(source)
end)

AddEventHandler('esx:playerDropped', function(playerID, reason)
	CancelProcessing(playerID)
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	CancelProcessing(source)
end)




-- -------------
-- -- selling --
-- -------------


RegisterNetEvent('esx_ava_jobs:SellItems')
AddEventHandler('esx_ava_jobs:SellItems', function(jobName, zoneName, jobIndex, item, count) 
	local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.getInventory()
    local job = Config.Jobs[jobName]
    local zone = job.SellZones[zoneName]

	if zone and inventory.canRemoveItem(item, count) then
        local price = nil
        for k,v in ipairs(zone.Items) do
            if v.name == item then
                price = v.price
                break
            end
        end
        if price == nil then
            return
        end

		local totalFromSell = tonumber(count) * tonumber(price)
		local total = nil
		TriggerEvent('esx_statejob:getTaxed', job.SocietyName, totalFromSell, function(toSociety)
			total = toSociety
		end)
		local playerMoney
		local societyMoney

		-- if he is an interim, he must earn less than the society
		if xPlayer['job' .. (jobIndex ~= 1 and jobIndex or '')].grade_name == 'interim' then
			playerMoney = math.floor(total * 0.2)
			societyMoney = math.floor(total * 0.4)
			local stateMoney = math.floor(total * 0.4)

            local stateAccount = nil
            TriggerEvent('esx_addonaccount:getSharedAccount', "society_state", function(account)
                stateAccount = account
            end)
            if stateAccount ~= nil then
                TriggerEvent('esx_avan0x:logTransaction', xPlayer.identifier, xPlayer.identifier, "society_state", "society_state", "interim_selling", stateMoney)

                stateAccount.addMoney(stateMoney)
            end
		else
			playerMoney = math.floor(total / 100 * 60)
			societyMoney = math.floor(total / 100 * 40)
		end

		inventory.removeItem(item, count)

		local societyAccount = nil

		TriggerEvent('esx_addonaccount:getSharedAccount', job.SocietyName, function(account)
			societyAccount = account
		end)
		if societyAccount ~= nil then
			TriggerEvent('esx_avan0x:logTransaction', xPlayer.identifier, xPlayer.identifier, job.SocietyName, job.SocietyName, "job_selling", societyMoney)

			xPlayer.addMoney(playerMoney)
			societyAccount.addMoney(societyMoney)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _('have_earned') .. playerMoney)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _('comp_earned') .. societyMoney)
		end
	end
end)

ESX.RegisterServerCallback('esx_ava_jobs:GetSellElements', function(source, cb, items)
	local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.getInventory()

    local elements = {}
	for k, v in pairs(items) do
		local item = inventory.getItem(v.name)

		table.insert(elements, {
            itemLabel = item.label,
            label = item.label .. ' : ' .. item.count .. ' unité(s)',
            price = v.price,
            name = v.name,
            owned = item.count
        })
	end
	cb(elements)
end)






-- ------------
-- -- buying --
-- ------------


-- RegisterNetEvent('esx_ava_vigneronjob:BuyItems')
-- AddEventHandler('esx_ava_vigneronjob:BuyItems', function(item,price,count) 
-- 	local xPlayer = ESX.GetPlayerFromId(source)
-- 	while not xPlayer do 
-- 		xPlayer = ESX.GetPlayerFromId(source); 
-- 		Citizen.Wait(0); 
-- 	end
-- 	local xItem = xPlayer.getInventoryItem(item)
-- 	local totalprice = tonumber(count)*tonumber(price)

-- 	if xItem.limit ~= -1 and (xItem.count + count) > xItem.limit then
-- 		TriggerClientEvent('esx:showNotification', source, _U('buy_cant_carry'))
-- 	elseif (xPlayer.getMoney() < totalprice) then
-- 		TriggerClientEvent('esx:showNotification', source, _U('buy_cant_afford'))
-- 	else
-- 		TriggerEvent('esx_statejob:getTaxed', Config.SocietyName, totalprice, function(toSociety)
-- 		end)    
-- 		xPlayer.removeMoney(totalprice)
-- 		xPlayer.addInventoryItem(item, count)
-- 		TriggerClientEvent('esx:showNotification', source, _U('buy_you_paid')..totalprice)
-- 	end
-- end)

-- ESX.RegisterServerCallback('esx_ava_vigneronjob:GetBuyElements', function(source, cb, items) 
-- 	local xPlayer = ESX.GetPlayerFromId(source)
-- 	while not xPlayer do 
-- 		xPlayer = ESX.GetPlayerFromId(source); 
-- 		Citizen.Wait(0); 
-- 	end

-- 	local elements = {}
-- 	for k,v in pairs(items) do
-- 		local item = xPlayer.getInventoryItem(v.name)
-- 		table.insert(elements, {itemLabel = item.label, label = item.label..' : $'..v.price, price = v.price, name = v.name})
-- 	end
-- 	cb(elements)
-- end)




-- USE WOODEN BOXES
RegisterNetEvent('esx_ava_jobs:UseBox')
AddEventHandler('esx_ava_jobs:UseBox', function(source, itembox, item) 
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.getInventory()

	if not inventory.canAddItem(item, 6) or not inventory.canAddItem('woodenbox', 6) then
		TriggerClientEvent('esx:showNotification', source, _U('buy_cant_carry'))
	else
		inventory.removeItem(itembox, 1)
		inventory.addItem(item, 6)
		inventory.addItem('woodenbox', 1)
	end
end)

ESX.RegisterUsableItem('vinebox', function(source)
	TriggerEvent('esx_ava_jobs:UseBox', source, 'vinebox', 'vine')
end)

ESX.RegisterUsableItem('jus_raisinbox', function(source)
	TriggerEvent('esx_ava_jobs:UseBox', source, 'jus_raisinbox', 'jus_raisin')
end)

ESX.RegisterUsableItem('champagnebox', function(source)
	TriggerEvent('esx_ava_jobs:UseBox', source, 'champagnebox', 'champagne')
end)

ESX.RegisterUsableItem('grand_crubox', function(source)
	TriggerEvent('esx_ava_jobs:UseBox', source, 'grand_crubox', 'grand_cru')
end)