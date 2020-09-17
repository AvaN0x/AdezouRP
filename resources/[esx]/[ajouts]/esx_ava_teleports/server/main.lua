ESX = nil
local teleporterInfo = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_ava_teleports:updateState')
AddEventHandler('esx_ava_teleports:updateState', function(tpID, state)
	local xPlayer = ESX.GetPlayerFromId(source)

	if type(tpID) ~= 'number' then
		print(('esx_ava_teleports: %s didn\'t send a number!'):format(xPlayer.identifier))
		return
	end

	if type(state) ~= 'boolean' then
		print(('esx_ava_teleports: %s attempted to update invalid state!'):format(xPlayer.identifier))
		return
	end

	if not Config.Teleporters[tpID] then
		print(('esx_ava_teleports: %s attempted to update invalid door!'):format(xPlayer.identifier))
		return
	end

	teleporterInfo[tpID] = state

	TriggerClientEvent('esx_ava_teleports:setState', -1, tpID, state)
end)

ESX.RegisterServerCallback('esx_ava_teleports:getTeleporterInfo', function(source, cb)
	cb(teleporterInfo)
end)

