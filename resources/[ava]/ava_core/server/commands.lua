-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVA.Commands = {}
AVA.Commands.SuggestionList = {}

---Register a command using ace permissions to a group
---@param name string|table
---@param group string|nil
---@param callback any
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
    RegisterCommand(name, callback, needAce)

    if needAce then
        ExecuteCommand("add_ace group." .. group .. " command." .. name .. " allow")
    end
    if help or params then
        table.insert(AVA.Commands.SuggestionList, {name = name, help = help or "", params = params})
    end

    dprint("Command added: ^3" .. name .. (needAce and "^7, requires principal ^3group." .. group or "") .. "^7")
end
exports("RegisterCommand", AVA.Commands.RegisterCommand)

AVA.Commands.RegisterCommand({"vehicle", "car", "plane", "boat", "bike", "heli"}, "admin", function(source, args)
    if type(args[1]) == "string" then
        TriggerClientEvent("ava:client:spawnVehicle", source, args[1])
    end
end, "spawn_car", {{name = "car", help = "car_name"}})

AVA.Commands.RegisterCommand({"deletevehicle", "dv", "removevehicle", "rv"}, "admin", function(source, args)
    TriggerClientEvent("ava:client:deleteVehicle", source)
end, "delete_car")

AVA.Commands.RegisterCommand("report", "", function(source, args)
    TriggerClientEvent("chat:addMessage", source, {args = {"hey this should report, maybe, maybe not"}})
end, "report", {{name = "reason", help = "your_reason"}})
