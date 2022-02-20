-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

local min = math.min
local max = math.max
local floor = math.floor

-- #region get vehicles in pound
exports.ava_core:RegisterServerCallback("ava_garages:server:getVehiclesInPound", function(source, garageName, vehicleType)
    -- Player personal vehicles garage
    local src = source
    if type(garageName) ~= "string" or type(vehicleType) ~= "number" then return end

    local aPlayer = exports.ava_core:GetPlayer(src)
    if not aPlayer then return end

    local jobs = {}
    local playerJobs = aPlayer.getJobs()
    for i = 1, #playerJobs do
        local job = playerJobs[i]
        if not job.isGang and IsPlayerAceAllowed(src, "job." .. job.name .. ".manage") then
            table.insert(jobs, job.name)
        end
    end
    local vehicles
    if #jobs > 0 then
        vehicles = MySQL.query.await(
        "SELECT `id`, `job_name`, `label`, `model`, `plate` FROM `ava_vehicles` WHERE `vehicletype` = :vehicletype AND `garage` = :garage AND (`citizenid` = :citizenid OR `job_name` IN (:jobs))",
            { vehicletype = vehicleType, garage = garageName, citizenid = aPlayer.citizenId, jobs = jobs })
    else
        vehicles = MySQL.query.await(
        "SELECT `id`, `label`, `model`, `plate` FROM `ava_vehicles` WHERE `vehicletype` = :vehicletype AND `garage` = :garage AND `citizenid` = :citizenid",
            { vehicletype = vehicleType, garage = garageName, citizenid = aPlayer.citizenId })
    end

    return vehicles
end)
-- #endregion get vehicles in pound


exports.ava_core:RegisterServerCallback("ava_garages:server:takeVehicleOutOfPound", function(source, vehicleId, garageName, vehicleType)
    local src = source
    if not vehicleId or not garageName or not vehicleType then return end

    local aPlayer = exports.ava_core:GetPlayer(src)
    if not aPlayer then return end

    local allowed, vehicleData = IsAllowedToInteractWithVehicle(vehicleId, aPlayer, false)
    if not allowed or vehicleData.garage ~= garageName then return end

    if not aPlayer.hasLicense("driver") then
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("pound_do_not_have_driver_license"))
        return
    end

    local vehiclePrice = exports.ava_stores:GetVehiclePrice(vehicleType, vehicleData.model)
    if not vehiclePrice then return end

    local price = min(max(floor(vehiclePrice * AVAConfig.PoundPriceMultiplier + 0.5), AVAConfig.PoundPriceMinimum), AVAConfig.PoundPriceMaximum)
    local inventory = aPlayer.getInventory()
    if not inventory.canRemoveItem("cash", price) then
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("cant_afford"))
        return
    end

    inventory.removeItem("cash", price)
    MySQL.update.await("UPDATE `ava_vehicles` SET `garage` = :garage WHERE `id` = :id", { garage = vehicleData.job_name and ("jobgarage_" .. vehicleData.job_name) or AVAConfig.DefaultGarage, id = vehicleId })

    return true
end)
