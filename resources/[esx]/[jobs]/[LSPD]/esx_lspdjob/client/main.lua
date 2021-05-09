local PlayerData, CurrentActionData, handcuffTimer, dragStatus, blipsCops, currentTask, spawnedVehicles = {}, {}, {}, {}, {}, {}, {}
local HasAlreadyEnteredMarker, isDead, IsHandcuffed, hasAlreadyJoined, playerInService, isInShopMenu = false, false, false, false, false, false
local LastStation, LastPart, LastPartNum, LastEntity, CurrentAction, CurrentActionMsg
dragStatus.isDragged = false
ESX = nil
blip = nil

local attente = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0) 
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	isPlayerWhitelisted = refreshPlayerWhitelisted()
	PlayerData = ESX.GetPlayerData()
end)

function cleanPlayer(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

function setUniform(job, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if Config.Uniforms[job].male then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end

			-- if job == 'bullet_wear' then
			-- 	SetPedArmour(playerPed, 100)
			-- end

			if job == 'tenu_doag' then
				SetPedArmour(playerPed, 100)
			end

			if job == 'tenu_sahpg' then
				SetPedArmour(playerPed, 100)
			end

			if job == 'tenu_swatgr' then
				SetPedArmour(playerPed, 100)
			end
		else
			if Config.Uniforms[job].female then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end

			-- if job == 'bullet_wear' then
			-- 	SetPedArmour(playerPed, 100)
			-- end
		end
	end)
end

function OpenCloakroomMenu()
	local playerPed = PlayerPedId()
	local grade = PlayerData.job.grade_name

	local elements = {
		{ label = _U('citizen_wear'), value = 'citizen_wear' },
		{ label = 'Tenue Manche Court', value = 'tenu_lspd' },
		{ label = 'Tenue Manche Long', value = 'tenu_ma' },
		{ label = 'Tenue Hiver', value = 'tenu_hiv'},
		{ label = 'Tenue SWAT Léger', value = 'tenu_swat'},
		{ label = 'Tenue SWAT Lourd', value = 'tenu_swatgr'},
		{ label = 'Tenue DOA', value = 'tenu_doag' },
		{ label = _('bike_suit'), value = 'bike_suit' },
		-- { label = _U('bullet_wear'), value = 'bullet_wear' },
	}

	
	if grade == 'recruit' then
		table.insert(elements, {label = _U('police_wear'), value = 'recruit_wear'})
		table.insert(elements, {label = _U('cadet_wear_short'), value = 'cadet_wear_short'})
		table.insert(elements, {label = _U('cadet_wear_long'), value = 'cadet_wear_long'})
	elseif grade == 'officer' or grade == 'sous-officier' or grade == 'Off-stup' then
		table.insert(elements, {label = _U('police_wear'), value = 'officer_wear'})
	elseif grade == 'sergeant' or grade == 'sergent-stup' then
		table.insert(elements, {label = _U('police_wear'), value = 'sergeant_wear'})
	elseif grade == 'intendent' then
		table.insert(elements, {label = _U('police_wear'), value = 'intendent_wear'})
	elseif grade == 'lieutenant' then
		table.insert(elements, {label = _U('police_wear'), value = 'lieutenant_wear'})
	elseif grade == 'chef' then
		table.insert(elements, {label = _U('police_wear'), value = 'chef_wear'})
	elseif grade == 'boss' then
		table.insert(elements, {label = _U('police_wear'), value = 'boss_wear'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
		css      = 'police',
		title    = _U('cloakroom'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		cleanPlayer(playerPed)

		if data.current.value == 'citizen_wear' then
			if Config.EnableNonFreemodePeds then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					local isMale = skin.sex == 0


					TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
						ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin)
							TriggerEvent('esx:restoreLoadout')
						end)
					end)

				end)
			else
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					local isMale = skin.sex == 0


					TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
						ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin)
							TriggerEvent('esx:restoreLoadout')
						end)
					end)

				end)
			end

			if Config.MaxInService ~= -1 then
				ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
					if isInService then
						playerInService = false

						local notification = {
							title    = _U('service_anonunce'),
							subject  = '',
							msg      = _U('service_out_announce', GetPlayerName(PlayerId())),
							iconType = 1
						}

						TriggerServerEvent('esx_service:notifyAllInService', notification, 'police')

						TriggerServerEvent('esx_service:disableService', 'police')
						TriggerEvent('esx_policejob:updateBlip')
						ESX.ShowNotification(_U('service_out'))
					end
				end, 'police')
			end
		end

		if Config.MaxInService ~= -1 and data.current.value ~= 'citizen_wear' then
			local serviceOk = 'waiting'

			ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
				if not isInService then

					ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
						if not canTakeService then
							ESX.ShowNotification(_U('service_max', inServiceCount, maxInService))
						else
							serviceOk = true
							playerInService = true

							local notification = {
								title    = _U('service_anonunce'),
								subject  = '',
								msg      = _U('service_in_announce', GetPlayerName(PlayerId())),
								iconType = 1
							}

							TriggerServerEvent('esx_service:notifyAllInService', notification, 'police')
							TriggerEvent('esx_policejob:updateBlip')
							ESX.ShowNotification(_U('service_in'))
						end
					end, 'police')

				else
					serviceOk = true
				end
			end, 'police')

			while type(serviceOk) == 'string' do
				Citizen.Wait(5)
			end

			-- if we couldn't enter service don't let the player get changed
			if not serviceOk then
				return
			end
		end

		if
			data.current.value == 'cadet_wear_short' or
			data.current.value == 'cadet_wear_long' or
			data.current.value == 'recruit_wear' or
			data.current.value == 'officer_wear' or
			data.current.value == 'sergeant_wear' or
			data.current.value == 'intendent_wear' or
			data.current.value == 'lieutenant_wear' or
			data.current.value == 'chef_wear' or
			data.current.value == 'boss_wear' or
			-- data.current.value == 'bullet_wear' or
			data.current.value == 'tenu_ma' or
			data.current.value == 'tenu_hiv' or
			data.current.value == 'tenu_swat' or
			data.current.value == 'tenu_swatgr' or
			data.current.value == 'tenu_doag' or
			data.current.value == 'tenu_lspd' or
			data.current.value == 'tenu_sahp' or
			data.current.value == 'tenu_sahpg' or
			data.current.value == 'bike_suit'
		then
			setUniform(data.current.value, playerPed)
		end

		if data.current.value == 'freemode_ped' then
			local modelHash = ''

			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					modelHash = GetHashKey(data.current.maleModel)
				else
					modelHash = GetHashKey(data.current.femaleModel)
				end

				ESX.Streaming.RequestModel(modelHash, function()
					SetPlayerModel(PlayerId(), modelHash)
					SetModelAsNoLongerNeeded(modelHash)

					TriggerEvent('esx:restoreLoadout')
				end)
			end)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	end)
end

function OpenArmoryMenu(station)
local elements = {
	--{label = _U('buy_weapons'), value = 'buy_weapons'}
		}
	if Config.EnableArmoryManagement then
		table.insert(elements, {label = _U('get_weapon'),     value = 'get_weapon'})
		table.insert(elements, {label = ('Ranger ses armes'),     value = 'put_weapon'})
		table.insert(elements, {label = _U('remove_object'),  value = 'get_stock'})
		table.insert(elements, {label = _U('deposit_object'), value = 'put_stock'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory', {
		css      = 'police',
		title    = _U('armory'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'get_weapon' then
			OpenGetWeaponMenu()
		elseif data.current.value == 'put_weapon' then
			OpenPutWeaponMenu()
		-- elseif data.current.value == 'buy_weapons' then
		-- 	OpenBuyWeaponsMenu()
		elseif data.current.value == 'put_stock' then
			OpenPutStocksMenu()
		elseif data.current.value == 'get_stock' then
			OpenGetStocksMenu()
		end

	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}
	end)
end

-- function OpenVehicleSpawnerMenu(type, station, part, partNum)
-- 	local playerCoords = GetEntityCoords(PlayerPedId())
-- 	PlayerData = ESX.GetPlayerData()
-- 	local elements = {
-- 		{label = _U('garage_storeditem'), action = 'garage'},
-- 		{label = _U('garage_storeitem'), action = 'store_garage'},
-- 		{label = _U('garage'), action = 'vehicle_menu'}
-- 	}

-- 	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle', {
-- 		css      = 'police',
-- 		title    = _U('garage_title'),
-- 		align    = 'top-left',
-- 		elements = elements
-- 	}, function(data, menu)
-- 		if data.current.action == 'buy_vehicle' then
-- 			local shopElements, shopCoords = {}

-- 			if type == 'car' then
-- 				shopCoords = Config.PoliceStations[station].Vehicles[partNum].InsideShop
-- 				local authorizedVehicles = Config.AuthorizedVehicles[PlayerData.job.grade_name]

-- 				if #Config.AuthorizedVehicles['Shared'] > 0 then
-- 					for k,vehicle in ipairs(Config.AuthorizedVehicles['Shared']) do
-- 						table.insert(shopElements, {
-- 							label = ('%s - <span style="color:green;">%s</span>'):format(vehicle.label, _U('shop_item', ESX.Math.GroupDigits(vehicle.price))),
-- 							name  = vehicle.label,
-- 							model = vehicle.model,
-- 							price = vehicle.price,
-- 							type  = 'car'
-- 						})
-- 					end
-- 				end

-- 				if #authorizedVehicles > 0 then
-- 					for k,vehicle in ipairs(authorizedVehicles) do
-- 						table.insert(shopElements, {
-- 							label = ('%s - <span style="color:green;">%s</span>'):format(vehicle.label, _U('shop_item', ESX.Math.GroupDigits(vehicle.price))),
-- 							name  = vehicle.label,
-- 							model = vehicle.model,
-- 							price = vehicle.price,
-- 							type  = 'car'
-- 						})
-- 					end
-- 				else
-- 					if #Config.AuthorizedVehicles['Shared'] == 0 then
-- 						return
-- 					end
-- 				end
-- 			elseif type == 'helicopter' then
-- 				shopCoords = Config.PoliceStations[station].Helicopters[partNum].InsideShop
-- 				local authorizedHelicopters = Config.AuthorizedHelicopters[PlayerData.job.grade_name]

-- 				if #authorizedHelicopters > 0 then
-- 					for k,vehicle in ipairs(authorizedHelicopters) do
-- 						table.insert(shopElements, {
-- 							label = ('%s - <span style="color:green;">%s</span>'):format(vehicle.label, _U('shop_item', ESX.Math.GroupDigits(vehicle.price))),
-- 							name  = vehicle.label,
-- 							model = vehicle.model,
-- 							price = vehicle.price,
-- 							livery = vehicle.livery or nil,
-- 							type  = 'helicopter'
-- 						})
-- 					end
-- 				else
-- 					ESX.ShowNotification(_U('helicopter_notauthorized'))
-- 					return
-- 				end
-- 			end

-- 			OpenShopMenu(shopElements, playerCoords, shopCoords)
-- 		elseif data.current.action == 'garage' then
-- 			local garage = {}

-- 			ESX.TriggerServerCallback('esx_vehicleshop:retrieveJobVehicles', function(jobVehicles)
-- 				if #jobVehicles > 0 then
-- 					for k,v in ipairs(jobVehicles) do
-- 						local props = json.decode(v.vehicle)
-- 						local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(props.model))
-- 						local label = ('%s - <span style="color:darkgoldenrod;">%s</span>: '):format(vehicleName, props.plate)

-- 						if v.stored then
-- 							label = label .. ('<span style="color:green;">%s</span>'):format(_U('garage_stored'))
-- 						else
-- 							label = label .. ('<span style="color:darkred;">%s</span>'):format(_U('garage_notstored'))
-- 						end

-- 						table.insert(garage, {
-- 							label = label,
-- 							stored = v.stored,
-- 							model = props.model,
-- 							vehicleProps = props
-- 						})
-- 					end

-- 					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_garage', {
-- 						css      = 'police',
-- 						title    = _U('garage_title'),
-- 						align    = 'top-left',
-- 						elements = garage
-- 					}, function(data2, menu2)
-- 						if data2.current.stored then
-- 							local foundSpawn, spawnPoint = GetAvailableVehicleSpawnPoint(station, part, partNum)
-- 							if foundSpawn then
-- 								menu2.close()

-- 								ESX.Game.SpawnVehicle(data2.current.model, spawnPoint.coords, spawnPoint.heading, function(vehicle)
-- 									ESX.Game.SetVehicleProperties(vehicle, data2.current.vehicleProps)
-- 									SetVehicleEnginePowerMultiplier(vehicle, 2.0 * 15.0)

-- 									TriggerServerEvent('esx_vehicleshop:setJobVehicleState', data2.current.vehicleProps.plate, false)
-- 									ESX.ShowNotification(_U('garage_released'))
-- 								end)
-- 							end
-- 						else
-- 							ESX.ShowNotification(_U('garage_notavailable'))
-- 						end
-- 					end, function(data2, menu2)
-- 						menu2.close()
-- 					end)
-- 				else
-- 					ESX.ShowNotification(_U('garage_empty'))
-- 				end
-- 			end, type)
-- 		elseif data.current.action == 'menu_vehicle_spawner' then
-- 			StoreNearbyVehicle(playerCoords)
-- 		end
-- 	end, function(data, menu)
-- 		menu.close()
-- 	end)
-- end

-- function StoreNearbyVehicle(playerCoords)
-- 	local vehicles, vehiclePlates = ESX.Game.GetVehiclesInArea(playerCoords, 30.0), {}

-- 	if #vehicles > 0 then
-- 		for k,v in ipairs(vehicles) do

-- 			-- Make sure the vehicle we're saving is empty, or else it wont be deleted
-- 			if GetVehicleNumberOfPassengers(v) == 0 and IsVehicleSeatFree(v, -1) then
-- 				table.insert(vehiclePlates, {
-- 					vehicle = v,
-- 					plate = ESX.Math.Trim(GetVehicleNumberPlateText(v))
-- 				})
-- 			end
-- 		end
-- 	else
-- 		ESX.ShowNotification(_U('garage_store_nearby'))
-- 		return
-- 	end

-- 	ESX.TriggerServerCallback('esx_policejob:storeNearbyVehicle', function(storeSuccess, foundNum)
-- 		if storeSuccess then
-- 			local vehicleId = vehiclePlates[foundNum]
-- 			local attempts = 0
-- 			ESX.Game.DeleteVehicle(vehicleId.vehicle)
-- 			IsBusy = true

-- 			Citizen.CreateThread(function()
-- 				while IsBusy do
-- 					Citizen.Wait(0)
-- 					drawLoadingText(_U('garage_storing'), 255, 255, 255, 255)
-- 				end
-- 			end)

-- 			-- Workaround for vehicle not deleting when other players are near it.
-- 			while DoesEntityExist(vehicleId.vehicle) do
-- 				Citizen.Wait(500)
-- 				attempts = attempts + 1

-- 				-- Give up
-- 				if attempts > 30 then
-- 					break
-- 				end

-- 				vehicles = ESX.Game.GetVehiclesInArea(playerCoords, 30.0)
-- 				if #vehicles > 0 then
-- 					for k,v in ipairs(vehicles) do
-- 						if ESX.Math.Trim(GetVehicleNumberPlateText(v)) == vehicleId.plate then
-- 							ESX.Game.DeleteVehicle(v)
-- 							break
-- 						end
-- 					end
-- 				end
-- 			end

-- 			IsBusy = false
-- 			ESX.ShowNotification(_U('garage_has_stored'))
-- 		else
-- 			ESX.ShowNotification(_U('garage_has_notstored'))
-- 		end
-- 	end, vehiclePlates)
-- end

-- function GetAvailableVehicleSpawnPoint(station, part, partNum)
-- 	local spawnPoints = Config.PoliceStations[station][part][partNum].SpawnPoints
-- 	local found, foundSpawnPoint = false, nil

-- 	for i=1, #spawnPoints, 1 do
-- 		if ESX.Game.IsSpawnPointClear(spawnPoints[i].coords, spawnPoints[i].radius) then
-- 			found, foundSpawnPoint = true, spawnPoints[i]
-- 			break
-- 		end
-- 	end

-- 	if found then
-- 		return true, foundSpawnPoint
-- 	else
-- 		ESX.ShowNotification(_U('vehicle_blocked'))
-- 		return false
-- 	end
-- end

-- function OpenShopMenu(elements, restoreCoords, shopCoords)
-- 	local playerPed = PlayerPedId()
-- 	isInShopMenu = true

-- 	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop', {
-- 		css      = 'police',
-- 		title    = _U('vehicleshop_title'),
-- 		align    = 'top-left',
-- 		elements = elements
-- 	}, function(data, menu)
-- 		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop_confirm', {
-- 			css      = 'police',
-- 			title    = _U('vehicleshop_confirm', data.current.name, data.current.price),
-- 			align    = 'top-left',
-- 			elements = {
-- 				{label = _U('confirm_no'), value = 'no'},
-- 				{label = _U('confirm_yes'), value = 'yes'}
-- 		}}, function(data2, menu2)
-- 			if data2.current.value == 'yes' then
-- 				local newPlate = exports['esx_vehicleshop']:GeneratePlate()
-- 				local vehicle  = GetVehiclePedIsIn(playerPed, false)
-- 				local props    = ESX.Game.GetVehicleProperties(vehicle)
-- 				props.plate    = newPlate

-- 				ESX.TriggerServerCallback('esx_policejob:buyJobVehicle', function (bought)
-- 					if bought then
-- 						ESX.ShowNotification(_U('vehicleshop_bought', data.current.name, ESX.Math.GroupDigits(data.current.price)))

-- 						isInShopMenu = false
-- 						ESX.UI.Menu.CloseAll()
-- 						DeleteSpawnedVehicles()
-- 						FreezeEntityPosition(playerPed, false)
-- 						SetEntityVisible(playerPed, true)

-- 						ESX.Game.Teleport(playerPed, restoreCoords)
-- 					else
-- 						ESX.ShowNotification(_U('vehicleshop_money'))
-- 						menu2.close()
-- 					end
-- 				end, props, data.current.type)
-- 			else
-- 				menu2.close()
-- 			end
-- 		end, function(data2, menu2)
-- 			menu2.close()
-- 		end)
-- 	end, function(data, menu)
-- 		isInShopMenu = false
-- 		ESX.UI.Menu.CloseAll()

-- 		DeleteSpawnedVehicles()
-- 		FreezeEntityPosition(playerPed, false)
-- 		SetEntityVisible(playerPed, true)

-- 		ESX.Game.Teleport(playerPed, restoreCoords)
-- 	end, function(data, menu)
-- 		DeleteSpawnedVehicles()

-- 		WaitForVehicleToLoad(data.current.model)
-- 		ESX.Game.SpawnLocalVehicle(data.current.model, shopCoords, 0.0, function(vehicle)
-- 			table.insert(spawnedVehicles, vehicle)
-- 			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
-- 			FreezeEntityPosition(vehicle, true)

-- 			if data.current.livery then
-- 				SetVehicleModKit(vehicle, 0)
-- 				SetVehicleLivery(vehicle, data.current.livery)
-- 			end
-- 		end)
-- 	end)

-- 	WaitForVehicleToLoad(elements[1].model)
-- 	ESX.Game.SpawnLocalVehicle(elements[1].model, shopCoords, 0.0, function(vehicle)
-- 		table.insert(spawnedVehicles, vehicle)
-- 		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
-- 		FreezeEntityPosition(vehicle, true)

-- 		if elements[1].livery then
-- 			SetVehicleModKit(vehicle, 0)
-- 			SetVehicleLivery(vehicle,elements[1].livery)
-- 		end
-- 	end)
-- end

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(0)

-- 		if isInShopMenu then
-- 			DisableControlAction(0, 75, true)  -- Disable exit vehicle
-- 			DisableControlAction(27, 75, true) -- Disable exit vehicle
-- 		else
-- 			Citizen.Wait(500)
-- 		end
-- 	end
-- end)

-- function DeleteSpawnedVehicles()
-- 	while #spawnedVehicles > 0 do
-- 		local vehicle = spawnedVehicles[1]
-- 		ESX.Game.DeleteVehicle(vehicle)
-- 		table.remove(spawnedVehicles, 1)
-- 	end
-- end

-- function WaitForVehicleToLoad(modelHash)
-- 	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

-- 	if not HasModelLoaded(modelHash) then
-- 		RequestModel(modelHash)

-- 		while not HasModelLoaded(modelHash) do
-- 			Citizen.Wait(0)
-- 			DisableAllControlActions(0)

-- 			drawLoadingText(_U('vehicleshop_awaiting_model'), 255, 255, 255, 255)
-- 		end
-- 	end
-- end

function drawLoadingText(text, red, green, blue, alpha)
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(red, green, blue, alpha)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)

	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.5, 0.5)
end

function OpenPoliceActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'police_actions', {
		css      = 'police',
		title    = 'Police',
		align    = 'top-left',
		elements = {
			{label = '<span style="color:orange;">Status de l\'agent <span style="color:cyan;"> >', value = 'status'},
			{label = '<span style="color:#00cc00;">Intéraction Citoyen <span style="color:cyan;"> >', value = 'citizen_interaction'},
			{label = '<span style="color:#669999;">Menu Menottes<span style="color:cyan;"> >', value = 'menu_menottes'},
			{label = '<span style="color:#00cc00;">Interaction véhicule <span style="color:cyan;"> >', value = 'vehicle_interaction'},
			{label = '<span style="color:#669999;">Menu objets <span style="color:cyan;"> >', value = 'object_spawner'},
			--{label = '<span style="color:#669999;">Equipement LSPD<span style="color:cyan;"> >', value = 'lspd_equipement'},
			{label = '<span style="color:#669999;">Donner une amende<span style="color:cyan;"> >', value = 'ammende'},
			{label = '<span style="color:#ff6600;">Demande renfort<span style="color:cyan;"> >', value = 'renfort'}
	}}, function(data, menu)
		if data.current.value == 'citizen_interaction' then
			local elements = {
				{label = _U('id_card'), value = 'identity_card'},
				{label = _U('search'), value = 'body_search'},
				{label = _U('fine'), value = 'fine'},
				{label = _U('unpaid_bills'), value = 'unpaid_bills'}
			}


			if PlayerData.job and PlayerData.job.name == 'police' and (PlayerData.job.grade_name == 'intendent' or PlayerData.job.grade_name == 'lieutenant' or PlayerData.job.grade_name == 'chef' or PlayerData.job.grade_name == 'boss') then
				table.insert(elements, {label = 'Donner le PPA', value = 'ppa'})
			end

			if Config.EnableLicenses then
				table.insert(elements, { label = _U('license_check'), value = 'license' })
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				css      = 'police',
				title    = _U('citizen_interaction'),
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
					local action = data2.current.value

					if action == 'identity_card' then
						OpenIdentityCardMenu(closestPlayer)
					elseif action == 'body_search' then
						TriggerServerEvent('esx_policejob:message', GetPlayerServerId(closestPlayer), _U('being_searched'))
						OpenBodySearchMenu(closestPlayer)
					elseif action == 'ppa' then
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if closestPlayer ~= -1 and closestDistance <= 3.0 then
						ESX.ShowNotification(_U('licence_you_ppa', data.current.label, targetName))
						TriggerServerEvent('esx_license:addLicense', GetPlayerServerId(closestPlayer), 'weapon')
					else
						ESX.ShowNotification('Aucun joueurs à proximité')
					end						
					elseif action == 'handcuff' then
						--TriggerServerEvent('esx_policejob:handcuff', GetPlayerServerId(closestPlayer))
						local target, distance = ESX.Game.GetClosestPlayer()
						playerheading = GetEntityHeading(GetPlayerPed(-1))
						playerlocation = GetEntityForwardVector(PlayerPedId())
						playerCoords = GetEntityCoords(GetPlayerPed(-1))
						local target_id = GetPlayerServerId(target)
						if distance <= 2.0 then
							TriggerServerEvent('esx_policejob:requestarrest', target_id, playerheading, playerCoords, playerlocation)
							Wait(5000)
							TriggerServerEvent('esx_policejob:handcuff', GetPlayerServerId(closestPlayer))
						else
							ESX.ShowNotification('Not Close Enough')
						end
					elseif action == 'handcuff2' then
						local target, distance = ESX.Game.GetClosestPlayer()
						playerheading = GetEntityHeading(GetPlayerPed(-1))
						playerlocation = GetEntityForwardVector(PlayerPedId())
						playerCoords = GetEntityCoords(GetPlayerPed(-1))
						local target_id = GetPlayerServerId(target)
						TriggerServerEvent('esx_policejob:requestrelease', target_id, playerheading, playerCoords, playerlocation)
						Wait(5000)
						TriggerServerEvent('esx_policejob:handcuff', GetPlayerServerId(closestPlayer))
					elseif action == 'drag' then
						TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
					elseif action == 'put_in_vehicle' then
						TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(closestPlayer))
					elseif action == 'out_the_vehicle' then
						TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(closestPlayer))
					elseif action == 'fine' then
						OpenFineMenu(closestPlayer)
					elseif action == 'license' then
						ShowPlayerLicense(closestPlayer)
					elseif action == 'unpaid_bills' then
						OpenUnpaidBillsMenu(closestPlayer)						
					end
				else
					ESX.ShowNotification(_U('no_players_nearby'))
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'ammende' then

			ESX.UI.Menu.Open(
				'dialog', GetCurrentResourceName(), 'ammende',
				{
					title = 'Donner une contravention'
				},
				function(data, menu)

					local amount = tonumber(data.value)

					if amount == nil or amount <= 0 then
						ESX.ShowNotification('Montant invalide')
					else
						menu.close()

						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

						if closestPlayer == -1 or closestDistance > 3.0 then
							ESX.ShowNotification('Pas de joueurs proche')
						else
							local playerPed        = GetPlayerPed(-1)

							Citizen.CreateThread(function()
								TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', 0, true)
								Citizen.Wait(5000)
								ClearPedTasks(playerPed)
								TriggerServerEvent('esx_billing:sendBill1', GetPlayerServerId(closestPlayer), 'society_police', 'Police', amount)
							end)
						end
					end
				end,
				function(data, menu)
					menu.close()
			end)
		elseif data.current.value == 'menu_menottes' then
			local elements  = {}

			local elements = {
				{label = '<span style="color:green;">Mettre<span style="color:white;"> les menottes', value = 'handcuff'},
				{label = '<span style="color:red;">Enlever<span style="color:white;"> les menottes', value = 'handcuff2'},
				{label = 'Escorter la personne', value = 'drag'},
				{label = '<span style="color:green;">Mettre<span style="color:white;"> dans le véhicule', value = 'put_in_vehicle'},
				{label = '<span style="color:red;">Retirer<span style="color:white;"> du véhicule', value = 'out_the_vehicle'}
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Menu_Menottes', {
				css      = 'police',
				title    = 'Menu Menottes',
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
					local action = data2.current.value

					if action == 'handcuff' then
						local target, distance = ESX.Game.GetClosestPlayer()
						playerheading = GetEntityHeading(GetPlayerPed(-1))
						playerlocation = GetEntityForwardVector(PlayerPedId())
						playerCoords = GetEntityCoords(GetPlayerPed(-1))
						local target_id = GetPlayerServerId(target)
						if distance <= 2.0 then
							TriggerServerEvent('esx_policejob:requestarrest', target_id, playerheading, playerCoords, playerlocation)
							Wait(5000)
							TriggerServerEvent('esx_policejob:handcuff', GetPlayerServerId(closestPlayer))
						else
							ESX.ShowNotification('Not Close Enough')
						end
					elseif action == 'handcuff2' then
						local target, distance = ESX.Game.GetClosestPlayer()
						playerheading = GetEntityHeading(GetPlayerPed(-1))
						playerlocation = GetEntityForwardVector(PlayerPedId())
						playerCoords = GetEntityCoords(GetPlayerPed(-1))
						local target_id = GetPlayerServerId(target)
						TriggerServerEvent('esx_policejob:requestrelease', target_id, playerheading, playerCoords, playerlocation)
						Wait(5000)
						TriggerServerEvent('esx_policejob:handcuff', GetPlayerServerId(closestPlayer))
					elseif action == 'drag' then
						TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
					elseif action == 'put_in_vehicle' then
						TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(closestPlayer))
					elseif action == 'out_the_vehicle' then
						TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(closestPlayer))
					end
				else
					ESX.ShowNotification('Pas de joueurs proches')
				end

			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'status' then
			local elements  = {}

			local elements = {
				{label = '<span style="color:green;">Prise<span style="color:white;"> de service', value = 'prise'},
				{label = '<span style="color:red;">Fin<span style="color:white;"> de service', value = 'fin'},
				{label = '<span style="color:orange;">Pause<span style="color:white;"> de service', value = 'pause'},
				{label = '<span style="color:orange;">Standby<span style="color:gray;">, en attente de dispatch', value = 'standby'},
				{label = '<span style="color:orange;">Control<span style="color:gray;"> routier en cours', value = 'control'},
				{label = '<span style="color:orange;">Refus<span style="color:gray;"> d\'obtempérer / Délit de fuite', value = 'refus'},
				{label = '<span style="color:orange;">Arrestation<span style="color:gray;"> en cours', value = 'arrestation'}
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'status_service', {
				css      = 'police',
				title    = 'Status Service',
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local action = data2.current.value

				if action == 'prise' then
					local info = 'prise'
					TriggerServerEvent('police:PriseEtFinservice', info)
				elseif action == 'fin' then
					local info = 'fin'
					TriggerServerEvent('police:PriseEtFinservice', info)
				elseif action == 'pause' then
					local info = 'pause'
					TriggerServerEvent('police:PriseEtFinservice', info)
				elseif action == 'standby' then
					local info = 'standby'
					TriggerServerEvent('police:PriseEtFinservice', info)
				elseif action == 'control' then
					local info = 'control'
					TriggerServerEvent('police:PriseEtFinservice', info)
				elseif action == 'refus' then
					local info = 'refus'
					TriggerServerEvent('police:PriseEtFinservice', info)
				elseif action == 'arrestation' then
					local info = 'arrestation'
					TriggerServerEvent('police:PriseEtFinservice', info)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'vehicle_interaction' then
			local elements  = {}
			local playerPed = PlayerPedId()
			local vehicle = ESX.Game.GetVehicleInDirection()

			if DoesEntityExist(vehicle) then
				table.insert(elements, {label = _U('vehicle_info'), value = 'vehicle_infos'})
				table.insert(elements, {label = _U('pick_lock'), value = 'hijack_vehicle'})
				table.insert(elements, {label = _U('impound'), value = 'impound'})
			end

			table.insert(elements, {label = _U('search_database'), value = 'search_database'})
			--table.insert(elements, {label = 'Fourrière (à coté du véhicule)', value = 'impound2'})

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_interaction', {
				css      = 'police',
				title    = _U('vehicle_interaction'),
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local coords  = GetEntityCoords(playerPed)
				vehicle = ESX.Game.GetVehicleInDirection()
				action  = data2.current.value

				if action == 'search_database' then
					LookupVehicle()
				elseif action == 'impound2' then
					-- is the script busy?
					if currentTask.busy then
						return
					end

					local playerPed = PlayerPedId()
					local vehicle   = ESX.Game.GetVehicleInDirection()
					if IsPedInAnyVehicle(playerPed, true) then
					    vehicle = GetVehiclePedIsIn(playerPed, false)
					end
					local entity = vehicle
					carModel = GetEntityModel(entity)
					carName = GetDisplayNameFromVehicleModel(carModel)
					NetworkRequestControlOfEntity(entity)
					
					local timeout = 2000
					while timeout > 0 and not NetworkHasControlOfEntity(entity) do
					    Wait(100)
					    timeout = timeout - 100
					end
				 
					SetEntityAsMissionEntity(entity, true, true)
					
					local timeout = 2000
					while timeout > 0 and not IsEntityAMissionEntity(entity) do
					    Wait(100)
					    timeout = timeout - 100
					end
				 
					Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
					
					if (DoesEntityExist(entity)) then 
					    DeleteEntity(entity)
					end
				elseif DoesEntityExist(vehicle) then
					if action == 'vehicle_infos' then
						local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
						OpenVehicleInfosMenu(vehicleData)
					elseif action == 'hijack_vehicle' then
						if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
							TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
							Citizen.Wait(20000)
							ClearPedTasksImmediately(playerPed)

							SetVehicleDoorsLocked(vehicle, 1)
							SetVehicleDoorsLockedForAllPlayers(vehicle, false)
							ESX.ShowNotification(_U('vehicle_unlocked'))
						end
					elseif action == 'impound' then
						-- is the script busy?
						if currentTask.busy then
							return
						end

						ESX.ShowHelpNotification(_U('impound_prompt'))
						TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)

						currentTask.busy = true
						currentTask.task = ESX.SetTimeout(10000, function()
							ClearPedTasks(playerPed)
							ImpoundVehicle(vehicle)
							Citizen.Wait(100) -- sleep the entire script to let stuff sink back to reality
						end)

						-- keep track of that vehicle!
						Citizen.CreateThread(function()
							while currentTask.busy do
								Citizen.Wait(1000)

								vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 3.0, 0, 71)
								if not DoesEntityExist(vehicle) and currentTask.busy then
									ESX.ShowNotification(_U('impound_canceled_moved'))
									ESX.ClearTimeout(currentTask.task)
									ClearPedTasks(playerPed)
									currentTask.busy = false
									break
								end
							end
						end)
					end
				else
					ESX.ShowNotification(_U('no_vehicles_nearby'))
				end

			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'renfort' then
			local elements  = {}
			local playerPed = PlayerPedId()

			table.insert(elements, {label = ('Petite demande'), value = 'petite_demande'})
			table.insert(elements, {label = ('Demande importante'), value = 'demande_importante'})
			table.insert(elements, {label = ('Toute les unitées demandé !'), value = 'omgad'})


			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'renfort', {
				css      = 'police',
				title    = ('Menu renfort'),
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local coords  = GetEntityCoords(playerPed)
				vehicle = ESX.Game.GetVehicleInDirection()
				action  = data2.current.value
				local name = GetPlayerName(PlayerId())

				if action == 'petite_demande' then
					local raison = 'petit'
					TriggerServerEvent('renfort', coords, raison)
				elseif action == 'demande_importante' then
					local raison = 'importante'
					TriggerServerEvent('renfort', coords, raison)
				elseif action == 'omgad' then
					local raison = 'omgad'
					TriggerServerEvent('renfort', coords, raison)
				end

			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'lspd_equipement' then
			local elements  = {}
			local playerPed = PlayerPedId()
			local grade = PlayerData.job.grade_name

			if grade == 'recruit' then
				table.insert(elements, {label = ('Equipement Cadet'), value = 'equipement_cadet'})
			elseif grade == 'officer' then
				table.insert(elements, {label = ('Equipement officier'), value = 'equipement_officier'})
			elseif grade == 'sergeant' then
				table.insert(elements, {label = ('Equipement sergeant'), value = 'equipement_sergeant'})
			elseif grade == 'lieutenant' then
				table.insert(elements, {label = ('Equipement Lieutenant'), value = 'equipement_lieutenant'})
			elseif grade == 'boss' then
				table.insert(elements, {label = ('Equipement CMD'), value = 'equipement_cmd'})
			end
	


			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lspd_equipement', {
				css      = 'police',
				title    = ('Menu équipement'),
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local coords  = GetEntityCoords(playerPed)
				vehicle = ESX.Game.GetVehicleInDirection()
				action  = data2.current.value
				local name = GetPlayerName(PlayerId())

				if action == 'equipement_cadet' then
					PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
					Citizen.Wait(2000)
					GiveWeaponToPed(PlayerPedId(), "WEAPON_COMBATPISTOL", 255, false, false)
					GiveWeaponToPed(PlayerPedId(), "WEAPON_STUNGUN", 255, false, false)
					GiveWeaponToPed(PlayerPedId(), "WEAPON_NIGHTSTICK", 255, false, false)
					
					ESX.ShowAdvancedNotification('LSPD INFO', 'Armurie LSPD', 'Voila ton équipement, le perd pas.', 'CHAR_AMMUNATION', 1)
					PlaySoundFrontend(-1, "Bus_Schedule_Pickup", "DLC_PRISON_BREAK_HEIST_SOUNDS", 0)
				elseif action == 'equipement_officier' then
					PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
					Citizen.Wait(2000)
					GiveWeaponToPed(PlayerPedId(), "WEAPON_COMBATPISTOL", 255, false, false)
					GiveWeaponToPed(PlayerPedId(), "WEAPON_STUNGUN", 255, false, false)
					GiveWeaponToPed(PlayerPedId(), "WEAPON_NIGHTSTICK", 255, false, false)
					GiveWeaponToPed(PlayerPedId(), "WEAPON_CARBINERIFLE", 255, false, false)
					
					ESX.ShowAdvancedNotification('LSPD INFO', 'Armurie LSPD', 'Voila ton équipement, le perd pas.', 'CHAR_AMMUNATION', 1)
					PlaySoundFrontend(-1, "Bus_Schedule_Pickup", "DLC_PRISON_BREAK_HEIST_SOUNDS", 0)
				elseif action == 'equipement_sergeant' then
					PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
					Citizen.Wait(2000)
					GiveWeaponToPed(PlayerPedId(), "WEAPON_COMBATPISTOL", 255, false, false)
					GiveWeaponToPed(PlayerPedId(), "WEAPON_STUNGUN", 255, false, false)
					GiveWeaponToPed(PlayerPedId(), "WEAPON_NIGHTSTICK", 255, false, false)
					GiveWeaponToPed(PlayerPedId(), "WEAPON_ADVANCEDRIFLE", 255, false, false)
					GiveWeaponToPed(PlayerPedId(), "WEAPON_FLASHBANG", 25, false, false)
					
					ESX.ShowAdvancedNotification('LSPD INFO', 'Armurie LSPD', 'Voila ton équipement, le perd pas.', 'CHAR_AMMUNATION', 1)
					PlaySoundFrontend(-1, "Bus_Schedule_Pickup", "DLC_PRISON_BREAK_HEIST_SOUNDS", 0)
				elseif action == 'equipement_lieutenant' then
					PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
					Citizen.Wait(2000)
					GiveWeaponToPed(PlayerPedId(), "WEAPON_COMBATPISTOL", 255, false, false)
					GiveWeaponToPed(PlayerPedId(), "WEAPON_STUNGUN", 255, false, false)
					GiveWeaponToPed(PlayerPedId(), "WEAPON_NIGHTSTICK", 255, false, false)
					GiveWeaponToPed(PlayerPedId(), "WEAPON_ADVANCEDRIFLE", 255, false, false)
					GiveWeaponToPed(PlayerPedId(), "WEAPON_SNIPERRIFLE", 255, false, false)
					GiveWeaponToPed(PlayerPedId(), "WEAPON_FLASHBANG", 25, false, false)
					
					ESX.ShowAdvancedNotification('LSPD INFO', 'Armurie LSPD', 'Voila ton équipement, le perd pas.', 'CHAR_AMMUNATION', 1)
					PlaySoundFrontend(-1, "Bus_Schedule_Pickup", "DLC_PRISON_BREAK_HEIST_SOUNDS", 0)
				elseif action == 'equipement_cmd' then
					PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
					Citizen.Wait(2000)
					GiveWeaponToPed(PlayerPedId(), "WEAPON_COMBATPISTOL", 255, false, false)
					GiveWeaponToPed(PlayerPedId(), "WEAPON_STUNGUN", 255, false, false)
					GiveWeaponToPed(PlayerPedId(), "WEAPON_NIGHTSTICK", 255, false, false)
					GiveWeaponToPed(PlayerPedId(), "WEAPON_ADVANCEDRIFLE", 255, false, false)
					GiveWeaponToPed(PlayerPedId(), "WEAPON_HEAVYSNIPER", 255, false, false)
					GiveWeaponToPed(PlayerPedId(), "WEAPON_FLASHBANG", 25, false, false)
					
					ESX.ShowAdvancedNotification('LSPD INFO', 'Armurie LSPD', 'Voila ton équipement, le perd pas.', 'CHAR_AMMUNATION', 1)
					PlaySoundFrontend(-1, "Bus_Schedule_Pickup", "DLC_PRISON_BREAK_HEIST_SOUNDS", 0)
					
				end

			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'object_spawner' then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				css      = 'police',
				title    = _U('traffic_interaction'),
				align    = 'top-left',
				elements = {
					{label = _U('cone'), model = 'prop_roadcone02a'},
					{label = _U('barrier'), model = 'prop_barrier_work05'},
					{label = _U('spikestrips'), model = 'p_ld_stinger_s'},
					{label = _U('box'), model = 'prop_boxpile_07d'},
			}}, function(data2, menu2)
				local playerPed = PlayerPedId()
				local coords    = GetEntityCoords(playerPed)
				local forward   = GetEntityForwardVector(playerPed)
				local x, y, z   = table.unpack(coords + forward * 1.0)

				if data2.current.model == 'prop_roadcone02a' then
					z = z + 2.0
				end

				ESX.Game.SpawnObject(data2.current.model, {x = x, y = y, z = z}, function(obj)
					SetEntityHeading(obj, GetEntityHeading(playerPed))
					PlaceObjectOnGroundProperly(obj)
				end)
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenIdentityCardMenu(player)
	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
		local elements = {}
		local nameLabel = _U('name', data.name)
		local jobLabel, sexLabel, dobLabel, heightLabel, idLabel

		if data.job.grade_label and  data.job.grade_label ~= '' then
			jobLabel = _U('job', data.job.label .. ' - ' .. data.job.grade_label)
		else
			jobLabel = _U('job', data.job.label)
		end

		if Config.EnableESXIdentity then
			nameLabel = _U('name', data.firstname .. ' ' .. data.lastname)

			if data.sex then
				if string.lower(data.sex) == 'm' then
					sexLabel = _U('sex', _U('male'))
				else
					sexLabel = _U('sex', _U('female'))
				end
			else
				sexLabel = _U('sex', _U('unknown'))
			end

			if data.dob then
				dobLabel = _U('dob', data.dob)
			else
				dobLabel = _U('dob', _U('unknown'))
			end

			if data.height then
				heightLabel = _U('height', data.height)
			else
				heightLabel = _U('height', _U('unknown'))
			end

			if data.name then
				idLabel = _U('id', data.name)
			else
				idLabel = _U('id', _U('unknown'))
			end
		end

		local elements = {
			{label = nameLabel},
			{label = jobLabel}
		}

		if Config.EnableESXIdentity then
			table.insert(elements, {label = sexLabel})
			table.insert(elements, {label = dobLabel})
			table.insert(elements, {label = heightLabel})
			table.insert(elements, {label = idLabel})
		end

		if data.drunk then
			table.insert(elements, {label = _U('bac', data.drunk)})
		end

		if data.licenses then
			table.insert(elements, {label = _U('license_label')})

			for i=1, #data.licenses, 1 do
				table.insert(elements, {label = data.licenses[i].label})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
			css      = 'police',
			title    = _U('citizen_interaction'),
			align    = 'top-left',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

-- function OpenBodySearchMenu(player)
-- 	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
-- 		local elements = {}

-- 		for i=1, #data.accounts, 1 do
-- 			if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
-- 				table.insert(elements, {
-- 					label    = _U('confiscate_dirty', ESX.Math.Round(data.accounts[i].money)),
-- 					value    = 'black_money',
-- 					itemType = 'item_account',
-- 					amount   = data.accounts[i].money
-- 				})

-- 				break
-- 			end
-- 		end

-- 		table.insert(elements, {label = _U('guns_label')})

-- 		for i=1, #data.weapons, 1 do
-- 			table.insert(elements, {
-- 				label    = _U('confiscate_weapon', ESX.GetWeaponLabel(data.weapons[i].name), data.weapons[i].ammo),
-- 				value    = data.weapons[i].name,
-- 				itemType = 'item_weapon',
-- 				amount   = data.weapons[i].ammo
-- 			})
-- 		end

-- 		table.insert(elements, {label = _U('inventory_label')})

-- 		for i=1, #data.inventory, 1 do
-- 			if data.inventory[i].count > 0 then
-- 				table.insert(elements, {
-- 					label    = _U('confiscate_inv', data.inventory[i].count, data.inventory[i].label),
-- 					value    = data.inventory[i].name,
-- 					itemType = 'item_standard',
-- 					amount   = data.inventory[i].count
-- 				})
-- 			end
-- 		end

-- 		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
-- 			css      = 'police',
-- 			title    = _U('search'),
-- 			align    = 'top-left',
-- 			elements = elements
-- 		}, function(data, menu)
-- 			if data.current.value then
-- 				TriggerServerEvent('esx_policejob:confiscatePlayerItem', GetPlayerServerId(player), data.current.itemType, data.current.value, data.current.amount)
-- 				OpenBodySearchMenu(player)
-- 			end
-- 		end, function(data, menu)
-- 			menu.close()
-- 		end)
-- 	end, GetPlayerServerId(player))
-- end
function OpenBodySearchMenu(player)
	TriggerEvent("esx_ava_inventories:openPlayerInventory", GetPlayerServerId(player))
end

function OpenFineMenu(player)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine', {
		css      = 'police',
		title    = _U('fine'),
		align    = 'top-left',
		elements = {
			-- {label = _U('traffic_offense'), value = 0},
			-- {label = _U('minor_offense'),   value = 1},
			-- {label = _U('average_offense'), value = 2},
			-- {label = _U('major_offense'),   value = 3}
			{label = _U('0_offense'), value = 0},
			{label = _U('1_offense'), value = 1},
			{label = _U('2_offense'), value = 2},
			{label = _U('3_offense'), value = 3},
			{label = _U('4_offense'), value = 4},
			{label = _U('5_offense'), value = 5},

	}}, function(data, menu)
		OpenFineCategoryMenu(player, data.current.value)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenFineCategoryMenu(player, category)
	ESX.TriggerServerCallback('esx_policejob:getFineList', function(fines)
		local elements = {}

		for k,fine in ipairs(fines) do
			table.insert(elements, {
				label     = ('%s <span style="color:green;">%s</span>'):format(fine.label, _U('armory_item', ESX.Math.GroupDigits(fine.amount))),
				value     = fine.id,
				amount    = fine.amount,
				fineLabel = fine.label
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine_category', {
			css      = 'police',
			title    = _U('fine'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()

			if Config.EnablePlayerManagement then
				TriggerServerEvent('esx_billing:sendBill1', GetPlayerServerId(player), 'society_police', _U('fine_total', data.current.fineLabel), data.current.amount)
			else
				TriggerServerEvent('esx_billing:sendBill1', GetPlayerServerId(player), '', _U('fine_total', data.current.fineLabel), data.current.amount)
			end

			ESX.SetTimeout(300, function()
				OpenFineCategoryMenu(player, category)
			end)
		end, function(data, menu)
			menu.close()
		end)
	end, category)
end

function LookupVehicle()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'lookup_vehicle',
	{
		css      = 'police',
		title = _U('search_database_title'),
	}, function(data, menu)
		local length = string.len(data.value)
		if data.value == nil or length < 2 or length > 13 then
			ESX.ShowNotification(_U('search_database_error_invalid'))
		else
			ESX.TriggerServerCallback('esx_policejob:getVehicleFromPlate', function(owner, found)
				if found then
					ESX.ShowNotification(_U('search_database_found', owner))
				else
					ESX.ShowNotification(_U('search_database_error_not_found'))
				end
			end, data.value)
			menu.close()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function ShowPlayerLicense(player)
	local elements, targetName = {}

	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
		if data.licenses then
			for i=1, #data.licenses, 1 do
				if data.licenses[i].label and data.licenses[i].type then
					table.insert(elements, {
						label = data.licenses[i].label,
						type = data.licenses[i].type
					})
				end
			end
		end

		if Config.EnableESXIdentity then
			targetName = data.firstname .. ' ' .. data.lastname
		else
			targetName = data.name
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_license', {
			title    = _U('license_revoke'),
			align    = 'top-left',
			elements = elements,
		}, function(data, menu)
			ESX.ShowNotification(_U('licence_you_revoked', data.current.label, targetName))
			TriggerServerEvent('esx_policejob:message', GetPlayerServerId(player), _U('license_revoked', data.current.label))

			TriggerServerEvent('esx_license:removeLicense', GetPlayerServerId(player), data.current.type)

			ESX.SetTimeout(300, function()
				ShowPlayerLicense(player)
			end)
		end, function(data, menu)
			menu.close()
		end)

	end, GetPlayerServerId(player))
end

function OpenUnpaidBillsMenu(player)
	local elements = {}

	ESX.TriggerServerCallback('esx_billing:getTargetBills', function(bills)
		for k,bill in ipairs(bills) do
			table.insert(elements, {
				label = ('%s - <span style="color:red;">%s</span>'):format(bill.label, _U('armory_item', ESX.Math.GroupDigits(bill.amount))),
				billId = bills[i].id
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'billing', {
			css      = 'police',
			title    = _U('unpaid_bills'),
			align    = 'top-left',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

function OpenVehicleInfosMenu(vehicleData)
	ESX.TriggerServerCallback('esx_policejob:getVehicleInfos', function(retrivedInfo)
		local elements = {{label = _U('plate', retrivedInfo.plate)}}

		if retrivedInfo.owner == nil then
			table.insert(elements, {label = _U('owner_unknown')})
		else
			table.insert(elements, {label = _U('owner', retrivedInfo.owner)})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos', {
			css      = 'police',
			title    = _U('vehicle_info'),
			align    = 'top-left',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
	end, vehicleData.plate)
end

function OpenGetWeaponMenu()
	ESX.TriggerServerCallback('esx_policejob:getArmoryWeapons', function(weapons)
		local elements = {}

		for i=1, #weapons, 1 do
			if weapons[i].count > 0 then
				table.insert(elements, {
					label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name),
					value = weapons[i].name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon', {
			css      = 'police',
			title    = _U('get_weapon_menu'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()
			if not HasPedGotWeapon(PlayerPedId(), GetHashKey(data.current.value), false) then
				ESX.TriggerServerCallback('esx_policejob:removeArmoryWeapon', function()
					OpenGetWeaponMenu()
				end, data.current.value, 'weaponsGrasped')
			else
				ESX.ShowNotification("Vous avez déjà cette arme sur vous.")
			end

		end, function(data, menu)
			menu.close()
		end)
	end, 'weaponsGrasped')
end


function OpenPutWeaponMenu()
	local elements   = {}
	local playerPed  = PlayerPedId()
	local weaponList = ESX.GetWeaponList()

	for i=1, #weaponList, 1 do
		local weaponHash = GetHashKey(weaponList[i].name)

		if HasPedGotWeapon(playerPed, weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
			table.insert(elements, {
				label = weaponList[i].label,
				value = weaponList[i].name
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_put_weapon', {
		css      = 'police',
		title    = _U('put_weapon_menu'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()

		ESX.TriggerServerCallback('esx_policejob:addArmoryWeapon', function()
			OpenPutWeaponMenu()
		end, data.current.value, true, 'weaponsGrasped')
	end, function(data, menu)
		menu.close()
	end)
end

--function OpenBuyWeaponsMenu()
--	local elements = {}
--	local playerPed = PlayerPedId()
--	PlayerData = ESX.GetPlayerData()
--	local hasWeapon = HasPedGotWeapon(playerPed, GetHashKey(v.weapon), false)

--	for k,v in ipairs(Config.AuthorizedWeapons[PlayerData.job.grade_name]) do
--		local weaponNum, weapon = ESX.GetWeapon(v.weapon)
--		local components, label = {}
--		local hasWeapon = HasPedGotWeapon(playerPed, GetHashKey(v.weapon), false)

--		if v.components then
--			for i=1, #v.components do
--				if v.components[i] then
--					local component = weapon.components[i]
--					local hasComponent = HasPedGotWeaponComponent(playerPed, GetHashKey(v.weapon), component.hash)
--
--					if hasComponent then
--						label = ('%s: <span style="color:green;">%s</span>'):format(component.label, _U('armory_owned'))
--					else
--						if v.components[i] > 0 then
--							label = ('%s: <span style="color:green;">%s</span>'):format(component.label, _U('armory_item', ESX.Math.GroupDigits(v.components[i])))
--						else
--							label = ('%s: <span style="color:green;">%s</span>'):format(component.label, _U('armory_free'))
--						end
--					end
--
--					table.insert(components, {
--						label = label,
--						componentLabel = component.label,
--						hash = component.hash,
--						name = component.name,
--						price = v.components[i],
--						hasComponent = hasComponent,
--						componentNum = i
--					})
--				end
--			end
--		end
--
--		if hasWeapon and v.components then
--			label = ('%s: <span style="color:green;">></span>'):format(weapon.label)
--		elseif hasWeapon and not v.components then
--			label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, _U('armory_owned'))
--		else
--			if v.price > 0 then
--				label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, _U('armory_item', ESX.Math.GroupDigits(v.price)))
--			else
--				label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, _U('armory_free'))
--			end
--		end
--
--		table.insert(elements, {
--			label = label,
--			weaponLabel = weapon.label,
--			name = weapon.name,
--			components = components,
--			price = v.price,
--			hasWeapon = hasWeapon
--		})
--	end
--
--	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_weapons', {
--		title    = _U('armory_weapontitle'),
--		align    = 'top-left',
--		elements = elements
--	}, function(data, menu)
--		if data.current.hasWeapon then
--			if #data.current.components > 0 then
--				OpenWeaponComponentShop(data.current.components, data.current.name, menu)
--			end
--		else
--			ESX.TriggerServerCallback('esx_policejob:buyWeapon', function(bought)
--				if bought then
--					if data.current.price > 0 then
--						ESX.ShowNotification(_U('armory_bought', data.current.weaponLabel, ESX.Math.GroupDigits(data.current.price)))
--					end
--
--					menu.close()
--					OpenBuyWeaponsMenu()
--				else
--					ESX.ShowNotification(_U('armory_money'))
--				end
--			end, data.current.name, 1)
--		end
--	end, function(data, menu)
--		menu.close()
--	end)
--end

function OpenWeaponComponentShop(components, weaponName, parentShop)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_weapons_components', {
		css      = 'police',
		title    = _U('armory_componenttitle'),
		align    = 'top-left',
		elements = components
	}, function(data, menu)
		if data.current.hasComponent then
			ESX.ShowNotification(_U('armory_hascomponent'))
		else
			ESX.TriggerServerCallback('esx_policejob:buyWeapon', function(bought)
				if bought then
					if data.current.price > 0 then
						ESX.ShowNotification(_U('armory_bought', data.current.componentLabel, ESX.Math.GroupDigits(data.current.price)))
					end

					menu.close()
					parentShop.close()
					OpenBuyWeaponsMenu()
				else
					ESX.ShowNotification(_U('armory_money'))
				end
			end, weaponName, 2, data.current.componentNum)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenGetStocksMenu()
	ESX.TriggerServerCallback('esx_policejob:getStockItems', function(items)
		local elements = {}

		for i=1, #items, 1 do
			if items[i].count > 0 then
				table.insert(elements, {
					label = 'x' .. items[i].count .. ' ' .. items[i].label,
					value = items[i].name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			css      = 'police',
			title    = _U('police_stock'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				css      = 'police',
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_policejob:getStockItem', itemName, count)

					Citizen.Wait(300)
					OpenGetStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPutStocksMenu()
	ESX.TriggerServerCallback('esx_policejob:getPlayerInventory', function(inventory)
		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			css      = 'police',
			title    = _U('inventory'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				css      = 'police',
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_policejob:putStockItems', itemName, count)

					Citizen.Wait(300)
					OpenPutStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job

	isPlayerWhitelisted = refreshPlayerWhitelisted()
	Citizen.Wait(5000)
	TriggerServerEvent('esx_policejob:forceBlip')
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = _U('phone_police'),
		number     = 'police',
		base64Icon = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyJpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNiAoV2luZG93cykiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6NDFGQTJDRkI0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6NDFGQTJDRkM0QUJCMTFFN0JBNkQ5OENBMUI4QUEzM0YiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDo0MUZBMkNGOTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDo0MUZBMkNGQTRBQkIxMUU3QkE2RDk4Q0ExQjhBQTMzRiIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PoW66EYAAAjGSURBVHjapJcLcFTVGcd/u3cfSXaTLEk2j80TCI8ECI9ABCyoiBqhBVQqVG2ppVKBQqUVgUl5OU7HKqNOHUHU0oHamZZWoGkVS6cWAR2JPJuAQBPy2ISEvLN57+v2u2E33e4k6Ngz85+9d++95/zP9/h/39GpqsqiRYsIGz8QZAq28/8PRfC+4HT4fMXFxeiH+GC54NeCbYLLATLpYe/ECx4VnBTsF0wWhM6lXY8VbBE0Ch4IzLcpfDFD2P1TgrdC7nMCZLRxQ9AkiAkQCn77DcH3BC2COoFRkCSIG2JzLwqiQi0RSmCD4JXbmNKh0+kc/X19tLtc9Ll9sk9ZS1yoU71YIk3xsbEx8QaDEc2ttxmaJSKC1ggSKBK8MKwTFQVXRzs3WzpJGjmZgvxcMpMtWIwqsjztvSrlzjYul56jp+46qSmJmMwR+P3+4aZ8TtCprRkk0DvUW7JjmV6lsqoKW/pU1q9YQOE4Nxkx4ladE7zd8ivuVmJQfXZKW5dx5EwPRw4fxNx2g5SUVLw+33AkzoRaQDP9SkFu6OKqz0uF8yaz7vsOL6ycQVLkcSg/BlWNsjuFoKE1knqDSl5aNnmPLmThrE0UvXqQqvJPyMrMGorEHwQfEha57/3P7mXS684GFjy8kreLppPUuBXfyd/ibeoS2kb0mWPANhJdYjb61AxUvx5PdT3+4y+Tb3mTd19ZSebE+VTXVGNQlHAC7w4VhH8TbA36vKq6ilnzlvPSunHw6Trc7XpZ14AyfgYeyz18crGN1Alz6e3qwNNQSv4dZox1h/BW9+O7eIaEsVv41Y4XeHJDG83Nl4mLTwzGhJYtx0PzNTjOB9KMTlc7Nkcem39YAGU7cbeBKVLMPGMVf296nMd2VbBq1wmizHoqqm/wrS1/Zf0+N19YN2PIu1fcIda4Vk66Zx/rVi+jo9eIX9wZGGcFXUMR6BHUa76/2ezioYcXMtpyAl91DSaTfDxlJbtLprHm2ecpObqPuTPzSNV9yKz4a4zJSuLo71/j8Q17ON69EmXiPIlNMe6FoyzOqWPW/MU03Lw5EFcyKghTrNDh7+/vw545mcJcWbTiGKpRdGPMXbx90sGmDaux6sXk+kimjU+BjnMkx3kYP34cXrFuZ+3nrHi6iDMt92JITcPjk3R3naRwZhpuNSqoD93DKaFVU7j2dhcF8+YzNlpErbIBTVh8toVccbaysPB+4pMcuPw25kwSsau7BIlmHpy3guaOPtISYyi/UkaJM5Lpc5agq5Xkcl6gIHkmqaMn0dtylcjIyPThCNyhaXyfR2W0I1our0v6qBii07ih5rDtGSOxNVdk1y4R2SR8jR/g7hQD9l1jUeY/WLJB5m39AlZN4GZyIQ1fFJNsEgt0duBIc5GRkcZF53mNwIzhXPDgQPoZIkiMkbTxtstDMVnmFA4cOsbz2/aKjSQjev4Mp9ZAg+hIpFhB3EH5Yal16+X+Kq3dGfxkzRY+KauBjBzREvGN0kNCTARu94AejBLMHorAQ7cEQMGs2cXvkWshYLDi6e9l728O8P1XW6hKeB2yv42q18tjj+iFTGoSi+X9jJM9RTxS9E+OHT0krhNiZqlbqraoT7RAU5bBGrEknEBhgJks7KXbLS8qERI0ErVqF/Y4K6NHZfLZB+/wzJvncacvFd91oXO3o/O40MfZKJOKu/rne+mRQByXM4lYreb1tUnkizVVA/0SpfpbWaCNBeEE5gb/UH19NLqEgDF+oNDQWcn41Cj0EXFEWqzkOIyYekslFkThsvMxpIyE2hIc6lXGZ6cPyK7Nnk5OipixRdxgUESAYmhq68VsGgy5CYKCUAJTg0+izApXne3CJFmUTwg4L3FProFxU+6krqmXu3MskkhSD2av41jLdzlnfFrSdCZxyqfMnppN6ZUa7pwt0h3fiK9DCt4IO9e7YqisvI7VYgmNv7mhBKKD/9psNi5dOMv5ZjukjsLdr0ffWsyTi6eSlfcA+dmiVyOXs+/sHNZu3M6PdxzgVO9GmDSHsSNqmTz/R6y6Xxqma4fwaS5Mn85n1ZE0Vl3CHBER3lUNEhiURpPJRFdTOcVnpUJnPIhR7cZXfoH5UYc5+E4RzRH3sfSnl9m2dSMjE+Tz9msse+o5dr7UwcQ5T3HwlWUkNuzG3dKFSTbsNs7m/Y8vExOlC29UWkMJlAxKoRQMR3IC7x85zOn6fHS50+U/2Untx2R1voinu5no+DQmz7yPXmMKZnsu0wrm0Oe3YhOVHdm8A09dBQYhTv4T7C+xUPrZh8Qn2MMr4qcDSRfoirWgKAvtgOpv1JI8Zi77X15G7L+fxeOUOiUFxZiULD5fSlNzNM62W+k1yq5gjajGX/ZHvOIyxd+Fkj+P092rWP/si0Qr7VisMaEWuCiYonXFwbAUTWWPYLV245NITnGkUXnpI9butLJn2y6iba+hlp7C09qBcvoN7FYL9mhxo1/y/LoEXK8Pv6qIC8WbBY/xr9YlPLf9dZT+OqKTUwfmDBm/GOw7ws4FWpuUP2gJEZvKqmocuXPZuWYJMzKuSsH+SNwh3bo0p6hao6HeEqwYEZ2M6aKWd3PwTCy7du/D0F1DsmzE6/WGLr5LsDF4LggnYBacCOboQLHQ3FFfR58SR+HCR1iQH8ukhA5s5o5AYZMwUqOp74nl8xvRHDlRTsnxYpJsUjtsceHt2C8Fm0MPJrphTkZvBc4It9RKLOFx91Pf0Igu0k7W2MmkOewS2QYJUJVWVz9VNbXUVVwkyuAmKTFJayrDo/4Jwe/CT0aGYTrWVYEeUfsgXssMRcpyenraQJa0VX9O3ZU+Ma1fax4xGxUsUVFkOUbcama1hf+7+LmA9juHWshwmwOE1iMmCFYEzg1jtIm1BaxW6wCGGoFdewPfvyE4ertTiv4rHC73B855dwp2a23bbd4tC1hvhOCbX7b4VyUQKhxrtSOaYKngasizvwi0RmOS4O1QZf2yYfiaR+73AvhTQEVf+rpn9/8IMAChKDrDzfsdIQAAAABJRU5ErkJggg=='
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

-- don't show dispatches if the player isn't in service
AddEventHandler('esx_phone:cancelMessage', function(dispatchNumber)
	if PlayerData.job and PlayerData.job.name == 'police' and PlayerData.job.name == dispatchNumber then
		-- if esx_service is enabled
		if Config.MaxInService ~= -1 and not playerInService then
			CancelEvent()
		end
	end
end)

AddEventHandler('esx_policejob:hasEnteredMarker', function(station, part, partNum)
	if part == 'Cloakroom' then
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	elseif part == 'Armory' then
		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}
	elseif part == 'SocietyGarage' then
		CurrentAction     = 'menu_vehicle_spawner'
		CurrentActionMsg  = _U('garage_prompt')
		CurrentActionData = {station = station, part = part, partNum = partNum}
	-- elseif part == 'delete_vehicle' then
	-- 	CurrentAction     = 'delete_vehicle'
	-- 	CurrentActionMsg  = _U('garage_prompt_delete')
	-- 	CurrentActionData = {station = station, part = part, partNum = partNum}	
	elseif part == 'SocietyHeliGarage' then
		CurrentAction     = 'menu_heli_spawner'
		CurrentActionMsg  = _U('helicopter_prompt')
		CurrentActionData = {station = station, part = part, partNum = partNum}
	elseif part == 'BossActions' then
		CurrentAction     = 'menu_boss_actions'
		CurrentActionMsg  = _U('open_bossmenu')
		CurrentActionData = {}
	end
end)

AddEventHandler('esx_policejob:hasExitedMarker', function(station, part, partNum)
	if not isInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

AddEventHandler('esx_policejob:hasEnteredEntityZone', function(entity)
	local playerPed = PlayerPedId()

	if PlayerData.job and PlayerData.job.name == 'police' and IsPedOnFoot(playerPed) then
		CurrentAction     = 'remove_entity'
		CurrentActionMsg  = _U('remove_prop')
		CurrentActionData = {entity = entity}
	end

	if GetEntityModel(entity) == GetHashKey('p_ld_stinger_s') then
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed)

			for i=0, 7, 1 do
				SetVehicleTyreBurst(vehicle, i, true, 1000)
			end
		end
	end
end)

AddEventHandler('esx_policejob:hasExitedEntityZone', function(entity)
	if CurrentAction == 'remove_entity' then
		CurrentAction = nil
	end
end)

RegisterNetEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function()
	IsHandcuffed    = not IsHandcuffed
	local playerPed = PlayerPedId()

	Citizen.CreateThread(function()
		if IsHandcuffed then

			RequestAnimDict('mp_arresting')
			while not HasAnimDictLoaded('mp_arresting') do
				Citizen.Wait(100)
			end

			TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)

			SetEnableHandcuffs(playerPed, true)
			DisablePlayerFiring(playerPed, true)
			SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
			SetPedCanPlayGestureAnims(playerPed, false)
			FreezeEntityPosition(playerPed, false)
			DisplayRadar(false)

			if Config.EnableHandcuffTimer then

				if handcuffTimer then
					ESX.ClearTimeout(HandcuffTimer)
				end

				StartHandcuffTimer()
			end

		else

			if Config.EnableHandcuffTimer and HandcuffTimer then
				ESX.ClearTimeout(HandcuffTimer)
			end

			ClearPedSecondaryTask(playerPed)
			SetEnableHandcuffs(playerPed, false)
			DisablePlayerFiring(playerPed, false)
			SetPedCanPlayGestureAnims(playerPed, true)
			FreezeEntityPosition(playerPed, false)
			DisplayRadar(true)
		end
	end)

end)

RegisterNetEvent('esx_policejob:unrestrain')
AddEventHandler('esx_policejob:unrestrain', function()
	if IsHandcuffed then
		local playerPed = PlayerPedId()
		IsHandcuffed = false

		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
		FreezeEntityPosition(playerPed, false)
		DisplayRadar(true)

		-- end timer
		if Config.EnableHandcuffTimer and HandcuffTimer then
			ESX.ClearTimeout(HandcuffTimer)
		end
	end
end)

RegisterNetEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(copId)
	if not IsHandcuffed then
		return
	end

	dragStatus.isDragged = not dragStatus.isDragged
	dragStatus.CopId = copId
end)

Citizen.CreateThread(function()
	local playerPed
	local targetPed

	while true do
		Citizen.Wait(1)

		if IsHandcuffed then
			playerPed = PlayerPedId()

			if dragStatus.isDragged then
				targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))

				-- undrag if target is in an vehicle
				if not IsPedSittingInAnyVehicle(targetPed) then
					AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
				else
					dragStatus.isDragged = false
					DetachEntity(playerPed, true, false)
				end

				if IsPedDeadOrDying(targetPed, true) then
					dragStatus.isDragged = false
					DetachEntity(playerPed, true, false)
				end

			else
				DetachEntity(playerPed, true, false)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	if not IsHandcuffed then
		return
	end

	if IsAnyVehicleNearPoint(coords, 5.0) then
		local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

		if DoesEntityExist(vehicle) then
			local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
				dragStatus.isDragged = false
			end
		end
	end
end)

RegisterNetEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function()
	local playerPed = PlayerPedId()

	if not IsPedSittingInAnyVehicle(playerPed) then
		return
	end

	local vehicle = GetVehiclePedIsIn(playerPed, false)
	TaskLeaveVehicle(playerPed, vehicle, 16)
end)

-- Handcuff
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if IsHandcuffed then
			-- DisableControlAction(0, 1, true) -- Disable horizontal cam
			-- DisableControlAction(0, 2, true) -- Disable vertical cam
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1
			--DisableControlAction(0, 32, true) -- W
			--DisableControlAction(0, 34, true) -- A
			--DisableControlAction(0, 31, true) -- S
			--DisableControlAction(0, 30, true) -- D

			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 23, true) -- Also 'enter'?

			DisableControlAction(0, 288,  true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job

			-- DisableControlAction(0, 0, true) -- Disable changing view
			-- DisableControlAction(0, 26, true) -- Disable looking behind
			DisableControlAction(0, 73, true) -- Disable clearing animation
			-- DisableControlAction(2, 199, true) -- Disable pause screen

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, 36, true) -- Disable going stealth

			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle

			if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
				end)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

-- Create blips
Citizen.CreateThread(function()

	for k,v in pairs(Config.PoliceStations) do
		local blip = AddBlipForCoord(v.Blip.Coords)

		SetBlipSprite (blip, v.Blip.Sprite)
		SetBlipDisplay(blip, v.Blip.Display)
		SetBlipScale  (blip, v.Blip.Scale)
		SetBlipColour (blip, v.Blip.Colour)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('map_blip'))
		EndTextCommandSetBlipName(blip)
	end

end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if PlayerData.job and PlayerData.job.name == 'police' then

			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)
			local isInMarker, hasExited, letSleep = false, false, true
			local currentStation, currentPart, currentPartNum

			for k,v in pairs(Config.PoliceStations) do

				for i=1, #v.Cloakrooms, 1 do
					local distance = GetDistanceBetweenCoords(coords, v.Cloakrooms[i], true)

					if distance < Config.DrawDistance then
						DrawMarker(20, v.Cloakrooms[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
						letSleep = false
					end

					if distance < Config.MarkerSize.x then
						isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Cloakroom', i
					end
				end

				for i=1, #v.Armories, 1 do
					local distance = GetDistanceBetweenCoords(coords, v.Armories[i], true)

					if distance < Config.DrawDistance then
						DrawMarker(21, v.Armories[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
						letSleep = false
					end

					if distance < Config.MarkerSize.x then
						isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Armory', i
					end
				end

				-- for i=1, #v.Vehicles, 1 do
				if v.SocietyGarage then
					local distance = GetDistanceBetweenCoords(coords, v.SocietyGarage.Spawner, true)

					if distance < Config.DrawDistance then
						DrawMarker(36, v.SocietyGarage.Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
						letSleep = false
					end

					if distance < Config.MarkerSize.x then
						isInMarker, currentStation, currentPart, currentPartNum = true, k, 'SocietyGarage', i
					end
				end

				-- for i=1, #v.VehiclesDelete, 1 do
				-- 	local distance = GetDistanceBetweenCoords(coords, v.VehiclesDelete[i], true)

				-- 	if distance < Config.DrawDistance then
				-- 		DrawMarker(21, v.VehiclesDelete[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
				-- 		letSleep = false
				-- 	end

				-- 	if distance < Config.MarkerSize.x then
				-- 		isInMarker, currentStation, currentPart, currentPartNum = true, k, 'delete_vehicle', i
				-- 	end
				-- end


				-- for i=1, #v.Helicopters, 1 do
				if v.SocietyHeliGarage then
					local distance =  GetDistanceBetweenCoords(coords, v.SocietyHeliGarage.Spawner, true)

					if distance < Config.DrawDistance then
						DrawMarker(34, v.SocietyHeliGarage.Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
						letSleep = false
					end

					if distance < Config.MarkerSize.x then
						isInMarker, currentStation, currentPart, currentPartNum = true, k, 'SocietyHeliGarage', i
					end
				end

				if Config.EnablePlayerManagement and PlayerData.job.grade_name == 'boss' then
					for i=1, #v.BossActions, 1 do
						local distance = GetDistanceBetweenCoords(coords, v.BossActions[i], true)

						if distance < Config.DrawDistance then
							DrawMarker(22, v.BossActions[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
							letSleep = false
						end

						if distance < Config.MarkerSize.x then
							isInMarker, currentStation, currentPart, currentPartNum = true, k, 'BossActions', i
						end
					end
				end
			end

			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
				if
					(LastStation and LastPart and LastPartNum) and
					(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
				then
					TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
					hasExited = true
				end

				HasAlreadyEnteredMarker = true
				LastStation             = currentStation
				LastPart                = currentPart
				LastPartNum             = currentPartNum

				TriggerEvent('esx_policejob:hasEnteredMarker', currentStation, currentPart, currentPartNum)
			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
			end

			if letSleep then
				Citizen.Wait(500)
			end

		else
			Citizen.Wait(500)
		end
	end
end)

-- Enter / Exit entity zone events
Citizen.CreateThread(function()
	local trackedEntities = {
		'prop_roadcone02a',
		'prop_barrier_work05',
		'p_ld_stinger_s',
		'prop_boxpile_07d',
		'hei_prop_cash_crate_half_full'
	}

	while true do
		Citizen.Wait(500)

		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		local closestDistance = -1
		local closestEntity   = nil

		for i=1, #trackedEntities, 1 do
			local object = GetClosestObjectOfType(coords, 3.0, GetHashKey(trackedEntities[i]), false, false, false)

			if DoesEntityExist(object) then
				local objCoords = GetEntityCoords(object)
				local distance  = GetDistanceBetweenCoords(coords, objCoords, true)

				if closestDistance == -1 or closestDistance > distance then
					closestDistance = distance
					closestEntity   = object
				end
			end
		end

		if closestDistance ~= -1 and closestDistance <= 3.0 then
			if LastEntity ~= closestEntity then
				TriggerEvent('esx_policejob:hasEnteredEntityZone', closestEntity)
				LastEntity = closestEntity
			end
		else
			if LastEntity then
				TriggerEvent('esx_policejob:hasExitedEntityZone', LastEntity)
				LastEntity = nil
			end
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) and PlayerData.job and PlayerData.job.name == 'police' then

				if CurrentAction == 'menu_cloakroom' then
					OpenCloakroomMenu()
				elseif CurrentAction == 'menu_armory' then
					if Config.MaxInService == -1 then
						OpenArmoryMenu(CurrentActionData.station)
					elseif playerInService then
						OpenArmoryMenu(CurrentActionData.station)
					else
						ESX.ShowNotification(_U('service_not'))
					end
				elseif CurrentAction == 'menu_vehicle_spawner' then
					-- if Config.MaxInService == -1 then
					-- 	-- OpenVehicleSpawnerMenu('car', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
						TriggerEvent('esx_ava_garage:OpenSocietyVehiclesMenu', "society_police", Config.PoliceStations[CurrentActionData.station].SocietyGarage)
					-- elseif playerInService then
					-- 	-- OpenVehicleSpawnerMenu('car', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
					-- 	TriggerEvent('eden_garage:ListSocietyVehiclesMenu', "society_police", Config.PoliceStations[CurrentActionData.station].SocietyGarage)
					-- else
					-- 	ESX.ShowNotification(_U('service_not'))
					-- end
				elseif CurrentAction == 'menu_heli_spawner' then
					TriggerEvent('esx_ava_garage:OpenSocietyVehiclesMenu', "society_police", Config.PoliceStations[CurrentActionData.station].SocietyHeliGarage)
					-- if Config.MaxInService == -1 then
					-- 	OpenVehicleSpawnerMenu('helicopter', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
					-- elseif playerInService then
					-- 	OpenVehicleSpawnerMenu('helicopter', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
					-- else
					-- 	ESX.ShowNotification(_U('service_not'))
					-- end
				elseif CurrentAction == 'delete_vehicle' then
					-- ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
					TriggerEvent('eden_garage:StockSocietyVehicleMenu', "society_police")

				elseif CurrentAction == 'menu_boss_actions' then
					ESX.UI.Menu.CloseAll()
					TriggerEvent('esx_society:openBossMenu', 'police', function(data, menu)
						menu.close()

						CurrentAction     = 'menu_boss_actions'
						CurrentActionMsg  = _U('open_bossmenu')
						CurrentActionData = {}
					end, { wash = false, withdrawDirty = true, depositDirty = true }) -- disable washing money
				elseif CurrentAction == 'remove_entity' then
					DeleteEntity(CurrentActionData.entity)
				end

				CurrentAction = nil
			end
		end -- CurrentAction end

		if IsControlJustReleased(0, 167) and not isDead and PlayerData.job and PlayerData.job.name == 'police' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'police_actions') then
			if Config.MaxInService == -1 then
				OpenPoliceActionsMenu()
			elseif playerInService then
				OpenPoliceActionsMenu()
			else
				ESX.ShowNotification(_U('service_not'))
			end
		end

		if IsControlJustReleased(0, 38) and currentTask.busy then
			ESX.ShowNotification(_U('impound_canceled'))
			ESX.ClearTimeout(currentTask.task)
			ClearPedTasks(PlayerPedId())

			currentTask.busy = false
		end
	end
end)

-- Create blip for colleagues
function createBlip(id)
	local ped = GetPlayerPed(id)
	local blip = GetBlipFromEntity(ped)

	if not DoesBlipExist(blip) then -- Add blip and create head display on player
		blip = AddBlipForEntity(ped)
		SetBlipSprite(blip, 1)
		ShowHeadingIndicatorOnBlip(blip, true) -- Player Blip indicator
		SetBlipRotation(blip, math.ceil(GetEntityHeading(ped))) -- update rotation
		SetBlipNameToPlayerName(blip, id) -- update blip name
		SetBlipScale(blip, 0.85) -- set scale
		SetBlipAsShortRange(blip, true)

		table.insert(blipsCops, blip) -- add blip to array so we can remove it later
	end
end

function refreshPlayerWhitelisted()
	if not ESX.PlayerData then
		return false
	end

	if not ESX.PlayerData.job then
		return false
	end

	for k,v in ipairs(Config.WhitelistedCops) do
		if v == ESX.PlayerData.job.name then
			return true
		end
	end

	return false
end

--RegisterNetEvent('esx_renfort:blip')
--AddEventHandler('esx_renfort:blip', function(coords)
--	print(coords)
--	--local ped = GetPlayerPed(id)
--	local alpha = 2500
--	--local blip = GetBlipFromEntity(ped)
--	local blipsRenfort = AddBlipForCoord(coords.x, coords.y, coords.z)
--
--
--	SetBlipSprite(blipsRenfort, 161)
--	SetBlipScale(blipsRenfort, 2.0) -- set scale
--	--SetBlipName(blipsRenfort, 'Demande de renfort')
--	SetBlipColour(blipsRenfort, 2)
--	SetBlipAlpha(blipsRenfort, alpha)
--
--	BeginTextCommandSetBlipName("STRING")
--	AddTextComponentString(('Demande renfort'))
--	EndTextCommandSetBlipName(blipsRenfort)
--	
--	while alpha ~= 0 do
--		Citizen.Wait(10)
--		alpha = alpha - 1
--		SetBlipAlpha(blipsRenfort, alpha)
--
--		if alpha == 0 then
--			RemoveBlip(blipsRenfort)
--			return
--		end
--	end
--end)
RegisterNetEvent('renfort:setBlip')
AddEventHandler('renfort:setBlip', function(coords, raison)
	if raison == 'petit' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)
		ESX.ShowAdvancedNotification('LSPD INFORMATIONS', '~b~Demande de renfort', 'Demande de renfort demandé.\nRéponse: ~g~CODE-2\n~w~Importance: ~g~Légère.', 'CHAR_CALL911', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
		color = 2
	elseif raison == 'importante' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)
		ESX.ShowAdvancedNotification('LSPD INFORMATIONS', '~b~Demande de renfort', 'Demande de renfort demandé.\nRéponse: ~g~CODE-3\n~w~Importance: ~o~Importante.', 'CHAR_CALL911', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
		color = 47
	elseif raison == 'omgad' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)
		PlaySoundFrontend(-1, "FocusIn", "HintCamSounds", 1)
		ESX.ShowAdvancedNotification('LSPD INFORMATIONS', '~b~Demande de renfort', 'Demande de renfort demandé.\nRéponse: ~g~CODE-99\n~w~Importance: ~r~URGENTE !\nDANGER IMPORTANT', 'CHAR_CALL911', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
		PlaySoundFrontend(-1, "FocusOut", "HintCamSounds", 1)
		color = 1
	end
	local blipId = AddBlipForCoord(coords)
	SetBlipSprite(blipId, 161)
	SetBlipScale(blipId, 1.2)
	SetBlipColour(blipId, color)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Demande renfort')
	EndTextCommandSetBlipName(blipId)
	Wait(80 * 1000)
	RemoveBlip(blipId)
end)

RegisterNetEvent('police:InfoService')
AddEventHandler('police:InfoService', function(service, nom)
	if service == 'prise' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('LSPD INFORMATIONS', '~b~Prise de service', 'Agent: ~g~'..nom..'\n~w~Code: ~g~10-8\n~w~Information: ~g~Prise de service.', 'CHAR_CALL911', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'fin' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('LSPD INFORMATIONS', '~b~Fin de service', 'Agent: ~g~'..nom..'\n~w~Code: ~g~10-10\n~w~Information: ~g~Fin de service.', 'CHAR_CALL911', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'pause' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('LSPD INFORMATIONS', '~b~Pause de service', 'Agent: ~g~'..nom..'\n~w~Code: ~g~10-6\n~w~Information: ~g~Pause de service.', 'CHAR_CALL911', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'standby' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('LSPD INFORMATIONS', '~b~Mise en standby', 'Agent: ~g~'..nom..'\n~w~Code: ~g~10-12\n~w~Information: ~g~Standby, en attente de dispatch.', 'CHAR_CALL911', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'control' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('LSPD INFORMATIONS', '~b~Control routier', 'Agent: ~g~'..nom..'\n~w~Code: ~g~10-48\n~w~Information: ~g~Control routier en cours.', 'CHAR_CALL911', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'refus' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('LSPD INFORMATIONS', '~b~Refus d\'obtempérer', 'Agent: ~g~'..nom..'\n~w~Code: ~g~10-30\n~w~Information: ~g~Refus d\'obtempérer / Délit de fuite en cours.', 'CHAR_CALL911', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	elseif service == 'arrestation' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('LSPD INFORMATIONS', '~b~Arrestation en cours', 'Agent: ~g~'..nom..'\n~w~Code: ~g~10-31\n~w~Information: ~g~Arrestation en cours.', 'CHAR_CALL911', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
	end
end)

--function createBlipRenfort(coords)
--	if isPlayerWhitelisted then
--		print(coords)
--		--local ped = GetPlayerPed(id)
--		local alpha = 2500
--		--local blip = GetBlipFromEntity(ped)
--		local blipsRenfort = AddBlipForCoord(coords.x, coords.y, coords.z)
--
--
--		SetBlipSprite(blipsRenfort, 161)
--		SetBlipScale(blipsRenfort, 2.0) -- set scale
--		--SetBlipName(blipsRenfort, 'Demande de renfort')
--		SetBlipColour(blipsRenfort, 2)
--		SetBlipAlpha(blipsRenfort, alpha)
--		
--		while alpha ~= 0 do
--			Citizen.Wait(10)
--			alpha = alpha - 1
--			SetBlipAlpha(blipsRenfort, alpha)
--
--			if alpha == 0 then
--				RemoveBlip(blipsRenfort)
--				return
--			end
--		end
--	end
--
--end

RegisterNetEvent('esx_policejob:updateBlip')
AddEventHandler('esx_policejob:updateBlip', function()

	-- Refresh all blips
	for k, existingBlip in pairs(blipsCops) do
		RemoveBlip(existingBlip)
	end

	-- Clean the blip table
	blipsCops = {}

	-- Enable blip?
	if Config.MaxInService ~= -1 and not playerInService then
		return
	end

	if not Config.EnableJobBlip then
		return
	end

	-- Is the player a cop? In that case show all the blips for other cops
	if PlayerData.job and PlayerData.job.name == 'police' then
		ESX.TriggerServerCallback('esx_society:getOnlinePlayers', function(players)
			for i=1, #players, 1 do
				if players[i].job.name == 'police' then
					local id = GetPlayerFromServerId(players[i].source)
					if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= PlayerPedId() then
						createBlip(id)
					end
				end
			end
		end)
	end

end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
	TriggerEvent('esx_policejob:unrestrain')

	if not hasAlreadyJoined then
		TriggerServerEvent('esx_policejob:spawned')
	end
	hasAlreadyJoined = true
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_policejob:unrestrain')
		TriggerEvent('esx_phone:removeSpecialContact', 'police')

		if Config.MaxInService ~= -1 then
			TriggerServerEvent('esx_service:disableService', 'police')
		end

		if Config.EnableHandcuffTimer and handcuffTimer.active then
			ESX.ClearTimeout(handcuffTimer.task)
		end
	end
end)

-- handcuff timer, unrestrain the player after an certain amount of time
function StartHandcuffTimer()
	if Config.EnableHandcuffTimer and handcuffTimer.active then
		ESX.ClearTimeout(handcuffTimer.task)
	end

	handcuffTimer.active = true

	handcuffTimer.task = ESX.SetTimeout(Config.handcuffTimer, function()
		ESX.ShowNotification(_U('unrestrained_timer'))
		TriggerEvent('esx_policejob:unrestrain')
		handcuffTimer.active = false
	end)
end

-- TODO
--   - return to garage if owned
--   - message owner that his vehicle has been impounded
function ImpoundVehicle(vehicle)
	local playerPed = PlayerPedId()
	local vehicle   = ESX.Game.GetVehicleInDirection()
	if IsPedInAnyVehicle(playerPed, true) then
	    vehicle = GetVehiclePedIsIn(playerPed, false)
	end
	local entity = vehicle
	carModel = GetEntityModel(entity)
	carName = GetDisplayNameFromVehicleModel(carModel)
	NetworkRequestControlOfEntity(entity)
	
	local timeout = 2000
	while timeout > 0 and not NetworkHasControlOfEntity(entity) do
	    Wait(100)
	    timeout = timeout - 100
	end
 
	SetEntityAsMissionEntity(entity, true, true)
	
	local timeout = 2000
	while timeout > 0 and not IsEntityAMissionEntity(entity) do
	    Wait(100)
	    timeout = timeout - 100
	end
 
	Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
	
	if (DoesEntityExist(entity)) then 
	    DeleteEntity(entity)
	end 
	ESX.ShowNotification(_U('impound_successful'))
	currentTask.busy = false
end




-- Nouvelle menotte 

function loadanimdict(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname) 
		while not HasAnimDictLoaded(dictname) do 
			Citizen.Wait(1)
		end
		RemoveAnimDict(dictname)
	end
end


RegisterNetEvent('esx_policejob:getarrested')
AddEventHandler('esx_policejob:getarrested', function(playerheading, playercoords, playerlocation)
	playerPed = GetPlayerPed(-1)
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	SetEntityHeading(GetPlayerPed(-1), playerheading)
	Citizen.Wait(250)
	loadanimdict('mp_arrest_paired')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
	Citizen.Wait(3760)
	cuffed = true
	loadanimdict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
end)

RegisterNetEvent('esx_policejob:doarrested')
AddEventHandler('esx_policejob:doarrested', function()
	Citizen.Wait(250)
	loadanimdict('mp_arrest_paired')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)
	Citizen.Wait(3000)

end) 

RegisterNetEvent('esx_policejob:douncuffing')
AddEventHandler('esx_policejob:douncuffing', function()
	Citizen.Wait(250)
	loadanimdict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent('esx_policejob:getuncuffed')
AddEventHandler('esx_policejob:getuncuffed', function(playerheading, playercoords, playerlocation)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	z = z - 1.0
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	SetEntityHeading(GetPlayerPed(-1), playerheading)
	Citizen.Wait(250)
	loadanimdict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	cuffed = false
	ClearPedTasks(GetPlayerPed(-1))
end)
