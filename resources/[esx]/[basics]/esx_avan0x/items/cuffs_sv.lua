-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX.RegisterUsableItem('handcuffs', function(source)
	TriggerClientEvent('esx_avan0x:useHandcuffs', source)
end)


RegisterServerEvent('esx_avan0x:handcuffs:handcuff')
AddEventHandler('esx_avan0x:handcuffs:handcuff', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.getInventory()
    
    print(target)
    if inventory.canRemoveItem("handcuffs", 1) then
        TriggerClientEvent('esx_avan0x:handcuffs:handcuff', target)
    end
end)

RegisterServerEvent('esx_avan0x:handcuffs:unhandcuff')
AddEventHandler('esx_avan0x:handcuffs:unhandcuff', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.getInventory()
    
    if inventory.canRemoveItem("handcuffs", 1) then
        TriggerClientEvent('esx_avan0x:handcuffs:handcuff', target)
    end
end)

RegisterServerEvent('esx_avan0x:handcuffs:drag')
AddEventHandler('esx_avan0x:handcuffs:drag', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.getInventory()
    
    if inventory.canRemoveItem("handcuffs", 1) then
        TriggerClientEvent('esx_avan0x:handcuffs:drag', target, source)
    end
end)

RegisterServerEvent('esx_avan0x:handcuffs:putInVehicle')
AddEventHandler('esx_avan0x:handcuffs:putInVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.getInventory()
    
    if inventory.canRemoveItem("handcuffs", 1) then
        TriggerClientEvent('esx_avan0x:handcuffs:putInVehicle', target)
    end
end)

RegisterServerEvent('esx_avan0x:handcuffs:OutVehicle')
AddEventHandler('esx_avan0x:handcuffs:OutVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.getInventory()
    
    if inventory.canRemoveItem("handcuffs", 1) then
        TriggerClientEvent('esx_avan0x:handcuffs:OutVehicle', target)
    end
end)

RegisterServerEvent('esx_avan0x:handcuffs:requestarrest')
AddEventHandler('esx_avan0x:handcuffs:requestarrest', function(targetid, playerheading, playerCoords,  playerlocation)
	_source = source
	TriggerClientEvent('esx_avan0x:handcuffs:getarrested', targetid, playerheading, playerCoords, playerlocation)
	TriggerClientEvent('esx_avan0x:handcuffs:doarrested', _source)
end)

RegisterServerEvent('esx_avan0x:handcuffs:requestrelease')
AddEventHandler('esx_avan0x:handcuffs:requestrelease', function(targetid, playerheading, playerCoords,  playerlocation)
	_source = source
	TriggerClientEvent('esx_avan0x:handcuffs:getuncuffed', targetid, playerheading, playerCoords, playerlocation)
	TriggerClientEvent('esx_avan0x:handcuffs:douncuffing', _source)
end)
