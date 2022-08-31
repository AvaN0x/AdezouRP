-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVA.Player = {}
AVA.Player.Loaded = false
AVA.Player.HasSpawned = false
AVA.Player.IsDead = false

-- * replaced with event playerJoining
-- Citizen.CreateThread(function()
--     repeat
--         Wait(5)
--     until NetworkIsSessionStarted()

--     TriggerServerEvent("ava_core:server:playerJoined")
-- end)

Citizen.CreateThread(function()
    while true do
        AVA.Player.playerPed = PlayerPedId()
        AVA.Player.playerCoords = GetEntityCoords(AVA.Player.playerPed)

        Wait(500)
    end
end)

Citizen.CreateThread(function()
    while not AVA.Player.Data do
        Wait(10)
    end

    while true do
        Wait(AVAConfig.SavePlayerPedDataTimeout)

        if AVA.Player.Data.position ~= AVA.Player.playerCoords and AVA.Player.HasSpawned and not AVA.Player.CreatingChar then
            AVA.Player.Data.position = AVA.Player.playerCoords
            TriggerServerEvent("ava_core:server:updatePosition", AVA.Player.Data.position)
        end

        local playerHealth = AVA.Player.IsDead == true
            and 0
            or GetEntityHealth(AVA.Player.playerPed)
        if AVA.Player.Data.health ~= playerHealth then
            TriggerServerEvent("ava_core:server:updateHealth", playerHealth)
            AVA.Player.Data.health = playerHealth
        end
    end
end)

RegisterNetEvent("ava_core:client:playerUpdatedData", function(data)
    for k, v in pairs(data) do
        dprint("Edit local value of ", k)
        AVA.Player.Data[k] = v
    end
end)

RegisterNetEvent("ava_core:client:playerLoaded", function(data)
    AVA.Player.IsDead = false
    AVA.Player.HasSpawned = false
    AVA.Player.Data = data
    dprint("citizenId", AVA.Player.Data.citizenId, "character", json.encode(AVA.Player.Data.character), "position",
        AVA.Player.Data.position, "health", AVA.Player.Data.health)
    AVA.Player.Loaded = true

    exports.spawnmanager:setAutoSpawn(false) -- disable auto respawn
    exports.spawnmanager:spawnPlayer({
        x = AVA.Player.Data.position.x,
        y = AVA.Player.Data.position.y,
        z = AVA.Player.Data.position.z,
        heading = 0.0,
        model = GetHashKey('mp_m_freemode_01'),
        skipFade = false
    }, function()
        AVA.Player.playerPed = PlayerPedId()

        if AVAConfig.EnablePVP then
            SetCanAttackFriendly(PlayerPedId(), true, false)
            NetworkSetFriendlyFireOption(true)
        end

        -- Player is not dead at this time
        TriggerEvent("ava_core:client:playerIsDead", false)

        -- Use setPedSkin and not setPlayerSkin because we already got the playerPed
        -- Use return value to get a valid skin array
        if AVA.Player.Data.skin then
            AVA.Player.Data.skin = exports.ava_mp_peds:setPedSkin(AVA.Player.playerPed, AVA.Player.Data.skin)
        else
            AVA.Player.Data.skin = exports.ava_mp_peds:setPedSkin(AVA.Player.playerPed, { gender = 0 })
        end
        -- If gender changed with setPedSkin, then we have to get playerped again
        AVA.Player.playerPed = PlayerPedId()

        -- Player can die if data.health is 0
        -- We use data and not AVA.Player.Data for health because the thread which save the player health could already be running
        local health = GetEntityMaxHealth(AVA.Player.playerPed)
        if type(data.health) == "number" and data.health >= 0 then
            health = data.health
        end
        SetEntityHealth(AVA.Player.playerPed, health)

        TriggerServerEvent("ava_core:server:reloadLoadout")

        TriggerServerEvent("ava_core:server:playerSpawned")
        TriggerEvent("ava_core:client:playerSpawned")

        ShutdownLoadingScreen()
        ShutdownLoadingScreenNui()
    end)
    dprint("AVA.Player.Loaded loaded")
end)

AddEventHandler("playerSpawned", function(data)
    AVA.Player.HasSpawned = true
end)

AddEventHandler("ava_core:client:playerDeath", function()
    AVA.Player.IsDead = true
    TriggerEvent("ava_core:client:playerIsDead", true)

    if AVAConfig.NPWD then
        -- TODO disable phone
        exports.npwd:setPhoneVisible(false)
    end
end)

AddEventHandler("ava_deaths:client:playerRevived", function()
    AVA.Player.IsDead = false
    TriggerEvent("ava_core:client:playerIsDead", false)

    TriggerServerEvent("ava_core:server:reloadLoadout")

    -- TODO enable phone if it should
end)

------------------------------------
--------------- Save ---------------
------------------------------------
AddTextEntry("AVA_BSY_SPNR", GetString("player_being_saved"))
local saveBusySpinnerState = false

RegisterNetEvent("ava_core:client:startSave", function()
    Citizen.CreateThread(function()
        saveBusySpinnerState = true
        BeginTextCommandBusyspinnerOn("AVA_BSY_SPNR")
        EndTextCommandBusyspinnerOn(4)

        -- we hide the busy spinner after 5 secondes if it's still shown, this should not happen but it's a security
        Wait(5000)
        if BusyspinnerIsOn() and saveBusySpinnerState then
            saveBusySpinnerState = false
            BusyspinnerOff()
        end
    end)
end)

RegisterNetEvent("ava_core:client:endSave", function()
    Citizen.CreateThread(function()
        -- Show the busyspinner for at least 500ms
        Wait(500)
        if BusyspinnerIsOn() then
            saveBusySpinnerState = false
            BusyspinnerOff()
        end
    end)
end)

-----------------------------------------
--------------- Multichar ---------------
-----------------------------------------

local playerChars = {}
local SelectCharMenu = RageUI.CreateMenu("", GetString("select_char_menu_title"), 0, 0, "avaui", "avaui_title_adezou")

function RageUI.PoolMenus:AvaCoreSelectChar()

    SelectCharMenu:IsVisible(function(Items)
        for i = 1, #playerChars, 1 do
            local char = playerChars[i]
            Items:AddButton(char.label, char.subtitle,
                { RightBadge = char.RightBadge, LeftBadge = char.LeftBadge, IsDisabled = char.disabled },
                function(onSelected, onEntered)
                    if onSelected then
                        if char.id == -1 then
                            ExecuteCommand("newchar")
                        else
                            ExecuteCommand(("changechar %s"):format(tostring(char.id)))
                        end
                        RageUI.CloseAll()
                    end
                end)
        end
    end)

end

RegisterNetEvent("ava_core:client:selectChar", function(chars, maxChars)
    if AVA.Player.IsDead or AVA.Player.CreatingChar then
        return
    end
    RageUI.CloseAll()
    playerChars = {}
    for i = 1, #chars, 1 do
        local char = chars[i]
        if type(char) == "table" and char.character ~= nil and char.id ~= nil then
            char.character = json.decode(char.character)
            table.insert(playerChars, {
                label = ("%s %s"):format(char.character.firstname, char.character.lastname),
                id = char.id,
                disabled = not not char.last_played,
                subtitle = GetString("select_char_menu_subtitle", tostring(char.id),
                    char.last_played and GetString("select_char_menu_subtitle_actual_char") or ""),
                RightBadge = function()
                    return { BadgeDictionary = "mpleaderboard",
                        BadgeTexture = char.character.sex == 1 and "leaderboard_female_icon" or "leaderboard_male_icon" }
                end,
            })
        end
    end
    if #playerChars < maxChars then
        for i = 1, (maxChars - #playerChars), 1 do
            table.insert(playerChars, {
                label = "Nouveau personnage",
                id = -1,
                LeftBadge = function()
                    return { BadgeDictionary = "commonmenu", BadgeTexture = "shop_new_star" }
                end,
            })
        end
    end
    if #playerChars > 1 then
        RageUI.Visible(SelectCharMenu, true)
    else
        AVA.ShowNotification(GetString("chars_need_at_least_one_char_to_change"), nil, "ava_core_logo",
            "Sélection de personnage", nil, nil, "ava_core_logo")
    end
end)

----------------------------------------------
--------------- Utiity exports ---------------
----------------------------------------------

local canOpenMenu = function()
    if AVA.Player.IsDead or AVA.Player.CreatingChar then
        return false
    end
    TriggerEvent("ava_core:client:canOpenMenu")
    return not WasEventCanceled()
end
exports("canOpenMenu", canOpenMenu)

------------------------------------------------
--------------- Get data exports ---------------
------------------------------------------------

local function waitLoadedPlayer()
    local p = promise.new()

    Citizen.CreateThread(function()
        while not AVA.Player.Loaded or not AVA.Player.HasSpawned do
            Wait(10)
        end
        p:resolve()
    end)

    return Citizen.Await(p)
end

---Get data from player
---@return any
AVA.Player.getData = function()
    waitLoadedPlayer()
    return AVA.Player.Data
end
exports("getPlayerData", AVA.Player.getData)

---Get skin data from player
---@return any
AVA.Player.getPlayerSkinData = function()
    waitLoadedPlayer()
    return AVA.Player.Data.skin
end
exports("getPlayerSkinData", AVA.Player.getPlayerSkinData)

---Get data from player character
---@return character
AVA.Player.getCharacterData = function()
    waitLoadedPlayer()
    return AVA.Player.Data.character
end
exports("getPlayerCharacterData", AVA.Player.getCharacterData)
