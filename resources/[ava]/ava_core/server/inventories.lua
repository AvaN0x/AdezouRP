-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local Items = AVAConfig.Items

AVA.RegisterServerCallback("ava_core:server:getInventoryItems", function(source)
    local src = source
    local aPlayer = exports.ava_core:GetPlayer(src)
    if aPlayer then
        local inventory = aPlayer.getInventory()

        local items = {}
        local itemsCount = 0
        for i = 1, #inventory.items, 1 do
            local invItem = inventory.items[i]
            local cfgItem = Items[invItem.name]
            if invItem.quantity > 0 or cfgItem.alwaysDisplayed then
                if cfgItem then
                    itemsCount = itemsCount + 1
                    items[itemsCount] = {
                        name = invItem.name,
                        quantity = invItem.quantity,
                        label = cfgItem.label,
                        desc = cfgItem.description,
                        type = cfgItem.type,
                        weight = cfgItem.weight,
                        limit = cfgItem.limit,
                        noIcon = cfgItem.noIcon,
                        closeInv = cfgItem.closeInv,
                        usable = cfgItem.usable,
                    }
                end
            end
        end

        return items, inventory.max_weight, inventory.actual_weight, inventory.label
    end
end)

RegisterNetEvent("ava_core:server:giveItem", function(targetId, itemName, count)
    local src = source
    local aPlayer = AVA.Players.GetPlayer(src)
    local aTarget = AVA.Players.GetPlayer(targetId)

    if src ~= targetId and aPlayer and aTarget then
        local playerInventory = aPlayer.inventory
        local targetInventory = aTarget.inventory
        if count and count > 0 and playerInventory.canRemoveItem(itemName, count) then
            if targetInventory.canAddItem(itemName, count) then
                playerInventory.removeItem(itemName, count)
                targetInventory.addItem(itemName, count)
            else
                TriggerClientEvent("ava_core:client:ShowNotification", src, ("target_not_enough_place"))
                TriggerClientEvent("ava_core:client:ShowNotification", targetId, ("not_enough_place"))
            end
        else
            TriggerClientEvent("ava_core:client:ShowNotification", src, ("invalid_quantity"))
        end
    end
end)

RegisterNetEvent("ava_core:server:addtest", function()
    local src = source
    local aPlayer = exports.ava_core:GetPlayer(src)
    if aPlayer then
        local inventory = aPlayer.inventory
        for k, v in pairs(AVAConfig.Items) do
            inventory.addItem(k, 1)
        end
    end
end)
