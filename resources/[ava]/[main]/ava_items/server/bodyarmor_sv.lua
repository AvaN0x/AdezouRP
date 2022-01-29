-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
exports.ava_core:RegisterUsableItem("bodyarmor", function(source)
    TriggerClientEvent("ava_items:client:useBodyarmor", source)
end)

RegisterNetEvent("ava_items:server:bodyarmor:remove", function()
    local aPlayer = exports.ava_core:GetPlayer(source)
    if aPlayer then
        local inventory = aPlayer.getInventory()
        inventory.removeItem("bodyarmor", 1)
    end
end)
