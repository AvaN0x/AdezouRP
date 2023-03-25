ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx_ava_crate_lost:getitem')
AddEventHandler('esx_ava_crate_lost:getitem', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.getInventory()
    local itemName = "weaponbox"

	if not inventory.canAddItem(itemName, 1) then
		TriggerClientEvent('esx:showNotification', source, "Pas de place chacal")
	else
		inventory.addItem(itemName, 1)
	end
end)
