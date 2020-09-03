-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_avan0x:logTransaction')
AddEventHandler('esx_avan0x:logTransaction', function(identifier_origin, account_origin, identifier_target, account_target, type, amount)
	MySQL.Async.execute('INSERT INTO `accounts_logs` (identifier_origin, account_origin, identifier_target, account_target, type, amount) VALUES (@identifier_origin, @account_origin, @identifier_target, @account_target, @type, @amount)', {
		['@identifier_origin'] = identifier_origin,
		['@account_origin'] = account_origin,
		['@identifier_target'] = identifier_target,
		['@account_target'] = account_target,
		['@type']   = type,
		['@amount'] = amount
	}, function(rowsChanged)
	end)

end)
