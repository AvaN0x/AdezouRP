-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local DrawText3D = import("DrawText3D")

DevAdminMenu = RageUI.CreateSubMenu(MainAdminMenu, GetString("dev_menu"), GetString("dev_menu"))
DevAdminMenu.Display.Glare = true

local showhash, showcoordshelper, showcoords = false, false, false
local showhash_object = GetResourceKvpInt("showhash_object") == 0
local showhash_vehicle = GetResourceKvpInt("showhash_vehicle") == 0
local showhash_ped = GetResourceKvpInt("showhash_ped") == 0
local showhash_dimensions = GetResourceKvpInt("showhash_dimensions") == 0
local showhash_distance = 5

function PoolDevMenu()
    DevAdminMenu:IsVisible(function(Items)
        if perms and perms.dev then
            if perms.dev.showhash then
                Items:CheckBox(GetString("dev_menu_showhash"), GetString("dev_menu_showhash_subtitle"), showhash, nil,
                    function(onSelected, IsChecked)
                        if (onSelected) then
                            if not showhash_object and not showhash_vehicle and not showhash_ped then
                                showhash_object, showhash_vehicle, showhash_ped = true, true, true
                                SetResourceKvpInt("showhash_object", 0)
                                SetResourceKvpInt("showhash_vehicle", 0)
                                SetResourceKvpInt("showhash_ped", 0)
                            end
                            ExecuteCommand("showhash")
                        end
                    end)
                local style <const> = { IsDisabled = not showhash, Style = not showhash and 2 }
                Items:CheckBox(GetString("dev_menu_showhash_object"), GetString("dev_menu_showhash_object_subtitle"),
                    showhash_object, style,
                    function(onSelected, IsChecked)
                        if (onSelected) then
                            showhash_object = not showhash_object
                            SetResourceKvpInt("showhash_object", showhash_object and 0 or 1)

                            if showhash and not showhash_object and not showhash_vehicle and not showhash_ped then
                                showhash = false
                            end
                        end
                    end)
                Items:CheckBox(GetString("dev_menu_showhash_vehicle"), GetString("dev_menu_showhash_vehicle_subtitle"),
                    showhash_vehicle, style,
                    function(onSelected, IsChecked)
                        if (onSelected) then
                            showhash_vehicle = not showhash_vehicle
                            SetResourceKvpInt("showhash_vehicle", showhash_vehicle and 0 or 1)

                            if showhash and not showhash_object and not showhash_vehicle and not showhash_ped then
                                showhash = false
                            end
                        end
                    end)
                Items:CheckBox(GetString("dev_menu_showhash_ped"), GetString("dev_menu_showhash_ped_subtitle"),
                    showhash_ped, style,
                    function(onSelected, IsChecked)
                        if (onSelected) then
                            showhash_ped = not showhash_ped
                            SetResourceKvpInt("showhash_ped", showhash_ped and 0 or 1)

                            if showhash and not showhash_object and not showhash_vehicle and not showhash_ped then
                                showhash = false
                            end
                        end
                    end)
                Items:CheckBox(GetString("dev_menu_showhash_dimensions"),
                    GetString("dev_menu_showhash_dimensions_subtitle"), showhash_dimensions, style,
                    function(onSelected, IsChecked)
                        if (onSelected) then
                            showhash_dimensions = not showhash_dimensions
                            SetResourceKvpInt("showhash_dimensions", showhash_dimensions and 0 or 1)
                        end
                    end)
                Items:AddList(GetString("dev_menu_showhash_distance"), 16, showhash_distance,
                    GetString("dev_menu_showhash_distance_subtitle"), { Min = 4, IsDisabled = not showhash },
                    function(Index, onSelected, onListChange)
                        if (onListChange) then
                            showhash_distance = Index;
                        end
                    end)

            end
            if perms.dev.showcoordshelper then
                Items:CheckBox(GetString("dev_menu_showcoordshelper"), GetString("dev_menu_showcoordshelper_subtitle"),
                    showcoordshelper, nil,
                    function(onSelected, IsChecked)
                        if (onSelected) then
                            ExecuteCommand("showcoordshelper")
                        end
                    end)
            end
            if perms.dev.showcoords then
                Items:CheckBox(GetString("dev_menu_showcoords"), GetString("dev_menu_showcoords_subtitle"), showcoords,
                    nil, function(onSelected, IsChecked)
                    if (onSelected) then
                        ExecuteCommand("showcoords")
                    end
                end)
            end
        end
    end)
end

RegisterNetEvent("ava_personalmenu:client:toggleShowCoords", function()
    showcoords = not showcoords

    if not showcoords then
        return
    end

    Citizen.CreateThread(function()
        while showcoords do
            Wait(0)
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)

            SetTextColour(255, 255, 255, 255)
            SetTextFont(0)
            SetTextScale(0.34, 0.34)
            SetTextWrap(0.0, 1.0)
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentSubstringPlayerName("~o~X~s~\t\t" ..
                string.format("%.2f", playerCoords.x) .. "\n~o~Y~s~\t\t" .. string.format("%.2f", playerCoords.y)
                .. "\n~o~Z~s~\t\t" .. string.format("%.2f", playerCoords.z) .. "\n~o~Heading~s~\t"
                .. string.format("%.2f", GetEntityHeading(playerPed)))
            EndTextCommandDisplayText(0.9, 0.88)
        end
    end)
end)

RegisterNetEvent("ava_personalmenu:client:toggleShowCoordsHelper", function()
    showcoordshelper = not showcoordshelper

    if not showcoordshelper then
        return
    end

    local xAxis, yAxis, zAxis = 0, 0, 0
    Citizen.CreateThread(function()
        while showcoordshelper do
            local playerPed = PlayerPedId()

            AddTextEntry("show_coord_helper", GetString("dev_show_coord_helper_display_text"))
            BeginTextCommandDisplayHelp("show_coord_helper")
            EndTextCommandDisplayHelp(false, false, false, -1)

            -- INPUT_RELOAD
            DisableControlAction(0, 45, true) -- R
            DisableControlAction(0, 140, true) -- R

            -- SCROLLWHEEL PRESS
            DisableControlAction(0, 348, true)
            -- SCROLLWHEEL UP
            DisableControlAction(0, 15, true)
            DisableControlAction(0, 17, true)
            -- SCROLLWHEEL DOWN
            DisableControlAction(0, 14, true)
            DisableControlAction(0, 16, true)

            if IsControlPressed(0, 172) and yAxis < 2 then -- up
                yAxis = yAxis + 0.01
            elseif IsControlPressed(0, 173) and yAxis > -2 then -- down
                yAxis = yAxis - 0.01
            end
            if IsControlPressed(0, 174) and xAxis > -2 then -- left
                xAxis = xAxis - 0.01
            elseif IsControlPressed(0, 175) and xAxis < 2 then -- right
                xAxis = xAxis + 0.01
            end
            if IsDisabledControlPressed(0, 14) and zAxis > -2 then -- SCROLLWHEEL DOWN
                zAxis = zAxis - 0.02
            elseif IsDisabledControlPressed(0, 15) and zAxis < 2 then -- SCROLLWHEEL UP
                zAxis = zAxis + 0.02
            end

            if IsDisabledControlJustReleased(0, 348) then -- SCROLLWHEEL PRESS
                zAxis = -0.98
            end
            if IsDisabledControlJustReleased(0, 45) then -- r
                xAxis, yAxis, zAxis = 0, 0, 0
            end

            local pointerCoords = GetOffsetFromEntityInWorldCoords(playerPed, xAxis + 0.0, yAxis + 0.0, zAxis + 0.0);
            SetTextColour(255, 99, 219, 255)
            SetTextFont(0)
            SetTextScale(0.34, 0.34)
            SetTextWrap(0.0, 1.0)
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentSubstringPlayerName("X\t" ..
                string.format("%.2f", pointerCoords.x) .. "\nY\t" .. string.format("%.2f", pointerCoords.y) .. "\nZ\t"
                .. string.format("%.2f", pointerCoords.z))
            DrawText(0.8, 0.88)

            DrawText3D(pointerCoords.x, pointerCoords.y, pointerCoords.z, "?", 0.3, 255, 99, 219)

            if IsControlPressed(0, 21) then -- shift
                -- Y axis
                DrawLine(pointerCoords.x, pointerCoords.y, pointerCoords.z, pointerCoords.x, pointerCoords.y + 0.2,
                    pointerCoords.z, 0, 255, 0, 256)
                DrawText3D(pointerCoords.x, pointerCoords.y + 0.2, pointerCoords.z + 0.1, "y", 0.3, 0, 255, 0)

                -- X axis
                DrawLine(pointerCoords.x, pointerCoords.y, pointerCoords.z, pointerCoords.x + 0.2, pointerCoords.y,
                    pointerCoords.z, 255, 0, 0, 256)
                DrawText3D(pointerCoords.x + 0.2, pointerCoords.y, pointerCoords.z + 0.1, "x", 0.3, 255, 0, 0)

                -- Z axis
                DrawLine(pointerCoords.x, pointerCoords.y, pointerCoords.z, pointerCoords.x, pointerCoords.y,
                    pointerCoords.z + 0.2, 0, 0, 255, 256)
                DrawText3D(pointerCoords.x, pointerCoords.y, pointerCoords.z + 0.3, "z", 0.3, 0, 0, 255)
            else
                -- vertical line on Z axis for better a better view of the position
                DrawLine(pointerCoords.x, pointerCoords.y, pointerCoords.z - 1, pointerCoords.x, pointerCoords.y,
                    pointerCoords.z + 1, 255, 99, 219, 256)
            end

            if zAxis == -0.98 then
                DrawMarker(27, pointerCoords.x, pointerCoords.y, pointerCoords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5,
                    1.5, 255, 99, 219, 100, false, true, 2,
                    false, false, false, false)
            end

            if IsControlJustReleased(0, 79) then -- c
                local coordString = "vector3(" ..
                    string.format("%.2f", pointerCoords.x) .. ", " .. string.format("%.2f", pointerCoords.y) .. ", "
                    .. string.format("%.2f", pointerCoords.z) .. ")"
                exports.ava_hud:copyToClipboard(coordString)
            elseif IsControlPressed(0, 25) then -- right mouse button
                showcoordshelper = false
            end
            Wait(0)
        end
    end)
end)

local visibleHash = {}
local function clearVisibleHashOutlines()
    for i = 1, #visibleHash do
        SetEntityDrawOutline(visibleHash[i].entity, false)
    end
end

RegisterNetEvent("ava_personalmenu:client:toggleShowHash", function()
    showhash = not showhash

    if not showhash then
        return
    end

    Citizen.CreateThread(function()
        SetEntityDrawOutlineColor(255, 133, 85, 255)
        SetEntityDrawOutlineShader(0)

        while showhash do
            Wait(500)
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)

            clearVisibleHashOutlines()
            visibleHash = {}
            local count = 0
            if showhash_object then
                for _, prop in ipairs(GetGamePool("CObject")) do
                    local propCoords = GetEntityCoords(prop)
                    if #(playerCoords - propCoords) < showhash_distance then
                        count = count + 1
                        local model = GetEntityModel(prop)
                        local archetypeName = GetEntityArchetypeName(prop)
                        visibleHash[count] = { model = model, entity = prop,
                            name = archetypeName ~= "" and archetypeName or model }
                        SetEntityDrawOutline(prop, true)
                    end
                end
            end
            if showhash_vehicle then
                for _, veh in ipairs(GetGamePool("CVehicle")) do
                    local vehCoords = GetEntityCoords(veh)
                    if #(playerCoords - vehCoords) < (showhash_distance * 2) then
                        count = count + 1
                        local model = GetEntityModel(veh)
                        local archetypeName = GetEntityArchetypeName(veh)
                        visibleHash[count] = { model = model, entity = veh,
                            name = archetypeName ~= "" and archetypeName or model }
                        SetEntityDrawOutline(veh, true)
                    end
                end
            end
            if showhash_ped then
                for _, ped in ipairs(GetGamePool("CPed")) do
                    local pedCoords = GetEntityCoords(ped)
                    if #(playerCoords - pedCoords) < (showhash_distance * 2) then
                        count = count + 1
                        local model = GetEntityModel(ped)
                        local archetypeName = GetEntityArchetypeName(ped)
                        visibleHash[count] = { model = model, entity = ped,
                            name = archetypeName ~= "" and archetypeName or model, dimensions = true }
                    end
                end
            end
        end
        clearVisibleHashOutlines()
    end)

    Citizen.CreateThread(function()
        local r <const>, g <const>, b <const> = 255, 0, 255
        local lineAlpha <const> = 255
        local polyAlpha <const> = 32
        while showhash do
            Wait(0)
            for _, entity in ipairs(visibleHash) do
                local coords = GetEntityCoords(entity.entity)
                DrawText3D(coords.x, coords.y, coords.z, entity.name, 0.3)

                if showhash_dimensions or entity.dimensions then
                    local min, max = GetModelDimensions(entity.model)
                    local pad = 0.001;

                    -- Bottom
                    local bottom1 = GetOffsetFromEntityInWorldCoords(entity.entity, min.x - pad, min.y - pad, min.z - pad)
                    local bottom2 = GetOffsetFromEntityInWorldCoords(entity.entity, max.x + pad, min.y - pad, min.z - pad)
                    local bottom3 = GetOffsetFromEntityInWorldCoords(entity.entity, max.x + pad, max.y + pad, min.z - pad)
                    local bottom4 = GetOffsetFromEntityInWorldCoords(entity.entity, min.x - pad, max.y + pad, min.z - pad)

                    -- Top
                    local top1 = GetOffsetFromEntityInWorldCoords(entity.entity, min.x - pad, min.y - pad, max.z + pad)
                    local top2 = GetOffsetFromEntityInWorldCoords(entity.entity, max.x + pad, min.y - pad, max.z + pad)
                    local top3 = GetOffsetFromEntityInWorldCoords(entity.entity, max.x + pad, max.y + pad, max.z + pad)
                    local top4 = GetOffsetFromEntityInWorldCoords(entity.entity, min.x - pad, max.y + pad, max.z + pad)

                    -- bottom
                    DrawLine(bottom1, bottom2, r, g, b, lineAlpha)
                    DrawLine(bottom1, bottom4, r, g, b, lineAlpha)
                    DrawLine(bottom2, bottom3, r, g, b, lineAlpha)
                    DrawLine(bottom3, bottom4, r, g, b, lineAlpha)

                    -- top
                    DrawLine(top1, top2, r, g, b, lineAlpha)
                    DrawLine(top1, top4, r, g, b, lineAlpha)
                    DrawLine(top2, top3, r, g, b, lineAlpha)
                    DrawLine(top3, top4, r, g, b, lineAlpha)

                    -- bottom to top
                    DrawLine(bottom1, top1, r, g, b, lineAlpha)
                    DrawLine(bottom2, top2, r, g, b, lineAlpha)
                    DrawLine(bottom3, top3, r, g, b, lineAlpha)
                    DrawLine(bottom4, top4, r, g, b, lineAlpha)

                    -- top face
                    DrawPoly(top1, top2, top3, r, g, b, polyAlpha)
                    DrawPoly(top4, top1, top3, r, g, b, polyAlpha)

                    -- bottom face
                    DrawPoly(bottom2, bottom1, bottom3, r, g, b, polyAlpha)
                    DrawPoly(bottom1, bottom4, bottom3, r, g, b, polyAlpha)

                    -- back face
                    DrawPoly(top2, top1, bottom1, r, g, b, polyAlpha)
                    DrawPoly(bottom1, bottom2, top2, r, g, b, polyAlpha)

                    -- front face
                    DrawPoly(top4, top3, bottom4, r, g, b, polyAlpha)
                    DrawPoly(bottom3, bottom4, top3, r, g, b, polyAlpha)

                    -- right face
                    DrawPoly(top3, top2, bottom2, r, g, b, polyAlpha)
                    DrawPoly(bottom2, bottom3, top3, r, g, b, polyAlpha)

                    -- left face
                    DrawPoly(top1, top4, bottom1, r, g, b, polyAlpha)
                    DrawPoly(bottom4, bottom1, top4, r, g, b, polyAlpha)
                end
            end
        end
    end)
end)
AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        clearVisibleHashOutlines()
    end
end)
