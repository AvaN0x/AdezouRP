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
















-- DEBUG COMMAND
RegisterCommand("respawn", function()
    exports.spawnmanager:spawnPlayer()
end)