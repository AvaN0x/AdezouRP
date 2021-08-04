-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

AVA.Utils = {}

AVA.Utils.Trim = function(string)
    return (string.gsub(string, "^%s*(.-)%s*$", "%1"))
end

AVA.Utils.TableHasValue = function(table, val)
	if table then
		for k, v in ipairs(table) do
			if v == val then
				return true
			end
		end
	end
	return false
end

---------------------------------------
--------------- Discord ---------------
---------------------------------------

local formattedToken
AVA.Utils.DiscordRequest = function(method, endpoint, jsondata)
    local data = nil
    if formattedToken then
        PerformHttpRequest("https://discordapp.com/api/"..endpoint,
            function(errorCode, resultData, resultHeaders)
                data = {
                    data = resultData,
                    code = errorCode,
                    headers = resultHeaders
                }
            end,
            method,
            #jsondata > 0 and json.encode(jsondata) or "",
            {
                ["Content-Type"] = "application/json",
                ["Authorization"] = formattedToken
            }
        )

        while data == nil do
            Citizen.Wait(0)
        end
    end

    return data
end
exports("DiscordRequest", AVA.Utils.DiscordRequest)

--* discord init thread
Citizen.CreateThread(function()
	local botToken = GetConvar("avan0x_bot_token", "avan0x_bot_token")
	if botToken ~= "avan0x_bot_token" then
		formattedToken = "Bot " .. botToken
        if AVAConfig.Discord.GuildId then
            local guild = AVA.Utils.DiscordRequest("GET", ("guilds/%s"):format(AVAConfig.Discord.GuildId), {})
            if guild.code == 200 then
                local data = json.decode(guild.data)
                print("Permission system guild set to: ^3" .. data.name .. " ^0(^3" .. data.id .. "^0)")
            else
                print("^1An error occured, please check your config and ensure everything is correct. Error: ^*" .. (guild.data or guild.code) .. "^0")
            end
        else
            print("^1An error occured, please check your config and ensure everything is correct.^0")
		end
	else
		print("^1You need to use \"set avan0x_bot_token 'YOUR BOT TOKEN'\" in your server.cfg.^0")
	end
end)

AVA.Utils.SendWebhookMessage = function(webhookName, message)
	local webhook = GetConvar(webhookName, "none")
	if webhook ~= "none" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), {['Content-Type'] = 'application/json'})
	end
end
exports("SendWebhookMessage", AVA.Utils.SendWebhookMessage)

AVA.Utils.SendWebhookEmbedMessage = function(webhookName, title, description, color)
	local webhook = GetConvar(webhookName, "none")
	if webhook ~= "none" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode(
			{
				embeds = {
					{
						title = title,
						description = description,
						color = color,
                        footer = GetConvar("DEV_SERVER", "false") ~= "false" and {text = "DEV SERVER"} or nil
					}
				}
			}), {['Content-Type'] = 'application/json'})
	end
end
exports("SendWebhookEmbedMessage", AVA.Utils.SendWebhookEmbedMessage)