-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

local min = math.min
local max = math.max
local floor = math.floor

-- #region get vehicles at insurance
exports.ava_core:RegisterServerCallback("ava_garages:server:getVehiclesAtInsurance", function(source)
    -- Player personal vehicles garage
    local src = source

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
        "SELECT `id`, `job_name`, `label`, `model`, `plate`, `insurance_left` FROM `ava_vehicles` WHERE `parked` = 0 AND (`citizenid` = :citizenid OR `job_name` IN (:jobs))",
            { citizenid = aPlayer.citizenId, jobs = jobs })
    else
        vehicles = MySQL.query.await(
        "SELECT `id`, `label`, `model`, `plate`, `insurance_left` FROM `ava_vehicles` WHERE `parked` = 0 AND `citizenid` = :citizenid",
            { citizenid = aPlayer.citizenId })
    end

    return vehicles
end)
-- #endregion get vehicles at insurance


exports.ava_core:RegisterServerCallback("ava_garages:server:payVehicleInsurance", function(source, vehicleId)
    local src = source
    if not vehicleId then return end

    local aPlayer = exports.ava_core:GetPlayer(src)
    if not aPlayer then return end

    local allowed, vehicleData = IsAllowedToInteractWithVehicle(vehicleId, aPlayer, false)
    if not allowed then return end

    if vehicleData.insurance_left <= 0 then
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("insurance_no_more_insurance"))
        return
    end

    local vehiclePrice = exports.ava_stores:GetVehiclePrice(vehicleData.model)
    if not vehiclePrice then return end

    local price = min(max(floor(vehiclePrice * AVAConfig.InsurancePriceMultiplier + 0.5), AVAConfig.InsurancePriceMinimum), AVAConfig.InsurancePriceMaximum)
    local inventory = aPlayer.getInventory()
    if not inventory.canRemoveItem("cash", price) then
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("cant_afford"))
        return
    end

    inventory.removeItem("cash", price)
    MySQL.update.await("UPDATE `ava_vehicles` SET `parked` = :parked, `insurance_left` = `insurance_left` - 1 WHERE `id` = :id",
        { parked = true, id = vehicleId })
    TriggerEvent("ava_logs:server:log", { aPlayer.citizenId, "pay_insurance", vehicleId, "for", price })

    return true
end)
