-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
ESX = nil
PlayerData = nil
actualGang = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()

	SetAllDoorsAuthorized()

	ESX.TriggerServerCallback('esx_ava_doors:getDoorInfo', function(doorInfo)
		for doorID,state in pairs(doorInfo) do
			Config.Doors.DoorList[doorID].locked = state
		end
	end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	SetAllDoorsAuthorized()
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	PlayerData.job2 = job2
	SetAllDoorsAuthorized()
end)

RegisterNetEvent('esx_ava_jobs:setGang')
AddEventHandler('esx_ava_jobs:setGang', function(gang)
	actualGang = gang
	SetAllDoorsAuthorized()
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

function DrawEntityBox(entity, r, g, b)
    local coords = GetEntityCoords(entity)
    DrawText3D(coords.x, coords.y, coords.z - 0.1, string.format("%.2f", GetEntityHeading(entity)) or "", 0.3)

	local min, max = GetModelDimensions(GetEntityModel(entity))

	local pad = 0.001;

	-- Bottom
	local bottom1 = GetOffsetFromEntityInWorldCoords(entity, min.x - pad, min.y - pad, min.z - pad)
	local bottom2 = GetOffsetFromEntityInWorldCoords(entity, max.x + pad, min.y - pad, min.z - pad)
	local bottom3 = GetOffsetFromEntityInWorldCoords(entity, max.x + pad, max.y + pad, min.z - pad)
	local bottom4 = GetOffsetFromEntityInWorldCoords(entity, min.x - pad, max.y + pad, min.z - pad)

	-- Top
	local top1 = GetOffsetFromEntityInWorldCoords(entity, min.x - pad, min.y - pad, max.z + pad)
	local top2 = GetOffsetFromEntityInWorldCoords(entity, max.x + pad, min.y - pad, max.z + pad)
	local top3 = GetOffsetFromEntityInWorldCoords(entity, max.x + pad, max.y + pad, max.z + pad)
	local top4 = GetOffsetFromEntityInWorldCoords(entity, min.x - pad, max.y + pad, max.z + pad)

	-- bottom
	DrawLine(bottom1, bottom2, r, g, b, 255)
	DrawLine(bottom1, bottom4, r, g, b, 255)
	DrawLine(bottom2, bottom3, r, g, b, 255)
	DrawLine(bottom3, bottom4, r, g, b, 255)

	-- top
	DrawLine(top1, top2, 255, r, g, b, 255)
	DrawLine(top1, top4, 255, r, g, b, 255)
	DrawLine(top2, top3, 255, r, g, b, 255)
	DrawLine(top3, top4, 255, r, g, b, 255)

	-- bottom to top
	DrawLine(bottom1, top1, r, g, b, 255)
	DrawLine(bottom2, top2, r, g, b, 255)
	DrawLine(bottom3, top3, r, g, b, 255)
	DrawLine(bottom4, top4, r, g, b, 255)

	-- top face
	DrawPoly(top1, top2, top3, r, g, b, 128)
	DrawPoly(top4, top1, top3, r, g, b, 128)

	-- bottom face
	DrawPoly(bottom2, bottom1, bottom3, r, g, b, 128)
	DrawPoly(bottom1, bottom4, bottom3, r, g, b, 128)

	-- back face
	DrawPoly(top2, top1, bottom1, r, g, b, 128)
	DrawPoly(bottom1, bottom2, top2, r, g, b, 128)

	-- front face
	DrawPoly(top4, top3, bottom4, r, g, b, 128)
	DrawPoly(bottom3, bottom4, top3, r, g, b, 128)

	-- right face
	DrawPoly(top3, top2, bottom2, r, g, b, 128)
	DrawPoly(bottom2, bottom3, top3, r, g, b, 128)

	-- left face
	DrawPoly(top1, top4, bottom1, r, g, b, 128)
	DrawPoly(bottom4, bottom1, top4, r, g, b, 128)
end


Citizen.CreateThread(function()
	Citizen.Wait(1000)
	while Config.Doors.Debug do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())

		for k,doorID in ipairs(Config.Doors.DoorList) do
			local distance = #(playerCoords - (doorID.textCoords or playerCoords))

			if distance < doorID.checkDistance then
				if doorID.doors then
					for _,v in ipairs(doorID.doors) do
						if not v.object or not DoesEntityExist(v.object) then
							v.object = GetClosestObjectOfType(v.objCoords, 1.0, v.objHash or GetHashKey(v.objName), false, false, false)
						end
						if distance < doorID.distance then
							DrawEntityBox(v.object, 255, 255, 255)
						else
							DrawEntityBox(v.object, 128, 128, 128)
						end
					end
				else
					if not doorID.object or not DoesEntityExist(doorID.object) then
						doorID.object = GetClosestObjectOfType(doorID.objCoords, 1.0, doorID.objHash or GetHashKey(doorID.objName), false, false, false)
					end
					if distance < doorID.distance then
						DrawEntityBox(doorID.object, 255, 255, 255)
					else
						DrawEntityBox(doorID.object, 128, 128, 128)
					end
				end
				if not doorID.textCoords then
					local min, max = GetModelDimensions(GetEntityModel(doorID.object or doorID.doors[1].object))
					doorID.textCoords = GetOffsetFromEntityInWorldCoords(doorID.object or doorID.doors[1].object, min.x, 0.0, 0.0)
					print(k .. " new text coords : " .. doorID.textCoords)
				end

				SetTextColour(255, 255, 255, 255)
				SetTextFont(0)
				SetTextScale(0.34, 0.34)
				SetTextWrap(0.0, 1.0)
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString("X\t" .. string.format("%.2f", doorID.textCoords.x) .. "\nY\t" .. string.format("%.2f", doorID.textCoords.y) .. "\nZ\t" .. string.format("%.2f", doorID.textCoords.z))
				DrawText(0.8, 0.88)

				if IsControlJustReleased(0, Config.Doors.DebugKey) then
					local offset = tonumber(ESX.KeyboardInput(_('enter_x_offset'), 0, 10))
					if type(offset) == "number" or type(offset) == "float" then
						local min, max = GetModelDimensions(GetEntityModel(doorID.object or doorID.doors[1].object))
						doorID.textCoords = GetOffsetFromEntityInWorldCoords(doorID.object or doorID.doors[1].object, min.x + offset, 0.0, 0.0)
						TriggerEvent('avan0x_hud:copyToClipboard', "vector3(" .. string.format("%.2f", doorID.textCoords.x) .. ", " .. string.format("%.2f", doorID.textCoords.y) .. ", " .. string.format("%.2f", doorID.textCoords.z) .. ")")
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(1000)
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())

		for k,doorID in ipairs(Config.Doors.DoorList) do
			if doorID.textCoords then
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
	end
end)

function SetAllDoorsAuthorized()
	if Config.Doors.Debug then
		for k,doorID in ipairs(Config.Doors.DoorList) do
			doorID.authorized = true
		end
	else
		for k,doorID in ipairs(Config.Doors.DoorList) do
			doorID.authorized = IsDoorAuthorized(doorID)
		end
	end
end

function IsDoorAuthorized(doorID)
	if PlayerData == nil or PlayerData.job == nil or PlayerData.job2 == nil then
		return false
	end

	if doorID.authorizedJobs then
		for _,job in pairs(doorID.authorizedJobs) do
			if job == PlayerData.job.name or job == PlayerData.job2.name then
				return true
			end
		end
	end
	if doorID.authorizedGangs and actualGang then
		for _,gang in pairs(doorID.authorizedGangs) do
			if gang == actualGang.name then
				return true
			end
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