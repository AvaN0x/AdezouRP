-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local CloseLSCustomsMenu, PrepareMenuElements, ToggleVehicleDoors, ReloadCurrentMenuWithValue, ValuesDeepEquals
local HardcodedLists

--- Menu Depth is used to keep track of how many layers/menus we're in
local MenuDepth = nil
local MenuElements = nil

local CurrentLSCustoms = nil
local CurrentLSCustomsName = nil
local CurrentJobToPay = nil
local CurrentVehicleData = nil

function LSCustoms()
    local store = Config.Stores[CurrentZoneName]
    if not store or not exports.ava_core:canOpenMenu() then return end

    CurrentLSCustomsName = CurrentZoneName
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
    CurrentLSCustomsName = nil
    CurrentJobToPay = nil
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

OpenLSCustomsMenu = function(store, jobToPay)
    -- Check if the player is in a vehicle and is the driver
    local isInVehicle, vehicle, seat = exports.ava_core:IsPlayerInVehicle()
    if not isInVehicle or seat ~= -1 then
        exports.ava_core:ShowNotification(GetString("lscustoms_not_in_vehicle_or_driver"))
        CurrentActionEnabled = true
        return
    end

    local vehiclePrice, vehicleName = GetVehiclePriceFromModel(GetEntityModel(vehicle))
    print(vehiclePrice, vehicleName)

    -- Check vehicle health
    if GetVehicleBodyHealth(vehicle) < Config.LSCustoms.MinimumBodyHealth or GetVehicleEngineHealth(vehicle) < Config.LSCustoms.MinimumEngineHealth then
        exports.ava_core:ShowNotification(GetString("lscustoms_vehicle_damaged"))
        CurrentActionEnabled = true
        return
    end

    RageUI.CloseAll()

    -- Set menu title and banner
    MainLSCustomsMenu.Sprite.Dictionary = store?.Title?.textureDirectory or "avaui"
    MainLSCustomsMenu.Sprite.Texture = store?.Title?.textureName or "avaui_title_adezou"
    MainLSCustomsMenu.Subtitle = store?.Subtitle or GetString("lscustoms_menu")

    -- Initialize needed data for the menu
    CurrentLSCustoms = store
    CurrentJobToPay = Config.LSCustoms.AllowedJobsToPay[jobToPay] and jobToPay
    CurrentVehicleData = {
        vehicle = vehicle,
        modsdata = exports.ava_core:GetVehicleModsData(vehicle),
        modified = false,
        price = vehiclePrice,
        totalSpent = 0,
        totalSpentStr = "0",
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

            -- Draw total spent amount
            if CurrentLSCustoms and CurrentVehicleData.totalSpentStr then
                SetTextColour(255, 255, 255, 255)
                SetTextFont(0)
                SetTextScale(0.34, 0.34)
                SetTextRightJustify(true)
                SetTextWrap(0.76, 0.98)
                SetTextOutline()
                SetTextEntry("STRING")

                AddTextComponentSubstringPlayerName(GetString("lscustoms_total_spent", CurrentVehicleData.totalSpentStr or "0"))
                DrawText(0.80, 0.92)
            end
        end
    end)

    -- Show menu
    RageUI.Visible(MainLSCustomsMenu, true)
end
RegisterNetEvent("ava_stores:client:OpenLSCustoms", OpenLSCustomsMenu)
exports("OpenLSCustomsMenu", OpenLSCustomsMenu)

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
                        label = GetString("lscustoms_stock"),
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
                        elseif modCfg.mod == 14 then
                            label = HardcodedLists["horn"][i]
                            if not label then
                                label = GetString("lscustoms_horn_number", i + 1)
                            end
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
                                desc = (CurrentJobToPay and price) and GetString("lscustoms_job_pay_desc", exports.ava_core:FormatNumber(price),
                                    exports.ava_core:FormatNumber(math.floor(price * Config.LSCustoms.JobPartPaid + 0.5))),
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
                        desc = (CurrentJobToPay and price) and GetString("lscustoms_job_pay_desc", exports.ava_core:FormatNumber(price),
                            exports.ava_core:FormatNumber(math.floor(price * Config.LSCustoms.JobPartPaid + 0.5))),
                        modName = data,
                        value = true,
                        price = price,
                        rightBadgeName = IsOn and "Car",
                        rightLabel = price and GetString("lscustoms_price_format", exports.ava_core:FormatNumber(price))
                    }

                elseif modCfg.type == "list" then
                    local list<const> = HardcodedLists[modCfg.target]
                    local currentValue<const> = CurrentVehicleData.modsdata[data]

                    if list and currentValue then
                        for i = 1, #list do
                            local elt<const> = list[i]

                            local isCurrent<const> = ValuesDeepEquals(elt.value, currentValue) and true or nil
                            local price = nil
                            -- Price only if we are in the context of a shop
                            if CurrentLSCustoms and not elt.default then
                                price = modCfg.staticPrice or math.floor(CurrentVehicleData.price * modCfg.priceMultiplier + 0.5)
                            end

                            count = count + 1
                            MenuElements[MenuDepth].elements[count] = {
                                label = elt.label,
                                desc = (CurrentJobToPay and price) and GetString("lscustoms_job_pay_desc", exports.ava_core:FormatNumber(price),
                                exports.ava_core:FormatNumber(math.floor(price * Config.LSCustoms.JobPartPaid + 0.5))),
                                modName = data,
                                value = elt.value,
                                default = elt.default,
                                rightBadgeName = isCurrent and "Car" or (elt.default and "Tick"),
                                price = price,
                                rightLabel = price and GetString("lscustoms_price_format", exports.ava_core:FormatNumber(price))
                            }
                        end
                    end

                elseif modCfg.type == "color" then
                    -- TODO

                elseif modCfg.type == "wheels" then
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
    if name == "neonColor" then
        data.neonEnabled = (value[1] == 0 and value[2] == 0 and value[3] == 0)
            and { false, false, false, false }
            or { true, true, true, true }
    elseif name == "tyreSmokeColor" then
        -- data.modSmokeEnabled = (value[1] ~= 255 and value[2] ~= 255 and value[3] ~= 255)
        data.modSmokeEnabled = true
        ToggleVehicleMod(CurrentVehicleData.vehicle, 20, data.modSmokeEnabled)
        print(json.encode(data))
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
                elements[i].rightBadgeName = ValuesDeepEquals(elements[i].value, value) and "Car" or (elements[i].default and "Tick")
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

                            elseif CurrentVehicleData.modsdata[element.modName] ~= element.value then
                                -- Validate element only if different from actual
                                local modsdata = exports.ava_core:GetVehicleModsData(CurrentVehicleData.vehicle)

                                -- Prevent player from moving in the menu while he pays
                                MainLSCustomsMenu.Controls.Back.Enabled = false
                                MainLSCustomsMenu.Controls.Select.Enabled = false

                                -- Thread to prevent the menu from freezing
                                Citizen.CreateThread(function ()
                                    if exports.ava_core:TriggerServerCallback("ava_stores:server:payLSCustoms", VehToNet(CurrentVehicleData.vehicle),
                                        element.modName, CurrentLSCustomsName, CurrentJobToPay)
                                    then
                                        ReloadCurrentMenuWithValue(element.value)
                                        CurrentVehicleData.modified = true
                                        CurrentVehicleData.modsdata = modsdata
                                        exports.ava_core:ShowNotification(GetString("lscustoms_element_applied"))

                                        -- Reload informations about total spent
                                        CurrentVehicleData.totalSpent = CurrentVehicleData.totalSpent + (element.price or 0)
                                        CurrentVehicleData.totalSpentStr = exports.ava_core:FormatNumber(CurrentVehicleData.totalSpent)
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

---Check if two values are equals, can compare two tabless
---@param a any
---@param b any
---@return boolean
ValuesDeepEquals = function(a, b)
    if type(a) == "table" and type(b) == "table" then
        for k, v in pairs(a) do
            if not ValuesDeepEquals(v, b[k]) then
                return false
            end
        end
        return true
    else
        return a == b
    end
end

--#region Hardcoded lists
HardcodedLists = {}
HardcodedLists["xenon"] = {
    { value = 255, label = GetString("lscustoms_default"), default = true },
    { value = 0, label = GetLabelText("CMOD_NEONCOL_0") },
    { value = 1, label = GetLabelText("CMOD_NEONCOL_1") },
    { value = 2, label = GetLabelText("CMOD_NEONCOL_2") },
    { value = 3, label = GetLabelText("CMOD_NEONCOL_3") },
    { value = 4, label = GetLabelText("CMOD_NEONCOL_4") },
    { value = 5, label = GetLabelText("CMOD_NEONCOL_5") },
    { value = 6, label = GetLabelText("CMOD_NEONCOL_6") },
    { value = 7, label = GetLabelText("CMOD_NEONCOL_7") },
    { value = 8, label = GetLabelText("CMOD_NEONCOL_8") },
    { value = 9, label = GetLabelText("CMOD_NEONCOL_9") },
    { value = 10, label = GetLabelText("CMOD_NEONCOL_10") },
    { value = 11, label = GetLabelText("CMOD_NEONCOL_11") },
    { value = 12, label = GetLabelText("CMOD_NEONCOL_12") }
}

HardcodedLists["neon"] = {
    { value = {0, 0, 0}, label = GetString("lscustoms_disable"), default = true },
    { value = { 255, 255, 255 }, label = GetLabelText("CMOD_NEONCOL_0") },
    { value = { 2, 21, 255 }, label = GetLabelText("CMOD_NEONCOL_1") },
    { value = { 3, 83, 255 }, label = GetLabelText("CMOD_NEONCOL_2") },
    { value = { 0, 255, 140 }, label = GetLabelText("CMOD_NEONCOL_3") },
    { value = { 94, 255, 1 }, label = GetLabelText("CMOD_NEONCOL_4") },
    { value = { 255, 255, 0 }, label = GetLabelText("CMOD_NEONCOL_5") },
    { value = { 255, 150, 5 }, label = GetLabelText("CMOD_NEONCOL_6") },
    { value = { 255, 62, 0 }, label = GetLabelText("CMOD_NEONCOL_7") },
    { value = { 255, 0, 0 }, label = GetLabelText("CMOD_NEONCOL_8") },
    { value = { 255, 50, 100 }, label = GetLabelText("CMOD_NEONCOL_9") },
    { value = { 255, 5, 190 }, label = GetLabelText("CMOD_NEONCOL_10") },
    { value = { 35, 1, 255 }, label = GetLabelText("CMOD_NEONCOL_11") },
    { value = { 15, 3, 255 }, label = GetLabelText("CMOD_NEONCOL_12") }
}

HardcodedLists["tyreSmokeColor"] = {
    { value = {254, 254, 254}, label = GetString("lscustoms_disable"), default = true },
    { value = { 244, 65, 65 }, label = GetString("lscustoms_color_red") },
    { value = { 244, 167, 66 }, label = GetString("lscustoms_color_orange") },
    { value = { 244, 217, 65 }, label = GetString("lscustoms_color_yellow") },
    { value = { 181, 120, 0 }, label = GetString("lscustoms_color_gold") },
    { value = { 158, 255, 84 }, label = GetString("lscustoms_color_light_green") },
    { value = { 44, 94, 5 }, label = GetString("lscustoms_color_dark_green") },
    { value = { 65, 211, 244 }, label = GetString("lscustoms_color_light_blue") },
    { value = { 24, 54, 163 }, label = GetString("lscustoms_color_dark_blue") },
    { value = { 108, 24, 192 }, label = GetString("lscustoms_color_purple") },
    { value = { 192, 24, 172 }, label = GetString("lscustoms_color_pink") },
    { value = { 1, 1, 1 }, label = GetString("lscustoms_color_black") }
}

HardcodedLists["horn"] = {
    [-1] = GetLabelText("CMOD_HRN_0"),
    [0] = GetLabelText("CMOD_HRN_TRK"),
    [1] = GetLabelText("CMOD_HRN_COP"),
    [2] = GetLabelText("CMOD_HRN_CLO"),
    [3] = GetLabelText("CMOD_HRN_MUS1"),
    [4] = GetLabelText("CMOD_HRN_MUS2"),
    [5] = GetLabelText("CMOD_HRN_MUS3"),
    [6] = GetLabelText("CMOD_HRN_MUS4"),
    [7] = GetLabelText("CMOD_HRN_MUS5"),
    [8] = GetLabelText("CMOD_HRN_SAD"),
    [9] = GetLabelText("HORN_CLAS1"),
    [10] = GetLabelText("HORN_CLAS2"),
    [11] = GetLabelText("HORN_CLAS3"),
    [12] = GetLabelText("HORN_CLAS4"),
    [13] = GetLabelText("HORN_CLAS5"),
    [14] = GetLabelText("HORN_CLAS6"),
    [15] = GetLabelText("HORN_CLAS7"),
    [16] = GetLabelText("HORN_CNOTE_C0"),
    [17] = GetLabelText("HORN_CNOTE_D0"),
    [18] = GetLabelText("HORN_CNOTE_E0"),
    [19] = GetLabelText("HORN_CNOTE_F0"),
    [20] = GetLabelText("HORN_CNOTE_G0"),
    [21] = GetLabelText("HORN_CNOTE_A0"),
    [22] = GetLabelText("HORN_CNOTE_B0"),
    [23] = GetLabelText("HORN_CNOTE_C1"),
    [24] = GetLabelText("HORN_HIPS1"),
    [25] = GetLabelText("HORN_HIPS2"),
    [26] = GetLabelText("HORN_HIPS3"),
    [27] = GetLabelText("HORN_HIPS4"),
    [28] = GetLabelText("HORN_INDI_1"),
    [29] = GetLabelText("HORN_INDI_2"),
    [30] = GetLabelText("HORN_INDI_3"),
    [31] = GetLabelText("HORN_INDI_4"),
    [32] = GetLabelText("HORN_LUXE2"),
    [33] = GetLabelText("HORN_LUXE1"),
    [34] = GetLabelText("HORN_LUXE3"),
    [35] = GetLabelText("HORN_LUXE2") .. " (2)", -- same as 32, but this one auto stop on first loop
    [36] = GetLabelText("HORN_LUXE1") .. " (2)", -- same as 33, but this one auto stop on first loop
    [37] = GetLabelText("HORN_LUXE3") .. " (2)", -- same as 34, but this one auto stop on first loop
    [38] = GetLabelText("HORN_HWEEN1"),
    [39] = GetLabelText("HORN_HWEEN1") .. " (2)", -- same as 38, but this one auto stop on first loop
    [40] = GetLabelText("HORN_HWEEN2"),
    [41] = GetLabelText("HORN_HWEEN2") .. " (2)", -- same as 40, but this one auto stop on first loop
    [42] = GetLabelText("HORN_LOWRDER1"),
    [43] = GetLabelText("HORN_LOWRDER1") .. " (2)", -- same as 43, but this one auto stop on first loop
    [44] = GetLabelText("HORN_LOWRDER2"),
    [45] = GetLabelText("HORN_LOWRDER2") .. " (2)", -- same as 44, but this one auto stop on first loop
    [46] = GetLabelText("HORN_XM15_1"),
    [47] = GetLabelText("HORN_XM15_1") .. " (2)", -- almost the same as 46, but this one auto stop on first loop
    [48] = GetLabelText("HORN_XM15_2"),
    [49] = GetLabelText("HORN_XM15_2") .. " (2)", -- almost the same as 48, but this one auto stop on first loop
    [50] = GetLabelText("HORN_XM15_3"),
    [51] = GetLabelText("HORN_XM15_3") .. " (2)", -- almost the same as 51, but this one auto stop on first loop
    [52] = GetLabelText("CMOD_AIRHORN_01"),
    [53] = GetLabelText("CMOD_AIRHORN_01") .. " (2)", -- same as 52, but this one auto stop on first loop
    [54] = GetLabelText("CMOD_AIRHORN_02"),
    [55] = GetLabelText("CMOD_AIRHORN_02") .. " (2)", -- same as 54, but this one auto stop on first loop
    [56] = GetLabelText("CMOD_AIRHORN_03"),
    [57] = GetLabelText("CMOD_AIRHORN_03") .. " (2)", -- same as 56, but this one auto stop on first loop
}

HardcodedLists["windowTint"] = {
    { value = 4, label = GetString("lscustoms_stock"), default = true },
    -- { value = 0, label = "None" },
    { value = 3, label = GetString("lscustoms_windowTint_lightsmoke") },
    { value = 2, label = GetString("lscustoms_windowTint_darksmoke") },
    { value = 1, label = GetString("lscustoms_windowTint_pureblack") },
    -- { value = 5, label = "Limo" },
    { value = 6, label = GetString("lscustoms_windowTint_green") }
}

HardcodedLists["plateIndex"] = {
    { value = 0, label = GetLabelText("CMOD_PLA_0") }, -- Blue on white 1
    { value = 3, label = GetLabelText("CMOD_PLA_1") }, -- Blue on white 2
    { value = 4, label = GetLabelText("CMOD_PLA_2") }, -- Blue on white 3
    { value = 1, label = GetLabelText("CMOD_PLA_4") }, -- Yellow on black
    { value = 2, label = GetLabelText("CMOD_PLA_3") }  -- Yellow on blue
}

--#endregion Hardcoded lists

