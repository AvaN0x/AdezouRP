-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
----------------------------------------
--------------- Vehicles ---------------
----------------------------------------
RegisterNetEvent("ava_core:client:spawnVehicle", function(vehName)
    local playerPed = PlayerPedId()
    local vehicle = AVA.Vehicles.SpawnVehicle(vehName, GetEntityCoords(playerPed), GetEntityHeading(playerPed))

    ClearPedTasksImmediately(playerPed)
    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
end)

RegisterNetEvent("ava_core:client:deleteVehicle", function()
    local playerPed = PlayerPedId()
    local vehicle = IsPedInAnyVehicle(playerPed, true) and GetVehiclePedIsIn(playerPed, false) or AVA.Vehicles.GetVehicleInFront(5)

    if vehicle ~= 0 then
        AVA.Vehicles.DeleteVehicle(vehicle)
    end
end)

-----------------------------------------
--------------- Teleports ---------------
-----------------------------------------

RegisterNetEvent("ava_core:client:teleportToCoords", function(x, y, z)
    AVA.TeleportPlayerToCoords(x, y, z, true)
end)

RegisterNetEvent("ava_core:client:teleportToWaypoint", function()
    local waypoint = GetFirstBlipInfoId(GetWaypointBlipEnumId())
    if waypoint and waypoint > 0 then
        local blipCoords = GetBlipInfoIdCoord(waypoint)
        AVA.TeleportPlayerToCoords(blipCoords.x, blipCoords.y, 0, true)
    else
        AVA.ShowNotification(nil, nil, "ava_core_logo", "Aucun waypoint trouvé", nil, nil, "ava_core_logo")
    end
end)

--------------------------------------
--------------- Others ---------------
--------------------------------------

RegisterNetEvent("ava_core:client:kill")
AddEventHandler("ava_core:client:kill", function()
    SetEntityHealth(PlayerPedId(), 0)
    AVA.ShowNotification(nil, nil, "ava_core_logo", "Tué par un staff", nil, nil, "ava_core_logo")
end)
