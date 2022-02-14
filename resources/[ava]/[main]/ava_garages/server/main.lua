-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
-- #region get vehicles in garage
exports.ava_core:RegisterServerCallback("ava_garages:server:getAccessibleVehiclesInGarage", function(source, garageName, vehicleType)
    -- Player personal vehicles garage
    local src = source
    if type(garageName) ~= "string" then
        return
    end
    local aPlayer = exports.ava_core:GetPlayer(src)
    if not aPlayer then
        return
    end
    -- TODO Only show vehicles from this garage?
    if type(vehicleType) == "number" then
        return MySQL.query.await(
            "SELECT `id`, `label`, `model`, `plate`, `parked`, `garage`, `data`, `vehicletype` FROM `ava_vehicles` WHERE `citizenid` = :citizenid AND `vehicletype` = :vehicletype",
            {citizenid = aPlayer.citizenId, vehicletype = vehicleType})
    else
        return MySQL.query.await(
            "SELECT `id`, `label`, `model`, `plate`, `parked`, `garage`, `data`, `vehicletype` FROM `ava_vehicles` WHERE `citizenid` = :citizenid",
            {citizenid = aPlayer.citizenId})
    end
end)

exports.ava_core:RegisterServerCallback("ava_garages:server:getAccessibleVehiclesInJobGarage", function(source, garageName, jobName, vehicleType)
    -- Garage where every vehicle inside of it is accessible to the player
    local src = source
    if type(garageName) ~= "string" or type(jobName) ~= "string" or not IsPlayerAceAllowed(src, "ace.job." .. jobName .. ".main") then
        return
    end
    -- Get all vehicles from the job
    -- TODO Only show vehicles from this garage?
    if type(vehicleType) == "number" then
        return MySQL.query.await(
            "SELECT `id`, `label`, `model`, `plate`, `parked`, `garage`, `data`, `vehicletype` FROM `ava_vehicles` WHERE `job_name` = :job_name AND `vehicletype` = :vehicletype",
            {job_name = jobName, vehicletype = vehicleType})
    else
        return MySQL.query.await(
            "SELECT `id`, `label`, `model`, `plate`, `parked`, `garage`, `data`, `vehicletype` FROM `ava_vehicles` WHERE `job_name` = :job_name",
            {job_name = jobName})
    end
end)

exports.ava_core:RegisterServerCallback("ava_garages:server:getAccessibleVehiclesInCommonGarage", function(source, garageName, vehicleType)
    -- Garage where every vehicle inside of it is accessible to everyone, and everyone can put his vehicle in it
    local src = source
    if type(garageName) ~= "string" then
        return
    end
    local aPlayer = exports.ava_core:GetPlayer(src)
    if not aPlayer then
        return
    end
    -- Get all vehicles in the garage
    if type(vehicleType) == "number" then
        return MySQL.query.await(
            "SELECT `id`, `label`, `model`, `plate`, `parked`, `garage`, `data`, `vehicletype`, citizenid = :citizenid AS `can_rename` FROM `ava_vehicles` WHERE `garage` = :garage AND `vehicletype` = :vehicletype",
            {citizenid = aPlayer.citizenId, garage = garageName, vehicletype = vehicleType})
    else
        return MySQL.query.await(
            "SELECT `id`, `label`, `model`, `plate`, `parked`, `garage`, `data`, `vehicletype`, citizenid = :citizenid AS `can_rename` FROM `ava_vehicles` WHERE `garage` = :garage",
            {citizenid = aPlayer.citizenId, garage = garageName})
    end
end)
-- #endregion get vehicles in garage

function IsAllowedToInteractWithVehicle(vehicleId, aPlayer, checkCanManage, IsCommonGarage)
    if not vehicleId or not aPlayer then
        return false
    end
    local vehicle = MySQL.single.await("SELECT `ownertype`, `citizenid`, `job_name`, `garage`, `parked` FROM `ava_vehicles` WHERE `id` = :id", {id = vehicleId})
    if not vehicle then
        return false
    end
    if (vehicle.ownertype == 0 and (vehicle.citizenid == aPlayer.citizenId or IsCommonGarage))
        or (vehicle.ownertype == 1 and IsPlayerAceAllowed(aPlayer.src, "ace.job." .. vehicle.job_name .. ".main")
            and (not checkCanManage or IsPlayerAceAllowed(aPlayer.src, "job." .. vehicle.job_name .. ".manage"))) then
        return true, vehicle
    end
    return false
end

-- #region rename vehicle
exports.ava_core:RegisterServerCallback("ava_garages:server:renameVehicle", function(source, vehicleId, label)
    local src = source
    local aPlayer = exports.ava_core:GetPlayer(src)
    if not aPlayer then
        return false
    end
    label = exports.ava_core:Trim(label)
    if label:len() < 2 or label:len() > 50 then
        return false
    end
    if IsAllowedToInteractWithVehicle(vehicleId, aPlayer, true) then
        MySQL.update.await("UPDATE `ava_vehicles` SET `label` = :label WHERE `id` = :id", {id = vehicleId, label = label})
        return true
    end
    return false
end)
-- #endregion rename vehicle

-- #region take out vehicle
RegisterNetEvent("ava_garages:server:spawnedVehicle", function(vehicleNet, vehicleId, IsCommonGarage)
    local src = source
    -- #region wait for entity to exist or abort
    -- Prevent infinite loop
    local waitForEntityToExistCount = 0
    while waitForEntityToExistCount <= 100 and not DoesEntityExist(NetworkGetEntityFromNetworkId(vehicleNet)) do
        Wait(10)
        waitForEntityToExistCount = waitForEntityToExistCount + 1
    end
    if waitForEntityToExistCount > 100 then
        return
    end
    -- #endregion wait for entity to exist or abort

    local vehicle = NetworkGetEntityFromNetworkId(vehicleNet)
    local aPlayer = exports.ava_core:GetPlayer(src)
    if not aPlayer then
        -- We delete the entity in case of error
        DeleteEntity(vehicle)
        return
    end
    local allowed, vehicleData = IsAllowedToInteractWithVehicle(vehicleId, aPlayer, true, IsCommonGarage)
    -- We only do actions if the player is allowed to interact with the vehicle and the vehicle is not already spawned
    if not allowed or not vehicleData.parked then
        -- We delete the entity in case of error
        DeleteEntity(vehicle)
        return
    end

    local entityState = Entity(vehicle)
    entityState.state:set("id", vehicleId, false)
    MySQL.update.await("UPDATE `ava_vehicles` SET `parked` = :parked WHERE `id` = :id", {id = vehicleId, parked = false})
end)
-- #endregion take out vehicle

-- #region park vehicle
RegisterNetEvent("ava_garages:server:parkVehicle", function(garageName, vehicleType, vehicleNet, IsJobGarage, IsCommonGarage)
    local src = source
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNet)
    if not DoesEntityExist(vehicle) then
        return
    end
    local aPlayer = exports.ava_core:GetPlayer(src)
    if not aPlayer then
        return false
    end

    local entityState = Entity(vehicle)
    local vehicleId = entityState.state.id
    if not vehicleId then
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("garage_park_cant_park_this_vehicle"))
        return
    end

    local allowed, vehicleData = IsAllowedToInteractWithVehicle(vehicleId, aPlayer, false, IsCommonGarage)
    local vehicleParked = false
    if allowed then
        if vehicleData.ownertype == 0 and not IsJobGarage then
            -- Player vehicle
            vehicleParked = true
        elseif vehicleData.ownertype == 1 and IsJobGarage and not IsCommonGarage then
            -- Job vehicle
            vehicleParked = true
        end
    end

    if vehicleParked then
        DeleteEntity(vehicle)

        if not vehicleData.parked then
            MySQL.update.await("UPDATE `ava_vehicles` SET `parked` = :parked, `garage` = :garage WHERE `id` = :id",
                {id = vehicleId, garage = garageName, parked = true})
        end
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("garage_park_vehicle_parked"))
    else
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("garage_park_cant_park_this_vehicle"))
    end
end)
-- #endregion park vehicle
