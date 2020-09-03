local spawnedCocaLeaf = 0
local CocaPlants = {}
local isPickingUp, isProcessing = false, false


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.CokeField.coords, true) < 50 then
			SpawnCocaPlants()
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

		if GetDistanceBetweenCoords(coords, Config.CircleZones.CokeProcessing.coords, true) < 2 then
			--if not isProcessing then
				--ESX.ShowHelpNotification(_U('coke_processprompt'))
			--end

			if IsControlJustReleased(0, Keys['E']) and not isProcessing then

				if Config.LicenseEnable then
					ESX.TriggerServerCallback('esx_license:checkLicense', function(hasProcessingLicense)
						if hasProcessingLicense then
							ProcesscokeLeaf()
						else
							OpenBuyLicenseMenu('coke_processing')
						end
					end, GetPlayerServerId(PlayerId()), 'coke_processing')
				else
					ProcessCokeLeaf()
				end

			end
		elseif GetDistanceBetweenCoords(coords, Config.CircleZones.CokeProcessing2.coords, true) < 2 then
			--if not isProcessing then
				--ESX.ShowHelpNotification(_U('coke_processprompt2'))
			--end

			if IsControlJustReleased(0, Keys['E']) and not isProcessing then

				if Config.LicenseEnable then
					ESX.TriggerServerCallback('esx_license:checkLicense', function(hasProcessingLicense)
						if hasProcessingLicense then
							ProcessCoke()
						else
							OpenBuyLicenseMenu('coke_processing2')
						end
					end, GetPlayerServerId(PlayerId()), 'coke_processing2')
				else
					ProcessCoke()
				end

			end
		else
			Citizen.Wait(500)
		end
	end
end)

function ProcessCokeLeaf()
	isProcessing = true

	-- ESX.ShowNotification(_U('coke_processingstarted'))
	TriggerServerEvent('esx_illegal:processCocaLeaf')
	local timeLeft = Config.Delays.CokeProcessing / 1000
	local playerPed = PlayerPedId()

	while timeLeft > 0 do
		Citizen.Wait(1000)
		timeLeft = timeLeft - 1

		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.CokeProcessing.coords, false) > 2 then
			-- ESX.ShowNotification(_U('coke_processingtoofar'))
			TriggerServerEvent('esx_illegal:cancelProcessing')
			break
		end
	end

	isProcessing = false
end

function ProcessCoke()
	isProcessing = true

	-- ESX.ShowNotification(_U('coke_processingstarted'))
	TriggerServerEvent('esx_illegal:processCoca')
	local timeLeft = Config.Delays.CokeProcessing / 1000
	local playerPed = PlayerPedId()

	while timeLeft > 0 do
		Citizen.Wait(1000)
		timeLeft = timeLeft - 1

		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.CokeProcessing2.coords, false) > 2 then
			-- ESX.ShowNotification(_U('coke_processingtoofar'))
			TriggerServerEvent('esx_illegal:cancelProcessing')
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

		for i=1, #CocaPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(CocaPlants[i]), false) < 1 then
				nearbyObject, nearbyID = CocaPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			--if not isPickingUp then
				--ESX.ShowHelpNotification(_U('coke_pickupprompt'))
			--end

			if IsControlJustReleased(0, Keys['E']) and not isPickingUp then
				isPickingUp = true

				ESX.TriggerServerCallback('esx_illegal:canPickUp', function(canPickUp)

					if canPickUp then
						TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)

						Citizen.Wait(2000)
						ClearPedTasks(playerPed)
						Citizen.Wait(1500)
		
						ESX.Game.DeleteObject(nearbyObject)
		
						table.remove(CocaPlants, nearbyID)
						spawnedCocaLeaf = spawnedCocaLeaf - 1
		
						TriggerServerEvent('esx_illegal:pickedUpCocaLeaf')
					else
						ESX.ShowNotification(_U('coke_inventoryfull'))
					end

					isPickingUp = false

				end, 'cokeleaf')
			end

		else
			Citizen.Wait(500)
		end

	end

end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(CocaPlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnCocaPlants()
	while spawnedCocaLeaf < 7 do
		Citizen.Wait(0)
		local cokeCoords = GenerateCocaLeafCoords()

		ESX.Game.SpawnLocalObject('prop_plant_fern_02a', cokeCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(CocaPlants, obj)
			spawnedCocaLeaf = spawnedCocaLeaf + 1
		end)
	end
end

function ValidateCocaLeafCoord(plantCoord)
	if spawnedCocaLeaf > 0 then
		local validate = true

		for k, v in pairs(CocaPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.CokeField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateCocaLeafCoords()
	while true do
		Citizen.Wait(1)

		local cokeCoordX, cokeCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-5, 5)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-5, 5)

		cokeCoordX = Config.CircleZones.CokeField.coords.x + modX
		cokeCoordY = Config.CircleZones.CokeField.coords.y + modY

		local coordZ = GetCoordZCoke(cokeCoordX, cokeCoordY)
		local coord = vector3(cokeCoordX, cokeCoordY, coordZ)

		if ValidateCocaLeafCoord(coord) then
			return coord
		end
	end
end

function GetCoordZCoke(x, y)
	local groundCheckHeights = { 74.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 74.62
end


-- infos
Citizen.CreateThread(function() 
	while true do
		Citizen.Wait(0)
		local plyPed = PlayerPedId()
		local coords = GetEntityCoords(plyPed)
		local door = vector4(-294.98, 6189.08, 31.49, 316.13)
		if GetDistanceBetweenCoords(coords, door, true) < Config.DrawTextDist then
			ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour frapper à la porte")
			if IsControlJustPressed(0, Keys["E"]) then    
				ESX.UI.Menu.CloseAll()
				KnockDoor(door)

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'weed_info',
				{
					title    = 'Coquelicot',
					align    = 'left',
					elements = {
						{ label = 'Récolte ('.. Config.CircleZones.CokeField.price ..'$)', 	value = 'fieldCoke'},
						{ label = 'Deux Traitement ('.. Config.CircleZones.CokeProcessing.price ..'$)', value = 'processCoke1'}
					}
				}, function(data, menu)
					menu.close()
					if data.current.value == 'fieldCoke' then
						BuyField(Config.CircleZones.CokeField.coords, Config.CircleZones.CokeField.price)
					elseif data.current.value == 'processCoke1' then
						BuyProcess(Config.CircleZones.CokeProcessing.coords, Config.CircleZones.CokeProcessing.price)
						ESX.ShowNotification("Il y a deux traitements à cette position, ne l'oublie pas")
					end
				end, function(data, menu)
					menu.close()
				end)			
			end
		else
			Citizen.Wait(500)
		end
	end
end)
