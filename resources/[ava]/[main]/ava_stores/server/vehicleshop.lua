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
            VehicleStock[model] = {quantity = quantity}
            lightStockArray[model] = quantity
        end
    end
    print(print(json.encode(VehicleStock, {indent = true})))
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
        VehicleStock[model] = {quantity = quantity, new = true}
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
            MySQL.query("INSERT INTO ava_vehicleshop (`model`, `quantity`) VALUES (@model, @quantity)", {["@model"] = model, ["@quantity"] = data.quantity})
            VehicleStock[model].new = nil
            VehicleStock[model].modified = nil
        elseif data.modified then
            MySQL.query("UPDATE ava_vehicleshop SET `quantity` = @quantity WHERE `model` = @model", {["@model"] = model, ["@quantity"] = data.quantity})
            VehicleStock[model].modified = nil
        end
    end
end)

exports.ava_core:RegisterServerCallback("ava_stores:server:vehicleshop:getStock", function(source)
    return lightStockArray
end)

-- vehicleType, vehicleName -- TODO check that vehicle is not hidden
-- vehicleType, vehicleName, jobName
