-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
exports.ava_core:RegisterUsableItem("lockpick", function(source)
    TriggerClientEvent("ava_items:client:useLockpick", source)
end)
RegisterNetEvent("ava_items:server:usedLockpick", function(success)
    local aPlayer = exports.ava_core:GetPlayer(source)
    local inventory = aPlayer.getInventory()
    if not success or math.random(1, 3) == 1 then
        inventory.removeItem("lockpick", 1)
    end
end)
