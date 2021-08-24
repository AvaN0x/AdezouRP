-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVA = {}

exports("GetSharedObject", function()
    return AVA
end)

-------------------------------------------
--------------- Init Config ---------------
-------------------------------------------

local resourceName = GetCurrentResourceName()
for i = 1, GetNumResourceMetadata(resourceName, "my_data"), 1 do
    local dataName = GetResourceMetadata(resourceName, "my_data", i - 1)
    if dataName == "discord_config" then
        AVAConfig.Discord = json.decode(GetResourceMetadata(resourceName, "my_data_extra", i - 1))

    elseif dataName == "debug_prints" then
        AVAConfig.Debug = true

    elseif dataName == "max_characters" then
        local value = json.decode(GetResourceMetadata(resourceName, "my_data_extra", i - 1)) or 0
        if value ~= "null" and tonumber(value) > 0 then
            AVAConfig.MaxChars = tonumber(value)
        else
            print("^3[WARN] max_characters was not valid, value must be a number > 0^0")
        end
    end
end

---Print only if AVAConfig.Debug is true
function dprint(...)
    if AVAConfig.Debug then
        print("^3[DEBUG] ^0", ...)
    end
end

dprint([[
Console colors : 
    ^0^ 0 : AvaN0x's Core
    ^1^ 1 : AvaN0x's Core
    ^2^ 2 : AvaN0x's Core
    ^3^ 3 : AvaN0x's Core
    ^4^ 4 : AvaN0x's Core
    ^5^ 5 : AvaN0x's Core
    ^6^ 6 : AvaN0x's Core
    ^7^ 7 : AvaN0x's Core
    ^8^ 8 : AvaN0x's Core
    ^9^ 9 : AvaN0x's Core^0]])

-----------------------------------------------
--------------- Init principals ---------------
-----------------------------------------------

-- if using "snail" instead of "builtin.everyone", then console can do commands and players can't
-- ExecuteCommand('add_principal group.mod builtin.snail')

ExecuteCommand("add_principal group.admin group.mod")
ExecuteCommand("add_ace group.admin command.stop allow")
ExecuteCommand("add_ace group.admin command.start allow")
ExecuteCommand("add_ace group.admin command.restart allow")
ExecuteCommand("add_ace group.admin command.ensure allow")

ExecuteCommand("add_principal group.superadmin group.admin")
ExecuteCommand("add_ace group.superadmin command allow")

-------------------------------------
--------------- Items ---------------
-------------------------------------
AVA.UsableItems = {}

---Register an usable item
---@param itemName any
---@param callback fun(itemName: string, callback: function)
AVA.RegisterUsableItem = function(itemName, callback)
    if type(itemName) == "string" and AVAConfig.Items[itemName]
        and (type(callback) == "function" or (type(callback) == "table" and callback["__cfx_functionReference"] ~= nil)) then
        AVA.UsableItems[itemName] = callback
        AVAConfig.Items[itemName].usable = true
    end
end

AVA.RegisterUsableItem("bread", function(src)
    print(src .. " tried to eat bread, unfortunately this feature is not done.")
    local aPlayer = AVA.Players.GetPlayer(src)
    if aPlayer then
        aPlayer.inventory.removeItem("bread", 1)
    end
end)
