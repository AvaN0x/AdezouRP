-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX.RegisterUsableItem("bagcoke", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "bagcoke")

	TriggerClientEvent("esx_status:add", source, "drugged", 600000)

	TriggerClientEvent("esx_ava_needs:onSmokeDrug", source)
end)

ESX.RegisterUsableItem("bagexta", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "bagexta")

	TriggerClientEvent("esx_status:add", source, "drugged", 400000)

	TriggerClientEvent("esx_ava_needs:onSmokeDrug", source)
end)

ESX.RegisterUsableItem("bagweed", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "bagweed")

	TriggerClientEvent("esx_status:add", source, "drugged", 250000)

	TriggerClientEvent("esx_ava_needs:onSmokeDrug", source)
end)

ESX.RegisterUsableItem("methamphetamine", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "methamphetamine")

	TriggerClientEvent("esx_status:add", source, "drugged", 800000)

	TriggerClientEvent("esx_ava_needs:onSmokeDrug", source)
end)
