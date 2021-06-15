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
					DrawText(0.9, 0.88)
				else
					Citizen.Wait(5000)
				end
			end
		end)

		Citizen.CreateThread(function()
            local xAxis, yAxis = 0, 1
			while true do
				Citizen.Wait(0)
				if show_coord_helper then
                    AddTextEntry("show_coord_helper", "Press ~INPUT_CELLPHONE_LEFT~, ~INPUT_CELLPHONE_UP~, ~INPUT_CELLPHONE_RIGHT~ or ~INPUT_CELLPHONE_DOWN~ to control the pointer position~n~~INPUT_RELOAD~ to reset positions~n~~INPUT_VEH_LOOK_BEHIND~ to copy coords to clipboard")
                    BeginTextCommandDisplayHelp("show_coord_helper")
                    EndTextCommandDisplayHelp(false, false, false, -1)

					local playerPed = PlayerPedId()

                    if IsControlPressed(1, 172) and yAxis < 2 then  -- up
                        yAxis = yAxis + 0.01
                    elseif IsControlPressed(1, 173) and yAxis > -2 then  -- down
                        yAxis = yAxis - 0.01
                    elseif IsControlPressed(1, 174) and xAxis > -2 then  -- left
                        xAxis = xAxis - 0.01
                    elseif IsControlPressed(1, 175) and xAxis < 2 then  -- right
                        xAxis = xAxis + 0.01
                    elseif IsControlJustReleased(0, 45) then -- r
                        xAxis = 0
                        yAxis = 1
                    end

                    local pointerCoords = GetOffsetFromEntityInWorldCoords(playerPed, xAxis + 0.0, yAxis + 0.0, 0.0);
                    local coordString = "vector3(" .. string.format("%.2f", pointerCoords.x) .. ", " .. string.format("%.2f", pointerCoords.y) .. ", " .. string.format("%.2f", pointerCoords.z) .. ")"

                    DrawText3D(pointerCoords.x, pointerCoords.y, pointerCoords.z, "?", 0.3, 255, 0, 255)
                    if IsControlJustReleased(0, 79) then -- c
                        TriggerEvent('avan0x_hud:copyToClipboard', coordString)
                    end
				else
					Citizen.Wait(5000)
				end
			end
		end)



	end
end
