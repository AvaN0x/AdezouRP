-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local playersKeys = {}

Citizen.CreateThread(function()
    print("[AVA] Vehicle keys doubles deleted")
    MySQL.query("DELETE FROM `ava_vehicleskeys` WHERE `keytype` > 0")
end)

---Get player keys
---@param src integer
---@param aPlayer? aPlayer
---@return table
local function GetPlayerKeys(src, aPlayer)
    src = tostring(src)
    if not playersKeys[src] then
        if not aPlayer then
            aPlayer = exports.ava_core:GetPlayer(src)
        end

        playersKeys[src] = {}
        if aPlayer then
            local keys = MySQL.query.await("SELECT `vehicleid`, `keytype` FROM `ava_vehicleskeys` WHERE `citizenid` = :citizenid", { citizenid = aPlayer.citizenId })
            for i = 1, #keys do
                playersKeys[src][tostring(keys[i].vehicleid)] = { type = keys[i].keytype }
            end
        end
    end

    return playersKeys[src]
end

local function HasKey(src, vehicleId)
    return GetPlayerKeys(src)[tostring(vehicleId)] ~= nil
end

exports.ava_core:RegisterServerCallback("ava_garages:server:getPlayerKeys", function(source)
    return GetPlayerKeys(source)
end)

RegisterNetEvent("ava_garages:server:tryToLockVehicle", function(vehNet)
    local src = source
    local vehicle = NetworkGetEntityFromNetworkId(vehNet)
    if not DoesEntityExist(vehicle) then return end

    local entityState = Entity(vehicle)
    local vehicleId = entityState.state.id
    if not vehicleId or not HasKey(src, vehicleId) then
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("vehicle_keys_dont_have_keys"))
        return
    end

    local state = GetVehicleDoorLockStatus(vehicle) == (AVAConfig.PlayerLockedInLockedVehicle and 4 or 2) and 1 or (AVAConfig.PlayerLockedInLockedVehicle and 4 or 2)
    TriggerClientEvent("ava_garages:client:vehicleDoorsLockAnim", src, vehNet, state ~= (AVAConfig.PlayerLockedInLockedVehicle and 4 or 2))
    SetVehicleDoorsLocked(vehicle, state)
end)

AddEventHandler("playerDropped", function(reason)
    local src = source
    if playersKeys[tostring(src)] then
        playersKeys[tostring(src)] = nil
    end
end)


GivePlayerVehicleKey = function(src, citizenId, vehicleId, keyType)
    src = tostring(src)
    local playerKeys = GetPlayerKeys(src)
    if playerKeys[tostring(vehicleId)] then
        playersKeys[src][tostring(vehicleId)].type = keyType
        MySQL.query("UPDATE `ava_vehicleskeys` SET `keytype` = :keytype WHERE `citizenid` = :citizenid AND `vehicleid` = :vehicleid", { citizenid = citizenId, vehicleid = vehicleId, keytype = keyType })
    else
        playersKeys[src][tostring(vehicleId)] = { type = keyType }
        MySQL.query("INSERT INTO `ava_vehicleskeys` (`citizenid`, `vehicleid`, `keytype`) VALUES (:citizenid, :vehicleid, :keytype)", { citizenid = citizenId, vehicleid = vehicleId, keytype = keyType })
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("vehicle_keys_received_key"))
    end
end
exports("GivePlayerVehicleKey", GivePlayerVehicleKey)

GivePlayerVehicleKeyIfLower = function(src, citizenId, vehicleId, keyType)
    src = tostring(src)
    local playerKeys = GetPlayerKeys(src)
    if not playerKeys[tostring(vehicleId)] or keyType < playerKeys[tostring(vehicleId)].type then
        GivePlayerVehicleKey(src, citizenId, vehicleId, keyType)
    end
end
exports("GivePlayerVehicleKeyIfLower", GivePlayerVehicleKeyIfLower)

RemovePlayerVehicleKey = function(src, citizenId, vehicleId)
    src = tostring(src)
    local playerKeys = GetPlayerKeys(src)
    if playerKeys[tostring(vehicleId)] then
        playersKeys[src][tostring(vehicleId)] = nil
        MySQL.query.await("DELETE FROM `ava_vehicleskeys` WHERE `citizenid` = :citizenid AND `vehicleid` = :vehicleid", { citizenid = citizenId, vehicleid = vehicleId })
    end
end
exports("RemovePlayerVehicleKey", RemovePlayerVehicleKey)

local RemoveKeysForVehicle = function(vehicleId)
    MySQL.query.await("DELETE FROM `ava_vehicleskeys` WHERE `vehicleid` = :vehicleid", { vehicleid = vehicleId })
end
exports("RemoveKeysForVehicle", RemoveKeysForVehicle)
