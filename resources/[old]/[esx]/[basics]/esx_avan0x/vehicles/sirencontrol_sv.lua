-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

RegisterServerEvent("esx_ava_siren:sync")
AddEventHandler("esx_ava_siren:sync", function(netID, state)
    TriggerClientEvent("esx_ava_siren:sync", -1, state, netID)
end)