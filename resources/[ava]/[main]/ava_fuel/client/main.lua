-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

local inLoop = false
local playerVehicle = 0

local IsVehicleElectric = function(vehicle)
    return not not AVAConfig.ElectricCars[GetEntityModel(vehicle)]
end
exports("IsVehicleElectric", IsVehicleElectric)

local function createVehicleFuelStateBag(vehicle, vehState)
    TriggerServerEvent('ava_fuel:server:setStateBag', VehToNet(vehicle), GetVehicleFuelLevel(vehicle))
    -- We can check "not" because lua do not consider 0 as false
    while not vehState.fuel do Wait(0) end
end

local function SetVehicleFuelInternal(vehicle, vehState, fuel, replicate)
    SetVehicleFuelLevel(vehicle, fuel)
    vehState:set('fuel', fuel, replicate)
end

---Get vehicle fuel, there is not point in using this
---@param vehicle entity
---@return number
local GetVehicleFuel = function(vehicle)
    return GetVehicleFuelLevel(vehicle)
end
exports("GetVehicleFuel", GetVehicleFuel)

---Get vehicle fuel, there is not point in using this
---@param vehicle entity
---@return number
local GetVehicleTankSize = function(vehicle)
    return GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fPetrolTankVolume') or 60.0
end
exports("GetVehicleTankSize", GetVehicleTankSize)

local SetVehicleFuel = function(vehicle, fuel)
    if GetEntityType(vehicle) ~= 2 then return end

    local vehState <const> = Entity(vehicle).state
    if not vehState.fuel then
        createVehicleFuelStateBag(vehicle, vehState)
    end
    SetVehicleFuelInternal(vehicle, vehState, fuel + 0.0, true)
end
exports("SetVehicleFuel", SetVehicleFuel)

local function Loop(vehicle)
    -- No need to go further
    if playerVehicle == vehicle then return end

    -- Set current vehicle
    playerVehicle = vehicle

    -- New vehicle is not a vehicle
    if playerVehicle == 0 then return end

    -- Vehicle has no fuel
    if GetVehicleTankSize(vehicle) <= 0.0 then return end

    local classUsage <const> = AVAConfig.ClassUsage[GetVehicleClass(vehicle)] or 1.0

    -- No need to handle fuel if class usage is 0
    if classUsage <= 0.0 then return end

    local multiplier <const> = (classUsage * (IsVehicleElectric(vehicle) and AVAConfig.ElectricMultiplier or 1.0)) * 0.05 * AVAConfig.GlobalMultiplier

    local vehState <const> = Entity(vehicle).state

    -- Create state bag if not exists
    if not vehState.fuel then
        createVehicleFuelStateBag(vehicle, vehState)
    end

    Citizen.CreateThread(function()
        -- Replicate counter, goes from 0 to AVAConfig.ReplicateDelay, if at 0, it'll replicate the fuel value to the server
        local replicateCounter = 0

        while playerVehicle == vehicle do
            if GetIsVehicleEngineRunning(vehicle) then -- Engine is not running if fuel is 0
                local rpm <const> = GetVehicleCurrentRpm(vehicle)
                local newFuel <const> = vehState.fuel - (multiplier * (rpm * rpm + rpm * 0.8))
                print(("fuel: %.3f (removed %.3f)"):format(vehState.fuel, (multiplier * (rpm * rpm + rpm * 0.8))))

                if newFuel >= 0 then
                    replicateCounter = (replicateCounter + 1) % AVAConfig.ReplicateDelay

                    -- Only replicate if replicateCounter == 0
                    SetVehicleFuelInternal(vehicle, vehState, newFuel, replicateCounter == 0)
                end
            end
            Wait(1000)
        end

        -- Loop ended, be sure to replicate the fuel
        if DoesEntityExist(vehicle) then
            SetVehicleFuelInternal(vehicle, vehState, vehState.fuel, true)
        end
    end)
end

Citizen.CreateThread(function()
    local isInVehicle, vehicle, seat = exports.ava_core:IsPlayerInVehicle()
    if isInVehicle and seat == -1 then
        Loop(vehicle)
    end
end)

AddEventHandler("ava_core:client:enteredDriverSeat", function(vehicle)
    Loop(vehicle)
end)
AddEventHandler("ava_core:client:leftDriverSeat", function(vehicle)
    Loop(0)
end)
