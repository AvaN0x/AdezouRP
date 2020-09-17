-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
ESX = nil
PlayerData = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()

	-- Update the teleporters list
	ESX.TriggerServerCallback('esx_ava_teleports:getTeleporterInfo', function(teleporterInfo)
		for tpID,state in pairs(teleporterInfo) do
			Config.Teleporters[tpID].locked = state
		end
	end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	PlayerData.job2 = job2
end)


Citizen.CreateThread(function()
	Citizen.Wait(5000)
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())

		for k,tpID in ipairs(Config.Teleporters) do
			local distance

			distance = #(playerCoords - tpID.tpEnter.pos)
			-- if tpID.doors then
			-- 	distance = #(playerCoords - tpID.doors[1].objCoords)
			-- else
			-- 	distance = #(playerCoords - tpID.objCoords)
			-- end

			local isAuthorized = IsAuthorized(tpID)
			local maxDistance, helpText = 2.5, _U('unlocked')

			if tpID.distance then
				maxDistance = tpID.distance
			end

			-- if distance < 50 then
			-- 	if tpID.doors then
			-- 		for _,v in ipairs(tpID.doors) do
			-- 			FreezeEntityPosition(v.object, tpID.locked)

			-- 			if tpID.locked and v.objYaw and GetEntityRotation(v.object).z ~= v.objYaw then
			-- 				SetEntityRotation(v.object, 0.0, 0.0, v.objYaw, 2, true)
			-- 			elseif not v.locked and v.objOpenYaw and GetEntityRotation(v.object).z ~= v.objOpenYaw then
			-- 				FreezeEntityPosition(v.object, not tpID.locked)
			-- 				SetEntityRotation(v.object, 0.0, 0.0, v.objYaw, 2, true)
			-- 			end
			-- 		end
			-- 	else
			-- 		FreezeEntityPosition(tpID.object, tpID.locked)

			-- 		if tpID.locked and tpID.objYaw and GetEntityRotation(tpID.object).z ~= tpID.objYaw then
			-- 			SetEntityRotation(tpID.object, 0.0, 0.0, tpID.objYaw, 2, true)
			-- 		elseif not tpID.locked and tpID.objOpenYaw and GetEntityRotation(tpID.object).z ~= tpID.objOpenYaw then
			-- 			FreezeEntityPosition(tpID.object, not tpID.locked)
			-- 			SetEntityRotation(tpID.object, 0.0, 0.0, tpID.objOpenYaw, 2, true)
			-- 		end
			-- 	end
			-- end

			if distance < maxDistance then
				if tpID.locked then
					helpText = _U('locked')
				end

				if isAuthorized then
					helpText = _U('press_button', helpText)
				end

				ESX.Game.Utils.DrawText3D(tpID.tpEnter.pos, tpID.tpEnter.label, 0.5) -- draw label
				ESX.ShowHelpNotification(helpText)

				if IsControlJustReleased(0, 38) then -- E
					if not tpID.locked then
						print("tp here")
					end
					-- if isAuthorized then
					-- 	tpID.locked = not tpID.locked

					-- 	print(k..' '..tostring(tpID.locked))
					-- 	TriggerServerEvent('esx_ava_teleports:updateState', k, tpID.locked) -- Broadcast new state of the door to everyone
					-- end
				end
				if IsControlJustReleased(0, 73) then -- X
					if isAuthorized then
						tpID.locked = not tpID.locked

						print(k..' '..tostring(tpID.locked))
						TriggerServerEvent('esx_ava_teleports:updateState', k, tpID.locked) -- Broadcast new state of the door to everyone
					end
				end

			end
		end
	end
end)



function IsAuthorized(tpID)
	if PlayerData.job == nil or PlayerData.job2 == nil then
		return false
	end

	for _,job in pairs(tpID.authorizedJobs) do
		if job == PlayerData.job.name or job == PlayerData.job2.name then
			return true
		end
	end

	return false
end

-- Set state for a teleporter
RegisterNetEvent('esx_ava_teleports:setState')
AddEventHandler('esx_ava_teleports:setState', function(tpID, state)
	Config.Teleporters[tpID].locked = state
end)








-- function Teleport(table, location)
--     if location == 'enter' then
--         DoScreenFadeOut(100)
-- 		-- FreezeEntityPosition(GetPlayerPed(-1),true)
--         Citizen.Wait(750)

--         ESX.Game.Teleport(PlayerPedId(), table['Exit'])

--         DoScreenFadeIn(100)
--     else
--         DoScreenFadeOut(100)

--         Citizen.Wait(750)

--         ESX.Game.Teleport(PlayerPedId(), table['Enter'])

--         DoScreenFadeIn(100)
--     end
-- end
