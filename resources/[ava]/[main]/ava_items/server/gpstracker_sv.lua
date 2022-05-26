-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
exports.ava_core:RegisterUsableItem("gpstracker", function(source)
    TriggerClientEvent("ava_items:client:useGPSTracker", source)
end)

RegisterNetEvent("ava_items:server:gpstracker:remove", function()
    local aPlayer = exports.ava_core:GetPlayer(source)
    if aPlayer then
        local inventory = aPlayer.getInventory()
        inventory.removeItem("gpstracker", 1)
    end
end)
