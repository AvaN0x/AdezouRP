-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------


function ChooseClosestPlayer(cb, title, distance)
    local playerPed = PlayerPedId()
    local playerId = PlayerId()
    if not distance or not tonumber(distance) or tonumber(distance) < 0 then
        distance = 3.0
    end
    if not title then
        title = _('select_a_player')
    end
    local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), distance + 0.0)
    local elements = {}

    local playersCount = 0
    for k, player in ipairs(players) do
        if player ~= playerId then
            playersCount = playersCount + 1
            table.insert(elements, {
                label = "Personne #" .. playersCount,
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

function ChooseClosestVehicle(cb, title, distance)
    local playerPed = PlayerPedId()

    if not distance or not tonumber(distance) or tonumber(distance) < 0 then
        distance = 3.0
    end
    if not title then
        title = _('select_a_vehicle')
    end
    local elements = {}

    local vehiclesCount = 0
    local playerCoords = GetEntityCoords(playerPed)
    for _, v in ipairs(GetGamePool("CVehicle")) do
        local veh = GetObjectIndexFromEntityIndex(v)
        local vehCoords = GetEntityCoords(veh)
        if #(playerCoords - vehCoords) < distance + 0.0 then
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


function DrawText3D(x, y, z, text, size)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)

    if onScreen then
        SetTextScale(0.35, size or 0.35)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        SetTextOutline()

        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end


function DrawBubbleText3D(x, y, z, text, backgroundColor, bubbleStyle)
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
