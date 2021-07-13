-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local show_object_hash, show_vehicle_hash, show_ped_hash, show_coord_helper = false, false, false, false
local show_coords = false
local visibleHash = {}

function OpenDevMenu()
    if PlayerGroup ~= nil and (PlayerGroup == "admin" or PlayerGroup == "superadmin" or PlayerGroup == "owner") then
        local elements = {
            {label = _("blue", _("dev_show_object_hash")), value = "show_object_hash", type="checkbox", checked=show_object_hash},
            {label = _("blue", _("dev_show_vehicle_hash")), value = "show_vehicle_hash", type="checkbox", checked=show_vehicle_hash},
            {label = _("blue", _("dev_show_ped_hash")), value = "show_ped_hash", type="checkbox", checked=show_ped_hash},
            {label = _("pink", _("dev_show_coord_helper")), value = "show_coord_helper", type="checkbox", checked=show_coord_helper},
            {label = _("orange", _("dev_show_coords")), value = "show_coords", type="checkbox", checked=show_coords},
        }

        ESX.UI.Menu.Open("default", GetCurrentResourceName(), "ava_personalmenu_dev",
        {
            title    = _("dev_menu"),
            align    = "left",
            elements = elements
        }, function(data, menu)
            if data.current.value == "show_object_hash" then
                show_object_hash = not show_object_hash
            elseif data.current.value == "show_vehicle_hash" then
                show_vehicle_hash = not show_vehicle_hash
            elseif data.current.value == "show_ped_hash" then
                show_ped_hash = not show_ped_hash
            elseif data.current.value == "show_coord_helper" then
                show_coord_helper = not show_coord_helper
                SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
            elseif data.current.value == "show_coords" then
                show_coords = not show_coords
            end
        end, function(data, menu)
            menu.close()
        end)
    end
end



function DevLoop()
	if PlayerGroup ~= nil and (PlayerGroup == "admin" or PlayerGroup == "superadmin" or PlayerGroup == "owner") then

		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(1000)
                if show_object_hash or show_vehicle_hash or show_ped_hash then
                    local playerPed = PlayerPedId()
                    local playerCoords = GetEntityCoords(playerPed)
                    visibleHash = {}
                    if show_object_hash then
                        for _, v in ipairs(GetGamePool("CObject")) do
                            local prop = GetObjectIndexFromEntityIndex(v)
                            local propCoords = GetEntityCoords(prop)
                            if #(playerCoords - propCoords) < 5.0 then
                                table.insert(visibleHash, {hash = GetEntityModel(prop), entity = prop})
                            end
                        end
                    end
                    if show_vehicle_hash then
                        for _, v in ipairs(GetGamePool("CVehicle")) do
                            local veh = GetObjectIndexFromEntityIndex(v)
                            local vehCoords = GetEntityCoords(veh)
                            if #(playerCoords - vehCoords) < 10.0 then
                                table.insert(visibleHash, {hash = GetEntityModel(veh), entity = veh})
                            end
                        end
                    end
                    if show_ped_hash then
                        for _, v in ipairs(GetGamePool("CPed")) do
                            local ped = GetObjectIndexFromEntityIndex(v)
                            local pedCoords = GetEntityCoords(ped)
                            if #(playerCoords - pedCoords) < 10.0 then
                                table.insert(visibleHash, {hash = GetEntityModel(ped), entity = ped})
                            end
                        end
                    end
                else
                    Citizen.Wait(5000)
                end
			end
		end)

		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(0)
                if show_object_hash or show_vehicle_hash or show_ped_hash then
                    for _, prop in ipairs(visibleHash) do
						local coords = GetEntityCoords(prop.entity)
						DrawText3D(coords.x, coords.y, coords.z, prop.hash, 0.3)

						local min, max = GetModelDimensions(GetEntityModel(prop.entity))
						local pad = 0.001;

						-- Bottom
						local bottom1 = GetOffsetFromEntityInWorldCoords(prop.entity, min.x - pad, min.y - pad, min.z - pad)
						local bottom2 = GetOffsetFromEntityInWorldCoords(prop.entity, max.x + pad, min.y - pad, min.z - pad)
						local bottom3 = GetOffsetFromEntityInWorldCoords(prop.entity, max.x + pad, max.y + pad, min.z - pad)
						local bottom4 = GetOffsetFromEntityInWorldCoords(prop.entity, min.x - pad, max.y + pad, min.z - pad)

						-- Top
						local top1 = GetOffsetFromEntityInWorldCoords(prop.entity, min.x - pad, min.y - pad, max.z + pad)
						local top2 = GetOffsetFromEntityInWorldCoords(prop.entity, max.x + pad, min.y - pad, max.z + pad)
						local top3 = GetOffsetFromEntityInWorldCoords(prop.entity, max.x + pad, max.y + pad, max.z + pad)
						local top4 = GetOffsetFromEntityInWorldCoords(prop.entity, min.x - pad, max.y + pad, max.z + pad)

						-- bottom
						DrawLine(bottom1, bottom2, 255, 0, 255, 255)
						DrawLine(bottom1, bottom4, 255, 0, 255, 255)
						DrawLine(bottom2, bottom3, 255, 0, 255, 255)
						DrawLine(bottom3, bottom4, 255, 0, 255, 255)

						-- top
						DrawLine(top1, top2, 255, 0, 255, 255)
						DrawLine(top1, top4, 255, 0, 255, 255)
						DrawLine(top2, top3, 255, 0, 255, 255)
						DrawLine(top3, top4, 255, 0, 255, 255)

						-- bottom to top
						DrawLine(bottom1, top1, 255, 0, 255, 255)
						DrawLine(bottom2, top2, 255, 0, 255, 255)
						DrawLine(bottom3, top3, 255, 0, 255, 255)
						DrawLine(bottom4, top4, 255, 0, 255, 255)

						-- top face
						DrawPoly(top1, top2, top3, 255, 0, 255, 128)
						DrawPoly(top4, top1, top3, 255, 0, 255, 128)

						-- bottom face
						DrawPoly(bottom2, bottom1, bottom3, 255, 0, 255, 128)
						DrawPoly(bottom1, bottom4, bottom3, 255, 0, 255, 128)

						-- back face
						DrawPoly(top2, top1, bottom1, 255, 0, 255, 128)
						DrawPoly(bottom1, bottom2, top2, 255, 0, 255, 128)

						-- front face
						DrawPoly(top4, top3, bottom4, 255, 0, 255, 128)
						DrawPoly(bottom3, bottom4, top3, 255, 0, 255, 128)

						-- right face
						DrawPoly(top3, top2, bottom2, 255, 0, 255, 128)
						DrawPoly(bottom2, bottom3, top3, 255, 0, 255, 128)

						-- left face
						DrawPoly(top1, top4, bottom1, 255, 0, 255, 128)
						DrawPoly(bottom4, bottom1, top4, 255, 0, 255, 128)
					end
				else
					Citizen.Wait(5000)
				end
			end
		end)

		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(0)
				if show_coords then
					local playerPed = PlayerPedId()
					local playerCoords = GetEntityCoords(playerPed)

					SetTextColour(255, 255, 255, 255)
					SetTextFont(0)
					SetTextScale(0.34, 0.34)
					SetTextWrap(0.0, 1.0)
					SetTextOutline()
					SetTextEntry("STRING")
					AddTextComponentString("~o~X~s~\t\t" .. string.format("%.2f", playerCoords.x) .. "\n~o~Y~s~\t\t" .. string.format("%.2f", playerCoords.y) .. "\n~o~Z~s~\t\t" .. string.format("%.2f", playerCoords.z) .. "\n~o~Heading~s~\t" .. string.format("%.2f", GetEntityHeading(playerPed)))
					EndTextCommandDisplayText(0.9, 0.88)
				else
					Citizen.Wait(5000)
				end
			end
		end)

		Citizen.CreateThread(function()
            local xAxis, yAxis, zAxis = 0, 0, 0
			while true do
				Citizen.Wait(0)
				if show_coord_helper then
                    AddTextEntry("show_coord_helper", _("dev_show_coord_helper_display_text"))
                    BeginTextCommandDisplayHelp("show_coord_helper")
                    EndTextCommandDisplayHelp(false, false, false, -1)

                    -- r
                    DisableControlAction(0, 45, true)

                    -- SCROLLWHEEL PRESS
                    DisableControlAction(0, 348, true)
                    -- SCROLLWHEEL UP
                    DisableControlAction(0, 15, true)
                    DisableControlAction(0, 17, true)
                    -- SCROLLWHEEL DOWN
                    DisableControlAction(0, 14, true)
                    DisableControlAction(0, 16, true)


                    if IsControlPressed(0, 172) and yAxis < 2 then  -- up
                        yAxis = yAxis + 0.01
                    elseif IsControlPressed(0, 173) and yAxis > -2 then  -- down
                        yAxis = yAxis - 0.01
                    end
                    if IsControlPressed(0, 174) and xAxis > -2 then  -- left
                        xAxis = xAxis - 0.01
                    elseif IsControlPressed(0, 175) and xAxis < 2 then  -- right
                        xAxis = xAxis + 0.01
                    end
                    if IsDisabledControlPressed(0, 14) and zAxis > -2 then  -- SCROLLWHEEL DOWN
                        zAxis = zAxis - 0.02
                    elseif IsDisabledControlPressed(0, 15) and zAxis < 2 then  -- SCROLLWHEEL UP
                        zAxis = zAxis + 0.02
                    end

                    if IsDisabledControlJustReleased(0, 348) then -- SCROLLWHEEL PRESS
                        zAxis = -0.98
                    end
                    if IsDisabledControlJustReleased(0, 45) then -- r
                        xAxis, yAxis, zAxis = 0, 0, 0
                    end

                    local playerPed = PlayerPedId()
                    local pointerCoords = GetOffsetFromEntityInWorldCoords(playerPed, xAxis + 0.0, yAxis + 0.0, zAxis + 0.0);
                    SetTextColour(255, 99, 219, 255)
                    SetTextFont(0)
                    SetTextScale(0.34, 0.34)
                    SetTextWrap(0.0, 1.0)
                    SetTextOutline()
                    SetTextEntry("STRING")
                    AddTextComponentString("X\t" .. string.format("%.2f", pointerCoords.x) .. "\nY\t" .. string.format("%.2f", pointerCoords.y) .. "\nZ\t" .. string.format("%.2f", pointerCoords.z))
                    DrawText(0.8, 0.88)

                    DrawText3D(pointerCoords.x, pointerCoords.y, pointerCoords.z, "?", 0.3, 255, 99, 219)

                    if IsControlPressed(0, 21) then -- shift
                        -- Y axis
                        DrawLine(pointerCoords.x, pointerCoords.y, pointerCoords.z, pointerCoords.x, pointerCoords.y + 0.2, pointerCoords.z, 0, 255, 0, 256)
                        DrawText3D(pointerCoords.x, pointerCoords.y + 0.2, pointerCoords.z + 0.1, "y", 0.3, 0, 255, 0)
                        
                        -- X axis
                        DrawLine(pointerCoords.x, pointerCoords.y, pointerCoords.z, pointerCoords.x + 0.2, pointerCoords.y, pointerCoords.z, 255, 0, 0, 256)
                        DrawText3D(pointerCoords.x + 0.2, pointerCoords.y, pointerCoords.z + 0.1, "x", 0.3, 255, 0, 0)
                        
                        -- Z axis
                        DrawLine(pointerCoords.x, pointerCoords.y, pointerCoords.z, pointerCoords.x, pointerCoords.y, pointerCoords.z + 0.2, 0, 0, 255, 256)
                        DrawText3D(pointerCoords.x, pointerCoords.y, pointerCoords.z + 0.3, "z", 0.3, 0, 0, 255)
                    else
                        -- vertical line on Z axis for better a better view of the position
                        DrawLine(pointerCoords.x, pointerCoords.y, pointerCoords.z - 1, pointerCoords.x, pointerCoords.y, pointerCoords.z + 1, 255, 99, 219, 256)
                    end


                    if zAxis == -0.98 then
                        DrawMarker(27, pointerCoords.x, pointerCoords.y, pointerCoords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 99, 219, 100, false, true, 2, false, false, false, false)
                    end

                    if IsControlJustReleased(0, 79) then -- c
                        local coordString = "vector3(" .. string.format("%.2f", pointerCoords.x) .. ", " .. string.format("%.2f", pointerCoords.y) .. ", " .. string.format("%.2f", pointerCoords.z) .. ")"
                        exports.avan0x_hud:copyToClipboard(coordString)
                    elseif IsControlPressed(0, 25) then -- right mouse button
                        show_coord_helper = false
                    end
				else
					Citizen.Wait(5000)
				end
			end
		end)



	end
end
