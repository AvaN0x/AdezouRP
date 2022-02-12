-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
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
    -- Get all vehicles in the garage
    if type(vehicleType) == "number" then
        return MySQL.query.await(
            "SELECT `id`, `label`, `model`, `plate`, `parked`, `garage`, `data`, `vehicletype` FROM `ava_vehicles` WHERE `garage` = :garage AND `vehicletype` = :vehicletype",
            {garage = garageName, vehicletype = vehicleType})
    else
        return MySQL.query.await(
            "SELECT `id`, `label`, `model`, `plate`, `parked`, `garage`, `data`, `vehicletype` FROM `ava_vehicles` WHERE `garage` = :garage",
            {garage = garageName})
    end
end)
