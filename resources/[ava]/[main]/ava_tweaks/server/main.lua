-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
exports.ava_core:RegisterCommand("vehweaphash", nil, function(source, args)
    TriggerClientEvent("ava_tweaks:client:vehweaphash", source)
end, GetString("vehweaphash_help"))
