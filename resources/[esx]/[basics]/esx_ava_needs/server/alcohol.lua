-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX.RegisterUsableItem("beer", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "beer")

	TriggerClientEvent("esx_status:add", source, "drunk", 250000)
	TriggerClientEvent("esx_status:add", source, "thirst", 100000)
	
	TriggerClientEvent("esx_ava_needs:onDrink", source, "prop_amb_beer_bottle")
end)

ESX.RegisterUsableItem("champagne", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "champagne")

	TriggerClientEvent("esx_status:add", source, "drunk", 400000)
	TriggerClientEvent("esx_status:add", source, "thirst", 160000)
	
	TriggerClientEvent("esx_ava_needs:onDrink", source)
end)

ESX.RegisterUsableItem("vodka", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "vodka")

	TriggerClientEvent("esx_status:add", source, "drunk", 160000)
	TriggerClientEvent("esx_status:add", source, "thirst", 100000)
	
	TriggerClientEvent("esx_ava_needs:onDrink", source, "prop_amb_40oz_03")
end)

ESX.RegisterUsableItem("whisky", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "whisky")

	TriggerClientEvent("esx_status:add", source, "drunk", 160000)
	TriggerClientEvent("esx_status:add", source, "thirst", 100000)
	
	TriggerClientEvent("esx_ava_needs:onDrink", source, "prop_amb_40oz_03")
end)

ESX.RegisterUsableItem("martini", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "martini")

	TriggerClientEvent("esx_status:add", source, "drunk", 160000)
	TriggerClientEvent("esx_status:add", source, "thirst", 100000)
	
	TriggerClientEvent("esx_ava_needs:onDrink", source, "prop_amb_40oz_03")
end)

ESX.RegisterUsableItem("martini2", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "martini2")

	TriggerClientEvent("esx_status:add", source, "drunk", 160000)
	TriggerClientEvent("esx_status:add", source, "thirst", 100000)
	
	TriggerClientEvent("esx_ava_needs:onDrink", source, "prop_amb_40oz_03")
end)

ESX.RegisterUsableItem("tequila", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "tequila")

	TriggerClientEvent("esx_status:add", source, "drunk", 160000)
	TriggerClientEvent("esx_status:add", source, "thirst", 100000)
	
	TriggerClientEvent("esx_ava_needs:onDrink", source, "prop_amb_40oz_03")
end)

ESX.RegisterUsableItem("rhum", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "rhum")

	TriggerClientEvent("esx_status:add", source, "drunk", 160000)
	TriggerClientEvent("esx_status:add", source, "thirst", 100000)
	
	TriggerClientEvent("esx_ava_needs:onDrink", source, "prop_amb_40oz_03")
end)

ESX.RegisterUsableItem("mojito", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "mojito")

	TriggerClientEvent("esx_status:add", source, "drunk", 180000)
	TriggerClientEvent("esx_status:add", source, "thirst", 100000)
	
	TriggerClientEvent("esx_ava_needs:onDrink", source, "prop_amb_40oz_03")
end)

ESX.RegisterUsableItem("grand_cru", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "grand_cru")

	TriggerClientEvent("esx_status:add", source, "drunk", 400000)
	
	TriggerClientEvent("esx_ava_needs:onDrink", source, "prop_amb_40oz_03")
end)

ESX.RegisterUsableItem("vine", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "vine")

	TriggerClientEvent("esx_status:add", source, "drunk", 400000)
	
	TriggerClientEvent("esx_ava_needs:onDrink", source, "prop_amb_40oz_03")
end)

