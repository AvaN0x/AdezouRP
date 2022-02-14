-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
MiscsSubMenu = RageUI.CreateSubMenu(MainPersonalMenu, "", GetString("miscs_menu"))

local isHudActive, isCinematicModeActive = true, false

local isDriftModeActive = GetResourceKvpInt("miscs_menu_drift_mode") ~= 0
local isIdleCamDisabled = GetResourceKvpInt("miscs_menu_disabled_idle_cam") ~= 0
local actualDriftVehicle, isDriftModeEquipied = 0, false

Citizen.CreateThread(function()
    DisableIdleCamera(isIdleCamDisabled)
end)

local function SetHudActive(state)
    TriggerEvent("ava_hud:client:toggle", state)
    DisplayRadar(state)
end

local function RefreshCinematicModeActive()
    if not isCinematicModeActive then
        return
    end

    Citizen.CreateThread(function()
        local function drawRects(alpha)
            DrawRect(0.0, 0.0, 2.0, 0.2, 0, 0, 0, alpha)
            DrawRect(0.0, 1.0, 2.0, 0.2, 0, 0, 0, alpha)
        end

        -- Fadein
        for i = 1, 255, 5 do
            drawRects(i)
            Wait(0)
        end

        -- Real loop
        while isCinematicModeActive do
            drawRects(255)
            Wait(0)
        end

        -- Fadeout
        for i = 255, 1, -5 do
            drawRects(i)
            Wait(0)
        end

    end)
end

function PoolMiscs()
    MiscsSubMenu:IsVisible(function(Items)
        Items:CheckBox(GetString("miscs_menu_toggle_hud"), GetString("miscs_menu_toggle_hud_subtitle"), isHudActive, {IsDisabled = isCinematicModeActive},
            function(onSelected, IsChecked)
                if (onSelected) then
                    isHudActive = not isHudActive
                    SetHudActive(isHudActive)
                end
            end)
        Items:CheckBox(GetString("miscs_menu_toggle_drift_mode"), GetString("miscs_menu_toggle_drift_mode_subtitle"), isDriftModeActive,
            {LeftBadge = RageUI.BadgeStyle.Car}, function(onSelected, IsChecked)
                if (onSelected) then
                    if isDriftModeActive and isDriftModeEquipied and actualDriftVehicle ~= 0 then
                        SetDriftTyresEnabled(actualDriftVehicle, false)
                        -- print("Drift mode disabled")
                        isDriftModeEquipied = false
                    end
                    isDriftModeActive = not isDriftModeActive
                    SetResourceKvpInt("miscs_menu_drift_mode", isDriftModeActive and 1 or 0)
                end
            end)
        Items:CheckBox(GetString("miscs_menu_toggle_disable_idle_cam"), GetString("miscs_menu_toggle_disable_idle_cam_subtitle"), isIdleCamDisabled, {},
            function(onSelected, IsChecked)
                if (onSelected) then
                    isIdleCamDisabled = not isIdleCamDisabled
                    SetResourceKvpInt("miscs_menu_disabled_idle_cam", isIdleCamDisabled and 1 or 0)
                    DisableIdleCamera(isIdleCamDisabled)
                end
            end)
        Items:CheckBox(GetString("miscs_menu_toggle_cinematic_mode"), GetString("miscs_menu_toggle_cinematic_mode_subtitle"), isCinematicModeActive, nil,
            function(onSelected, IsChecked)
                if (onSelected) then
                    isCinematicModeActive = not isCinematicModeActive
                    RefreshCinematicModeActive()
                    if isCinematicModeActive then
                        SetHudActive(false)
                    else
                        SetHudActive(isHudActive)
                    end
                end
            end)
    end)
end

------------------------------------
------------ Drift mode ------------
------------------------------------
local blacklistClasses<const> = {[8] = true, [13] = true, [14] = true, [15] = true, [16] = true, [19] = true, [21] = true}
-- 0: Compacts
-- 1: Sedans
-- 2: SUVs
-- 3: Coupes
-- 4: Muscle
-- 5: Sports Classics
-- 6: Sports
-- 7: Super
-- 8: Motorcycles
-- 9: Off-road
-- 10: Industrial
-- 11: Utility
-- 12: Vans
-- 13: Cycles
-- 14: Boats
-- 15: Helicopters
-- 16: Planes
-- 17: Service
-- 18: Emergency
-- 19: Military
-- 20: Commercial
-- 21: Trains

AddEventHandler("ava_core:client:enteredVehicle", function(vehicle)
    -- Only if ped is driver
    if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() and not blacklistClasses[GetVehicleClass(vehicle)] then
        actualDriftVehicle = vehicle
    else
        actualDriftVehicle = 0
    end
end)
AddEventHandler("ava_core:client:leftVehicle", function(vehicle)
    if isDriftModeActive and isDriftModeEquipied then
        SetDriftTyresEnabled(vehicle, false)
        -- print("Drift mode disabled")
        isDriftModeEquipied = false
    end
    actualDriftVehicle = 0
end)

RegisterCommand("+keyDriftMode", function()
    if isDriftModeActive then
        if actualDriftVehicle ~= 0 then
            SetDriftTyresEnabled(actualDriftVehicle, true)
            -- print("Drift mode enabled")
            isDriftModeEquipied = true
        end
    end
end, false)

RegisterCommand("-keyDriftMode", function()
    if isDriftModeActive then
        if actualDriftVehicle ~= 0 then
            SetDriftTyresEnabled(actualDriftVehicle, false)
            -- print("Drift mode disabled")
            isDriftModeEquipied = false
        end
    end
end, false)

RegisterKeyMapping("+keyDriftMode", GetString("miscs_menu_toggle_drift_mode_key"), "keyboard", "LSHIFT")
