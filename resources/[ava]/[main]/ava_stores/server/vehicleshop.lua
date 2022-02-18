-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local VehicleStock = {}
local lightStockArray = {}

Citizen.CreateThread(function()
    local res = MySQL.query.await("SELECT `model`, `quantity` FROM ava_vehicleshop", {})
    if res then
        for i = 1, #res do
            local model = res[i].model
            local quantity = res[i].quantity
            VehicleStock[model] = { quantity = quantity }
            lightStockArray[model] = quantity
        end
    end
end)

---Get vehicle stock quantity
---@param model string
---@return quantity
local function GetVehicleModelStock(model)
    return VehicleStock[model] and VehicleStock[model].quantity or Config.VehicleShops.DefaultStockValue
end

---Set vehicle stock quantity, this assume that the model is valid !
---@param model string
---@return quantity
local function SetVehicleModelStock(model, quantity)
    if not VehicleStock[model] then
        VehicleStock[model] = { quantity = quantity, new = true }
    else
        VehicleStock[model].quantity = quantity
        VehicleStock[model].modified = true
    end
    lightStockArray[model] = quantity
end

AddEventHandler("ava_core:server:saveAll", function()
    print("^2[SAVE VEHICLESHOP STOCKS]^0Saving vehicle shop stock quantities.")
    for model, data in pairs(VehicleStock) do
        if data.new then
            MySQL.query("INSERT INTO ava_vehicleshop (`model`, `quantity`) VALUES (@model, @quantity)", { ["@model"] = model, ["@quantity"] = data.quantity })
            VehicleStock[model].new = nil
            VehicleStock[model].modified = nil
        elseif data.modified then
            MySQL.query("UPDATE ava_vehicleshop SET `quantity` = @quantity WHERE `model` = @model", { ["@model"] = model, ["@quantity"] = data.quantity })
            VehicleStock[model].modified = nil
        end
    end
end)

exports.ava_core:RegisterServerCallback("ava_stores:server:vehicleshop:getStock", function(source)
    return lightStockArray
end)

local playerPurchasingVehicle = {}
exports.ava_core:RegisterServerCallback("ava_stores:server:vehicleshop:purchaseVehicle", function(source, vehicleType, vehicleModel, jobName)
    local src = source
    -- Check args validity    
    if not vehicleType or not vehicleModel
        -- Check if vehicle type exist
        or not Config.VehicleShops.Vehicles.vehiclestypes[vehicleType]
        -- Check if vehicle model exist in vehicle type
        or not Config.VehicleShops.Vehicles.vehiclestypes[vehicleType][vehicleModel]
        or (-- Check if the purchase is a job purchase, and if the player is allowed to buy it
        jobName and not (IsPlayerAceAllowed(src, "job." .. jobName .. ".manage")
            -- Check if the job as buyable vehicles
            and Config.VehicleShops.Vehicles.jobs[jobName]
            -- Check if the vehicle model is buyable by the job
            and Config.VehicleShops.Vehicles.jobs[jobName][vehicleModel])
        ) then
        return false
    end
    -- Check if vehicle is not hidden or if the purchase is a hidden purchase
    local vehicleData<const> = Config.VehicleShops.Vehicles.vehiclestypes[vehicleType][vehicleModel]
    if vehicleData.hidden and not jobName then return false end

    -- Check if the vehicle is in stock
    local quantity = GetVehicleModelStock(vehicleModel)
    if quantity <= 0 then
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("vehicleshop_outofstock"))
        return false
    end
    -- Remove the vehicle from stock while processing the purchase to avoid multiple people buying the same vehicle
    SetVehicleModelStock(vehicleModel, quantity - 1)

    -- Check if the player has enough money
    local aPlayer = exports.ava_core:GetPlayer(src)
    if not aPlayer then return end

    local inventory = aPlayer.getInventory()
    if not inventory.canRemoveItem("cash", vehicleData.price) then
        -- Restore the vehicle stock
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("cant_afford_amount", exports.ava_core:FormatNumber(vehicleData.price)))
        SetVehicleModelStock(vehicleModel, quantity)
        return false
    end

    inventory.removeItem("cash", vehicleData.price)

    -- Prevent player from purchasing multiple vehicles at the same time
    while playerPurchasingVehicle[tostring(src)] do
        print("waiting to be able to buy another vehicle") -- FIXME REMOVETHIS
        Wait(500)
    end
    playerPurchasingVehicle[tostring(src)] = { vehicleModel = vehicleModel, vehicleType = vehicleType, citizenId = aPlayer.citizenId, jobName = jobName }

    -- print(exports.ava_garages:GenerateValidPlate())
    -- exports.ava_garages:SetupSpawnedVehicle(src, vehicle, vehicleId)

    print("user can buy vehicle", jobName or "self", vehicleType, vehicleModel)
    return true
end)

RegisterNetEvent("ava_stores:server:vehicleshop:purchasedVehicle", function(vehicleNet, label, modsData)
    local src = source
    if not playerPurchasingVehicle[tostring(src)] then return end
    -- #region wait for entity to exist or abort
    -- Prevent infinite loop
    local waitForEntityToExistCount = 0
    while waitForEntityToExistCount <= 100 and not DoesEntityExist(NetworkGetEntityFromNetworkId(vehicleNet)) do
        Wait(10)
        waitForEntityToExistCount = waitForEntityToExistCount + 1
    end
    if waitForEntityToExistCount > 100 then
        playerPurchasingVehicle[tostring(src)] = nil
        print("^1[AVA_STORES]^0Vehicle purchase failed, entity does not exist.")
        return
    end
    -- #endregion wait for entity to exist or abort

    local purchaseData<const> = playerPurchasingVehicle[tostring(src)]

    if GetEntityModel(NetworkGetEntityFromNetworkId(vehicleNet)) ~= GetHashKey(purchaseData.vehicleModel) then
        playerPurchasingVehicle[tostring(src)] = nil
        print("^1[AVA_STORES]^0Vehicle purchase failed, model mismatch.")
        return
    end

    -- Generate plate and set it to modsData
    local plate<const> = exports.ava_garages:GenerateValidPlate()
    modsData = type(modsData) == "string" and json.decode(modsData) or modsData
    modsData.plate = plate

    local vehicleId
    if purchaseData.jobName then
        -- Job purchase
        vehicleId = exports.ava_garages:AddJobVehicle(purchaseData.jobName, purchaseData.vehicleType, purchaseData.vehicleModel, label:sub(0, 50), plate, json.encode(modsData))
    else
        -- Player purchase
        vehicleId = exports.ava_garages:AddPlayerVehicle(purchaseData.citizenId, purchaseData.vehicleType, purchaseData.vehicleModel, label:sub(0, 50), plate, json.encode(modsData))
    end

    playerPurchasingVehicle[tostring(src)] = nil
    exports.ava_garages:SetupSpawnedVehicle(src, vehicleNet, NetworkGetEntityFromNetworkId(vehicleNet), vehicleId)
end)
