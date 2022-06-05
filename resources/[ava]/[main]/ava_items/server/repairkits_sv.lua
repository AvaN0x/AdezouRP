-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local MechanicJobName <const> = "mechanic"

---------------
-- repairkit --
---------------

exports.ava_core:RegisterUsableItem("repairkit", function(source, aPlayer)
    local hasJob <const> = aPlayer.hasJob(MechanicJobName)
    if hasJob or exports.ava_jobs:getCountInService(MechanicJobName) == 0 then
        TriggerClientEvent("ava_items:client:useRepairkit", source, hasJob and 1000.0 or 500.0)
    else
        TriggerClientEvent("ava_core:client:ShowNotification", source, GetString("repairkits_cant_use_now"))
    end
end)

RegisterServerEvent("ava_items:repairkit:remove", function()
    local aPlayer = exports.ava_core:GetPlayer(source)
    if aPlayer then
        local inventory = aPlayer.getInventory()
        inventory.removeItem("repairkit", 1)
    end
end)

-------------
-- bodykit --
-------------

exports.ava_core:RegisterUsableItem("bodykit", function(source, aPlayer)
    if aPlayer.hasJob(MechanicJobName) then
        TriggerClientEvent("ava_items:client:useBodykit", source)
    else
        TriggerClientEvent("ava_core:client:ShowNotification", source, GetString("repairkits_need_to_be_mechanic"))
    end
end)

RegisterServerEvent("ava_items:bodykit:remove", function()
    local aPlayer = exports.ava_core:GetPlayer(source)
    if aPlayer then
        local inventory = aPlayer.getInventory()
        inventory.removeItem("bodykit", 1)
    end
end)

-----------
-- rag --
-----------

exports.ava_core:RegisterUsableItem("rag", function(source)
    TriggerClientEvent("ava_items:client:useRag", source)
end)

RegisterServerEvent("ava_items:rag:remove", function()
    local aPlayer = exports.ava_core:GetPlayer(source)
    if aPlayer then
        local inventory = aPlayer.getInventory()
        inventory.removeItem("rag", 1)
    end
end)

-------------
-- bodykit --
-------------

exports.ava_core:RegisterUsableItem("blowtorch", function(source, aPlayer)
    if aPlayer.hasJob(MechanicJobName) then
        TriggerClientEvent("ava_items:client:useBlowtorch", source)
    else
        TriggerClientEvent("ava_core:client:ShowNotification", source, GetString("repairkits_need_to_be_mechanic"))
    end
end)

RegisterServerEvent("ava_items:blowtorch:remove", function()
    if math.random(0, 100) < 10 then
        local aPlayer = exports.ava_core:GetPlayer(source)
        if aPlayer then
            local inventory = aPlayer.getInventory()
            inventory.removeItem("blowtorch", 1)
        end
    end
end)
