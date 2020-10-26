-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'ems', _U('alert_ems'), true, true)
TriggerEvent('esx_society:registerSociety', 'ems', 'EMS', 'society_ems', 'society_ems', 'society_ems', {type = 'public'})

-- RegisterServerEvent('esx_ambulancejob:revive')
-- AddEventHandler('esx_ambulancejob:revive', function(target)
-- 	local xPlayer = ESX.GetPlayerFromId(source)
-- 	local xPlayers = ESX.GetPlayers()

-- 	local playerGroup = xPlayer.getGroup()
-- 	if xPlayer.job.name == 'ambulance' or (playerGroup ~= nil and (playerGroup == 'mod' or playerGroup == 'admin' or playerGroup == 'superadmin' or playerGroup == 'owner')) then
-- 		local societyAccount = nil
-- 		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ambulance', function(account)
-- 			societyAccount = account
-- 		end)
-- 		if societyAccount ~= nil then
-- 			xPlayer.addMoney(Config.ReviveReward)
-- 			TriggerClientEvent('esx_ambulancejob:revive', target)
-- 			societyAccount.addMoney(Config.ReviveReward)
-- 			print('EMS : '..Config.ReviveReward..'$ ajouté au coffre')
-- 		end
-- 		for i=1, #xPlayers, 1 do
-- 			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
-- 			if xPlayer.job.name == 'ambulance' then
-- 				TriggerClientEvent('esx_ambulancejob:notif', xPlayers[i])
-- 			end
-- 		end
-- 	else
-- 		print(('esx_ambulancejob: %s attempted to revive!'):format(xPlayer.identifier))
-- 	end
-- end)

RegisterServerEvent('esx_ambulancejob:revive2')
AddEventHandler('esx_ambulancejob:revive2', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	TriggerClientEvent('esx_ambulancejob:revive2', target)
end)

ESX.RegisterServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if Config.RemoveCashAfterRPDeath then
		if xPlayer.getMoney() > 0 then
			xPlayer.removeMoney(xPlayer.getMoney())
		end

		if xPlayer.getAccount('black_money').money > 0 then
			xPlayer.setAccountMoney('black_money', 0)
		end
	end

	if Config.RemoveItemsAfterRPDeath then
		for i=1, #xPlayer.inventory, 1 do
			if xPlayer.inventory[i].count > 0 then
				xPlayer.setInventoryItem(xPlayer.inventory[i].name, 0)
			end
		end
	end

	local playerLoadout = {}
	if Config.RemoveWeaponsAfterRPDeath then
		for i=1, #xPlayer.loadout, 1 do
			xPlayer.removeWeapon(xPlayer.loadout[i].name)
		end
	else -- save weapons & restore em' since spawnmanager removes them
		for i=1, #xPlayer.loadout, 1 do
			table.insert(playerLoadout, xPlayer.loadout[i])
		end

		-- give back wepaons after a couple of seconds
		Citizen.CreateThread(function()
			Citizen.Wait(5000)
			for i=1, #playerLoadout, 1 do
				if playerLoadout[i].label ~= nil then
					xPlayer.addWeapon(playerLoadout[i].name, playerLoadout[i].ammo)
				end
			end
		end)
	end

	cb()
end)


TriggerEvent('es:addGroupCommand', 'revive', 'mod', function(source, args, user)
	if args[1] ~= nil then
		if GetPlayerName(tonumber(args[1])) ~= nil then
			print(('esx_ambulancejob: %s used admin revive'):format(GetPlayerIdentifiers(source)[1]))
			TriggerClientEvent('esx_ambulancejob:revive2', tonumber(args[1]))
		end
	else
		TriggerClientEvent('esx_ambulancejob:revive2', source)
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, { help = _U('revive_help'), params = {{ name = 'id' }} })


ESX.RegisterUsableItem('medikit', function(source)
	-- if not playersHealing[source] then
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('medikit', 1)

		playersHealing[source] = true
		-- TriggerClientEvent('esx_ambulancejob:useItem', source, 'medikit')

		Citizen.Wait(10000)
		-- playersHealing[source] = nil
	-- end
end)

ESX.RegisterUsableItem('bandage', function(source)
	-- if not playersHealing[source] then
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('bandage', 1)
	
		-- playersHealing[source] = true
		TriggerClientEvent('esx_ambulancejob:useItem', source, 'bandage')

		Citizen.Wait(10000)
		-- playersHealing[source] = nil
	-- end
end)

ESX.RegisterServerCallback('esx_ambulancejob:getDeathStatus', function(source, cb)
	local identifier = GetPlayerIdentifiers(source)[1]

	MySQL.Async.fetchScalar('SELECT is_dead FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(isDead)
		if isDead then
			print(('esx_ambulancejob: %s attempted combat logging!'):format(identifier))
		end

		cb(isDead)
	end)
end)

RegisterServerEvent('esx_ambulancejob:setDeathStatus')
AddEventHandler('esx_ambulancejob:setDeathStatus', function(isDead)
	local identifier = GetPlayerIdentifiers(source)[1]

	if type(isDead) ~= 'boolean' then
		print(('esx_ambulancejob: %s attempted to parse something else than a boolean to setDeathStatus!'):format(identifier))
		return
	end

	MySQL.Sync.execute('UPDATE users SET is_dead = @isDead WHERE identifier = @identifier', {
		['@identifier'] = identifier,
		['@isDead'] = isDead
	})
end)
