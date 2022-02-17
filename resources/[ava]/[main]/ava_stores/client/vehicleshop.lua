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
local CurrentCategory = nil
local MainVehicleShopMenu = RageUI.CreateMenu("", "Subtitle", 0, 0, "avaui", "avaui_title_adezou")
MainVehicleShopMenu.Closed = function()
    if not CurrentCategory then
        Categories = {}
        CurrentActionEnabled = true
    end
end
local CategoryMenu = RageUI.CreateSubMenu(MainVehicleShopMenu, "", "Subtitle", 0, 0, "avaui", "avaui_title_adezou")
CategoryMenu.Closed = function()
    CurrentCategory = nil
end

function OpenVehicleShopMenu()
    local shop = Config.Stores[CurrentZoneName]
    if not shop or not exports.ava_core:canOpenMenu() then
        return
    end
    -- #region prepare categories
    Categories = {}
    local vehicleStocks = exports.ava_core:TriggerServerCallback("ava_stores:server:vehicleshop:getStock")

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
                label = GetString("vehicleshop_job_category", job.label),
                desc = GetString("vehicleshop_job_category_desc"),
                vehicleCount = 0,
                Vehicles = {},
                jobName = job.name,
                rightLabel = "→→→",
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
                local stock<const> = vehicleStocks[vehicleName] or Config.VehicleShops.DefaultStockValue
                local element<const> = {
                    label = vehicleLabel ~= "NULL" and vehicleLabel or vehicleName,
                    vehicleName = vehicleName,
                    vehicleHash = vehicleHash,
                    price = vehicleData.price,
                    stock = stock,
                    desc = vehicleData.desc, -- TODO
                    rightLabel = stock > 0 and GetString("vehicleshop_price_format", exports.ava_core:FormatNumber(vehicleData.price))
                        or GetString("vehicleshop_price_outofstock"),
                }

                -- Vehicle shop category
                if not vehicleData.hidden then
                    -- Init category if it do not exist
                    if not CategoriesIndices[vehicleData.category] then
                        countCategories = countCategories + 1
                        CategoriesIndices[vehicleData.category] = countCategories
                        Categories[countCategories] = {
                            label = GetString("vehicleshop_category_" .. vehicleData.category),
                            desc = GetString("vehicleshop_category_" .. vehicleData.category .. "_desc"),
                            vehicleCount = 0,
                            Vehicles = {},
                            rightLabel = "→→→",
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
    CategoriesIndices = nil
    jobsManaged = nil
    -- #endregion prepare categories

    -- #region prepare menu
    MainVehicleShopMenu.Subtitle = shop.Name
    RageUI.CloseAll()
    RageUI.Visible(MainVehicleShopMenu, true)
end

function RageUI.PoolMenus:VehicleShopMenu()
    MainVehicleShopMenu:IsVisible(function(Items)
        if Categories then
            for i = 1, #Categories do
                local category<const> = Categories[i]
                Items:AddButton(category.label, category.desc, {RightLabel = category.rightLabel}, function(onSelected, onEntered)
                    if onSelected then
                        CategoryMenu.Subtitle = category.label
                        CurrentCategory = i
                    end
                end, CategoryMenu)
            end
        end
    end)
    CategoryMenu:IsVisible(function(Items)
        if Categories and CurrentCategory and Categories[CurrentCategory] then
            local category = Categories[CurrentCategory]
            for i = 1, #category.Vehicles do
                local vehicle<const> = category.Vehicles[i]
                Items:AddButton(vehicle.label, vehicle.desc, {RightLabel = vehicle.rightLabel}, function(onSelected, onEntered)
                    if onEntered then
                        print(vehicle.vehicleName)
                    elseif onSelected then
                        if vehicle.stock > 0 then
                            CategoryMenu.Controls.Back.Enabled = false
                            if category.jobName then
                                if exports.ava_core:ShowConfirmationMessage(GetString("vehicleshop_confirm_job_purchase_title"),
                                    GetString("vehicleshop_confirm_job_purchase_firstline"), GetString("vehicleshop_confirm_job_purchase_secondline",
                                        vehicle.label, vehicle.rightLabel)) then
                                    print("buy job")
                                end
                            else
                                if exports.ava_core:ShowConfirmationMessage(GetString("vehicleshop_confirm_purchase_title"),
                                    GetString("vehicleshop_confirm_purchase_firstline"), GetString("vehicleshop_confirm_purchase_secondline", vehicle.label,
                                        vehicle.rightLabel)) then
                                    print("buy player")
                                end
                            end
                            Wait(10)
                            CategoryMenu.Controls.Back.Enabled = true
                        else
                            exports.ava_core:ShowNotification(GetString("vehicleshop_outofstock"))
                        end
                    end
                end)
            end
        end
    end)
end

AddEventHandler("ava_core:client:canOpenMenu", function()
    if RageUI.Visible(MainVehicleShopMenu) or RageUI.Visible(CategoryMenu) then
        CancelEvent()
    end
end)
-- #endregion vehicleshop
