-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

exports.ava_core:RegisterCommand("lscustoms", "admin", function(source, args)
    TriggerClientEvent("ava_stores:client:OpenLSCustoms", source)
end, GetString("lscustoms_help"))


exports.ava_core:RegisterServerCallback("ava_stores:server:payLSCustoms", function(source, modName)
    local src = source
    local aPlayer = exports.ava_core:GetPlayer(src)
    if not aPlayer then return false end

    -- TODO
    return true
end)
