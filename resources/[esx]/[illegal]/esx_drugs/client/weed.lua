local spawnedWeeds = 0
local weedPlants = {}
local isPickingUp, isProcessing = false, false


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.WeedField.coords, true) < 20 then
			SpawnWeedPlants()
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

		if GetDistanceBetweenCoords(coords, Config.CircleZones.WeedProcessing.coords, true) < 2 then
			--if not isProcessing then
				--ESX.ShowHelpNotification(_U('weed_processprompt'))
			--end

			if IsControlJustReleased(0, Keys['E']) and not isProcessing then

				if Config.LicenseEnable then
					ESX.TriggerServerCallback('esx_license:checkLicense', function(hasProcessingLicense)
						if hasProcessingLicense then
							ProcessWeed()
						else
							OpenBuyLicenseMenu('weed_processing')
						end
					end, GetPlayerServerId(PlayerId()), 'weed_processing')
				else
					ProcessWeed()
				end

			end
		else
			Citizen.Wait(500)
		end
	end
end)

function ProcessWeed()
	isProcessing = true

	--ESX.ShowNotification(_U('weed_processingstarted'))
	TriggerServerEvent('esx_illegal:processCannabis')
	local timeLeft = Config.Delays.WeedProcessing / 1000
	local playerPed = PlayerPedId()

	while timeLeft > 0 do
		Citizen.Wait(1000)
		timeLeft = timeLeft - 1

		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.WeedProcessing.coords, false) > 2 then
			--ESX.ShowNotification(_U('weed_processingtoofar'))
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

		for i=1, #weedPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(weedPlants[i]), false) < 1 then
				nearbyObject, nearbyID = weedPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			--if not isPickingUp then
				--ESX.ShowHelpNotification(_U('weed_pickupprompt'))
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
		
						table.remove(weedPlants, nearbyID)
						spawnedWeeds = spawnedWeeds - 1
		
						TriggerServerEvent('esx_illegal:pickedUpCannabis')
					else
						ESX.ShowNotification(_U('weed_inventoryfull'))
					end

					isPickingUp = false

				end, 'cannabis')
			end

		else
			Citizen.Wait(500)
		end

	end

end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(weedPlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnWeedPlants()
	while spawnedWeeds < 5 do
		Citizen.Wait(0)
		local weedCoords = GenerateWeedCoords()

		ESX.Game.SpawnLocalObject('prop_weed_01', weedCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(weedPlants, obj)
			spawnedWeeds = spawnedWeeds + 1
		end)
	end
end

function ValidateWeedCoord(plantCoord)
	if spawnedWeeds > 0 then
		local validate = true

		for k, v in pairs(weedPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.WeedField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateWeedCoords()
	while true do
		Citizen.Wait(1)

		local weedCoordX, weedCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-8, 8)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-8, 8)

		weedCoordX = Config.CircleZones.WeedField.coords.x + modX
		weedCoordY = Config.CircleZones.WeedField.coords.y + modY

		local coordZ = GetCoordZWeed(weedCoordX, weedCoordY)
		local coord = vector3(weedCoordX, weedCoordY, coordZ)

		if ValidateWeedCoord(coord) then
			return coord
		end
	end
end

function GetCoordZWeed(x, y)
	local groundCheckHeights = { 1.0, 2.0, 3.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 2.57
end


-- infos
Citizen.CreateThread(function() 
	while true do
		Citizen.Wait(0)
		local plyPed = PlayerPedId()
		local coords = GetEntityCoords(plyPed)
		local door = vector4(-1157.06, -1569.71, 3.45, 130)
		if GetDistanceBetweenCoords(coords, door, true) < Config.DrawTextDist then
			ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour frapper à la porte")
			if IsControlJustPressed(0, Keys["E"]) then    
				ESX.UI.Menu.CloseAll()
				KnockDoor(door)

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'weed_info',
				{
					title    = 'Kiwi',
					align    = 'left',
					elements = {
						{ label = 'Récolte ('.. Config.CircleZones.WeedField.price ..'$)', 	value = 'fieldCannabis'},
						{ label = 'Traitement ('.. Config.CircleZones.WeedProcessing.price ..'$)', value = 'processCannabis'}
					}
				}, function(data, menu)
					menu.close()
					if data.current.value == 'fieldCannabis' then
						BuyField(Config.CircleZones.WeedField.coords, Config.CircleZones.WeedField.price)
					elseif data.current.value == 'processCannabis' then
						BuyProcess(Config.CircleZones.WeedProcessing.coords, Config.CircleZones.WeedProcessing.price)
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
