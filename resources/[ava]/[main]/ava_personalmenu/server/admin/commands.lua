-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
exports.ava_core:RegisterCommand("playerblips", "mod", function(source, args)
    if source > 0 then
        TriggerClientEvent("ava_personalmenu:client:togglePlayerBlips", source)
    end
end, GetString("admin_menu_players_options_blips_subtitle"))

exports.ava_core:RegisterCommand("playertags", "mod", function(source, args)
    if source > 0 then
        TriggerClientEvent("ava_personalmenu:client:togglePlayerTags", source)
    end
end, GetString("admin_menu_players_options_gamertags_subtitle"))

exports.ava_core:RegisterCommand("noclip", "admin", function(source, args)
    if source > 0 then
        TriggerClientEvent("ava_personalmenu:client:toggleNoclip", source)
    end
end, GetString("admin_menu_noclip_subtitle"))

exports.ava_core:RegisterCommand("cleararea", "admin", function(source, args)
    if source > 0 then
        TriggerClientEvent("ava_personalmenu:client:clearArea", source)
    end
end, GetString("admin_menu_cleararea_subtitle"))

exports.ava_core:RegisterCommand("showhash", "admin", function(source, args)
    if source > 0 then
        TriggerClientEvent("ava_personalmenu:client:toggleShowHash", source)
    end
end, GetString("dev_menu_showhash_subtitle"))

exports.ava_core:RegisterCommand("showcoords", "admin", function(source, args)
    if source > 0 then
        TriggerClientEvent("ava_personalmenu:client:toggleShowCoords", source)
    end
end, GetString("dev_menu_showcoords_subtitle"))

exports.ava_core:RegisterCommand("showcoordshelper", "admin", function(source, args)
    if source > 0 then
        TriggerClientEvent("ava_personalmenu:client:toggleShowCoordsHelper", source)
    end
end, GetString("dev_menu_showcoordshelper_subtitle"))

