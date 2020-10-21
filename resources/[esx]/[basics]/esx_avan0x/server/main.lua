-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_avan0x:getUsergroup', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer ~= nil then
		local playerGroup = xPlayer.getGroup()

        if playerGroup ~= nil then 
            cb(playerGroup)
        else
            cb(nil)
        end
	else
		cb(nil)
	end
end)


function SendWebhookMessage(webhookName, message)
	local webhook = GetConvar(webhookName, "none")
	if webhook ~= "none" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json'})
	end
end

function SendWebhookEmbedMessage(webhookName, title, description, color)
	local webhook = GetConvar(webhookName, "none")
	if webhook ~= "none" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode(
			{
				embeds = {
					{
						title = title,
						description = description,
						color = color
					}
				}
			}), { ['Content-Type'] = 'application/json'})
	end
end



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

TriggerEvent('es:addGroupCommand', 'sendskin', 'user', function(source, args)
	local xPlayer = ESX.GetPlayerFromId(source)
	local msg = table.concat(args, " ") or ""

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
					table.insert(skin, "\""..k.."\":"..v)
				end
			end

			local skinjson = "{"..table.concat(skin, ",").."}"
			print(skinjson)
			SendWebhookEmbedMessage("avan0x_wh_staff", "", "**" .. user.firstname.." "..user.lastname.."** ||"..user.identifier.."|| : \n"..msg.."```json\n"..skinjson.."```", 16773561)
		end
	end)
end, function(source, args)
	TriggerClientEvent('chat:addMessage', source, {args = {'^1SYSTEM', 'Insufficient Permissions.'}})
end, {
	help = "Envoyer votre tenue au staff", 
	params = {
		{
			name = "message", 
			help = "Message descriptif pour la tenue"
		}
	}
})

RegisterServerEvent('esx_avan0x:useWeaponItem')
AddEventHandler('esx_avan0x:useWeaponItem', function(weaponName)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem   = xPlayer.getInventoryItem(string.lower(weaponName))
	if xItem then
		if xItem.limit ~= -1 and xItem.count >= xItem.limit then
			TriggerClientEvent('esx:showNotification', source, "Vous n'avez plus de place pour cela")
		else
			xPlayer.addInventoryItem(string.lower(weaponName), 1)
			xPlayer.removeWeapon(weaponName)
		end
	else
		TriggerClientEvent('esx:showNotification', source, "Vous ne pouvez pas faire cela")
		SendWebhookMessage("L'arme `" .. weaponName .. "` n'est pas un item")
	end
end)
