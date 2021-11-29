-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
MiscsSubMenu = RageUI.CreateSubMenu(MainPersonalMenu, "", GetString("miscs_menu"))

local isHudActive, isBigMapActive, isCinematicModeActive = true, false, false
local isDriftModeActive = GetResourceKvpInt("miscs_menu_drift_mode") ~= 0

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
        Items:CheckBox(GetString("miscs_menu_toggle_drift_mode"), GetString("miscs_menu_toggle_drift_mode_subtitle"), isDriftModeActive, nil,
            function(onSelected, IsChecked)
                if (onSelected) then
                    if isDriftModeActive and isDriftModeEquipied and actualVehicle ~= 0 then
                        SetDriftTyresEnabled(actualVehicle, false)
                        print("Drift mode disabled") -- TODO Remove this line, for debug only
                        isDriftModeEquipied = false
                    end
                    isDriftModeActive = not isDriftModeActive
                    SetResourceKvpInt("miscs_menu_drift_mode", isDriftModeActive and 1 or 0)
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

local actualVehicle = 0
local isDriftModeEquipied = false
AddEventHandler("ava_core:client:enteredVehicle", function(vehicle)
    actualVehicle = vehicle
end)
AddEventHandler("ava_core:client:leftVehicle", function(vehicle)
    if isDriftModeActive and isDriftModeEquipied then
        SetDriftTyresEnabled(vehicle, false)
        print("Drift mode disabled") -- TODO Remove this line, for debug only
        isDriftModeEquipied = false
    end
    actualVehicle = 0
end)

RegisterCommand("+keyDriftMode", function()
    if isDriftModeActive then
        if actualVehicle ~= 0 then
            SetDriftTyresEnabled(actualVehicle, true)
            print("Drift mode enabled") -- TODO Remove this line, for debug only
            isDriftModeEquipied = true
        end
    end
end, false)

RegisterCommand("-keyDriftMode", function()
    if isDriftModeActive then
        if actualVehicle ~= 0 then
            SetDriftTyresEnabled(actualVehicle, false)
            print("Drift mode disabled") -- TODO Remove this line, for debug only
            isDriftModeEquipied = false
        end
    end
end, false)

RegisterKeyMapping("+keyDriftMode", GetString("miscs_menu_toggle_drift_mode_key"), "keyboard", "LSHIFT")
