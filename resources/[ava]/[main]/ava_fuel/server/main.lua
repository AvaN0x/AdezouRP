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

exports.ava_core:RegisterServerCallback("ava_fuel:server:getFuelPlayerCanAfford", function(source)
    local aPlayer = exports.ava_core:GetPlayer(source)
    if not aPlayer then return 0 end

    local inventory = aPlayer.getInventory()
    return math.floor((inventory.getItemQuantity("cash") / AVAConfig.LiterPrice) * 10) / 10
end)

exports.ava_core:RegisterServerCallback("ava_fuel:server:validateRefuel", function(source, refueled)
    if refueled <= 0 or refueled > 65 then return false end

    local aPlayer = exports.ava_core:GetPlayer(source)
    if not aPlayer then return false end

    local inventory = aPlayer.getInventory()
    local price<const> = tonumber(("%.0f"):format(refueled * AVAConfig.LiterPrice))
    if not inventory.canRemoveItem("cash", price) then
        return false
    end

    inventory.removeItem("cash", price)
    return true
end)


exports.ava_core:RegisterUsableItem("petrolcan", function(source)
    TriggerClientEvent("ava_fuel:client:usePetrolcan", source)
end)

RegisterNetEvent("ava_fuel:server:petrolcan:remove", function()
    local aPlayer = exports.ava_core:GetPlayer(source)
    if aPlayer then
        local inventory = aPlayer.getInventory()
        inventory.removeItem("petrolcan", 1)
    end
end)
