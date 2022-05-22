-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local housesInfos = {}

RegisterNetEvent("ava_burglaries:server:updateState", function(houseID, state)
    if not AVAConfig.Houses[houseID] then return end

    housesInfos[houseID] = state
    TriggerClientEvent("ava_burglaries:client:setState", -1, houseID, state)
end)

exports.ava_core:RegisterServerCallback("ava_burglaries:server:getHousesInfo", function(source)
    return housesInfos
end)

exports.ava_core:RegisterServerCallback("ava_burglaries:server:searchFurniture", function(source, houseID)
    if not AVAConfig.Houses[houseID] then return false end

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
    if not AVAConfig.Houses[houseID] then return end

    exports.ava_core:MovePlayerToNamedRB(source, "burglary_" .. houseID)
    housesInfos[houseID] = 1
    TriggerClientEvent("ava_burglaries:client:setState", -1, houseID, 1)

    Wait(30 * 60 * 1000)
    housesInfos[houseID] = 0
    TriggerClientEvent("ava_burglaries:client:setState", -1, houseID, 0)
end)

RegisterNetEvent("ava_burglaries:server:leaveHouse", function(houseID)
    if not AVAConfig.Houses[houseID] then return end
    exports.ava_core:MovePlayerToRB(source, 0)
end)

RegisterNetEvent("ava_burglaries:server:callCops", function(houseID)
    -- Check if house is valid
    if not AVAConfig.Houses[houseID] then return end
    -- Check if house is getting robbed
    if housesInfos[houseID] ~= 1 then return end

    exports.ava_jobs:sendMessageToJob("lspd", {
        message = GetString("burglary_in_this_house"),
        location = AVAConfig.Houses[houseID].coord.xyz
    })
end)
