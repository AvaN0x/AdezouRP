-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
exports.ava_core:RegisterCommand("spectate", "mod", function(source, args)
    if source > 0 then
        if type(args[1]) ~= "string" or args[1] == "0" or args[1] == tostring(source) then
            -- cancel spectate
            TriggerClientEvent("ava_personalmenu:client:cancelSpectate", source)
        else
            -- start spectate
            local targetPed = GetPlayerPed(args[1])
            if targetPed > 0 then
                if GetPlayerRoutingBucket(source) ~= GetPlayerRoutingBucket(args[1]) then
                    print("^1[ERROR] ^0Player ^3" .. args[1] .. "^0 is in another routing bucket")
                else
                    TriggerClientEvent("ava_personalmenu:client:spectate", source, args[1], GetEntityCoords(targetPed))
                end
            end
        end
    end
end, GetString("admin_menu_spectate_subtitle"), {{name = "player", help = GetString("player_id_or_empty")}})

