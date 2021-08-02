-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

AVA.Players = {}
AVA.Players.List = {}
AVA.Players.BanList = {}

local function GetDiscordGuildUser(discordId)
    if not discordId or type(discordId) ~= "string" then
        print("^1[GetDiscordGuildUser] An error occured, the discord identifier is not valid (^3" .. tostring(discordId) .. "^1).^7")
        return
    elseif not AVAConfig.Discord.GuildId then
        print("^1[GetDiscordGuildUser] An error occured, AVAConfig.Discord.GuildId is not set.^7")
        return
    end

    local member = AVA.Utils.DiscordRequest("GET", ("guilds/%s/members/%s"):format(AVAConfig.Discord.GuildId, string.gsub(discordId, "discord:", "")), {})
    if member.code == 200 then
        local data = json.decode(member.data)

        return data
    end
    return
end


local function GetDiscordUser(discordId)
    if not discordId or type(discordId) ~= "string" then
        print("^1[GetDiscordUser] An error occured, the discord identifier is not valid (^3" .. tostring(discordId) .. "^1).^7")
        return
    elseif not AVAConfig.Discord.GuildId then
        print("^1[GetDiscordUser] An error occured, AVAConfig.Discord.GuildId is not set.^7")
        return
    end

    local member = AVA.Utils.DiscordRequest("GET", ("users/%s"):format(string.gsub(discordId, "discord:", "")), {})
    if member.code == 200 then
        local data = json.decode(member.data)

        return data
    end
    return
end



------------------------------------------
--------------- Connecting ---------------
------------------------------------------
AddEventHandler('playerConnecting', function(playerName, setKickReason, deferrals)
    local src = source
    deferrals.defer()
    
    -- dprint(src, "playerConnecting")
    -- mandatory wait!
    Wait(0)

	deferrals.update("Vérification des permissions...")

	if AVA.Players.BanList == nil then
		deferrals.done("Une erreur est survenue, veuillez réessayer. Si le problème persiste, veuillez créer un ticket sur le discord.")
		AVA.Utils.SendWebhookEmbedMessage("avan0x_wh_staff", "", "The ban list have not loaded well !", 16711680)
	else
        local license, discord, steam, ip, live, xbl = AVA.Players.GetSourceIdentifiers(src)

		if license == nil then
			deferrals.done("Votre license Rockstar n'a pas été détectée.")
		elseif discord == nil then
            deferrals.done("Discord n'a pas été détecté. Veuillez vous assurer que Discord est en cours d'exécution et est installé. Voir le lien ci-dessous pour un processus de débogage - docs.faxes.zone/docs/debugging-discord")
        else
			local discordId = string.gsub(discord, "discord:", "")
			deferrals.update("Ton ID discord a été trouvé...")

			local isBanned, banReason = AVA.Players.IsBanned(license, discord, steam, ip, live, xbl)
			if isBanned == nil then
				deferrals.done("Une erreur est survenue, veuillez réessayer. Si le problème persiste, veuillez créer un ticket sur le discord.")
			elseif isBanned == true then
				deferrals.done("Vous avez été banni de ce serveur : " .. banReason)
			else
                if AVAConfig.DiscordWhitelist then
                    local member = GetDiscordGuildUser(discord)
                    if member then
                        local gotRole
                        for k, v in ipairs(AVAConfig.Discord.Whitelist) do
                            if AVA.Utils.TableHasValue(member.roles, v) then
                                gotRole = true
                                break
                            end
                        end
                        if gotRole then
                            deferrals.done()
                            return
                        end
                    end
                    deferrals.presentCard([==[{"type":"AdaptiveCard","body":[{"type":"TextBlock","size":"ExtraLarge","weight":"Bolder","text":"Discord introuvable ?"},{"type":"TextBlock","text":"Rejoignez le discord et complétez le formulaire pour nous rejoindre ! A très vite !","wrap":true},{"type":"Image","url":"https://cdn.discordapp.com/attachments/756841114589331457/757211539014156318/banniere_animee.gif","altText":""},{"type":"ActionSet","actions":[{"type":"Action.OpenUrl","title":"Nous rejoindre ! discord.gg/KRTKC6b","url":"https://discord.gg/KRTKC6b"}]}],"$schema":"http://adaptivecards.io/schemas/adaptive-card.json","version":"1.0"}]==],
                    function(data, rawData)
                        deferrals.done("discord.gg/KRTKC6b")
                    end)
                else
                    deferrals.done()
                    return
                end
			end
		end
	end
end)


---------------------------------------
--------------- Joining ---------------
---------------------------------------

local function setupPlayer(src, oldSource)
    Citizen.CreateThread(function()
        -- mandatory wait!
        Wait(0)

        -- dprint(src, "playerJoining, oldId : ", oldSource)
        
        local license, discord = AVA.Players.GetSourceIdentifiers(src)



        local member = AVAConfig.DiscordWhitelist
            and GetDiscordGuildUser(discord)
            or GetDiscordUser(discord)
        if not member then
            local playerName = GetPlayerName(src) or ""
            DropPlayer(src, "Votre utilisateur Discord n'a pas pu être récupéré. Veuillez réessayer dans un instant.")
            print("^1[DISCORD ERROR] ^5" .. (discord or license or "") .. "^7 (^3" .. playerName .. "^7) n'a pas pu se connecter car son utilisateur Discord n'a pas été récupéré.")
            AVA.Utils.SendWebhookEmbedMessage("avan0x_wh_connections", "", "<@" .. string.gsub(discord or license or "", "discord:", "") .. ">" .. " (`" .. playerName .. "`)" .. " n'a pas pu se connecter car son utilisateur Discord n'a pas été récupéré.", 311891)
            return    
        end

        local group, discordTag = nil, ""
        if AVAConfig.DiscordWhitelist then
            for i = 1, #AVAConfig.Discord.Ace, 1 do
                if AVA.Utils.TableHasValue(member.roles, AVAConfig.Discord.Ace[i].role) then
                    group = AVAConfig.Discord.Ace[i].ace
                    break
                end
            end
            discordTag = (member.user.username or "") .. "#" .. (member.user.discriminator or "")
        else
            discordTag = (member.username or "") .. "#" .. (member.discriminator or "")
        end

        AVA.Players.List[tostring(src)] = CreatePlayer(src, license, discord, group, discordTag)

        -- TriggerEvent('esx_ava_personalmenu:notifStaff', "login", "~g~" .. AVA.Players.List[tostring(src)].name .. "~s~ se connecte.")
        print("^5" .. discordTag .. "^7 (^3" .. AVA.Players.List[tostring(src)].name .. "^7) se connecte.")
        AVA.Utils.SendWebhookEmbedMessage("avan0x_wh_connections", "", "<@" .. string.gsub(AVA.Players.List[tostring(src)].identifiers.discord, "discord:", "") .. ">" .. " (`" .. AVA.Players.List[tostring(src)].name .. "`)" .. " se connecte.", 311891)

        
        dprint("playerJoining json.encode(AVA.Players.List)", json.encode(AVA.Players.List))
        TriggerClientEvent("ava_core:client:playerLoaded", src, AVA.Players.List[tostring(src)])
    end)
end


AddEventHandler('playerJoining', function(oldSource)
    local src = source
    setupPlayer(src, oldSource)
end)

for _, source in ipairs(GetPlayers()) do
    setupPlayer(source)
end

--* replaced with event playerJoining
-- RegisterNetEvent('ava_core:server:playerJoined', function()
--     local src = source
-- --     dprint(src, "ava_core:server:playerJoined")
-- end)



---------------------------------------
--------------- Dropped ---------------
---------------------------------------

AddEventHandler('playerDropped', function(reason)
    local src = source
    -- dprint(src, "playerDropped", reason)
    if AVA.Players.List[tostring(src)] then
        AVA.Utils.SendWebhookEmbedMessage("avan0x_wh_connections", "", AVA.Players.List[tostring(src)].name .. " se déconnecte.", 311891)

        AVA.Players.List[tostring(src)] = nil
    end
    dprint("playerDropped json.encode(AVA.Players.List)", json.encode(AVA.Players.List))
end)


-----------------------------------------
--------------- Functions ---------------
-----------------------------------------

AVA.Players.GetSourceIdentifiers = function(source)
	local license, discord, steam, ip, live, xbl
	for k, v in ipairs(GetPlayerIdentifiers(source)) do
        if string.find(v, "license:") then
            license = v
        elseif string.find(v, "discord:") then
            discord = v
        elseif string.find(v, "steam:") then
			steam = v
		elseif string.find(v, "ip:") then
			ip = v
		elseif string.find(v, "live:") then
			live = v
		elseif string.find(v, "xbl:") then
			xbl  = v
		end
	end

    return license, discord, steam, ip, live, xbl
end


------------------------------------
--------------- Bans ---------------
------------------------------------

local function UpdateBanList()
    -- MySQL.Async.fetchAll("SELECT ban_list.steam, ban_list.license, ban_list.discord, ban_list.ip, ban_list.xbl, ban_list.live, ban_list.name, ban_list.reason, ban_list.staff, DATE_FORMAT(ban_list.date_ban, '%d/%m/%Y %T') AS date_ban, COALESCE (users.name, 'STAFF') AS staff_name FROM ban_list LEFT JOIN users ON ban_list.staff = users.identifier ORDER BY date_ban DESC", {},
    MySQL.Async.fetchAll("SELECT ban_list.steam, ban_list.license, ban_list.discord, ban_list.ip, ban_list.xbl, ban_list.live, ban_list.name, ban_list.reason, ban_list.staff, DATE_FORMAT(ban_list.date_ban, '%d/%m/%Y %T') AS date_ban FROM ban_list ORDER BY date_ban DESC", {},
    function(data)
        AVA.Players.BanList = data[1] and data or {}
	end)
end

MySQL.ready(function()
	UpdateBanList()
end)

AVA.Players.IsBanned = function(license, discord, steam, ip, live, xbl)
	if AVA.Players.BanList == nil then
		return
	end

	for k, v in ipairs(AVA.Players.BanList) do
		if v.license == license or v.discord == discord or v.steam == steam or v.ip == ip or v.live == live or v.xbl == xbl then
			-- return true, v.reason .. " (" .. v.staff_name .. ")"
			return true, v.reason
		end
	end

	return false
end

-- TODO put as a command or something
-- RegisterServerEvent("ava_connection:banPlayer")
-- AddEventHandler("ava_connection:banPlayer", function(id, reason)
-- 	local license, discord, steam, ip, live, xbl = AVA.Players.GetSourceIdentifiers(id)
-- 	local name = GetPlayerName(id)
--     local _, staffDiscord = AVA.Players.GetSourceIdentifiers(source)
-- 	local staffName = GetPlayerName(source)

-- 	DropPlayer(id, "Tu as été banni par " .. staffName .. " : ".. reason)
-- 	AVA.Utils.SendWebhookEmbedMessage("avan0x_wh_staff", "", "<@" .. string.gsub(discord, "discord:", "") .. "> (`" .. name .. "`) got banned by " .. (staffDiscord and ("<@" .. string.gsub(staffDiscord, "discord:", "") .. "> (`" .. staffName .. "`)") or staffName) .. ".\nReason : " .. reason, 16711680) -- #ff0000

-- 	MySQL.Sync.execute('INSERT INTO `ban_list`(`license`, `discord`, `steam`, `ip`, `xbl`, `live`, `name`, `reason`, `staff`) VALUES (@license, @discord, @steam, @ip, @xbl, @live, @name, @reason, @staff)', {
--         ['@license'] = license or "not_found",
-- 		['@discord'] = discord or "not_found",
-- 		['@steam'] = steam or "not_found",
-- 		['@ip'] = ip or "not_found",
-- 		['@xbl'] = xbl or "not_found",
-- 		['@live'] = live or "not_found",
-- 		['@name'] = name or "not_found",
-- 		['@reason'] = reason or "",
-- 		['@staff'] = staffDiscord
-- 	})

-- 	UpdateBanList()
-- end)

-- TODO put as a command or something
-- RegisterServerEvent("ava_connection:unban")
-- AddEventHandler("ava_connection:unban", function(license)
--     local src = source
-- 	MySQL.Sync.execute('DELETE FROM `ban_list` WHERE license = @license', {
-- 		['@license'] = license
-- 	})
-- 	for i = 1, #AVA.Players.BanList, 1 do
-- 		if AVA.Players.BanList[i].license == license then
-- 			AVA.Utils.SendWebhookEmbedMessage("avan0x_wh_staff", "", AVA.Players.BanList[i].name .. " got unbanned by **" .. GetPlayerName(src) .. "**.", 16575503)
-- 			break
-- 		end
-- 	end
-- 	UpdateBanList()
-- end)