-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function trim(s)
    return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

local formattedToken

function DiscordRequest(method, endpoint, jsondata)
    local data = nil
    PerformHttpRequest("https://discordapp.com/api/"..endpoint, function(errorCode, resultData, resultHeaders)
			data = {data=resultData, code=errorCode, headers=resultHeaders}
		end,
		method, #jsondata > 0 and json.encode(jsondata) or "",
		{["Content-Type"] = "application/json", ["Authorization"] = formattedToken})

    while data == nil do
        Citizen.Wait(0)
    end

    return data
end

--? init thread
Citizen.CreateThread(function()
	local botToken = GetConvar("avan0x_bot_token", "avan0x_bot_token")
	if botToken ~= "avan0x_bot_token" then
		formattedToken = "Bot " .. botToken
	else
		print("You need to use \"set avan0x_bot_token 'YOUR BOT TOKEN'\" in your server.cfg.")
	end
end)

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
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), {['Content-Type'] = 'application/json'})
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
			}), {['Content-Type'] = 'application/json'})
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


--? sendskin command
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
        if xPlayer.hasWeapon(weaponName) then
            if xItem.limit ~= -1 and xItem.count >= xItem.limit then
                TriggerClientEvent('esx:showNotification', source, "Vous n'avez plus de place pour cela")
            else
                xPlayer.addInventoryItem(string.lower(weaponName), 1)
                xPlayer.removeWeapon(weaponName)
            end
        else
            TriggerClientEvent('esx:showNotification', source, "Vous ne pouvez pas faire cela")
        end
	else
		TriggerClientEvent('esx:showNotification', source, "Vous ne pouvez pas faire cela")
		SendWebhookMessage("L'arme `" .. weaponName .. "` n'est pas un item")
	end
end)


--? death verification
local deathCauses = {
	Suicide = { Label = "Suicide", Hash = {0} },
	Melee = { Label = "Melee", Hash = {-1569615261, 1737195953, 1317494643, -1786099057, 1141786504, -2067956739, -868994466, -538741184} },
	Bullet = { Label = "Bullet", Hash = {-86904375, 453432689, 1593441988, 584646201, -1716589765, 324215364, 736523883, -270015777, -1074790547, -2084633992, -1357824103, -1660422300, 2144741730, 487013001, 2017895192, -494615257, -1654528753, 100416529, 205991906, 1119849093, -1076751822, -1045183535} },
	Knife = { Label = "Knife", Hash = {-1716189206, 1223143800, -1955384325, -1833087301, 910830060} },
	Car = { Label = "Car", Hash = {133987706, -1553120962} },
	Animal = { Label = "Animal", Hash = {-100946242, 148160082} },
	FallDamage = { Label = "FallDamage", Hash = {-842959696} },
	Explosion = { Label = "Explosion", Hash = {-1568386805, 1305664598, -1312131151, 375527679, 324506233, 1752584910, -1813897027, 741814745, -37975472, 539292904, 341774354, -1090665087, -1355376991} },
	Gas = { Label = "Gas", Hash = {-1600701090} },
	Burn = { Label = "Burn", Hash = {615608432, 883325847, -544306709} },
	Drown = { Label = "Drown", Hash = {-10959621, 1936677264} }
}

RegisterServerEvent("esx:onPlayerDeath")
AddEventHandler("esx:onPlayerDeath", function(data)
	local _source = source
	local deathCauseLabel = GetDeathCauseLabel(data.deathCause)
	if data.killedByPlayer then
		TriggerEvent('esx_ava_personalmenu:notifStaff', "~r~" .. GetPlayerName(_source) .. "~s~ got killed by " .. GetPlayerName(data.killerServerId) .. " with " .. deathCauseLabel .. ".")
		SendWebhookEmbedMessage("avan0x_wh_deaths", "", GetPlayerName(_source) .. " got killed by " .. GetPlayerName(data.killerServerId) .. " with " .. deathCauseLabel .. " (`" .. data.deathCause .. "`) at distance : " .. data.distance, 16711680) -- #ff0000
	else
		TriggerEvent('esx_ava_personalmenu:notifStaff', "~r~" .. GetPlayerName(_source) .. "~s~ died from " .. deathCauseLabel .. ".")
		SendWebhookEmbedMessage("avan0x_wh_deaths", "", GetPlayerName(_source) .. " died from " .. deathCauseLabel .. " (`" .. data.deathCause .. "`).", 16711680) -- #ff0000
	end
end)

function GetDeathCauseLabel(deathCause)
	for _, v in pairs(deathCauses) do
		for __, v_ in ipairs(v.Hash) do
			if v_ == deathCause then
				return v.Label
			end
		end
	end
	return deathCause
end


-- TODO set this as convar
local LifeInvaderChannelID = 831508116234960906
local lastID = nil
--? life invader check last messages
Citizen.CreateThread(function()
    while true do
        local channel = DiscordRequest("GET", "channels/" .. LifeInvaderChannelID, {})
        if channel.code == 200 then
			local chanData = json.decode(channel.data)
			if lastID == nil then
				lastID = chanData.last_message_id
			elseif lastID ~= chanData.last_message_id then
				lastID = chanData.last_message_id
				local lastMessage = DiscordRequest("GET", "channels/" .. LifeInvaderChannelID .. "/messages/" .. lastID, {})
				if lastMessage.code == 200 then
					local data = json.decode(lastMessage.data)
					if not data.webhook_id then
						local message = trim(data.content)
						if #message > 1 then
							local name = data.author.username .. "#" .. data.author.discriminator
							for k, file in ipairs(data.attachments) do
								if file.width then
									message = message .. "\n[IMAGE]"
									break
								end
							end
							TriggerClientEvent('esx:showAdvancedNotification', -1, 'LIFEINVADER', name, message, "CHAR_LIFEINVADER", 1)
						end
					end
				end
			end
        end
        Citizen.Wait(2000)
    end
end)



-- command to add new burglary
-- TriggerEvent('es:addGroupCommand', 'burglary', 'user', function(source, args)
-- 	local playerPed = GetPlayerPed(source)
-- 	local coords = GetEntityCoords(playerPed)
-- 	local heading = GetEntityHeading(playerPed) + 180
-- 	if heading > 360 then
-- 		heading = heading - 360
-- 	end

-- 	local code = "{\n" .. "\tpos = {x = " .. coords.x .. ", y = " .. coords.y .. ", z = " .. coords.z .. ", h = " .. heading .. "},\n" .. "\tstate = 0\n" .. "},"

-- 	SendWebhookMessage("avan0x_wh_dev", "```lua\n"..code.."```")
-- end, function(source, args)
-- 	TriggerClientEvent('chat:addMessage', source, {args = {'^1SYSTEM', 'Insufficient Permissions.'}})
-- end, {
-- 	help = "Coords template for burglary", 
-- 	params = {
-- 		{
-- 			name = "",
-- 			help = ""
-- 		}
-- 	}
--})


TriggerEvent('es:addGroupCommand', 'rb', 'mod', function(source, args, user)
	if args[1] ~= nil then
		SetPlayerRoutingBucket(source, args[1])
        print(source .. " is in " .. args[1])
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end)