-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

RegisterNetEvent("ava_fuel:server:setStateBag", function(vehNet, fuel)
    local vehicle = NetworkGetEntityFromNetworkId(vehNet)
    if not vehicle or not DoesEntityExist(vehicle) then return end

    local vehState = Entity(vehicle).state
    if vehState and not vehState.fuel and GetEntityType(vehicle) == 2 /* 2 is vehicle */ and NetworkGetEntityOwner(vehicle) == source then
        -- Only allow values between 0 and 65
        vehState:set('fuel', fuel > 65 and 65 or (fuel < 0 and 0 or fuel), true)
    end
end)

exports.ava_core:RegisterCommand("refuel", "admin", function(source, args)
    if source > 0 then
        TriggerClientEvent("ava_fuel:client:refuel", source, tonumber(args[1]) and args[1])
    end
end, GetString("refuel_help"), {{name = "?value", help = GetString("refuel_value")}})