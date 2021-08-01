-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVA = {}

-- if using "snail" instead of "builtin.everyone", then console can do commands and players can't
-- ExecuteCommand('add_principal group.mod builtin.snail')

ExecuteCommand('add_principal group.admin group.mod')
    ExecuteCommand('add_ace group.admin command.stop allow')
    ExecuteCommand('add_ace group.admin command.start allow')
    ExecuteCommand('add_ace group.admin command.restart allow')
    ExecuteCommand('add_ace group.admin command.ensure allow')

ExecuteCommand('add_principal group.superadmin group.admin')
    ExecuteCommand('add_ace group.superadmin command allow')

