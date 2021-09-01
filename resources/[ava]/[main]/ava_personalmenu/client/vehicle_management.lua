-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
VehiclesManagementSubMenu = RageUI.CreateSubMenu(MainPersonalMenu, "", GetString("vehicle_management"))
local Speeds<const> = {{speed = -1, Name = GetString("disabled")}, {speed = 50, Name = 50}, {speed = 90, Name = 90}, {speed = 130, Name = 130}}
local speedLimitIndex = 1

local WindowsList<const> = {{0, "front_left"}, {1, "front_right"}, {2, "back_left"}, {3, "back_right"}}
local WindowsRollList<const> = {{type = "down", Name = GetString("window_roll_down")}, {type = "up", Name = GetString("window_roll_up")}}
local windowsRollIndex = 1
local function ListWindowHandler(Index, onSelected, onListChange, windowIndex)
    if onListChange then
        windowsRollIndex = Index
    end
    if onSelected then
        local rollType = WindowsRollList[windowsRollIndex] and WindowsRollList[windowsRollIndex].type
        if rollType == "up" then
            RollUpWindow(playerVehicle, windowIndex)
        elseif rollType == "down" then
            RollDownWindow(playerVehicle, windowIndex)
        end
    end
end

local DoorsToggleList<const> = {{type = "open", Name = GetString("door_open")}, {type = "close", Name = GetString("door_close")}}
local doorsToggleIndex = 1
local function ListDoorHandler(Index, onSelected, onListChange, doorIndex)
    if onListChange then
        doorsToggleIndex = Index
    end
    if onSelected then
        local rollType = DoorsToggleList[doorsToggleIndex] and DoorsToggleList[doorsToggleIndex].type
        if rollType == "close" then
            SetVehicleDoorShut(playerVehicle, doorIndex, false, false)
        elseif rollType == "open" then
            SetVehicleDoorOpen(playerVehicle, doorIndex, false, false)
        end
    end
end

function OnVehiclesManagementSubMenuOpened()
    windowsRollIndex = 1
    doorsToggleIndex = 1
    VehiclesManagementSubMenu.Index = 1
end
function PoolVehicleManagement()
    VehiclesManagementSubMenu:IsVisible(function(Items)
        local data = playerVehicleData
        if playerVehicle == 0 or data.playerSeat == 2 then
            RageUI.GoBack()
        else
            if data then
                if data.playerSeat == -1 then
                    -- ped is driver

                    Items:AddList(GetString("vehicle_management_speed_limit"), Speeds, speedLimitIndex, GetString("vehicle_management_speed_limit_subtitle"),
                        nil, function(Index, onSelected, onListChange)
                            if onListChange then
                                speedLimitIndex = Index
                            end
                            if onSelected then
                                local speed = Speeds[speedLimitIndex] and Speeds[speedLimitIndex].speed
                                if speed then
                                    TriggerEvent("teb_speed_control:setSpeedLimiter", speed)
                                end
                            end
                        end)

                    Items:CheckBox(GetString("vehicle_management_is_engine_on"), GetString("vehicle_management_is_engine_on_subtitle"), data.isEngineOn, nil,
                        function(onSelected, IsChecked)
                            if (onSelected) then
                                SetVehicleEngineOn(playerVehicle, IsChecked, false, true)
                                SetVehicleUndriveable(playerVehicle, not IsChecked)

                                data.isEngineOn = GetIsVehicleEngineRunning(playerVehicle)
                            end
                        end)

                    if playerVehicleData.class ~= 13 and playerVehicleData.class ~= 8 then
                        if #playerVehicleData.doors > 0 then
                            Items:AddSeparator(GetString("vehicle_management_doors"))
                            for i = 1, #playerVehicleData.doors do
                                local door = playerVehicleData.doors[i]
                                Items:AddList(GetString("vehicle_management_doors_" .. door[2]), DoorsToggleList, doorsToggleIndex,
                                    GetString("vehicle_management_doors_" .. door[2] .. "_subtitle"), nil, function(Index, onSelected, onListChange)
                                        ListDoorHandler(Index, onSelected, onListChange, door[1])
                                    end)

                            end
                        end

                        Items:AddSeparator(GetString("vehicle_management_windows"))
                        for i = 1, #WindowsList do
                            local window = WindowsList[i]
                            Items:AddList(GetString("vehicle_management_windows_" .. window[2]), WindowsRollList, windowsRollIndex,
                                GetString("vehicle_management_windows_" .. window[2] .. "_subtitle"), nil, function(Index, onSelected, onListChange)
                                    ListWindowHandler(Index, onSelected, onListChange, window[1])
                                end)

                        end

                    end
                elseif data.playerSeat == 0 then
                    -- ped is in passenger seat

                    Items:AddButton(GetString("personal_menu_enable_shuffle"), GetString("personal_menu_enable_shuffle_subtitle"), {}, function(onSelected)
                        if onSelected then
                            SetPedConfigFlag(PlayerPedId(), 184, false) -- CPED_CONFIG_FLAG_PreventAutoShuffleToDriversSeat 
                        end
                    end)
                end
            end
        end
    end)
end

AddEventHandler("baseevents:enteredVehicle", function()
    SetPedConfigFlag(PlayerPedId(), 184, true) -- CPED_CONFIG_FLAG_PreventAutoShuffleToDriversSeat
end)
