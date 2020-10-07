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
			Config.Teleports.TeleportersList[tpID].locked = state
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
	for k,tpID in ipairs(Config.Teleports.TeleportersList) do
		for k2,tpID2 in ipairs({tpID.tpEnter, tpID.tpExit}) do
			if not tpID2.size then
				tpID2.size = Config.Teleports.DefaultSize
			end
			if not tpID2.color then
				tpID2.color = Config.Teleports.DefaultColor
			end
		end
	end

	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())
		for k,tpID in ipairs(Config.Teleports.TeleportersList) do
			for k2,tpID2 in ipairs({
				{from = tpID.tpEnter, to = tpID.tpExit},
				{from = tpID.tpExit, to = tpID.tpEnter}
			}) do
				local distance = #(playerCoords - tpID2.from.pos)
				
				if distance < Config.Teleports.DrawDistance then
					DrawMarker(27, tpID2.from.pos.x, tpID2.from.pos.y, tpID2.from.pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, tpID2.from.size.x, tpID2.from.size.y, tpID2.from.size.z, tpID2.from.color.r, tpID2.from.color.g, tpID2.from.color.b, 100, false, true, 2, false, false, false, false)
				end
				
				if distance < tpID2.from.size.x then
					local isAuthorized = IsAuthorized(tpID)
					local helpText = _U('teleports_unlocked')
					local label = "~g~"
					if tpID.locked then
						helpText = _U('teleports_locked')
						label = "~r~"
					end
					if isAuthorized then
						helpText = _U('teleports_press_button', helpText)
					end

					DrawText3D(tpID2.from.pos.x, tpID2.from.pos.y, tpID2.from.pos.z + 0.2, label .. tpID2.from.label, 0.40) -- draw label
					ESX.ShowHelpNotification(helpText)

					if IsControlJustReleased(0, 38) then -- E
						if not tpID.locked then
							Teleport(tpID2.to.pos, tpID.allowVehicles, tpID2.to.heading)
						end
					end
					if IsControlJustReleased(0, 73) then -- X
						if isAuthorized then
							tpID.locked = not tpID.locked
							TriggerEvent("esx_ava_lock:dooranim")
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
	Config.Teleports.TeleportersList[tpID].locked = state
end)


function Teleport(coords, allowVehicles, heading)
	local ped = GetPlayerPed(-1)

	DoScreenFadeOut(100)
		Citizen.Wait(250)
		FreezeEntityPosition(ped, true)

		SetPedCoordsKeepVehicle(ped, coords.x, coords.y, coords.z)
		if heading then
			SetEntityHeading(ped, heading)
		end

		Citizen.Wait(500)
		
		FreezeEntityPosition(ped, false)
	DoScreenFadeIn(100)
end



-- LOCKPICKING TELEPORT
function FindClosestTeleport()
	local playerCoords = GetEntityCoords(PlayerPedId())
	for k,tpID in ipairs(Config.Teleports.TeleportersList) do
		for k2,tpID2 in ipairs({tpID.tpEnter, tpID.tpExit}) do
			local distance = #(playerCoords - tpID2.pos)
			if distance < tpID2.size.x then
				local isAuthorized = IsAuthorized(tpID)
				if tpID.locked and not isAuthorized then
					return {name = k, teleport = tpID}
				end
			end
		end
	end
	return nil
end

local closestTeleport = nil

RegisterNetEvent('esx_ava_lockpick:onUse')
AddEventHandler('esx_ava_lockpick:onUse', function()
	closestTeleport = nil
	closestTeleport = FindClosestTeleport()
	if closestTeleport then
		local playerPed = GetPlayerPed(-1)
		TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
		TriggerEvent('avan0x_lockpicking:StartLockPicking')
	end
end)


RegisterNetEvent('avan0x_lockpicking:LockpickingComplete')
AddEventHandler('avan0x_lockpicking:LockpickingComplete', function(result)
	local playerPed = GetPlayerPed(-1)
	ClearPedTasksImmediately(playerPed)
	if result and closestTeleport then
		-- Citizen.CreateThread(function()
		-- 	ThreadID = GetIdOfThisThread()

			closestTeleport.teleport.locked = not closestTeleport.teleport.locked
			TriggerServerEvent('esx_ava_teleports:updateState', closestTeleport.name, closestTeleport.teleport.locked)

			closestTeleport = nil
		-- 	TerminateThisThread()
		-- end)
	end
end)
