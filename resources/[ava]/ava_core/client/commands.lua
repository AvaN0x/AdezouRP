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
    local vehicle = IsPedInAnyVehicle(playerPed, true) and GetVehiclePedIsIn(playerPed, false) or AVA.Vehicles.GetVehicleInFront(5)

    if vehicle ~= 0 then
        AVA.Vehicles.DeleteVehicle(vehicle)
    end
end)

RegisterNetEvent("ava:client:teleportToCoords", function(x, y, z)
    AVA.TeleportPlayerToCoords(x, y, z, true)
end)

RegisterNetEvent("ava:client:teleportToWaypoint", function()
    local waypoint = GetFirstBlipInfoId(GetWaypointBlipEnumId())
    if waypoint and waypoint > 0 then
        local blipCoords = GetBlipInfoIdCoord(waypoint)
        print(blipCoords)
        AVA.TeleportPlayerToCoords(blipCoords.x, blipCoords.y, 0, true)
    else
        AVA.ShowNotification(nil, nil, "ava_core_logo", "Aucun waypoint trouvé", nil, nil, "ava_core_logo")
    end
end)
