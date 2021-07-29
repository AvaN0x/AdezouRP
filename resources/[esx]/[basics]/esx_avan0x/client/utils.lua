-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------


function ChooseClosestPlayer(cb, title, distance, allowMyself)
    local playerPed = PlayerPedId()
    local playerId = PlayerId()

    if not title or title == "" then
        title = _('select_a_player')
    end
    if not distance or not tonumber(distance) or tonumber(distance) <= 0 then
        distance = 3.0
    end

    local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), distance + 0.0)
    local elements = {}

    local playersCount = 0
    for k, player in ipairs(players) do
        if player ~= playerId or allowMyself then
            playersCount = playersCount + 1
            table.insert(elements, {
                label = player ~= playerId and "Personne #" .. playersCount or "Moi",
                localId = player,
                serverId = GetPlayerServerId(player)
            })
        end
    end

    if playersCount > 0 then
        local drawPlayers = true
        Citizen.CreateThread(function()
            while drawPlayers do
                Citizen.Wait(0)
                local playerCoords = GetEntityCoords(playerPed)
                for k, v in ipairs(elements) do
                    local targetPed = GetPlayerPed(v.localId)
                    local targetCoords = GetEntityCoords(targetPed)
                    DrawLine(playerCoords.x, playerCoords.y, playerCoords.z + 0.3, targetCoords.x, targetCoords.y, targetCoords.z + 0.3, 255, 0, 255, 128)
                    DrawText3D(targetCoords.x, targetCoords.y, targetCoords.z + 0.3, v.label, 0.3)
                end
            end
        end)
        Citizen.CreateThread(function()
            while drawPlayers do
                Citizen.Wait(500)
                drawPlayers = ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'esx_avan0x_choose_closest_player')
            end
        end)
        ESX.UI.Menu.Open("default", GetCurrentResourceName(), "esx_avan0x_choose_closest_player",
        {
            title = title,
            align = "left",
            elements = elements
        }, function(data, menu)
            drawPlayers = false
            menu.close()
            cb(data.current.serverId, data.current.localId)
        end, function(data, menu)
            drawPlayers = false
            menu.close()
        end)
    else
        ESX.ShowNotification(_("no_players_near"))
    end
end

-- whitelist and blacklist needs to be arrays of hashkeys
function ChooseClosestVehicle(cb, title, distance, whitelist, blacklist)
    local playerPed = PlayerPedId()

    if not distance or not tonumber(distance) or tonumber(distance) < 0 then
        distance = 3.0
    end
    if not title or title == "" then
        title = _('select_a_vehicle')
    end
    local elements = {}

    local vehiclesCount = 0
    local playerCoords = GetEntityCoords(playerPed)
    for _, v in ipairs(GetGamePool("CVehicle")) do
        local veh = GetObjectIndexFromEntityIndex(v)
        local vehCoords = GetEntityCoords(veh)
        local vehModel = GetEntityModel(veh)
        if #(playerCoords - vehCoords) < distance + 0.0
            and (whitelist == nil or #whitelist == 0 or ArrayContains(whitelist, vehModel))
            and (blacklist == nil or #blacklist == 0 or not ArrayContains(blacklist, vehModel))
        then
            vehiclesCount = vehiclesCount + 1
            table.insert(elements, {
                label = "Véhicule #" .. vehiclesCount,
                vehicle = veh
            })
        end
    end

    if vehiclesCount > 0 then
        local drawVehicles = true
        Citizen.CreateThread(function()
            while drawVehicles do
                Citizen.Wait(0)
                local playerCoords = GetEntityCoords(playerPed)
                for k, v in ipairs(elements) do
                    local vehCoords = GetEntityCoords(v.vehicle)
                    DrawLine(playerCoords.x, playerCoords.y, playerCoords.z + 0.3, vehCoords.x, vehCoords.y, vehCoords.z + 0.3, 255, 0, 255, 128)
                    DrawText3D(vehCoords.x, vehCoords.y, vehCoords.z + 0.3, v.label, 0.3)
                end
            end
        end)
        Citizen.CreateThread(function()
            while drawVehicles do
                Citizen.Wait(500)
                drawVehicles = ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'esx_avan0x_choose_closest_vehicle')
            end
        end)
        ESX.UI.Menu.Open("default", GetCurrentResourceName(), "esx_avan0x_choose_closest_vehicle",
        {
            title = title,
            align = "left",
            elements = elements
        }, function(data, menu)
            drawVehicles = false
            menu.close()
            cb(data.current.vehicle)
        end, function(data, menu)
            drawVehicles = false
            menu.close()
        end)
    else
        ESX.ShowNotification(_("no_vehicles_near"))
    end
end

function GetVehicleInFrontOrChooseClosestVehicle(cb, title, distance)
    local yOffset = distance
    if not distance or not tonumber(distance) or tonumber(distance) < 0 then
        yOffset = 4
    end

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local offsetCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, yOffset + 0.0, 0.0)
    local rayHandle = StartExpensiveSynchronousShapeTestLosProbe(playerCoords.x, playerCoords.y, playerCoords.z, offsetCoords.x, offsetCoords.y, offsetCoords.z, 10, playerPed, 0)
    local _, _, _, _, vehicle = GetShapeTestResult(rayHandle)

    if GetEntityType(vehicle) == 2 then
        cb(vehicle)
    else
        ChooseClosestVehicle(cb, title, distance)
    end
end

function DrawText3D(x, y, z, text, size, r, g, b)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)

    if onScreen then
        SetTextScale(0.35, size or 0.35)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r or 255, g or 255, b or 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        SetTextOutline()

        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)
    end
end


function DrawBubbleText3D(x, y, z, text, backgroundColor, bubbleStyle)
    local onScreen = World3dToScreen2d(x, y, z)
    if onScreen then
        AddTextEntry(GetCurrentResourceName(), text)
        BeginTextCommandDisplayHelp(GetCurrentResourceName())
        EndTextCommandDisplayHelp(2, false, false, -1)
        SetFloatingHelpTextWorldPosition(1, x, y, z)


        local backgroundColor = backgroundColor or 15 -- see https://pastebin.com/d9aHPbXN
        local bubbleStyle = bubbleStyle or 3
        -- -1 centered, no triangles
        -- 0 left, no triangles
        -- 1 centered, triangle top
        -- 2 left, triangle left
        -- 3 centered, triangle bottom
        -- 4 right, triangle right
        SetFloatingHelpTextStyle(1, 1, backgroundColor, -1, bubbleStyle, 0)
    end
end

function ArrayContains(array, value)
	for k, v in pairs(array) do
		if v == value then
			return true
		end
	end
	return false
end

function KeyboardInput(textEntry, inputText, maxLength)
    AddTextEntry("FMMC_KEY_TIP1", textEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", '', inputText, '', '', '', maxLength)
    input = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(10)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(100)
        input = false
        return result or ''
    else
        Citizen.Wait(100)
        input = false
        return ''
    end
end

function CancelableGoStraightToCoord(ped, coords, speed, timeout, targetHeading , distanceToSlide)
	TaskGoStraightToCoord(ped, coords.x, coords.y, coords.z, speed, timeout, targetHeading , distanceToSlide)

    local checkControls = ped == PlayerPedId()
    -- 0x7D8F4411 is TaskGoStraightToCoord
	while GetScriptTaskStatus(ped, 0x7D8F4411) ~= 7 do
		if checkControls then
			if IsControlJustPressed(0, 32)
                or IsControlJustPressed(0, 33)
                or IsControlJustPressed(0, 34)
                or IsControlJustPressed(0, 35)
            then
				ClearPedTasks(ped)
                return false
			end
		end

		Citizen.Wait(0)
	end

	return true
end


-- use example : 
-- ```lua
--      local instructionalButtons = exports.esx_avan0x:GetScaleformInstructionalButtons({{control = "~INPUT_AIM~", label = "Aim"}})
--      DrawScaleformMovieFullscreen(instructionalButtons, 255, 255, 255, 255)
-- ```
-- to optimise it you can call the export outside of a loop
function GetScaleformInstructionalButtons(buttons)
    local instructionScaleform = RequestScaleformMovie("instructional_buttons")

    while not HasScaleformMovieLoaded(instructionScaleform) do
        Wait(0)
    end

    PushScaleformMovieFunction(instructionScaleform, "CLEAR_ALL")
    PushScaleformMovieFunction(instructionScaleform, "TOGGLE_MOUSE_BUTTONS")
    PushScaleformMovieFunctionParameterBool(0)
    PopScaleformMovieFunctionVoid()

    for i = 1, #buttons, 1 do
        PushScaleformMovieFunction(instructionScaleform, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(i - 1)
        
        PushScaleformMovieMethodParameterButtonName(buttons[i].control)
        PushScaleformMovieFunctionParameterString(buttons[i].label)
        PopScaleformMovieFunctionVoid()
    end

    PushScaleformMovieFunction(instructionScaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PushScaleformMovieFunctionParameterInt(-1)
    PopScaleformMovieFunctionVoid()

    return instructionScaleform
end

