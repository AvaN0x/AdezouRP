-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
MiscsSubMenu = RageUI.CreateSubMenu(MainPersonalMenu, "", GetString("miscs_menu"))

local isHudActive, isBigMapActive, isCinematicModeActive = true, false, false

local function SetHudActive(state)
    TriggerEvent("ava_hud:client:toggle", state)
    DisplayRadar(state)
end

local function SetCinematicModeActive()
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
        Items:CheckBox(GetString("miscs_menu_toggle_cinematic_mode"), GetString("miscs_menu_toggle_cinematic_mode_subtitle"), isCinematicModeActive, nil,
            function(onSelected, IsChecked)
                if (onSelected) then
                    isCinematicModeActive = not isCinematicModeActive
                    SetCinematicModeActive()
                    if isCinematicModeActive then
                        SetHudActive(false)
                    else
                        SetHudActive(isHudActive)
                    end
                end
            end)
    end)
end

