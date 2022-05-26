-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
exports.ava_core:RegisterServerCallback("ava_stores:server:getPlayerOutfits", function(source)
    local src = source
    local aPlayer = exports.ava_core:GetPlayer(src)
    if not aPlayer then
        return
    end
    return MySQL.query.await("SELECT `id`, `label`, `outfit` FROM `ava_playeroutfits` WHERE `citizenid` = :citizenid", {citizenid = aPlayer.citizenId})
end)

exports.ava_core:RegisterServerCallback("ava_stores:server:savePlayerOutfit", function(source, label, outfit)
    local src = source
    local aPlayer = exports.ava_core:GetPlayer(src)
    if not aPlayer or (not label or label == "") or type(outfit) ~= "table" then
        return
    end

    local id = MySQL.insert.await("INSERT INTO `ava_playeroutfits` (`citizenid`, `label`, `outfit`) VALUES (:citizenid, :label, :outfit)",
        {citizenid = aPlayer.citizenId, label = label:sub(0, 50), outfit = json.encode(outfit)})
    return id
end)

RegisterNetEvent("ava_stores:server:deletePlayerOutfit", function(id)
    local src = source
    local aPlayer = exports.ava_core:GetPlayer(src)
    if not aPlayer then
        return
    end

    MySQL.update.await("DELETE FROM `ava_playeroutfits` WHERE `citizenid` = :citizenid AND `id` = :id", {citizenid = aPlayer.citizenId, id = id})
end)

RegisterNetEvent("ava_stores:server:setPlayerSkin", function(playerSkin)
    local src = source
    local aPlayer = exports.ava_core:GetPlayer(src)
    if not aPlayer then
        return
    end

    aPlayer.setSkin(playerSkin)
end)
