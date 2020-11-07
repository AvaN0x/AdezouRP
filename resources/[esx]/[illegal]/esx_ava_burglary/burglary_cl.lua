-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
ESX = nil
PlayerData = nil
local isInside = false
local thisHouse = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()

	ESX.TriggerServerCallback('esx_ava_burglary:getHousesInfo', function(houseInfos)
		for ID, state in pairs(houseInfos) do
			Config.coords[ID].state = state
		end
	end)
end)


RegisterNetEvent('esx_ava_lockpick:onUse')
AddEventHandler('esx_ava_lockpick:onUse', function(xPlayer)
	canLockPick = true
	Citizen.Wait(100)
	canLockPick = false
end)

RegisterNetEvent('avan0x_lockpicking:LockpickingComplete')
AddEventHandler('avan0x_lockpicking:LockpickingComplete', function(result)
	local playerPed = GetPlayerPed(-1)
	ClearPedTasksImmediately(playerPed)
	if result then
		lockpicking = true
		Citizen.Wait(100)
		lockpicking = false
	end
end)

-- todo not working, fix later
-- --* safety to allow user to exit the house if they spawn inside
-- AddEventHandler('playerSpawned', function()
-- 	local playerPed = PlayerPedId()
-- 	local coords = GetEntityCoords(playerPed)
-- 	if not isInside and GetDistanceBetweenCoords(Config.Appartment.coord.x, Config.Appartment.coord.y, Config.Appartment.coord.z, coords.x, coords.y, coords.z, false) <= 23.0 then
-- 		isInside = true
-- 		LoopExit()
-- 	end
-- end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		if not isInside then
			thisHouseID, thisHouse = getClosestHouse()
		end
	end
end)

function getClosestHouse()
	for k, v in ipairs(Config.coords) do
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		if GetDistanceBetweenCoords(v.coord.x, v.coord.y, v.coord.z, coords.x, coords.y, coords.z, false) <= 2.0 then
			return k, v
		end
	end
	return nil
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if thisHouse and not isInside then
			if thisHouse.state == 0 then
				DrawText3D(thisHouse.coord.x, thisHouse.coord.y, thisHouse.coord.z, _U('house_weak_door'), 0.3)

				if canLockPick == true then
					local playerPed = PlayerPedId()
					TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
					TriggerEvent('avan0x_lockpicking:StartLockPicking')
					canLockPick = false
				end

				if lockpicking == true then
					isInside = true
					lockpicking = false
					TriggerServerEvent('esx_ava_burglary:enterHouse', thisHouseID)
					Teleport({x = Config.Appartment.coord.x, y = Config.Appartment.coord.y, z = Config.Appartment.coord.z - 0.98, h = Config.Appartment.coord.h})
					TryCallCops()
					LoopExit()
					ResetBurglary()
					while isInside do
						Citizen.Wait(10)
						local playerPed = PlayerPedId()
						local coords = GetEntityCoords(playerPed)
						for k, v in ipairs(Config.Furnitures) do
							if GetDistanceBetweenCoords(v.x, v.y, v.z, coords.x, coords.y, coords.z, false) <= 0.7 then
								local loop = 1000
								while loop > 0 do
									Citizen.Wait(10)
									loop = loop - 10
									if v.empty then
										DrawText3D(v.x, v.y, v.z, _U('empty'), 0.3)

									else
										DrawText3D(v.x, v.y, v.z, _U('press_search'), 0.3)

										if IsControlJustReleased(0, 38) then
											loop = 0
											local item = Config.StealableItems[math.random(#Config.StealableItems)]
											FreezeEntityPosition(playerPed, true)
											TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)

											exports['progressBars']:startUI(3000, _U('searching'))
											Citizen.Wait(3000)

											TriggerServerEvent('esx_ava_burglary:giveItem', item, 1)
											ESX.ShowHelpNotification(_U('found_in_furniture'))
											v.empty = true

											ClearPedTasksImmediately(playerPed)
											FreezeEntityPosition(playerPed, false)
										end
									end
								end
							end
						end
					end
				end

			elseif thisHouse.state == 1 then
				DrawText3D(thisHouse.coord.x, thisHouse.coord.y, thisHouse.coord.z, _U('house_user_inside_door'), 0.3)

			else
				DrawText3D(thisHouse.coord.x, thisHouse.coord.y, thisHouse.coord.z, _U('house_burglarized_door'), 0.3)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function ResetBurglary()
	for k, v in ipairs(Config.Furnitures) do
		v.empty = false
	end
end

function LoopExit()
	Citizen.CreateThread(function()
		while isInside do
			Citizen.Wait(10)
			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed)
			if GetDistanceBetweenCoords(Config.Appartment.coord.x, Config.Appartment.coord.y, Config.Appartment.coord.z, coords.x, coords.y, coords.z, false) <= 2.0 then
				local loop = 1000
				while loop > 0 do
					Citizen.Wait(10)
					loop = loop - 10
					DrawText3D(Config.Appartment.coord.x, Config.Appartment.coord.y, Config.Appartment.coord.z, _U('press_exit'), 0.3)

					if IsControlJustReleased(0, 38) then
						loop = 0
						if thisHouse then
							Teleport({x = thisHouse.coord.x, y = thisHouse.coord.y, z = thisHouse.coord.z - 0.98, h = thisHouse.coord.h})
							TriggerServerEvent('esx_ava_burglary:updateState', thisHouseID, 2)
						else
							Teleport({x = 296.81, y = -769.55, z = 28.35, h = 330.0})
						end
						isInside = false
					end
				end
			else
				Citizen.Wait(500)
			end
		end
	end)
end

function TryCallCops()
	local random = math.random(0, 100)
	if random <= 65 then
		Citizen.CreateThread(function()
			Citizen.Wait(math.random(5000, 10000))
			if isInside then -- only call the cops, if the user is still in the house
				TriggerServerEvent("esx_phone:sendEmergency", "police", "Un cambriolage est suspecté dans cette maison.", true, { ["x"] = thisHouse.coord.x, ["y"] = thisHouse.coord.y, ["z"] = thisHouse.coord.z })
			end
		end)
	end
end

function Teleport(coords)
	local playerPed = GetPlayerPed(-1)

	DoScreenFadeOut(100)
		Citizen.Wait(250)
		FreezeEntityPosition(playerPed, true)

		SetEntityCoords(playerPed, coords.x, coords.y, coords.z)
		if coords.h then
			SetEntityHeading(playerPed, coords.h)
		end

		Citizen.Wait(1000)
		FreezeEntityPosition(playerPed, false)
	DoScreenFadeIn(100)
end


function DrawText3D(x, y, z, text, size)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)

    if onScreen then
        SetTextScale(0.35, size or 0.35)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        SetTextOutline()

        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end


-- Set state for houses
RegisterNetEvent('esx_ava_burglary:setState')
AddEventHandler('esx_ava_burglary:setState', function(doorID, state)
	Config.coords[doorID].state = state
end)