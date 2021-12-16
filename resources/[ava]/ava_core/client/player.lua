-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVA.Player = {}
AVA.Player.Loaded = false
AVA.Player.HasSpawned = false
AVA.Player.FirstSpawn = true
AVA.Player.IsDead = false

-- * replaced with event playerJoining
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
    while not AVA.Player.Data do
        Wait(10)
    end

    while true do
        Wait(AVAConfig.SavePlayerPedDataTimeout)

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        if AVA.Player.Data.position ~= playerCoords and AVA.Player.HasSpawned and not AVA.Player.CreatingChar then
            TriggerServerEvent("ava_core:server:updatePosition", playerCoords)
            AVA.Player.Data.position = playerCoords
        end

        local playerHealth = GetEntityHealth(playerPed)
        if AVA.Player.Data.health ~= playerHealth then
            TriggerServerEvent("ava_core:server:updateHealth", playerHealth)
            AVA.Player.Data.health = playerHealth
        end
    end
end)

local function SpawnPlayer()
    AVA.Player.IsDead = false
    AVA.Player.HasSpawned = true

    while not AVA.Player.Loaded do
        Wait(10)
    end
    local playerPed = PlayerPedId()

    -- dprint(AVA.Player.Data.position)
    if AVA.Player.Data.position then
        RequestCollisionAtCoord(AVA.Player.Data.position)
        SetEntityCoords(playerPed, AVA.Player.Data.position)
        SetEntityHeading(playerPed, 0.0)
    end
    SetEntityHealth(playerPed, AVA.Player.Data.health ~= nil and AVA.Player.Data.health or 200)

    if AVA.Player.FirstSpawn then
        exports.spawnmanager:setAutoSpawn(false) -- disable auto respawn

        -- dprint(json.encode(AVA.Player.Data.skin))
        AVA.Player.FirstSpawn = false
        if AVA.Player.Data.skin then
            exports.skinchanger:loadSkin(AVA.Player.Data.skin)
        else
            exports.skinchanger:loadSkin({sex = 0})
        end
    end

    TriggerServerEvent("ava_core:server:reloadLoadout")
end

RegisterNetEvent("ava_core:client:playerUpdatedData", function(data)
    for k, v in pairs(data) do
        dprint("Edit local value of ", k)
        AVA.Player.Data[k] = v
    end
end)

RegisterNetEvent("ava_core:client:playerLoaded", function(data)
    AVA.Player.Data = data
    dprint("jobs", json.encode(AVA.Player.Data.jobs))
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
    dprint("playerSpawned", AVAConfig.EnablePVP)
    if AVAConfig.EnablePVP then
        SetCanAttackFriendly(PlayerPedId(), true, false)
        NetworkSetFriendlyFireOption(true)
    end
    SpawnPlayer()
end)

local function RespawnPlayer()
    Citizen.CreateThread(function()
        local playerPed = PlayerPedId()
        DoScreenFadeOut(800)
        while not IsScreenFadedOut() do
            Citizen.Wait(50)
        end

        local position = AVA.Player.Data and AVA.Player.Data.position or GetEntityCoords(playerPed)

        SetEntityCoordsNoOffset(playerPed, position, false, false, false, true)
        NetworkResurrectLocalPlayer(position, 0.0, true, false)
        SetPlayerInvincible(playerPed, false)
        TriggerEvent("playerSpawned", {x = position.x, y = position.y, z = position.z, heading = 0.0})
        ClearPedBloodDamage(playerPed)
        AVA.Player.IsDead = false

        SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))

        StopScreenEffect("DeathFailOut")
        DoScreenFadeIn(800)
    end)
end

AddEventHandler("ava_core:client:playerDeath", function()
    AVA.Player.IsDead = true

    Wait(2000)
    RespawnPlayer()
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
            Items:AddButton(char.label, char.subtitle, {RightBadge = char.RightBadge, LeftBadge = char.LeftBadge, IsDisabled = char.disabled},
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
                    return {BadgeDictionary = "mpleaderboard", BadgeTexture = char.character.sex == 1 and "leaderboard_female_icon" or "leaderboard_male_icon"}
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
                    return {BadgeDictionary = "commonmenu", BadgeTexture = "shop_new_star"}
                end,
            })
        end
    end
    if #playerChars > 1 then
        RageUI.Visible(SelectCharMenu, true)
    else
        AVA.ShowNotification(GetString("chars_need_at_least_one_char_to_change"), nil, "ava_core_logo", "Sélection de personnage", nil, nil, "ava_core_logo")
    end
end)

------------------------------------------------
--------------- Get data exports ---------------
------------------------------------------------

local function waitLoadedPlayer()
    local p = promise.new()

    Citizen.CreateThread(function()
        while not AVA.Player.Loaded do
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
AVA.Player.getSkinData = function()
    waitLoadedPlayer()
    return AVA.Player.Data.skin
end
exports("getPlayerSkinData", AVA.Player.getSkinData)

---Get data from player character
---@return character
AVA.Player.getCharacterData = function()
    waitLoadedPlayer()
    return AVA.Player.Data.character
end
exports("getPlayerCharacterData", AVA.Player.getCharacterData)

-- DEBUG COMMAND
RegisterCommand("respawn", function()
    SpawnPlayer()
end)
RegisterCommand("revive", function()
    RespawnPlayer()
end)
