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
            
            if AVA.Player.Data.position ~= playerCoords and AVA.Player.HasSpawned then
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
	while not AVA.Player.Loaded do Wait(10) end
    local playerPed = PlayerPedId()
    AVA.Player.HasSpawned = true

    dprint(json.encode(AVA.Player.Data.position), AVA.Player.Data.position)
	if AVA.Player.Data.position then
		SetEntityCoords(playerPed, AVA.Player.Data.position)
	end

	-- TriggerEvent("ava_core:client:restoreLoadout") -- restore loadout

	IsDead = false
end)

AVA.GetPlayerData = function()
    -- if player is not loaded, Data can't possibly (not sure) be incomplete
    if AVA.Player.Loaded then
        return AVA.Player.Data
    end
    return
end