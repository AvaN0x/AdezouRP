-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
-- #region sell vehicle
function OpenSellZoneMenu()
    local sellZone = Config.Stores[CurrentZoneName]
    if not sellZone or not exports.ava_core:canOpenMenu() then return end

    local isInVehicle, vehicle, seat = exports.ava_core:IsPlayerInVehicle()
    if not isInVehicle or seat ~= -1 then
        exports.ava_core:ShowNotification(GetString("sellvehicle_not_in_vehicle_or_driver"), nil, "CHAR_SIMEON", "Simeon Yetarian")
        CurrentActionEnabled = true
        return
    end

    local vehiclePrice, vehicleName = GetVehiclePriceFromModel(sellZone.SellVehicle.VehicleType, GetEntityModel(vehicle))
    if not vehiclePrice then
        exports.ava_core:ShowNotification(GetString("sellvehicle_cannot_sell_this_vehicle_here"), nil, "CHAR_SIMEON", "Simeon Yetarian")
        CurrentActionEnabled = true
        return
    end
    local sellPrice = exports.ava_core:FormatNumber(math.floor((vehiclePrice * Config.VehicleShops.SellMultiplier) + 0.5))
    vehiclePrice = exports.ava_core:FormatNumber(vehiclePrice)
    local vehicleLabel = GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(vehicleName)))
    if vehicleLabel == "NULL" then vehicleLabel = vehicleName end

    if exports.ava_core:ShowConfirmationMessage(GetString("sellvehicle_want_to_sell_title"), GetString("sellvehicle_want_to_sell_firstline"),
        GetString("sellvehicle_want_to_sell_secondline", vehicleLabel, vehiclePrice, sellPrice))
        and exports.ava_core:ShowConfirmationMessage(GetString("sellvehicle_confirm_sell_title"), GetString("sellvehicle_confirm_sell_firstline"),
            GetString("sellvehicle_confirm_sell_secondline", vehicleLabel, vehiclePrice, sellPrice)) then

        local res<const> = exports.ava_core:TriggerServerCallback("ava_stores:server:vehicleshop:sellVehicle", sellZone.SellVehicle.VehicleType, VehToNet(vehicle))
        if res == 0 then
            exports.ava_core:ShowNotification(GetString("sellvehicle_cannot_sell_this_vehicle_here"), nil, "CHAR_SIMEON", "Simeon Yetarian")
        elseif res == 1 then
            PlaySoundFrontend(-1, "CHALLENGE_UNLOCKED", "HUD_AWARDS", true)

            -- The vehicle will be removed by the server while the screen is faded out
            DoScreenFadeOut(500)
            while not IsScreenFadedOut() do Wait(0) end

            PlaySoundFrontend(-1, "Garage_Door_Close", "GTAO_Script_Doors_Faded_Screen_Sounds", true)

            Wait(1500)
            DoScreenFadeIn(500)
        end
    end

    CurrentActionEnabled = true
end

-- #endregion sell vehicle

-- #region vehicleshop
local shopSavedData = nil
local Categories = {}
local CurrentCategory = nil

local MainVehicleShopMenu = RageUI.CreateMenu("", "Subtitle", 0, 0, "avaui", "avaui_title_adezou")
local CategoryMenu = RageUI.CreateSubMenu(MainVehicleShopMenu, "", "Subtitle", 0, 0, "avaui", "avaui_title_adezou")

local currentVehicleHashDisplayed = nil
local currentVehicleDisplayed = nil
-- #region vehicle display
local function DeleteDisplayedVehicle()
    if currentVehicleDisplayed then
        exports.ava_core:DeleteVehicle(currentVehicleDisplayed)
        currentVehicleDisplayed = nil
    end
end

local function DisplayVehicle(vehicleHash)
    local playerPed = PlayerPedId()
    local isPlayerInDisplayedVehicle = GetVehiclePedIsIn(playerPed) == currentVehicleDisplayed
    DeleteDisplayedVehicle()

    local shop = Config.Stores[CurrentZoneName]
    if shop and shop.VehicleShop then
        Citizen.CreateThread(function()
            -- #region prepare vehicle load
            BeginTextCommandBusyspinnerOn("STRING")
            AddTextComponentSubstringPlayerName(GetString("vehicleshop_loading_model"))
            EndTextCommandBusyspinnerOn(4)
            CategoryMenu.Controls.Back.Enabled = false
            CategoryMenu.Controls.Select.Enabled = false
            CategoryMenu.Controls.Up.Enabled = false
            CategoryMenu.Controls.Down.Enabled = false
            -- #endregion prepare vehicle load

            currentVehicleDisplayed = exports.ava_core:SpawnVehicleLocal(vehicleHash, shop.VehicleShop.Inside.Coord, shop.VehicleShop.Inside.Heading)
            SetVehicleColours(currentVehicleDisplayed, 111, 111)
            SetVehicleExtraColours(currentVehicleDisplayed, 111, 111)
            SetVehicleInteriorColor(currentVehicleDisplayed, 111)
            SetVehicleDirtLevel(currentVehicleDisplayed, 0)
            FreezeEntityPosition(currentVehicleDisplayed, true)

            if isPlayerInDisplayedVehicle then
                TaskWarpPedIntoVehicle(playerPed, currentVehicleDisplayed, -1)
            else
                SetVehicleEngineOn(currentVehicleDisplayed, true, true, false)
            end
            SetVehicleLights(currentVehicleDisplayed, 2)
            SetVehicleInteriorlight(currentVehicleDisplayed, true)

            -- #region finished vehicle load
            CategoryMenu.Controls.Back.Enabled = true
            CategoryMenu.Controls.Select.Enabled = true
            CategoryMenu.Controls.Up.Enabled = true
            CategoryMenu.Controls.Down.Enabled = true
            BusyspinnerOff()
            -- #endregion finished vehicle load
        end)
    end
end

-- #endregion vehicle display

local function resetVehicleShop()
    Categories = {}
    CurrentActionEnabled = true

    CurrentCategory = nil
    currentVehicleHashDisplayed = nil

    if shopSavedData and Config.Stores[shopSavedData.ShopName] then
        Config.Stores[shopSavedData.ShopName].Distance = shopSavedData.Distance
        Config.Stores[shopSavedData.ShopName].DrawDistance = shopSavedData.DrawDistance
        Config.Stores[shopSavedData.ShopName].Coord = shopSavedData.Coord
        Config.Stores[shopSavedData.ShopName].Marker = shopSavedData.Marker

        shopSavedData = nil
    end
end

MainVehicleShopMenu.Closed = function()
    if not CurrentCategory then
        resetVehicleShop()
    end
end
CategoryMenu.Closed = function()
    CurrentCategory = nil
    currentVehicleHashDisplayed = nil
    DeleteDisplayedVehicle()

    -- In case the menu was closed without having the player go back to the main menu
    Citizen.SetTimeout(500, function()
        if not RageUI.Visible(MainVehicleShopMenu) and not RageUI.Visible(CategoryMenu) then
            resetVehicleShop()
        end
    end)
end

function OpenVehicleShopMenu()
    local shop = Config.Stores[CurrentZoneName]
    if not shop or not exports.ava_core:canOpenMenu() then return end

    -- Change some data to be able to walk around the vehicle
    shopSavedData = { ShopName = CurrentZoneName, Distance = shop.Distance, DrawDistance = shop.DrawDistance, Coord = shop.Coord, Marker = shop.Marker }
    Config.Stores[CurrentZoneName].Distance = shop.VehicleShop.Inside.Distance or 20.0
    Config.Stores[CurrentZoneName].DrawDistance = Config.Stores[CurrentZoneName].Distance
    Config.Stores[CurrentZoneName].Coord = shop.VehicleShop.Inside.Coord
    Config.Stores[CurrentZoneName].Marker = nil

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
    if shop.VehicleShop.Categories then
        for i = 1, #shop.VehicleShop.Categories do
            availableCategories[shop.VehicleShop.Categories[i]] = true
        end
    end

    local vehiclesList<const> = Config.VehicleShops.Vehicles.vehiclestypes[tostring(shop.VehicleShop.VehicleType)]
    for vehicleName, vehicleData in pairs(vehiclesList) do
        -- First check, vehicle will be added only if it is not hidden, or if it can potentially be for the player job
        if not vehicleData.hidden or jobsManaged then
            local vehicleHash<const> = GetHashKey(vehicleName)
            -- Is vehicle in the right category and is the vehicle model valid
            if (not shop.VehicleShop.Categories or availableCategories[vehicleData.category]) and IsModelInCdimage(vehicleHash) then
                -- Element
                local vehicleLabel<const> = GetLabelText(GetDisplayNameFromVehicleModel(vehicleHash))
                local vehicleMakeName = GetLabelText(GetMakeNameFromVehicleModel(vehicleHash))
                if vehicleMakeName == "NULL" then
                    vehicleMakeName = GetString("vehicleshop_makename_not_found")
                end
                local stock<const> = vehicleStocks[vehicleName] or vehicleData.quantity or Config.VehicleShops.DefaultStockValue
                local element<const> = {
                    label = vehicleLabel ~= "NULL" and vehicleLabel or vehicleName,
                    vehicleName = vehicleName,
                    vehicleHash = vehicleHash,
                    price = vehicleData.price,
                    stock = stock,
                    desc = GetString("vehicleshop_vehicle_desc", vehicleMakeName),
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
            elseif not IsModelInCdimage(vehicleHash) then
                print("^1[AVA Vehicle Shop] " .. vehicleName .. " is not a valid model^0")
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
    MainVehicleShopMenu:ResetIndex()
    RageUI.Visible(MainVehicleShopMenu, true)
end

function RageUI.PoolMenus:VehicleShopMenu()
    MainVehicleShopMenu:IsVisible(function(Items)
        if Categories then
            for i = 1, #Categories do
                local category<const> = Categories[i]
                Items:AddButton(category.label, category.desc, { RightLabel = category.rightLabel }, function(onSelected, onEntered)
                    if onSelected then
                        CategoryMenu.Subtitle = category.label
                        CurrentCategory = i
                        CategoryMenu:ResetIndex()
                    end
                end, CategoryMenu)
            end
        end
    end)
    CategoryMenu:IsVisible(function(Items)
        local vehicleToDisplay = nil
        if Categories and CurrentCategory and Categories[CurrentCategory] then
            local category = Categories[CurrentCategory]
            for i = 1, #category.Vehicles do
                local vehicle<const> = category.Vehicles[i]
                Items:AddButton(vehicle.label, vehicle.desc, { RightLabel = vehicle.rightLabel }, function(onSelected, onEntered)
                    vehicleToDisplay = vehicle.vehicleHash
                    if onSelected then
                        if vehicle.stock > 0 then
                            CategoryMenu.Controls.Back.Enabled = false

                            local shop = Config.Stores[CurrentZoneName]
                            if shop then
                                -- Display matching confirmation message (job or personal vehicle)
                                if (
                                    category.jobName
                                        and exports.ava_core:ShowConfirmationMessage(GetString("vehicleshop_confirm_job_purchase_title"), GetString("vehicleshop_confirm_job_purchase_firstline"),
                                            GetString("vehicleshop_confirm_job_purchase_secondline", vehicle.label, vehicle.rightLabel))
                                    )
                                    or (not category.jobName
                                        and exports.ava_core:ShowConfirmationMessage(GetString("vehicleshop_confirm_purchase_title"), GetString("vehicleshop_confirm_purchase_firstline"),
                                            GetString("vehicleshop_confirm_purchase_secondline", vehicle.label, vehicle.rightLabel))
                                    ) then
                                    -- Buy vehicle
                                    if exports.ava_core:TriggerServerCallback("ava_stores:server:vehicleshop:purchaseVehicle",
                                        tostring(shop.VehicleShop.VehicleType), vehicle.vehicleName, category.jobName) then
                                        RageUI.CloseAllInternal()

                                        local spawn = shop.VehicleShop.SpawnVehicle
                                        -- If there is a large vehicle spawn, check the dimensions of the vehicle and spawn it at the right location
                                        if shop.VehicleShop.SpawnLargeVehicle then
                                            local min, max = GetModelDimensions(vehicle.vehicleHash)
                                            if min.y < -5 or max.y > 5 or max.z > 2 then
                                                spawn = shop.VehicleShop.SpawnLargeVehicle
                                            end
                                        end

                                        DoScreenFadeOut(500)
                                        while not IsScreenFadedOut() do Wait(0) end

                                        local vehicleEntity = exports.ava_core:SpawnVehicle(vehicle.vehicleHash, spawn.Coord, spawn.Heading)
                                        if vehicleEntity then
                                            SetVehicleColours(vehicleEntity, 111, 111)
                                            SetVehicleExtraColours(vehicleEntity, 111, 111)
                                            SetVehicleInteriorColor(vehicleEntity, 111)
                                            SetVehicleDirtLevel(vehicleEntity, 0)
                                            TriggerServerEvent("ava_stores:server:vehicleshop:purchasedVehicle", VehToNet(vehicleEntity), vehicle.label, json.encode(exports.ava_core:GetVehicleModsData(vehicleEntity) or {}))

                                            PlaySoundFrontend(soundId, "Garage_Door_Open", "GTAO_Script_Doors_Faded_Screen_Sounds", true)
                                            SetVehRadioStation(vehicleEntity, "OFF")
                                            TaskWarpPedIntoVehicle(PlayerPedId(), vehicleEntity, -1)

                                        end

                                        Wait(1500)
                                        DoScreenFadeIn(500)
                                    end
                                end
                                Wait(10)
                            end

                            CategoryMenu.Controls.Back.Enabled = true
                        else
                            exports.ava_core:ShowNotification(GetString("vehicleshop_outofstock"), nil, "CHAR_SIMEON", "Simeon Yetarian")
                        end
                    end
                end)
            end
        end

        if currentVehicleHashDisplayed ~= vehicleToDisplay then
            currentVehicleHashDisplayed = vehicleToDisplay
            DisplayVehicle(currentVehicleHashDisplayed)
        end
    end)
end

AddEventHandler("ava_core:client:canOpenMenu", function()
    if RageUI.Visible(MainVehicleShopMenu) or RageUI.Visible(CategoryMenu) then
        CancelEvent()
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() and currentVehicleDisplayed then
        DeleteDisplayedVehicle()
    end
end)
-- #endregion vehicleshop
