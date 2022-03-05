-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local Items = AVAConfig.Items

---Get data from player inventory to be used in client interface
---@param src string "player source"
---@return table|nil "items from inventory"
---@return integer|nil "max weight of inventory"
---@return number|nil "actual weight of inventory"
---@return string|nil "inventory label name"
AVA.GetPlayerInventoryItems = function(src)
    local aPlayer = exports.ava_core:GetPlayer(src)
    if aPlayer then
        local inventory = aPlayer.getInventory()

        local items = {}
        local itemsCount = 0
        for i = 1, #inventory.items, 1 do
            local invItem = inventory.items[i]
            local cfgItem = Items[invItem.name]
            if cfgItem and (invItem.quantity > 0 or cfgItem.alwaysDisplayed) then
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

        return items, inventory.max_weight, inventory.actual_weight, inventory.label
    end
    return nil
end
exports("GetPlayerInventoryData", AVA.GetPlayerInventoryItems)

AVA.RegisterServerCallback("ava_core:server:getItemQuantity", function(source, itemName)
    local aPlayer = exports.ava_core:GetPlayer(source)
    if aPlayer then
        local item = aPlayer.getInventory().getItem(itemName)

        if item then
            return item.quantity
        end
    end
    return 0
end)

AVA.RegisterServerCallback("ava_core:server:getInventoryItems", function(source)
    local src = source
    return AVA.GetPlayerInventoryItems(src)
end)

AVA.RegisterServerCallback("ava_core:server:getTargetInventoryItems", function(source, target)
    return AVA.GetPlayerInventoryItems(target)
end)

AVA.Commands.RegisterCommand("openinventory", "admin", function(source, args)
    if type(args[1]) ~= "string" then
        return
    end
    if tostring(args[1]) == tostring(source) then
        TriggerClientEvent("chat:addMessage", source,
            { color = { 255, 0, 0 }, multiline = false, args = { "AvaCore", GetString("cannot_open_my_inventory_with_openinventory") } })
        return
    end

    TriggerClientEvent("ava_core:client:openTargetInventory", source, args[1])
end, GetString("openinventory_help"), { { name = "player", help = GetString("player_id") } })

RegisterNetEvent("ava_core:server:dropItem", function(coords, itemName, count)
    local src = source
    local aPlayer = AVA.Players.GetPlayer(src)

    if aPlayer then
        local inventory = aPlayer.getInventory()
        if count and count > 0 and inventory.canRemoveItem(itemName, count) then
            local playerPed = GetPlayerPed(src)
            if playerPed then
                local playerCoords = GetEntityCoords(playerPed)
                -- Player should not send coords that are too far away
                if type(coords) == "vector3" and #(coords - playerCoords) < 3.0 then
                    local playerHeading = GetEntityHeading(playerPed)
                    local propCoords = vector4(coords.x, coords.y, coords.z, playerHeading)
                    AVA.CreatePickup(propCoords, itemName, count)
                    inventory.removeItem(itemName, count)
                    TriggerEvent("ava_logs:server:log", { "citizenid:" .. aPlayer.citizenId, "create_pickup", "item:" .. itemName, count })
                end
            end
        else
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("inventory_drop_not_enough_items"))
        end
    end
end)

RegisterNetEvent("ava_core:server:giveItem", function(targetId, itemName, count)
    local src = source
    if src == targetId then
        return
    end
    local aPlayer = AVA.Players.GetPlayer(src)
    local aTarget = AVA.Players.GetPlayer(targetId)

    if aPlayer and aTarget then
        local playerInventory = aPlayer.inventory
        local targetInventory = aTarget.inventory
        if count and count > 0 and playerInventory.canRemoveItem(itemName, count) then
            if targetInventory.canAddItem(itemName, count) then
                playerInventory.removeItem(itemName, count)
                targetInventory.addItem(itemName, count)
                TriggerEvent("ava_logs:server:log", { "citizenid:" .. aPlayer.citizenId, "give_item_to", "citizenid:" .. aTarget.citizenId, "item:" .. itemName, count })
            else
                TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("target_not_enough_place"))
                TriggerClientEvent("ava_core:client:ShowNotification", targetId, GetString("not_enough_place"))
            end
        else
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("invalid_quantity"))
        end
    end
end)

RegisterNetEvent("ava_core:server:takeItem", function(targetId, itemName, count)
    local src = source
    if src == targetId then
        return
    end
    local aPlayer = AVA.Players.GetPlayer(src)
    local aTarget = AVA.Players.GetPlayer(targetId)

    if aPlayer and aTarget then
        local playerInventory = aPlayer.inventory
        local targetInventory = aTarget.inventory
        if count and count > 0 and targetInventory.canRemoveItem(itemName, count) then
            if playerInventory.canAddItem(itemName, count) then
                targetInventory.removeItem(itemName, count)
                playerInventory.addItem(itemName, count)
                TriggerEvent("ava_logs:server:log", { "citizenid:" .. aPlayer.citizenId, "take_item_from", "citizenid:" .. aTarget.citizenId, "item:" .. itemName, count })
            else
                TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("not_enough_place"))
            end
        else
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("invalid_quantity"))
        end
    end
end)
