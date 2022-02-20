-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local CurrentPound = nil
local min = math.min
local max = math.max
local floor = math.floor

function OpenPoundMenu(pound)
    if not exports.ava_core:canOpenMenu() then return end
    CurrentPound = pound

    local vehicles<const> = exports.ava_core:TriggerServerCallback("ava_garages:server:getVehiclesInPound", CurrentPound.Name, CurrentPound.VehicleType) or {}
    table.sort(vehicles, function(a, b)
        return not a.job_name and b.job_name
    end)

    -- Variable used to add job separators
    local lastJob = nil

    local elements = {
        { separator = true, label = GetString("pound_separator", GetString("your_vehicles")) } -- Default separator
    }

    for i = 1, #vehicles do
        local vehicle<const> = vehicles[i]

        local vehiclePrice = exports.ava_stores:GetVehiclePrice(vehicle.model, CurrentPound.VehicleType)
        if vehiclePrice then
            -- Add separator if needed
            if vehicle.job_name and lastJob ~= vehicle.job_name then
                lastJob = vehicle.job_name
                local label = GetString("pound_separator", vehicle.job_name)
                for i = 1, #PlayerData.jobs do
                    if PlayerData.jobs[i].name == vehicle.job_name then
                        label = GetString("pound_separator", PlayerData.jobs[i].label)
                        break
                    end
                end

                table.insert(elements, {
                    separator = true,
                    label = label
                })
            end

            -- Add the vehicle to the menu
            local vehicleLabel = GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(vehicle.model)))
            if vehicleLabel == "NULL" then vehicleLabel = vehicle.model end

            -- Get vehicle price with min of AVAConfig.PoundPriceMinimum and max of AVAConfig.PoundPriceMaximum
            local price = min(max(floor(vehiclePrice * AVAConfig.PoundPriceMultiplier + 0.5), AVAConfig.PoundPriceMinimum), AVAConfig.PoundPriceMaximum)

            table.insert(elements, {
                label = vehicle.label,
                desc = GetString("pound_desc", vehicleLabel, vehicle.plate),
                rightLabel = GetString("price", exports.ava_core:FormatNumber(price)),
                jobName = vehicle.job_name,
                model = vehicle.model,
                id = vehicle.id,
            })
        end
    end


    RageUI.CloseAll()
    RageUI.OpenTempMenu(GetString("pound_menu"), function(Items)
        for i = 1, #elements do
            local element = elements[i]
            if element.separator then
                Items:AddSeparator(element.label)
            else
                Items:AddButton(element.label, element.desc, { RightLabel = element.rightLabel }, function(onSelected)
                    if onSelected then
                        if not canTakeOutVehicle(CurrentPound) then return end

                        if exports.ava_core:TriggerServerCallback("ava_garages:server:takeVehicleOutOfPound", element.id, CurrentPound.Name, CurrentPound.VehicleType) then
                            takeOutVehicle(CurrentPound, element.model, element.id)
                            RageUI.CloseAllInternal()
                        end
                    end
                end)
            end
        end
    end, function()
        CurrentActionEnabled = true
    end)

end
