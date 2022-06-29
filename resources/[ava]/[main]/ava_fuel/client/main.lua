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
    -- We can check "not  vehState.fuel" because lua do not consider 0 as false
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
    -- TODO this would require to check a lot of gta vehicles, some vehicles like the issi3 have 100.0 of petrolTankVolume while a lot of other have 65.0
    -- return GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fPetrolTankVolume') or 60.0
    return 65.0
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

    local multiplier <const> = (classUsage * (IsVehicleElectric(vehicle) and AVAConfig.ElectricMultiplier or 1.0)) * 0.02
        * AVAConfig.GlobalMultiplier

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
                local newFuel = vehState.fuel - (multiplier * (rpm * rpm + rpm * 0.8))
                if newFuel < 0 then newFuel = 0 end

                if newFuel ~= vehState.fuel then
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

RegisterNetEvent("ava_fuel:client:refuel", function(fuel)
    local isInVehicle, vehicle, seat = exports.ava_core:IsPlayerInVehicle()
    if not isInVehicle then return end

    SetVehicleFuel(vehicle, tonumber(fuel) or GetVehicleTankSize(vehicle))
end)

--#region Pumps
-- TODO better way of getting props
local IsDead = false
local pump = nil
local isFueling = false
Citizen.CreateThread(function()
    while true do
        Wait(1000)
        pump = getPump()
    end
end)

AddEventHandler("ava_core:client:playerIsDead", function(isDead)
    IsDead = isDead
end)

Citizen.CreateThread(function()
    while true do
        local wait = 1000
        if not IsDead and pump and not isFueling then
            wait = 0
            DrawText3D(pump.x, pump.y, pump.z, GetString("fuel_price", AVAConfig.LiterPrice))
            BeginTextCommandDisplayHelp("STRING")
            AddTextComponentSubstringPlayerName(GetString("press_to_fuel_vehicle"))
            EndTextCommandDisplayHelp(0, false, true, -1)

            if IsControlJustPressed(0, 38) then
                FuelVehicle()
            end
        end
        Wait(wait)
    end
end)

function getPump()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    for _, hash in ipairs(AVAConfig.GasPumps) do
        local closestProp = GetClosestObjectOfType(coords, 1.5, hash, false, false, false)

        if DoesEntityExist(closestProp) and GetEntityHealth(closestProp) > 0 then
            local markerCoords = GetOffsetFromEntityInWorldCoords(closestProp, 0.0, 0.0, 0.0)

            return { x = markerCoords.x, y = markerCoords.y, z = markerCoords.z + 0.9 }
        end
    end
    return nil
end

function FuelVehicle(isPetrolCan)
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed, true) then
        exports.ava_core:ShowNotification(GetString("pump_cant_inside_vehicle"))
        return
    end
    if GetIsVehicleEngineRunning(vehicle) then
        exports.ava_core:ShowNotification(GetString("pump_cant_with_engine_on"))
        return
    end

    local vehicle = exports.ava_core:GetVehicleInFrontOrChooseClosest()
    if vehicle == 0 then return end

    local tankSize <const> = GetVehicleTankSize(vehicle)
    local toRefuel = tankSize - GetVehicleFuel(vehicle)
    -- Check this a first time to avoid triggering a server event if we don't need to refuel
    if toRefuel <= AVAConfig.MinimumToRefuel then
        exports.ava_core:ShowNotification(GetString("pump_not_enough_to_refuel", AVAConfig.MinimumToRefuel))
        return
    end

    if not isPetrolCan then
        local fuelPlayerCanAfford <const> = exports.ava_core:TriggerServerCallback("ava_fuel:server:getFuelPlayerCanAfford")
        if toRefuel > fuelPlayerCanAfford then
            toRefuel = fuelPlayerCanAfford
        end

        -- Check this a second time
        if toRefuel <= AVAConfig.MinimumToRefuel then
            exports.ava_core:ShowNotification(GetString("pump_not_enough_to_refuel", AVAConfig.MinimumToRefuel))
            return
        end

    else

        if toRefuel > AVAConfig.PetrolCanCapacity then
            toRefuel = AVAConfig.PetrolCanCapacity
        end
    end


    -- Setup state if needed
    local vehState <const> = Entity(vehicle).state

    -- Create state bag if not exists
    if not vehState.fuel then
        createVehicleFuelStateBag(vehicle, vehState)
    end

    -- TODO do we need to get control of vehicle if somebody else is inside of it?

    isFueling = true
    -- Prevent vehicle from starting
    SetVehicleUndriveable(vehicle, true)

    print(("toRefuel: %.3f"):format(toRefuel))

    TaskTurnPedToFaceEntity(playerPed, vehicle, 1000)
    Wait(1000)

    -- Start anim
    local animDict, animName = "timetable@gardener@filling_can", "gar_ig_5_filling_can"
    if isPetrolCan then
        animDict, animName = "weapon@w_sp_jerrycan", "fire"
    end

    exports.ava_core:RequestAnimDict(animDict)
    TaskPlayAnim(playerPed, animDict, animName, 8.0, -8, -1, 1, 0, 0, 0, 0)
    RemoveAnimDict(animDict)

    local stopRefueling = false
    local currentlyRefueled = 0
    Citizen.CreateThread(function()
        -- Handle adding of fuel
        repeat
            Wait(100)
            currentlyRefueled += 0.1

            if currentlyRefueled > toRefuel then
                stopRefueling = true
            end
            SetVehicleFuelInternal(vehicle, vehState, vehState.fuel + 0.1, false)
        until stopRefueling or not isFueling
    end)

    Citizen.CreateThread(function()
        -- Handle player input and help text
        repeat
            Wait(0)

            BeginTextCommandDisplayHelp("STRING")
            if isPetrolCan then
                AddTextComponentSubstringPlayerName(GetString("fueling_vehicle"))
            else
                AddTextComponentSubstringPlayerName(GetString("pump_fueling_vehicle", currentlyRefueled,
                    AVAConfig.LiterPrice * currentlyRefueled))
            end
            EndTextCommandDisplayHelp(0, false, false, -1)

            if IsDisabledControlJustReleased(0, 202) -- cancel
                or IsControlPressed(0, 73) -- X
            then
                stopRefueling = true
            end
        until stopRefueling or not isFueling

        if isPetrolCan then
            TriggerServerEvent("ava_fuel:server:petrolcan:remove")

            -- Replicate the new fuel
            SetVehicleFuelInternal(vehicle, vehState, vehState.fuel, true)
        elseif exports.ava_core:TriggerServerCallback("ava_fuel:server:validateRefuel", currentlyRefueled) then
            -- Player paid the money

            -- Replicate the new fuel
            SetVehicleFuelInternal(vehicle, vehState, vehState.fuel, true)
        else
            -- Player did not pay the money

            -- Reset the fuel
            SetVehicleFuelInternal(vehicle, vehState, vehState.fuel - currentlyRefueled, false)
            exports.ava_core:ShowNotification(GetString("not_enough_money"))
        end

        -- Clear task
        ClearPedTasks(playerPed)

        -- Vehicle can now be driven
        SetVehicleUndriveable(vehicle, false)
        isFueling = false
    end)
end

AddEventHandler("ava_core:client:canOpenMenu", function()
    if isFueling then
        CancelEvent()
    end
end)

--#endregion Pumps


--#region petrol can
RegisterNetEvent("ava_fuel:client:usePetrolcan", function()
    FuelVehicle(true)
end)
--#endregion petrol can

function DrawText3D(x, y, z, text, size)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)

    if onScreen then
        SetTextScale(0.35, size or 0.35)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        SetTextOutline()

        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayText(_x, _y)
    end
end
