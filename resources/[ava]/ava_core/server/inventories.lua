-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local Items = AVAConfig.Items

AVA.RegisterServerCallback("ava_core:server:getInventoryItems", function(source)
    local src = source
    local aPlayer = exports.ava_core:GetPlayer(src)
    if aPlayer then
        local inventory = aPlayer.GetInventory()

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
