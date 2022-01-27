-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local houseInfos = {}

RegisterNetEvent("ava_burglaries:server:updateState", function(houseID, state)
    if not AVAConfig.Houses[houseID] then
        return
    end
    houseInfos[houseID] = state
    TriggerClientEvent("ava_burglaries:client:setState", -1, houseID, state)
end)

exports.ava_core:RegisterServerCallback("ava_burglaries:server:getHousesInfo", function(source)
    return houseInfos
end)

exports.ava_core:RegisterServerCallback("ava_burglaries:server:searchFurniture", function(source, houseID)
    if not AVAConfig.Houses[houseID] then
        return false
    end
    local src = source
    local aPlayer = exports.ava_core:GetPlayer(src)
    local inventory = aPlayer.getInventory()
    local itemName = AVAConfig.StealableItems[math.random(#AVAConfig.StealableItems)]
    -- 80% chance to find an item
    if math.random(0, 100) < 80 then
        if inventory.addOrDropItem(itemName, 1) then
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("cant_carry"))
        end
        return true
    end
    return false
end)

RegisterNetEvent("ava_burglaries:server:enterHouse", function(houseID)
    if not AVAConfig.Houses[houseID] then
        return
    end
    exports.ava_core:MovePlayerToNamedRB(source, "burglary_" .. houseID)
    houseInfos[houseID] = 1
    TriggerClientEvent("ava_burglaries:client:setState", -1, houseID, 1)

    Wait(30 * 60 * 1000)
    houseInfos[houseID] = 0
    TriggerClientEvent("ava_burglaries:client:setState", -1, houseID, 0)
end)

RegisterNetEvent("ava_burglaries:server:leaveHouse", function(houseID)
    if not AVAConfig.Houses[houseID] then
        return
    end
    exports.ava_core:MovePlayerToRB(source, 0)
end)
