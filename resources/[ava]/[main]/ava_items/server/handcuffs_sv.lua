-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
-- TODO: redo, atm it's inspired by esx_policejob
-- TODO: use statebags and things to make it better

exports.ava_core:RegisterUsableItem("handcuffs", function(source)
    TriggerClientEvent('ava_items:handcuffs:useHandcuff', source)
end)


RegisterServerEvent('ava_items:handcuffs:handcuffs', function(target)
    local aPlayer = exports.ava_core:GetPlayer(source)
    if aPlayer then
        local inventory = aPlayer.getInventory()
        if inventory.canRemoveItem("handcuffs", 1) then
            TriggerClientEvent('ava_items:handcuffs:handcuffs', target)
        end
    end
end)

RegisterServerEvent('ava_items:handcuffs:unhandcuff', function(target)
    local aPlayer = exports.ava_core:GetPlayer(source)
    if aPlayer then
        local inventory = aPlayer.getInventory()
        if inventory.canRemoveItem("handcuffs", 1) then
            TriggerClientEvent('ava_items:handcuffs:unrestrain', target)
        end
    end
end)

RegisterServerEvent('ava_items:handcuffs:drag', function(target)
    local aPlayer = exports.ava_core:GetPlayer(source)
    if aPlayer then
        local inventory = aPlayer.getInventory()
        if inventory.canRemoveItem("handcuffs", 1) then
            TriggerClientEvent('ava_items:handcuffs:drag', target, source)
        end
    end
end)

RegisterServerEvent('ava_items:handcuffs:putInVehicle', function(target)
    local aPlayer = exports.ava_core:GetPlayer(source)
    if aPlayer then
        local inventory = aPlayer.getInventory()
        if inventory.canRemoveItem("handcuffs", 1) then
            TriggerClientEvent('ava_items:handcuffs:putInVehicle', target)
        end
    end
end)

RegisterServerEvent('ava_items:handcuffs:OutVehicle', function(target)
    local aPlayer = exports.ava_core:GetPlayer(source)
    if aPlayer then
        local inventory = aPlayer.getInventory()
        if inventory.canRemoveItem("handcuffs", 1) then
            TriggerClientEvent('ava_items:handcuffs:OutVehicle', target)
        end
    end
end)

RegisterServerEvent('ava_items:handcuffs:requestarrest', function(targetid, playerheading, playerCoords, playerlocation)
    _source = source
    TriggerClientEvent('ava_items:handcuffs:getarrested', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('ava_items:handcuffs:doarrested', _source)
end)

RegisterServerEvent('ava_items:handcuffs:requestrelease', function(targetid, playerheading, playerCoords, playerlocation)
    _source = source
    TriggerClientEvent('ava_items:handcuffs:getuncuffed', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('ava_items:handcuffs:douncuffing', _source)
end)
