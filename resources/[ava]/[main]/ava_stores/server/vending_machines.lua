-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

exports.ava_core:RegisterServerCallback("ava_stores:server:buyVendingMachines", function(source, model, itemName)
    local src = source
    local vendingMachine = Config.VendingMachines[model]

    if not vendingMachine or not vendingMachine.Items then return end

    local aPlayer = exports.ava_core:GetPlayer(src)
    local inventory = aPlayer.getInventory()

    if not inventory.canAddItem(itemName, 1) then
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("cant_carry"))
        return false
    end

    local price = nil
    for k, v in ipairs(vendingMachine.Items) do
        if v.name == itemName then
            price = tonumber(v.price)
            break
        end
    end
    if price == nil then
        return false
    end

    if not inventory.canRemoveItem("cash", price) then
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("cant_afford"))
        return false
    end

    inventory.removeItem("cash", price)
    -- TODO give item after timeout?
    -- TODO config to force use of item?
    inventory.addItem(itemName, 1)

    exports.ava_jobs:applyTaxes(price, 'vendingMachine:' .. model .. ":citizenid:" .. aPlayer.citizenId)
    TriggerEvent("ava_logs:server:log",
        { "citizenid:" .. aPlayer.citizenId, "buy_item", "item:" .. itemName, "count:" .. 1, "price:" .. price })
    return true
end)
