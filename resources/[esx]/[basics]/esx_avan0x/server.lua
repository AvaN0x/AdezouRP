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

RegisterCommand('sendskin', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll(
	  'SELECT * FROM users WHERE identifier = @identifier',
	  {
		['@identifier'] = xPlayer.identifier
	  },
	  function(users)
		local user = users[1]
		
		if user.skin ~= nil then
			local skin = {}
			for k,v in pairs(json.decode(user.skin)) do
				if k == "tshirt_1"
				or k == "tshirt_2"
				or k == "torso_1"
				or k == "torso_2"
				or k == "pants_1"
				or k == "pants_2"
				or k == "shoes_1"
				or k == "shoes_2"
				or k == "chain_1"
				or k == "chain_2"
				or k == "bags_1"
				or k == "bags_2"
				or k == "bproof_1"
				or k == "bproof_2"
				or k == "helmet_1"
				or k == "helmet_2"
				or k == "arms"
				or k == "glasses_1"
				or k == "glasses_2"
				then
					table.insert(skin, k..":"..v)
				end
			end

			local skinjson = "{"..table.concat(skin, ",").."}"
			print(skinjson)
			SendWebhookMessage("```json\n"..skinjson.."```")
		end  
	  end)

end)

function SendWebhookMessage(message)
	webhook = GetConvar("avan0x_webhook", "none")
	if webhook ~= "none" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end
