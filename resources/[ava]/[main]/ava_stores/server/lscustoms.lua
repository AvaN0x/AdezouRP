-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

exports.ava_core:RegisterCommand("lscustoms", "admin", function(source, args)
    TriggerClientEvent("ava_stores:client:OpenLSCustoms", source)
end, GetString("lscustoms_help"))


exports.ava_core:RegisterServerCallback("ava_stores:server:payLSCustoms", function(source, vehNet, modName, clientPrice, lscustomName, jobToPay)
    local src = source
    -- Check if modName is valid
    local modCfg<const> = Config.LSCustoms.Mods[modName]
    if not modCfg then return false end

    -- Check if vehicle is valid
    local vehicle = NetworkGetEntityFromNetworkId(vehNet)
    if not DoesEntityExist(vehicle) then return false end

    -- If there is no lscustomName, then only a player that could have executed lscustoms is allowed to apply the custom
    if not lscustomName and not jobToPay then
        return IsPlayerAceAllowed(src, "command.lscustoms")
    end

    -- Get player
    local aPlayer = exports.ava_core:GetPlayer(src)
    if not aPlayer then return false end

    -- Get mod price
    local vehiclePrice, vehicleModel = GetVehiclePriceFromModel(GetEntityModel(vehicle))
    if not vehiclePrice then return false end

    local price = modCfg.staticPrice or math.floor(vehiclePrice * modCfg.priceMultiplier + 0.5)
    -- If client price is higher than mod price, then use client price
    if clientPrice > price then
        price = clientPrice
    end

    if Config.Stores[lscustomName]?.LSCustoms?.DirtyCash then
        -- Dirty Money
        -- Player pays
        local inventory = aPlayer.getInventory()
        if inventory.canRemoveItem("dirtycash", price) then
            inventory.removeItem("dirtycash", price)
            TriggerEvent("ava_logs:server:log", { "citizenid:" .. aPlayer.citizenId, "pay_custom", "price:" .. price, "(dirtycash)" })
        else
            TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("cant_afford_dirty"))
            return false
        end

    else
        -- Clean money
        if jobToPay and Config.LSCustoms.AllowedJobsToPay[jobToPay] then
            -- Job pays
            local jobPrice = math.floor(price * Config.LSCustoms.JobPartPaid + 0.5)
            local accounts = exports.ava_core:GetJobAccounts(jobToPay)
            if accounts and accounts.getAccountBalance("bank") >= jobPrice then
                accounts.removeAccountBalance("bank", jobPrice)
                exports.ava_jobs:applyTaxes(price, jobToPay)
                TriggerEvent("ava_logs:server:log", { "citizenid:" .. aPlayer.citizenId, "job_pay_custom", "price:" .. price, "job:" .. jobToPay })
            else
                TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("job_cant_afford"))
                return false
            end
        else
            -- Player pays
            local inventory = aPlayer.getInventory()
            if inventory.canRemoveItem("cash", price) then
                inventory.removeItem("cash", price)
                exports.ava_jobs:applyTaxes(price, "citizenid:" .. aPlayer.citizenId)
                TriggerEvent("ava_logs:server:log", { "citizenid:" .. aPlayer.citizenId, "pay_custom", "price:" .. price })
            else
                TriggerClientEvent("ava_core:client:ShowNotification", src, GetString("cant_afford"))
                return false
            end
        end
    end

    return true
end)
