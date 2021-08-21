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
        local commandString = callback(source, args, rawCommand)

        local aPlayer = AVA.Players.GetPlayer(source)
        local logString = ("**%s** used command `/%s`"):format(aPlayer and aPlayer.getDiscordTag() or GetPlayerName(source), rawCommand)
        -- print("^5[COMMAND]^0 " .. logString)
        AVA.Utils.SendWebhookEmbedMessage("avan0x_wh_staff_commands", "", ("%s\n\n%s"):format(logString, commandString or ""), 15902015)
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
        TriggerClientEvent("ava:client:spawnVehicle", source, args[1])
    end
end, "spawn_car", {{name = "car", help = "car_name"}})

AVA.Commands.RegisterCommand({"deletevehicle", "dv", "removevehicle", "rv"}, "admin", function(source, args)
    TriggerClientEvent("ava:client:deleteVehicle", source)
end, "delete_car")

----------------------------------------
--------------- Accounts ---------------
----------------------------------------

-- * DEBUG
AVA.Commands.RegisterCommand("debugaccounts", "superadmin", function(source, args)
    local aPlayer = AVA.Players.GetPlayer(source)
    if aPlayer then
        dprint("accounts", json.encode(aPlayer.accounts))
    end
end)

AVA.Commands.RegisterCommand("addaccount", "admin", function(source, args)
    if type(args[1]) ~= "string" or type(args[2]) ~= "string" or type(args[3]) ~= "string" and tonumber(args[3]) then
        return
    end

    local aPlayer = AVA.Players.GetPlayer(args[1] == "0" and source or args[1])
    if aPlayer then
        local accountExist = aPlayer.addAccountBalance(args[2], tonumber(args[3]))
        return accountExist and ("**" .. aPlayer.getDiscordTag() .. "** received **" .. args[3] .. " $** on account named **" .. args[2] .. "**.")
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

    local aPlayer = AVA.Players.GetPlayer(args[1] == "0" and source or args[1])
    if aPlayer then
        local accountExist = aPlayer.setAccountBalance(args[2], tonumber(args[3]))
        return accountExist and ("**" .. aPlayer.getDiscordTag() .. "** on account named " .. args[2] .. " has its balance set to **" .. args[3] .. "**.")
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

    local aPlayer = AVA.Players.GetPlayer(args[1] == "0" and source or args[1])
    if aPlayer then
        local accountExist = aPlayer.removeAccountBalance(args[2], tonumber(args[3]))
        return accountExist and ("**" .. aPlayer.getDiscordTag() .. "** deducted **" .. args[3] .. " $** on account named **" .. args[2] .. "**.")
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
AVA.Commands.RegisterCommand("debuglicenses", "superadmin", function(source, args)
    local aPlayer = AVA.Players.GetPlayer(source)
    if aPlayer then
        dprint("licenses", json.encode(aPlayer.metadata.licenses))
    end
end)

AVA.Commands.RegisterCommand("addlicense", "admin", function(source, args)
    if type(args[1]) ~= "string" or type(args[2]) ~= "string" then
        return
    end

    local aPlayer = AVA.Players.GetPlayer(args[1] == "0" and source or args[1])
    if aPlayer then
        local licenseAdded = aPlayer.addLicense(args[2])
        return licenseAdded and ("**" .. aPlayer.getDiscordTag() .. "** received license named **" .. args[2] .. "**.")
    end
end, "Add a license to a player",
    {{name = "player", help = "Player id, 0 is yourself"}, {name = "license", help = "License name (driver, trafficLaws, weapon)"}})

AVA.Commands.RegisterCommand("removelicense", "admin", function(source, args)
    if type(args[1]) ~= "string" or type(args[2]) ~= "string" then
        return
    end

    local aPlayer = AVA.Players.GetPlayer(args[1] == "0" and source or args[1])
    if aPlayer then
        local licenseRemoved = aPlayer.removeLicense(args[2])
        return licenseRemoved and ("**" .. aPlayer.getDiscordTag() .. "** got the license named **" .. args[2] .. "** removed.")
    end
end, "Remove license from a player",
    {{name = "player", help = "Player id, 0 is yourself"}, {name = "license", help = "License name (driver, trafficLaws, weapon)"}})

AVA.Commands.RegisterCommand("setlicensepoints", "admin", function(source, args)
    if type(args[1]) ~= "string" or type(args[2]) ~= "string" or type(args[3]) ~= "string" and tonumber(args[3]) then
        return
    end

    local aPlayer = AVA.Players.GetPlayer(args[1] == "0" and source or args[1])
    if aPlayer then
        local success, quantity = aPlayer.setLicensePoints(args[2], tonumber(args[3]))
        return success and ("**" .. aPlayer.getDiscordTag() .. "** now has **" .. quantity .. "** points to its license named **" .. args[2] .. "**.")
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

    local aPlayer = AVA.Players.GetPlayer(args[1] == "0" and source or args[1])
    if aPlayer then
        local success, quantity = aPlayer.addLicensePoints(args[2], tonumber(args[3]))
        return success and ("**" .. aPlayer.getDiscordTag() .. "** now has **" .. quantity .. "** points to its license named **" .. args[2] .. "**.")
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

    local aPlayer = AVA.Players.GetPlayer(args[1] == "0" and source or args[1])
    if aPlayer then
        local success, quantity = aPlayer.removeLicensePoints(args[2], tonumber(args[3]))
        return success and ("**" .. aPlayer.getDiscordTag() .. "** now has **" .. quantity .. "** points to its license named **" .. args[2] .. "**.")
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
    local aPlayer = AVA.Players.GetPlayer(type(args[1]) == "string" and args[1] or source)
    if aPlayer then
        aPlayer.getInventory().clearInventory()
    end
end, "Clear player inventory", {{name = "player", help = "Player id, empty if yourself"}})

--------------------------------------
--------------- Others ---------------
--------------------------------------

AVA.Commands.RegisterCommand("report", "", function(source, args)
    TriggerClientEvent("chat:addMessage", source, {args = {"hey this should report, maybe, maybe not"}})
end, "report", {{name = "reason", help = "your_reason"}})

