local isPickingUp, isProcessing = false, false
local spawnedMethylas = 0
local methylaPlants = {}
local spawnedPseudos = 0
local pseudoPlants = {}
local spawnedMethas = 0
local methaPlants = {}

-- boucle pour spawn plants
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.MethylaField.coords, true) < 20 then
			SpawnMethylaPlants()
			Citizen.Wait(500)
		elseif GetDistanceBetweenCoords(coords, Config.CircleZones.PseudoField.coords, true) < 20 then
			SpawnPseudoPlants()
			Citizen.Wait(500)
		elseif GetDistanceBetweenCoords(coords, Config.CircleZones.MethaField.coords, true) < 20 then
			SpawnMethaPlants()
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

		if GetDistanceBetweenCoords(coords, Config.CircleZones.MethProcessing.coords, true) < 2 then
			--if not isProcessing then
				--ESX.ShowHelpNotification(_U('meth_processprompt'))
			--end

			if IsControlJustReleased(0, Keys['E']) and not isProcessing then

				if Config.LicenseEnable then
					ESX.TriggerServerCallback('esx_license:checkLicense', function(hasProcessingLicense)
						if hasProcessingLicense then
							ProcessMeth()
						else
							OpenBuyLicenseMenu('meth_processing')
						end
					end, GetPlayerServerId(PlayerId()), 'meth_processing')
				else
					ProcessMeth()
				end

			end
		else
			Citizen.Wait(500)
		end
	end
end)

function ProcessMeth()
	isProcessing = true

	ESX.ShowNotification(_U('meth_processingstarted'))
	TriggerServerEvent('esx_illegal:processMeth')
	local timeLeft = Config.Delays.MethProcessing / 1000
	local playerPed = PlayerPedId()

	while timeLeft > 0 do
		Citizen.Wait(1000)
		timeLeft = timeLeft - 1

		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.MethProcessing.coords, false) > 2 then
			ESX.ShowNotification(_U('Meth_processingtoofar'))
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

		for i=1, #methylaPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(methylaPlants[i]), false) < 2 then
				nearbyObject, nearbyID = methylaPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			-- if not isPickingUp then
				--ESX.ShowHelpNotification(_U('methyla_pickupprompt'))
			-- end

			if IsControlJustReleased(0, Keys['E']) and not isPickingUp then
				isPickingUp = true

				ESX.TriggerServerCallback('esx_illegal:canPickUp', function(canPickUp)

					if canPickUp then
						TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)

						Citizen.Wait(2000)
						ClearPedTasks(playerPed)
						Citizen.Wait(1500)
		
						ESX.Game.DeleteObject(nearbyObject)
		
						table.remove(methylaPlants, nearbyID)
						spawnedMethylas = spawnedMethylas - 1
		
						TriggerServerEvent('esx_illegal:pickedUpMethyla')
					else
						ESX.ShowNotification(_U('Methyla_inventoryfull'))
					end

					isPickingUp = false

				end, 'methylamine')
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

		for i=1, #pseudoPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(pseudoPlants[i]), false) < 1 then
				nearbyObject, nearbyID = pseudoPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			-- if not isPickingUp then
				--ESX.ShowHelpNotification(_U('pseudo_pickupprompt'))
			-- end

			if IsControlJustReleased(0, Keys['E']) and not isPickingUp then
				isPickingUp = true

				ESX.TriggerServerCallback('esx_illegal:canPickUp', function(canPickUp)

					if canPickUp then
						TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)

						Citizen.Wait(2000)
						ClearPedTasks(playerPed)
						Citizen.Wait(1500)
		
						ESX.Game.DeleteObject(nearbyObject)
		
						table.remove(pseudoPlants, nearbyID)
						spawnedPseudos = spawnedPseudos - 1
		
						TriggerServerEvent('esx_illegal:pickedUpPseudo')
					else
						ESX.ShowNotification(_U('pseudo_inventoryfull'))
					end

					isPickingUp = false

				end, 'methpseudophedrine')
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

		for i=1, #methaPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(methaPlants[i]), false) < 1 then
				nearbyObject, nearbyID = methaPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			-- if not isPickingUp then
				--ESX.ShowHelpNotification(_U('metha_pickupprompt'))
			-- end

			if IsControlJustReleased(0, Keys['E']) and not isPickingUp then
				isPickingUp = true

				ESX.TriggerServerCallback('esx_illegal:canPickUp', function(canPickUp)

					if canPickUp then
						TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)

						Citizen.Wait(2000)
						ClearPedTasks(playerPed)
						Citizen.Wait(1500)
		
						ESX.Game.DeleteObject(nearbyObject)
		
						table.remove(methaPlants, nearbyID)
						spawnedMethas = spawnedMethas - 1
		
						TriggerServerEvent('esx_illegal:pickedUpMetha')
					else
						ESX.ShowNotification(_U('metha_inventoryfull'))
					end

					isPickingUp = false

				end, 'methacide')
			end

		else
			Citizen.Wait(500)
		end

	end

end)

--Enleve les item apres
AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(methylaPlants) do
			ESX.Game.DeleteObject(v)
		end
		for k, v in pairs(pseudoPlants) do
			ESX.Game.DeleteObject(v)
		end
		for k, v in pairs(methaPlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnMethylaPlants()
	while spawnedMethylas < 5 do
		Citizen.Wait(0)
		local methylaCoords = GenerateMethylaCoords()

		ESX.Game.SpawnLocalObject('prop_barrel_exp_01c', methylaCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(methylaPlants, obj)
			spawnedMethylas = spawnedMethylas + 1
		end)
	end
end

function SpawnPseudoPlants()
	while spawnedPseudos < 5 do
		Citizen.Wait(0)
		local pseudoCoords = GeneratePseudoCoords()

		ESX.Game.SpawnLocalObject('prop_barrel_01a', pseudoCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(pseudoPlants, obj)
			spawnedPseudos = spawnedPseudos + 1
		end)
	end
end

function SpawnMethaPlants()
	while spawnedMethas < 5 do
		Citizen.Wait(0)
		local methaCoords = GenerateMethaCoords()

		ESX.Game.SpawnLocalObject('prop_barrel_exp_01c', methaCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(methaPlants, obj)
			spawnedMethas = spawnedMethas + 1
		end)
	end
end


function ValidateMethylaCoord(plantCoord)
	if spawnedMethylas > 0 then
		local validate = true

		for k, v in pairs(methylaPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 2 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.MethylaField.coords, false) > 20 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function ValidatePseudoCoord(plantCoord)
	if spawnedPseudos > 0 then
		local validate = true

		for k, v in pairs(pseudoPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 2 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.PseudoField.coords, false) > 20 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function ValidateMethaCoord(plantCoord)
	if spawnedMethas > 0 then
		local validate = true

		for k, v in pairs(methaPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 2 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.MethaField.coords, false) > 20 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateMethylaCoords()
	while true do
		Citizen.Wait(1)

		local methylaCoordX, methylaCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-5, 5)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-5, 5)

		methylaCoordX = Config.CircleZones.MethylaField.coords.x + modX
		methylaCoordY = Config.CircleZones.MethylaField.coords.y + modY

		local coordZ = GetCoordZMethyla(methylaCoordX, methylaCoordY)
		local coord = vector3(methylaCoordX, methylaCoordY, coordZ)

		if ValidateMethylaCoord(coord) then
			return coord
		end
	end
end

function GeneratePseudoCoords()
	while true do
		Citizen.Wait(1)

		local pseudoCoordX, pseudoCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-5, 5)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-5, 5)

		pseudoCoordX = Config.CircleZones.PseudoField.coords.x + modX
		pseudoCoordY = Config.CircleZones.PseudoField.coords.y + modY

		local coordZ = GetCoordZPseudo(pseudoCoordX, pseudoCoordY)
		local coord = vector3(pseudoCoordX, pseudoCoordY, coordZ)

		if ValidatePseudoCoord(coord) then
			return coord
		end
	end
end

function GenerateMethaCoords()
	while true do
		Citizen.Wait(1)

		local methaCoordX, methaCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-4, 4)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-4, 4)

		methaCoordX = Config.CircleZones.MethaField.coords.x + modX
		methaCoordY = Config.CircleZones.MethaField.coords.y + modY

		local coordZ = GetCoordZPseudo(methaCoordX, methaCoordY)
		local coord = vector3(methaCoordX, methaCoordY, coordZ)

		if ValidateMethaCoord(coord) then
			return coord
		end
	end
end

-- Hauteur du props possible
function GetCoordZMethyla(x, y)
	local groundCheckHeights = { 88.0, 89.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 88.12
end


function GetCoordZPseudo(x, y)
	local groundCheckHeights = { 112.0, 113.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 112.67
end


function GetCoordZMetha(x, y)
	local groundCheckHeights = { 30.0, 31.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 30.5
end

-- infos
Citizen.CreateThread(function() 
	while true do
		Citizen.Wait(0)
		local plyPed = PlayerPedId()
		local coords = GetEntityCoords(plyPed)
		local door = vector4(1639.37, 4879.44, 41.16, 277.64)
		if GetDistanceBetweenCoords(coords, door, true) < Config.DrawTextDist then
			ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour frapper à la porte")
			if IsControlJustPressed(0, Keys["E"]) then    
				ESX.UI.Menu.CloseAll()
				KnockDoor(door)

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'weed_info',
				{
					title    = 'Baleine',
					align    = 'left',
					elements = {
						{ label = 'Récolte 1 ('.. Config.CircleZones.MethylaField.price ..'$)', 	value = 'fieldMethyla'},
						{ label = 'Récolte 2 ('.. Config.CircleZones.PseudoField.price ..'$)', 	value = 'fieldPseudo'},
						{ label = 'Récolte 3 ('.. Config.CircleZones.MethaField.price ..'$)', 	value = 'fieldMetha'},
						{ label = 'Traitement ('.. Config.CircleZones.MethProcessing.price ..'$)', value = 'processMeth'}
					}
				}, function(data, menu)
					menu.close()
					if data.current.value == 'fieldMethyla' then
						BuyField(Config.CircleZones.MethylaField.coords, Config.CircleZones.MethylaField.price)
					elseif data.current.value == 'fieldPseudo' then
						BuyField(Config.CircleZones.PseudoField.coords, Config.CircleZones.PseudoField.price)
					elseif data.current.value == 'fieldMetha' then
						BuyField(Config.CircleZones.MethaField.coords, Config.CircleZones.MethaField.price)
					elseif data.current.value == 'processMeth' then
						BuyProcess(Config.CircleZones.MethProcessing.coords, Config.CircleZones.MethProcessing.price)
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
