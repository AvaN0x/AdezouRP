-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX = nil

TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

TriggerEvent("es:addGroupCommand", "heal", "admin", function(source, args, user)
	-- heal another player - don"t heal source
	if args[1] then
		local playerId = tonumber(args[1])

		-- is the argument a number?
		if playerId then
			-- is the number a valid player?
			if GetPlayerName(playerId) then
				print(("esx_ava_needs: %s healed %s"):format(GetPlayerIdentifier(source, 0), GetPlayerIdentifier(playerId, 0)))
				TriggerClientEvent("esx_ava_needs:healPlayer", playerId)
				TriggerClientEvent("chat:addMessage", source, { args = { "^5HEAL", "Vous avez été soigné." } })
			else
				TriggerClientEvent("chat:addMessage", source, { args = { "^1SYSTEM", "Joueur non connecté." } })
			end
		else
			TriggerClientEvent("chat:addMessage", source, { args = { "^1SYSTEM", "ID Incorrecte." } })
		end
	else
		print(("esx_ava_needs: %s healed self"):format(GetPlayerIdentifier(source, 0)))
		TriggerClientEvent("esx_ava_needs:healPlayer", source)
	end
end, function(source, args, user)
	TriggerClientEvent("chat:addMessage", source, { args = { "^1SYSTEM", "Insufficient Permissions." } })
end, {help = "Heal a player, or yourself - restores thirst, hunger and health - clear drunk.", params = {{name = "playerId", help = "(optional) player id"}}})


RegisterServerEvent("esx_ava_needs:useItem")
AddEventHandler("esx_ava_needs:useItem", function(source, itemName)
	local xPlayer = ESX.GetPlayerFromId(source)
	local item = xPlayer.getInventoryItem(itemName)

	xPlayer.removeInventoryItem(itemName, 1)
    TriggerClientEvent("esx:showNotification", source, _U("you_consumed", item.label))

end)
