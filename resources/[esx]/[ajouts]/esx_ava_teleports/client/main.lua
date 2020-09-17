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
end)


Citizen.CreateThread(function()
	Citizen.Wait(5000)
	for k,tpID in ipairs(Config.Teleporters) do
		for k2,tpID2 in ipairs({tpID.tpEnter, tpID.tpExit}) do
			if not tpID2.size then 
				tpID2.size = Config.DefaultSize 
			end
			if not tpID2.color then 
				tpID2.color = Config.DefaultColor 
			end
		end
	end

	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())

		for k,tpID in ipairs(Config.Teleporters) do
			for k2,tpID2 in ipairs({tpID.tpEnter, tpID.tpExit}) do
				local distance = #(playerCoords - tpID2.pos)
				
				if distance < Config.DrawDistance then
					DrawMarker(27, tpID2.pos.x, tpID2.pos.y, tpID2.pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, tpID2.size.x, tpID2.size.y, tpID2.size.z, tpID2.color.r, tpID2.color.g, tpID2.color.b, 100, false, true, 2, false, false, false, false)
				end
				
				if distance < tpID2.size.x then
					local isAuthorized = IsAuthorized(tpID)
					local helpText = _U('unlocked')
					local label = "~g~"
					if tpID.locked then
						helpText = _U('locked')
						label = "~r~"
					end
					if isAuthorized then
						helpText = _U('press_button', helpText)
					end

					ESX.Game.Utils.DrawText3D(vector3(tpID2.pos.x, tpID2.pos.y, tpID2.pos.z + 0.2), label .. tpID2.label, 0.8) -- draw label
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
