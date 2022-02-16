-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
-- #region sell vehicle
function OpenSellZoneMenu()
    local sellZone = Config.Stores[CurrentZoneName]
    print("sellZone")
    -- TODO open confirmation message with price
    -- exports.ava_core:ShowConfirmationMessage -- "Do you want to sell this vehicle for X$?"
    -- exports.ava_core:ShowConfirmationMessage -- "Are you sure you want to sell this vehicle for X$?"
end
-- #endregion sell vehicle

-- #region vehicleshop
local Categories = {}

function OpenVehicleShopMenu()
    local shop = Config.Stores[CurrentZoneName]
    print("shop")

    if not shop then
        return
    end
    -- #region prepare categories
    Categories = {}

    local countCategories = 0
    local CategoriesIndices = {}

    -- Prepare job categories
    local jobsManaged = {}
    for i = 1, #PlayerData.jobs do
        local job = PlayerData.jobs[i]
        if job.canManage and not job.isGang and Config.VehicleShops.Vehicles.jobs[job.name] then
            table.insert(jobsManaged, job.name)
            countCategories = countCategories + 1
            CategoriesIndices[job.name] = countCategories
            Categories[countCategories] = {
                label = job.label,
                desc = GetString("vehicle_shop_job_category_desc"),
                vehicleCount = 0,
                Vehicles = {},
                jobName = job.name,
            }
        end
    end
    if #jobsManaged == 0 then
        jobsManaged = nil
    end

    -- Prepare a list of categories for this vehicle shop
    local availableCategories = {}
    for i = 1, #shop.VehicleShop.Categories do
        availableCategories[shop.VehicleShop.Categories[i]] = true
    end

    local vehiclesList<const> = Config.VehicleShops.Vehicles.vehiclestypes[tostring(shop.VehicleShop.VehicleType)]
    for vehicleName, vehicleData in pairs(vehiclesList) do
        -- First check, vehicle will be added only if it is not hidden, or if it can potentially be for the player job
        if not vehicleData.hidden or jobsManaged then
            local vehicleHash<const> = GetHashKey(vehicleName)
            -- Is vehicle in the right category and is the vehicle model valid
            if not shop.VehicleShop.Categories or availableCategories[vehicleData.category] and IsModelInCdimage(vehicleHash) then
                -- Element
                local vehicleLabel<const> = GetLabelText(GetDisplayNameFromVehicleModel(vehicleHash))
                local element<const> = {
                    label = vehicleLabel ~= "NULL" and vehicleLabel or vehicleName,
                    vehicleName = vehicleName,
                    vehicleHash = vehicleHash,
                    desc = vehicleData.desc, -- TODO
                    rightLabel = GetString("vehicle_shop_price_format", exports.ava_core:FormatNumber(vehicleData.price)),
                }

                -- Vehicle shop category
                if not vehicleData.hidden then
                    -- Init category if it do not exist
                    if not CategoriesIndices[vehicleData.category] then
                        countCategories = countCategories + 1
                        CategoriesIndices[vehicleData.category] = countCategories
                        Categories[countCategories] = {
                            label = GetString("vehicle_shop_category_" .. vehicleData.category),
                            desc = GetString("vehicle_shop_category_" .. vehicleData.category .. "_desc"),
                            vehicleCount = 0,
                            Vehicles = {},
                        }
                    end
                    local index<const> = CategoriesIndices[vehicleData.category]
                    Categories[index].vehicleCount = Categories[index].vehicleCount + 1
                    Categories[index].Vehicles[Categories[index].vehicleCount] = element
                end

                -- Job category
                if jobsManaged then
                    for i = 1, #jobsManaged do
                        local jobName = jobsManaged[i]
                        if Config.VehicleShops.Vehicles.jobs[jobName][vehicleName] then
                            local index<const> = CategoriesIndices[jobName]
                            Categories[index].vehicleCount = Categories[index].vehicleCount + 1
                            Categories[index].Vehicles[Categories[index].vehicleCount] = element
                        end
                    end
                end
            end
        end
    end

    table.sort(Categories, function(a, b)
        if not a.jobName and b.jobName then
            return true
        elseif a.jobName and not b.jobName then
            return false
        end
        return a.label < b.label
    end)
    for k, v in pairs(Categories) do
        table.sort(v.Vehicles, function(a, b)
            return a.label < b.label
        end)
    end

    -- #endregion prepare categories

end
-- #endregion vehicleshop
