-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVA.Commands = {}
AVA.Commands.SuggestionList = {}

---Register a command using ace permissions to a group
---@param name string|table
---@param group string|nil
---@param callback fun(source: any, args: table, rawCommand: string) this can return a string that will be added to the discord log
---@param help string
---@param params table {name: string, help: string}
AVA.Commands.RegisterCommand = function(name, group, callback, help, params)
    if type(name) == "table" then
        -- name is an array of aliases
        for i = 1, #name, 1 do
            if type(name[i]) == "string" then
                AVA.Commands.RegisterCommand(name[i], group, callback, help, params)
            end
        end
        return
    elseif type(name) ~= "string" then
        print("^3[WARN] Could not create command because ^0name^3 is not a ^0string^3.^0")
        return
    elseif type(callback) ~= "function" and (type(callback) == "table" and callback["__cfx_functionReference"] == nil) then
        print("^3[WARN]^0 Could not create command ^3" .. name .. "^0 because ^3callback^0 is not a ^3function^0.^0")
        return
    end

    name = name:lower()
    group = type(group) == "string" and group:lower() or nil

    local needAce = group and group ~= ""
    RegisterCommand(name, function(source, args, rawCommand)
        local aPlayer = AVA.Players.GetPlayer(source)
        local commandString = callback(source, args, rawCommand, aPlayer)

        if aPlayer then
            local logString = GetString("used_command", aPlayer and aPlayer.getDiscordTag() or GetPlayerName(source), rawCommand)
            -- print("^5[COMMAND]^0 " .. logString)
            AVA.Utils.SendWebhookEmbedMessage("avan0x_wh_staff_commands", "", ("%s\n\n%s"):format(logString, commandString or ""), 15902015)
        end
    end, needAce)

    if needAce then
        ExecuteCommand("add_ace group." .. group .. " command." .. name .. " allow")
    end
    if help or params then
        table.insert(AVA.Commands.SuggestionList, {name = name, help = help or "", params = params})
    end

    dprint("Command added: ^3" .. name .. (needAce and "^7, requires principal ^3group." .. group or "") .. "^0")
end
exports("RegisterCommand", AVA.Commands.RegisterCommand)

----------------------------------------
--------------- Vehicles ---------------
----------------------------------------

AVA.Commands.RegisterCommand({"spawnvehicle", "vehicle", "car", "plane", "boat", "bike", "heli"}, "admin", function(source, args)
    if type(args[1]) == "string" then
        TriggerClientEvent("ava_core:client:spawnVehicle", source, args[1])
    end
end, GetString("spawn_vehicle_help"), {{name = "vehicle", help = GetString("vehicle_name")}})

AVA.Commands.RegisterCommand({"deletevehicle", "dv", "removevehicle", "rv"}, "admin", function(source, args)
    TriggerClientEvent("ava_core:client:deleteVehicle", source)
end, GetString("delete_vehicle_help"))

AVA.Commands.RegisterCommand({"repairvehicle", "repair", "r"}, "admin", function(source, args)
    TriggerClientEvent("ava_core:client:repairVehicle", source)
end, GetString("repair_vehicle_help"))

AVA.Commands.RegisterCommand({"flipvehicle", "flipv"}, "admin", function(source, args)
    TriggerClientEvent("ava_core:client:flipVehicle", source)
end, GetString("flip_vehicle_help"))

AVA.Commands.RegisterCommand({"tpnearestvehicle", "tpv"}, "admin", function(source, args)
    TriggerClientEvent("ava_core:client:tpNearestVehicle", source)
end, GetString("tpnearestvehicle_help"))

AVA.Commands.RegisterCommand({"tunevehiclepink", "ava"}, "superadmin", function(source, args)
    TriggerClientEvent("ava_core:client:tuneVehiclePink", source)
end, GetString("tune_vehicle_pink_help"))

------------------------------------
--------------- Kick ---------------
------------------------------------

AVA.Commands.RegisterCommand("kick", "mod", function(source, args, rawCommand, aPlayer)
    if type(args[1]) ~= "string" then
        return
    end
    local id = args[1]
    local reason = table.concat(args, " ", 2)
    if not reason or reason == "" then
        reason = GetString("no_reason_given")
    end

	local license, discord = AVA.Players.GetSourceIdentifiers(id)
    if license then
        local aTargetPlayer = AVA.Players.GetPlayer(id)
        local name = aTargetPlayer and aTargetPlayer.getDiscordTag() or GetPlayerName(id) or "not_found"
        local staffName = aPlayer and aPlayer.getDiscordTag()
        
        local discordMessage
        if aPlayer then
            DropPlayer(id, GetString("you_got_kicked_by", staffName, reason))
            discordMessage = GetString("player_got_kicked_by", string.gsub(discord, "discord:", ""), name, string.gsub(aPlayer.identifiers.discord, "discord:", ""), staffName, reason)
        else
            DropPlayer(id, GetString("you_got_kicked", reason))
            discordMessage = GetString("player_got_kicked", string.gsub(discord, "discord:", ""), name, reason)
        end
                
        AVA.Utils.SendWebhookEmbedMessage("avan0x_wh_staff", "", discordMessage, 16522243) -- #fc1c03
        return discordMessage
    end
end)

----------------------------------------
--------------- Accounts ---------------
----------------------------------------

-- * DEBUG
AVA.Commands.RegisterCommand("debugaccounts", "superadmin", function(source, args, rawCommand, aPlayer)
    if aPlayer then
        dprint("accounts", json.encode(aPlayer.accounts))
    end
end)

AVA.Commands.RegisterCommand("addaccount", "admin", function(source, args)
    if type(args[1]) ~= "string" or type(args[2]) ~= "string" or type(args[3]) ~= "string" and tonumber(args[3]) then
        return
    end

    local aTargetPlayer = AVA.Players.GetPlayer(args[1] == "0" and source or args[1])
    if aTargetPlayer then
        local accountExist = aTargetPlayer.addAccountBalance(args[2], tonumber(args[3]))
        return accountExist and GetString("addaccount_log", aTargetPlayer.getDiscordTag(), args[3], args[2])
    end
end, GetString("addaccount_help"), {
    {name = "player", help = GetString("player_id_or_zero")},
    {name = "account", help = GetString("account_name")},
    {name = "balance", help = GetString("account_balance_amount")},
})

AVA.Commands.RegisterCommand("setaccount", "admin", function(source, args)
    if type(args[1]) ~= "string" or type(args[2]) ~= "string" or type(args[3]) ~= "string" and tonumber(args[3]) then
        return
    end

    local aTargetPlayer = AVA.Players.GetPlayer(args[1] == "0" and source or args[1])
    if aTargetPlayer then
        local accountExist = aTargetPlayer.setAccountBalance(args[2], tonumber(args[3]))
        return accountExist and GetString("setaccount_log", aTargetPlayer.getDiscordTag(), args[3], args[2])
    end
end, GetString("setaccount_help"), {
    {name = "player", help = GetString("player_id_or_zero")},
    {name = "account", help = GetString("account_name")},
    {name = "balance", help = GetString("account_balance_amount")},
})

AVA.Commands.RegisterCommand("removeaccount", "admin", function(source, args)
    if type(args[1]) ~= "string" or type(args[2]) ~= "string" or type(args[3]) ~= "string" and tonumber(args[3]) then
        return
    end

    local aTargetPlayer = AVA.Players.GetPlayer(args[1] == "0" and source or args[1])
    if aTargetPlayer then
        local accountExist = aTargetPlayer.removeAccountBalance(args[2], tonumber(args[3]))
        return accountExist and GetString("removeaccount_log", aTargetPlayer.getDiscordTag(), args[3], args[2])
    end
end, GetString("removeaccount_help"), {
    {name = "player", help = GetString("player_id_or_zero")},
    {name = "account", help = GetString("account_name")},
    {name = "balance", help = GetString("account_balance_amount")},
})

----------------------------------------
--------------- Licenses ---------------
----------------------------------------

-- * DEBUG
AVA.Commands.RegisterCommand("debuglicenses", "superadmin", function(source, args, rawCommand, aPlayer)
    if aPlayer then
        dprint("licenses", json.encode(aPlayer.metadata.licenses))
    end
end)

AVA.Commands.RegisterCommand("addlicense", "admin", function(source, args)
    if type(args[1]) ~= "string" or type(args[2]) ~= "string" then
        return
    end

    local aTargetPlayer = AVA.Players.GetPlayer(args[1] == "0" and source or args[1])
    if aTargetPlayer then
        local licenseAdded = aTargetPlayer.addLicense(args[2])
        return licenseAdded and ("**" .. aTargetPlayer.getDiscordTag() .. "** received license named **" .. args[2] .. "**.")
    end
end, "Add a license to a player", {
    {name = "player", help = GetString("player_id_or_zero")},
    {name = "license", help = "License name (driver, trafficLaws, weapon)"},
})

AVA.Commands.RegisterCommand("removelicense", "admin", function(source, args)
    if type(args[1]) ~= "string" or type(args[2]) ~= "string" then
        return
    end

    local aTargetPlayer = AVA.Players.GetPlayer(args[1] == "0" and source or args[1])
    if aTargetPlayer then
        local licenseRemoved = aTargetPlayer.removeLicense(args[2])
        return licenseRemoved and ("**" .. aTargetPlayer.getDiscordTag() .. "** got the license named **" .. args[2] .. "** removed.")
    end
end, "Remove license from a player", {
    {name = "player", help = GetString("player_id_or_zero")},
    {name = "license", help = "License name (driver, trafficLaws, weapon)"},
})

AVA.Commands.RegisterCommand("setlicensepoints", "admin", function(source, args)
    if type(args[1]) ~= "string" or type(args[2]) ~= "string" or type(args[3]) ~= "string" and tonumber(args[3]) then
        return
    end

    local aTargetPlayer = AVA.Players.GetPlayer(args[1] == "0" and source or args[1])
    if aTargetPlayer then
        local success, quantity = aTargetPlayer.setLicensePoints(args[2], tonumber(args[3]))
        return success and ("**" .. aTargetPlayer.getDiscordTag() .. "** now has **" .. quantity .. "** points to its license named **" .. args[2] .. "**.")
    end
end, "Set quantity of points from a player license", {
    {name = "player", help = GetString("player_id_or_zero")},
    {name = "license", help = "License name (driver, trafficLaws, weapon)"},
    {name = "quantity", help = "Quantity of points"},
})

AVA.Commands.RegisterCommand("addlicensepoints", "admin", function(source, args)
    if type(args[1]) ~= "string" or type(args[2]) ~= "string" or type(args[3]) ~= "string" and tonumber(args[3]) then
        return
    end

    local aTargetPlayer = AVA.Players.GetPlayer(args[1] == "0" and source or args[1])
    if aTargetPlayer then
        local success, quantity = aTargetPlayer.addLicensePoints(args[2], tonumber(args[3]))
        return success and ("**" .. aTargetPlayer.getDiscordTag() .. "** now has **" .. quantity .. "** points to its license named **" .. args[2] .. "**.")
    end
end, "Add points to a player license", {
    {name = "player", help = GetString("player_id_or_zero")},
    {name = "license", help = "License name (driver, trafficLaws, weapon)"},
    {name = "quantity", help = "Quantity of points"},
})

AVA.Commands.RegisterCommand("removelicensepoints", "admin", function(source, args)
    if type(args[1]) ~= "string" or type(args[2]) ~= "string" or type(args[3]) ~= "string" and tonumber(args[3]) then
        return
    end

    local aTargetPlayer = AVA.Players.GetPlayer(args[1] == "0" and source or args[1])
    if aTargetPlayer then
        local success, quantity = aTargetPlayer.removeLicensePoints(args[2], tonumber(args[3]))
        return success and ("**" .. aTargetPlayer.getDiscordTag() .. "** now has **" .. quantity .. "** points to its license named **" .. args[2] .. "**.")
    end
end, "Remove points from a player license", {
    {name = "player", help = GetString("player_id_or_zero")},
    {name = "license", help = "License name (driver, trafficLaws, weapon)"},
    {name = "quantity", help = "Quantity of points"},
})

-----------------------------------------
--------------- Inventory ---------------
-----------------------------------------

AVA.Commands.RegisterCommand("clearinventory", "admin", function(source, args)
    local aTargetPlayer = AVA.Players.GetPlayer(type(args[1]) == "string" and args[1] or source)
    if aTargetPlayer then
        aTargetPlayer.getInventory().clearInventory()
    end
end, "Clear player inventory", {{name = "player", help = "Player id, empty if yourself"}})

-----------------------------------------
--------------- Teleports ---------------
-----------------------------------------

AVA.Commands.RegisterCommand({"tpcoords", "tp"}, "admin", function(source, args)
    if type(args[1]) ~= "string" or type(args[2]) ~= "string" or type(args[3]) ~= "string" then
        return
    end

    local x = tonumber((string.gsub(args[1], ",$", ""))) -- double parentheses are needed to only use first return of gsub
    local y = tonumber((string.gsub(args[2], ",$", "")))
    local z = tonumber(type(args[3]) == "string" and (string.gsub(args[3], ",$", "")) or 0)

    if x and y and z then
        TriggerClientEvent("ava_core:client:teleportToCoords", source, x, y, z)
        return GetString("tp_log", AVA.Utils.Vector3ToString(vector3(x, y, z)))
    end
end, GetString("tp_help"), {{name = "x", help = "number[,]"}, {name = "y", help = "number[,]"}, {name = "z", help = "number[,] or empty"}})

AVA.Commands.RegisterCommand("goto", "mod", function(source, args)
    if type(args[1]) ~= "string" or tostring(args[1]) == tostring(source) then
        return
    end

    local targetPed = GetPlayerPed(args[1])
    if targetPed and targetPed ~= 0 then
        if GetPlayerRoutingBucket(source) ~= GetPlayerRoutingBucket(args[1]) then
            print("^1[ERROR] ^0Player ^3" .. args[1] .. "^0 is in another routing bucket")
        else
            local targetCoords = GetEntityCoords(targetPed)
            if targetCoords ~= vector3(0.0, 0.0, 0.0) then
                TriggerClientEvent("ava_core:client:teleportToCoords", source, targetCoords.x, targetCoords.y, targetCoords.z)
                return GetString("goto_log", AVA.Utils.Vector3ToString(targetCoords))
            end
        end
    end
end, GetString("goto_help"), {{name = "player", help = GetString("player_id")}})

AVA.Commands.RegisterCommand({"bring", "summon"}, "mod", function(source, args)
    if type(args[1]) ~= "string" or tostring(args[1]) == tostring(source) then
        return
    end

    local aTargetPlayer = AVA.Players.GetPlayer(args[1])
    local sourcePed = GetPlayerPed(source)
    if aTargetPlayer and sourcePed and sourcePed ~= 0 then
        if GetPlayerRoutingBucket(source) ~= GetPlayerRoutingBucket(args[1]) then
            print("^1[ERROR] ^0Player ^3" .. args[1] .. "^0 is in another routing bucket")
        else
            local sourceCoords = GetEntityCoords(sourcePed)
            if sourceCoords ~= vector3(0.0, 0.0, 0.0) then
                TriggerClientEvent("ava_core:client:teleportToCoords", args[1], sourceCoords.x, sourceCoords.y, sourceCoords.z)
                return GetString("summon_log", aTargetPlayer.getDiscordTag(), AVA.Utils.Vector3ToString(sourceCoords))
            end
        end
    end
end, GetString("summon_help"), {{name = "player", help = GetString("player_id")}})

AVA.Commands.RegisterCommand({"tpwaypoint", "tpm", "tpmarker", "tpw"}, "admin", function(source, args)
    TriggerClientEvent("ava_core:client:teleportToWaypoint", source)
    return GetString("tpwaypoint_log")
end, GetString("tpwaypoint_help"))

--------------------------------------
--------------- Others ---------------
--------------------------------------

AVA.Commands.RegisterCommand("save", "", function(_, _, _, aPlayer)
    if aPlayer then
        aPlayer.save()
    end
end)

AVA.Commands.RegisterCommand("myid", "", function(source, args)
    TriggerClientEvent("chat:addMessage", source, {args = {GetString("myid_message", source)}})
end, GetString("myid_help"))

-- AVA.Commands.RegisterCommand("report", "", function(source, args)
--     TriggerClientEvent("chat:addMessage", source, {args = {"hey this should report, maybe, maybe not"}})
-- end, "report", {{name = "reason", help = "your_reason"}})

AVA.Commands.RegisterCommand("kill", "admin", function(source, args, rawCommand, aPlayer)
    if type(args[1]) == "string" and args[1] ~= "0" and args[1] ~= tostring(source) then
        local aTargetPlayer = AVA.Players.GetPlayer(args[1])
        if aTargetPlayer then
            TriggerClientEvent("ava_core:client:kill", args[1])
            return GetString("kill_log", aTargetPlayer.getDiscordTag(), aPlayer and aPlayer.getDiscordTag() or "console")
        end
    else
        TriggerClientEvent("ava_core:client:kill", source)
    end
end, GetString("kill_help"), {{name = "player", help = GetString("player_id_or_empty")}})
