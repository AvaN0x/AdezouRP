-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX.RegisterUsableItem("bread", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "bread")
	
	TriggerClientEvent("esx_status:add", source, "hunger", 200000)

	TriggerClientEvent("esx_ava_needs:onEat", source)
end)

ESX.RegisterUsableItem("hamburger", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "hamburger")

	TriggerClientEvent("esx_status:add", source, "hunger", 600000)

	TriggerClientEvent("esx_ava_needs:onEat", source)
end)

ESX.RegisterUsableItem("pizza", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "pizza")

	TriggerClientEvent("esx_status:add", source, "hunger", 600000)

	TriggerClientEvent("esx_ava_needs:onEat", source)
end)

ESX.RegisterUsableItem("donut", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "donut")

	TriggerClientEvent("esx_status:add", source, "hunger", 200000)

	TriggerClientEvent("esx_ava_needs:onEat", source, "prop_amb_donut")
end)

ESX.RegisterUsableItem("raisin", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "raisin")

    TriggerClientEvent("esx_status:add", source, "hunger", 200000)

	TriggerClientEvent("esx_ava_needs:onEat", source)
end)

ESX.RegisterUsableItem("nuggets", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "nuggets")

	TriggerClientEvent("esx_status:add", source, "hunger", 300000)

	TriggerClientEvent("esx_ava_needs:onEat", source)
end)

ESX.RegisterUsableItem("chickenburger", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "chickenburger")

	TriggerClientEvent("esx_status:add", source, "hunger", 600000)

	TriggerClientEvent("esx_ava_needs:onEat", source)
end)

ESX.RegisterUsableItem("frites", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "frites")

	TriggerClientEvent("esx_status:add", source, "hunger", 200000)

	TriggerClientEvent("esx_ava_needs:onEat", source)
end)

ESX.RegisterUsableItem("potatoes", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "potatoes")

	TriggerClientEvent("esx_status:add", source, "hunger", 300000)

	TriggerClientEvent("esx_ava_needs:onEat", source)
end)

ESX.RegisterUsableItem("doublechickenburger", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "doublechickenburger")

	TriggerClientEvent("esx_status:add", source, "hunger", 800000)

	TriggerClientEvent("esx_ava_needs:onEat", source)
end)

ESX.RegisterUsableItem("tenders", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "tenders")

	TriggerClientEvent("esx_status:add", source, "hunger", 400000)

	TriggerClientEvent("esx_ava_needs:onEat", source)
end)

ESX.RegisterUsableItem("chickenwrap", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "chickenwrap")

	TriggerClientEvent("esx_status:add", source, "hunger", 500000)

	TriggerClientEvent("esx_ava_needs:onEat", source)
end)

