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
local function GetVehicleModelStock(model, vehicleType)
    if VehicleStock[model] then
        return VehicleStock[model].quantity
    end
    -- Get default value, the one from the vehicle if it has one
    if Config.VehicleShops.Vehicles.vehiclestypes[vehicleType]?[model]?.quantity then
        return Config.VehicleShops.Vehicles.vehiclestypes[vehicleType][model].quantity
    end
    -- or the main default value
    return Config.VehicleShops.DefaultStockValue
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
    print("^2[SAVE VEHICLESHOP STOCKS]^0 Saving vehicle shop stock quantities.")
    for model, data in pairs(VehicleStock) do
        if data.new then
            MySQL.query("INSERT INTO ava_vehicleshop (`model`, `quantity`) VALUES (:model, :quantity)", { model = model, quantity = data.quantity })
            VehicleStock[model].new = nil
            VehicleStock[model].modified = nil
        elseif data.modified then
            MySQL.query("UPDATE ava_vehicleshop SET `quantity` = :quantity WHERE `model` = :model", { model = model, quantity = data.quantity })
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
        -- Check if vehicle model exist in vehicle type
        or not Config.VehicleShops.Vehicles.vehiclestypes[vehicleType]?[vehicleModel]
        or (-- Check if the purchase is a job purchase, and if the player is allowed to buy it
            jobName and not (IsPlayerAceAllowed(src, "job." .. jobName .. ".manage")
            -- Check if the vehicle model is buyable by the job
            and Config.VehicleShops.Vehicles.jobs[jobName]?[vehicleModel])
        ) then
        return false
    end
    -- Check if vehicle is not hidden or if the purchase is a hidden purchase
    local vehicleData<const> = Config.VehicleShops.Vehicles.vehiclestypes[vehicleType][vehicleModel]
    if vehicleData.hidden and not jobName then return false end

    -- Check if the vehicle is in stock
    local quantity = GetVehicleModelStock(vehicleModel, vehicleType)
    if quantity <= 0 then
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("vehicleshop_outofstock"), nil, "CHAR_SIMEON", "Simeon Yetarian")
        return false
    end
    -- Remove the vehicle from stock while processing the purchase to avoid multiple people buying the same vehicle
    SetVehicleModelStock(vehicleModel, quantity - 1)

    local aPlayer = exports.ava_core:GetPlayer(src)
    if not aPlayer then 
        -- Restore the vehicle stock
        SetVehicleModelStock(vehicleModel, quantity)
        return false 
    end

    -- Check if the player do not have already enough vehicles
    if not jobName and Config.VehicleShops.MaxVehiclePerPlayer then 
        local vehicleCount = MySQL.scalar.await("SELECT COUNT(*) AS `count` FROM ava_vehicles WHERE `citizenid` = :citizenid", { citizenid = aPlayer.citizenId })
        if vehicleCount >= Config.VehicleShops.MaxVehiclePerPlayer then
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("vehicleshop_cannot_have_more_vehicles", Config.VehicleShops.MaxVehiclePerPlayer), 
                nil, "CHAR_SIMEON", "Simeon Yetarian")

            -- Restore the vehicle stock
            SetVehicleModelStock(vehicleModel, quantity)
            return false 
        end
    end


    local inventory = aPlayer.getInventory()
    if not inventory.canRemoveItem("cash", vehicleData.price) then
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("cant_afford_amount", exports.ava_core:FormatNumber(vehicleData.price)), 
            nil, "CHAR_SIMEON", "Simeon Yetarian")
        
        -- Restore the vehicle stock
        SetVehicleModelStock(vehicleModel, quantity)
        return false
    end

    inventory.removeItem("cash", vehicleData.price)
    TriggerEvent("ava_logs:server:log", {"citizenid:" .. aPlayer.citizenId, "purchase", "vehiclemodel:" .. vehicleModel, "for", vehicleData.price})

    -- Prevent player from purchasing multiple vehicles at the same time
    while playerPurchasingVehicle[tostring(src)] do
        print("^2[AVA_STORES]^0Player " .. GetPlayerName(src) .. " is trying to purchase a vehicle while already purchasing one, waiting for last purchase to end.")
        Wait(500)
    end
    playerPurchasingVehicle[tostring(src)] = { vehicleModel = vehicleModel, vehicleType = vehicleType, citizenId = aPlayer.citizenId, jobName = jobName }
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
        exports.ava_garages:GivePlayerVehicleKey(src, purchaseData.citizenId, vehicleId, 1)
    else
        -- Player purchase
        vehicleId = exports.ava_garages:AddPlayerVehicle(purchaseData.citizenId, purchaseData.vehicleType, purchaseData.vehicleModel, label:sub(0, 50), plate, json.encode(modsData))
        exports.ava_garages:GivePlayerVehicleKey(src, purchaseData.citizenId, vehicleId, 0)
    end

    playerPurchasingVehicle[tostring(src)] = nil
    exports.ava_garages:SetupSpawnedVehicle(src, vehicleNet, NetworkGetEntityFromNetworkId(vehicleNet), vehicleId)
end)

---Event to sell a vehicle
---@param source integer
---@param vehicleType string vehicle type
---@param vehicleNet integer network id of the vehicle
---@return integer 0 : "failed, 1 : success, 2 : do nothing in client"
exports.ava_core:RegisterServerCallback("ava_stores:server:vehicleshop:sellVehicle", function(source, vehicleType, vehicleNet)
    local src = source
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNet)
    if not DoesEntityExist(vehicle) then return 0 end

    local aPlayer = exports.ava_core:GetPlayer(src)
    if not aPlayer then return 0 end

    local entityState = Entity(vehicle)
    local vehicleId = entityState.state.id
    if not vehicleId then return 0 end

    local vehiclePrice, vehicleModel = GetVehiclePriceFromModel(vehicleType, GetEntityModel(vehicle))
    if not vehiclePrice then return 0 end
    local sellPrice = math.floor((vehiclePrice * Config.VehicleShops.SellMultiplier) + 0.5)

    local allowed, vehicleData = exports.ava_garages:IsAllowedToInteractWithVehicle(vehicleId, aPlayer, true)
    if not allowed then return 0 end

    local inventory = aPlayer.getInventory()
    if not inventory.canAddItem("cash", sellPrice) then
        TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("vehicleshop_cannot_obtain_money", sellPrice), nil, "CHAR_SIMEON", "Simeon Yetarian")
        return 2
    end
    inventory.addItem("cash", sellPrice)
    SetVehicleModelStock(vehicleModel, GetVehicleModelStock(vehicleModel, tostring(vehicleType)) + 1)
    TriggerEvent("ava_logs:server:log", {"citizenid:" .. aPlayer.citizenId, "sell", "vehiclemodel:" .. vehicleModel, "vehicleid:" .. vehicleId, "at", sellPrice})

    exports.ava_garages:RemoveKeysForVehicle(vehicleId)
    exports.ava_garages:RemoveVehicle(vehicleId, aPlayer)

    Citizen.CreateThread(function()
        for i = -1, 6 do
            local ped = GetPedInVehicleSeat(vehicle, i)
            if ped > 0 then
                TaskLeaveVehicle(ped, vehicle, 1)
            end
        end
        Wait(1000)
        DeleteEntity(vehicle)
    end)
    return 1
end)
