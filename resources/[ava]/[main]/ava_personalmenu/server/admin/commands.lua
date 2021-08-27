-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
exports.ava_core:RegisterCommand("playerblips", "mod", function(source, args)
    TriggerClientEvent("ava_personalmenu:client:togglePlayerBlips", source, (type(args[1]) == "string" and args[1] == "true") and true or nil)
end, GetString("admin_menu_players_options_blips_subtitle"))

exports.ava_core:RegisterCommand("playertags", "mod", function(source, args)
    TriggerClientEvent("ava_personalmenu:client:togglePlayerTags", source, (type(args[1]) == "string" and args[1] == "true") and true or nil)
end, GetString("admin_menu_players_options_gamertags_subtitle"))
