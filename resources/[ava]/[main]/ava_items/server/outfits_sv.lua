-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
for itemName, outfitName in pairs(AVAConfig.OutfitItemNames) do
    exports.ava_core:RegisterUsableItem(itemName, function(source)
        TriggerClientEvent("ava_items:client:useOutfit", source, outfitName)
    end)
end
