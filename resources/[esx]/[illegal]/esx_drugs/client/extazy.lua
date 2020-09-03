local spawnedMdmas = 0
local mdmaPlants = {}
local isPickingUp, isProcessing = false, false
local spawnedAmphets = 0
local amphetPlants = {}


-- boucle pour spawn plants
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.MdmaField.coords, true) < 20 then
			SpawnMdmaPlants()
			Citizen.Wait(500)
		elseif GetDistanceBetweenCoords(coords, Config.CircleZones.AmphetField.coords, true) < 20 then
			SpawnAmphetPlants()
			Citizen.Wait(500)
		
			Citizen.Wait(500)
		end
	end
end)

-- boucle pour traiter
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.CircleZones.ExtapProcessing.coords, true) < 2 then
		    --if not isProcessing then
				--ESX.ShowHelpNotification(_U('exta_processprompt'))
			--end

			if IsControlJustReleased(0, Keys['E']) and not isProcessing then

				if Config.LicenseEnable then
					ESX.TriggerServerCallback('esx_license:checkLicense', function(hasProcessingLicense)
						if hasProcessingLicense then
							ProcessExtap()
						else
							OpenBuyLicenseMenu('extap_processing')
						end
					end, GetPlayerServerId(PlayerId()), 'extap_processing')
				else
					ProcessExtap()
				end

			end
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

		if GetDistanceBetweenCoords(coords, Config.CircleZones.ExtaProcessing.coords, true) < 2 then
		    --if not isProcessing then
				--ESX.ShowHelpNotification(_U('exta_processprompt'))
			--end

			if IsControlJustReleased(0, Keys['E']) and not isProcessing then

				if Config.LicenseEnable then
					ESX.TriggerServerCallback('esx_license:checkLicense', function(hasProcessingLicense)
						if hasProcessingLicense then
							ProcessExta()
						else
							OpenBuyLicenseMenu('exta_processing')
						end
					end, GetPlayerServerId(PlayerId()), 'exta_processing')
				else
					ProcessExta()
				end

			end
		else
			Citizen.Wait(500)
		end
	end
end)


function ProcessExtap()
	isProcessing = true

	-- ESX.ShowNotification(_U('extap_processingstarted'))
	TriggerServerEvent('esx_illegal:processExtap')
	local timeLeft = Config.Delays.ExtapProcessing / 1000
	local playerPed = PlayerPedId()

	while timeLeft > 0 do
		Citizen.Wait(1000)
		timeLeft = timeLeft - 1

		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.ExtapProcessing.coords, false) > 2 then
			ESX.ShowNotification(_U('exta_processingtoofar'))
			TriggerServerEvent('esx_illegal:cancelProcessing')
			break
		end
	end

	isProcessing = false
end

function ProcessExta()
	isProcessing = true

	ESX.ShowNotification(_U('exta_processingstarted'))
	TriggerServerEvent('esx_illegal:processExta')
	local timeLeft = Config.Delays.ExtaProcessing / 1000
	local playerPed = PlayerPedId()

	while timeLeft > 0 do
		Citizen.Wait(1000)
		timeLeft = timeLeft - 1

		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.ExtaProcessing.coords, false) > 2 then
			ESX.ShowNotification(_U('exta_processingtoofar'))
			TriggerServerEvent('esx_illegal:cancelProcessing')
			break
		end
	end

	isProcessing = false
end

-- boucle pour récolter
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID

		for i=1, #mdmaPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(mdmaPlants[i]), false) < 2 then
				nearbyObject, nearbyID = mdmaPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			--if not isPickingUp then
				--ESX.ShowHelpNotification(_U('mdma_pickupprompt'))
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
		
						table.remove(mdmaPlants, nearbyID)
						spawnedMdmas = spawnedMdmas - 1
		
						TriggerServerEvent('esx_illegal:pickedUpMdma')
					else
						ESX.ShowNotification(_U('Mdma_inventoryfull'))
					end

					isPickingUp = false

				end, 'extamdma')
			end

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
		local nearbyObject, nearbyID

		for i=1, #amphetPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(amphetPlants[i]), false) < 2 then
				nearbyObject, nearbyID = amphetPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			--if not isPickingUp then
				--ESX.ShowHelpNotification(_U('amphet_pickupprompt'))
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
		
						table.remove(amphetPlants, nearbyID)
						spawnedAmphets = spawnedAmphets - 1
		
						TriggerServerEvent('esx_illegal:pickedUpAmphet')
					else
						ESX.ShowNotification(_U('Amphet_inventoryfull'))
					end

					isPickingUp = false

				end, 'extaamphetamine')
			end

		else
			Citizen.Wait(500)
		end

	end

end)


--Enleve les item apres
AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(mdmaPlants) do
			ESX.Game.DeleteObject(v)
		end
		for k, v in pairs(amphetPlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnMdmaPlants()
	while spawnedMdmas < 2 do
		Citizen.Wait(0)
		local mdmaCoords = GenerateMdmaCoords()

		ESX.Game.SpawnLocalObject('prop_drug_package_02', mdmaCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(mdmaPlants, obj)
			spawnedMdmas = spawnedMdmas + 1
		end)
	end
end

function SpawnAmphetPlants()
	while spawnedAmphets < 2 do
		Citizen.Wait(0)
		local amphetCoords = GenerateAmphetCoords()

		ESX.Game.SpawnLocalObject('ex_office_swag_pills2', amphetCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(amphetPlants, obj)
			spawnedAmphets = spawnedAmphets + 1
		end)
	end
end

function ValidateMdmaCoord(plantCoord)
	if spawnedMdmas > 0 then
		local validate = true

		for k, v in pairs(mdmaPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 2 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.MdmaField.coords, false) > 20 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function ValidateAmphetCoord(plantCoord)
	if spawnedAmphets > 0 then
		local validate = true

		for k, v in pairs(amphetPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 2 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.AmphetField.coords, false) > 20 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateMdmaCoords()
	while true do
		Citizen.Wait(1)

		local mdmaCoordX, mdmaCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-3, 3)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-3, 3)

		mdmaCoordX = Config.CircleZones.MdmaField.coords.x + modX
		mdmaCoordY = Config.CircleZones.MdmaField.coords.y + modY

		local coordZ = GetCoordZMdma(mdmaCoordX, mdmaCoordY)
		local coord = vector3(mdmaCoordX, mdmaCoordY, coordZ)

		if ValidateMdmaCoord(coord) then
			return coord
		end
	end
end

function GenerateAmphetCoords()
	while true do
		Citizen.Wait(1)

		local amphetCoordX, amphetCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-3, 3)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-3, 3)

		amphetCoordX = Config.CircleZones.AmphetField.coords.x + modX
		amphetCoordY = Config.CircleZones.AmphetField.coords.y + modY

		local coordZ = GetCoordZAmphet(amphetCoordX, amphetCoordY)
		local coord = vector3(amphetCoordX, amphetCoordY, coordZ)

		if ValidateAmphetCoord(coord) then
			return coord
		end
	end
end

-- Hauteur du props possible
function GetCoordZMdma(x, y)
	local groundCheckHeights = { 2.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 2.16
end


function GetCoordZAmphet(x, y)
	local groundCheckHeights = { 105.0, 106.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 105.37
end


-- infos
Citizen.CreateThread(function() 
	while true do
		Citizen.Wait(0)
		local plyPed = PlayerPedId()
		local coords = GetEntityCoords(plyPed)
		local door = vector4(-675.96, -885.01, 23.47, 272.59)
		if GetDistanceBetweenCoords(coords, door, true) < Config.DrawTextDist then
			ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour frapper à la porte")
			if IsControlJustPressed(0, Keys["E"]) then    
				ESX.UI.Menu.CloseAll()
				KnockDoor(door)

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'weed_info',
				{
					title    = 'Emile',
					align    = 'left',
					elements = {
						{ label = 'Récolte 1 ('.. Config.CircleZones.MdmaField.price ..'$)', 	value = 'fieldMdma'},
						{ label = 'Récolte 2 ('.. Config.CircleZones.AmphetField.price ..'$)', 	value = 'fieldAmphet'},
						{ label = 'Deux Traitement ('.. Config.CircleZones.ExtaProcessing.price ..'$)', value = 'processExta'}
					}
				}, function(data, menu)
					menu.close()
					if data.current.value == 'fieldMdma' then
						BuyField(Config.CircleZones.MdmaField.coords, Config.CircleZones.MdmaField.price)
					elseif data.current.value == 'fieldAmphet' then
						BuyField(Config.CircleZones.AmphetField.coords, Config.CircleZones.AmphetField.price)
					elseif data.current.value == 'processExta' then
						BuyProcess(Config.CircleZones.ExtaProcessing.coords, Config.CircleZones.ExtaProcessing.price)
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
