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

    local vehicles
    -- local playerVehicles = exports.ava_core:TriggerServerCallback("ava_garages:server:getVehiclesInGarage", garage.Name, garage.VehicleType) or {}
    if CurrentGarage.IsJobGarage then
        print("is job garage")
        vehicles = exports.ava_core:TriggerServerCallback("ava_garages:server:getAccessibleVehiclesInJobGarage", CurrentGarage.Name, CurrentGarage.IsJobGarage,
            CurrentGarage.VehicleType) or {}
    elseif CurrentGarage.IsCommonGarage then
        print("is common garage")
        vehicles = exports.ava_core:TriggerServerCallback("ava_garages:server:getAccessibleVehiclesInCommonGarage", CurrentGarage.Name,
            CurrentGarage.VehicleType) or {}
    else
        print("is public garage")
        vehicles = exports.ava_core:TriggerServerCallback("ava_garages:server:getAccessibleVehiclesInGarage", CurrentGarage.Name, CurrentGarage.VehicleType)
                       or {}
    end
    print("vehicles", json.encode(vehicles, {indent = true}))

    local count = 0
    MenuElements = {}
    for i = 1, #vehicles do
        local vehicle = vehicles[i]
        count = count + 1
        local element = {label = vehicle.label, id = vehicle.id}
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
                    end
                end)
        end
        if MenuElements then
            for i = 1, #MenuElements do
                local element = MenuElements[i]
                if element then
                    if element.disabled then
                        Items:AddButton(element.label, element.desc, {IsDisabled = true})
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
                                    print("rename") -- TODO
                                end
                            end
                        end)
                    end
                end
            end

        end
    end)
end
