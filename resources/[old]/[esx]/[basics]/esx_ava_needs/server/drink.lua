-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX.RegisterUsableItem("water", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "water")

	TriggerClientEvent("esx_status:add", source, "thirst", 200000)

	TriggerClientEvent("esx_ava_needs:onDrink", source)
end)

ESX.RegisterUsableItem("coffee", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "coffee")

	TriggerClientEvent("esx_status:add", source, "thirst", 100000)

	TriggerClientEvent("esx_ava_needs:onDrink", source)
end)

ESX.RegisterUsableItem("jus_raisin", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "jus_raisin")

	TriggerClientEvent("esx_status:add", source, "thirst", 600000)

	TriggerClientEvent("esx_ava_needs:onDrink", source)
end)

ESX.RegisterUsableItem("cocacola", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "cocacola")

	TriggerClientEvent("esx_status:add", source, "thirst", 300000)

	TriggerClientEvent("esx_ava_needs:onDrink", source)
end)


ESX.RegisterUsableItem("icetea", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "icetea")

	TriggerClientEvent("esx_status:add", source, "thirst", 400000)

	TriggerClientEvent("esx_ava_needs:onDrink", source)
end)

ESX.RegisterUsableItem("sprite", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "sprite")

	TriggerClientEvent("esx_status:add", source, "thirst", 300000)

	TriggerClientEvent("esx_ava_needs:onDrink", source)
end)

ESX.RegisterUsableItem("orangina", function(source)
	TriggerEvent("esx_ava_needs:useItem", source, "orangina")

	TriggerClientEvent("esx_status:add", source, "thirst", 300000)
	
	TriggerClientEvent("esx_ava_needs:onDrink", source)
end)
