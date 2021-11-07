-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVA.Players = {}
AVA.Players.List = {}
AVA.Players.BanList = {}

local function DEBUGPrintPlayerList(...)
    if AVAConfig.Debug then
        local string = "{ "
        local isFirst = true
        for src, player in pairs(AVA.Players.List) do
            if not isFirst then
                string = string .. ", "
            else
                isFirst = false
            end
            string = string .. "\"^2" .. src .. "^0\""
        end
        string = string .. " }"
        dprint(..., "PlayerList", string)
    end
end

local function GetDiscordGuildUser(discordId)
    if not discordId or type(discordId) ~= "string" then
        print("^1[GetDiscordGuildUser] An error occured, the discord identifier is not valid (^3" .. tostring(discordId) .. "^1).^0")
        return
    elseif not AVAConfig.Discord.GuildId then
        print("^1[GetDiscordGuildUser] An error occured, AVAConfig.Discord.GuildId is not set.^0")
        return
    end

    local member = AVA.Utils.DiscordRequest("GET", ("guilds/%s/members/%s"):format(AVAConfig.Discord.GuildId, string.gsub(discordId, "discord:", "")), {})
    if member.code == 200 then
        local data = json.decode(member.data)

        return data
    end
    print("^1[GetDiscordGuildUser] An error occured, we did not get a success code of ^2200^1, instead we got : ^8" .. member.code .. "^0")
    return
end

local function GetDiscordUser(discordId)
    if not discordId or type(discordId) ~= "string" then
        print("^1[GetDiscordUser] An error occured, the discord identifier is not valid (^3" .. tostring(discordId) .. "^1).^0")
        return
    elseif not AVAConfig.Discord.GuildId then
        print("^1[GetDiscordUser] An error occured, AVAConfig.Discord.GuildId is not set.^0")
        return
    end

    local member = AVA.Utils.DiscordRequest("GET", ("users/%s"):format(string.gsub(discordId, "discord:", "")), {})
    if member.code == 200 then
        local data = json.decode(member.data)

        return data
    end
    print("^1[GetDiscordUser] An error occured, we did not get a success code of ^2200^1, instead we got : ^8" .. member.code .. "^0")
    return
end

------------------------------------------
--------------- Connecting ---------------
------------------------------------------
AddEventHandler("playerConnecting", function(playerName, setKickReason, deferrals)
    local src = source
    deferrals.defer()

    -- dprint(src, "playerConnecting")
    -- mandatory wait!
    Wait(0)

    deferrals.update(GetString("connecting_checking_perms"))

    if AVA.Players.BanList == nil then
        deferrals.done(GetString("connecting_error"))
        AVA.Utils.SendWebhookEmbedMessage("avan0x_wh_staff", "", GetString("connecting_error_ban_list_log"), 16711680)
    else
        local license, discord, steam, ip, live, xbl = AVA.Players.GetSourceIdentifiers(src)

        if license == nil then
            deferrals.done(GetString("connecting_no_rockstar_license"))
        elseif discord == nil then
            deferrals.done(GetString("connecting_discord_not_found"))
        else
            local discordId = string.gsub(discord, "discord:", "")
            deferrals.update(GetString("connecting_discord_found"))

            local isBanned, banReason = AVA.Players.IsBanned(license, discord, steam, ip, live, xbl)
            if isBanned == nil then
                deferrals.done(GetString("connecting_error"))
            elseif isBanned == true then
                deferrals.done(GetString("connecting_you_are_banned", banReason))
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
                    deferrals.presentCard(
                        [==[{"type":"AdaptiveCard","body":[{"type":"TextBlock","size":"ExtraLarge","weight":"Bolder","text":"Discord introuvable ?"},{"type":"TextBlock","text":"Rejoignez le discord et complétez le formulaire pour nous rejoindre ! A très vite !","wrap":true},{"type":"Image","url":"https://cdn.discordapp.com/attachments/756841114589331457/757211539014156318/banniere_animee.gif","altText":""},{"type":"ActionSet","actions":[{"type":"Action.OpenUrl","title":"Nous rejoindre ! discord.gg/KRTKC6b","url":"https://discord.gg/KRTKC6b"}]}],"$schema":"http://adaptivecards.io/schemas/adaptive-card.json","version":"1.0"}]==],
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

local function retrievePlayerData(id)
    if not id then
        print("^1An error occured, player id is not valid : ^0", id)
        return
    end
    local players = exports.oxmysql:fetchSync(
        "SELECT `position`, `character`, `skin`, `loadout`, `accounts`, `status`, `jobs`, `inventory`, `metadata` FROM `players` WHERE `id` = :id", {id = id})
    return players[1]
end

local function loadPlayer(src)
    local aPlayer = AVA.Players.List[tostring(src)]
    if not aPlayer then
        print("^1[loadPlayer] ^0Could not load player for id ^3" .. tostring(src), "^0")
        return
    end
    aPlayer.login()
    AVA.RB.MoveSourceToRB(src, 0)

    TriggerClientEvent("ava_core:client:playerLoaded", src, {
        citizenId = aPlayer.citizenId,
        character = {
            citizenId = aPlayer.citizenId,
            firstname = aPlayer.character.firstname,
            lastname = aPlayer.character.lastname,
            sex = aPlayer.character.sex,
            birthdate = aPlayer.character.birthdate,
        },
        position = vector3(aPlayer.position.x, aPlayer.position.y, aPlayer.position.z),
        skin = aPlayer.skin,
        jobs = aPlayer.getJobsClientData(),
    })
end

local function logPlayerCharacter(src, license, discord, group, playerName, discordTag, citizenId)
    local oldPlayer = AVA.Players.GetPlayer(src)
    if oldPlayer then
        oldPlayer.logout()
        Citizen.Await(oldPlayer.save())
        AVA.Players.List[tostring(src)] = nil
    end

    local playerData = retrievePlayerData(citizenId)

    -- dprint(json.encode(playerData, {indent = true}))

    -- if for any reason, we could not get player datas, then we drop the player
    -- /!\ this should not happen, but it's better to prevent than cure
    if not playerData then
        DropPlayer(src, GetString("log_player_error"))
        print("^1[DISCORD ERROR] ^5" .. (discord or license or "") .. "^0 (^3" .. playerName
                  .. "^0) n'a pas pu se connecter car son personnage n'a pas été récupéré.")
        AVA.Utils.SendWebhookEmbedMessage("avan0x_wh_connections", "",
            "<@" .. string.gsub(discord or license or "", "discord:", "") .. ">" .. " (`" .. playerName .. "`)"
                .. " n'a pas pu se connecter car son personnage n'a pas été récupéré.", 16733269)
        return
    end

    local aPlayer = CreatePlayer(tostring(src), license, discord, group, playerName, discordTag, citizenId, playerData)
    AVA.Players.List[tostring(src)] = aPlayer

    -- we check if the player character is valid
    if type(aPlayer.character) == "table" and aPlayer.character.firstname and aPlayer.character.lastname and aPlayer.character.sex
        and aPlayer.character.birthdate then
        -- player char is valid
        loadPlayer(tostring(src))
    else
        -- player char needs to create a char
        AVA.RB.MoveSourceToRBName(src, "createchar" .. src)
        TriggerClientEvent("ava_core:client:createChar", src)
    end
end

local function setupPlayer(src, oldSource)
    Citizen.CreateThread(function()
        -- mandatory wait!
        Wait(0)

        local playerName = GetPlayerName(src)
        local license, discord = AVA.Players.GetSourceIdentifiers(src)
        -- TODO check if license is not already connected in the server

        local member = AVAConfig.DiscordWhitelist and GetDiscordGuildUser(discord) or GetDiscordUser(discord)
        -- kick player if we could not get the discord user
        if not member then
            DropPlayer(src, GetString("log_player_discord_error"))
            print("^1[DISCORD ERROR] ^5" .. (discord or license or "") .. "^0 (^3" .. playerName
                      .. "^0) n'a pas pu se connecter car son utilisateur Discord n'a pas été récupéré.")
            AVA.Utils.SendWebhookEmbedMessage("avan0x_wh_connections", "",
                "<@" .. string.gsub(discord or license or "", "discord:", "") .. ">" .. " (`" .. playerName .. "`)"
                    .. " n'a pas pu se connecter car son utilisateur Discord n'a pas été récupéré.", 16733269)
            return
        end

        -- get group and discord tag of user
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

        -- check if the player already exist on database, we get the most last played and most recent found
        local citizenId = exports.oxmysql:scalarSync(
            "SELECT id FROM `players` WHERE `license` = :license ORDER BY `last_played` DESC, `last_updated` DESC LIMIT 0, 1", {license = license})
        if citizenId then
            -- we found a character, so we update its discord and name
            -- we also edit the last_played value of all other characters this player have
            exports.oxmysql:executeSync(
                "UPDATE `players` SET `name` = :name, `discord` = :discord, `last_played` = 1 WHERE `license` = :license AND `id` = :id",
                {license = license, discord = discord, name = playerName, id = citizenId})
            -- we edit the last_played value of all other characters this player have
            exports.oxmysql:executeSync("UPDATE `players` SET `last_played` = 0 WHERE `license` = :license AND `id` <> :id AND `last_played` <> 0",
                {license = license, id = citizenId})
        else
            -- we haven't found a character, so we create a new one
            citizenId = exports.oxmysql:insertSync("INSERT INTO `players` (`license`, `discord`, `name`) VALUES (:license, :discord, :name)",
                {license = license, discord = discord, name = playerName})
        end

        -- add principal to the user
        if group then
            AVA.AddPrincipal("player." .. src, "group." .. group)
            -- ExecuteCommand("add_principal player." .. src .. " group." .. group)
            dprint("Add principal ^3group." .. group .. "^0 to ^3player." .. src .. "^0 (^3" .. discordTag .. "^0)")
        end

        -- we add command suggestions to the player
        local suggestions = {}
        for i = 1, #AVA.Commands.SuggestionList, 1 do
            local command = AVA.Commands.SuggestionList[i]
            if IsPlayerAceAllowed(src, ("command.%s"):format(command.name)) then
                table.insert(suggestions, {name = "/" .. command.name, help = command.help or "", params = command.params})
            end
        end
        TriggerClientEvent("chat:addSuggestions", src, suggestions)
        suggestions = nil

        TriggerEvent("ava_personalmenu:server:notifAdmins", "loginout", "~g~" .. playerName .. "~s~ se connecte.")
        print("^5" .. discordTag .. "^0 (^3" .. playerName .. "^0) se connecte. (" .. citizenId .. ")")
        AVA.Utils.SendWebhookEmbedMessage("avan0x_wh_connections", "", "<@" .. string.gsub(discord, "discord:", "") .. ">" .. " (`" .. playerName .. "`)"
            .. " se connecte. (" .. citizenId .. ")", 311891)

        logPlayerCharacter(src, license, discord, group, playerName, discordTag, citizenId)

        DEBUGPrintPlayerList("setupPlayer")
    end)
end

AddEventHandler("playerJoining", function(oldSource)
    local src = source
    setupPlayer(src, oldSource)
end)

Citizen.CreateThread(function()
    for _, source in ipairs(GetPlayers()) do
        setupPlayer(source)
    end
end)

-- * replaced with event playerJoining
-- RegisterNetEvent('ava_core:server:playerJoined', function()
--     local src = source
-- --     dprint(src, "ava_core:server:playerJoined")
-- end)

RegisterNetEvent("ava_core:server:createdPlayer", function(character, skin)
    local src = source

    local aPlayer = AVA.Players.List[tostring(src)]
    if aPlayer and type(aPlayer.character) == "table" and type(aPlayer.character.firstname) == "string" and type(aPlayer.skin) == "table" then
        print("^5" .. aPlayer.discordTag .. "^0 (^3" .. aPlayer.name .. "^0)^9 already have a char but tried to create one.^0(" .. aPlayer.citizenId .. ")")
        return

        -- we check if the player character is valid
    elseif type(character) == "table" and character.firstname and character.firstname ~= "" and character.lastname and character.lastname ~= "" and character.sex
        and character.sex ~= "" and character.birthdate and character.birthdate ~= "" and type(skin) == "table" and skin.sex then
        aPlayer.position = json.decode(json.encode(AVAConfig.DefaultPlayerData.position))
        aPlayer.character = {firstname = character.firstname, lastname = character.lastname, sex = character.sex, birthdate = character.birthdate}
        aPlayer.skin = skin
        aPlayer.inventory = CreateInventory(tostring(src), json.decode(json.encode(AVAConfig.DefaultPlayerData.inventory)), AVAConfig.InventoryMaxWeight)
        aPlayer.accounts = json.decode(json.encode(AVAConfig.DefaultPlayerData.accounts)) or {}
        aPlayer.status = json.decode(json.encode(AVAConfig.DefaultPlayerData.status)) or {}
        aPlayer.jobs = json.decode(json.encode(AVAConfig.DefaultPlayerData.jobs)) or {}
        aPlayer.loadout = json.decode(json.encode(AVAConfig.DefaultPlayerData.loadout)) or {}
        aPlayer.metadata = json.decode(json.encode(AVAConfig.DefaultPlayerData.metadata)) or {}

        dprint(json.encode(aPlayer.character, {indent = true}))
        exports.oxmysql:executeSync("UPDATE `players` SET `character` = :character WHERE `license` = :license AND `id` = :id",
            {character = json.encode(aPlayer.character), license = aPlayer.identifiers.license, id = aPlayer.citizenId})
        print("^2[SAVE CHARACTER] ^0" .. aPlayer.getDiscordTag() .. " (" .. aPlayer.citizenId .. ")")
        aPlayer.save()

        TriggerClientEvent("ava_core:client:joinCutScene", src)

        loadPlayer(src)

    else
        -- for some reason, player managed to have unvalid data, we send him back to creating a char
        print("^5" .. aPlayer.discordTag .. "^0 (^3" .. aPlayer.name .. "^0)^9 needs to create a character again because we received uncomplete values.^0("
                  .. aPlayer.citizenId .. ")")
        TriggerClientEvent("ava_core:client:createChar", src)
    end

end)

---------------------------------------
--------------- Dropped ---------------
---------------------------------------

AddEventHandler("playerDropped", function(reason)
    local src = source
    -- dprint(src, "playerDropped", reason)
    local aPlayer = AVA.Players.List[tostring(src)]
    if aPlayer then
        TriggerEvent("ava_personalmenu:server:notifAdmins", "loginout", "~r~" .. aPlayer.name .. "~s~ se déconnecte.")
        print("^5" .. aPlayer.discordTag .. "^0 (^3" .. aPlayer.name .. "^0) se déconnecte. (" .. aPlayer.citizenId .. ")")
        AVA.Utils.SendWebhookEmbedMessage("avan0x_wh_connections", "", "<@" .. string.gsub(aPlayer.identifiers.discord, "discord:", "") .. ">" .. " (`"
            .. aPlayer.name .. "`)" .. " se déconnecte. (" .. aPlayer.citizenId .. ")", 16733269)

        aPlayer.logout()
        Citizen.Await(aPlayer.save())

        AVA.RemovePrincipal("player." .. src, "group." .. aPlayer.group)

        AVA.Players.List[tostring(src)] = nil
    end
    DEBUGPrintPlayerList("playerDropped")
end)

-----------------------------------------
--------------- Functions ---------------
-----------------------------------------

---Get identifiers from source
---@param source string
---@return string license
---@return string discord
---@return string steam
---@return string ip
---@return string live
---@return string xbl
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
            xbl = v
        end
    end

    return license, discord, steam, ip, live, xbl
end
exports("GetSourceIdentifiers", AVA.Players.GetSourceIdentifiers)

---Get player from its source
---@param src string
---@return aPlayer
AVA.Players.GetPlayer = function(src)
    return AVA.Players.List[tostring(src)]
end
exports("GetPlayer", AVA.Players.GetPlayer)

---Get player from its citizen id
---@param src string
---@return aPlayer
AVA.Players.GetPlayerByCitizenId = function(citizenId)
    citizenId = tostring(citizenId)
    for src, player in pairs(AVA.Players.List) do
        if tostring(player.citizenId) == citizenId then
            return AVA.Players.List[tostring(src)]
        end
    end
end
exports("GetPlayerByCitizenId", AVA.Players.GetPlayerByCitizenId)

---Make the source player use an item if possible
---@param src string
---@param itemName string
AVA.Players.UseItem = function(src, itemName)
    local aPlayer = AVA.Players.GetPlayer(src)

    if not aPlayer or type(itemName) ~= "string" then
        return
    end
    if type(AVA.UsableItems[itemName]) ~= "nil" then
        local item = aPlayer.inventory.getItem(itemName)
        if item and item.quantity > 0 then
            AVA.UsableItems[itemName](aPlayer.src)
        end
    end
end
exports("UseItem", AVA.Players.UseItem)

RegisterNetEvent("ava_core:server:useItem", function(itemName)
    local src = source
    local aPlayer = AVA.Players.GetPlayer(src)
    if aPlayer then
        aPlayer.useItem(itemName)
    end
end)

------------------------------------
--------------- Bans ---------------
------------------------------------

local function UpdateBanList()
    -- exports.oxmysql:fetch("SELECT ban_list.steam, ban_list.license, ban_list.discord, ban_list.ip, ban_list.xbl, ban_list.live, ban_list.name, ban_list.reason, ban_list.staff, DATE_FORMAT(ban_list.date_ban, '%d/%m/%Y %T') AS date_ban, COALESCE (users.name, 'STAFF') AS staff_name FROM ban_list LEFT JOIN users ON ban_list.staff = users.identifier ORDER BY date_ban DESC", {},
    exports.oxmysql:fetch(
        "SELECT ban_list.steam, ban_list.license, ban_list.discord, ban_list.ip, ban_list.xbl, ban_list.live, ban_list.name, ban_list.reason, ban_list.staff, ban_list.date_ban AS date_ban FROM ban_list ORDER BY date_ban DESC",
        {}, function(data)
            AVA.Players.BanList = (data and data[1]) and data or {}
        end)
end

Citizen.CreateThread(function()
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

AVA.Commands.RegisterCommand("ban", "mod", function(source, args, rawCommand, aPlayer)
    if type(args[1]) ~= "string" then
        return
    end
    local id = args[1]
    local reason = table.concat(args, " ", 2)
    if not reason or reason == "" then
        reason = GetString("no_reason_given")
    end

    local license, discord, steam, ip, live, xbl = AVA.Players.GetSourceIdentifiers(id)
    if license then
        local aTargetPlayer = AVA.Players.GetPlayer(id)
        local name = aTargetPlayer and aTargetPlayer.getDiscordTag() or GetPlayerName(id) or "not_found"
        local staffName = aPlayer and aPlayer.getDiscordTag()

        local discordMessage
        if aPlayer then
            DropPlayer(id, GetString("you_got_banned_by", staffName, reason))
            discordMessage = GetString("player_got_banned_by", string.gsub(discord, "discord:", ""), name,
                string.gsub(aPlayer.identifiers.discord, "discord:", ""), staffName, reason)
        else
            DropPlayer(id, GetString("you_got_banned", reason))
            discordMessage = GetString("player_got_banned", string.gsub(discord, "discord:", ""), name, reason)
        end

        exports.oxmysql:execute(
            "INSERT INTO `ban_list`(`license`, `discord`, `steam`, `ip`, `xbl`, `live`, `name`, `reason`, `staff`) VALUES (:license, :discord, :steam, :ip, :xbl, :live, :name, :reason, :staff)",
            {
                license = license or "not_found",
                discord = discord or "not_found",
                steam = steam or "not_found",
                ip = ip or "not_found",
                xbl = xbl or "not_found",
                live = live or "not_found",
                name = name or "not_found",
                reason = reason or "",
                staff = aPlayer and aPlayer.identifiers.discord or "console",
            }, function()
                UpdateBanList()
            end)

        AVA.Utils.SendWebhookEmbedMessage("avan0x_wh_staff", "", discordMessage, 16711680) -- #ff0000
        return discordMessage
    end
end, GetString("ban_help"), {{name = "player", help = GetString("player_id")}})

-- TODO put as a command or something
-- AVA.Commands.RegisterCommand("unban", "superadmin", function(source, args)

-- RegisterNetEvent("ava_connection:unban")
-- AddEventHandler("ava_connection:unban", function(license)
--     local src = source
-- 	exports.oxmysql:executeSync('DELETE FROM `ban_list` WHERE license = :license', {
-- 		license = license
-- 	})
-- 	for i = 1, #AVA.Players.BanList, 1 do
-- 		if AVA.Players.BanList[i].license == license then
-- 			AVA.Utils.SendWebhookEmbedMessage("avan0x_wh_staff", "", AVA.Players.BanList[i].name .. " got unbanned by **" .. GetPlayerName(src) .. "**.", 16575503)
-- 			break
-- 		end
-- 	end
-- 	UpdateBanList()
-- end)

-------------------------------------------
--------------- Player Data ---------------
-------------------------------------------

RegisterNetEvent("ava_core:server:updatePosition", function(position)
    local src = source
    if position then
        local aPlayer = AVA.Players.GetPlayer(src)
        if aPlayer then
            aPlayer.position = position
        end
    end
end)

AVA.Players.Login = function(src)
    local aPlayer = AVA.Players.GetPlayer(src)

    if aPlayer then
        -- add all RP related aces and principals
        local jobs = aPlayer.getJobs()
        for i = 1, #jobs do
            local job = jobs[i]
            AVA.AddPrincipal("player." .. aPlayer.src, "job." .. job.name .. ".grade." .. job.grade)
        end

        dprint("^2[LOGIN] ^0" .. aPlayer.getDiscordTag() .. " (" .. aPlayer.citizenId .. ")")
    else
        error("^1[AVA.Players.Login]^0 aPlayer is not valid for src ^3" .. src .. "^0.")
    end
end

AVA.Players.Logout = function(src)
    local aPlayer = AVA.Players.GetPlayer(src)

    if aPlayer then
        -- remove all RP related aces and principals
        local jobs = aPlayer.getJobs()
        for i = 1, #jobs do
            local job = jobs[i]
            AVA.RemovePrincipal("player." .. aPlayer.src, "job." .. job.name .. ".grade." .. job.grade)
        end

        dprint("^2[LOGOUT] ^0" .. aPlayer.getDiscordTag() .. " (" .. aPlayer.citizenId .. ")")
    else
        error("^1[AVA.Players.Logout]^0 aPlayer is not valid for src ^3" .. src .. "^0.")
    end
end

AVA.Players.Save = function(src)
    local aPlayer = AVA.Players.GetPlayer(src)

    if aPlayer and aPlayer.citizenId then
        TriggerClientEvent("ava_core:client:startSave", src)
        local p = promise.new()
        -- exports.oxmysql:execute('UPDATE `players` SET `position` = :position, `character` = :character, `skin` = :skin, `loadout` = :loadout, `accounts` = :accounts, `status` = :status, `jobs` = :jobs, `inventory` = :inventory, `metadata` = :metadata WHERE `license` = :license AND `id` = :id', {
        exports.oxmysql:execute(
            "UPDATE `players` SET `position` = :position, `skin` = :skin, `loadout` = :loadout, `accounts` = :accounts, `status` = :status, `jobs` = :jobs, `inventory` = :inventory, `metadata` = :metadata WHERE `license` = :license AND `id` = :id",
            {
                position = json.encode(aPlayer.position),
                -- character = json.encode(aPlayer.character),
                skin = json.encode(aPlayer.skin),
                loadout = json.encode(aPlayer.loadout),
                accounts = json.encode(aPlayer.accounts),
                status = json.encode(aPlayer.status),
                jobs = json.encode(aPlayer.jobs),
                inventory = aPlayer.inventory and json.encode(aPlayer.inventory.items) or "[]",
                metadata = json.encode(aPlayer.metadata),
                license = aPlayer.identifiers.license,
                id = aPlayer.citizenId,
            }, function(result)
                print("^2[SAVE] ^0" .. aPlayer.getDiscordTag() .. " (" .. aPlayer.citizenId .. ")")
                aPlayer.lastSaveTime = os.time()
                TriggerClientEvent("ava_core:client:endSave", src)
                p:resolve()
            end)
        return p
    else
        error("^1[AVA.Players.Save]^0 aPlayer is not valid for src ^3" .. src .. "^0.")
    end
end

AVA.Players.SavePlayerJobs = function(src)
    local aPlayer = AVA.Players.GetPlayer(src)

    if aPlayer and aPlayer.citizenId then
        TriggerClientEvent("ava_core:client:startSave", src)
        local p = promise.new()
        exports.oxmysql:execute("UPDATE `players` SET `jobs` = :jobs WHERE `license` = :license AND `id` = :id",
            {jobs = json.encode(aPlayer.jobs), license = aPlayer.identifiers.license, id = aPlayer.citizenId}, function(result)
                print("^2[SAVE JOBS] ^0" .. aPlayer.getDiscordTag() .. " (" .. aPlayer.citizenId .. ")")
                TriggerClientEvent("ava_core:client:endSave", src)
                p:resolve()
            end)
        return p
    else
        error("^1[AVA.Players.SavePlayerJobs]^0 aPlayer is not valid for src ^3" .. src .. "^0.")
    end
end

---Save all players and print when all saves are done
AVA.Players.SaveAll = function()
    local promises = {}
    local count = 0
    for src, aPlayer in pairs(AVA.Players.List) do
        count = count + 1
        promises[count] = aPlayer.save()
    end

    Citizen.Await(promise.all(promises))
    print("^2[SAVE PLAYERS] ^0 Every player has been saved.")
end
exports("SaveAllPlayers", AVA.Players.SaveAll)

AVA.Commands.RegisterCommand("saveplayers", "superadmin", function(source, args, rawCommand)
    AVA.Players.SaveAll()
end)

-------------------------------------------
--------------- Select char ---------------
-------------------------------------------

AVA.Commands.RegisterCommand("changechar", "admin", function(source, args)
    local src = source
    local newCitizenId = args[1]
    local aPlayer = AVA.Players.GetPlayer(src)
    if aPlayer and newCitizenId then
        local license, citizenId = aPlayer.identifiers.license, aPlayer.citizenId

        if tostring(citizenId) == tostring(newCitizenId) then
            dprint("You can't change to the current character")
            return
        end

        -- we check if the citizenId is owned by the license
        local citizenExist = exports.oxmysql:scalarSync("SELECT 1 FROM `players` WHERE `license` = :license AND `id` = :id LIMIT 0, 1",
            {license = license, id = newCitizenId})

        if not citizenExist then
            dprint("citizen " .. tostring(newCitizenId) .. " does not exist for " .. tostring(license))
            return
        end

        -- local license, discord, group, playerName, discordTag, citizenId = aPlayer.license, aPlayer.discord, aPlayer.group, aPlayer.playerName, aPlayer.discordTag, aPlayer.citizenId
        local discord, group, playerName, discordTag = aPlayer.identifiers.discord, aPlayer.group, aPlayer.name, aPlayer.discordTag
        dprint("citizen " .. newCitizenId .. " does exist for " .. license)

        -- we update the discord id and name of the new character
        -- and we also edit the last_played value of all other characters this player have
        exports.oxmysql:executeSync("UPDATE `players` SET `name` = :name, `discord` = :discord, `last_played` = 1 WHERE `license` = :license AND `id` = :id",
            {license = license, discord = discord, name = playerName, id = newCitizenId})
        exports.oxmysql:executeSync("UPDATE `players` SET `last_played` = 0 WHERE `license` = :license AND `id` <> :id AND `last_played` <> 0",
            {license = license, id = newCitizenId})

        -- local playerData = retrievePlayerData(newCitizenId)
        logPlayerCharacter(src, license, discord, group, playerName, discordTag, newCitizenId)
    end
    return
end, GetString("change_char_help"), {{name = "char", help = GetString("char_id")}})

AVA.Commands.RegisterCommand("newchar", "admin", function(source, args)
    local src = source
    local aPlayer = AVA.Players.GetPlayer(src)
    if aPlayer then
        -- check if player can create a new char
        local charsCount = exports.oxmysql:scalarSync("SELECT COUNT(1) FROM `players` WHERE `license` = :license", {license = aPlayer.identifiers.license})
        if charsCount >= AVAConfig.MaxChars then
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("chars_no_more_chars"), nil, "ava_core_logo", GetString("chars"), nil, nil,
                "ava_core_logo")
            return
        end

        local license, discord, group, playerName, discordTag, citizenId = aPlayer.identifiers.license, aPlayer.identifiers.discord, aPlayer.group,
            aPlayer.name, aPlayer.discordTag, aPlayer.citizenId

        -- we edit the last_played value of the character that the player was using
        exports.oxmysql:executeSync("UPDATE `players` SET `last_played` = 0 WHERE `license` = :license AND `id` = :id AND `last_played` <> 0",
            {license = license, id = citizenId})

        dprint("insert a new char", license, discord, playerName, citizenId)
        -- we insert a new chaacter for the player
        local newCitizenId = exports.oxmysql:insertSync("INSERT INTO `players` (`license`, `discord`, `name`) VALUES (:license, :discord, :name)",
            {license = license, discord = discord, name = playerName})

        if not newCitizenId then
            dprint("could not insert a new char", newCitizenId, license, discord, playerName)
            return
        end
        dprint("citizen " .. newCitizenId .. " will be a new char for " .. license)

        logPlayerCharacter(src, license, discord, group, playerName, discordTag, newCitizenId)
    end
    return
end, GetString("new_char_help"))

AVA.Commands.RegisterCommand("chars", "admin", function(source, args)
    local src = source
    local aPlayer = AVA.Players.GetPlayer(src)
    if aPlayer then
        local chars = exports.oxmysql:fetchSync("SELECT `id`, `character`, `last_played` FROM `players` WHERE `license` = :license ORDER BY `id` DESC",
            {license = aPlayer.identifiers.license})
        if chars[1] then
            TriggerClientEvent("ava_core:client:selectChar", src, chars, AVAConfig.MaxChars)
        else
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("chars_need_at_least_one_char_to_change"), nil, "ava_core_logo",
                GetString("chars"), nil, nil, "ava_core_logo")
        end
    end
end, GetString("get_all_player_chars_help"))

-------------------------------------------
----------------- WEAPONS -----------------
-------------------------------------------

RegisterNetEvent("ava_core:server:reloadLoadout", function()
    local src = source
    local aPlayer = AVA.Players.GetPlayer(src)
    if aPlayer then
        local playerItems = aPlayer.getInventory().items
        local TabHasValue<const> = AVA.Utils.TableHasValue
        local Items<const> = AVAConfig.Items
        local WeaponsTypes<const> = AVAConfig.WeaponsTypes
        local playerPed = GetPlayerPed(src)
        if not playerPed then
            return
        end
        dprint("^9[WEAPONS] ^0" .. aPlayer.getDiscordTag() .. " all weapons ^9removed^0")
        RemoveAllPedWeapons(playerPed, true)
        for i = 1, #playerItems do
            local item = playerItems[i]
            if item and item.quantity > 0 then
                local cfgItem = Items[item.name]
                if cfgItem and TabHasValue(WeaponsTypes, cfgItem.type) then
                    dprint("^9[WEAPONS] ^0" .. aPlayer.getDiscordTag() .. " add weapon ^2" .. item.name .. "^0")
                    aPlayer.addWeapon(item.name, item.quantity)
                end
            end
        end
        -- mandatory wait !
        Wait(500)
        -- Second loop for ammos, because we need to add them when the player has the weapons
        for i = 1, #playerItems do
            local item = playerItems[i]
            if item and item.quantity > 0 then
                local cfgItem = Items[item.name]
                if cfgItem and cfgItem.type == "ammo" then
                    TriggerClientEvent("ava_core:client:updateAmmoTypeCount", src, GetHashKey(item.name), item.quantity)

                end
            end
        end
    end
end)

AddEventHandler("ava_core:server:editPlayerItemInventoryCount", function(src, itemName, itemLabel, isAddition, editedQuantity, newQuantity)
    local cfgWeapon<const> = AVAConfig.Weapons[itemName]
    if cfgWeapon then
        local aPlayer = AVA.Players.GetPlayer(src)
        if isAddition and (editedQuantity == newQuantity or cfgWeapon.type == "throwable") then
            dprint("^9[WEAPONS] ^0" .. aPlayer.getDiscordTag() .. " add weapon ^2" .. itemName .. "^0")
            aPlayer.addWeapon(itemName, editedQuantity)
        elseif not isAddition and (newQuantity == 0 or cfgWeapon.type == "throwable") then
            dprint("^9[WEAPONS] ^0" .. aPlayer.getDiscordTag() .. " remove weapon ^8" .. itemName .. "^0")
            aPlayer.removeWeapon(itemName, newQuantity)
        end
        return
    end
    local cfgItem<const> = AVAConfig.Items[itemName]
    if cfgItem and cfgItem.type == "ammo" then
        TriggerClientEvent("ava_core:client:updateAmmoTypeCount", src, GetHashKey(itemName), newQuantity)
    end
end)

RegisterNetEvent("ava_core:server:playerShotAmmoType", function(ammoType, ammoRemoved)
    local src = source
    local aPlayer = AVA.Players.GetPlayer(src)
    if aPlayer then
        local inventory = aPlayer.getInventory()
        local item = inventory.getItem(ammoType)
        print(src, ammoType, ammoRemoved, item and item.quantity)
        if not item then
            AVA.Utils.SendWebhookEmbedMessage("avan0x_wh_staff", "", ("**%s** used an unknown type of ammo `%s`"):format(aPlayer.getDiscordTag(), ammoType),
                15685721)

        elseif ammoRemoved > item.quantity then
            AVA.Utils.SendWebhookEmbedMessage("avan0x_wh_staff", "",
                ("**%s** has removed more ammo on client side than items in inventory (`%s` : %d ammo in inventory and %d ammo removed client side)"):format(
                    aPlayer.getDiscordTag(), ammoType, item.quantity, ammoRemoved), 15685721)
            TriggerClientEvent("ava_core:client:updateAmmoTypeCount", src, GetHashKey(ammoType), item.quantity)

        elseif ammoRemoved <= item.quantity then
            inventory.removeItem(item.name, ammoRemoved)

        end
    end
end)
