-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
RegisterNetEvent("ava_tweaks:server:sirencontrol:sync", function(netID, state)
    TriggerClientEvent("ava_tweaks:client:sirencontrol:sync", -1, netID, state)
end)
