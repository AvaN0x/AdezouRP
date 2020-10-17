ESX = nil
poidsInventaire = 2000

TriggerEvent(
	"esx:getSharedObject",
	function(obj)
		ESX = obj
	end
)

ESX.RegisterServerCallback(
	"esx_inventoryhud:getPlayerInventory",
	function(source, cb, target)
		local targetXPlayer = ESX.GetPlayerFromId(target)

		if targetXPlayer ~= nil then
			cb({inventory = targetXPlayer.inventory, money = targetXPlayer.getMoney(), accounts = targetXPlayer.accounts, weapons = targetXPlayer.loadout})
		else
			cb(nil)
		end
	end
)

ESX.RegisterServerCallback("esx_inventoryhud:getPlayerWeight", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(ESX.GetWeight(xPlayer.inventory,xPlayer.loadout))
end)

RegisterServerEvent("esx_inventoryhud:canPlayerHave")
AddEventHandler("esx_inventoryhud:canPlayerHave", function(source,cb, itemName, quantity)
	local xPlayer = ESX.GetPlayerFromId(source)
	--cb(ESX.GetWeight(xPlayer.inventory,xPlayer.loadout)+ESX.GetItemWeight(itemName)*quantity < poidsInventaire)
	cb(true)
end)

ESX.RegisterServerCallback("esx_inventoryhud:canPlayerGiveTo", function(source, cb, target, itemName, quantity)
	local xPlayer = ESX.GetPlayerFromId(target)
	cb(ESX.GetWeight(xPlayer.inventory,xPlayer.loadout)+ESX.GetItemWeight(itemName)*quantity < poidsInventaire)
end)

RegisterServerEvent("esx_inventoryhud:tradePlayerItem")
AddEventHandler(
	"esx_inventoryhud:tradePlayerItem",
	function(from, target, type, itemName, itemCount)
		local _source = from

		local sourceXPlayer = ESX.GetPlayerFromId(_source)
		local targetXPlayer = ESX.GetPlayerFromId(target)

		TriggerEvent('esx_inventoryhud:canPlayerHave', target,function(can)
			if can then
				if type == "item_standard" then
					local sourceItem = sourceXPlayer.getInventoryItem(itemName)
					local targetItem = targetXPlayer.getInventoryItem(itemName)

					if itemCount > 0 and sourceItem.count >= itemCount then
						if targetItem.limit ~= -1 and (targetItem.count + itemCount) > targetItem.limit then
						else
							sourceXPlayer.removeInventoryItem(itemName, itemCount)
							targetXPlayer.addInventoryItem(itemName, itemCount)
						end
					end
				elseif type == "item_money" then
					if itemCount > 0 and sourceXPlayer.getMoney() >= itemCount then
						sourceXPlayer.removeMoney(itemCount)
						targetXPlayer.addMoney(itemCount)
					end
				elseif type == "item_account" then
					if itemCount > 0 and sourceXPlayer.getAccount(itemName).money >= itemCount then
						sourceXPlayer.removeAccountMoney(itemName, itemCount)
						targetXPlayer.addAccountMoney(itemName, itemCount)
					end
				elseif type == "item_weapon" then
					if not targetXPlayer.hasWeapon(itemName) then
						sourceXPlayer.removeWeapon(itemName)
						targetXPlayer.addWeapon(itemName, itemCount)
					end
				end
			else
				TriggerClientEvent('esx:shownotification',_source,'L\'individu n\'a pas assez de place')
 			end
		end, itemName, itemCount)		
	end
)

RegisterCommand(
	"openinventory",
	function(source, args, rawCommand)
		if IsPlayerAceAllowed(source, "inventory.openinventory") then
			local target = tonumber(args[1])
			local targetXPlayer = ESX.GetPlayerFromId(target)

			if targetXPlayer ~= nil then
				TriggerClientEvent("esx_inventoryhud:openPlayerInventory", source, target, targetXPlayer.name)
			else
				TriggerClientEvent("chatMessage", source, "^1" .. _U("no_player"))
			end
		else
			TriggerClientEvent("chatMessage", source, "^1" .. _U("no_permissions"))
		end
	end
)
