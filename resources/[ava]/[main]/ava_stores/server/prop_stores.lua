-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

exports.ava_core:RegisterServerCallback("ava_stores:server:buyAtPropStore", function(source, model, itemName)
    local src = source
    local propStore = Config.PropStores[model]

    if not propStore or not propStore.Items then return end

    local aPlayer = exports.ava_core:GetPlayer(src)
    local inventory = aPlayer.getInventory()

    local price = nil
    local useItem = false
    for _, v in ipairs(propStore.Items) do
        if v.name == itemName then
            price = tonumber(v.price)
            useItem = v.useItem
            break
        end
    end
    if price == nil then
        return false
    end

    -- If item has to be used, the player do not need to be able to have the item in his inventory
    if not inventory.canAddItem(itemName, 1) and not useItem then
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("cant_carry"))
        return false
    end

    if not inventory.canRemoveItem("cash", price) then
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("cant_afford"))
        return false
    end

    inventory.removeItem("cash", price)
    -- TODO give item after timeout?
    inventory.addItem(itemName, 1)
    if useItem then
        aPlayer.useItem(itemName)
    end

    exports.ava_jobs:applyTaxes(price, 'propStore:' .. model .. ":citizenid:" .. aPlayer.citizenId)
    TriggerEvent("ava_logs:server:log",
        { "citizenid:" .. aPlayer.citizenId, "buy_item", "item:" .. itemName, "count:" .. 1, "price:" .. price })
    return true
end)
