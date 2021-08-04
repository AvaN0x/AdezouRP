-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

AVA.Commands = {}
AVA.Commands.SuggestionList = {}

AVA.Commands.RegisterCommand = function(name, group, callback, help, params)
    local name = name:lower()
    local group = group:lower()

    local needAce = group and group ~= ""
    RegisterCommand(name, callback, needAce)
    
    if needAce then
        ExecuteCommand("add_ace group." .. group  .. " command." .. name .. " allow")
    end
    if help or params then
        table.insert(AVA.Commands.SuggestionList, {name = name, help = help or "", params = params})
    end
    
    dprint("Command added: ^3" .. name .. (needAce and "^7, requires principal ^3group." .. group or "") .. "^7")
end

AVA.Commands.RegisterCommand("car", "mod", function(source, args)
    TriggerClientEvent('chat:addMessage', source, {
        args = { "don't spawn " .. (args[1] or 'adder') }
    })
end, "spawn_car", {{name = "car", help = "car_name"}})


AVA.Commands.RegisterCommand("report", "", function(source, args)
    TriggerClientEvent('chat:addMessage', source, {
        args = { "hey this should report, maybe, maybe not" }
    })
end, "spawn_car", {{name = "reason", help = "your_reason"}})