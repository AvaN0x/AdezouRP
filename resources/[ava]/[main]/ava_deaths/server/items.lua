-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

-- TODO error logs

local isAbleToUse = function(src)
    return exports.ava_jobs:getCountInService(AVAConfig.EMSJobName) == 0 or exports.ava_jobs:isInServiceOrHasJob(src, AVAConfig.EMSJobName)
end

-------------
-- bandage --
-------------

exports.ava_core:RegisterUsableItem("bandage", function(source)
    local src = source
    local aPlayer = exports.ava_core:GetPlayer(src)
    local inventory = aPlayer.getInventory()

    if inventory.canRemoveItem("bandage", 1) then
        TriggerClientEvent("ava_deaths:clientbandage:heal", src)
    end
end)

RegisterServerEvent("ava_deaths:server:bandage:remove", function()
    local src = source
    local aPlayer = exports.ava_core:GetPlayer(src)
    local inventory = aPlayer.getInventory()

    if inventory.canRemoveItem("bandage", 1) then
        inventory.removeItem("bandage", 1)
    end
end)

-------------
-- medikit --
-------------

exports.ava_core:RegisterUsableItem("medikit", function(source)
    local src = source
    if isAbleToUse(src) then
        TriggerClientEvent("ava_deaths:client:medikit", src)
    else
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("cant_use_now"))
    end
end)

RegisterServerEvent("ava_deaths:server:medikit:heal", function(target)
    local src = source
    local aPlayer = exports.ava_core:GetPlayer(src)
    local inventory = aPlayer.getInventory()

    if inventory.canRemoveItem("medikit", 1) then
        inventory.removeItem("medikit", 1)
        TriggerClientEvent("ava_deaths:client:medikit:heal", target)
    end
end)


-------------------
-- defibrillator --
-------------------

exports.ava_core:RegisterUsableItem("defibrillator", function(source)
    local src = source
    if isAbleToUse(src) then
        TriggerClientEvent("ava_deaths:client:defibrillator", src)
    else
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("cant_use_now"))
    end
end)

RegisterServerEvent("ava_deaths:server:defibrillator:revive", function(target)
    local src = source
    local aPlayer = exports.ava_core:GetPlayer(src)
    local aTarget = exports.ava_core:GetPlayer(target)
    local inventory = aPlayer.getInventory()

    if inventory.canRemoveItem("defibrillator", 1) and (aTarget.metadata.health or 0) <= 0 then
        inventory.removeItem("defibrillator", 1)
        TriggerClientEvent("ava_deaths:client:revive", target)
    end
end)
