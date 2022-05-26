-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX = nil
local playersHealing = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function getDeathStatus(identifier)
    return MySQL.Sync.fetchScalar('SELECT is_dead FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier
	})
end

ESX.RegisterServerCallback('esx_ava_deaths:getDeathStatus', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
    local isDead = getDeathStatus(xPlayer.identifier)

    if isDead then
        print(('esx_ava_deaths: %s spawned dead!'):format(xPlayer.identifier))
    end

    cb(isDead)
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

    local fineAmount = (exports.esx_ava_jobs:getCountInService(Config.EMSJobName) == 0 or exports.esx_ava_jobs:isInService(source, Config.EMSJobName))
        and Config.RespawnFineAmountNoEMS
        or Config.RespawnFineAmount

    TriggerEvent('esx_billing:sendBillWithId', xPlayer.identifier, 'society_ems', "Unité X", fineAmount)
end)


TriggerEvent('es:addGroupCommand', 'revive', 'mod', function(source, args, user)
    exports.esx_avan0x:SendWebhookEmbedMessage("avan0x_wh_staff_commands", "", GetPlayerName(source) .. " used admin revive", 15902015)
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


RegisterServerEvent('esx_ava_deaths:admin:revive')
AddEventHandler('esx_ava_deaths:admin:revive', function(target, debug)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	TriggerClientEvent('esx_ava_deaths:admin:revive', target, debug)
    print(('esx_ava_deaths: %s used admin revive'):format(GetPlayerIdentifiers(source)[1]))
    exports.esx_avan0x:SendWebhookEmbedMessage("avan0x_wh_staff_commands", "", GetPlayerName(source) .. " used admin revive", 15902015)
end)