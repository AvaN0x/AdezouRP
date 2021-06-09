-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

-------------
-- bandage --
-------------

ESX.RegisterUsableItem('bandage', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.getInventory()

    if inventory.canRemoveItem("bandage", 1) then
        inventory.removeItem("bandage", 1)
        TriggerClientEvent('esx_ava_deaths:bandage:heal', source)
	else
		print(('esx_ava_deaths: %s attempted to heal !'):format(xPlayer.identifier))
        exports.esx_avan0x:SendWebhookEmbedMessage("avan0x_wh_dev", "", ('esx_ava_deaths: %s attempted to heal !'):format(xPlayer.identifier), 5233787)
	end
end)



-------------
-- medikit --
-------------

ESX.RegisterUsableItem('medikit', function(source)
    -- local xPlayer = ESX.GetPlayerFromId(source)

	TriggerClientEvent('esx_ava_deaths:medikit', source)
end)

RegisterServerEvent('esx_ava_deaths:medikit:heal')
AddEventHandler('esx_ava_deaths:medikit:heal', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.getInventory()

    print(source, target)
    if inventory.canRemoveItem("medikit", 1) then
        inventory.removeItem("medikit", 1)
        TriggerClientEvent('esx_ava_deaths:medikit:heal', target)
	else
        local xTarget = ESX.GetPlayerFromId(target)
		print(('esx_ava_deaths: %s attempted to heal %s !'):format(xPlayer.identifier, xTarget.identifier))
        exports.esx_avan0x:SendWebhookEmbedMessage("avan0x_wh_dev", "", ('esx_ava_deaths: %s attempted to heal %s !'):format(xPlayer.identifier, xTarget.identifier), 5233787)
	end
end)


-------------------
-- defibrillator --
-------------------

ESX.RegisterUsableItem('defibrillator', function(source)
    -- local xPlayer = ESX.GetPlayerFromId(source)

	TriggerClientEvent('esx_ava_deaths:defibrillator', source)
end)

RegisterServerEvent('esx_ava_deaths:defibrillator:revive')
AddEventHandler('esx_ava_deaths:defibrillator:revive', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)
    local inventory = xPlayer.getInventory()

    if inventory.canRemoveItem("defibrillator", 1) and getDeathStatus(xTarget.identifier) then
        inventory.removeItem("defibrillator", 1)
        TriggerClientEvent('esx_ava_deaths:revive', target)
	else
		print(('esx_ava_deaths: %s attempted to revive %s !'):format(xPlayer.identifier, xTarget.identifier))
        exports.esx_avan0x:SendWebhookEmbedMessage("avan0x_wh_dev", "", ('esx_ava_deaths: %s attempted to revive %s !'):format(xPlayer.identifier, xTarget.identifier), 5233787)
	end
end)