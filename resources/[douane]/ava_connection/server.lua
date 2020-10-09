----------------------------------------------------
------------ MADE BY GITHUB.COM/AVAN0X -------------
------------------- AvaN0x#6348 --------------------
---------- DISCORD REQUESTS ARE BASED ON -----------
--- https://github.com/sadboilogan/discord_perms ---
----------------------------------------------------

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
end)




AddEventHandler('playerDropped', function(reason)
    for k, v in ipairs(GetPlayerIdentifiers(source)) do
		if string.match(v, "discord:") then
			discordId = string.gsub(v, "discord:", "")
			break
		end
    end

    if discordId then
        local endpoint = ("users/%s"):format(discordId)
        local member = DiscordRequest("GET", endpoint, {})
        if member.code == 200 then
			local data = json.decode(member.data)
			print(data.username.."#"..data.discriminator .. " left.\n\tReason : "..reason)
			SendWebhookEmbedMessage("avan0x_wh_connections", "", data.username.."#"..data.discriminator .. " left.\n\tReason : "..reason, 16733269)
			return
		end
	end
	print((GetPlayerName(source) or "An user") .. " left.\n\tReason : "..reason)
	SendWebhookEmbedMessage("avan0x_wh_connections", "", (GetPlayerName(source) or "An user") .. " left.\n\tReason : "..reason, 16733269)
end)


