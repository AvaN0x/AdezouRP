-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVA = {}



-------------------------------------------
--------------- Init Config ---------------
-------------------------------------------

local resourceName = GetCurrentResourceName()
for i = 1, GetNumResourceMetadata(resourceName, "my_data"), 1 do
    if GetResourceMetadata(resourceName, "my_data", i - 1) == "discord_config" then
        AVAConfig.Discord = json.decode(GetResourceMetadata(resourceName, "my_data_extra", i - 1))

    elseif GetResourceMetadata(resourceName, "my_data", i - 1) == "debug_prints" then
        AVAConfig.Debug = true
    end
end




-------------------------------------------
--------------- Init Config ---------------
-------------------------------------------

function dprint(...)
    if AVAConfig.Debug then
        print("^3[DEBUG] ^7", ...)
    end
end

dprint("Console colors : \n\t^1^ 1 : AvaN0x's Core^7\n\t^2^ 2 : AvaN0x's Core^7\n\t^3^ 3 : AvaN0x's Core^7\n\t^4^ 4 : AvaN0x's Core^7\n\t^5^ 5 : AvaN0x's Core^7\n\t^6^ 6 : AvaN0x's Core^7\n\t^7^ 7 : AvaN0x's Core^7\n\t^8^ 8 : AvaN0x's Core^7\n\t^9^ 9 : AvaN0x's Core^7")

-----------------------------------------------
--------------- Init principals ---------------
-----------------------------------------------

-- if using "snail" instead of "builtin.everyone", then console can do commands and players can't
-- ExecuteCommand('add_principal group.mod builtin.snail')

ExecuteCommand('add_principal group.admin group.mod')
    ExecuteCommand('add_ace group.admin command.stop allow')
    ExecuteCommand('add_ace group.admin command.start allow')
    ExecuteCommand('add_ace group.admin command.restart allow')
    ExecuteCommand('add_ace group.admin command.ensure allow')

ExecuteCommand('add_principal group.superadmin group.admin')
    ExecuteCommand('add_ace group.superadmin command allow')

