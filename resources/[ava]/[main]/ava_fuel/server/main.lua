-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

RegisterNetEvent("ava_fuel:server:setStateBag", function(vehNet, fuel)
    local vehicle = NetworkGetEntityFromNetworkId(vehNet)
    if not vehicle or not DoesEntityExist(vehicle) then return end

    local vehState = Entity(vehicle).state
    if vehState and not vehState.fuel and GetEntityType(vehicle) == 2 /* 2 is vehicle */ and NetworkGetEntityOwner(vehicle) == source then
        -- Only allow values between 0 and 100
        vehState:set('fuel', fuel > 100 and 100 or (fuel < 0 and 0 or fuel), true)
    end
end)
