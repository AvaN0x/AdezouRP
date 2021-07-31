----------------------------------------------------
------------ MADE BY GITHUB.COM/AVAN0X -------------
------------------- AvaN0x#6348 --------------------
---------- DISCORD REQUESTS ARE BASED ON -----------
--- https://github.com/sadboilogan/discord_perms ---
----------------------------------------------------

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local formattedToken
local banList = nil

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

--* init thread
Citizen.CreateThread(function()
	local botToken = GetConvar("avan0x_bot_token", "avan0x_bot_token")
	if botToken ~= "avan0x_bot_token" then
		formattedToken = "Bot " .. botToken
		local guild = DiscordRequest("GET", "guilds/" .. Config.GuildId, {})
		if guild.code == 200 then
			local data = json.decode(guild.data)
			print("Permission system guild set to: "..data.name.." ("..data.id..")")
		else
			print("An error occured, please check your config and ensure everything is correct. Error: " .. (guild.data or guild.code))
		end
	else
		print("You need to use \"set avan0x_bot_token 'YOUR BOT TOKEN'\" in your server.cfg.")
	end

	GetBanList()
end)


function has_value(table, val)
	if table then
		for k, v in ipairs(table) do
			if v == val then
				return true
			end
		end
	end
	return false
end

function GetPlayerIdentifiersInVars(player)
	local steam, license, discord, ip, live, xbl
	for k, v in ipairs(GetPlayerIdentifiers(player)) do
		if string.find(v, "steam:") then
			steam = v
		elseif string.find(v, "license:") then
			license = v
		elseif string.find(v, "discord:") then
			discord = v
		elseif string.find(v, "ip:") then
			ip = v
		elseif string.find(v, "live:") then
			live = v
		elseif string.find(v, "xbl:") then
			xbl  = v
		end
	end
	return steam, license, discord, ip, live, xbl
end

AddEventHandler("playerConnecting", function(steamName, setCallback, deferrals)
    deferrals.defer()
    -- mandatory wait!
    Wait(0)
    deferrals.update("Vérification des permissions...")

	if banList == nil then
		deferrals.done("Une erreur est survenue, veuillez réessayer. Si le problème persiste, veuillez créer un ticket sur le discord.")
		SendWebhookEmbedMessage("avan0x_wh_staff", "", "The ban list have not loaded well !", 16711680)
	else
		local steam, license, discord, ip, live, xbl = GetPlayerIdentifiersInVars(source)

		if steam == nil or license == nil then
			deferrals.done("Veuillez vérifier que steam soit bien lancé.")
		elseif discord ~= nil then
			local discordId = string.gsub(discord, "discord:", "")
			local gotRole = false
			deferrals.update("Ton ID discord a été trouvé...")
			local isBanned, banReason = isBanned(license, steam, discord, ip, live, xbl)

			if isBanned == nil then
				deferrals.done("Une erreur est survenue, veuillez réessayer. Si le problème persiste, veuillez créer un ticket sur le discord.")
			elseif isBanned == true then
				deferrals.done("Vous avez été banni de ce serveur : " .. banReason)
			else
				local endpoint = ("guilds/%s/members/%s"):format(Config.GuildId, discordId)
				local member = DiscordRequest("GET", endpoint, {})
				if member.code == 200 then
					local data = json.decode(member.data)
					for k, v in ipairs(Config.WhitelistedRoles) do
						if has_value(data.roles, v) then
							gotRole = true
							break
						end
					end
					if gotRole then
						local name = data.user.username .. "#" .. data.user.discriminator .. " (" .. steamName .. ")"
						local namePing = "<@" .. discordId .. ">" .. " (`" .. steamName .. "`)"
						print(name .. " se connecte.")
						TriggerEvent('esx_ava_personalmenu:notifStaff', "login", "~g~" .. name .. "~s~ se connecte.")
						SendWebhookEmbedMessage("avan0x_wh_connections", "", namePing .. " se connecte.", 311891)
						deferrals.done()
						return
					end
				end
				deferrals.presentCard([==[{"type":"AdaptiveCard","body":[{"type":"TextBlock","size":"ExtraLarge","weight":"Bolder","text":"Discord introuvable ?"},{"type":"TextBlock","text":"Vous devez accepter notre règlement sur notre discord pour pouvoir nous rejoindre.","wrap":true},{"type":"Image","url":"https://cdn.discordapp.com/attachments/756841114589331457/757211539014156318/banniere_animee.gif","altText":""},{"type":"ActionSet","actions":[{"type":"Action.OpenUrl","title":"Nous rejoindre ! discord.gg/KRTKC6b","url":"https://discord.gg/KRTKC6b"}]}],"$schema":"http://adaptivecards.io/schemas/adaptive-card.json","version":"1.0"}]==],
				function(data, rawData)
					deferrals.done("discord.gg/KRTKC6b")
				end)
			end
		else
			deferrals.done("Discord n'a pas été détecté. Veuillez vous assurer que Discord est en cours d'exécution et est installé. Voir le lien ci-dessous pour un processus de débogage - docs.faxes.zone/docs/debugging-discord")
		end
	end
end)

AddEventHandler('playerDropped', function(reason)
    local discordId = GetDiscordId(source)
	local steamName = (GetPlayerName(source) or "SteamName")
	local name = steamName
    local namePing = steamName

    if discordId then
        local endpoint = ("users/%s"):format(discordId)
        local member = DiscordRequest("GET", endpoint, {})
        if member.code == 200 then
			local data = json.decode(member.data)
			name = data.username .. "#" .. data.discriminator .. " (" .. steamName .. ")"
		end
        namePing = "<@" .. discordId .. ">" .. " (`" .. steamName .. "`)"
	end
	print(name .. " a quitté.\n\tRaison : " .. reason)
	TriggerEvent('esx_ava_personalmenu:notifStaff', "logout", "~r~" .. name .. "~s~ a quitté. (" .. reason .. ")")
	SendWebhookEmbedMessage("avan0x_wh_connections", "", namePing .. " a quitté.\n\tRaison : " .. reason, 16733269)
end)

RegisterServerEvent("ava_connection:banPlayer")
AddEventHandler("ava_connection:banPlayer", function(id, reason)
	local steam, license, discord, ip, live, xbl = GetPlayerIdentifiersInVars(id)
	local name = GetPlayerName(id)
    local staffSteam, _, staffDiscord = GetPlayerIdentifiersInVars(source)
	local staffName = GetPlayerName(source)

	DropPlayer(id, "Tu as été banni par " .. staffName .. " : ".. reason)
	SendWebhookEmbedMessage("avan0x_wh_staff", "", "<@" .. string.gsub(discord, "discord:", "") .. "> (`" .. name .. "`) got banned by " .. (staffDiscord and ("<@" .. string.gsub(staffDiscord, "discord:", "") .. "> (`" .. staffName .. "`)") or staffName) .. ".\nReason : " .. reason, 16711680) -- #ff0000

	MySQL.Async.execute('INSERT INTO `ban_list`(`steam`, `license`, `discord`, `ip`, `xbl`, `live`, `name`, `reason`, `staff`) VALUES (@steam, @license, @discord, @ip, @xbl, @live, @name, @reason, @staff)', {
		['@steam'] = steam or "not_found",
		['@license'] = license or "not_found",
		['@discord'] = discord or "not_found",
		['@ip'] = ip or "not_found",
		['@xbl'] = xbl or "not_found",
		['@live'] = live or "not_found",
		['@name'] = name or "not_found",
		['@reason'] = reason or "",
		['@staff'] = staffSteam
	})

	GetBanList()
end)

function GetDiscordId(source)
    for k, v in ipairs(GetPlayerIdentifiers(source)) do
		if string.match(v, "discord:") then
			return string.gsub(v, "discord:", "")
		end
    end
    return nil
end


function GetBanList()
	Citizen.Wait(500)
	MySQL.Async.fetchAll("SELECT ban_list.steam, ban_list.license, ban_list.discord, ban_list.ip, ban_list.xbl, ban_list.live, ban_list.name, ban_list.reason, ban_list.staff, DATE_FORMAT(ban_list.date_ban, '%d/%m/%Y %T') AS date_ban, COALESCE (users.name,'STAFF') AS staff_name FROM ban_list LEFT JOIN users ON ban_list.staff = users.identifier ORDER BY date_ban DESC", {}, function(data)
		if data[1] then
			banList = data
		else
			banList = {}
		end
	end)
end

function isBanned(steam, license, discord, ip, live, xbl)
	if banList == nil then
		return nil, nil
	end

	for k, v in ipairs(banList) do
		if v.steam == steam or v.license == license or v.discord == discord or v.ip == ip or v.live == live or v.xbl == xbl then
			return true, v.reason .. " (" .. v.staff_name .. ")"
		end
	end

	return false, ""
end

ESX.RegisterServerCallback('ava_connection:getBannedElements', function(source, cb)
	local elements = {}
	for k, v in ipairs(banList) do
		local detail = "Reason : " .. v.reason .. "<br/>" .. "Staff : " .. v.staff_name.. "<br/>" .. "Date : " .. v.date_ban
		table.insert(elements, {label = v.name, value = v.license, detail = detail})
	end
	cb(elements)
end)

RegisterServerEvent("ava_connection:unban")
AddEventHandler("ava_connection:unban", function(license)
    -- TODO check if user have rights
	MySQL.Async.execute('DELETE FROM `ban_list` WHERE license = @license', {
		['@license'] = license
	})
	for k, v in ipairs(banList) do
		if v.license == license then
			SendWebhookEmbedMessage("avan0x_wh_staff", "", v.name .. " got unbanned by **" .. GetPlayerName(source) .. "**.", 16575503)
			break
		end
	end
	GetBanList()
end)