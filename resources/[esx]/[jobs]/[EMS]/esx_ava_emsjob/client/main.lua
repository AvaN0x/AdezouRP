-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX = nil
PlayerData = nil
local FirstSpawn, PlayerLoaded = true, false
IsDead = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
	for k,v in pairs(Config.Hospitals) do
		local blip = AddBlipForCoord(v.Blip.Pos.x, v.Blip.Pos.y, v.Blip.Pos.z)

		SetBlipSprite(blip, v.Blip.Sprite)
		SetBlipScale(blip, v.Blip.Scale)
		SetBlipColour(blip, v.Blip.Color)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U('hospital'))
		EndTextCommandSetBlipName(blip)
    end
end)

-- Disable most inputs when dead
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsDead then
			DisableAllControlActions(0)
			EnableControlAction(0, 47, true) -- G
			EnableControlAction(0, 245, true) -- T
			EnableControlAction(0, 38, true) -- E
			EnableControlAction(0, 166, true) -- F5
			EnableControlAction(0, 168, true) -- F7
			EnableControlAction(0, 213, true) -- HOME
			EnableControlAction(0, 249, true) -- N

		else
			-- Citizen.Wait(500)
			SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
		end
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	PlayerLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	PlayerData.job2 = job2
end)

AddEventHandler('playerSpawned', function()
	IsDead = false

	if FirstSpawn then
		exports.spawnmanager:setAutoSpawn(false) -- disable respawn
		FirstSpawn = false

		ESX.TriggerServerCallback('esx_ava_emsjob:getDeathStatus', function(isDead)
			if isDead then
				while not PlayerLoaded do
					Citizen.Wait(1000)
				end
				Citizen.Wait(1000)
				SetEntityHealth(PlayerPedId(), 0)
				OnPlayerDeath()
			end
		end)
	end
end)

AddEventHandler('esx:onPlayerDeath', function(data)
    OnPlayerDeath()
end)

function OnPlayerDeath()
	IsDead = true
	ESX.UI.Menu.CloseAll()
	TriggerServerEvent('esx_ava_emsjob:setDeathStatus', true)

	StartDeathTimer()
	StartDistressSignal()

	StartScreenEffect('DeathFailOut', Config.ForceRespawnTimer * 60 * 1000, false)
end


function Normal()
    local playerPed = GetPlayerPed(-1)
    ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    -- SetPedMovementClipset(playerPed, "move_m@multiplayer", true)
    SetPedMotionBlur(playerPed, false)
end


function RPDeathRespawn()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	TriggerServerEvent('esx_ava_emsjob:setDeathStatus', false)
	SetEntityHealth(playerPed, 105)

	Citizen.CreateThread(function()
		DoScreenFadeOut(800)
		while not IsScreenFadedOut() do
			Citizen.Wait(10)
		end

		ESX.SetPlayerData('lastPosition', Config.RespawnPoint.coords)
		TriggerServerEvent('esx:updateLastPosition', Config.RespawnPoint.coords)
		RespawnPed(playerPed, Config.RespawnPoint.coords, Config.RespawnPoint.heading)

		StopScreenEffect('DeathFailOut')
		DoScreenFadeIn(800)
		Citizen.Wait(10)
		ClearPedTasksImmediately(playerPed)
		SetTimecycleModifier("spectator5") -- Je sait pas se que ça fait lel
		SetPedMotionBlur(playerPed, true)
		RequestAnimSet("move_injured_generic")
			while not HasAnimSetLoaded("move_injured_generic") do
				Citizen.Wait(0)
			end
		-- SetPedMovementClipset(playerPed, "move_injured_generic", true) // trouver une anim pour remettre l'anim de base ensuite dans Normal()
		PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
        PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)

        ESX.ShowAdvancedNotification('REANIMATION X', 'Unité X réanimation', 'Vous avez été réanimé par l\'unité X.', 'CHAR_CALL911', 1) -- todo local

        local ped = GetPlayerPed(PlayerId())
		local coords = GetEntityCoords(ped, false)
		local name = GetPlayerName(PlayerId())
		local x, y, z = table.unpack(GetEntityCoords(ped, false))
		TriggerServerEvent('esx_ambulance:NotificationBlipsX', x, y, z, name)
		Citizen.Wait(60*1000) -- Effets de la réanimation pendant 1 minute ( 60 seconde )
		Normal()
	end)
end

function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	TriggerEvent('playerSpawned', coords.x, coords.y, coords.z)
	ClearPedBloodDamage(ped)

	ESX.UI.Menu.CloseAll()
end




function StartDeathTimer()
	local earlySpawnTimer = ESX.Math.Round(Config.EarlyRespawnTimer / 1000)
	local ForceRespawnTimer = ESX.Math.Round(Config.ForceRespawnTimer / 1000)

	Citizen.CreateThread(function()
		-- early respawn timer
		while earlySpawnTimer > 0 and IsDead do
			Citizen.Wait(1000)

			if earlySpawnTimer > 0 then
				earlySpawnTimer = earlySpawnTimer - 1
			end
		end

		-- bleedout timer
		while ForceRespawnTimer > 0 and IsDead do
			Citizen.Wait(1000)

			if ForceRespawnTimer > 0 then
				ForceRespawnTimer = ForceRespawnTimer - 1
			end
		end
	end)

	Citizen.CreateThread(function()
		local text, timeHeld

		-- early respawn timer
		while earlySpawnTimer > 0 and IsDead do
			Citizen.Wait(0)
			text = _U('respawn_available_in', secondsToClock(earlySpawnTimer))

			DrawGenericTextThisFrame()

			SetTextEntry("STRING")
			AddTextComponentString(text)
			DrawText(0.5, 0.8)
		end

		-- bleedout timer
		while ForceRespawnTimer > 0 and IsDead do
			Citizen.Wait(0)
			text = _U('respawn_respawn_timer', secondsToClock(ForceRespawnTimer))
			text = text .. _U('respawn_respawn_prompt')

            if IsControlPressed(0, 38) and timeHeld > 60 then
                TriggerServerEvent('esx_ava_emsjob:uniteX')
                RPDeathRespawn()
                break
            end


			if IsControlPressed(0, 38) then
				timeHeld = timeHeld + 1
			else
				timeHeld = 0
			end

			DrawGenericTextThisFrame()

			SetTextEntry("STRING")
			AddTextComponentString(text)
			DrawText(0.5, 0.8)
		end

		if ForceRespawnTimer < 1 and IsDead then
			RPDeathRespawn()
		end
	end)
end

function StartDistressSignal()
	Citizen.CreateThread(function()
		local timer = Config.ForceRespawnTimer

		while timer > 0 and IsDead do
			Citizen.Wait(2)
			timer = timer - 30

			SetTextFont(4)
			SetTextScale(0.45, 0.45)
			SetTextColour(185, 185, 185, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			BeginTextCommandDisplayText('STRING')
			AddTextComponentSubstringPlayerName(_U('distress_send'))
			EndTextCommandDisplayText(0.175, 0.805)

			if IsControlPressed(0, 47) then
				local playerPed = PlayerPedId()
				local coords = GetEntityCoords(playerPed)
				TriggerServerEvent('esx_phone:send', 'ems', 'Besoin de réanimation', true, {["x"] = coords.x, ["y"] = coords.y, ["z"] = coords.z })
				Citizen.CreateThread(function()
					Citizen.Wait(1000 * 60 * 5)
					if IsDead then
						StartDistressSignal()
					end
				end)
				break
			end
		end
	end)
end


RegisterNetEvent('esx_ava_emsjob:useItem')
AddEventHandler('esx_ava_emsjob:useItem', function(itemName)
	ESX.UI.Menu.CloseAll()

	if itemName == 'medikit' then
		local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01' -- TODO better animations
		local playerPed = PlayerPedId()

		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)

			Citizen.Wait(500)
			while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
				Citizen.Wait(0)
				DisableAllControlActions(0)
			end
	
			TriggerEvent('esx_ava_emsjob:heal', 'big', true)
			ESX.ShowNotification(_U('used_medikit'))
		end)

	elseif itemName == 'bandage' then
		local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01' -- TODO better animations
		local playerPed = PlayerPedId()

		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)

			Citizen.Wait(500)
			while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
				Citizen.Wait(0)
				DisableAllControlActions(0)
			end

			TriggerEvent('esx_ava_emsjob:heal', 'small', true)
			ESX.ShowNotification(_U('used_bandage'))
		end)
	end
end)

RegisterNetEvent('esx_ava_emsjob:heal')
AddEventHandler('esx_ava_emsjob:heal', function(healType, quiet)
	local playerPed = PlayerPedId()
	local maxHealth = GetEntityMaxHealth(playerPed)

	if healType == 'small' then
		local health = GetEntityHealth(playerPed)
		local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 8))
		SetEntityHealth(playerPed, newHealth)
	elseif healType == 'big' then
		SetEntityHealth(playerPed, maxHealth)
	end

	if not quiet then
		ESX.ShowNotification(_U('healed'))
	end
end)

function secondsToClock(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format("%02.f", math.floor(seconds / 3600))
		local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60))

		return mins, secs
	end
end

function DrawGenericTextThisFrame()
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
end



-- revives
RegisterNetEvent('esx_ava_emsjob:revive')
AddEventHandler('esx_ava_emsjob:revive', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	TriggerServerEvent('esx_ava_emsjob:setDeathStatus', false)
	print(GetEntityMaxHealth(playerPed))
	Citizen.CreateThread(function()
		DoScreenFadeOut(800)
		while not IsScreenFadedOut() do
			Citizen.Wait(50)
		end

		local formattedCoords = {
			x = ESX.Math.Round(coords.x, 1),
			y = ESX.Math.Round(coords.y, 1),
			z = ESX.Math.Round(coords.z, 1)
		}

		ESX.SetPlayerData('lastPosition', formattedCoords)
		TriggerServerEvent('esx:updateLastPosition', formattedCoords)
		RespawnPed(playerPed, formattedCoords, 0.0)

		TriggerEvent('esx_avan0x:resetKO')
		SetEntityHealth(playerPed, 105)

		StopScreenEffect('DeathFailOut')
		DoScreenFadeIn(800)
	end)
end)

RegisterNetEvent('esx_ava_emsjob:revive2')
AddEventHandler('esx_ava_emsjob:revive2', function(debug)
	local playerPed = PlayerPedId()
	
	ESX.TriggerServerCallback('esx_ava_emsjob:getDeathStatus', function(isDead)
		if isDead or debug then
			local coords = GetEntityCoords(playerPed)
			TriggerServerEvent('esx_ava_emsjob:setDeathStatus', false)
			print(GetEntityMaxHealth(playerPed))
			Citizen.CreateThread(function()
				DoScreenFadeOut(800)
				while not IsScreenFadedOut() do
					Citizen.Wait(50)
				end

				local formattedCoords = {
					x = ESX.Math.Round(coords.x, 1),
					y = ESX.Math.Round(coords.y, 1),
					z = ESX.Math.Round(coords.z, 1)
				}

				ESX.SetPlayerData('lastPosition', formattedCoords)
				TriggerServerEvent('esx:updateLastPosition', formattedCoords)
				RespawnPed(playerPed, formattedCoords, 0.0)

				TriggerEvent('esx_avan0x:resetKO')
				SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))

				StopScreenEffect('DeathFailOut')
				DoScreenFadeIn(800)

				ESX.ShowAdvancedNotification('STAFF INFO', 'STAFF ~g~REVIVE', 'Tu as été revive par un staff.', 'CHAR_DEVIN', 8)
			end)
		else
			TriggerEvent('esx_avan0x:resetKO')
			SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
			ESX.ShowAdvancedNotification('STAFF INFO', 'STAFF ~g~HEAL', 'Tu as été heal par un staff.', 'CHAR_DEVIN', 8)
		end
	end)
end)

