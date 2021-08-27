-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
PlayerListSubMenu = RageUI.CreateSubMenu(MainAdminMenu, "", GetString("player_list"))
PlayersOptionsSubMenu = RageUI.CreateSubMenu(MainAdminMenu, "", GetString("players_options"))
local PlayersManageSubMenu = RageUI.CreateSubMenu(PlayerListSubMenu, "", "player_name")
local playersOptions = {{Name = "Gérer", task = "manage"}, {Name = "Spectate", task = "spec"}}
local playerlistTaskIndex = 1
PlayerListSubMenu.Closed = function()
    playerlistTaskIndex = 1
end
local selectedPlayerData = nil

local displayPlayerBlips = false
local displayPlayerTags = false

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
                            if oldBlip and oldBlip.blip then
                                RemoveBlip(oldBlip.blip)
                            end
                            local targetPed = GetPlayerPed(playerLocalId)
                            blip = AddBlipForEntity(targetPed)
                            oldBlip = {type = "entity"}

                            ShowHeadingIndicatorOnBlip(blip, true)
                        end
                    elseif not oldBlip or oldBlip.type == "entity" then
                        if oldBlip and oldBlip.blip then
                            RemoveBlip(oldBlip.blip)
                        end
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
                        AddTextComponentString(playerId .. ' - ' .. playerData.n)
                        EndTextCommandSetBlipName(blip)
                        oldBlip.blip = blip
                    end
                    if oldBlip.sameRB ~= playerData.sameRB then
                        SetBlipColour(oldBlip.blip, playerData.sameRB and 8 or 27)
                        oldBlip.sameRB = playerData.sameRB
                    end
                    newBlips[playerId] = oldBlip
                    shownBlips[playerId] = nil
                end
            end

            -- we remove left over blips
            for _, blip in pairs(shownBlips) do
                RemoveBlip(blip.blip)
            end
            shownBlips = newBlips
            Wait(5000)
        end
        -- blips that are left in shownBlips need to be removed
        for _, blip in pairs(shownBlips) do
            RemoveBlip(blip.blip)
        end
    end)
end

RegisterNetEvent("ava_personalmenu:client:togglePlayerBlips", function(value)
    togglePlayerBlipsLoop(value and true or false)
end)


local function togglePlayerTagsLoop(value)
    if value ~= nil then
        value = not displayPlayerTags
    end

    if displayPlayerTags then
        displayPlayerTags = value
        return
    end
    displayPlayerTags = value

    Citizen.CreateThread(function()
        local pairs = pairs
        local MP_GAMER_TAG_COMPONENTS = {
            GAMER_NAME = 0,
            CREW_TAG = 1,
            HEALTH_ARMOUR = 2,
            BIG_TEXT = 3,
            AUDIO_ICON = 4,
            MP_USING_MENU = 5,
            MP_PASSIVE_MODE = 6,
            WANTED_STARS = 7,
            MP_DRIVER = 8,
            MP_CO_DRIVER = 9,
            MP_TAGGED = 12,
            GAMER_NAME_NEARBY = 13,
            ARROW = 14,
            MP_PACKAGES = 15,
            INV_IF_PED_FOLLOWING = 16,
            RANK_TEXT = 17,
            MP_TYPING = 18
        }
        local shownTags = {}

        while displayPlayerTags do
            local newTags = {}

            for i = 1, #playersData do
                local playerData = playersData[i]
                local playerId = tostring(playerData.id)

                local playerLocalId = GetPlayerFromServerId(tonumber(playerId))
                if playerLocalId ~= -1 then
                    local tag = shownTags[playerId]
                    if not tag or not IsMpGamerTagActive(tag) then
                        local targetPed = GetPlayerPed(playerLocalId)
                        tag = CreateFakeMpGamerTag(targetPed, playerId .. ' - ' .. playerData.n, false, false, "", 0)

                        -- Name
                        SetMpGamerTagVisibility(tag, MP_GAMER_TAG_COMPONENTS.GAMER_NAME, 1)

                        -- Health
                        SetMpGamerTagHealthBarColor(tag, 18)
                        SetMpGamerTagAlpha(tag, MP_GAMER_TAG_COMPONENTS.HEALTH_ARMOUR, 255)
                        SetMpGamerTagVisibility(tag, MP_GAMER_TAG_COMPONENTS.HEALTH_ARMOUR, 1)
                    end
                    newTags[playerId] = tag

                    -- we remove the tag from the old list, to be able to know which tags needs to be removed
                    shownTags[playerId] = nil
                end
            end

            -- we remove left over blips
            for _, tag in pairs(shownTags) do
                RemoveMpGamerTag(tag)
            end
            shownTags = newTags
            Wait(5000)
        end

        -- tags that are left in shownTags need to be removed
        for _, tag in pairs(shownTags) do
            RemoveMpGamerTag(tag)
        end
    end)
end

RegisterNetEvent("ava_personalmenu:client:togglePlayerTags", function(value)
    togglePlayerTagsLoop(value and true or false)
end)

function PoolPlayerList()
    if perms.playerlist then
        PlayerListSubMenu:IsVisible(function(Items)
            for i = 1, #playersData do
                local playerData = playersData[i]
                Items:AddList(playerData.id .. ' - ' .. playerData.n, playersOptions, playerlistTaskIndex, not playerData.sameRB and GetString("routing_bucket_different"),
                    nil, function(Index, onSelected, onListChange)
                        if onListChange then
                            playerlistTaskIndex = Index
                        end
                        if onSelected then
                            local task = playersOptions[playerlistTaskIndex].task
                            if task == "manage" then
                                print("manage")
                                selectedPlayerData = playerData
                                PlayersManageSubMenu.Subtitle = playerData.n
                            elseif task == "spec" then
                                print("spec")
                            end
                        end
                    end, {PlayersManageSubMenu})
            end
        end)

        PlayersManageSubMenu:IsVisible(function(Items)
            if not selectedPlayerData then
                RageUI.GoBack()
            else
                local playerData = selectedPlayerData
                if perms.playerlist["goto"] then
                    Items:AddButton(GetString("player_manage_goto"), GetString("player_manage_goto_subtitle"), nil, function(onSelected)
                        if onSelected then
                            ExecuteCommand("goto " .. playerData.id)
                        end
                    end)
                end
                if perms.playerlist.bring then
                    Items:AddButton(GetString("player_manage_bring"), GetString("player_manage_bring_subtitle"), nil, function(onSelected)
                        if onSelected then
                            ExecuteCommand("bring " .. playerData.id)
                        end
                    end)
                end
                if perms.playerlist.kill then
                    Items:AddButton(GetString("player_manage_kill"), GetString("player_manage_kill_subtitle"), nil, function(onSelected)
                        if onSelected then
                            ExecuteCommand("kill " .. playerData.id)
                        end
                    end)
                end
                if perms.playerlist.kick then
                    Items:AddButton(GetString("player_manage_kick"), GetString("player_manage_kick_subtitle"), nil, function(onSelected)
                        if onSelected then
                            local reason = AVA.KeyboardInput(GetString("player_manage_kick_input"), "" or "", 50)
                            if reason and reason ~= "" then
                                ExecuteCommand("kick " .. playerData.id .. " " .. reason)
                            end
                        end
                    end)
                end
                if perms.playerlist.ban then
                    Items:AddButton(GetString("player_manage_ban"), GetString("player_manage_ban_subtitle"), nil, function(onSelected)
                        if onSelected then
                            local reason = AVA.KeyboardInput(GetString("player_manage_ban_input"), "" or "", 50)
                            if reason and reason ~= "" then
                                ExecuteCommand("ban " .. playerData.id .. " " .. reason)
                            end
                        end
                    end)
                end
            end
        end)
    end

    if perms.playersoptions then
        PlayersOptionsSubMenu:IsVisible(function(Items)
            if perms.playersoptions.playerblips then
                Items:CheckBox(GetString("admin_menu_players_options_blips"), GetString("admin_menu_players_options_blips_subtitle"), displayPlayerBlips, nil,
                    function(onSelected, IsChecked)
                        if (onSelected) then
                            ExecuteCommand("playerblips" .. (IsChecked and " true" or ""))
                        end
                    end)
            end
            if perms.playersoptions.playertags then
                Items:CheckBox(GetString("admin_menu_players_options_gamertags"), GetString("admin_menu_players_options_gamertags_subtitle"), displayPlayerTags, nil,
                    function(onSelected, IsChecked)
                        if (onSelected) then
                            ExecuteCommand("playertags" .. (IsChecked and " true" or ""))
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

    -- we need to update the selectedPlayerData
    local selectedPlayerDataId = selectedPlayerData and selectedPlayerData.id
    local newSelectedPlayerData = nil
    for i = 1, #data do
        local player = data[i]
        player.sameRB = tonumber(myRB) == tonumber(data[i].rb)

        if selectedPlayerDataId and player.id == selectedPlayerDataId then
            newSelectedPlayerData = player
        end
    end
    selectedPlayerData = newSelectedPlayerData
        
    playersData = data
end)
