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
        ESX.UI.Menu.Open("default", GetCurrentResourceName(), "esx_avan0x_get_close_player",
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