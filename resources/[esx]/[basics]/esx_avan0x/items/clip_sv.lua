-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

RegisterServerEvent("esx_clip:remove")
AddEventHandler("esx_clip:remove", function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem("clip", 1)
end)

ESX.RegisterUsableItem("clip", function(source)
	TriggerClientEvent("esx_avan0x:clip", source)
end)

