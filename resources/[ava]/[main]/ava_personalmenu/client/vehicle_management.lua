-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
VehiclesManagementSubMenu = RageUI.CreateSubMenu(MainPersonalMenu, "", GetString("vehicle_management"))
local speedLimitIndex = 1

local Speeds = {
    {
        speed = -1,
        Name = GetString("disabled")
    },
    {
        speed = 50,
        Name = 50
    },
    {
        speed = 90,
        Name = 90
    },
    {
        speed = 130,
        Name = 130
    }
}

function PoolVehicleManagement()
    VehiclesManagementSubMenu:IsVisible(function(Items)
        if playerVehicle == 0 then
            RageUI.GoBack()
        else
            local data = playerVehicleData
            if data then
                if data.playerSeat == -1 then
                    Items:AddList(GetString("vehicle_management_speed_limit"), Speeds, speedLimitIndex, GetString("vehicle_management_speed_limit_subtitle"), nil, function(Index, onSelected, onListChange)
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
                    
                    Items:CheckBox(GetString("vehicle_management_is_engine_on"), GetString("vehicle_management_is_engine_on_subtitle"), data.isEngineOn, nil, function(onSelected, IsChecked)
                        if (onSelected) then
                            SetVehicleEngineOn(playerVehicle, IsChecked, false, true)
                            SetVehicleUndriveable(playerVehicle, not IsChecked)
                            
                            data.isEngineOn = GetIsVehicleEngineRunning(playerVehicle)
                        end
                    end)
                end
                
                
            end
        end
    end)
end