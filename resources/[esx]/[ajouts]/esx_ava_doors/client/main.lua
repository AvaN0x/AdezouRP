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

	-- Update the door list
	ESX.TriggerServerCallback('esx_ava_doors:getDoorInfo', function(doorInfo)
		for doorID,state in pairs(doorInfo) do
			Config.DoorList[doorID].locked = state
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

-- Get objects every second, instead of every frame
Citizen.CreateThread(function()
	while true do
		for _,doorID in ipairs(Config.DoorList) do
			if doorID.doors then
				for k,v in ipairs(doorID.doors) do
					if not v.object or not DoesEntityExist(v.object) then
						if v.objName then
							v.object = GetClosestObjectOfType(v.objCoords, 1.0, GetHashKey(v.objName), false, false, false)
						else
							v.object = GetClosestObjectOfType(v.objCoords, 1.0, v.objHash, false, false, false)
						end
					end
				end
			else
				if not doorID.object or not DoesEntityExist(doorID.object) then
					if doorID.objName then
						doorID.object = GetClosestObjectOfType(doorID.objCoords, 1.0, GetHashKey(doorID.objName), false, false, false)
					else
						v.object = GetClosestObjectOfType(doorID.objCoords, 1.0, doorID.objHash, false, false, false)
					end
				end
			end
		end

		Citizen.Wait(1000)
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(5000)
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())

		for k,doorID in ipairs(Config.DoorList) do
			local distance

			distance = #(playerCoords - doorID.textCoords)
			-- if doorID.doors then
			-- 	distance = #(playerCoords - doorID.doors[1].objCoords)
			-- else
			-- 	distance = #(playerCoords - doorID.objCoords)
			-- end

			local isAuthorized = IsAuthorized(doorID)
			local maxDistance, size, displayText = 2.5, 0.5, _U('unlocked')

			if doorID.distance then
				maxDistance = doorID.distance
			end

			if distance < 50 then
				if doorID.doors then
					for _,v in ipairs(doorID.doors) do
						FreezeEntityPosition(v.object, doorID.locked)

						if doorID.locked and v.objYaw and GetEntityRotation(v.object).z ~= v.objYaw then
							SetEntityRotation(v.object, 0.0, 0.0, v.objYaw, 2, true)
						elseif not v.locked and v.objOpenYaw and GetEntityRotation(v.object).z ~= v.objOpenYaw then
							FreezeEntityPosition(v.object, not doorID.locked)
							SetEntityRotation(v.object, 0.0, 0.0, v.objYaw, 2, true)
						end
					end
				else
					FreezeEntityPosition(doorID.object, doorID.locked)

					if doorID.locked and doorID.objYaw and GetEntityRotation(doorID.object).z ~= doorID.objYaw then
						SetEntityRotation(doorID.object, 0.0, 0.0, doorID.objYaw, 2, true)
					elseif not doorID.locked and doorID.objOpenYaw and GetEntityRotation(doorID.object).z ~= doorID.objOpenYaw then
						FreezeEntityPosition(doorID.object, not doorID.locked)
						SetEntityRotation(doorID.object, 0.0, 0.0, doorID.objOpenYaw, 2, true)
					end
				end
			end

			if distance < maxDistance then
				if doorID.size then
					size = doorID.size
				end

				if doorID.locked then
					displayText = _U('locked')
				end

				if isAuthorized then
					displayText = _U('press_button', displayText)
				end

				ESX.Game.Utils.DrawText3D(doorID.textCoords, displayText, size)

				if IsControlJustReleased(0, 38) then
					if isAuthorized then
						doorID.locked = not doorID.locked

						print(k..' '..tostring(doorID.locked))
						TriggerServerEvent('esx_ava_doors:updateState', k, doorID.locked) -- Broadcast new state of the door to everyone
					end
				end

			  
			end
		end
	end
end)

function IsAuthorized(doorID)
	if PlayerData.job == nil or PlayerData.job2 == nil then
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
	Config.DoorList[doorID].locked = state
end)

-- LOCKPICKING DOOR

function FindClosestDoor()
	local playerCoords = GetEntityCoords(PlayerPedId())
	for k,doorID in ipairs(Config.DoorList) do
		local distance

		distance = #(playerCoords - doorID.textCoords)
		-- if doorID.doors then
		-- 	distance = #(playerCoords - doorID.doors[1].objCoords)
		-- else
		-- 	distance = #(playerCoords - doorID.objCoords)
		-- end

		local isAuthorized = IsAuthorized(doorID)
		local maxDistance, size, displayText = 2.5, 0.5, _U('unlocked')

		if doorID.distance then
			maxDistance = doorID.distance
		end

		if distance < maxDistance then
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
	-- print('useitem')
	closestDoor = nil
	closestDoor = FindClosestDoor()
	if closestDoor then
		-- print('finddoor')
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
    Citizen.CreateThread(function()
      ThreadID = GetIdOfThisThread()
      CurrentAction = 'lockpick'
      
	  if CurrentAction ~= nil then
		closestDoor.door.locked = not closestDoor.door.locked

		print(closestDoor.name..' '..tostring(closestDoor.door.locked))

        TriggerServerEvent('esx_ava_doors:updateState', closestDoor.name, closestDoor.door.locked)
      end
      
	  CurrentAction = nil
	  closestDoor = nil
      TerminateThisThread()
	end)
  elseif result then
	local randi = math.random(1, 3)
	if randi == 1 then
		TriggerServerEvent('esx_ava_lockpick:removeKit')
	end
  end
end)