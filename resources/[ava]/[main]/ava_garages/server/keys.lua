-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local playerKeys = {}

---Get player keys
---@param src integer
---@param aPlayer? aPlayer
---@return table
local function GetPlayerKeys(src, aPlayer)
    src = tostring(src)
    if not playerKeys[src] then
        if not aPlayer then
            aPlayer = exports.ava_core:GetPlayer(src)
        end

        playerKeys[src] = {}
        if aPlayer then
            local keys = MySQL.query.await("SELECT `vehicleid`, `keytype` FROM `ava_vehicleskeys` WHERE `citizenid` = :citizenid", { citizenid = aPlayer.citizenId })
            for i = 1, #keys do
                playerKeys[src][tostring(keys[i].vehicleid)] = { type = keys[i].keytype }
            end
        end
    end

    return playerKeys[src]
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
    if playerKeys[tostring(src)] then
        playerKeys[tostring(src)] = nil
    end
end)
