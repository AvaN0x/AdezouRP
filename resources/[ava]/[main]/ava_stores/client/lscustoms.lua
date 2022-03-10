-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local CloseLSCustomsMenu, PrepareMenuElements, ToggleVehicleDoors, ReloadCurrentMenuWithValue

--- Menu Depth is used to keep track of how many layers/menus we're in
local MenuDepth = nil
local MenuElements = nil

local CurrentLSCustoms = nil
local CurrentVehicleData = nil

function LSCustoms()
    local store = Config.Stores[CurrentZoneName]
    if not store or not exports.ava_core:canOpenMenu() then return end

    OpenLSCustomsMenu(store, store.Subtitle, store.Title.textureName, store.Title.textureDirectory)
end

CloseLSCustomsMenu = function()
    if CurrentVehicleData then
        if CurrentVehicleData.doorsOpened then
            ToggleVehicleDoors()
        end
        if CurrentVehicleData.modified and CurrentVehicleData.modsdata then
            -- If vehicle modified, save the modifications to database
            TriggerServerEvent("ava_garages:server:savemodsdata", VehToNet(CurrentVehicleData.vehicle),
                json.encode(CurrentVehicleData.modsdata))
        end
    end
    if CurrentLSCustoms then
        -- Allow the player to reopen the menu if he was in a store
        CurrentActionEnabled = true
    end
    -- Clear variables
    CurrentLSCustoms = nil
    CurrentVehicleData = nil
    MenuDepth = nil
    MenuElements = nil
end

local MainLSCustomsMenu = RageUI.CreateMenu("", "lscustoms_menu", 0, 0, "avaui", "avaui_title_adezou")
MainLSCustomsMenu:AddInstructionButton({GetControlInstructionalButton(0, 22, true), GetString("lscustoms_toggle_vehicle_doors")}) -- INPUT_JUMP

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() and CurrentVehicleData then
        exports.ava_core:SetVehicleModsData(CurrentVehicleData.vehicle, CurrentVehicleData.modsdata)
        CloseLSCustomsMenu()
    end
end)

AddEventHandler("ava_core:client:canOpenMenu", function()
    if RageUI.Visible(MainLSCustomsMenu) then
        CancelEvent()
    end
end)

OpenLSCustomsMenu = function(store, menuName, titleTexture, titleTextureDirectory)
    -- Check if the player is in a vehicle and is the driver
    local isInVehicle, vehicle, seat = exports.ava_core:IsPlayerInVehicle()
    if not isInVehicle or seat ~= -1 then
        exports.ava_core:ShowNotification(GetString("lscustoms_not_in_vehicle_or_driver"))
        CurrentActionEnabled = true
        return
    end

    local vehiclePrice, vehicleName = exports.ava_stores:GetVehiclePriceFromModel(GetEntityModel(vehicle))
    print(vehiclePrice, vehicleName)

    -- Check vehicle health
    if GetVehicleBodyHealth(vehicle) < Config.LSCustoms.MinimumBodyHealth or GetVehicleEngineHealth(vehicle) < Config.LSCustoms.MinimumEngineHealth then
        exports.ava_core:ShowNotification(GetString("lscustoms_vehicle_damaged"))
        CurrentActionEnabled = true
        return
    end

    RageUI.CloseAll()

    -- Set menu title and banner
    MainLSCustomsMenu.Sprite.Dictionary = titleTextureDirectory or "avaui"
    MainLSCustomsMenu.Sprite.Texture = titleTexture or "avaui_title_adezou"
    MainLSCustomsMenu.Subtitle = menuName or GetString("lscustoms_menu")

    -- Initialize needed data for the menu
    CurrentLSCustoms = store
    CurrentVehicleData = {
        vehicle = vehicle,
        modsdata = exports.ava_core:GetVehicleModsData(vehicle),
        modified = false,
        price = vehiclePrice,
        name = vehicleName,
    }
    MenuDepth = nil
    MenuElements = {}
    PrepareMenuElements(Config.LSCustoms.Menu)
    MainLSCustomsMenu.Parent = MainLSCustomsMenu

    -- Allow to get vehicle mod kit
    SetVehicleModKit(vehicle, 0)

    -- Prevent player from leaving the vehicle
    Citizen.CreateThread(function()
        while CurrentVehicleData do
            Wait(0)
            DisableControlAction(0, 75, true) -- INPUT_VEH_EXIT
        end
    end)

    -- Show menu
    RageUI.Visible(MainLSCustomsMenu, true)
end
RegisterNetEvent("ava_stores:client:OpenLSCustoms", OpenLSCustomsMenu)

MainLSCustomsMenu.Closed = function()
    exports.ava_core:SetVehicleModsData(CurrentVehicleData.vehicle, CurrentVehicleData.modsdata)
    if MenuDepth == 1 then
        -- We went back to the start of the menu, close the menu
        MainLSCustomsMenu.Parent = nil
        CloseLSCustomsMenu()
    else
        -- We went back to a previous menu, go back to that menu
        PrepareMenuElements(nil)
    end
end

---Check whether an element can be added to the menu or not
---@param element table
---@return boolean
local function ShouldAddElementToMenu(element)
    if element.mod and Config.LSCustoms.Mods[element.mod] then
        -- Element is a mod, check if it has things that can be modified
        local modCfg<const> = Config.LSCustoms.Mods[element.mod]
        if modCfg.type == "mod" then
            return GetNumVehicleMods(CurrentVehicleData.vehicle, modCfg.mod) > 0
        elseif modCfg.type == "livery" then
            return GetVehicleLiveryCount(CurrentVehicleData.vehicle) > 0
        elseif modCfg.type == "extras" then
            -- Check if an extra exist
            for i = 0, 14 do
                if DoesExtraExist(CurrentVehicleData.vehicle, i) then
                    return true
                end
            end
            return false
        end
        return true

    elseif element.menu then
        -- Element has a submenu, check if some elements inside of it can be modified
        for i = 1, #element.menu do
            -- Recursive call
            if ShouldAddElementToMenu(element.menu[i]) then
                return true
            end
        end
    end
    return false
end

---Will prepare the menu elements of the next sub menu
---@param data? table|string|nil
---@param newSubtitle string|nil
PrepareMenuElements = function(data, newSubtitle)
    if data then
        -- We prepare the next sub menu
        if MenuDepth then
            -- Save current menu data
            MenuElements[MenuDepth].Subtitle = MainLSCustomsMenu.Subtitle
            MenuElements[MenuDepth].PaginationMinimum = MainLSCustomsMenu.Pagination.Minimum
            MenuElements[MenuDepth].PaginationMaximum = MainLSCustomsMenu.Pagination.Maximum
            MenuElements[MenuDepth].Index = MainLSCustomsMenu.Index

            MenuDepth = MenuDepth + 1
        else
            MenuDepth = 1
        end

        if newSubtitle then
            MainLSCustomsMenu.Subtitle = newSubtitle
        end

        local count = 0
        MenuElements[MenuDepth] = {elements = {}}

        if type(data) == "table" then
            -- Submenu is a menu of elements
            for i = 1, #data do
                local element<const> = data[i]
                if ShouldAddElementToMenu(element) then
                    count = count + 1
                    MenuElements[MenuDepth].elements[count] = {
                        label = element.label,
                        menu = element.menu,
                        mod = element.mod,
                    }
                end
            end

        elseif type(data) == "string" then
            if Config.LSCustoms.Mods[data] then
                -- Submenu is a menu of mods
                local modCfg<const> = Config.LSCustoms.Mods[data]
                --#region Prepare mod menu
                if modCfg.type == "mod" then
                    -- Is a normal mod, iterate through all mods
                    local currentMod<const> = GetVehicleMod(CurrentVehicleData.vehicle, modCfg.mod)

                    -- Add default mod
                    count = count + 1
                    MenuElements[MenuDepth].elements[count] = {
                        label = GetString("lscustoms_default"),
                        modName = data,
                        value = -1,
                        price = CurrentLSCustoms and 0,
                        default = true,
                        rightBadgeName = (-1 == currentMod) and "Car" or "Tick",
                    }

                    for i = 0, GetNumVehicleMods(CurrentVehicleData.vehicle, modCfg.mod) - 1 do
                        local label
                        if modCfg.displayAsLevels then
                            label = GetString("lscustoms_level", i + 1)
                        else
                            local name = GetModTextLabel(CurrentVehicleData.vehicle, modCfg.mod, i)
                            if name then
                                label = GetLabelText(name)
                                if label == "NULL" then
                                    label = newSubtitle and GetString("lscustoms_mod_name_number", newSubtitle, i + 1) or GetString("lscustoms_mod_number", i + 1)
                                end
                            end
                        end

                        if label then
                            count = count + 1
                            local isCurrent<const> = i == currentMod and true or nil
                            local price = nil
                            -- Price only if we are in the context of a shop
                            if CurrentLSCustoms then
                                price = modCfg.staticPrice or math.floor(CurrentVehicleData.price * modCfg.priceMultiplier + 0.5)
                            end

                            MenuElements[MenuDepth].elements[count] = {
                                label = label,
                                modName = data,
                                value = i,
                                rightBadgeName = isCurrent and "Car" ,
                                price = price,
                                rightLabel = price and GetString("lscustoms_price_format", exports.ava_core:FormatNumber(price))
                            }
                        end
                    end

                elseif modCfg.type == "toggle" then
                    local IsOn<const> = IsToggleModOn(CurrentVehicleData.vehicle, modCfg.mod)
                    -- Add the disable button
                    count = count + 1
                    MenuElements[MenuDepth].elements[count] = {
                        label = GetString("lscustoms_disable"),
                        modName = data,
                        value = false,
                        default = true,
                        rightBadgeName = not IsOn and "Car" or "Tick",
                    }

                    -- Add the enable button
                    local price = nil
                    -- Price only if we are in the context of a shop
                    if CurrentLSCustoms then
                        price = modCfg.staticPrice or math.floor(CurrentVehicleData.price * modCfg.priceMultiplier + 0.5)
                    end
                    count = count + 1
                    MenuElements[MenuDepth].elements[count] = {
                        label = GetString("lscustoms_enable"),
                        modName = data,
                        value = true,
                        price = price,
                        rightBadgeName = IsOn and "Car",
                        rightLabel = price and GetString("lscustoms_price_format", exports.ava_core:FormatNumber(price))
                    }

                elseif modCfg.type == "color" then
                    -- TODO

                elseif modCfg.type == "wheels" then
                    -- TODO

                elseif modCfg.type == "horn" then
                    -- TODO

                elseif modCfg.type == "neon" then
                    -- TODO

                end
                --#endregion Prepare mod menu
            else
                print("^8[LSCustoms] Mod \"" .. data .. "\" is missing from Config.LSCustoms.Mods^0")
            end
        end

        -- Reset menu index
        Citizen.CreateThread(function()
            -- Wait a frame for the menu to be switched
            Wait(0)
            MainLSCustomsMenu:ResetIndex()
        end)
    else
        -- Go back from one in depth, remove all elements at that depth
        MenuElements[MenuDepth] = nil
        MenuDepth = MenuDepth - 1

        -- Resume the menu data
        if MenuElements[MenuDepth] and MenuElements[MenuDepth].Subtitle then
            Citizen.CreateThread(function()
                -- Wait a frame for the menu to be switched
                Wait(0)
                MainLSCustomsMenu.Subtitle = MenuElements[MenuDepth].Subtitle
                MainLSCustomsMenu.Pagination.Minimum = MenuElements[MenuDepth].PaginationMinimum
                MainLSCustomsMenu.Pagination.Maximum = MenuElements[MenuDepth].PaginationMaximum
                MainLSCustomsMenu.Index = MenuElements[MenuDepth].Index
                MainLSCustomsMenu.NewIndex = MenuElements[MenuDepth].Index
            end)
        end
    end
end

---Apply element to vehicle
---@param name string
---@param value any
local function ApplyElement(name, value)
    local data = {}
    data[name] = value

    -- Specific cases
    if name == "tyreSmokeColor" then
        data.modSmokeEnabled = true
    end

    exports.ava_core:SetVehicleModsData(CurrentVehicleData.vehicle, data)
end

---Reload the current menu elements to match the new value
---@param value any
ReloadCurrentMenuWithValue = function(value)
    local elements<const> = MenuElements[MenuDepth]?.elements
    if elements then
        for i = 1, #elements do
            if elements[i]?.value ~= nil then
                elements[i].rightBadgeName = elements[i].value == value and "Car" or (elements[i].default and "Tick")
            end
        end
    end
end

function RageUI.PoolMenus:LSCustomsMenu()
    MainLSCustomsMenu:IsVisible(function(Items)
        DisableControlAction(0, 22, true) -- INPUT_JUMP
        if IsDisabledControlJustReleased(0, 22) then
            ToggleVehicleDoors()
        end

        local elements<const> = MenuElements[MenuDepth]?.elements
        if elements then
            for i = 1, #elements do
                local element<const> = elements[i]
                if element then
                    local hasSubMenu<const> = element.menu or element.mod
                    Items:AddButton(element.label, element.desc,{
                        RightLabel = element.menu and "→→→" or element.rightLabel,
                        RightBadge = element.rightBadgeName and RageUI.BadgeStyle[element.rightBadgeName]
                    }, function(onSelected, onEnter)
                        if onEnter and element?.modName then
                            -- Apply element
                            ApplyElement(element.modName, element.value)

                        elseif onSelected then
                            if element.menu or element.mod then
                                -- Submenu
                                PrepareMenuElements(element.menu or element.mod, element.label)
                            else
                                -- Validate element
                                local modsdata = exports.ava_core:GetVehicleModsData(CurrentVehicleData.vehicle)

                                -- Prevent player from moving in the menu while he pays
                                MainLSCustomsMenu.Controls.Back.Enabled = false
                                MainLSCustomsMenu.Controls.Select.Enabled = false
                                
                                -- Thread to prevent the menu from freezing
                                Citizen.CreateThread(function ()
                                    if exports.ava_core:TriggerServerCallback("ava_stores:server:payLSCustoms", element.modName) then
                                        ReloadCurrentMenuWithValue(element.value)
                                        CurrentVehicleData.modified = true
                                        CurrentVehicleData.modsdata = modsdata
                                        exports.ava_core:ShowNotification(GetString("lscustoms_element_applied"))
                                    end
                                    -- Bring back controls
                                    MainLSCustomsMenu.Controls.Back.Enabled = true
                                    MainLSCustomsMenu.Controls.Select.Enabled = true
                                end)
                            end
                        end
                    end, hasSubMenu and MainLSCustomsMenu)
                end
            end
        end
    end)
end

---Toggle vehicle doors
ToggleVehicleDoors = function()
    CurrentVehicleData.doorsOpened = not CurrentVehicleData.doorsOpened
    if CurrentVehicleData.doorsOpened then
        for i = 0, 8 do
            SetVehicleDoorOpen(CurrentVehicleData.vehicle, i, false, false)
        end
    else
        SetVehicleDoorsShut(CurrentVehicleData.vehicle, false)
    end
end