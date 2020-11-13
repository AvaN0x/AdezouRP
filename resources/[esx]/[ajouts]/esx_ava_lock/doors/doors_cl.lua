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

	SetAllAuthorized()

	ESX.TriggerServerCallback('esx_ava_doors:getDoorInfo', function(doorInfo)
		for doorID,state in pairs(doorInfo) do
			Config.Doors.DoorList[doorID].locked = state
		end
	end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	SetAllAuthorized()
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	PlayerData.job2 = job2
	SetAllAuthorized()
end)

Citizen.CreateThread(function()
	for k,doorID in ipairs(Config.Doors.DoorList) do
		if not doorID.distance then
			doorID.distance = Config.Doors.DefaultDistance
		end
		doorID.checkDistance = doorID.distance * 2
		if doorID.checkDistance > Config.Doors.ObjectDistance then
			doorID.checkDistance = Config.Doors.ObjectDistance
		end
		if not doorID.size then
			doorID.size = Config.Doors.DefaultSize
		end
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(1000)
	while true do
		Citizen.Wait(10)
		local playerCoords = GetEntityCoords(PlayerPedId())

		for k,doorID in ipairs(Config.Doors.DoorList) do
			local distance = #(playerCoords - doorID.textCoords)

			if distance < doorID.checkDistance then
				if doorID.doors then
					for _,v in ipairs(doorID.doors) do
						if not v.object or not DoesEntityExist(v.object) then
							v.object = GetClosestObjectOfType(v.objCoords, 1.0, v.objHash or GetHashKey(v.objName), false, false, false)
						end
						FreezeEntityPosition(v.object, doorID.locked)

						if doorID.locked and v.objYaw and GetEntityRotation(v.object).z ~= v.objYaw then
							SetEntityRotation(v.object, 0.0, 0.0, v.objYaw, 2, true)
						elseif not doorID.locked and v.objOpenYaw and GetEntityRotation(v.object).z ~= v.objOpenYaw then
							FreezeEntityPosition(v.object, not doorID.locked)
							SetEntityRotation(v.object, 0.0, 0.0, v.objYaw, 2, true)
						end
					end
				else
					if not doorID.object or not DoesEntityExist(doorID.object) then
						doorID.object = GetClosestObjectOfType(doorID.objCoords, 1.0, doorID.objHash or GetHashKey(doorID.objName), false, false, false)
					end
					FreezeEntityPosition(doorID.object, doorID.locked)

					if doorID.locked and doorID.objYaw and GetEntityRotation(doorID.object).z ~= doorID.objYaw then
						SetEntityRotation(doorID.object, 0.0, 0.0, doorID.objYaw, 2, true)
					elseif not doorID.locked and doorID.objOpenYaw and GetEntityRotation(doorID.object).z ~= doorID.objOpenYaw then
						FreezeEntityPosition(doorID.object, not doorID.locked)
						SetEntityRotation(doorID.object, 0.0, 0.0, doorID.objOpenYaw, 2, true)
					end
				end

				if distance < doorID.distance then
					local displayText = _U('doors_unlocked')
					if doorID.locked then
						displayText = _U('doors_locked')
					end

					if doorID.authorized then
						displayText = _U('doors_press_button', displayText)
					end

					DrawText3D(doorID.textCoords.x, doorID.textCoords.y, doorID.textCoords.z, displayText, doorID.size)

					if IsControlJustReleased(0, 38) then
						if doorID.authorized then
							doorID.locked = not doorID.locked
							TriggerEvent("esx_ava_lock:dooranim")
							TriggerServerEvent('esx_ava_doors:updateState', k, doorID.locked)
						end
					end
				end
			end
		end
	end
end)

function SetAllAuthorized()
	for k,doorID in ipairs(Config.Doors.DoorList) do
		doorID.authorized = IsAuthorized(doorID)
	end
end

function IsAuthorized(doorID)
	if PlayerData == nil or PlayerData.job == nil or PlayerData.job2 == nil then
		return false
	end

	for _,job in pairs(doorID.authorizedJobs) do
		if job == PlayerData.job.name or job == PlayerData.job2.name then
			return true
		end
	end

	return false
end

-- Set state for a door
RegisterNetEvent('esx_ava_doors:setState')
AddEventHandler('esx_ava_doors:setState', function(doorID, state)
	Config.Doors.DoorList[doorID].locked = state
end)


-- LOCKPICKING DOOR
function FindClosestDoor()
	local playerCoords = GetEntityCoords(PlayerPedId())
	for k,doorID in ipairs(Config.Doors.DoorList) do
		local distance = #(playerCoords - doorID.textCoords)

		if distance < doorID.distance then
			local isAuthorized = IsAuthorized(doorID)
			if doorID.locked and not isAuthorized then
				return {name = k, door = doorID}
			end
		end
	end
	return nil
end

local closestDoor = nil

RegisterNetEvent('esx_ava_lockpick:onUse')
AddEventHandler('esx_ava_lockpick:onUse', function()
	closestDoor = nil
	closestDoor = FindClosestDoor()
	if closestDoor then
		local playerPed = GetPlayerPed(-1)
		TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
		TriggerEvent('avan0x_lockpicking:StartLockPicking')
	end
end)


RegisterNetEvent('avan0x_lockpicking:LockpickingComplete')
AddEventHandler('avan0x_lockpicking:LockpickingComplete', function(result) 
	local playerPed = GetPlayerPed(-1)
	ClearPedTasksImmediately(playerPed)
	if result and closestDoor then
		CurrentAction = 'lockpick'
		if CurrentAction ~= nil then
			closestDoor.door.locked = not closestDoor.door.locked
			TriggerServerEvent('esx_ava_doors:updateState', closestDoor.name, closestDoor.door.locked)
		end

		CurrentAction = nil
		closestDoor = nil
	end
end)