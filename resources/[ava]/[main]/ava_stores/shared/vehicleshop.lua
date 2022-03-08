-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

---Get vehicle price from model hash
---@param model number vehicle model hash
---@param vehicleType? int|string vehicle type
---@return number|nil vehicle price 
---@return string|nil vehicle name
GetVehiclePriceFromModel = function(model, vehicleType)
    if vehicleType and Config.VehicleShops.Vehicles.vehiclestypes[tostring(vehicleType)] then
        for vehicleName, vehicleData in pairs(Config.VehicleShops.Vehicles.vehiclestypes[tostring(vehicleType)]) do
            if GetHashKey(vehicleName) == model then
                return vehicleData.price, vehicleName
            end
        end
    end
    if not vehicleType then
        for _, vehicles in pairs(Config.VehicleShops.Vehicles.vehiclestypes) do
            for vehicleName, vehicleData in pairs(vehicles) do
                if GetHashKey(vehicleName) == model then
                    return vehicleData.price, vehicleName
                end
            end
        end
    end
    return nil
end
exports("GetVehiclePriceFromModel", GetVehiclePriceFromModel)

---Get vehicle price from name
---@param name string vehicle name
---@param vehicleType? int|string vehicle type
---@return number|nil vehicle price 
GetVehiclePrice = function(name, vehicleType)
    if vehicleType and Config.VehicleShops.Vehicles.vehiclestypes[tostring(vehicleType)]
        and Config.VehicleShops.Vehicles.vehiclestypes[tostring(vehicleType)][name] then
        return Config.VehicleShops.Vehicles.vehiclestypes[tostring(vehicleType)][name].price
    end
    if not vehicleType then
        for _, vehicles in pairs(Config.VehicleShops.Vehicles.vehiclestypes) do
            if vehicles[name] then
                return vehicles[name].price
            end
        end
    end
    return nil
end
exports("GetVehiclePrice", GetVehiclePrice)
