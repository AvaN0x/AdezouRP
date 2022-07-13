-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local playerRentingVehicle = {}

exports.ava_core:RegisterServerCallback("ava_stores:server:vehicleRental:canRent", function(source, storeName, vehName)
    local src = source

    -- Player already renting a vehicle (should not happen)
    if playerRentingVehicle[tostring(src)] then return false end

    -- Check store
    local store = Config.Stores[storeName]
    if not store or not store.Rental then return false end

    local aPlayer = exports.ava_core:GetPlayer(src)
    if not aPlayer then return false end

    -- Get vehicle renting price
    local price
    for i = 1, #store.Rental.Vehicles do
        if store.Rental.Vehicles[i].name == vehName then
            price = store.Rental.Vehicles[i].price
            break
        end
    end
    if price == nil then return false end

    -- Check if player has enough money
    local inventory = aPlayer.getInventory()
    if inventory.canRemoveItem("cash", price) then
        -- Player has enough money, rent the vehicle
        inventory.removeItem("cash", price)

        playerRentingVehicle[tostring(src)] = { vehicleName = vehName }
        return true
    end
    return false
end)

RegisterNetEvent("ava_stores:server:vehicleRental:spawnedVehicle", function(vehicleNet)
    local src = source

    if not playerRentingVehicle[tostring(src)] then return end
    -- #region wait for entity to exist or abort
    -- Prevent infinite loop
    local waitForEntityToExistCount = 0
    while waitForEntityToExistCount <= 100 and not DoesEntityExist(NetworkGetEntityFromNetworkId(vehicleNet)) do
        Wait(10)
        waitForEntityToExistCount = waitForEntityToExistCount + 1
    end
    if waitForEntityToExistCount > 100 then
        playerRentingVehicle[tostring(src)] = nil
        print("^1[AVA_STORES]^0Vehicle renting failed, entity does not exist.")
        return
    end
    -- #endregion wait for entity to exist or abort

    local rentingData <const> = playerRentingVehicle[tostring(src)]

    -- Check if vehicle is still has the right model
    if GetEntityModel(NetworkGetEntityFromNetworkId(vehicleNet)) ~= joaat(rentingData.vehicleName) then
        playerRentingVehicle[tostring(src)] = nil
        print("^1[AVA_STORES]^0Vehicle renting failed, model mismatch.")
        return
    end

    -- Setup the vehicle
    Entity(NetworkGetEntityFromNetworkId(vehicleNet)).state:set("rentalVehicle", true, true)

    exports.ava_garages:GivePlayerVehicleKeyForVehicleNet(src, vehicleNet)

    playerRentingVehicle[tostring(src)] = nil
end)
