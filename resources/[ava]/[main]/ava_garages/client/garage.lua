-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local CurrentGarage = nil
local MenuElements = nil

local vehicleListOptions<const> = {{Name = GetString("garage_take_out"), action = "take_out"}, {Name = GetString("garage_rename"), action = "rename"}}
local MainGarageMenu = RageUI.CreateMenu("", GetString("garage_menu"), 0, 0, "avaui", "avaui_title_adezou")
MainGarageMenu.Closed = function()
    CurrentGarage = nil
    GarageVehicles = nil
    CurrentActionEnabled = true
end

function OpenGarageMenu(garage)
    if not garage or not exports.ava_core:canOpenMenu() then
        return
    end
    CurrentGarage = garage

    local isInVehicle, vehicle, seat = exports.ava_core:IsPlayerInVehicle()
    if not isInVehicle then
        local vehicles
        local canRename = true
        if CurrentGarage.IsJobGarage then
            vehicles = exports.ava_core:TriggerServerCallback("ava_garages:server:getAccessibleVehiclesInJobGarage", CurrentGarage.Name,
                CurrentGarage.IsJobGarage, CurrentGarage.VehicleType) or {}
            canRename = CurrentGarage.canManage
        elseif CurrentGarage.IsCommonGarage then
            vehicles = exports.ava_core:TriggerServerCallback("ava_garages:server:getAccessibleVehiclesInCommonGarage", CurrentGarage.Name,
                CurrentGarage.VehicleType) or {}
        else
            vehicles = exports.ava_core:TriggerServerCallback("ava_garages:server:getAccessibleVehiclesInGarage", CurrentGarage.Name, CurrentGarage.VehicleType)
                           or {}
        end

        local count = 0
        MenuElements = {}
        for i = 1, #vehicles do
            local vehicle = vehicles[i]
            count = count + 1

            -- can_rename is only fetched if the garage is a common garage
            if CurrentGarage.IsCommonGarage then
                canRename = vehicle.can_rename == 1
            end

            local element = {label = vehicle.label, id = vehicle.id, canRename = canRename}
            if not vehicle.parked then
                element.desc = GetString("garage_menu_not_parked")
                element.disabled = true
            elseif vehicle.garage ~= CurrentGarage.Name then
                element.desc = GetString("garage_menu_not_in_this_garage")
                element.disabled = true
            else
                element.desc = GetString("garage_menu_parked", vehicle.plate, 100.0)
            end
            MenuElements[count] = element
        end
    end

    RageUI.CloseAll()
    RageUI.Visible(MainGarageMenu, true)
end

AddEventHandler("ava_core:client:canOpenMenu", function()
    if CurrentGarage then
        CancelEvent()
    end
end)

function RageUI.PoolMenus:GarageMenu()
    MainGarageMenu:IsVisible(function(Items)
        if not CurrentGarage then
            return
        end
        if not CurrentGarage.OnlyTakeOut then
            Items:AddButton(GetString("garage_park_vehicle"), GetString("garage_park_vehicle_subtitle"), {RightBadge = RageUI.BadgeStyle.Car},
                function(onSelected)
                    if onSelected then
                        print("park vehicle") -- TODO
                        RageUI.CloseAllInternal()
                    end
                end)
        end
        if MenuElements then
            for i = 1, #MenuElements do
                local element = MenuElements[i]
                if element then
                    if element.disabled then
                        Items:AddButton(element.label, element.desc, {IsDisabled = true})
                    elseif not element.canRename then
                        Items:AddButton(element.label, element.desc, {RightLabel = GetString("garage_take_out")}, function(onSelected)
                            if onSelected then
                                print("take_out") -- TODO
                            end
                        end)
                    else
                        Items:AddList(element.label, vehicleListOptions, element.indice or 1, element.desc, nil, function(Index, onSelected, onListChange)
                            if onListChange then
                                MenuElements[i].indice = Index
                            end
                            if onSelected then
                                local action = vehicleListOptions[element.indice or 1].action
                                if action == "take_out" then
                                    print("take_out") -- TODO

                                elseif action == "rename" then
                                    local label = exports.ava_core:KeyboardInput(GetString("garage_rename_input_label"), element.label, 50)

                                    -- check if label is valid
                                    if not label or label == "" or label:len() < 2 then
                                        exports.ava_core:ShowNotification(GetString("garage_rename_invalid_label"))
                                    elseif exports.ava_core:TriggerServerCallback("ava_garages:server:renameVehicle", element.id, label) then
                                        exports.ava_core:ShowNotification(GetString("garage_rename_success"))
                                        MenuElements[i].label = label
                                    else
                                        exports.ava_core:ShowNotification(GetString("garage_rename_error"))
                                    end
                                end
                            end
                        end)
                    end
                end
            end

        end
    end)
end
