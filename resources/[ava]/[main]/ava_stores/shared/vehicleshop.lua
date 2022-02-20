-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

---Get vehicle price from model hash
---@param vehicleType int|string vehicle type
---@param model number vehicle model hash
---@return number|nil vehicle price 
---@return string|nil vehicle name
function GetVehiclePriceFromModel(vehicleType, model)
    if Config.VehicleShops.Vehicles.vehiclestypes[tostring(vehicleType)] then
        for vehicleName, vehicleData in pairs(Config.VehicleShops.Vehicles.vehiclestypes[tostring(vehicleType)]) do
            if GetHashKey(vehicleName) == model then
                return vehicleData.price, vehicleName
            end
        end
    end
    return nil
end
