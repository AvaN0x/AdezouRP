-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
---@type boolean
local isEnteringVehicle = false
---@type entity vehicle
local currentEnteringVehicle = 0
---@type boolean
local isInVehicle = false
---@type entity vehicle
local currentVehicle = 0
---@type integer
local currentSeat = 0

---Get player seat index
---@param ped entity
---@param vehicle entity
---@return integer
local function GetPedVehicleSeat(ped, vehicle)
    for i = -2, GetVehicleMaxNumberOfPassengers(vehicle) do
        if GetPedInVehicleSeat(vehicle, i) == ped then
            return i
        end
    end
    return -2
end

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()

        local vehicle = GetVehiclePedIsUsing(playerPed, false)
        -- check if player is not in a vehicle, or if the vehicle the player is using is different from the last one
        if (not isInVehicle or vehicle ~= currentVehicle) and not AVA.Player.IsDead and vehicle ~= 0 then
            if vehicle == GetVehiclePedIsIn(playerPed) then
                isEnteringVehicle = false
                currentEnteringVehicle = 0
                isInVehicle = true

                if currentVehicle ~= 0 then
                    -- TriggerServerEvent("ava_core:server:leftVehicle", VehToNet(currentVehicle), currentSeat)
                    TriggerEvent("ava_core:client:leftVehicle", currentVehicle, currentSeat)
                    dprint("ava_core:client:leftVehicle", currentVehicle, currentSeat)
                end

                currentVehicle = vehicle
                currentSeat = GetPedVehicleSeat(playerPed, currentVehicle)

                -- TriggerServerEvent("ava_core:server:enteredVehicle", VehToNet(currentVehicle), currentSeat)
                TriggerEvent("ava_core:client:enteredVehicle", currentVehicle, currentSeat)
                dprint("ava_core:client:enteredVehicle", currentVehicle, currentSeat)

            elseif currentEnteringVehicle ~= vehicle then
                isEnteringVehicle = true
                currentEnteringVehicle = vehicle
                local seat = GetSeatPedIsTryingToEnter(playerPed)

                -- TriggerServerEvent("ava_core:server:enteredVehicle", VehToNet(currentEnteringVehicle), currentSeat)
                TriggerEvent("ava_core:client:enteringVehicle", currentEnteringVehicle, seat)
                dprint("ava_core:client:enteringVehicle", currentEnteringVehicle, seat)
            end

        elseif isEnteringVehicle and (vehicle == 0 or AVA.Player.IsDead) then
            -- TriggerServerEvent("ava_core:server:quitEnteringVehicle", VehToNet(currentEnteringVehicle))
            TriggerEvent("ava_core:client:quitEnteringVehicle", currentEnteringVehicle)
            dprint("ava_core:client:quitEnteringVehicle", currentEnteringVehicle)

            isEnteringVehicle = false
            currentEnteringVehicle = 0
        elseif isInVehicle and (vehicle == 0 or AVA.Player.IsDead) then
            -- TriggerServerEvent("ava_core:server:leftVehicle", VehToNet(currentVehicle), currentSeat)
            TriggerEvent("ava_core:client:leftVehicle", currentVehicle, currentSeat)
            dprint("ava_core:client:leftVehicle", currentVehicle, currentSeat)

            isInVehicle = false
            currentVehicle = 0
            currentSeat = 0
        end
        Wait(50)
    end
end)

---Check if player is in a vehicle
---@return boolean "is in a vehicle"
---@return entity "current vehicle"
---@return integer "current seat"
AVA.Player.IsInVehicle = function()
    return currentVehicle ~= 0, currentVehicle, currentSeat
end
exports("IsPlayerInVehicle", AVA.Player.IsInVehicle)
