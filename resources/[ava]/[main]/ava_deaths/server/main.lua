-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
exports.ava_core:RegisterCommand("revive", "mod", function(source, args)
    local id = (type(args[1]) == "string" and args[1] ~= "0") and tonumber(args[1]) or source

    TriggerClientEvent("ava_deaths:client:staff_revive", id)
end, GetString("revive_help"), {{name = "player?", help = GetString("player_id_or_empty")}})
