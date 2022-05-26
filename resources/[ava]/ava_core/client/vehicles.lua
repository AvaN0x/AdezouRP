-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
---@type boolean
AVA.Player.isEnteringVehicle = false
---@type entity vehicle
AVA.Player.currentEnteringVehicle = 0
---@type boolean
AVA.Player.isInVehicle = false
---@type entity vehicle
AVA.Player.currentVehicle = 0
---@type integer
AVA.Player.currentSeat = 0

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
        local vehicle = GetVehiclePedIsUsing(AVA.Player.playerPed, false)
        -- check if player is not in a vehicle, or if the vehicle the player is using is different from the last one
        if (not AVA.Player.isInVehicle or vehicle ~= AVA.Player.currentVehicle) and not AVA.Player.IsDead and vehicle ~= 0 then
            if vehicle == GetVehiclePedIsIn(AVA.Player.playerPed) then
                AVA.Player.isEnteringVehicle = false
                AVA.Player.currentEnteringVehicle = 0
                AVA.Player.isInVehicle = true

                if AVA.Player.currentVehicle ~= 0 then
                    -- TriggerServerEvent("ava_core:server:leftVehicle", VehToNet(AVA.Player.currentVehicle), AVA.Player.currentSeat)
                    TriggerEvent("ava_core:client:leftVehicle", AVA.Player.currentVehicle, AVA.Player.currentSeat)
                    dprint("ava_core:client:leftVehicle", AVA.Player.currentVehicle, AVA.Player.currentSeat)
                end

                AVA.Player.currentVehicle = vehicle
                AVA.Player.currentSeat = GetPedVehicleSeat(AVA.Player.playerPed, AVA.Player.currentVehicle)

                -- TriggerServerEvent("ava_core:server:enteredVehicle", VehToNet(AVA.Player.currentVehicle), AVA.Player.currentSeat)
                TriggerEvent("ava_core:client:enteredVehicle", AVA.Player.currentVehicle, AVA.Player.currentSeat)
                dprint("ava_core:client:enteredVehicle", AVA.Player.currentVehicle, AVA.Player.currentSeat)

            elseif AVA.Player.currentEnteringVehicle ~= vehicle then
                AVA.Player.isEnteringVehicle = true
                AVA.Player.currentEnteringVehicle = vehicle
                local seat = GetSeatPedIsTryingToEnter(AVA.Player.playerPed)

                -- TriggerServerEvent("ava_core:server:enteredVehicle", VehToNet(AVA.Player.currentEnteringVehicle), AVA.Player.currentSeat)
                TriggerEvent("ava_core:client:enteringVehicle", AVA.Player.currentEnteringVehicle, seat)
                dprint("ava_core:client:enteringVehicle", AVA.Player.currentEnteringVehicle, seat)
            end

        elseif AVA.Player.isEnteringVehicle and (vehicle == 0 or AVA.Player.IsDead) then
            -- TriggerServerEvent("ava_core:server:quitEnteringVehicle", VehToNet(AVA.Player.currentEnteringVehicle))
            TriggerEvent("ava_core:client:quitEnteringVehicle", AVA.Player.currentEnteringVehicle)
            dprint("ava_core:client:quitEnteringVehicle", AVA.Player.currentEnteringVehicle)

            AVA.Player.isEnteringVehicle = false
            AVA.Player.currentEnteringVehicle = 0
        elseif AVA.Player.isInVehicle and (vehicle == 0 or AVA.Player.IsDead) then
            -- TriggerServerEvent("ava_core:server:leftVehicle", VehToNet(AVA.Player.currentVehicle), AVA.Player.currentSeat)
            TriggerEvent("ava_core:client:leftVehicle", AVA.Player.currentVehicle, AVA.Player.currentSeat)
            dprint("ava_core:client:leftVehicle", AVA.Player.currentVehicle, AVA.Player.currentSeat)

            AVA.Player.isInVehicle = false
            AVA.Player.currentVehicle = 0
            AVA.Player.currentSeat = 0
        end
        Wait(50)
    end
end)

---Check if player is in a vehicle
---@return boolean "is in a vehicle"
---@return entity "current vehicle"
---@return integer "current seat"
AVA.Player.IsPlayerInVehicle = function()
    return AVA.Player.isInVehicle, AVA.Player.currentVehicle, AVA.Player.currentSeat
end
exports("IsPlayerInVehicle", AVA.Player.IsPlayerInVehicle)
