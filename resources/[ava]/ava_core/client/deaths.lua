-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
---------- Inspired by baseevents ---------
-------------------------------------------
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
    local isDead = false

    while true do
        Wait(0)

        local player = PlayerId()

        if NetworkIsPlayerActive(player) then
            local playerPed = PlayerPedId()
            local pedFatallyInjured<const> = IsPedFatallyInjured(playerPed)

            if pedFatallyInjured and not isDead then
                isDead = true
                local data = {}
                local deathCoords = GetEntityCoords(playerPed)

                local killerPed, killerWeapon = NetworkGetEntityKillerOfPlayer(player)
                local killerId = NetworkGetPlayerIndexFromPed(killerPed)

                killerId = (killerPed ~= playerPed and killerId ~= nil and NetworkIsPlayerActive(killerId)) and GetPlayerServerId(killerId) or -1

                if killerPed == playerPed or killerPed == -1 or killerId == -1 then
                    data = {killedByPlayer = false, coords = deathCoords, cause = GetPedCauseOfDeath(playerPed)}
                else
                    local killerCoords = GetEntityCoords(killerPed)

                    local killerInVeh = false
                    local killerVehModel, killerVehSeat
                    if GetEntityType(killerPed) == 1 then -- killer is a ped
                        local killerVehicle = GetVehiclePedIsUsing(killerPed)
                        if killerVehicle ~= 0 then
                            killerInVeh = true
                            killerVehModel = GetEntityModel(GetVehiclePedIsUsing(killerPed))
                            killerVehSeat = GetPedVehicleSeat(killerPed, killerVehicle)
                        else
                            killerInVeh = false
                        end
                    end

                    data = {
                        killedByPlayer = true,
                        coords = deathCoords,
                        weapon = killerWeapon,
                        killerCoords = killerCoords,
                        killerId = killerId,
                        killerInVeh = killerInVeh,
                        killerVehModel = killerVehModel,
                        killerVehSeat = killerVehSeat,
                    }

                end

                TriggerEvent("ava_core:client:playerDeath", data)
                TriggerServerEvent("ava_core:server:playerDeath", data)

            elseif not pedFatallyInjured and isDead then
                isDead = false
            end
        end
    end
end)

