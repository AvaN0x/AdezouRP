-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local playersPickUpCount = {}
local playersProcessing = {}

Citizen.CreateThread(function()
    for jobName, job in pairs(Config.Jobs) do
        TriggerEvent('esx_phone:registerNumber', jobName, _('job_client', job.LabelName), true, true)
        TriggerEvent('esx_society:registerSociety', jobName, Config.LabelName, job.SocietyName, job.SocietyName, job.SocietyName, {type = 'private'})
    end
end)



AddEventHandler('onMySQLReady', function()
    -- This need to have a reboot at 8 am
    local timestamp = os.time()
    local hour = tonumber(os.date('%H', timestamp))
    if hour == 8 then
        MySQL.Async.execute('DELETE FROM `user_pickups_count`')
    end
end)

RegisterServerEvent("esx_ava_jobs:savePickUpCounts")
AddEventHandler("esx_ava_jobs:savePickUpCounts", function()
	for identifier, pickupCount in pairs(playersPickUpCount) do
        if pickupCount.modified == true then
            MySQL.Async.execute('INSERT INTO user_pickups_count (identifier, count) VALUES (@identifier, @count) ON DUPLICATE KEY UPDATE count = @count', {
                ['@identifier'] = identifier;
                ['@count'] = pickupCount.count
            })
            pickupCount.modified = false
        end
    end
end)




-------------
-- RECOLTE --
-------------

ESX.RegisterServerCallback('esx_ava_jobs:canPickUp', function(source, cb, jobName, zoneName)
	local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.getInventory()
	local result = false

    local job = Config.Jobs[jobName]
    local zone = job.FieldZones[zoneName]

    if zone then
        if not playersPickUpCount[xPlayer.identifier] then
            playersPickUpCount[xPlayer.identifier] = {
                count = Config.MaxPickUp,
                modified = false
            }
        end

        if playersPickUpCount[xPlayer.identifier].count > 0 then
            for k, item in ipairs(zone.Items) do
                if inventory.canTake(item.name) > 0 then
                    result = true
                end
            end
        else
            result = "max_count"
        end
    end
    cb(result)
end)

RegisterServerEvent('esx_ava_jobs:pickUp')
AddEventHandler('esx_ava_jobs:pickUp', function(jobName, zoneName)
	local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.getInventory()

    local job = Config.Jobs[jobName]
    local zone = job.FieldZones[zoneName]

    if zone then
        for k, item in ipairs(zone.Items) do
            local canTake = inventory.canTake(item.name)
            if canTake > 0 then
                inventory.addItem(item.name, (canTake > item.quantity and item.quantity or canTake))
            end
        end
        playersPickUpCount[xPlayer.identifier].modified = true
        playersPickUpCount[xPlayer.identifier].count = playersPickUpCount[xPlayer.identifier].count - 1
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




-------------
-- selling --
-------------


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
                TriggerEvent('esx_avan0x:logTransaction', xPlayer.identifier, 'money', "society_state", "society_state", "interim_selling", stateMoney)

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
			TriggerEvent('esx_avan0x:logTransaction', xPlayer.identifier, 'money', job.SocietyName, job.SocietyName, "job_selling", tonumber(playerMoney + societyMoney))
			TriggerEvent('esx_avan0x:logTransaction', job.SocietyName, job.SocietyName, xPlayer.identifier, 'money', "job_selling", societyMoney)

			xPlayer.addMoney(playerMoney)
			societyAccount.addMoney(societyMoney)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _('have_earned') .. playerMoney)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _('comp_earned') .. societyMoney)
		end
    else
        print(('%s attempted to exploit processing!'):format(GetPlayerIdentifiers(source)[1]))
    end
end)

ESX.RegisterServerCallback('esx_ava_jobs:GetSellElements', function(source, cb, jobName, zoneName)
	local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.getInventory()
    local job = Config.Jobs[jobName]
    local zone = job.SellZones[zoneName]

    if zone then
        local elements = {}
        for k, v in pairs(zone.Items) do
            local item = inventory.getItem(v.name)

            table.insert(elements, {
                itemLabel = item.label,
                label = _('sell_label', item.label, item.count),
                price = v.price,
                name = v.name,
                owned = item.count
            })
        end
        cb(elements)
    end
end)






------------
-- buying --
------------

RegisterNetEvent('esx_ava_jobs:BuyItem')
AddEventHandler('esx_ava_jobs:BuyItem', function(jobName, zoneName, item, count)
	local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.getInventory()
    local job = Config.Jobs[jobName]
    local zone = job.BuyZones[zoneName]

    if zone then
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

        local totalprice = tonumber(count)*tonumber(price)
        
        if not inventory.canAddItem(item, count) then
            TriggerClientEvent('esx:showNotification', source, _('buy_cant_carry'))
        elseif xPlayer.getMoney() < totalprice then
            TriggerClientEvent('esx:showNotification', source, _('buy_cant_afford'))
        else
            TriggerEvent('esx_statejob:getTaxed', job.SocietyName, totalprice, function(toSociety)
            end)
            
            xPlayer.removeMoney(totalprice)
            inventory.addItem(item, count)
            TriggerClientEvent('esx:showNotification', source, _('buy_you_paid')..totalprice)
        end
    else
        print(('%s attempted to exploit processing!'):format(GetPlayerIdentifiers(source)[1]))
    end
end)

ESX.RegisterServerCallback('esx_ava_jobs:GetBuyElements', function(source, cb, jobName, zoneName)
	local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.getInventory()

    local job = Config.Jobs[jobName]
    local zone = job.BuyZones[zoneName]

    if zone then
        local elements = {}
        for k,v in pairs(zone.Items) do
            local item = inventory.getItem(v.name)
            table.insert(elements, {itemLabel = item.label, label = _('buy_label', item.label, v.price), price = v.price, name = v.name})
        end
        cb(elements)
    end
end)





----------------
-- JOBS ITEMS --
----------------


--------------
-- Vigneron --
--------------

-- USE WOODEN BOXES
RegisterNetEvent('esx_ava_jobs:UseBox')
AddEventHandler('esx_ava_jobs:UseBox', function(source, itembox, item) 
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.getInventory()

	if not inventory.canAddItem(item, 6) or not inventory.canAddItem('woodenbox', 6) then
		TriggerClientEvent('esx:showNotification', source, _('buy_cant_carry'))
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