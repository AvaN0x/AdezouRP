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
			local distance = #(playerCoords - tpID.tpEnter.pos)
			local isAuthorized = IsAuthorized(tpID)
			local maxDistance = 2.5
			local helpText = _U('unlocked')

			if tpID.distance then maxDistance = tpID.distance end

			if distance < maxDistance then
				if tpID.locked then	helpText = _U('locked')	end
				if isAuthorized then helpText = _U('press_button', helpText) end

				ESX.Game.Utils.DrawText3D(vector3(tpID.tpEnter.pos.x, tpID.tpEnter.pos.y, tpID.tpEnter.pos.z + 0.5), tpID.tpEnter.label, 0.5) -- draw label
				ESX.ShowHelpNotification(helpText)

				if IsControlJustReleased(0, 38) then -- E
					if not tpID.locked then
						print("tp here")
					end
				end
				if IsControlJustReleased(0, 73) then -- X
					if isAuthorized then
						tpID.locked = not tpID.locked
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
