-------------------------------------------
------- REMADE BY GITHUB.COM/AVAN0X -------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX          = nil
local IsDead = false
local IsAnimated = false

local STATUS_MAX = 1000000


local IsAlreadyDrunk, DrunkLevel = nil, nil
local IsAlreadyDrugged = nil
local IsAlreadyInjured, InjureLevel, InjureLoop = nil, nil, 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler('esx_ava_needs:onRevive', function()
    TriggerEvent('esx_status:getStatus', 'hunger', function(status)
        if status.val < 0.05 * STATUS_MAX then
            TriggerEvent("esx_status:add", "hunger", 10000)
        end
    end)
    TriggerEvent('esx_status:getStatus', 'thirst', function(status)
        if status.val < 0.05 * STATUS_MAX then
            TriggerEvent("esx_status:add", "thirst", 10000)
        end
    end)
    TriggerEvent("esx_status:remove", "drunk", STATUS_MAX * 0.2)
    TriggerEvent("esx_status:remove", "drugged", STATUS_MAX * 0.2)
	TriggerEvent("esx_status:add", "injured", 250000)
end)

RegisterNetEvent('esx_ava_needs:healPlayer')
AddEventHandler('esx_ava_needs:healPlayer', function()
	-- restore hunger & thirst
	TriggerEvent('esx_status:set', 'hunger', 1000000)
	TriggerEvent('esx_status:set', 'thirst', 1000000)
	TriggerEvent('esx_status:set', 'drunk', 0)
	TriggerEvent('esx_status:set', 'drugged', 0)
	TriggerEvent('esx_status:set', 'injured', 0)

	-- restore hp
	local playerPed = PlayerPedId()
	SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
end)

AddEventHandler('esx:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	if IsDead then
		TriggerEvent('esx_ava_needs:onRevive')
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
		status.remove(500)
	end)

	TriggerEvent('esx_status:registerStatus', 'drugged', 0, '#15A517', function(status)
        return false
    end, function(status)
		status.remove(500)
    end)

	TriggerEvent('esx_status:registerStatus', 'injured', 0, '#03bdae', function(status)
        return false
    end, function(status)
		status.remove(150)
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
				elseif status.val > 0.99 * STATUS_MAX then
                    TriggerEvent("esx_status:add", "injured", 300)
                end
			end)

			TriggerEvent('esx_status:getStatus', 'thirst', function(status)
				if status.val == 0 then
					if prevHealth <= 150 then
						health = health - 5
					else
						health = health - 1
					end
				elseif status.val > 0.99 * STATUS_MAX then
                    TriggerEvent("esx_status:add", "injured", 300)
                end
			end)

			TriggerEvent('esx_status:getStatus', 'drunk', function(status)
				if status.val > 0 then
					local start = not IsAlreadyDrunk

					local level = 0
					if status.val <= 250000 then
						level = 0
					elseif status.val <= 500000 then
						level = 1
					else
                        if status.val > 0.95 * STATUS_MAX then
                            health = health - 1
                        end
						level = 2
					end
					if level ~= DrunkLevel then
						Drunk(level, start)
					end
					IsAlreadyDrunk = true
					DrunkLevel = level
				else
					if IsAlreadyDrunk then
						Reality()
					end
					IsAlreadyDrunk = false
					DrunkLevel = -1
				end
			end)

			TriggerEvent('esx_status:getStatus', 'drugged', function(status)
				if status.val > 0 then
					local start = not IsAlreadyDrugged

                    if status.val > 0.95 * STATUS_MAX then
                        health = health - 1
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

            TriggerEvent('esx_status:getStatus', 'injured', function(status)
				if status.val > 0 then
					local start = not IsAlreadyInjured

					local level = 0
					if status.val <= 200000 then
						level = 0
					elseif status.val <= 500000 then
						level = 1
					else
						level = 2
					end
					if level ~= InjureLevel or InjureLoop == 10 then
                        InjureLoop = 0
						Injured(level, start, InjureLevel)
					end
					IsAlreadyInjured = true
					InjureLevel = level
                    InjureLoop = InjureLoop + 1
                else
					if IsAlreadyInjured then
						Reality(true)
					end
					IsAlreadyInjured = false
					InjureLevel = -1
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
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.13, 0.052, 0.031, -70.0, 175.0, 90.0, true, true, false, true, 1, true)

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
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_ava_needs:onSmokeDrug')
AddEventHandler('esx_ava_needs:onSmokeDrug', function()
    if not IsAnimated then
        IsAnimated = true
        local playerPed = PlayerPedId()

        TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_SMOKING_POT", 0, 1)
        Citizen.Wait(3000)
        ClearPedTasksImmediately(playerPed)
        IsAnimated = false
    end
end)

RegisterNetEvent('esx_ava_needs:onTakePill')
AddEventHandler('esx_ava_needs:onTakePill', function()
    if not IsAnimated then
        IsAnimated = true
        local playerPed = PlayerPedId()

        ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
            TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 8.0, -8, -1, 49, 0, 0, 0, 0)

            Citizen.Wait(1000)
            IsAnimated = false
            ClearPedSecondaryTask(playerPed)
        end)
    end
end)




-- drunk effect

function Drunk(level, start)
	Citizen.CreateThread(function()
		local playerPed = PlayerPedId()
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
		local playerPed = PlayerPedId()

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

-- injured effect

function Injured(level, start, oldLevel)
	Citizen.CreateThread(function()
		local playerPed = PlayerPedId()
		if start then
			DoScreenFadeOut(800)
			Wait(1000)
		end

        RequestAnimSet("move_injured_generic")
        while not HasAnimSetLoaded("move_injured_generic") do
            Citizen.Wait(0)
        end
		SetPedMovementClipset(playerPed, "move_injured_generic", true)

		if level == 0 then

        elseif level == 1 then
            -- old level was 2
            if oldLevel == 2 then
                ClearTimecycleModifier()
            end

        elseif level == 2 then
            -- SetTimecycleModifier("phone_cam5")

            SetTimecycleModifier("pulse")

            -- SetTimecycleModifier("redmist")
            -- SetTimecycleModifierStrength(0.7)

        end



		SetPedMotionBlur(playerPed, true)
		-- SetPedIsDrunk(playerPed, true)

		if start then
			DoScreenFadeIn(800)
		end
	end)
end



-- back to reality

function Reality(noFade)
	Citizen.CreateThread(function()
		local playerPed = PlayerPedId()
	
        if not noFade then
            DoScreenFadeOut(800)
            Wait(1000)
        end
	
		ClearTimecycleModifier()
		ResetScenarioTypesEnabled()
		ResetPedMovementClipset(playerPed, 0)
		SetPedIsDrunk(playerPed, false)
		SetPedMotionBlur(playerPed, false)
	
        if not noFade then
            DoScreenFadeIn(800)
        end
	end)
end
