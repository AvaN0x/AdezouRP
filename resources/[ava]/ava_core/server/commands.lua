-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVA.Commands = {}
AVA.Commands.SuggestionList = {}

---Register a command using ace permissions to a group
---@param name string|table
---@param group string|nil
---@param callback fun(source: any, args: table, rawCommand: string) "this can return a string that will be added to the discord log"
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
        if aPlayer then
            TriggerEvent("ava_logs:server:log", { aPlayer.getDiscordTag(), "citizenid:" .. aPlayer.citizenId, "use_command", rawCommand })
        end

        local commandString = callback(source, args, rawCommand, aPlayer)

        local logString = GetString("used_command", aPlayer and aPlayer.getDiscordTag() or "console", rawCommand)
        AVA.Utils.SendWebhookEmbedMessage("avan0x_wh_staff_commands", "", ("%s\n\n%s"):format(logString, commandString or ""), 0xF2A53F)
    end, needAce)

    if needAce then
        AVA.AddAce("group." .. group, "command." .. name)
    end
    if help or params then
        table.insert(AVA.Commands.SuggestionList, { name = name, help = help or "", params = params })
    end

    dprint("Command added: ^3" .. name .. (needAce and "^7, requires principal ^3group." .. group or "") .. "^0")
end
exports("RegisterCommand", AVA.Commands.RegisterCommand)

AVA.Commands.RegisterCommand("saveall", "superadmin", function(source, args, rawCommand)
    AVA.SaveEverything()
end)

----------------------------------------
--------------- Vehicles ---------------
----------------------------------------

AVA.Commands.RegisterCommand({ "spawnvehicle", "vehicle", "car", "plane", "boat", "bike", "heli" }, "admin", function(source, args)
    if source > 0 and type(args[1]) == "string" then
        TriggerClientEvent("ava_core:client:spawnVehicle", source, args[1])
    end
end, GetString("spawn_vehicle_help"), { { name = "vehicle", help = GetString("vehicle_name") } })

AVA.Commands.RegisterCommand({ "deletevehicle", "dv", "removevehicle", "rv" }, "admin", function(source, args)
    if source > 0 then
        TriggerClientEvent("ava_core:client:deleteVehicle", source)
    end
end, GetString("delete_vehicle_help"))

AVA.Commands.RegisterCommand({ "repairvehicle", "repair", "r" }, "admin", function(source, args)
    if source > 0 then
        TriggerClientEvent("ava_core:client:repairVehicle", source)
    end
end, GetString("repair_vehicle_help"))

AVA.Commands.RegisterCommand({ "flipvehicle", "flipv" }, "admin", function(source, args)
    if source > 0 then
        TriggerClientEvent("ava_core:client:flipVehicle", source)
    end
end, GetString("flip_vehicle_help"))

AVA.Commands.RegisterCommand({ "tpnearestvehicle", "tpv" }, "admin", function(source, args)
    if source > 0 then
        TriggerClientEvent("ava_core:client:tpNearestVehicle", source)
    end
end, GetString("tpnearestvehicle_help"))

AVA.Commands.RegisterCommand({ "tunevehiclepink", "ava" }, "superadmin", function(source, args)
    if source > 0 then
        TriggerClientEvent("ava_core:client:tuneVehiclePink", source, args[1])
    end
end, GetString("tune_vehicle_pink_help"), { { name = "vehicle?", help = GetString("vehicle_name") } })

AVA.Commands.RegisterCommand("getvehicledata", "admin", function(source, args)
    if source > 0 then
        TriggerClientEvent("ava_core:client:getvehicledata", source)
    end
end, GetString("getvehicledata_help"))

------------------------------------
--------------- Anim ---------------
------------------------------------

AVA.Commands.RegisterCommand({ "anim", "a" }, "admin", function(source, args)
    if source > 0 and type(args[1]) == "string" and type(args[2]) == "string" then
        TriggerClientEvent("ava_core:client:anim", source, args[1], args[2])
    end
end, GetString("anim_help"), { { name = "animdict", help = GetString("anim_dict") }, { name = "animname", help = GetString("anim_name") } })

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
            discordMessage = GetString("player_got_kicked_by", string.gsub(discord, "discord:", ""), name,
                string.gsub(aPlayer.identifiers.discord, "discord:", ""), staffName, reason)
        else
            DropPlayer(id, GetString("you_got_kicked", reason))
            discordMessage = GetString("player_got_kicked", string.gsub(discord, "discord:", ""), name, reason)
        end

        AVA.Utils.SendWebhookEmbedMessage("avan0x_wh_staff", "", discordMessage, 0xFC1C03)
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
    { name = "player", help = GetString("player_id_or_zero") },
    { name = "account", help = GetString("account_name") },
    { name = "balance", help = GetString("account_balance_amount") },
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
    { name = "player", help = GetString("player_id_or_zero") },
    { name = "account", help = GetString("account_name") },
    { name = "balance", help = GetString("account_balance_amount") },
})

AVA.Commands.RegisterCommand({ "removeaccount", "remaccount" }, "admin", function(source, args)
    if type(args[1]) ~= "string" or type(args[2]) ~= "string" or type(args[3]) ~= "string" and tonumber(args[3]) then
        return
    end

    local aTargetPlayer = AVA.Players.GetPlayer(args[1] == "0" and source or args[1])
    if aTargetPlayer then
        local accountExist = aTargetPlayer.removeAccountBalance(args[2], tonumber(args[3]))
        return accountExist and GetString("removeaccount_log", aTargetPlayer.getDiscordTag(), args[3], args[2])
    end
end, GetString("removeaccount_help"), {
    { name = "player", help = GetString("player_id_or_zero") },
    { name = "account", help = GetString("account_name") },
    { name = "balance", help = GetString("account_balance_amount") },
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
end, "Add a license to a player", { { name = "player", help = GetString("player_id_or_zero") }, { name = "license", help = GetString("license_name") } })

AVA.Commands.RegisterCommand({ "removelicense", "remlicense" }, "admin", function(source, args)
    if type(args[1]) ~= "string" or type(args[2]) ~= "string" then
        return
    end

    local aTargetPlayer = AVA.Players.GetPlayer(args[1] == "0" and source or args[1])
    if aTargetPlayer then
        local licenseRemoved = aTargetPlayer.removeLicense(args[2])
        return licenseRemoved and ("**" .. aTargetPlayer.getDiscordTag() .. "** got the license named **" .. args[2] .. "** removed.")
    end
end, "Remove license from a player", { { name = "player", help = GetString("player_id_or_zero") }, { name = "license", help = GetString("license_name") } })

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
    { name = "player", help = GetString("player_id_or_zero") },
    { name = "license", help = GetString("license_name") },
    { name = "quantity", help = "Quantity of points" },
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
    { name = "player", help = GetString("player_id_or_zero") },
    { name = "license", help = GetString("license_name") },
    { name = "quantity", help = "Quantity of points" },
})

AVA.Commands.RegisterCommand({ "removelicensepoints", "remlicensepoints" }, "admin", function(source, args)
    if type(args[1]) ~= "string" or type(args[2]) ~= "string" or type(args[3]) ~= "string" and tonumber(args[3]) then
        return
    end

    local aTargetPlayer = AVA.Players.GetPlayer(args[1] == "0" and source or args[1])
    if aTargetPlayer then
        local success, quantity = aTargetPlayer.removeLicensePoints(args[2], tonumber(args[3]))
        return success and ("**" .. aTargetPlayer.getDiscordTag() .. "** now has **" .. quantity .. "** points to its license named **" .. args[2] .. "**.")
    end
end, "Remove points from a player license", {
    { name = "player", help = GetString("player_id_or_zero") },
    { name = "license", help = GetString("license_name") },
    { name = "quantity", help = "Quantity of points" },
})

------------------------------------
--------------- Jobs ---------------
------------------------------------

-- * DEBUG
AVA.Commands.RegisterCommand("debugjobs", "superadmin", function(source, args, rawCommand, aPlayer)
    if aPlayer then
        dprint("jobs", json.encode(aPlayer.jobs))
    end
end)

AVA.Commands.RegisterCommand("addjob", "admin", function(source, args)
    if type(args[1]) ~= "string" or type(args[2]) ~= "string" then
        return
    end

    local aTargetPlayer = AVA.Players.GetPlayer(args[1] == "0" and source or args[1])
    if aTargetPlayer then
        local cfgJob = AVAConfig.Jobs[args[2]]
        if not cfgJob or cfgJob.isGang then
            TriggerClientEvent("chat:addMessage", source, { color = { 255, 0, 0 }, multiline = false, args = { "AvaCore", GetString("job_do_not_exist") } })

        else
            if aTargetPlayer.canAddAnotherJob() or aTargetPlayer.hasJob(args[2]) then
                local jobAdded, finalGrade = aTargetPlayer.addJob(args[2], args[3])
                return jobAdded and GetString("addjob_log", aTargetPlayer.getDiscordTag(), args[2], finalGrade)
            else
                TriggerClientEvent("chat:addMessage", source,
                    { color = { 255, 0, 0 }, multiline = false, args = { "AvaCore", GetString("job_player_cannot_have_more_jobs") } })
            end
        end
    end
end, GetString("addjob_help"), {
    { name = "player", help = GetString("player_id_or_zero") },
    { name = "job", help = GetString("job_name") },
    { name = "grade?", help = GetString("job_grade_name") },
})

AVA.Commands.RegisterCommand({ "removejob", "remjob" }, "admin", function(source, args)
    if type(args[1]) ~= "string" or type(args[2]) ~= "string" then
        return
    end

    local aTargetPlayer = AVA.Players.GetPlayer(args[1] == "0" and source or args[1])
    if aTargetPlayer then
        local cfgJob = AVAConfig.Jobs[args[2]]
        if not cfgJob or cfgJob.isGang then
            TriggerClientEvent("chat:addMessage", source, { color = { 255, 0, 0 }, multiline = false, args = { "AvaCore", GetString("job_do_not_exist") } })
        else
            local jobRemoved = aTargetPlayer.removeJob(args[2])
            return jobRemoved and GetString("removejob_log", aTargetPlayer.getDiscordTag(), args[2])
        end
    end
end, GetString("removejob_help"), { { name = "player", help = GetString("player_id_or_zero") }, { name = "job", help = GetString("job_name") } })


AVA.Commands.RegisterCommand("addalljobs", "superadmin", function(source, args, rawCommand, aPlayer)
    local aTargetPlayer = AVA.Players.GetPlayer(type(args[1]) == "string" and args[1] or source)
    if aTargetPlayer then
        for jobName, cfgJob in pairs(AVAConfig.Jobs) do
            local gradeName <const> = cfgJob.grades[#cfgJob.grades].name
            aTargetPlayer.addJob(jobName, gradeName)
        end
        return GetString("addalljobs_log", aPlayer and aPlayer.getDiscordTag() or "console", aTargetPlayer.getDiscordTag())
    end
end, GetString("addalljobs_help"), {
    { name = "player", help = GetString("player_id_or_empty") },
})

AVA.Commands.RegisterCommand({ "removealljobs", "remalljobs" }, "superadmin", function(source, args, rawCommand, aPlayer)
    local aTargetPlayer = AVA.Players.GetPlayer(type(args[1]) == "string" and args[1] or source)
    if aTargetPlayer then
        local playerJobs = aTargetPlayer.getJobs()
        for i = #playerJobs, 1, -1 do
            aTargetPlayer.removeJob(playerJobs[i].name)
        end

        return GetString("removealljobs_log", aPlayer and aPlayer.getDiscordTag() or "console", aTargetPlayer.getDiscordTag())
    end
end, GetString("removealljobs_help"), {
    { name = "player", help = GetString("player_id_or_empty") },
})

AVA.Commands.RegisterCommand("addgang", "admin", function(source, args)
    if type(args[1]) ~= "string" or type(args[2]) ~= "string" then
        return
    end

    local aTargetPlayer = AVA.Players.GetPlayer(args[1] == "0" and source or args[1])
    if aTargetPlayer then
        local cfgJob = AVAConfig.Jobs[args[2]]
        if not cfgJob or not cfgJob.isGang then
            TriggerClientEvent("chat:addMessage", source, { color = { 255, 0, 0 }, multiline = false, args = { "AvaCore", GetString("gang_do_not_exist") } })

        else
            if aTargetPlayer.canAddAnotherGang() or aTargetPlayer.hasJob(args[2]) then
                local jobAdded, finalGrade = aTargetPlayer.addJob(args[2], args[3])
                return jobAdded and GetString("addgang_log", aTargetPlayer.getDiscordTag(), args[2], finalGrade)
            else
                TriggerClientEvent("chat:addMessage", source,
                    { color = { 255, 0, 0 }, multiline = false, args = { "AvaCore", GetString("gang_player_cannot_have_more_gangs") } })
            end
        end
    end
end, GetString("addgang_help"), {
    { name = "player", help = GetString("player_id_or_zero") },
    { name = "gang", help = GetString("gang_name") },
    { name = "grade?", help = GetString("gang_grade_name") },
})

AVA.Commands.RegisterCommand({ "removegang", "remgang" }, "admin", function(source, args)
    if type(args[1]) ~= "string" or type(args[2]) ~= "string" then
        return
    end

    local aTargetPlayer = AVA.Players.GetPlayer(args[1] == "0" and source or args[1])
    if aTargetPlayer then
        local cfgJob = AVAConfig.Jobs[args[2]]
        if not cfgJob or not cfgJob.isGang then
            TriggerClientEvent("chat:addMessage", source, { color = { 255, 0, 0 }, multiline = false, args = { "AvaCore", GetString("gang_do_not_exist") } })
        else
            local jobRemoved = aTargetPlayer.removeJob(args[2])
            return jobRemoved and GetString("removegang_log", aTargetPlayer.getDiscordTag(), args[2])
        end
    end
end, GetString("removegang_help"), { { name = "player", help = GetString("player_id_or_zero") }, { name = "gang", help = GetString("gang_name") } })

-----------------------------------------
--------------- Inventory ---------------
-----------------------------------------

AVA.Commands.RegisterCommand("clearinventory", "admin", function(source, args)
    local aTargetPlayer = AVA.Players.GetPlayer(type(args[1]) == "string" and args[1] or source)
    if aTargetPlayer then
        aTargetPlayer.getInventory().clearInventory()
    end
end, GetString("clearinventory_help"), { { name = "player?", help = GetString("player_id_or_empty") } })

AVA.Commands.RegisterCommand("giveitem", "admin", function(source, args)
    if type(args[1]) ~= "string" or type(args[2]) ~= "string" or type(args[3]) ~= "string" and tonumber(args[3]) then
        return
    end

    local aTargetPlayer = AVA.Players.GetPlayer(args[1] == "0" and source or args[1])
    if aTargetPlayer then
        if not aTargetPlayer.getInventory().addItem(args[2], tonumber(args[3]) or 1) then
            TriggerClientEvent("chat:addMessage", source, { color = { 255, 0, 0 }, multiline = false, args = { "AvaCore", GetString("item_do_not_exist") } })
        end
    end
end, GetString("give_item_help"), {
    { name = "player", help = GetString("player_id_or_zero") },
    { name = "itemName", help = GetString("item_name") },
    { name = "quantity", help = GetString("quantity") },
})

AVA.Commands.RegisterCommand("giveitemtype", "superadmin", function(source, args)
    if type(args[1]) ~= "string" or type(args[2]) ~= "string" then
        return
    end

    local aTargetPlayer = AVA.Players.GetPlayer(args[1] == "0" and source or args[1])
    if aTargetPlayer then
        local inventory = aTargetPlayer.getInventory()
        local quantity = type(args[3]) == "string" and tonumber(args[3]) or 1
        local found = false
        for itemName, item in pairs(AVAConfig.Items) do
            if item.type == args[2] then
                inventory.addItem(itemName, quantity)
                found = true
            end
        end
        if not found then
            TriggerClientEvent("chat:addMessage", source, { color = { 255, 0, 0 }, multiline = false, args = { "AvaCore", GetString("item_type_do_not_exist") } })
        end
    end
end, GetString("give_item_help"), {
    { name = "player", help = GetString("player_id_or_zero") },
    { name = "itemTypeName", help = GetString("item_type_name") },
    { name = "quantity?", help = GetString("quantity") },
})

AVA.Commands.RegisterCommand("giveallitems", "superadmin", function(source, args)
    local aTargetPlayer = AVA.Players.GetPlayer(args[1] and (args[1] == "0" and source or args[1]) or source)
    if aTargetPlayer then
        local inventory = aTargetPlayer.inventory
        for k, v in pairs(AVAConfig.Items) do
            inventory.addItem(k, 1)
        end
    end
end, GetString("give_all_items_help"), { { name = "player", help = GetString("player_id_or_empty") } })

AVA.Commands.RegisterCommand({ "removeitem", "remitem" }, "admin", function(source, args)
    if type(args[1]) ~= "string" or type(args[2]) ~= "string" then
        return
    end

    local aTargetPlayer = AVA.Players.GetPlayer(args[1] == "0" and source or args[1])
    if aTargetPlayer then
        if not aTargetPlayer.getInventory().removeItem(args[2], type(args[3]) == "string" and tonumber(args[3]) or 1) then
            TriggerClientEvent("chat:addMessage", source, { color = { 255, 0, 0 }, multiline = false, args = { "AvaCore", GetString("item_do_not_exist") } })
        end
    end
end, GetString("remove_item_help"), {
    { name = "player", help = GetString("player_id_or_zero") },
    { name = "itemName", help = GetString("item_name") },
    { name = "quantity", help = GetString("quantity") },
})

AVA.Commands.RegisterCommand("createpickup", "admin", function(source, args)
    if type(args[1]) ~= "string" then
        return
    end

    local playerPed = GetPlayerPed(source)
    if playerPed then
        local playerCoords = GetEntityCoords(playerPed)

        AVA.CreatePickup(vector3(playerCoords.x, playerCoords.y, playerCoords.z - 1.0), args[1], type(args[2]) == "string" and tonumber(args[2]) or 1)
    end
end, GetString("create_pickup_help"), { { name = "itemName", help = GetString("item_name") }, { name = "quantity", help = GetString("quantity") } })

-----------------------------------
--------------- Ped ---------------
-----------------------------------

exports.ava_core:RegisterCommand("setped", "admin", function(source, args, rawCommand, aPlayer)
    if type(args[1]) == "string" and type(args[2]) == "string" then
        local src = args[1] == "0" and source or tonumber(args[1])
        if src > 0 then
            local aTargetPlayer = AVA.Players.GetPlayer(src)
            if aTargetPlayer then
                TriggerClientEvent("ava_core:client:setped", src, args[2])
                return GetString("setped_log", aTargetPlayer.getDiscordTag(), args[2], aPlayer and aPlayer.getDiscordTag() or "console")
            end
        end
    end
end, GetString("setped_help"), { { name = "player", help = GetString("player_id_or_zero") }, { name = "pedName", help = GetString("ped_name") } })

exports.ava_core:RegisterCommand("resetped", "admin", function(source, args, rawCommand, aPlayer)
    if type(args[1]) == "string" and args[1] ~= "0" and args[1] ~= tostring(source) then
        local aTargetPlayer = AVA.Players.GetPlayer(args[1])
        if aTargetPlayer then
            TriggerClientEvent("ava_core:client:resetped", args[1])
            return GetString("resetped_log", aTargetPlayer.getDiscordTag(), aPlayer and aPlayer.getDiscordTag() or "console")
        end
    elseif aPlayer then
        TriggerClientEvent("ava_core:client:resetped", source)
        return GetString("resetped_log", aPlayer.getDiscordTag(), aPlayer.getDiscordTag())
    end
end, GetString("resetped_help"), { { name = "player", help = GetString("player_id_or_empty") } })

-----------------------------------------
--------------- Teleports ---------------
-----------------------------------------

AVA.Commands.RegisterCommand({ "tpcoords", "tp" }, "admin", function(source, args)
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
end, GetString("tp_help"), { { name = "x", help = "number[,]" }, { name = "y", help = "number[,]" }, { name = "z", help = "number[,] or empty" } })

AVA.Commands.RegisterCommand("goto", "mod", function(source, args)
    if type(args[1]) ~= "string" or tostring(args[1]) == tostring(source) then
        return
    end

    local targetPed = GetPlayerPed(args[1])
    if targetPed then
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
end, GetString("goto_help"), { { name = "player", help = GetString("player_id") } })

AVA.Commands.RegisterCommand({ "bring", "summon" }, "mod", function(source, args)
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
end, GetString("summon_help"), { { name = "player", help = GetString("player_id") } })

AVA.Commands.RegisterCommand({ "tpwaypoint", "tpw", "tpmarker", "tpm" }, "admin", function(source, args)
    if source > 0 then
        TriggerClientEvent("ava_core:client:teleportToWaypoint", source)
        return GetString("tpwaypoint_log")
    end
end, GetString("tpwaypoint_help"))

AVA.Commands.RegisterCommand("debugcoords", "mod", function(source, args)
    local src = source
    if type(args[1]) == "string" and args[1] ~= "0" then
        src = tonumber(args[1])
    end

    -- Source was target and no args were given
    if src == 0 then return end

    local targetPed = GetPlayerPed(src)
    if not targetPed then return end

    local targetCoords = GetEntityCoords(targetPed)
    if targetCoords ~= vector3(0.0, 0.0, 0.0) then
        TriggerClientEvent("ava_core:client:teleportToCoords", src, targetCoords.x, targetCoords.y, 0)
    end
end, GetString("debugcoords_help"), { { name = "player?", help = GetString("player_id_or_empty") } })

------------------------------------
--------------- SKIN ---------------
------------------------------------

AVA.Commands.RegisterCommand("getskin", "", function(source, args)
    if source > 0 then
        TriggerClientEvent("ava_core:client:getskin", source)
    end
end, GetString("getskin_help"))

AVA.Commands.RegisterCommand("getclothes", "", function(source, args)
    if source > 0 then
        TriggerClientEvent("ava_core:client:getclothes", source)
    end
end, GetString("getclothes_help"))

--------------------------------------
--------------- Others ---------------
--------------------------------------

AVA.Commands.RegisterCommand("save", "", function(_, _, _, aPlayer)
    if aPlayer then
        local time = os.time()
        -- player need to wait at least 10 seconds to be able to save manually again
        if not aPlayer.lastSaveTime or (time - aPlayer.lastSaveTime) > 10 then
            aPlayer.save()
        else
            TriggerClientEvent("ava_core:client:ShowNotification", aPlayer.src, "", nil, "ava_core_logo", GetString("cannot_save"),
                GetString("save_wait_x_seconds", 10 - (time - aPlayer.lastSaveTime)), nil, "ava_core_logo")
        end
    end
end)

AVA.Commands.RegisterCommand("myid", "", function(source, args)
    if source > 0 then
        TriggerClientEvent("chat:addMessage", source, { args = { GetString("myid_message", source) } })
    end
end, GetString("myid_help"))

AVA.Commands.RegisterCommand("phonenumber", "", function(source, args, rawCommand, aPlayer)
    if aPlayer then
        TriggerClientEvent("chat:addMessage", source, { args = { GetString("phonenumber_message", aPlayer.phoneNumber) } })
    end
end, GetString("myid_help"))

AVA.Commands.RegisterCommand({ "announce", "annonce" }, "", function(source, args, rawCommand, aPlayer)
    if type(args[1]) ~= "string" then
        return
    end
    local message <const> = table.concat(args, " ")
    AVA.Utils.SendWebhookEmbedMessage("avan0x_wh_staff", GetString("announce_embed_by_staff", aPlayer and aPlayer.getDiscordTag() or "console"), message,
        0xFF0076)
    TriggerClientEvent("ava_core:client:announce", -1, message)
end, GetString("announce_help"), { { name = "message", help = GetString("message") } })

AVA.Commands.RegisterCommand({ "message", "msg", "pm", "dm" }, "mod", function(source, args, rawCommand, aPlayer)
    if type(args[1]) ~= "string" or type(args[2]) ~= "string" -- or tostring(args[1]) == tostring(source)
    then
        return
    end
    local targetId = args[1]
    table.remove(args, 1)
    local message <const> = table.concat(args, " ")
    TriggerClientEvent("ava_core:client:ShowNotification", targetId, message, nil, "ava_core_logo", GetString("message_title"),
        aPlayer and aPlayer.getDiscordTag() or "console", nil, "ava_core_logo")
end, GetString("message_help"), { { name = "player", help = GetString("player_id") }, { name = "message", help = GetString("message") } })

AVA.Commands.RegisterCommand("report", "", function(source, args, rawCommand, aPlayer)
    if not aPlayer or type(args[1]) ~= "string" then
        return
    end
    local message <const> = table.concat(args, " ")
    local playerName <const> = aPlayer.getDiscordTag()

    AVA.Utils.SendWebhookEmbedMessage("avan0x_wh_staff", GetString("report_embed_by_player", playerName, source), message, 0xFFD767)
    -- Notify source
    TriggerClientEvent("chat:addMessage", source,
        { color = { 255, 60, 60 }, multiline = false, args = { GetString("report_chat_prefix"), GetString("report_chat_message") } })
    -- Notify staff
    AVA.Utils.TriggerClientWithAceEvent("ava_core:client:staff_report", "ace.group.mod", playerName, source, message)
end, GetString("report_help"), { { name = "message", help = GetString("message") } })

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
end, GetString("kill_help"), { { name = "player?", help = GetString("player_id_or_empty") } })

AVA.Commands.RegisterCommand("ace", "superadmin", function(source, args, rawCommand, aPlayer)
    if aPlayer and args[1] then
        dprint(args[1], IsPlayerAceAllowed(source, args[1]))
    end
end)
