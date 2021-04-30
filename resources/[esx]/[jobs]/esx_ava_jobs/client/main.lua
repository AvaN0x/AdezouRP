-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX = nil
local GUI = {
    Time = 0
}
local PlayerData = {}
local playerJobs = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil or ESX.GetPlayerData().job2 == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
    setJobsToUse()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
    setJobsToUse()
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	PlayerData.job2 = job2
    setJobsToUse()
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
        -- if plants then
        --     for k, v in pairs(plants) do
        --         ESX.Game.DeleteObject(v.obj)
        --     end
        -- end
        deleteBlips()
	end
end)

function setJobsToUse()
    playerJobs = {}
    if Config.Jobs[PlayerData.job.name] ~= nil then
        playerJobs[PlayerData.job.name] = Config.Jobs[PlayerData.job.name]
    end
    if Config.Jobs[PlayerData.job2.name] ~= nil then
        playerJobs[PlayerData.job2.name] = Config.Jobs[PlayerData.job2.name]
    end
    -- deleteBlips()
	-- blips()
end





local HasAlreadyEnteredMarker = false
local LastZone = nil
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}
local JobBlips = {}
local publicBlip = false


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
        for jobName, job in pairs(playerJobs) do
            print(jobName .. " : " .. job.SocietyName)
        end
    end
end)

-- function OpenCloakroomMenu()
-- 	ESX.UI.Menu.CloseAll()

-- 	ESX.UI.Menu.Open(
-- 		'default', GetCurrentResourceName(), 'cloakroom',
-- 		{
-- 			title    = _U('cloakroom'),
-- 			align    = 'left',
-- 			css 	 = 'vestiaire',
-- 			elements = {
-- 				{label = _U('vine_clothes_civil'), value = 'citizen_wear'},
-- 				{label = _U('vine_clothes_vine'), value = 'job_wear'}
-- 			},
-- 		},
-- 		function(data, menu)

-- 			menu.close()

-- 			if data.current.value == 'citizen_wear' then
-- 				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
-- 					TriggerEvent('skinchanger:loadSkin', skin)
-- 				end)
-- 			end

-- 			if data.current.value == 'job_wear' then
-- 				if (PlayerData.job ~= nil and PlayerData.job.name == Config.JobName) then
-- 					ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
-- 						if skin.sex == 0 then
-- 							TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
-- 						else
-- 							TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
-- 						end
-- 					end)
-- 				elseif (PlayerData.job2 ~= nil and PlayerData.job2.name == Config.JobName) then
-- 					ESX.TriggerServerCallback('esx_skin:getPlayerSkin2', function(skin, job2Skin)
-- 						if skin.sex == 0 then
-- 							TriggerEvent('skinchanger:loadClothes', skin, job2Skin.skin_male)
-- 						else
-- 							TriggerEvent('skinchanger:loadClothes', skin, job2Skin.skin_female)
-- 						end
-- 					end)
-- 				end
-- 			end

-- 		end,
-- 		function(data, menu)
-- 			menu.close()
-- 		end
-- 	)

-- end

-- function OpenJobActionsMenu()

-- 	local elements = {
-- 		{label = _U('deposit_stock'), value = 'put_stock'},
-- 		{label = _U('take_stock'), value = 'get_stock'}
-- 	}
  
-- 	if (PlayerData.job ~= nil and PlayerData.job.name == Config.JobName and (PlayerData.job.grade_name == 'boss')) 
-- 	or (PlayerData.job2 ~= nil and PlayerData.job2.name == Config.JobName and (PlayerData.job2.grade_name == 'boss')) then
-- 		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
-- 	end

-- 	ESX.UI.Menu.CloseAll()

-- 	ESX.UI.Menu.Open(
-- 		'default', GetCurrentResourceName(), 'job_actions',
-- 		{
-- 			title    = Config.LabelName,
-- 			align    = 'left',
-- 			css 	 = 'job',
-- 			elements = elements
-- 		},
		
-- 		function(data, menu)
-- 			if data.current.value == 'put_stock' then
-- 				OpenPutStocksMenu()
-- 			elseif data.current.value == 'get_stock' then
-- 				OpenGetStocksMenu()
-- 			elseif data.current.value == 'boss_actions' then
-- 				TriggerEvent('esx_society:openBossMenu', Config.JobName, function(data, menu)
-- 					menu.close()
-- 				end, {wash = false})
-- 			end

-- 		end,
-- 		function(data, menu)

-- 			menu.close()

-- 			CurrentAction     = 'job_actions_menu'
-- 			CurrentActionMsg  = _U('press_to_open')
-- 			CurrentActionData = {}

-- 		end
-- 	)
-- end


-- function OpenGetStocksMenu()

-- 	ESX.TriggerServerCallback('esx_ava_vigneronjob:getStockItems', function(items)

-- 		print(json.encode(items))

-- 		local elements = {}

-- 		for i=1, #items, 1 do
-- 			if (items[i].count ~= 0) then
-- 				table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
-- 			end
-- 		end

-- 		ESX.UI.Menu.Open(
-- 			'default', GetCurrentResourceName(), 'stocks_menu',
-- 			{
-- 				title    = Config.LabelName..' Stock',
-- 				align    = 'left',
-- 				css 	 = 'job',
-- 				elements = elements
-- 			},
-- 			function(data, menu)

-- 				local itemName = data.current.value

-- 				ESX.UI.Menu.Open(
-- 					'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
-- 					{
-- 						title = _U('quantity')
-- 					},
-- 					function(data2, menu2)
		
-- 						local count = tonumber(data2.value)

-- 						if count == nil or count <= 0 then
-- 							ESX.ShowNotification(_U('quantity_invalid'))
-- 						else
-- 							menu2.close()
-- 							menu.close()
-- 							OpenGetStocksMenu()

-- 							TriggerServerEvent('esx_ava_vigneronjob:getStockItem', itemName, count)
-- 						end

-- 					end,
-- 					function(data2, menu2)
-- 						menu2.close()
-- 					end
-- 				)

-- 			end,
-- 			function(data, menu)
-- 				menu.close()
-- 			end
-- 		)
-- 	end)
-- end

-- function OpenPutStocksMenu()

-- 	ESX.TriggerServerCallback('esx_ava_vigneronjob:getPlayerInventory', function(inventory)

-- 		local elements = {}

-- 		for i=1, #inventory.items, 1 do

-- 			local item = inventory.items[i]

-- 			if item.count > 0 then
-- 				table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
-- 			end

-- 		end

-- 		ESX.UI.Menu.Open(
-- 			'default', GetCurrentResourceName(), 'stocks_menu',
-- 			{
-- 				title    = _U('inventory'),
-- 				elements = elements
-- 			},
-- 			function(data, menu)

-- 				local itemName = data.current.value

-- 				ESX.UI.Menu.Open(
-- 					'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
-- 					{
-- 						title = _U('quantity')
-- 					},
-- 					function(data2, menu2)

-- 						local count = tonumber(data2.value)

-- 						if count == nil or count <= 0 then
-- 							ESX.ShowNotification(_U('quantity_invalid'))
-- 						else
-- 							menu2.close()
-- 							menu.close()
-- 							OpenPutStocksMenu()

-- 							TriggerServerEvent('esx_ava_vigneronjob:putStockItems', itemName, count)
-- 						end

-- 					end,
-- 					function(data2, menu2)
-- 						menu2.close()
-- 					end
-- 				)

-- 			end,
-- 			function(data, menu)
-- 				menu.close()
-- 			end
-- 		)

-- 	end)

-- end




-- AddEventHandler('esx_ava_vigneronjob:hasEnteredMarker', function(zone)
-- 	if (PlayerData.job ~= nil and PlayerData.job.name == Config.JobName) or (PlayerData.job2 ~= nil and PlayerData.job2.name == Config.JobName) then
-- 		if (zone == 'JobActions' 
-- 		and ((PlayerData.job ~= nil and PlayerData.job.name == Config.JobName and PlayerData.job.grade_name ~= 'interim') 
-- 		or (PlayerData.job2 ~= nil and PlayerData.job2.name == Config.JobName and PlayerData.job2.grade_name ~= 'interim'))) then
-- 			-- interim can't access this menu
-- 			CurrentAction     = 'job_actions_menu'
-- 			CurrentActionMsg  = _U('press_to_open')
-- 			CurrentActionData = {}

-- 		elseif zone == 'Dressing' then
-- 			CurrentAction     = 'dressing'
-- 			CurrentActionMsg  = _U('press_to_open')
-- 			CurrentActionData = {}

-- 		elseif zone == 'SocietyGarage' then
-- 			CurrentAction     = 'vehicle_spawner_menu'
-- 			CurrentActionMsg  = _U('spawn_veh')
-- 			CurrentActionData = {}
-- 		end
-- 	end
-- end)

-- AddEventHandler('esx_ava_vigneronjob:hasExitedMarker', function(zone)
-- 	ESX.UI.Menu.CloseAll()
-- 	CurrentAction = nil
-- end)


-- function deleteBlips()
-- 	if JobBlips[1] ~= nil then
-- 		for i=1, #JobBlips, 1 do
-- 		RemoveBlip(JobBlips[i])
-- 		JobBlips[i] = nil
-- 		end
-- 	end
-- end

-- local function addJobBlip(v)
-- 	local blip2 = AddBlipForCoord(v.Pos.x, v.Pos.y, v.Pos.z)

-- 	SetBlipSprite (blip2, Config.Blip.Sprite)
-- 	SetBlipDisplay(blip2, 4)
-- 	SetBlipScale  (blip2, 0.7)
-- 	SetBlipColour (blip2, Config.Blip.Colour)
-- 	SetBlipAsShortRange(blip2, true)

-- 	BeginTextCommandSetBlipName("STRING")
-- 	AddTextComponentString('~c~'..v.Name)
-- 	EndTextCommandSetBlipName(blip2)
-- 	table.insert(JobBlips, blip2)
-- end

-- -- Create Blips
-- function blips()
-- 	if publicBlip == false then
-- 		local blip = AddBlipForCoord(Config.Zones.JobActions.Pos.x, Config.Zones.JobActions.Pos.y, Config.Zones.JobActions.Pos.z)
-- 		SetBlipSprite (blip, Config.Blip.Sprite)
-- 		SetBlipDisplay(blip, 4)
-- 		SetBlipScale  (blip, 1.0)
-- 		SetBlipColour (blip, Config.Blip.Colour)
-- 		SetBlipAsShortRange(blip, true)

-- 		BeginTextCommandSetBlipName("STRING")
-- 		AddTextComponentString(Config.LabelName)
-- 		EndTextCommandSetBlipName(blip)
-- 		publicBlip = true
-- 	end
	
--     if (PlayerData.job ~= nil and PlayerData.job.name == Config.JobName) or (PlayerData.job2 ~= nil and PlayerData.job2.name == Config.JobName) then

-- 		for k,v in pairs(Config.Zones)do
-- 			if v.Blip then
-- 				addJobBlip(v)
-- 			end
-- 		end
-- 		for k,v in pairs(Config.FieldZones)do
-- 			if v.Blip then
-- 				addJobBlip(v)
-- 			end
-- 		end
-- 		for k,v in pairs(Config.ProcessZones)do
-- 			if v.Blip then
-- 				addJobBlip(v)
-- 			end
-- 		end
-- 		for k,v in pairs(Config.ProcessMenuZones)do
-- 			if v.Blip then
-- 				addJobBlip(v)
-- 			end
-- 		end
-- 		for k,v in pairs(Config.SellZones)do
-- 			if v.Blip then
-- 				addJobBlip(v)
-- 			end
-- 		end
-- 		for k,v in pairs(Config.BuyZones)do
-- 			if v.Blip then
-- 				addJobBlip(v)
-- 			end
-- 		end

		
-- 	end
-- end


-- -- Display markers
-- Citizen.CreateThread(function()
-- 	while true do
-- 		Wait(0)
-- 		local coords = GetEntityCoords(GetPlayerPed(-1))

-- 		if (PlayerData.job ~= nil and PlayerData.job.name == Config.JobName) or (PlayerData.job2 ~= nil and PlayerData.job2.name == Config.JobName) then
-- 			for k,v in pairs(Config.Zones) do
-- 				if(v.Marker ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
-- 					if (k ~= 'JobActions' or (PlayerData.job == nil or PlayerData.job.name ~= Config.JobName or PlayerData.job.grade_name ~= 'interim') and (PlayerData.job2 == nil or PlayerData.job2.name ~= Config.JobName or PlayerData.job.grade_name ~= 'interim')) then
-- 						DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
-- 					end
-- 				end
-- 			end
-- 			for k,v in pairs(Config.ProcessZones) do
-- 				if(v.Marker ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
-- 					DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
-- 				end
-- 			end
-- 			for k,v in pairs(Config.ProcessMenuZones) do
-- 				if(v.Marker ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
-- 					DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
-- 				end
-- 			end
-- 			for k,v in pairs(Config.SellZones) do
-- 				if(v.Marker ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
-- 					DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
-- 				end
-- 			end
-- 			for k,v in pairs(Config.BuyZones) do
-- 				if(v.Marker ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
-- 					DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
-- 				end
-- 			end

-- 		end
-- 	end
-- end)


-- -- Enter / Exit marker events
-- Citizen.CreateThread(function()
-- 	while true do

-- 		Wait(0)

-- 		if (PlayerData.job ~= nil and PlayerData.job.name == Config.JobName) or (PlayerData.job2 ~= nil and PlayerData.job2.name == Config.JobName) then

-- 			local coords      = GetEntityCoords(GetPlayerPed(-1))
-- 			local isInMarker  = false
-- 			local currentZone = nil

-- 			for k,v in pairs(Config.Zones) do
-- 				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
-- 					isInMarker  = true
-- 					currentZone = k
-- 				end
-- 			end

-- 			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
-- 				HasAlreadyEnteredMarker = true
-- 				LastZone                = currentZone
-- 				TriggerEvent('esx_ava_vigneronjob:hasEnteredMarker', currentZone)
-- 			end

-- 			if not isInMarker and HasAlreadyEnteredMarker then
-- 				HasAlreadyEnteredMarker = false
-- 				TriggerEvent('esx_ava_vigneronjob:hasExitedMarker', LastZone)
-- 			end
-- 		end
-- 	end
-- end)

-- -- Key Controls
-- Citizen.CreateThread(function()
-- 	while true do

-- 		Citizen.Wait(0)

-- 		if CurrentAction ~= nil then

-- 			SetTextComponentFormat('STRING')
-- 			AddTextComponentString(CurrentActionMsg)
-- 			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

-- 			if IsControlPressed(0,  Keys['E']) 
-- 			and ((PlayerData.job ~= nil and PlayerData.job.name == Config.JobName) 
-- 			or (PlayerData.job2 ~= nil and PlayerData.job2.name == Config.JobName)) 
-- 			and (GetGameTimer() - GUI.Time) > 300 then
-- 				if CurrentAction == 'job_actions_menu' then
-- 					OpenJobActionsMenu()
-- 				elseif CurrentAction == 'dressing' then
-- 					OpenCloakroomMenu()
-- 				elseif CurrentAction == 'vehicle_spawner_menu' then
-- 					TriggerEvent('esx_ava_garage:OpenSocietyVehiclesMenu', Config.SocietyName, Config.Zones.SocietyGarage)
-- 				end

-- 				CurrentAction = nil
-- 				GUI.Time      = GetGameTimer()

-- 			end
-- 		end
-- 	end
-- end)








-- -------------
-- -- récolte --
-- -------------

-- local spawnedPlants = {}
-- local plants = {}
-- local isPickingUp = false

-- local function spawnedPlantsFindName(name)
-- 	for i=1, #spawnedPlants, 1 do
-- 		if spawnedPlants[i].name == name then
-- 			return i
-- 		end
-- 	end

-- 	return nil
-- end

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(10)
-- 		if (PlayerData.job ~= nil and PlayerData.job.name == Config.JobName) or (PlayerData.job2 ~= nil and PlayerData.job2.name == Config.JobName) then
-- 			local coords = GetEntityCoords(PlayerPedId())
-- 			for k,v in pairs(Config.FieldZones) do

-- 				if GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 20 then
-- 					Spawnplants(k, v)
-- 					Citizen.Wait(500)
-- 				else
-- 					Citizen.Wait(500)
-- 				end
-- 			end
-- 			-- for debug
-- 			-- for i=1, #spawnedPlants, 1 do
-- 			-- 	print(spawnedPlants[i].name ..' : '.. spawnedPlants[i].quantity)
-- 			-- end
-- 		else 
-- 			Citizen.Wait(10000)
-- 		end
-- 	end
-- end)

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(0)
-- 		if (PlayerData.job ~= nil and PlayerData.job.name == Config.JobName) or (PlayerData.job2 ~= nil and PlayerData.job2.name == Config.JobName) then

-- 			local playerPed = PlayerPedId()
-- 			local coords = GetEntityCoords(playerPed)
-- 			local nearbyObject, nearbyID

-- 			for i=1, #plants, 1 do
-- 				if GetDistanceBetweenCoords(coords, GetEntityCoords(plants[i].obj), false) < 1 then
-- 					nearbyObject, nearbyID = plants[i], i
-- 				end
-- 			end

-- 			if nearbyObject and nearbyObject.obj and IsPedOnFoot(playerPed) then

-- 				if not isPickingUp then
-- 					ESX.ShowHelpNotification(_U('press_collect'))
-- 				end

-- 				if IsControlJustReleased(0, Keys['E']) and not isPickingUp then
-- 					isPickingUp = true

-- 					ESX.TriggerServerCallback('esx_ava_vigneronjob:canPickUp', function(canPickUp)

-- 						if canPickUp then
-- 							TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)

-- 							Citizen.Wait(2000)
-- 							ClearPedTasks(playerPed)
			
-- 							ESX.Game.DeleteObject(nearbyObject.obj)
			
-- 							table.remove(plants, nearbyID)

-- 							local sPIndex = spawnedPlantsFindName(nearbyObject.name)
-- 							spawnedPlants[sPIndex].quantity = spawnedPlants[sPIndex].quantity - 1
-- 							for i=1, #nearbyObject.items, 1 do
-- 								TriggerServerEvent('esx_ava_vigneronjob:pickUp', nearbyObject.items[i])
-- 							end
-- 						else
-- 							ESX.ShowNotification(_U('inventoryfull'))
-- 						end

-- 						isPickingUp = false

-- 					end, nearbyObject.items)
-- 				end

-- 			else
-- 				Citizen.Wait(500)
-- 			end
-- 		else 
-- 			Citizen.Wait(10000)
-- 		end

-- 	end

-- end)

-- function Spawnplants(k, v)
-- 	local sPIndex = spawnedPlantsFindName(k)
-- 	if sPIndex == nil then
-- 		table.insert(spawnedPlants, {name = k, quantity = 0})
-- 		sPIndex = spawnedPlantsFindName(k)
-- 	end

-- 	while spawnedPlants[sPIndex].quantity < 5 do
-- 		Citizen.Wait(0)
-- 		local plantCoords = GeneratePlantCoords(k, v)

-- 		ESX.Game.SpawnLocalObject(v.Prop, plantCoords, function(obj)
-- 			PlaceObjectOnGroundProperly(obj)
-- 			FreezeEntityPosition(obj, true)

-- 			table.insert(plants, {obj = obj, items = v.Items, name = k})
-- 			spawnedPlants[sPIndex].quantity = spawnedPlants[sPIndex].quantity + 1
-- 		end)
-- 	end
-- end

-- function GeneratePlantCoords(k, v)
-- 	while true do
-- 		Citizen.Wait(1)

-- 		local plantCoordX, plantCoordY

-- 		math.randomseed(GetGameTimer())
-- 		local modX = math.random(-8, 8)

-- 		Citizen.Wait(100)

-- 		math.randomseed(GetGameTimer())
-- 		local modY = math.random(-8, 8)

-- 		plantCoordX = v.Pos.x + modX
-- 		plantCoordY = v.Pos.y + modY

-- 		local coordZ = GetCoordZ(plantCoordX, plantCoordY, v)
-- 		local coord = vector3(plantCoordX, plantCoordY, coordZ)

-- 		if ValidateplantCoord(coord, k, v) then
-- 			return coord
-- 		end
-- 	end
-- end

-- function ValidateplantCoord(plantCoord, k, v)
-- 	local sPIndex = spawnedPlantsFindName(k)
-- 	if spawnedPlants[sPIndex].quantity > 0 then
-- 		local validate = true

-- 		for k, v in pairs(plants) do
-- 			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v.obj), true) < 5 then
-- 				validate = false
-- 			end
-- 		end

-- 		if GetDistanceBetweenCoords(plantCoord, v.Pos.x, v.Pos.y, v.Pos.z, false) > 50 then
-- 			validate = false
-- 		end

-- 		return validate
-- 	else
-- 		return true
-- 	end
-- end

-- function GetCoordZ(x, y, v)
-- 	for i, height in ipairs(v.GroundCheckHeights) do
-- 		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

-- 		if foundGround then
-- 			return z
-- 		end
-- 	end

-- 	return v.Pos.z
-- end






-- ----------------
-- -- TRAITEMENT --
-- ----------------

-- local isProcessing = false

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(0)
-- 		local playerPed = PlayerPedId()
-- 		if (PlayerData.job ~= nil and PlayerData.job.name == Config.JobName) or (PlayerData.job2 ~= nil and PlayerData.job2.name == Config.JobName) then
-- 			local coords = GetEntityCoords(PlayerPedId())
-- 			local foundZone = false
-- 			for k,v in pairs(Config.ProcessZones) do
-- 				if GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 2 then
-- 					foundZone = true
-- 					if not v.NoInterim or 
-- 					(v.NoInterim and (PlayerData.job ~= nil and PlayerData.job.name == Config.JobName and PlayerData.job.grade_name ~= 'interim') 
-- 					or (PlayerData.job2 ~= nil and PlayerData.job2.name == Config.JobName and PlayerData.job2.grade_name ~= 'interim'))
-- 					then
-- 						if not isProcessing then
-- 							ESX.ShowHelpNotification(_U('press_traitement'))
-- 						end

-- 						if IsControlJustReleased(0, Keys['E']) and not isProcessing then
-- 							Process(v)
-- 						end
-- 					else
-- 						ESX.ShowHelpNotification(_U('no_interim'))
-- 					end
-- 				end
-- 			end
-- 			if not foundZone then
-- 				Citizen.Wait(500)
-- 			end
-- 		else 
-- 			Citizen.Wait(10000)
-- 		end
-- 	end
-- end)

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(0)
-- 		local playerPed = PlayerPedId()
-- 		if (PlayerData.job ~= nil and PlayerData.job.name == Config.JobName) or (PlayerData.job2 ~= nil and PlayerData.job2.name == Config.JobName) then
-- 			local coords = GetEntityCoords(PlayerPedId())
-- 			local foundZone = false
-- 			for k,v in pairs(Config.ProcessMenuZones) do
-- 				if GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 2 then
-- 					foundZone = true
-- 					if not isProcessing then
-- 						ESX.ShowHelpNotification(_U('press_traitement'))
-- 					end

-- 					if IsControlJustReleased(0, Keys['E']) and not isProcessing then
-- 						local elements = {}
-- 						for k2, v2 in pairs(v.Process) do
-- 							table.insert(elements, {label = v2.Name, delay = v2.Delay, value = v2})
-- 						end
-- 						ESX.UI.Menu.CloseAll()
-- 						isProcessing = true
-- 						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_process',{ title = v.Title, align = 'left', elements = elements },
-- 							function(data,menu) 
-- 								local count = false 
-- 								ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'how_much', {title = "Combien voulez-vous en traiter ? [Max : "..v.MaxProcess.."]"}, 
-- 									function(data2, menu2)
-- 										local quantity = tonumber(data2.value)
					
-- 										if quantity == nil or quantity < 1 or quantity > v.MaxProcess then
-- 											ESX.ShowNotification(_U('amount_invalid'))
-- 										else
-- 											count = quantity
-- 											menu2.close()
-- 										end
-- 									end, 
-- 									function(data2, menu2)
-- 										menu2.close()
-- 									end
-- 								)
-- 								while not count do 
-- 									Citizen.Wait(0); 
-- 								end
-- 								menu.close()

-- 								for i = 1, count, 1 do
-- 									Process(data.current.value)
-- 									Citizen.Wait(data.current.delay + 500)
-- 								end
-- 								ClearPedTasks(playerPed)

-- 								isProcessing = false
-- 								Citizen.Wait(1500)
-- 							end,
-- 							function(data,menu)
-- 								menu.close()
-- 								isProcessing = false
-- 							end
-- 						)
-- 					end
-- 				end
-- 			end
-- 			if not foundZone then
-- 				Citizen.Wait(500)
-- 			end
-- 		else 
-- 			Citizen.Wait(10000)
-- 		end
-- 	end
-- end)


-- function Process(v)
	
-- 	ESX.TriggerServerCallback('esx_ava_vigneronjob:canprocess', function(canProcess)
-- 		isProcessing = true
-- 		if canProcess then
-- 			TriggerServerEvent('esx_ava_vigneronjob:process', v)
-- 			local timeLeft = v.Delay / 1000
-- 			local playerPed = PlayerPedId()
		
-- 			exports['progressBars']:startUI(v.Delay, _U('process_in_progress'))
-- 			TaskStartScenarioInPlace(playerPed, v.Scenario, 0, false)
-- 			while timeLeft - 2 > 0 do
		
-- 				Citizen.Wait(1000)
-- 				timeLeft = timeLeft - 1
		
-- 				if GetDistanceBetweenCoords(GetEntityCoords(playerPed), v.Pos.x, v.Pos.y, v.Pos.z, false) > 2 then
-- 					TriggerServerEvent('esx_ava_vigneronjob:cancelProcessing')
-- 					break
-- 				end
-- 			end
-- 			Citizen.Wait(2000)
-- 			ClearPedTasks(playerPed)		
-- 		end
-- 		isProcessing = false
-- 	end, v)

-- end



-- -------------
-- -- selling --
-- -------------

-- local isSelling = false

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(0)
-- 		local playerPed = PlayerPedId()
-- 		if (PlayerData.job ~= nil and PlayerData.job.name == Config.JobName) or (PlayerData.job2 ~= nil and PlayerData.job2.name == Config.JobName) then
-- 			local coords = GetEntityCoords(PlayerPedId())
-- 			local foundZone = false
-- 			for k,v in pairs(Config.SellZones) do
-- 				if GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 2 then
-- 					foundZone = true
-- 					if not isSelling then
-- 						ESX.ShowHelpNotification(_U('press_sell'))
-- 					end

-- 					if IsControlJustReleased(0, Keys['E']) then
-- 						ESX.TriggerServerCallback('esx_ava_vigneronjob:GetSellElements', function(elements)
-- 							ESX.UI.Menu.CloseAll()
-- 							isSelling = true
-- 							ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_seller',{ title = "Acheteur "..Config.LabelName, align = 'left', elements = elements },
-- 								function(data,menu) 
-- 									local count = false 
-- 									ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'how_much', {title = "Combien voulez-vous vendre ? [Max : "..data.current.owned.."]"}, 
-- 										function(data2, menu2)
-- 											local quantity = tonumber(data2.value)
						
-- 											if quantity == nil then
-- 												ESX.ShowNotification(_U('amount_invalid'))
-- 											else
-- 												count = quantity
-- 												menu2.close()
-- 											end
-- 										end, 
-- 										function(data2, menu2)
-- 											menu2.close()
-- 										end
-- 									)
-- 									while not count do 
-- 										Citizen.Wait(0); 
-- 									end
-- 									if tonumber(count) > tonumber(data.current.owned) then 
-- 										ESX.ShowNotification("Tu n'as pas autant de "..data.current.itemLabel..".")
-- 									else 
-- 										TriggerServerEvent('esx_ava_vigneronjob:SellItems',data.current.name,data.current.price,count)
-- 										menu.close()
-- 										isSelling = false
-- 										Citizen.Wait(1500)
-- 									end
-- 								end,
-- 								function(data,menu)
-- 									menu.close()
-- 									isSelling = false
-- 								end
-- 							)
-- 						end, v.Items)
-- 					end
-- 				end
-- 			end
-- 			if not foundZone then
-- 				Citizen.Wait(500)
-- 			end
-- 		else 
-- 			Citizen.Wait(10000)
-- 		end
-- 	end
-- end)


-- -------------
-- -- buying --
-- -------------

-- local isBuying = false

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(0)
-- 		local playerPed = PlayerPedId()
-- 		if (PlayerData.job ~= nil and PlayerData.job.name == Config.JobName) or (PlayerData.job2 ~= nil and PlayerData.job2.name == Config.JobName) then
-- 			local coords = GetEntityCoords(PlayerPedId())
-- 			local foundZone = false
-- 			for k,v in pairs(Config.BuyZones) do
-- 				if GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 2 then
-- 					foundZone = true
-- 					if not isBuying then
-- 						ESX.ShowHelpNotification(_U('press_buy'))
-- 					end

-- 					if IsControlJustReleased(0, Keys['E']) then
-- 						ESX.TriggerServerCallback('esx_ava_vigneronjob:GetBuyElements', function(elements)
-- 							ESX.UI.Menu.CloseAll()
-- 							isBuying = true
-- 							ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_buyer',{ title = "Vendeur pour "..Config.LabelName, align = 'left', elements = elements },
-- 								function(data,menu) 
-- 									local count = false 
-- 									ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'how_much', {title = "Combien voulez-vous en acheter ?"}, 
-- 										function(data2, menu2)
-- 											local quantity = tonumber(data2.value)
						
-- 											if quantity == nil then
-- 												ESX.ShowNotification(_U('amount_invalid'))
-- 											else
-- 												count = quantity
-- 												menu2.close()
-- 											end
-- 										end, 
-- 										function(data2, menu2)
-- 											menu2.close()
-- 										end
-- 									)
-- 									while not count do 
-- 										Citizen.Wait(0); 
-- 									end
-- 									TriggerServerEvent('esx_ava_vigneronjob:BuyItems',data.current.name,data.current.price,count)
-- 									isBuying = false
-- 									Citizen.Wait(1500)
-- 								end,
-- 								function(data,menu)
-- 									menu.close()
-- 									isBuying = false
-- 								end
-- 							)
-- 						end, v.Items)
-- 					end
-- 				end
-- 			end
-- 			if not foundZone then
-- 				Citizen.Wait(500)
-- 			end
-- 		else 
-- 			Citizen.Wait(10000)
-- 		end
-- 	end
-- end)
