-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

exports.ava_core:RegisterCommand("lscustoms", "admin", function(source, args)
    TriggerClientEvent("ava_stores:client:OpenLSCustoms", source)
end, GetString("lscustoms_help"))


exports.ava_core:RegisterServerCallback("ava_stores:server:payLSCustoms", function(source, vehNet, modName, lscustomName, jobToPay)
    local src = source
    print(vehNet, modName, lscustomName)
    -- Check if modName is valid
    local modCfg<const> = Config.LSCustoms.Mods[modName]
    if not modCfg then return false end

    -- check if vehicle is valid
    local vehicle = NetworkGetEntityFromNetworkId(vehNet)
    if not DoesEntityExist(vehicle) then return false end

    -- get player
    local aPlayer = exports.ava_core:GetPlayer(src)
    if not aPlayer then return false end

    -- get mod price
    local vehiclePrice, vehicleModel = GetVehiclePriceFromModel(GetEntityModel(vehicle))
    local price = modCfg.staticPrice or math.floor(vehiclePrice * modCfg.priceMultiplier + 0.5)

    if lscustomName and Config.Stores[lscustomName]?.LSCustoms?.DirtyCash then
        -- dirty cash
        print("dirty cash", price) -- TODO
    else
        -- cash
        if jobToPay and Config.LSCustoms.AllowedJobsToPay[jobToPay] then
            -- job
            print("job cash", price, jobToPay) -- TODO
        else
            -- player
            print("player cash", price) -- TODO
        end
    end
    

    -- TODO
    return true
end)
