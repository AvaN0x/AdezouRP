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
        "SELECT `id`, `label`, `model`, `plate`, `parked`, `garage`, `vehicletype` FROM `ava_vehicles` WHERE `citizenid` = :citizenid AND `vehicletype` = :vehicletype",
            { citizenid = aPlayer.citizenId, vehicletype = vehicleType })
    else
        return MySQL.query.await("SELECT `id`, `label`, `model`, `plate`, `parked`, `garage`, `vehicletype` FROM `ava_vehicles` WHERE `citizenid` = :citizenid",
            { citizenid = aPlayer.citizenId })
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
        "SELECT `id`, `label`, `model`, `plate`, `parked`, `garage`, `vehicletype` FROM `ava_vehicles` WHERE `job_name` = :job_name AND `vehicletype` = :vehicletype",
            { job_name = jobName, vehicletype = vehicleType })
    else
        return MySQL.query.await("SELECT `id`, `label`, `model`, `plate`, `parked`, `garage`, `vehicletype` FROM `ava_vehicles` WHERE `job_name` = :job_name",
            { job_name = jobName })
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
        "SELECT `id`, `label`, `model`, `plate`, `parked`, `garage`, `vehicletype`, citizenid = :citizenid AS `can_rename` FROM `ava_vehicles` WHERE `garage` = :garage AND `vehicletype` = :vehicletype",
            { citizenid = aPlayer.citizenId, garage = garageName, vehicletype = vehicleType })
    else
        return MySQL.query.await(
        "SELECT `id`, `label`, `model`, `plate`, `parked`, `garage`, `vehicletype`, citizenid = :citizenid AS `can_rename` FROM `ava_vehicles` WHERE `garage` = :garage",
            { citizenid = aPlayer.citizenId, garage = garageName })
    end
end)
-- #endregion get vehicles in garage

IsAllowedToInteractWithVehicle = function(vehicleId, aPlayer, checkCanManage, IsCommonGarage, garageName)
    if not vehicleId or not aPlayer then
        return false
    end
    local vehicle = MySQL.single.await("SELECT `ownertype`, `citizenid`, `job_name`, `garage`, `model`, `parked`, `insurance_left` FROM `ava_vehicles` WHERE `id` = :id", { id = vehicleId })
    if not vehicle then
        return false
    end
    if (vehicle.ownertype == 0 and (tonumber(vehicle.citizenid) == tonumber(aPlayer.citizenId) or (IsCommonGarage and garageName == vehicle.garage)))
        or (vehicle.ownertype == 1 and IsPlayerAceAllowed(aPlayer.src, "ace.job." .. vehicle.job_name .. ".main")
            and (not checkCanManage or IsPlayerAceAllowed(aPlayer.src, "job." .. vehicle.job_name .. ".manage"))) then
        return true, vehicle
    end
    return false
end
exports("IsAllowedToInteractWithVehicle", IsAllowedToInteractWithVehicle)

---Generate a valid plate with format 00AAA00
---@return string
local GenerateValidPlate = function()
    local plate
    repeat
        if plate then
            print("[GENERATE PLATE] Plate already exists, trying again", plate)
        end
        plate = ""
        -- 2 numbers
        for i = 1, 2 do
            plate = plate .. string.char(math.random(48, 57))
        end
        -- 3 letters
        for i = 1, 3 do
            plate = plate .. string.char(math.random(65, 90))
        end
        -- 2 numbers
        for i = 1, 2 do
            plate = plate .. string.char(math.random(48, 57))
        end
    until not MySQL.single.await("SELECT 1 FROM `ava_vehicles` WHERE `plate` = :plate", { plate = plate })
    return plate
end
exports("GenerateValidPlate", GenerateValidPlate)

---Add a vehicle to a player character
---@param citizenId number player citizen id
---@param vehicleType string vehicle type
---@param vehicleModel string vehicle name
---@param label string vehicle label
---@param plate string vehicle plate
---@param modsData string mods data as json
local AddPlayerVehicle = function(citizenId, vehicleType, vehicleModel, label, plate, modsData)
    return MySQL.insert.await("INSERT INTO `ava_vehicles` (`ownertype`, `citizenid`, `vehicletype`, `model`, `label`, `plate`, `modsdata`, `healthdata`) VALUES (0, :citizenid, :vehicletype, :model, :label, :plate, :modsdata, '{}')", {
        citizenid = citizenId,
        vehicletype = vehicleType,
        model = vehicleModel,
        label = label,
        plate = plate,
        modsdata = modsData,
    })
end

exports("AddPlayerVehicle", AddPlayerVehicle)
---Add a vehicle to a job
---@param jobName string job name
---@param vehicleType string vehicle type
---@param vehicleModel string vehicle name
---@param label string vehicle label
---@param plate string vehicle plate
---@param modsData string mods data as json
local AddJobVehicle = function(jobName, vehicleType, vehicleModel, label, plate, modsData)
    return MySQL.insert.await("INSERT INTO `ava_vehicles` (`ownertype`, `job_name`, `vehicletype`, `model`, `label`, `plate`, `modsdata`, `healthdata`, `garage`) VALUES (1, :job_name, :vehicletype, :model, :label, :plate, :modsdata, '{}', :garage)", {
        job_name = jobName,
        vehicletype = vehicleType,
        model = vehicleModel,
        label = label,
        plate = plate,
        modsdata = modsData,
        garage = "jobgarage_" .. jobName,
    })
end
exports("AddJobVehicle", AddJobVehicle)

---Remove a vehicle from the database
---@param vehicleId number vehicle id
---@param aPlayer aPlayer player who is removing the vehicle
local RemoveVehicle = function(vehicleId, aPlayer)
    -- Log informations to discord
    local vehicleData = MySQL.single.await("SELECT COALESCE(`citizenid`, `job_name`) AS `owner`, `label`, `model`, `plate`, `modsdata`, `vehicletype` FROM `ava_vehicles` WHERE `id` = :id", { id = vehicleId })
    if vehicleData then
        exports.ava_core:SendWebhookEmbedMessage("avan0x_wh_rp_actions", GetString("log_remove_vehicle_title", aPlayer and (aPlayer.citizenId .. " " .. aPlayer.getDiscordTag()) or "console"),
            GetString("log_remove_vehicle_description", vehicleData.label, vehicleData.owner, vehicleData.plate, vehicleData.model, vehicleData.vehicletype, vehicleData.modsdata), 0x007acc)
    end

    MySQL.update.await("DELETE FROM `ava_vehicles` WHERE `id` = :id", { id = vehicleId })
end
exports("RemoveVehicle", RemoveVehicle)


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
        MySQL.update.await("UPDATE `ava_vehicles` SET `label` = :label WHERE `id` = :id", { id = vehicleId, label = label })
        return true
    end
    return false
end)
-- #endregion rename vehicle

-- #region take out vehicle
---Setup the vehicle to be taken out, set data and id
---@param src any
---@param vehicle any
---@param vehicleId any
local SetupSpawnedVehicle = function(src, vehicleNet, vehicle, vehicleId)
    local entityState = Entity(vehicle)
    entityState.state:set("id", vehicleId, false)
    -- TODO Maybe save the entity net idea to an array, listen to entityRemoved event and remove it from the array, used to see if the vehicle should be able to be spawned again?

    local vehicleData = MySQL.single.await("SELECT `modsdata`, `healthdata` FROM `ava_vehicles` WHERE `id` = :id", { id = vehicleId })
    if vehicleData then
        TriggerClientEvent("ava_garages:client:setVehicleData", src, vehicleNet, vehicleData.modsdata, vehicleData.healthdata)
    end
end
exports("SetupSpawnedVehicle", SetupSpawnedVehicle)

RegisterNetEvent("ava_garages:server:spawnedVehicle", function(vehicleNet, vehicleId, IsCommonGarage, garageName)
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
    local allowed, vehicleData = IsAllowedToInteractWithVehicle(vehicleId, aPlayer, false, IsCommonGarage, garageName)
    -- We only do actions if the player is allowed to interact with the vehicle and the vehicle is not already spawned
    if not allowed or not vehicleData.parked then
        -- We delete the entity in case of error
        DeleteEntity(vehicle)
        return
    end

    SetupSpawnedVehicle(src, vehicleNet, vehicle, vehicleId)
    if vehicleData.ownertype == 1 then
        GivePlayerVehicleKeyIfLower(src, aPlayer.citizenId, vehicleId, 1)
    else
        GivePlayerVehicleKeyIfLower(src, aPlayer.citizenId, vehicleId, 2)
    end

    MySQL.update("UPDATE `ava_vehicles` SET `parked` = :parked WHERE `id` = :id", { id = vehicleId, parked = false })
    TriggerEvent("ava_logs:server:log", { "citizenid:" .. aPlayer.citizenId, "spawn_vehicle", "vehicleid:" .. vehicleId })
end)
-- #endregion take out vehicle

-- #region park vehicle
RegisterNetEvent("ava_garages:server:parkVehicle", function(garageName, vehicleNet, healthData, IsJobGarage, IsCommonGarage)
    local src = source
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNet)
    if not DoesEntityExist(vehicle) then return end

    local aPlayer = exports.ava_core:GetPlayer(src)
    if not aPlayer then return false end

    local entityState = Entity(vehicle)
    local vehicleId = entityState.state.id
    if not vehicleId then
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("garage_park_cant_park_this_vehicle"))
        return
    end

    local allowed, vehicleData = IsAllowedToInteractWithVehicle(vehicleId, aPlayer, false, IsCommonGarage, garageName)
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
        MySQL.update("UPDATE `ava_vehicles` SET `parked` = :parked, `garage` = :garage, `healthdata` = :healthdata WHERE `id` = :id",
            { id = vehicleId, garage = garageName, parked = true, healthdata = healthData })
        TriggerEvent("ava_logs:server:log", { "citizenid:" .. aPlayer.citizenId, "park_vehicle", "vehicleid:" .. vehicleId })

        for i = -1, 6 do
            local ped = GetPedInVehicleSeat(vehicle, i)
            if ped > 0 then
                TaskLeaveVehicle(ped, vehicle, 1)
            end
        end
        Wait(1500)

        DeleteEntity(vehicle)
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("garage_park_vehicle_parked"))
    else
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("garage_park_cant_park_this_vehicle"))
    end
end)
-- #endregion park vehicle



exports.ava_core:RegisterCommand("savevehicledata", "admin", function(source, args)
    if source > 0 then
        TriggerClientEvent("ava_garages:client:savevehicledata", source)
    end
end, GetString("savevehicledata_help"))

RegisterNetEvent("ava_garages:server:savevehicledata", function(vehicleNet, modsData, healthData)
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNet)
    if not DoesEntityExist(vehicle) then
        return
    end
    local entityState = Entity(vehicle)
    local vehicleId = entityState.state.id
    if vehicleId then
        MySQL.update("UPDATE `ava_vehicles` SET `modsdata` = :modsdata, `healthdata` = :healthdata WHERE `id` = :id",
            { id = vehicleId, modsdata = modsData, healthdata = healthData })
    end
end)
