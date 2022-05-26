-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
RegisterNetEvent("ava_drivingschool:server:setDrivingTestVehicle", function(vehNet)
    local entityState = Entity(NetworkGetEntityFromNetworkId(vehNet))
    entityState.state:set("drivingTestVehicle", true, true)
end)
