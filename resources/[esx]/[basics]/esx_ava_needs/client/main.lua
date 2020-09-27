ESX          = nil
local IsDead = false
local IsAnimated = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler('esx_ava_needs:resetStatus', function()
	TriggerEvent('esx_status:set', 'hunger', 500000)
	TriggerEvent('esx_status:set', 'thirst', 500000)
end)

RegisterNetEvent('esx_ava_needs:healPlayer')
AddEventHandler('esx_ava_needs:healPlayer', function()
	-- restore hunger & thirst
	TriggerEvent('esx_status:set', 'hunger', 1000000)
	TriggerEvent('esx_status:set', 'thirst', 1000000)
	TriggerEvent('esx_status:set', 'drunk', 0)
	TriggerEvent('esx_status:set', 'drugged', 0)

	-- restore hp
	local playerPed = PlayerPedId()
	SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
end)

AddEventHandler('esx:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	if IsDead then
		TriggerEvent('esx_ava_needs:resetStatus')
	end

	IsDead = false
end)

AddEventHandler('esx_status:loaded', function(status)

	TriggerEvent('esx_status:registerStatus', 'hunger', 1000000, '#FFFF00', function(status)
		return false
	end, function(status)
		status.remove(75)
	end)

	TriggerEvent('esx_status:registerStatus', 'thirst', 1000000, '#0099FF', function(status)
		return false
	end, function(status)
		status.remove(100)
	end)

	TriggerEvent('esx_status:registerStatus', 'drunk', 0, '#8F15A5', function(status)
        return false
    end, function(status)
		status.remove(1500)
	end)
	
	TriggerEvent('esx_status:registerStatus', 'drugged', 0, '#15A517', function(status)
        return false
    end, function(status)
		status.remove(1500)
    end)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1000)

			local playerPed  = PlayerPedId()
			local prevHealth = GetEntityHealth(playerPed)
			local health     = prevHealth

			TriggerEvent('esx_status:getStatus', 'hunger', function(status)
				if status.val == 0 then
					if prevHealth <= 150 then
						health = health - 5
					else
						health = health - 1
					end
				end
			end)

			TriggerEvent('esx_status:getStatus', 'thirst', function(status)
				if status.val == 0 then
					if prevHealth <= 150 then
						health = health - 5
					else
						health = health - 1
					end
				end
			end)

			TriggerEvent('esx_status:getStatus', 'drunk', function(status)
				if status.val > 0 then
					local start = true
					if IsAlreadyDrunk then
						start = false
					end

					local level = 0
					if status.val <= 250000 then
						level = 0
					elseif status.val <= 500000 then
						level = 1
					else
						level = 2
					end
					if level ~= DrunkLevel then
						Drunk(level, start)
					end
					IsAlreadyDrunk = true
					DrunkLevel     = level
				end
				if status.val == 0 then
					if IsAlreadyDrunk then
						Reality()
					end
					IsAlreadyDrunk = false
					DrunkLevel     = -1
				end
			end)

			TriggerEvent('esx_status:getStatus', 'drugged', function(status)
				if status.val > 0 then
					local start = true
					if IsAlreadyDrugged then
						start = false
					end
					
					Drugged(start)
					IsAlreadyDrugged = true
				end
				if status.val == 0 then
					if IsAlreadyDrugged then
						Reality()
					end
					IsAlreadyDrugged = false
				end
			end)

			if health ~= prevHealth then
				SetEntityHealth(playerPed, health)
			end
		end
	end)
end)

AddEventHandler('esx_ava_needs:isEating', function(cb)
	cb(IsAnimated)
end)

RegisterNetEvent('esx_ava_needs:onEat')
AddEventHandler('esx_ava_needs:onEat', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_cs_burger_01'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_ava_needs:onDrink')
AddEventHandler('esx_ava_needs:onDrink', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_ld_flow_bottle'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.15, 0.018, 0.031, -100.0, 55.0, 350.0, true, true, false, true, 1, true)


			ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)





-- drunk effect

function Drunk(level, start)
	Citizen.CreateThread(function()
		local playerPed = GetPlayerPed(-1)
		if start then
			DoScreenFadeOut(800)
			Wait(1000)
		end

		if level == 0 then
			RequestAnimSet("move_m@drunk@slightlydrunk")
			while not HasAnimSetLoaded("move_m@drunk@slightlydrunk") do
			Citizen.Wait(0)
			end
			SetPedMovementClipset(playerPed, "move_m@drunk@slightlydrunk", true)
		elseif level == 1 then
			RequestAnimSet("move_m@drunk@moderatedrunk")
			while not HasAnimSetLoaded("move_m@drunk@moderatedrunk") do
			Citizen.Wait(0)
			end
			SetPedMovementClipset(playerPed, "move_m@drunk@moderatedrunk", true)
		elseif level == 2 then
			RequestAnimSet("move_m@drunk@verydrunk")
			while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
			Citizen.Wait(0)
			end
			SetPedMovementClipset(playerPed, "move_m@drunk@verydrunk", true)
		end

		SetTimecycleModifier("spectator5")
		SetPedMotionBlur(playerPed, true)
		SetPedIsDrunk(playerPed, true)

		if start then
			DoScreenFadeIn(800)
		end
	end)
end

-- drugged effect

function Drugged(start)
	Citizen.CreateThread(function()
		local playerPed = GetPlayerPed(-1)

		if start then
			DoScreenFadeOut(1000)
			Wait(1000)
		end

		--Anim goes here
		Citizen.Wait(0)
		SetTimecycleModifier("DRUG_gas_huffin")

		if start then
			DoScreenFadeIn(2000)
		end
	end)
end

function Reality()
	Citizen.CreateThread(function()
	
		local playerPed = GetPlayerPed(-1)
	
		DoScreenFadeOut(800)
		Wait(1000)
	
		ClearTimecycleModifier()
		ResetScenarioTypesEnabled()
		ResetPedMovementClipset(playerPed, 0)
		SetPedIsDrunk(playerPed, false)
		SetPedMotionBlur(playerPed, false)
	
		DoScreenFadeIn(800)
	end)
end

RegisterNetEvent('esx_ava_needs:onDrinkAlcohol')
AddEventHandler('esx_ava_needs:onDrinkAlcohol', function()
	local playerPed = GetPlayerPed(-1)
	
	TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_DRINKING", 0, 1)
	Citizen.Wait(1000)
	ClearPedTasksImmediately(playerPed)
end)

RegisterNetEvent('esx_ava_needs:onSmokeDrug')
AddEventHandler('esx_ava_needs:onSmokeDrug', function()
	local playerPed = GetPlayerPed(-1)
	
	TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_SMOKING_POT", 0, 1)
	Citizen.Wait(3000)
	ClearPedTasksImmediately(playerPed)
end)
