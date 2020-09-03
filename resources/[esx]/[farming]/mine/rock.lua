local spawnedProps = 0
local Props = {}
local isPickingUp, isProcessing = false, false


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, config.zones.Mine.coords, true) < 50 then
			SpawnProps()
			Citizen.Wait(500)
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, config.zones.MineProcessing.coords, true) < 1 then
			if not isProcessing then
				ESX.ShowHelpNotification("Appuyer sur ~INPUT_CONTEXT~ pour ~g~Traiter")
			end

			if IsControlJustReleased(0, 38) and not isProcessing then
					Process()
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function Process()
	isProcessing = true
	
	exports['progressBars']:startUI(10000, "Traitement..") --ให้ค่าเวลาเท่ากับที่โชอะนิเมชั่น	
	TriggerServerEvent('caruby_mining:processStone')
	local timeLeft = 10000 / 1000
	local playerPed = PlayerPedId()
	Citizen.CreateThread(function()
		while timeLeft > 0 do
			Citizen.Wait(0)
	
			TriggerEvent("esx:openinventory2")
	
			end
			end)

	while timeLeft > 0 do
		Citizen.Wait(1000)
		timeLeft = timeLeft - 1
		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), config.zones.MineProcessing.coords, false) > 4 then
			TriggerServerEvent('caruby_mining:cancelProcessing')
			break
		end
	end

	isProcessing = false
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID

		for i=1, #Props, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(Props[i]), false) < 1 then
				nearbyObject, nearbyID = Props[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then
		
					if not isPickingUp then
						ESX.ShowHelpNotification("Appuyer sur ~INPUT_CONTEXT~ pour ~g~Miner")
					end

					if IsControlJustReleased(0, 38) and not isPickingUp then
						ESX.TriggerServerCallback('caruby_mining:canDrill', function(haveItem)
							if haveItem then
							isPickingUp = true
							
						ESX.TriggerServerCallback('caruby_mining:canPickUp', function(canPickUp)
							
								if canPickUp then
									Citizen.CreateThread(function()
										while isPickingUp == true do
											Citizen.Wait(0)
									
											TriggerEvent("esx:openinventory2")
									
											end
											end)						
									TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_CONST_DRILL', 0, false)
                                    
									exports['progressBars']:startUI(5000, "Forage...") --ให้ค่าเวลาเท่ากับที่โชอะนิเมชั่น	
									Citizen.Wait(5000)
									ClearPedTasks(playerPed)
									Citizen.Wait(1000)
					
									ESX.Game.DeleteObject(nearbyObject)
												
												table.remove(Props, nearbyID)
												spawnedProps = spawnedProps - 1
												
												TriggerServerEvent('caruby_mining:pickedUpStone')
											else
												ESX.ShowNotification("Vous n'avez plus de place")

											end

											isPickingUp = false
										
									end, 'stone')
							else
								ESX.ShowNotification("Vous devez acheter une perceuse")
							end
						
						end)
					end
				
		else
			Citizen.Wait(500)
		end

	end

end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(Props) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnProps()
	while spawnedProps < 25 do
		Citizen.Wait(0)
		local Coords = GeneratePropCoords()

		ESX.Game.SpawnLocalObject('prop_rock_4_a', Coords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)
			
			table.insert(Props, obj)
			spawnedProps = spawnedProps + 1
		end)
	end
end

function ValidateCoord(Coord)
	if spawnedProps > 0 then
		local validate = true

		for k, v in pairs(Props) do
			if GetDistanceBetweenCoords(Coord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(Coord, config.zones.Mine.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GeneratePropCoords()
	while true do
		Citizen.Wait(1)

		local CoordX, CoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-90, 90)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-90, 90)

		CoordX = config.zones.Mine.coords.x + modX
		CoordY = config.zones.Mine.coords.y + modY

		local coordZ = GetCoordZ(CoordX, CoordY)
		local coord = vector3(CoordX, CoordY, coordZ)

		if ValidateCoord(coord) then
			return coord
		end
	end
end

function GetCoordZ(x, y)
	local groundCheckHeights = { 40.0, 41.0, 42.0, 43.0, 44.0, 45.0, 46.0, 47.0, 48.0, 49.0, 50.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 43.0
end