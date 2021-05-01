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

local mainBlips = {}
local JobBlips = {}

local HasAlreadyEnteredMarker = false
local CurrentZoneName = nil
local CurrentZoneCategory = nil
local CurrentZoneValue = nil
local CurrentHelpText = nil
local CurrentJobName = nil
local CurrentActionEnabled = false



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

    for _, job in pairs(Config.Jobs) do
        local blip = AddBlipForCoord(job.Zones.JobActions.Pos)
        SetBlipSprite (blip, job.Blip.Sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale  (blip, 1.0)
        SetBlipColour (blip, job.Blip.Colour)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(job.LabelName)
        EndTextCommandSetBlipName(blip)

        table.insert(mainBlips, blip)
    end
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
        if mainBlips then
            for _, blip in ipairs(mainBlips) do
                RemoveBlip(blip)
            end
        end
        mainBlips = {}
        clearJobBlips()
	end
end)

function setJobsToUse()
    CurrentZoneName = nil
    playerJobs = {}
    if Config.Jobs[PlayerData.job.name] ~= nil then
        playerJobs[PlayerData.job.name] = Config.Jobs[PlayerData.job.name]
        playerJobs[PlayerData.job.name].jobIndex = 1
        playerJobs[PlayerData.job.name].grade = PlayerData.job.grade_name
    end
    if Config.Jobs[PlayerData.job2.name] ~= nil then
        playerJobs[PlayerData.job2.name] = Config.Jobs[PlayerData.job2.name]
        playerJobs[PlayerData.job2.name].jobIndex = 2
        playerJobs[PlayerData.job2.name].grade = PlayerData.job2.grade_name
    end
    clearJobBlips()
	createBlips()
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
        for jobName, job in pairs(playerJobs) do
            print(jobName .. " : " .. job.SocietyName .. " - " .. job.grade)
        end
    end
end)




-----------
-- Blips --
-----------

function clearJobBlips()
    if JobBlips then
        for _, blip in ipairs(JobBlips) do
            RemoveBlip(blip)
        end
    end
    JobBlips = {}
end

function createBlips()
    local function addJobBlip(coords, label, sprite, colour)
        local blip = AddBlipForCoord(coords)

        SetBlipSprite (blip, sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale  (blip, 0.7)
        SetBlipColour (blip, colour)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('~c~' .. label)
        EndTextCommandSetBlipName(blip)

        table.insert(JobBlips, blip)
    end

    for jobName, job in pairs(playerJobs) do
		if job.Zones ~= nil then
            for k, v in pairs(job.Zones) do
                if v.Blip then
                    addJobBlip(v.Pos, job.LabelName, job.Blip.Sprite, job.Blip.Colour)
                end
            end
		end
		if job.FieldZones ~= nil then
            for k, v in pairs(job.FieldZones) do
                if v.Blip then
                    addJobBlip(v.Pos, job.LabelName, job.Blip.Sprite, job.Blip.Colour)
                end
            end
		end
		if job.ProcessZones ~= nil then
            for k, v in pairs(job.ProcessZones) do
                if v.Blip then
                    addJobBlip(v.Pos, job.LabelName, job.Blip.Sprite, job.Blip.Colour)
                end
            end
		end
		if job.ProcessMenuZones ~= nil then
            for k, v in pairs(job.ProcessMenuZones) do
                if v.Blip then
                    addJobBlip(v.Pos, job.LabelName, job.Blip.Sprite, job.Blip.Colour)
                end
            end
		end
		if job.SellZones ~= nil then
            for k, v in pairs(job.SellZones) do
                if v.Blip then
                    addJobBlip(v.Pos, job.LabelName, job.Blip.Sprite, job.Blip.Colour)
                end
            end
		end
		if job.BuyZones ~= nil then
            for k, v in pairs(job.BuyZones) do
                if v.Blip then
                    addJobBlip(v.Pos, job.LabelName, job.Blip.Sprite, job.Blip.Colour)
                end
            end
		end
	end
end




local playerCoords = nil


Citizen.CreateThread(function()
	while true do
		playerCoords = GetEntityCoords(GetPlayerPed(-1))
		Wait(500)
    end
end)




-------------
-- Markers --
-------------

Citizen.CreateThread(function()
	while true do
		Wait(0)
        local foundMarker = false
        for jobName, job in pairs(playerJobs) do
            if job.Zones ~= nil then
                for k, v in pairs(job.Zones) do
                    if (v.Marker ~= nil and #(playerCoords - v.Pos) < Config.DrawDistance) then
                        if (k ~= 'JobActions' or job.grade ~= 'interim') then
                            DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
                            foundMarker = true
                        end
                    end
                end
            end
            if job.ProcessZones ~= nil then
                for k, v in pairs(job.ProcessZones) do
                    if (v.Marker ~= nil and #(playerCoords - v.Pos) < Config.DrawDistance) then
                        DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
                        foundMarker = true
                    end
                end
            end
            if job.ProcessMenuZones ~= nil then
                for k, v in pairs(job.ProcessMenuZones) do
                    if (v.Marker ~= nil and #(playerCoords - v.Pos) < Config.DrawDistance) then
                        DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
                        foundMarker = true
                    end
                end
            end
            if job.SellZones ~= nil then
                for k, v in pairs(job.SellZones) do
                    if (v.Marker ~= nil and #(playerCoords - v.Pos) < Config.DrawDistance) then
                        DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
                        foundMarker = true
                    end
                end
            end
            if job.BuyZones ~= nil then
                for k, v in pairs(job.BuyZones) do
                    if (v.Marker ~= nil and #(playerCoords - v.Pos) < Config.DrawDistance) then
                        DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
                        foundMarker = true
                    end
                end
            end
        end
        if not foundMarker then
            Wait(500)
        end
    end
end)


--------------------------------
-- Enter / Exit marker events --
--------------------------------


Citizen.CreateThread(function()
	while true do
		Wait(200)
        local isInMarker  = false
        local zoneNamePlayerIsIn = nil
        local zoneCategoryPlayerIsIn = nil
        local zonePlayerIsIn = nil
        local zoneJob = nil

        for jobName, job in pairs(playerJobs) do
            zoneJob = jobName
            
            if job.Zones ~= nil then
                for k, v in pairs(job.Zones) do
                    if (k ~= 'JobActions' or job.grade ~= 'interim') then
                        if (#(playerCoords - v.Pos) < v.Size.x) then
                            isInMarker = true
                            zoneCategoryPlayerIsIn = "Zones"
                            zoneNamePlayerIsIn = k
                            zonePlayerIsIn = v
                        end
                    end
				end
			end
            if job.ProcessZones ~= nil then
                for k, v in pairs(job.ProcessZones) do
                    if (#(playerCoords - v.Pos) < 2) then
                        isInMarker = true
                        zoneCategoryPlayerIsIn = "ProcessZones"
                        zoneNamePlayerIsIn = k
                        zonePlayerIsIn = v
                    end
				end
			end

		end


        if (isInMarker and not HasAlreadyEnteredMarker)
            or (isInMarker and CurrentZoneName ~= zoneNamePlayerIsIn)
        then
            HasAlreadyEnteredMarker = true
            TriggerEvent('esx_ava_jobs:hasEnteredMarker', zoneJob, zoneNamePlayerIsIn, zoneCategoryPlayerIsIn, zonePlayerIsIn)
        end

        if not isInMarker and HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = false
            TriggerEvent('esx_ava_jobs:hasExitedMarker', zoneJob, CurrentZoneName, CurrentZoneCategory)
        end
	end
end)


AddEventHandler('esx_ava_jobs:hasEnteredMarker', function(jobName, zoneName, zoneCategory, zone)
	if zone.HelpText ~= nil then
        CurrentHelpText = zone.HelpText
    end

    CurrentJobName = jobName
    CurrentZoneName = zoneName
    CurrentZoneCategory = zoneCategory
    CurrentZoneValue = zone
    CurrentActionEnabled = true
end)

AddEventHandler('esx_ava_jobs:hasExitedMarker', function(jobName, zoneName, zoneCategory)
	ESX.UI.Menu.CloseAll()
	CurrentZoneName = nil
end)

------------------
-- Key Controls --
------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentZoneName ~= nil and CurrentActionEnabled then
            if CurrentHelpText ~= nil then
                SetTextComponentFormat('STRING')
                AddTextComponentString(CurrentHelpText)
                DisplayHelpTextFromStringLabel(0, 0, 1, -1)
            end

			if IsControlPressed(0, 38) -- E
                and (GetGameTimer() - GUI.Time) > 300
            then
                CurrentActionEnabled = false
                GUI.Time = GetGameTimer()
                local job = playerJobs[CurrentJobName]

                if CurrentZoneCategory == "Zones" then
                    if CurrentZoneName == 'JobActions' then
                        OpenJobActionsMenu(CurrentJobName)
                    elseif CurrentZoneName == 'Dressing' then
                        OpenCloakroomMenu(playerJobs[CurrentJobName].jobIndex)
                    elseif CurrentZoneName == 'SocietyGarage' then
                        TriggerEvent('esx_ava_garage:OpenSocietyVehiclesMenu', playerJobs[CurrentJobName].SocietyName, playerJobs[CurrentJobName].Zones.SocietyGarage)
                    end

                elseif CurrentZoneCategory == "ProcessZones" then
					if not CurrentZoneValue.NoInterim or
                        (CurrentZoneValue.NoInterim and job.grade ~= 'interim')
					then
                        Process(CurrentZoneValue)
                        CurrentActionEnabled = true
					else
						ESX.ShowHelpNotification(_U('no_interim'))
					end
                    
                end

			end
		end
	end
end)





function OpenJobActionsMenu(jobName)
    local job = playerJobs[jobName]
	local elements = {
		{label = _U('access_chest'), value = 'access_chest'},
	}

	if job.grade == "boss" then
		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'esx_ava_jobs_job_actions',
    {
        title    = job.LabelName,
        align    = 'left',
        elements = elements
    },
    function(data, menu)
        if data.current.value == 'access_chest' then
            TriggerEvent('esx_ava_inventories:OpenSharedInventory', job.SocietyName)

        elseif data.current.value == 'boss_actions' then
            TriggerEvent('esx_society:openBossMenu', jobName, function(data, menu)
                menu.close()
            end, {wash = false})
        end

    end,
    function(data, menu)
        menu.close()
        CurrentActionEnabled = true
    end)
end

function OpenCloakroomMenu(jobIndex)
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'esx_ava_jobs_cloakroom',
    {
        title    = _U('cloakroom'),
        align    = 'left',
        css 	 = 'vestiaire',
        elements = {
            {label = _U('vine_clothes_civil'), value = 'citizen_wear'},
            {label = _U('vine_clothes_vine'), value = 'job_wear'}
        },
    },
    function(data, menu)
        menu.close()

        if data.current.value == 'citizen_wear' then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                TriggerEvent('skinchanger:loadSkin', skin)
            end)
        end

        if data.current.value == 'job_wear' then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin' .. (jobIndex ~= 1 and jobIndex or ''), function(skin, jobSkin)
                TriggerEvent('skinchanger:loadClothes', skin, skin.sex == 0 and jobSkin.skin_male or jobSkin.skin_female)
            end)
        end

        CurrentActionEnabled = true
    end,
    function(data, menu)
        menu.close()
        CurrentActionEnabled = true
    end)

end



function Process(process)
	ESX.TriggerServerCallback('esx_ava_jobs:canprocess', function(canProcess)
		if canProcess then
			TriggerServerEvent('esx_ava_jobs:process', process)
			local timeLeft = process.Delay / 1000
			local playerPed = PlayerPedId()

			exports['progressBars']:startUI(process.Delay, _U('process_in_progress'))
			TaskStartScenarioInPlace(playerPed, process.Scenario, 0, true)
			while timeLeft > 0 do
				Citizen.Wait(1000)
				timeLeft = timeLeft - 1

				if #(playerCoords - process.Pos) > 2 then
					TriggerServerEvent('esx_ava_jobs:cancelProcessing')
					break
				end
			end
			Citizen.Wait(1500)
			ClearPedTasks(playerPed)
		end
	end, process)
end














-------------
-- récolte --
-------------

local spawnedPlants = {}
local plants = {}
local isPickingUp = false

local function spawnedPlantsFindName(name)
	for i=1, #spawnedPlants, 1 do
		if spawnedPlants[i].name == name then
			return i
		end
	end

	return nil
end

Citizen.CreateThread(function()
	-- while true do
	-- 	Citizen.Wait(10)
	-- 	if (PlayerData.job ~= nil and PlayerData.job.name == Config.JobName) or (PlayerData.job2 ~= nil and PlayerData.job2.name == Config.JobName) then
	-- 		local coords = GetEntityCoords(PlayerPedId())
	-- 		for k,v in pairs(Config.FieldZones) do

	-- 			if GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 20 then
	-- 				Spawnplants(k, v)
	-- 				Citizen.Wait(500)
	-- 			else
	-- 				Citizen.Wait(500)
	-- 			end
	-- 		end
	-- 		-- for debug
	-- 		-- for i=1, #spawnedPlants, 1 do
	-- 		-- 	print(spawnedPlants[i].name ..' : '.. spawnedPlants[i].quantity)
	-- 		-- end
	-- 	else 
	-- 		Citizen.Wait(10000)
	-- 	end
	-- end
end)

Citizen.CreateThread(function()
	-- while true do
	-- 	Citizen.Wait(0)
	-- 	if (PlayerData.job ~= nil and PlayerData.job.name == Config.JobName) or (PlayerData.job2 ~= nil and PlayerData.job2.name == Config.JobName) then

	-- 		local playerPed = PlayerPedId()
	-- 		local coords = GetEntityCoords(playerPed)
	-- 		local nearbyObject, nearbyID

	-- 		for i=1, #plants, 1 do
	-- 			if GetDistanceBetweenCoords(coords, GetEntityCoords(plants[i].obj), false) < 1 then
	-- 				nearbyObject, nearbyID = plants[i], i
	-- 			end
	-- 		end

	-- 		if nearbyObject and nearbyObject.obj and IsPedOnFoot(playerPed) then

	-- 			if not isPickingUp then
	-- 				ESX.ShowHelpNotification(_U('press_collect'))
	-- 			end

	-- 			if IsControlJustReleased(0, Keys['E']) and not isPickingUp then
	-- 				isPickingUp = true

	-- 				ESX.TriggerServerCallback('esx_ava_vigneronjob:canPickUp', function(canPickUp)

	-- 					if canPickUp then
	-- 						TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)

	-- 						Citizen.Wait(2000)
	-- 						ClearPedTasks(playerPed)
			
	-- 						ESX.Game.DeleteObject(nearbyObject.obj)
			
	-- 						table.remove(plants, nearbyID)

	-- 						local sPIndex = spawnedPlantsFindName(nearbyObject.name)
	-- 						spawnedPlants[sPIndex].quantity = spawnedPlants[sPIndex].quantity - 1
	-- 						for i=1, #nearbyObject.items, 1 do
	-- 							TriggerServerEvent('esx_ava_vigneronjob:pickUp', nearbyObject.items[i])
	-- 						end
	-- 					else
	-- 						ESX.ShowNotification(_U('inventoryfull'))
	-- 					end

	-- 					isPickingUp = false

	-- 				end, nearbyObject.items)
	-- 			end

	-- 		else
	-- 			Citizen.Wait(500)
	-- 		end
	-- 	else 
	-- 		Citizen.Wait(10000)
	-- 	end

	-- end

end)

function Spawnplants(k, v)
	local sPIndex = spawnedPlantsFindName(k)
	if sPIndex == nil then
		table.insert(spawnedPlants, {name = k, quantity = 0})
		sPIndex = spawnedPlantsFindName(k)
	end

	while spawnedPlants[sPIndex].quantity < 5 do
		Citizen.Wait(0)
		local plantCoords = GeneratePlantCoords(k, v)

		ESX.Game.SpawnLocalObject(v.Prop, plantCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(plants, {obj = obj, items = v.Items, name = k})
			spawnedPlants[sPIndex].quantity = spawnedPlants[sPIndex].quantity + 1
		end)
	end
end

function GeneratePlantCoords(k, v)
	while true do
		Citizen.Wait(1)

		local plantCoordX, plantCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-8, 8)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-8, 8)

		plantCoordX = v.Pos.x + modX
		plantCoordY = v.Pos.y + modY

		local coordZ = GetCoordZ(plantCoordX, plantCoordY, v)
		local coord = vector3(plantCoordX, plantCoordY, coordZ)

		if ValidateplantCoord(coord, k, v) then
			return coord
		end
	end
end

function ValidateplantCoord(plantCoord, k, v)
	local sPIndex = spawnedPlantsFindName(k)
	if spawnedPlants[sPIndex].quantity > 0 then
		local validate = true

		for k, v in pairs(plants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v.obj), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, v.Pos.x, v.Pos.y, v.Pos.z, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GetCoordZ(x, y, v)
	for i, height in ipairs(v.GroundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return v.Pos.z
end






----------------
-- TRAITEMENT --
----------------

local isProcessing = false

Citizen.CreateThread(function()
	-- while true do
	-- 	Citizen.Wait(0)
	-- 	local playerPed = PlayerPedId()
	-- 	if (PlayerData.job ~= nil and PlayerData.job.name == Config.JobName) or (PlayerData.job2 ~= nil and PlayerData.job2.name == Config.JobName) then
	-- 		local coords = GetEntityCoords(PlayerPedId())
	-- 		local foundZone = false
	-- 		for k,v in pairs(Config.ProcessZones) do
	-- 			if GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 2 then
	-- 				foundZone = true
	-- 				if not v.NoInterim or 
	-- 				(v.NoInterim and (PlayerData.job ~= nil and PlayerData.job.name == Config.JobName and PlayerData.job.grade_name ~= 'interim') 
	-- 				or (PlayerData.job2 ~= nil and PlayerData.job2.name == Config.JobName and PlayerData.job2.grade_name ~= 'interim'))
	-- 				then
	-- 					if not isProcessing then
	-- 						ESX.ShowHelpNotification(_U('press_traitement'))
	-- 					end

	-- 					if IsControlJustReleased(0, Keys['E']) and not isProcessing then
	-- 						Process(v)
	-- 					end
	-- 				else
	-- 					ESX.ShowHelpNotification(_U('no_interim'))
	-- 				end
	-- 			end
	-- 		end
	-- 		if not foundZone then
	-- 			Citizen.Wait(500)
	-- 		end
	-- 	else 
	-- 		Citizen.Wait(10000)
	-- 	end
	-- end
end)

Citizen.CreateThread(function()
	-- while true do
	-- 	Citizen.Wait(0)
	-- 	local playerPed = PlayerPedId()
	-- 	if (PlayerData.job ~= nil and PlayerData.job.name == Config.JobName) or (PlayerData.job2 ~= nil and PlayerData.job2.name == Config.JobName) then
	-- 		local coords = GetEntityCoords(PlayerPedId())
	-- 		local foundZone = false
	-- 		for k,v in pairs(Config.ProcessMenuZones) do
	-- 			if GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 2 then
	-- 				foundZone = true
	-- 				if not isProcessing then
	-- 					ESX.ShowHelpNotification(_U('press_traitement'))
	-- 				end

	-- 				if IsControlJustReleased(0, Keys['E']) and not isProcessing then
	-- 					local elements = {}
	-- 					for k2, v2 in pairs(v.Process) do
	-- 						table.insert(elements, {label = v2.Name, delay = v2.Delay, value = v2})
	-- 					end
	-- 					ESX.UI.Menu.CloseAll()
	-- 					isProcessing = true
	-- 					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_process',{ title = v.Title, align = 'left', elements = elements },
	-- 						function(data,menu) 
	-- 							local count = false 
	-- 							ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'how_much', {title = "Combien voulez-vous en traiter ? [Max : "..v.MaxProcess.."]"}, 
	-- 								function(data2, menu2)
	-- 									local quantity = tonumber(data2.value)
					
	-- 									if quantity == nil or quantity < 1 or quantity > v.MaxProcess then
	-- 										ESX.ShowNotification(_U('amount_invalid'))
	-- 									else
	-- 										count = quantity
	-- 										menu2.close()
	-- 									end
	-- 								end, 
	-- 								function(data2, menu2)
	-- 									menu2.close()
	-- 								end
	-- 							)
	-- 							while not count do 
	-- 								Citizen.Wait(0); 
	-- 							end
	-- 							menu.close()

	-- 							for i = 1, count, 1 do
	-- 								Process(data.current.value)
	-- 								Citizen.Wait(data.current.delay + 500)
	-- 							end
	-- 							ClearPedTasks(playerPed)

	-- 							isProcessing = false
	-- 							Citizen.Wait(1500)
	-- 						end,
	-- 						function(data,menu)
	-- 							menu.close()
	-- 							isProcessing = false
	-- 						end
	-- 					)
	-- 				end
	-- 			end
	-- 		end
	-- 		if not foundZone then
	-- 			Citizen.Wait(500)
	-- 		end
	-- 	else 
	-- 		Citizen.Wait(10000)
	-- 	end
	-- end
end)





-------------
-- selling --
-------------

local isSelling = false

Citizen.CreateThread(function()
	-- while true do
	-- 	Citizen.Wait(0)
	-- 	local playerPed = PlayerPedId()
	-- 	if (PlayerData.job ~= nil and PlayerData.job.name == Config.JobName) or (PlayerData.job2 ~= nil and PlayerData.job2.name == Config.JobName) then
	-- 		local coords = GetEntityCoords(PlayerPedId())
	-- 		local foundZone = false
	-- 		for k,v in pairs(Config.SellZones) do
	-- 			if GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 2 then
	-- 				foundZone = true
	-- 				if not isSelling then
	-- 					ESX.ShowHelpNotification(_U('press_sell'))
	-- 				end

	-- 				if IsControlJustReleased(0, Keys['E']) then
	-- 					ESX.TriggerServerCallback('esx_ava_vigneronjob:GetSellElements', function(elements)
	-- 						ESX.UI.Menu.CloseAll()
	-- 						isSelling = true
	-- 						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_seller',{ title = "Acheteur "..Config.LabelName, align = 'left', elements = elements },
	-- 							function(data,menu) 
	-- 								local count = false 
	-- 								ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'how_much', {title = "Combien voulez-vous vendre ? [Max : "..data.current.owned.."]"}, 
	-- 									function(data2, menu2)
	-- 										local quantity = tonumber(data2.value)
						
	-- 										if quantity == nil then
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
	-- 								if tonumber(count) > tonumber(data.current.owned) then 
	-- 									ESX.ShowNotification("Tu n'as pas autant de "..data.current.itemLabel..".")
	-- 								else 
	-- 									TriggerServerEvent('esx_ava_vigneronjob:SellItems',data.current.name,data.current.price,count)
	-- 									menu.close()
	-- 									isSelling = false
	-- 									Citizen.Wait(1500)
	-- 								end
	-- 							end,
	-- 							function(data,menu)
	-- 								menu.close()
	-- 								isSelling = false
	-- 							end
	-- 						)
	-- 					end, v.Items)
	-- 				end
	-- 			end
	-- 		end
	-- 		if not foundZone then
	-- 			Citizen.Wait(500)
	-- 		end
	-- 	else 
	-- 		Citizen.Wait(10000)
	-- 	end
	-- end
end)


-------------
-- buying --
-------------

local isBuying = false

Citizen.CreateThread(function()
	-- while true do
	-- 	Citizen.Wait(0)
	-- 	local playerPed = PlayerPedId()
	-- 	if (PlayerData.job ~= nil and PlayerData.job.name == Config.JobName) or (PlayerData.job2 ~= nil and PlayerData.job2.name == Config.JobName) then
	-- 		local coords = GetEntityCoords(PlayerPedId())
	-- 		local foundZone = false
	-- 		for k,v in pairs(Config.BuyZones) do
	-- 			if GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < 2 then
	-- 				foundZone = true
	-- 				if not isBuying then
	-- 					ESX.ShowHelpNotification(_U('press_buy'))
	-- 				end

	-- 				if IsControlJustReleased(0, Keys['E']) then
	-- 					ESX.TriggerServerCallback('esx_ava_vigneronjob:GetBuyElements', function(elements)
	-- 						ESX.UI.Menu.CloseAll()
	-- 						isBuying = true
	-- 						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_buyer',{ title = "Vendeur pour "..Config.LabelName, align = 'left', elements = elements },
	-- 							function(data,menu) 
	-- 								local count = false 
	-- 								ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'how_much', {title = "Combien voulez-vous en acheter ?"}, 
	-- 									function(data2, menu2)
	-- 										local quantity = tonumber(data2.value)
						
	-- 										if quantity == nil then
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
	-- 								TriggerServerEvent('esx_ava_vigneronjob:BuyItems',data.current.name,data.current.price,count)
	-- 								isBuying = false
	-- 								Citizen.Wait(1500)
	-- 							end,
	-- 							function(data,menu)
	-- 								menu.close()
	-- 								isBuying = false
	-- 							end
	-- 						)
	-- 					end, v.Items)
	-- 				end
	-- 			end
	-- 		end
	-- 		if not foundZone then
	-- 			Citizen.Wait(500)
	-- 		end
	-- 	else 
	-- 		Citizen.Wait(10000)
	-- 	end
	-- end
end)
