-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local Items = AVAConfig.Items
local NamedInventories = {
    -- Name
    ["1"] = {},
    -- Player vehicle
    ["2"] = {},
    -- Vehicle entity
    ["3"] = {}
}

---Get data from inventory to be used in client interface
---@param inventory inventory "inventory"
---@return table|nil "items from inventory"
---@return integer|nil "max weight of inventory"
---@return number|nil "actual weight of inventory"
---@return string|nil "inventory label name"
local function GetUsableDataFromInventory(inventory)
    if not inventory then return nil end

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

---Get data from player inventory to be used in client interface
---@param src string "player source"
---@return table|nil "items from inventory"
---@return integer|nil "max weight of inventory"
---@return number|nil "actual weight of inventory"
---@return string|nil "inventory label name"
AVA.GetPlayerInventoryItems = function(src)
    local aPlayer = exports.ava_core:GetPlayer(src)
    if aPlayer then
        return GetUsableDataFromInventory(aPlayer.getInventory())
    end
    return nil
end
exports("GetPlayerInventoryData", AVA.GetPlayerInventoryItems)

--#region player inventory
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


RegisterNetEvent("ava_core:server:dropItem", function(coords, itemName, count)
    -- Event is canceled in case of failure
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
                    TriggerEvent("ava_logs:server:log", { "citizenid:" .. aPlayer.citizenId, "create_pickup", "item:" .. itemName, "count:" .. count })
                    return -- Return so the event is not canceled
                end
            end
        else
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("inventory_drop_not_enough_items"))
        end
    end
    CancelEvent()
end)

RegisterNetEvent("ava_core:server:giveItem", function(targetId, itemName, count)
    -- Event is canceled in case of failure
    local src = source
    if src == targetId then
        CancelEvent()
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
                TriggerEvent("ava_logs:server:log", { "citizenid:" .. aPlayer.citizenId, "give_item_to", "citizenid:" .. aTarget.citizenId, "item:" .. itemName, "count:" .. count })
                return -- Return so the event is not canceled
            else
                TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("target_not_enough_place"))
                TriggerClientEvent("ava_core:client:ShowNotification", targetId, GetString("not_enough_place"))
            end
        else
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("invalid_quantity"))
        end
    end
    CancelEvent()
end)

RegisterNetEvent("ava_core:server:takePlayerItem", function(targetId, itemName, count)
    -- Event is canceled in case of failure
    local src = source
    if src == targetId then
        CancelEvent()
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
                TriggerEvent("ava_logs:server:log", { "citizenid:" .. aPlayer.citizenId, "take_item_from", "citizenid:" .. aTarget.citizenId, "item:" .. itemName, "count:" .. count })
                return -- Return so the event is not canceled
            else
                TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("not_enough_place"))
            end
        else
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("invalid_quantity"))
        end
    end
    CancelEvent()
end)
--#endregion player inventory

---Get data from named inventory to be used in client interface
---@param invType integer "inventory type"
---@param invName string "inventory name"
---@param trunkSize? number "trunk size, only used in case of creation of trunk inventory"
---@return table|nil "items from inventory"
---@return integer|nil "max weight of inventory"
---@return number|nil "actual weight of inventory"
---@return string|nil "inventory label name"
AVA.GetNamedInventoryItems = function(invType, invName, trunkSize)
    -- Remove non valid inventory type
    if not NamedInventories[invType] then return end

    -- If inventory exist, return it
    if NamedInventories[invType][invName] then
        return GetUsableDataFromInventory(NamedInventories[invType][invName])
    end

    -- Else, we have to get it from database or create it
    if invType == "1" then
        -- Named inventory
        -- Named inventories can't be created by player asking for them, these have to be created explicitly by server script

        local inventory = MySQL.single.await("SELECT `label`, `max_weight`, `inventory` FROM `ava_named_inventories` WHERE `name` = :name", { name = invName })
        if inventory then
            -- If it exists, we can use it
            NamedInventories[invType][invName] = CreateInventory(1, invName, inventory.inventory and json.decode(inventory.inventory) or {},
                inventory.max_weight, inventory.label)

            return GetUsableDataFromInventory(NamedInventories[invType][invName])
        end

    elseif invType == "2" then
        -- Vehicle inventory

        -- Get vehicle inventory
        local inventory = MySQL.single.await("SELECT `max_weight`, `trunk` FROM `ava_vehiclestrunk` WHERE `vehicleid` = :vehicleid", { vehicleid = tonumber(invName) })
        if inventory then
            -- If it exists, we can use it
            NamedInventories[invType][invName] = CreateInventory(2, invName, inventory.trunk and json.decode(inventory.trunk) or {},
                inventory.max_weight, GetString("vehicle_trunk"))
        else
            -- If it doesn't exist, insert it
            dprint("[AVA] Creating vehicle inventory for vehicle", invName)
            MySQL.insert.await("INSERT INTO `ava_vehiclestrunk` (`vehicleid`, `max_weight`, `trunk`) VALUES (:vehicleid, :max_weight, :trunk)",
                { vehicleid = tonumber(invName), max_weight = trunkSize, trunk = "[]" })
            NamedInventories[invType][invName] = CreateInventory(2, invName, {}, trunkSize, GetString("vehicle_trunk"))
        end

        return GetUsableDataFromInventory(NamedInventories[invType][invName])

    elseif invType == "3" then
        -- Vehicle entity
        NamedInventories[invType][invName] = CreateInventory(3, invName, {}, trunkSize, GetString("vehicle_trunk"))
        dprint("[AVA] Creating vehicle inventory for entity", invName)
        return GetUsableDataFromInventory(NamedInventories[invType][invName])
    end

end
exports("GetNamedInventoryItems", AVA.GetNamedInventoryItems)

--#region named inventory

AVA.RegisterServerCallback("ava_core:server:getNamedInventoryItems", function(source, invName)
    return AVA.GetNamedInventoryItems("1", invName)
end)

AVA.RegisterServerCallback("ava_core:server:getVehicleTrunk", function(source, vehicleNet, trunkSize)
    local src = source
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNet)
    if not DoesEntityExist(vehicle) then return end

    -- Vehicle is locked
    if GetVehicleDoorLockStatus(vehicle) > 1 then
        return
    end

    local vehicleId = Entity(vehicle).state.id
    local invType, invName
    if vehicleId then
        -- Owned vehicle
        invType, invName = "2", tostring(vehicleId)
    else
        -- Entity is not owned
        invType, invName = "3", ("%s-%s"):format(tostring(vehicleNet), GetVehicleNumberPlateText(vehicle))
    end

    return invType, invName, AVA.GetNamedInventoryItems(invType, invName, trunkSize)
end)

RegisterNetEvent("ava_core:server:takeInventoryItem", function(invType, invName, itemName, quantity)
    -- Event is canceled in case of failure
    local src = source

    invType = tostring(invType)
    if not NamedInventories[invType] then CancelEvent() return
    end

    local namedInventory = NamedInventories[invType][invName]
    if not namedInventory then CancelEvent() return
    end

    local aPlayer = AVA.Players.GetPlayer(src)
    if aPlayer then
        local playerInventory = aPlayer.inventory
        if quantity and quantity > 0 and namedInventory.canRemoveItem(itemName, quantity) then
            if playerInventory.canAddItem(itemName, quantity) then
                namedInventory.removeItem(itemName, quantity)
                playerInventory.addItem(itemName, quantity)
                TriggerEvent("ava_logs:server:log", { "citizenid:" .. aPlayer.citizenId, "take_item_from", "invType:" .. invType, "invName:" .. invName, "item:" .. itemName, "quantity:" .. quantity })
                return -- Return so the event is not canceled
            else
                TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("not_enough_place"))
            end
        else
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("invalid_quantity"))
        end
    end
    CancelEvent()
end)

RegisterNetEvent("ava_core:server:putInventoryItem", function(invType, invName, itemName, quantity)
    -- Event is canceled in case of failure
    local src = source

    invType = tostring(invType)
    if not NamedInventories[invType] then CancelEvent() return end

    local namedInventory = NamedInventories[invType][invName]
    if not namedInventory then CancelEvent() return end

    local aPlayer = AVA.Players.GetPlayer(src)
    if aPlayer then
        local playerInventory = aPlayer.inventory
        if quantity and quantity > 0 and playerInventory.canRemoveItem(itemName, quantity) then
            if namedInventory.canAddItem(itemName, quantity) then
                playerInventory.removeItem(itemName, quantity)
                namedInventory.addItem(itemName, quantity)
                TriggerEvent("ava_logs:server:log", { "citizenid:" .. aPlayer.citizenId, "put_item_into", "invType:" .. invType, "invName:" .. invName, "item:" .. itemName, "quantity:" .. quantity })
                return -- Return so the event is not canceled
            else
                TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("named_inventory_not_enough_place", namedInventory.label))
            end
        else
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("invalid_quantity"))
        end
    end
    CancelEvent()
end)

AVA.SaveAllNamedInventories = function()
    local promises = {}
    local count = 0

    for invType, inventories in pairs(NamedInventories) do
        for invName, inventory in pairs(inventories) do
            local p = inventory.save()
            if p then
                count = count + 1
                promises[count] = p
            end
        end
    end
    Citizen.Await(promise.all(promises))
    print("^2[SAVE NAMED INVENTORIES]^0 Every named inventories has been saved.")
end

AVA.SaveNamedInventory = function(inventory)
    if inventory then
        if inventory.modified then
            if inventory.namedInventory then
                local p = promise.new()
                MySQL.update("UPDATE `ava_named_inventories` SET `inventory` = :inventory WHERE `name` = :name",
                    { name = inventory.namedInventory, inventory = json.encode(inventory.items) }, function(result)
                    inventory.modified = false
                    print("^2[SAVE NAMED INVENTORY] ^0" .. inventory.namedInventory)
                    p:resolve()
                end)
                return p

            elseif inventory.vehicleIdentifier then
                local p = promise.new()
                MySQL.update("UPDATE `ava_vehiclestrunk` SET `trunk` = :trunk WHERE `vehicleid` = :vehicleid",
                    { vehicleid = tonumber(inventory.vehicleIdentifier), trunk = json.encode(inventory.items) }, function(result)
                    inventory.modified = false
                    print("^2[SAVE VEHICLE INVENTORY] ^0" .. inventory.vehicleIdentifier)
                    p:resolve()
                end)
                return p
            end
        end
    else
        error("^1[AVA.SaveNamedInventory]^0 aInventory is not valid.")
    end
end
--#endregion named inventory
