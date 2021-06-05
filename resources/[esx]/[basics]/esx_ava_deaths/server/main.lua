-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX = nil
local playersHealing = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_ava_deaths:revive')
AddEventHandler('esx_ava_deaths:revive', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ems' or xPlayer.job2.name  == 'ems' then
		local societyAccount = nil
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ems', function(account)
			societyAccount = account
		end)
		if societyAccount ~= nil then
			xPlayer.addMoney(Config.ReviveReward)
			TriggerClientEvent('esx_ava_deaths:revive', target)
			societyAccount.addMoney(Config.ReviveReward)
			print('EMS : ' .. Config.ReviveReward .. '$ ajouté au coffre')
		end
	else
		print(('esx_ava_deaths: %s attempted to revive!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('esx_ava_deaths:admin:revive')
AddEventHandler('esx_ava_deaths:admin:revive', function(target, debug)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	TriggerClientEvent('esx_ava_deaths:admin:revive', target, debug)
end)

ESX.RegisterServerCallback('esx_ava_deaths:getDeathStatus', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchScalar('SELECT is_dead FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(isDead)
		if isDead then
			print(('esx_ava_deaths: %s spawned dead!'):format(identifier))
		end

		cb(isDead)
	end)
end)

RegisterServerEvent('esx_ava_deaths:setDeathStatus')
AddEventHandler('esx_ava_deaths:setDeathStatus', function(isDead)
	local xPlayer = ESX.GetPlayerFromId(source)

	if type(isDead) ~= 'boolean' then
		print(('esx_ava_deaths: %s attempted to parse something else than a boolean to setDeathStatus!'):format(identifier))
		return
	end

	MySQL.Sync.execute('UPDATE users SET is_dead = @isDead WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier,
		['@isDead'] = isDead
	})
end)

RegisterServerEvent('esx_ava_deaths:uniteX')
AddEventHandler('esx_ava_deaths:uniteX', function(target, debug)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()

    local ems = 0
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if (xPlayer.job ~= nil and xPlayer.job.name == 'ems') or (xPlayer.job2 ~= nil and xPlayer.job2.name == 'ems') then
            ems = ems + 1
            break
        end
    end

    TriggerEvent('esx_billing:sendBillWithId', xPlayer.identifier, 'society_ems', "Unité X", ems > 0 and Config.RespawnFineAmount or Config.RespawnFineAmountNoEMS)
end)


TriggerEvent('es:addGroupCommand', 'revive', 'mod', function(source, args, user)
	if args[1] ~= nil then
		if GetPlayerName(tonumber(args[1])) ~= nil then
			print(('esx_ava_deaths: %s used admin revive'):format(GetPlayerIdentifiers(source)[1]))
			TriggerClientEvent('esx_ava_deaths:admin:revive', tonumber(args[1]))
		end
	else
		TriggerClientEvent('esx_ava_deaths:admin:revive', source)
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, { help = _U('revive_help'), params = {{ name = 'id' }} })
