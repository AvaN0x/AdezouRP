-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
exports.ava_core:RegisterCommand("playerblips", "mod", function(source, args)
    TriggerClientEvent("ava_personalmenu:client:togglePlayerBlips", source)
end, GetString("admin_menu_players_options_blips_subtitle"))

exports.ava_core:RegisterCommand("playertags", "mod", function(source, args)
    TriggerClientEvent("ava_personalmenu:client:togglePlayerTags", source)
end, GetString("admin_menu_players_options_gamertags_subtitle"))

exports.ava_core:RegisterCommand("noclip", "admin", function(source, args)
    TriggerClientEvent("ava_personalmenu:client:toggleNoclip", source)
end, GetString("admin_menu_noclip_subtitle"))

exports.ava_core:RegisterCommand("showhash", "admin", function(source, args)
    TriggerClientEvent("ava_personalmenu:client:toggleShowHash", source)
end, GetString("dev_menu_showhash_subtitle"))

exports.ava_core:RegisterCommand("showcoords", "admin", function(source, args)
    TriggerClientEvent("ava_personalmenu:client:toggleShowCoords", source)
end, GetString("dev_menu_showcoords_subtitle"))

exports.ava_core:RegisterCommand("showcoordshelper", "admin", function(source, args)
    TriggerClientEvent("ava_personalmenu:client:toggleShowCoordsHelper", source)
end, GetString("dev_menu_showcoordshelper_subtitle"))
