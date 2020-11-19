-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--? 1 is main key
--? 2 is double key

AddEventHandler('onMySQLReady', function()
	MySQL.Async.execute('DELETE FROM owned_keys WHERE type = @type',
	{
		['@type'] = 2
	})
end)


function GetKeys(xPlayer)
	if not xPlayer or not xPlayer.identifier then
		return {}
	end
    local result = MySQL.Sync.fetchAll('SELECT plate, type FROM owned_keys WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	})
	if result[1] then
        return result
	end
	return {}
end

RegisterServerEvent('esx_ava_keys:deleteKeys')
AddEventHandler('esx_ava_keys:deleteKeys', function(plate)
	MySQL.Async.execute('DELETE FROM `owned_keys` WHERE plate = @plate', {
		['@plate'] = plate
	})
	TriggerClientEvent('esx_ava_keys:requestNewKeys', -1, plate)
end)

RegisterServerEvent('esx_ava_keys:requestKeys')
AddEventHandler('esx_ava_keys:requestKeys', function()
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent('esx_ava_keys:setKeys', _source, GetKeys(xPlayer))
end)


RegisterServerEvent('esx_ava_keys:giveKey')
AddEventHandler('esx_ava_keys:giveKey', function(plate, type, target)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(target or _source)
	if not OwnKey(xPlayer, plate, type) then
		MySQL.Async.execute('INSERT INTO `owned_keys`(`identifier`, `plate`, `type`) VALUES (@identifier, @plate, @type)', {
			['@identifier'] = xPlayer.identifier,
			['@plate'] = plate,
			['@type'] = type
		}, function(rowsChanged)
			TriggerClientEvent('esx_ava_keys:setKeys', target or _source, GetKeys(xPlayer))
			TriggerClientEvent('esx:showNotification', target or _source, _U('received_new_key', plate))
			if target then
				TriggerClientEvent('esx:showNotification', _source, _U('gave_double_of_key'))
			end
		end)
	end
end)

function OwnKey(xPlayer, plate, type)
	if not xPlayer or not xPlayer.identifier then
		return true -- if xPlayer is null, then we don't want to do anything on it
	end
    local result = MySQL.Sync.fetchAll('SELECT plate, type FROM owned_keys WHERE identifier = @identifier AND plate = @plate', {
		['@identifier'] = xPlayer.identifier,
		['@plate'] = plate
	})
	if result[1] then
		if result[1].type <= type then
			return true
		else
			MySQL.Async.execute('DELETE FROM `owned_keys` WHERE identifier = @identifier AND plate = @plate', {
				['@identifier'] = xPlayer.identifier,
				['@plate'] = plate
			})
			return false
		end
	end
	return false
end

RegisterServerEvent('esx_ava_keys:giveOwnerShip')
AddEventHandler('esx_ava_keys:giveOwnerShip', function(plate, target)
	local _source = source
	local _target = target
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xTarget = ESX.GetPlayerFromId(_target)
	MySQL.Async.execute('UPDATE `owned_keys` SET `identifier`= @identifier WHERE `type` = 1 AND `plate` = @plate', {
		['@identifier'] = xTarget.identifier,
		['@plate'] = plate
	}, function(rowsChanged)
		MySQL.Async.execute('UPDATE `owned_vehicles` SET `owner`= @identifier WHERE `plate` = @plate', {
			['@identifier'] = xTarget.identifier,
			['@plate'] = plate
		}, function(rowsChanged)
			MySQL.Async.execute('DELETE FROM `owned_keys` WHERE type<>1 AND plate = @plate', {
				['@plate'] = plate
			}, function(rowsChanged)
				print(_source)
				print(_target)
				TriggerClientEvent('esx_ava_keys:setKeys', _source, GetKeys(xPlayer))
				TriggerClientEvent('esx:showNotification', _source, _('no_longer_owner_of'))
				TriggerClientEvent('esx_ava_keys:setKeys', _target, GetKeys(xTarget))
				TriggerClientEvent('esx:showNotification', _target, _('new_owner_of', plate))
			end)
		end)
	end)
end)
