-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
PlayerListSubMenu = RageUI.CreateSubMenu(MainAdminMenu, "", GetString("player_list"))
PlayersOptionsSubMenu = RageUI.CreateSubMenu(MainAdminMenu, "", GetString("players_options"))
local playersOptions = {{Name = "Gérer", task = "manage"}, {Name = "Spectate", task = "spec"}}
local listIndex = 1

local displayPlayerBlips = false

local function togglePlayerBlipsLoop(value)
    if value ~= nil then
        value = not displayPlayerBlips
    end

    if displayPlayerBlips then
        displayPlayerBlips = value
        return
    end
    displayPlayerBlips = value

    DisplayPlayerNameTagsOnBlips(true)
    Citizen.CreateThread(function()
        local pairs = pairs
        local shownBlips = {}

        while displayPlayerBlips do
            local myPlayerId = PlayerId()
            local newBlips = {}

            for i = 1, #playersData do
                local playerData = playersData[i]
                local playerId = tostring(playerData.id)
                local oldBlip = shownBlips[playerId]
                local blip

                local playerLocalId = GetPlayerFromServerId(tonumber(playerId))
                if playerLocalId ~= myPlayerId then
                    if playerLocalId ~= -1 then
                        if not oldBlip or oldBlip.type == "coord" then
                            local targetPed = GetPlayerPed(playerLocalId)
                            blip = AddBlipForEntity(targetPed)
                            oldBlip = {type = "entity"}

                            ShowHeadingIndicatorOnBlip(blip, true)
                        end
                    elseif not oldBlip or oldBlip.type == "entity" then
                        local coords = playerData.c
                        blip = AddBlipForCoord(coords.x, coords.y, coords.z)
                        oldBlip = {type = "coord"}
                    elseif oldBlip.type == "coord" and oldBlip.blip then
                        local coords = playerData.c
                        SetBlipCoords(oldBlip.blip, coords.x, coords.y, coords.z)
                    end

                    if blip then
                        SetBlipDisplay(blip, 2)
                        SetBlipSprite(blip, 1)
                        SetBlipColour(blip, 8)
                        SetBlipCategory(blip, 7)
                        SetBlipScale(blip, 0.7)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString(("%s - %s"):format(playerId, playerData.n))
                        EndTextCommandSetBlipName(blip)
                        oldBlip.blip = blip
                    end
                    if oldBlip.sameRB ~= playerData.sameRB then
                        SetBlipColour(oldBlip.blip, playerData.sameRB and 8 or 27)
                        oldBlip.sameRB = playerData.sameRB
                    end
                    newBlips[playerId] = oldBlip
                end
                Wait(0)
            end

            -- we check if we need to remove blips
            for playerId, blip in pairs(shownBlips) do
                local newBlip = newBlips[playerId]
                if not newBlip or blip.type ~= newBlip.type then
                    RemoveBlip(blip.blip)
                end
            end
            shownBlips = newBlips
            Wait(5000)
        end
        for _, blip in pairs(shownBlips) do
            RemoveBlip(blip.blip)
        end
    end)
end

RegisterNetEvent("ava_personalmenu:client:togglePlayerBlips", function(value)
    togglePlayerBlipsLoop(value and true or false)
end)

function PoolPlayerList()
    if perms.playerlist then
        PlayerListSubMenu:IsVisible(function(Items)
            for i = 1, #playersData do
                local player = playersData[i]
                Items:AddList(("%s - %s"):format(player.id, player.n), playersOptions, listIndex, not player.sameRB and GetString("routing_bucket_different"),
                    nil, function(Index, onSelected, onListChange)
                        if onListChange then
                            listIndex = Index
                        end
                    end)
            end
        end)
    end

    if perms.playersoptions then
        PlayersOptionsSubMenu:IsVisible(function(Items)
            if perms.playersoptions.playerblips then
                Items:CheckBox(GetString("admin_menu_players_options_blips"), GetString("admin_menu_players_options_blips_subtitle"), displayPlayerBlips, nil,
                    function(onSelected, IsChecked)
                        if (onSelected) then
                            -- togglePlayerBlipsLoop(IsChecked)
                            ExecuteCommand("playerblips" .. (IsChecked and " true" or ""))
                        end
                    end)
            end
        end)
    end
end

local tablesort = table.sort
RegisterNetEvent("ava_personalmenu:client:playersData", function(data, myRB)
    tablesort(data, function(a, b)
        return a.id < b.id
    end)
    for i = 1, #data do
        local player = data[i]
        player.sameRB = tonumber(myRB) == tonumber(data[i].rb)
    end
    playersData = data
end)
