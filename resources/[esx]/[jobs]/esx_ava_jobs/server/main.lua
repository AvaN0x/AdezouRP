-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local jobsServices = {}

local playersPickUpCount = {}
local playersProcessing = {}

Citizen.CreateThread(function()
    for jobName, job in pairs(Config.Jobs) do
        if not job.isIllegal and not job.isGang and not job.Disabled then
            TriggerEvent('esx_phone:registerNumber', jobName, _('job_client', job.LabelName), true, true)
            TriggerEvent('esx_society:registerSociety', jobName, Config.LabelName, job.SocietyName, job.SocietyName, job.SocietyName, {type = 'private'})
        end
    end
end)



AddEventHandler('onMySQLReady', function()
    -- This need to have a reboot at 8 am
    local timestamp = os.time()
    local hour = tonumber(os.date('%H', timestamp))
    if hour == 8 then
        MySQL.Async.execute('DELETE FROM `user_pickups_count`')
    else
        local result = MySQL.Sync.fetchAll('SELECT * FROM user_pickups_count')

        for i=1, #result, 1 do
            playersPickUpCount[result[i].identifier] = {
                count = result[i].count,
                illegalCount = result[i].illegalCount,
                modified = false
            }
        end
    end
end)

RegisterServerEvent("esx_ava_jobs:savePickUpCounts")
AddEventHandler("esx_ava_jobs:savePickUpCounts", function()
	for identifier, pickupCount in pairs(playersPickUpCount) do
        if pickupCount.modified == true then
            MySQL.Async.execute('INSERT INTO user_pickups_count (identifier, count, illegalCount) VALUES (@identifier, @count, @illegalCount) ON DUPLICATE KEY UPDATE count = @count, illegalCount = @illegalCount', {
                ['@identifier'] = identifier,
                ['@count'] = pickupCount.count,
                ['@illegalCount'] = pickupCount.illegalCount
            })
            pickupCount.modified = false
        end
    end
end)


RegisterServerEvent("esx_ava_jobs:setService")
AddEventHandler("esx_ava_jobs:setService", function(jobName, state)
	if not jobsServices[jobName] then
        jobsServices[jobName] = {}
    end
    jobsServices[jobName][source] = state and true or nil
end)

AddEventHandler('playerDropped', function(reason)
    local _source = source
    for jobName, v in pairs(jobsServices) do
        if v[source] ~= nil then
            jobsServices[jobName][source] = nil
        end
    end
end)

function getCountInService(job)
    local count = 0
    local xPlayers = ESX.GetPlayers()

    local debugString = ""

    if jobsServices[job] then
        for i = 1, #xPlayers do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if ((xPlayer.job ~= nil and xPlayer.job.name == job) or (xPlayer.job2 ~= nil and xPlayer.job2.name == job)) and jobsServices[job][xPlayers[i]] ~= nil then
                count = count + 1
                debugString = debugString .. tostring(xPlayers[i]) .. " "
            end
        end
    end

    exports.esx_avan0x:SendWebhookEmbedMessage("avan0x_wh_dev", "asked for count of " .. job, "ID des joueurs : " .. debugString .. "\ncount value : `" .. count .. "`", 15902015)

    return tonumber(count)
end

function isInService(source, job)
    return jobsServices[job] and jobsServices[job][source] == true or false
end

function hasJob(source, job)
    local xPlayer = ESX.GetPlayerFromId(source)

    return (xPlayer.job ~= nil and xPlayer.job.name == job) or (xPlayer.job2 ~= nil and xPlayer.job2.name == job)
end

function isInServiceOrHasJob(source, job)
    return isInService(source, job) or hasJob(source, job)
end

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
                illegalCount = Config.MaxPickUpIllegal,
                modified = false
            }
        end

        if (not job.isIllegal and playersPickUpCount[xPlayer.identifier].count <= 0) then
            result = "max_count"
        elseif (job.isIllegal and playersPickUpCount[xPlayer.identifier].illegalCount <= 0) then
            result = "max_countillegal"
        else
            for k, item in ipairs(zone.Items) do
                if inventory.canTake(item.name) > 0 then
                    result = true
                    break
                end
            end
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
        if not job.isIllegal then
            playersPickUpCount[xPlayer.identifier].count = playersPickUpCount[xPlayer.identifier].count - (zone.PickupCount or 1)
        else
            playersPickUpCount[xPlayer.identifier].illegalCount = playersPickUpCount[xPlayer.identifier].illegalCount - (zone.PickupCount or 1)
        end
    end
end)



----------------
-- TRAITEMENT --
----------------

local function canCarryAll(source, items)
	local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.getInventory()

	for i=1, #items, 1 do
        if not inventory.canAddItem(items[i].name, items[i].quantity) then
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

local function hasKey(source, keyName)
	local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.getInventory()

    local hasOne = inventory.getItem(keyName).count > 0

    if not hasOne then
        TriggerClientEvent('esx:showNotification', source, _U('dont_have_keychain'))
    end
    return hasOne
end

ESX.RegisterServerCallback('esx_ava_jobs:canprocess', function(source, cb, process, jobName)
    if not playersProcessing[source] then
        local job = Config.Jobs[jobName]
        if (job.isIllegal ~= true or not process.NeedKey or hasKey(source, job.KeyName))
            and hasEnoughItems(source, process.ItemsGive) and canCarryAll(source, process.ItemsGet)
        then
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
        print(('%s attempted to exploit selling!'):format(GetPlayerIdentifiers(source)[1]))
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
        local isIllegal = nil
        for k,v in ipairs(zone.Items) do
            if v.name == item then
                price = v.price
                isIllegal = v.isDirtyMoney
                break
            end
        end
        if price == nil then
            return
        end

        local totalprice = tonumber(count) * tonumber(price)
        
        if not inventory.canAddItem(item, count) then
            TriggerClientEvent('esx:showNotification', source, _('buy_cant_carry'))
        else
            if isIllegal == true then
                if xPlayer.getAccount('black_money').money < totalprice then
                    TriggerClientEvent('esx:showNotification', source, _('buy_cant_afford_dirty'))
                else
                    xPlayer.removeAccountMoney('black_money', totalprice)
                    inventory.addItem(item, count)
                    TriggerClientEvent('esx:showNotification', source, _('buy_you_paid_dirty', totalprice))
                end
            else
                if xPlayer.getMoney() < totalprice then
                    TriggerClientEvent('esx:showNotification', source, _('buy_cant_afford'))
                else
                    if job.SocietyName then
                        TriggerEvent('esx_statejob:getTaxed', job.SocietyName, totalprice, function(toSociety)
                        end)
                    end

                    xPlayer.removeMoney(totalprice)
                    inventory.addItem(item, count)
                    TriggerClientEvent('esx:showNotification', source, _('buy_you_paid', totalprice))
                end

            end
        end
    else
        print(('%s attempted to exploit buying!'):format(GetPlayerIdentifiers(source)[1]))
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




RegisterNetEvent('esx_ava_jobs:job_center:hire')
AddEventHandler('esx_ava_jobs:job_center:hire', function(index, jobSlot)
    local _source = source
    if index == nil or jobSlot == nil then
        return
    end
    local job = Config.JobCenter.JobList[index]
    local notificationText = _("job_center_error_happened")

    if job then
        local xPlayer = ESX.GetPlayerFromId(_source)
    
        if jobSlot == 1 then
            xPlayer.setJob(job.JobName, job.Grade or 0)
            notificationText = _("job_center_set_primary")

        elseif jobSlot == 2 then
            xPlayer.setJob2(job.Job2Name or job.JobName, job.Grade2 or job.Grade or 0)
            notificationText = _("job_center_set_secondary")

        end
    end


    TriggerClientEvent('esx:showNotification', _source, notificationText)	
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



----------
-- LSPD --
----------
ESX.RegisterServerCallback('esx_ava_jobs:getPlayerData', function(source, cb, target)
    local xPlayer = ESX.GetPlayerFromId(target)
    local result = MySQL.Sync.fetchAll('SELECT firstname, lastname, sex FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    })

    local data = {
        name = GetPlayerName(target),
        job = xPlayer.job,
        job2 = xPlayer.job2,
        firstname = result[1].firstname or "",
        lastname = result[1].lastname or "",
        sex = result[1].sex or 0,
    }

    TriggerEvent('esx_license:getLicenses', target, function(licenses)
        data.licenses = licenses
        print(ESX.DumpTable(data))
        cb(data)
    end)
end)

ESX.RegisterServerCallback('esx_ava_jobs:getVehicleInfos', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		local vehicleInfos = {
			plate = plate
		}

        if result[1] then
            local request = string.match(result[1].owner, '^society_.*$')
                and 'SELECT label as owner FROM addon_account WHERE name = @owner'
                or 'SELECT CONCAT(firstname, " ", lastname) as owner FROM users WHERE identifier = @owner'

			MySQL.Async.fetchAll(request, {
				['@owner'] = result[1].owner
			}, function(result2)
                vehicleInfos.owner = result2[1].owner

				cb(vehicleInfos)
			end)
        else
			cb(vehicleInfos)
		end
	end)
end)


---------
-- EMS --
---------
ESX.RegisterServerCallback('esx_ava_jobs:ems:getTargetData', function(source, cb, target)
    local data = {}

    TriggerEvent('esx_status:getStatus', target, 'injured', function(status)
        data.injured = math.floor(status.percent or 0)
        cb(data)
    end)
end)