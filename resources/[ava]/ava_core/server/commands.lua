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
    elseif type(callback) ~= "function" then
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
            local logString = ("**%s** used command `/%s`"):format(aPlayer and aPlayer.getDiscordTag() or GetPlayerName(source), rawCommand)
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

    dprint("Command added: ^3" .. name .. (needAce and "^7, requires principal ^3group." .. group or "") .. "^7")
end
exports("RegisterCommand", AVA.Commands.RegisterCommand)

----------------------------------------
--------------- Vehicles ---------------
----------------------------------------

AVA.Commands.RegisterCommand({"vehicle", "car", "plane", "boat", "bike", "heli"}, "admin", function(source, args)
    if type(args[1]) == "string" then
        TriggerClientEvent("ava_core:client:spawnVehicle", source, args[1])
    end
end, "spawn_car", {{name = "car", help = "car_name"}})

AVA.Commands.RegisterCommand({"deletevehicle", "dv", "removevehicle", "rv"}, "admin", function(source, args)
    TriggerClientEvent("ava_core:client:deleteVehicle", source)
end, "delete_car")

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
        return accountExist and ("**" .. aTargetPlayer.getDiscordTag() .. "** received **" .. args[3] .. " $** on account named **" .. args[2] .. "**.")
    end
end, "Add money to a player account balance", {
    {name = "player", help = "Player id, 0 is yourself"},
    {name = "account", help = "Account name (bank)"},
    {name = "balance", help = "Money amount"},
})

AVA.Commands.RegisterCommand("setaccount", "admin", function(source, args)
    if type(args[1]) ~= "string" or type(args[2]) ~= "string" or type(args[3]) ~= "string" and tonumber(args[3]) then
        return
    end

    local aTargetPlayer = AVA.Players.GetPlayer(args[1] == "0" and source or args[1])
    if aTargetPlayer then
        local accountExist = aTargetPlayer.setAccountBalance(args[2], tonumber(args[3]))
        return accountExist and ("**" .. aTargetPlayer.getDiscordTag() .. "** on account named " .. args[2] .. " has its balance set to **" .. args[3] .. "**.")
    end
end, "Set balance of a player account", {
    {name = "player", help = "Player id, 0 is yourself"},
    {name = "account", help = "Account name (bank)"},
    {name = "balance", help = "Money amount"},
})

AVA.Commands.RegisterCommand("removeaccount", "admin", function(source, args)
    if type(args[1]) ~= "string" or type(args[2]) ~= "string" or type(args[3]) ~= "string" and tonumber(args[3]) then
        return
    end

    local aTargetPlayer = AVA.Players.GetPlayer(args[1] == "0" and source or args[1])
    if aTargetPlayer then
        local accountExist = aTargetPlayer.removeAccountBalance(args[2], tonumber(args[3]))
        return accountExist and ("**" .. aTargetPlayer.getDiscordTag() .. "** deducted **" .. args[3] .. " $** on account named **" .. args[2] .. "**.")
    end
end, "Remove money from a player account balance", {
    {name = "player", help = "Player id, 0 is yourself"},
    {name = "account", help = "Account name (bank)"},
    {name = "balance", help = "Money amount"},
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
end, "Add a license to a player",
    {{name = "player", help = "Player id, 0 is yourself"}, {name = "license", help = "License name (driver, trafficLaws, weapon)"}})

AVA.Commands.RegisterCommand("removelicense", "admin", function(source, args)
    if type(args[1]) ~= "string" or type(args[2]) ~= "string" then
        return
    end

    local aTargetPlayer = AVA.Players.GetPlayer(args[1] == "0" and source or args[1])
    if aTargetPlayer then
        local licenseRemoved = aTargetPlayer.removeLicense(args[2])
        return licenseRemoved and ("**" .. aTargetPlayer.getDiscordTag() .. "** got the license named **" .. args[2] .. "** removed.")
    end
end, "Remove license from a player",
    {{name = "player", help = "Player id, 0 is yourself"}, {name = "license", help = "License name (driver, trafficLaws, weapon)"}})

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
    {name = "player", help = "Player id, 0 is yourself"},
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
    {name = "player", help = "Player id, 0 is yourself"},
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
    {name = "player", help = "Player id, 0 is yourself"},
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

AVA.Commands.RegisterCommand("tp", "admin", function(source, args)
    local x = tonumber((string.gsub(args[1], ",$", ""))) -- double parentheses are needed to only use first return of gsub
    local y = tonumber((string.gsub(args[2], ",$", "")))
    local z = tonumber(type(args[3]) == "string" and (string.gsub(args[3], ",$", "")) or 0)

    if x and y and z then
        TriggerClientEvent("ava_core:client:teleportToCoords", source, x, y, z)
        return "Teleported to **" .. AVA.Utils.Vector3ToString(vector3(x, y, z)) .. "**."
    end
end, "Teleport to coords", {{name = "x", help = "number[,]"}, {name = "y", help = "number[,]"}, {name = "z", help = "number[,] or empty"}})

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
                return "Teleported to **" .. AVA.Utils.Vector3ToString(targetCoords) .. "**."
            end
        end
    end
end, "Teleport to a player", {{name = "player", help = "Other player id"}})

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
                return "**" .. aTargetPlayer.getDiscordTag() .. "** teleported to **" .. AVA.Utils.Vector3ToString(sourceCoords) .. "**."
            end
        end
    end
end, "Teleport a player to me", {{name = "player", help = "Other player id"}})

AVA.Commands.RegisterCommand({"tpm", "tpmarker", "tpw", "tpwaypoint"}, "admin", function(source, args)
    TriggerClientEvent("ava_core:client:teleportToWaypoint", source)
    return "Teleported to its waypoint."
end, "Teleport to waypoint")

--------------------------------------
--------------- Others ---------------
--------------------------------------

AVA.Commands.RegisterCommand("report", "", function(source, args)
    TriggerClientEvent("chat:addMessage", source, {args = {"hey this should report, maybe, maybe not"}})
end, "report", {{name = "reason", help = "your_reason"}})

AVA.Commands.RegisterCommand("kill", "admin", function(source, args, rawCommand, aPlayer)
    if type(args[1]) == "string" and args[1] ~= "0" and args[1] ~= tostring(source) then
        local aTargetPlayer = AVA.Players.GetPlayer(args[1])
        if aTargetPlayer then
            TriggerClientEvent("ava_core:client:kill", args[1])
            return "**" .. aTargetPlayer.getDiscordTag() .. "** has been killed by **" .. aPlayer and aPlayer.getDiscordTag() or "console" .. "."
        end
    else
        TriggerClientEvent("ava_core:client:kill", source)
    end
end, "Kill a player", {{name = "player", help = "Player id, 0 or empty is yourself"}})
