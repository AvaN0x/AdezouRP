-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
function OpenRentalMenu()
    local rentalName, rental = CurrentZoneName, Config.Stores[CurrentZoneName]
    if not rental or not exports.ava_core:canOpenMenu() then return end

    local elements = {}
    local count = 0
    for i = 1, #rental.Rental.Vehicles do
        local vehicle = rental.Rental.Vehicles[i]
        local vehicleHash = GetHashKey(vehicle.name)
        if IsModelInCdimage(vehicleHash) then
            count = count + 1

            local vehicleLabel<const> = GetLabelText(GetDisplayNameFromVehicleModel(vehicleHash))
            elements[count] = {
                label = vehicleLabel ~= "NULL" and vehicleLabel or vehicle.name,
                rightLabel = GetString("rental_price_format", vehicle.price),
                price = vehicle.price,
                name = vehicle.name,
            }
        end
    end

    if count > 0 then
        RageUI.CloseAll()
        RageUI.OpenTempMenu(rental.Name, function(Items)
            for i = 1, #elements do
                local element = elements[i]
                Items:AddButton(element.label, element.desc, { RightLabel = element.rightLabel }, function(onSelected)
                    if onSelected then
                        if canRentVehicle(rental, rentalName, element.name) then
                            print("element", json.encode(element, { indent = true }))
                            local vehicle = exports.ava_core:SpawnVehicle(GetHashKey(element.name), rental.Rental.SpawnCoord.xyz, rental.Rental.SpawnCoord.w)
                            TriggerServerEvent("ava_stores:server:vehicleRental:spawnedVehicle", VehToNet(vehicle))
                            -- TODO set vehicle fuel
                            SetVehRadioStation(vehicle, "OFF")
                            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                        end
                    end
                end)
            end
        end, function()
            CurrentActionEnabled = true
        end, rental.Title and rental.Title.textureName, rental.Title and rental.Title.textureDirectory)
    end
end

function canRentVehicle(rental, rentalName, vehName)
    if exports.ava_core:IsPlayerInVehicle() then
        exports.ava_core:ShowNotification(GetString("rental_already_in_vehicle"))
        return false
    end
    if IsPositionOccupied(rental.Rental.SpawnCoord.x, rental.Rental.SpawnCoord.y, rental.Rental.SpawnCoord.z, 0.7, false, true, false, false, false, 0, false) then
        exports.ava_core:ShowNotification(GetString("rental_area_is_occupied"))
        return false
    end
    if not exports.ava_core:TriggerServerCallback("ava_stores:server:vehicleRental:canRent", rentalName, vehName) then
        exports.ava_core:ShowNotification(GetString("rental_not_enough_money"))
        return false
    end
    return true
end
