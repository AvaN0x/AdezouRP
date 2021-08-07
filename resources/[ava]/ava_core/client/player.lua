-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVA.Player = {}
AVA.Player.Loaded = false
AVA.Player.HasSpawned = false

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
        local playerPed = PlayerPedId()
        if not IsEntityDead(playerPed) then
            local playerCoords = GetEntityCoords(playerPed)

            if AVA.Player.Data.position ~= playerCoords and AVA.Player.HasSpawned and not AVA.Player.CreatingChar then
                TriggerServerEvent("ava_core:server:updatePosition", playerCoords)
                AVA.Player.Data.position = playerCoords
            end
        end
	end
end)

RegisterNetEvent("ava_core:client:playerLoaded", function(data)
    AVA.Player.Data = data
    dprint(AVA.Player.Data.citizenId, json.encode(AVA.Player.Data), AVA.Player.Data.position)
    AVA.Player.Loaded = true
    dprint("AVA.Player.Loaded loaded")

    if AVA.Player.HasSpawned then
        AVA.Player.HasSpawned = false
        dprint('TriggerEvent("playerSpawned")')
        -- TriggerEvent("playerSpawned")
        exports.spawnmanager:spawnPlayer()
    end
end)

AddEventHandler("playerSpawned", function()
    dprint("playerSpawned")
    AVA.Player.IsDead = false

	while not AVA.Player.Loaded do Wait(10) end
    local playerPed = PlayerPedId()

    dprint(json.encode(AVA.Player.Data.position), AVA.Player.Data.position)
	if AVA.Player.Data.position then
		SetEntityCoords(playerPed, AVA.Player.Data.position)
	end


    if not AVA.Player.HasSpawned then
        if AVA.Player.Data.skin then
            TriggerEvent('skinchanger:loadSkin', AVA.Player.Data.skin)
        else
            TriggerEvent('skinchanger:loadDefaultModel', true)
        end

    end

	-- TriggerEvent("ava_core:client:restoreLoadout") -- restore loadout
    AVA.Player.HasSpawned = true
end)

AVA.GetPlayerData = function()
    -- if player is not loaded, Data can't possibly (not sure) be incomplete
    if AVA.Player.Loaded then
        return AVA.Player.Data
    end
    return
end

-- DEBUG COMMAND
RegisterCommand("respawn", function()
    exports.spawnmanager:spawnPlayer()
end)