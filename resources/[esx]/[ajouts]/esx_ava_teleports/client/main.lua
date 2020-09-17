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
	-- ESX.TriggerServerCallback('esx_ava_doors:getDoorInfo', function(doorInfo)
	-- 	for doorID,state in pairs(doorInfo) do
	-- 		Config.DoorList[doorID].locked = state
	-- 	end
	-- end)
end)

-- RegisterNetEvent('esx:setJob')
-- AddEventHandler('esx:setJob', function(job)
-- 	PlayerData.job = job
-- end)

-- RegisterNetEvent('esx:setJob2')
-- AddEventHandler('esx:setJob2', function(job2)
-- 	PlayerData.job2 = job2
-- end)

-- -- Get objects every second, instead of every frame
-- Citizen.CreateThread(function()
-- 	while true do
-- 		for _,doorID in ipairs(Config.DoorList) do
-- 			if doorID.doors then
-- 				for k,v in ipairs(doorID.doors) do
-- 					if not v.object or not DoesEntityExist(v.object) then
-- 						if v.objName then
-- 							v.object = GetClosestObjectOfType(v.objCoords, 1.0, GetHashKey(v.objName), false, false, false)
-- 						else
-- 							v.object = GetClosestObjectOfType(v.objCoords, 1.0, v.objHash, false, false, false)
-- 						end
-- 					end
-- 				end
-- 			else
-- 				if not doorID.object or not DoesEntityExist(doorID.object) then
-- 					if doorID.objName then
-- 						doorID.object = GetClosestObjectOfType(doorID.objCoords, 1.0, GetHashKey(doorID.objName), false, false, false)
-- 					else
-- 						v.object = GetClosestObjectOfType(doorID.objCoords, 1.0, doorID.objHash, false, false, false)
-- 					end
-- 				end
-- 			end
-- 		end

-- 		Citizen.Wait(1000)
-- 	end
-- end)

-- Citizen.CreateThread(function()
-- 	Citizen.Wait(5000)
-- 	while true do
-- 		Citizen.Wait(0)
-- 		local playerCoords = GetEntityCoords(PlayerPedId())

-- 		for k,doorID in ipairs(Config.DoorList) do
-- 			local distance

-- 			distance = #(playerCoords - doorID.textCoords)
-- 			-- if doorID.doors then
-- 			-- 	distance = #(playerCoords - doorID.doors[1].objCoords)
-- 			-- else
-- 			-- 	distance = #(playerCoords - doorID.objCoords)
-- 			-- end

-- 			local isAuthorized = IsAuthorized(doorID)
-- 			local maxDistance, size, helpText = 2.5, 0.5, _U('unlocked')

-- 			if doorID.distance then
-- 				maxDistance = doorID.distance
-- 			end

-- 			if distance < 50 then
-- 				if doorID.doors then
-- 					for _,v in ipairs(doorID.doors) do
-- 						FreezeEntityPosition(v.object, doorID.locked)

-- 						if doorID.locked and v.objYaw and GetEntityRotation(v.object).z ~= v.objYaw then
-- 							SetEntityRotation(v.object, 0.0, 0.0, v.objYaw, 2, true)
-- 						elseif not v.locked and v.objOpenYaw and GetEntityRotation(v.object).z ~= v.objOpenYaw then
-- 							FreezeEntityPosition(v.object, not doorID.locked)
-- 							SetEntityRotation(v.object, 0.0, 0.0, v.objYaw, 2, true)
-- 						end
-- 					end
-- 				else
-- 					FreezeEntityPosition(doorID.object, doorID.locked)

-- 					if doorID.locked and doorID.objYaw and GetEntityRotation(doorID.object).z ~= doorID.objYaw then
-- 						SetEntityRotation(doorID.object, 0.0, 0.0, doorID.objYaw, 2, true)
-- 					elseif not doorID.locked and doorID.objOpenYaw and GetEntityRotation(doorID.object).z ~= doorID.objOpenYaw then
-- 						FreezeEntityPosition(doorID.object, not doorID.locked)
-- 						SetEntityRotation(doorID.object, 0.0, 0.0, doorID.objOpenYaw, 2, true)
-- 					end
-- 				end
-- 			end

-- 			if distance < maxDistance then
-- 				if doorID.size then
-- 					size = doorID.size
-- 				end

-- 				if doorID.locked then
-- 					helpText = _U('locked')
-- 				end

-- 				if isAuthorized then
-- 					helpText = _U('press_button', helpText)
-- 				end

-- 				-- ESX.Game.Utils.DrawText3D(doorID.textCoords, helpText, size) -- draw label

-- 				if IsControlJustReleased(0, 38) then
-- 					if isAuthorized then
-- 						doorID.locked = not doorID.locked

-- 						print(k..' '..tostring(doorID.locked))
-- 						TriggerServerEvent('esx_ava_doors:updateState', k, doorID.locked) -- Broadcast new state of the door to everyone
-- 					end
-- 				end

			  
-- 			end
-- 		end
-- 	end
-- end)

-- function IsAuthorized(doorID)
-- 	if PlayerData.job == nil or PlayerData.job2 == nil then
-- 		return false
-- 	end

-- 	for _,job in pairs(doorID.authorizedJobs) do
-- 		if job == PlayerData.job.name or job == PlayerData.job2.name then
-- 			return true
-- 		end
-- 	end

-- 	return false
-- end

-- -- Set state for a door
-- RegisterNetEvent('esx_ava_doors:setState')
-- AddEventHandler('esx_ava_doors:setState', function(doorID, state)
-- 	Config.DoorList[doorID].locked = state
-- end)








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
