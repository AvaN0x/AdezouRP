-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
RegisterNetEvent("ava:client:spawnVehicle", function(vehName)
    local playerPed = PlayerPedId()
    local vehicle = AVA.Vehicles.SpawnVehicle(vehName, GetEntityCoords(playerPed), GetEntityHeading(playerPed))

    ClearPedTasksImmediately(playerPed)
    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
end)

RegisterNetEvent("ava:client:deleteVehicle", function()
    local playerPed = PlayerPedId()
    local vehicle = IsPedInAnyVehicle(playerPed, true) and GetVehiclePedIsIn(playerPed, false)
                        or AVA.Vehicles.GetVehicleInFront(5)

    if vehicle ~= 0 then AVA.Vehicles.DeleteVehicle(vehicle) end
end)
