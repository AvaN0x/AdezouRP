-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
-- #region get vehicles in pound
exports.ava_core:RegisterServerCallback("ava_garages:server:getVehiclesInPound", function(source, garageName, vehicleType)
    -- Player personal vehicles garage
    local src = source
    if type(garageName) ~= "string" or type(vehicleType) ~= "number" then
        print("sad1")
        return
    end
    local aPlayer = exports.ava_core:GetPlayer(src)
    if not aPlayer then
        print("sad")
        return
    end
    local jobs = {}
    local playerJobs = aPlayer.getJobs()
    for i = 1, #playerJobs do
        local job = playerJobs[i]
        if not job.isGang and IsPlayerAceAllowed(src, "job." .. job.name .. ".manage") then
            table.insert(jobs, job.name)
        end
    end
    if #jobs > 0 then
        return MySQL.query.await(
            "SELECT `id`, `job_name`, `label`, `model`, `plate` FROM `ava_vehicles` WHERE `vehicletype` = :vehicletype AND `garage` = :garage AND (`citizenid` = :citizenid OR `job_name` IN (:jobs))",
            {vehicletype = vehicleType, garage = garageName, citizenid = aPlayer.citizenId, jobs = jobs})
    else
        return MySQL.query.await(
            "SELECT `id`, `job_name`, `label`, `model`, `plate` FROM `ava_vehicles` WHERE `vehicletype` = :vehicletype AND `garage` = :garage AND `citizenid` = :citizenid",
            {vehicletype = vehicleType, garage = garageName, citizenid = aPlayer.citizenId})
    end
end)
-- #endregion get vehicles in pound
