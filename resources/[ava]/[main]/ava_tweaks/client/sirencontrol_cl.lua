-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local playerVehicle, state = 0, false

Citizen.CreateThread(function()
    local isInVehicle, vehicle, seat = exports.ava_core:IsPlayerInVehicle()
    if isInVehicle and seat == -1 and GetVehicleClass(vehicle) == 18 then
        playerVehicle = vehicle
        state = false
    end
end)
AddEventHandler("ava_core:client:enteredVehicle", function(vehicle, seat)
    if seat == -1 and GetVehicleClass(vehicle) == 18 then
        playerVehicle = vehicle
        state = false
    end
end)
AddEventHandler("ava_core:client:leftVehicle", function(vehicle)
    playerVehicle = 0
    state = false
end)

RegisterCommand("mutesiren", function(source)
    if playerVehicle then
        state = not state
        TriggerServerEvent("ava_tweaks:server:sirencontrol:sync", VehToNet(playerVehicle), state)
    end
end)
RegisterKeyMapping("mutesiren", GetString("mutesiren"), "keyboard", "G")

-- Server side sync
RegisterNetEvent("ava_tweaks:client:sirencontrol:sync", function(vehNet, value)
    if vehNet ~= 0 and NetToVeh(vehNet) ~= 0 then
        SetVehicleHasMutedSirens(NetToVeh(vehNet), not not value)
    end
end)
