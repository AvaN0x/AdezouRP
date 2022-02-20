-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local CurrentGarage = nil
local MenuElements = {}

local vehicleListOptions<const> = { { Name = GetString("garage_take_out"), action = "take_out" }, { Name = GetString("garage_rename"), action = "rename" } }
local MainGarageMenu = RageUI.CreateMenu("", GetString("garage_menu"), 0, 0, "avaui", "avaui_title_adezou")
MainGarageMenu.Closed = function()
    CurrentGarage = nil
    MenuElements = {}
    CurrentActionEnabled = true
end

function OpenGarageMenu(garage)
    if not garage or not exports.ava_core:canOpenMenu() then
        return
    end
    CurrentGarage = garage

    local isInVehicle, vehicle, seat = exports.ava_core:IsPlayerInVehicle()
    if not isInVehicle and not CurrentGarage.DisableTakeOut then
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

            local element = { label = vehicle.label, id = vehicle.id, data = vehicle.data, plate = vehicle.plate, model = vehicle.model, canRename = canRename }
            if not vehicle.parked then
                element.desc = GetString("garage_menu_not_parked")
                element.disabled = true
            elseif vehicle.garage ~= CurrentGarage.Name then
                element.desc = GetString("garage_menu_not_in_this_garage")
                element.disabled = true
            else
                local vehicleName = "unknown"
                local vehicleHash = GetHashKey(vehicle.model)
                if IsModelInCdimage(vehicleHash) then
                    local vehicleDisplayName = GetDisplayNameFromVehicleModel(vehicleHash)
                    vehicleName = GetLabelText(vehicleDisplayName)
                    if vehicleName == "NULL" then
                        vehicleName = vehicleDisplayName
                    end
                end
                element.desc = GetString("garage_menu_parked", vehicleName, vehicle.plate, 100.0)
            end
            MenuElements[count] = element
        end

        table.sort(MenuElements, function(a, b)
            return a.label:lower() < b.label:lower()
        end)
    end

    RageUI.CloseAll()
    MainGarageMenu:ResetIndex()
    RageUI.Visible(MainGarageMenu, true)
end

AddEventHandler("ava_core:client:canOpenMenu", function()
    if CurrentGarage then
        CancelEvent()
    end
end)


RegisterNetEvent("ava_garages:client:setVehicleData", function(vehicleNet, modsData, healthData)
    local vehicle = NetToVeh(vehicleNet)
    if vehicle > 0 then
        exports.ava_core:SetVehicleModsData(vehicle, json.decode(modsData))
        exports.ava_core:SetVehicleHealthData(vehicle, json.decode(healthData))
    end
end)

function RageUI.PoolMenus:GarageMenu()
    MainGarageMenu:IsVisible(function(Items)
        if not CurrentGarage then
            return
        end
        if not CurrentGarage.DisablePark then
            Items:AddButton(GetString("garage_park_vehicle"), GetString("garage_park_vehicle_subtitle"), { RightBadge = RageUI.BadgeStyle.Car },
                function(onSelected)
                    if onSelected then
                        local isInVehicle, vehicle, seat = exports.ava_core:IsPlayerInVehicle()
                        if isInVehicle and seat == -1 then
                            TriggerServerEvent("ava_garages:server:parkVehicle", CurrentGarage.Name, VehToNet(vehicle),
                                json.encode(exports.ava_core:GetVehicleHealthData(vehicle) or {}), CurrentGarage.IsJobGarage, CurrentGarage.IsCommonGarage)
                            RageUI.CloseAllInternal()
                        else
                            exports.ava_core:ShowNotification(GetString("garage_park_vehicle_need_in_vehicle"))
                        end
                    end
                end)
        end
        if MenuElements then
            for i = 1, #MenuElements do
                local element = MenuElements[i]
                if element then
                    if element.disabled then
                        Items:AddButton(element.label, element.desc, { IsDisabled = true })
                    elseif not element.canRename then
                        Items:AddButton(element.label, element.desc, { RightLabel = GetString("garage_take_out") }, function(onSelected)
                            if onSelected then
                                if not canTakeOutVehicle(CurrentGarage) then return end
                                takeOutVehicle(CurrentGarage, element.model, element.id)
                                RageUI.CloseAllInternal()
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
                                    if not canTakeOutVehicle(CurrentGarage) then return end
                                    takeOutVehicle(CurrentGarage, element.model, element.id)
                                    RageUI.CloseAllInternal()

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

RegisterNetEvent("ava_core:client:savevehicledata", function()
    local isInVehicle, vehicle, seat = exports.ava_core:IsPlayerInVehicle()
    if isInVehicle and seat == -1 then
        TriggerServerEvent("ava_core:server:savevehicledata", VehToNet(vehicle), json.encode(exports.ava_core:GetVehicleModsData(vehicle) or {}),
            json.encode(exports.ava_core:GetVehicleHealthData(vehicle) or {}))
    end
end)
