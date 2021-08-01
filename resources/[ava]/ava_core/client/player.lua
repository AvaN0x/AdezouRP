-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVA.Player = {}
AVA.Player.Loaded = false

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
		local playerCoords = GetEntityCoords(playerPed)

		if AVA.Player.Data.position ~= playerCoords and not IsEntityDead(playerPed) then
			-- TriggerServerEvent("es:updatePositions", playerCoords.x, playerCoords.y, playerCoords.z)
			-- TriggerServerEvent("es:updatePositions", playerCoords)
            AVA.Player.Data.position = playerCoords
		end
	end
end)

RegisterNetEvent("ava_core:client:playerLoaded", function(data)
    AVA.Player.Data = data
    print(json.encode(AVA.Player.Data), AVA.Player.Data.position)
    AVA.Player.Loaded = true
    print("AVA.Player.Loaded loaded")
end)

AddEventHandler("playerSpawned", function()
	while not AVA.Player.Loaded do Wait(10) end
    local playerPed = PlayerPedId()
    
    print(json.encode(AVA.Player.Data.position), AVA.Player.Data.position)
	if AVA.Player.Data.position then
		SetEntityCoords(playerPed, AVA.Player.Data.position)
	end

	-- TriggerEvent("ava_core:client:restoreLoadout") -- restore loadout

	IsDead = false
end)