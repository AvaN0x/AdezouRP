-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVA.Player = {}
AVA.Player.Loaded = false
AVA.Player.HasSpawned = false
AVA.Player.FirstSpawn = true
AVA.Player.IsDead = false

--* replaced with event playerJoining
-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(5)
-- 		if NetworkIsSessionStarted() then
-- 			TriggerServerEvent("ava_core:server:playerJoined")
-- 			return
-- 		end
-- 	end
-- end)

Citizen.CreateThread(function()
    while not AVA.Player.Data do Wait(10) end

	while true do
		Citizen.Wait(1000)
        if not AVA.Player.IsDead then
            local playerCoords = GetEntityCoords(PlayerPedId())

            if AVA.Player.Data.position ~= playerCoords and AVA.Player.HasSpawned and not AVA.Player.CreatingChar then
                TriggerServerEvent("ava_core:server:updatePosition", playerCoords)
                AVA.Player.Data.position = playerCoords
            end
        end
	end
end)


AVA.GetPlayerData = function()
    -- if player is not loaded, Data can't possibly (not sure) be incomplete
    if AVA.Player.Loaded then
        return AVA.Player.Data
    end
    return
end


local function SpawnPlayer()
    AVA.Player.IsDead = false
    AVA.Player.HasSpawned = true

    while not AVA.Player.Loaded do Wait(10) end
    local playerPed = PlayerPedId()

    -- dprint(AVA.Player.Data.position)
    if AVA.Player.Data.position then
        SetEntityCoords(playerPed, AVA.Player.Data.position)
    end

    dprint(json.encode(AVA.Player.Data.skin))
    if AVA.Player.FirstSpawn then
        exports.spawnmanager:setAutoSpawn(false) -- disable auto respawn

        AVA.Player.FirstSpawn = false
        if AVA.Player.Data.skin then
            exports.skinchanger:loadSkin(AVA.Player.Data.skin)
        else
            exports.skinchanger:loadSkin({sex = 0})
        end

    end

    -- TriggerEvent("ava_core:client:restoreLoadout") -- restore loadout
end


RegisterNetEvent("ava_core:client:playerLoaded", function(data)
    AVA.Player.Data = data
    dprint(AVA.Player.Data.citizenId, json.encode(AVA.Player.Data.character), AVA.Player.Data.position)
    AVA.Player.Loaded = true
    dprint("AVA.Player.Loaded loaded")

    if AVA.Player.HasSpawned then
        AVA.Player.HasSpawned = false
        AVA.Player.FirstSpawn = true
        -- print('TriggerEvent("playerSpawned")')
        -- -- TriggerEvent("playerSpawned")
        -- exports.spawnmanager:spawnPlayer()
        SpawnPlayer()
    end
end)

AddEventHandler("playerSpawned", function()
    dprint("playerSpawned")
    SpawnPlayer()
end)




local function RespawnPlayer()
    Citizen.CreateThread(function()
        local playerPed = PlayerPedId()
        DoScreenFadeOut(800)
        while not IsScreenFadedOut() do
            Citizen.Wait(50)
        end


        SetEntityCoordsNoOffset(playerPed, AVA.Player.Data.position, false, false, false, true)
        NetworkResurrectLocalPlayer(AVA.Player.Data.position, 0.0, true, false)
        SetPlayerInvincible(playerPed, false)
        ClearPedBloodDamage(playerPed)
        AVA.Player.IsDead = false

        SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))

        StopScreenEffect('DeathFailOut')
        DoScreenFadeIn(800)

        print(IsEntityDead(playerPed))
    end)
end

AddEventHandler("baseevents:onPlayerDied", function(killertype, killerpos)
    dprint("baseevents:onPlayerDied")
    AVA.Player.IsDead = true

    Wait(2000)
    RespawnPlayer()
end)

AddEventHandler("baseevents:onPlayerKilled", function(killerid, data)
    -- data :
    -- killertype
    -- weaponhash
    -- killerinveh
    -- killervehseat
    -- killervehname
    -- killerpos
    dprint("baseevents:onPlayerKilled")
    AVA.Player.IsDead = true

    Wait(2000)
    RespawnPlayer()
end)








-----------------------------------------
--------------- Multichar ---------------
-----------------------------------------

local playerChars = {}
local SelectCharMenu = RageUI.CreateMenu("", "Sélection de personnage", 0, 0, "avaui", "avaui_title_adezou")


function RageUI.PoolMenus:AvaCoreSelectChar()

    SelectCharMenu:IsVisible(function(Items)
        for i = 1, #playerChars, 1 do
            local char = playerChars[i]
            Items:AddButton(char.label, char.subtitle, { RightBadge = char.RightBadge, LeftBadge = char.LeftBadge, IsDisabled = char.disabled },
                function(onSelected, onEntered)
                    if onSelected then
                        if char.id == -1 then
                            ExecuteCommand("newchar")
                        else
                            ExecuteCommand(("changechar %s"):format(tostring(char.id)))
                        end
                        RageUI.Visible(SelectCharMenu, false)
                    end
                end)
        end
    end)


end
RegisterNetEvent("ava_core:client:selectChar", function(chars, maxChars)
    RageUI.CloseAll()
    playerChars = {}
    for i = 1, #chars, 1 do
        local char = chars[i]
        char.character = json.decode(char.character)
        if type(char) == "table"
            and char.character ~= nil
            and char.id ~= nil
            and char.last_played ~= nil
        then
            table.insert(playerChars, {
                label = ("%s %s"):format(char.character.firstname, char.character.lastname),
                id = char.id,
                disabled = char.last_played,
                subtitle = ("ID de personnage ~o~%s~s~%s"):format(tostring(char.id), char.last_played and "\nPersonnage actuel" or ""),
                RightBadge = function()
                    return {
                        BadgeDictionary = "mpleaderboard", BadgeTexture = char.character.sex == 1 and "leaderboard_female_icon" or "leaderboard_male_icon"
                    }
                end,
            })
        end
    end
    if #playerChars < maxChars then
        for i = 1, (maxChars - #playerChars), 1 do
            table.insert(playerChars, {
                label = "Nouveau personnage",
                id = -1,
                LeftBadge = function() return {BadgeDictionary = "commonmenu", BadgeTexture = "shop_new_star"} end,
            })
        end
    end
    if #playerChars > 1 then
        RageUI.Visible(SelectCharMenu, true)
    else
        AVA.ShowNotification("Vous devez avoir au minimum un personnage pour pouvoir en changer.", nil, "ava_core_logo", "Sélection de personnage", nil, nil, "ava_core_logo")
    end
end)





-- DEBUG COMMAND
RegisterCommand("respawn", function()
    exports.spawnmanager:spawnPlayer()
end)