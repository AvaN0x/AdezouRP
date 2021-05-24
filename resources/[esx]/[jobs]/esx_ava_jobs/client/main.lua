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
actualGang = nil

local mainBlips = {}
local JobBlips = {}

local HasAlreadyEnteredMarker = false
local CurrentZoneName = nil
local CurrentZoneCategory = nil
local CurrentZoneValue = nil
local CurrentHelpText = nil
local CurrentJobName = nil
local CurrentActionEnabled = false

local spawnedPlants = {}
local plants = {}



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
        if not job.isIllegal and not job.isGang then
            local blip = AddBlipForCoord(job.Zones.JobActions.Pos)
            SetBlipSprite (blip, job.Blip.Sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale  (blip, 1.0)
            SetBlipColour (blip, job.Blip.Colour)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(job.Blip.Name or job.LabelName)
            EndTextCommandSetBlipName(blip)

            table.insert(mainBlips, blip)
        end
    end

    Citizen.Wait(1000)
    TriggerServerEvent("esx_ava_jobs:requestGang")
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

RegisterNetEvent('esx_ava_jobs:setGang')
AddEventHandler('esx_ava_jobs:setGang', function(gang)
	if gang and gang.name and Config.Jobs[gang.name] then
		actualGang = {name = gang.name, grade = gang.grade}
	else
		actualGang = nil
	end
    setJobsToUse()
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
        if plants then
            for k, v in pairs(plants) do
                ESX.Game.DeleteObject(v.obj)
            end
        end
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
    if actualGang and Config.Jobs[actualGang.name] ~= nil then
        playerJobs[actualGang.name] = Config.Jobs[actualGang.name]
        playerJobs[actualGang.name].grade = actualGang.grade
    end
    for name, farm in pairs(Config.Jobs) do
        if farm.isIllegal == true then
            playerJobs[name] = farm
        end
    end

    checkAuthorizations()
    clearJobBlips()
	createBlips()
end

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(5000)
--         for jobName, job in pairs(playerJobs) do
--             print(jobName .. " : " .. job.SocietyName .. " - " .. job.grade)
--         end
--     end
-- end)


function checkAuthorizations()
    for jobName, job in pairs(playerJobs) do
        if not job.isIllegal then
            if job.Zones ~= nil then
                for k, v in pairs(job.Zones) do
                    if k == "JobActions" and job.grade == "interim" then
                        job.Zones[k].GradeEnabled = false
                    else
                        job.Zones[k].GradeEnabled = not ((v.ExcludeGrades and tableHasValue(v.ExcludeGrades, job.grade))
                            or (v.OnlyGrades and not tableHasValue(v.OnlyGrades, job.grade)))
                    end
                end
            end
            if job.FieldZones ~= nil then
                for k, v in pairs(job.FieldZones) do
                    job.FieldZones[k].GradeEnabled = not ((v.ExcludeGrades and tableHasValue(v.ExcludeGrades, job.grade))
                        or (v.OnlyGrades and not tableHasValue(v.OnlyGrades, job.grade)))
                end
            end
            if job.ProcessZones ~= nil then
                for k, v in pairs(job.ProcessZones) do
                    job.ProcessZones[k].GradeEnabled = not ((v.ExcludeGrades and tableHasValue(v.ExcludeGrades, job.grade))
                        or (v.OnlyGrades and not tableHasValue(v.OnlyGrades, job.grade)))
                end
            end
            if job.ProcessMenuZones ~= nil then
                for k, v in pairs(job.ProcessMenuZones) do
                    job.ProcessMenuZones[k].GradeEnabled =not ((v.ExcludeGrades and tableHasValue(v.ExcludeGrades, job.grade))
                        or (v.OnlyGrades and not tableHasValue(v.OnlyGrades, job.grade)))
                end
            end
            if job.SellZones ~= nil then
                for k, v in pairs(job.SellZones) do
                    job.SellZones[k].GradeEnabled = not ((v.ExcludeGrades and tableHasValue(v.ExcludeGrades, job.grade))
                        or (v.OnlyGrades and not tableHasValue(v.OnlyGrades, job.grade)))
                end
            end
            if job.BuyZones ~= nil then
                for k, v in pairs(job.BuyZones) do
                    job.BuyZones[k].GradeEnabled = not ((v.ExcludeGrades and tableHasValue(v.ExcludeGrades, job.grade))
                        or (v.OnlyGrades and not tableHasValue(v.OnlyGrades, job.grade)))
                end
            end
		end
	end
end


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
                if v.Blip and v.GradeEnabled then
                    addJobBlip(v.Pos, v.Name, job.Blip.Sprite, job.Blip.Colour)
                end
            end
		end
		if job.FieldZones ~= nil then
            for k, v in pairs(job.FieldZones) do
                if v.Blip and v.GradeEnabled then
                    addJobBlip(v.Pos, v.Name, job.Blip.Sprite, job.Blip.Colour)
                end
            end
		end
		if job.ProcessZones ~= nil then
            for k, v in pairs(job.ProcessZones) do
                if v.Blip and v.GradeEnabled then
                    addJobBlip(v.Pos, v.Name, job.Blip.Sprite, job.Blip.Colour)
                end
            end
		end
		if job.ProcessMenuZones ~= nil then
            for k, v in pairs(job.ProcessMenuZones) do
                if v.Blip and v.GradeEnabled then
                    addJobBlip(v.Pos, v.Name, job.Blip.Sprite, job.Blip.Colour)
                end
            end
		end
		if job.SellZones ~= nil then
            for k, v in pairs(job.SellZones) do
                if v.Blip and v.GradeEnabled then
                    addJobBlip(v.Pos, v.Name, job.Blip.Sprite, job.Blip.Colour)
                end
            end
		end
		if job.BuyZones ~= nil then
            for k, v in pairs(job.BuyZones) do
                if v.Blip and v.GradeEnabled then
                    addJobBlip(v.Pos, v.Name, job.Blip.Sprite, job.Blip.Colour)
                end
            end
		end
	end
end




local playerCoords = nil
local playerPed = nil

Citizen.CreateThread(function()
	while true do
        playerPed = PlayerPedId()
		playerCoords = GetEntityCoords(playerPed)
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
                    if (v.Marker ~= nil and #(playerCoords - v.Pos) < Config.DrawDistance) and v.GradeEnabled then
                        DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
                        foundMarker = true
                    end
                end
            end
            if job.ProcessZones ~= nil then
                for k, v in pairs(job.ProcessZones) do
                    if (v.Marker ~= nil and #(playerCoords - v.Pos) < Config.DrawDistance) and v.GradeEnabled then
                        DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
                        foundMarker = true
                    end
                end
            end
            if job.ProcessMenuZones ~= nil then
                for k, v in pairs(job.ProcessMenuZones) do
                    if (v.Marker ~= nil and #(playerCoords - v.Pos) < Config.DrawDistance) and v.GradeEnabled then
                        DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
                        foundMarker = true
                    end
                end
            end
            if job.SellZones ~= nil then
                for k, v in pairs(job.SellZones) do
                    if (v.Marker ~= nil and #(playerCoords - v.Pos) < Config.DrawDistance) and v.GradeEnabled then
                        DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
                        foundMarker = true
                    end
                end
            end
            if job.BuyZones ~= nil then
                for k, v in pairs(job.BuyZones) do
                    if (v.Marker ~= nil and #(playerCoords - v.Pos) < Config.DrawDistance) and v.GradeEnabled then
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
		Wait(100)
        local isInMarker  = false
        local zoneNamePlayerIsIn = nil
        local zoneCategoryPlayerIsIn = nil
        local zonePlayerIsIn = nil
        local zoneJob = nil

        for jobName, job in pairs(playerJobs) do
            if job.Zones ~= nil then
                for k, v in pairs(job.Zones) do
                    if (#(playerCoords - v.Pos) < (v.Distance or 1.5)) and v.GradeEnabled then
                        isInMarker = true
                        zoneJob = jobName
                        zoneCategoryPlayerIsIn = "Zones"
                        zoneNamePlayerIsIn = k
                        zonePlayerIsIn = v
                    end
				end
			end
            if job.ProcessZones ~= nil then
                for k, v in pairs(job.ProcessZones) do
                    if (#(playerCoords - v.Pos) < 2) and v.GradeEnabled then
                        isInMarker = true
                        zoneJob = jobName
                        zoneCategoryPlayerIsIn = "ProcessZones"
                        zoneNamePlayerIsIn = k
                        zonePlayerIsIn = v
                    end
				end
			end
            if job.ProcessMenuZones ~= nil then
                for k, v in pairs(job.ProcessMenuZones) do
                    if (#(playerCoords - v.Pos) < 2) and v.GradeEnabled then
                        isInMarker = true
                        zoneJob = jobName
                        zoneCategoryPlayerIsIn = "ProcessMenuZones"
                        zoneNamePlayerIsIn = k
                        zonePlayerIsIn = v
                    end
				end
			end
            if job.SellZones ~= nil then
                for k, v in pairs(job.SellZones) do
                    if (#(playerCoords - v.Pos) < 2) and v.GradeEnabled then
                        isInMarker = true
                        zoneJob = jobName
                        zoneCategoryPlayerIsIn = "SellZones"
                        zoneNamePlayerIsIn = k
                        zonePlayerIsIn = v
                    end
				end
			end
            if job.BuyZones ~= nil then
                for k, v in pairs(job.BuyZones) do
                    if (#(playerCoords - v.Pos) < 2) and v.GradeEnabled then
                        isInMarker = true
                        zoneJob = jobName
                        zoneCategoryPlayerIsIn = "BuyZones"
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
                        OpenCloakroomMenu(job.jobIndex)
                    elseif string.match(CurrentZoneName, "Stock$") then
                        TriggerEvent('esx_ava_inventories:OpenSharedInventory', CurrentZoneValue.StockName)
                    elseif string.match(CurrentZoneName, "Garage$") then
                        if CurrentZoneValue.IsNonProprietaryGarage then
                            TriggerEvent('esx_ava_garage:openSpecialVehicleMenu', CurrentZoneValue)

                        else
                            TriggerEvent('esx_ava_garage:OpenSocietyVehiclesMenu', job.SocietyName, CurrentZoneValue)
                        end
                    end

                elseif CurrentZoneCategory == "ProcessZones" then
                    ProcessZone(job)

                elseif CurrentZoneCategory == "ProcessMenuZones" then
                    ProcessMenuZone(job)

                elseif CurrentZoneCategory == "SellZones" then
                    SellZone(job)

                elseif CurrentZoneCategory == "BuyZones" then
                    BuyZone(job)


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
		table.insert(elements, {label = _('boss_actions'), value = 'boss_actions'})
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

    local outfits = CurrentZoneValue.Outfits
    local elements = {}

    if not CurrentZoneValue.NoJobDress then
        table.insert(elements, {label = _('vine_clothes_civil'), value = 'citizen_wear'})
        table.insert(elements, {label = _('vine_clothes_vine'), value = 'job_wear'})
    end
    table.insert(elements, {label = _('user_clothes'), value = 'user_clothes'})

    if outfits ~= nil then
        for k, v in ipairs(outfits) do
            table.insert(elements, {label = _('custom_clothe_format', v.Label), value = k})
        end
    end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'esx_ava_jobs_cloakroom',
    {
        title    = _('cloakroom'),
        align    = 'left',
        css 	 = 'vestiaire',
        elements = elements
    },
    function(data, menu)
        if data.current.value == 'user_clothes' then
            TriggerEvent("esx_ava_clotheshop:openOutfitsMenu")
        elseif data.current.value == 'citizen_wear' then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                TriggerEvent('skinchanger:loadSkin', skin)
            end)
        elseif data.current.value == 'job_wear' then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin' .. (jobIndex ~= 1 and jobIndex or ''), function(skin, jobSkin)
                TriggerEvent('skinchanger:loadClothes', skin, skin.sex == 0 and jobSkin.skin_male or jobSkin.skin_female)
            end)
        elseif outfits ~= nil and outfits[data.current.value] then
            TriggerEvent('skinchanger:getSkin', function(skin)
                TriggerEvent('skinchanger:loadClothes', skin, skin.sex == 0 and outfits[data.current.value].Male or outfits[data.current.value].Female)
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
	end, process, CurrentJobName)
end

function ProcessZone(job)
    Process(CurrentZoneValue)
    Citizen.Wait(CurrentZoneValue.Delay + 1000)
    CurrentActionEnabled = true
end

function ProcessMenuZone(job)
    local elements = {}
    for k, v in pairs(CurrentZoneValue.Process) do
        table.insert(elements, {label = v.Name, delay = v.Delay, value = v})
    end

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'esx_ava_jobs_job_process',
    {
        title = CurrentZoneValue.Title,
        align = 'left',
        elements = elements
    },
    function(data,menu)
        local count = false
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'esx_ava_jobs_how_much',
        {
            title = _('process_how_much', CurrentZoneValue.MaxProcess)
        },
        function(data2, menu2)
            local quantity = tonumber(data2.value)

            if quantity == nil or quantity < 1 or quantity > CurrentZoneValue.MaxProcess then
                ESX.ShowNotification(_U('amount_invalid'))
            else
                count = quantity
                menu2.close()
            end
        end,
        function(data2, menu2)
            menu2.close()
        end)


        while not count do
            Citizen.Wait(0);
        end
        menu.close()

        for i = 1, count, 1 do
            Process(data.current.value)
            Citizen.Wait(data.current.delay + 500)
        end
        ClearPedTasks(playerPed)

        CurrentActionEnabled = true
        Citizen.Wait(1500)
    end,
    function(data,menu)
        menu.close()
        CurrentActionEnabled = true
    end)

end

function SellZone(job)
    ESX.TriggerServerCallback('esx_ava_jobs:GetSellElements', function(elements)
        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_seller',
        {
            title = _('buyer_for', job.LabelName),
            align = 'left',
            elements = elements
        },
        function(data,menu)
            local count = false
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'how_much',
            {
                title = _('sell_how_much', data.current.owned)
            },
            function(data2, menu2)
                local quantity = tonumber(data2.value)

                if quantity == nil then
                    ESX.ShowNotification(_U('amount_invalid'))
                else
                    count = quantity
                    menu2.close()
                end
            end,
            function(data2, menu2)
                menu2.close()
            end)


            while not count do
                Citizen.Wait(0);
            end
            if tonumber(count) > tonumber(data.current.owned) then
                ESX.ShowNotification(_('sell_not_that_much', data.current.itemLabel))
            else
                TriggerServerEvent('esx_ava_jobs:SellItems', CurrentJobName, CurrentZoneName, job.jobIndex, data.current.name, count)
                menu.close()
                CurrentActionEnabled = true
                Citizen.Wait(1500)
            end
        end,
        function(data,menu)
            menu.close()
            CurrentActionEnabled = true
        end)
    end, CurrentJobName, CurrentZoneName)

end

function BuyZone(job)
    ESX.TriggerServerCallback('esx_ava_jobs:GetBuyElements', function(elements)
        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'esx_ava_jobs_job_buyer',
        {
            title = _('seller_for', job.LabelName),
            align = 'left',
            elements = elements
        },
        function(data,menu)
            local count = false
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'esx_ava_jobs_how_much', 
            {
                title = _('buy_how_much')
            },
            function(data2, menu2)
                local quantity = tonumber(data2.value)

                if quantity == nil then
                    ESX.ShowNotification(_U('amount_invalid'))
                else
                    count = quantity
                    menu2.close()
                end
            end,
            function(data2, menu2)
                menu2.close()
            end)

            while not count do
                Citizen.Wait(0);
            end

            TriggerServerEvent('esx_ava_jobs:BuyItem', CurrentJobName, CurrentZoneName, data.current.name, count)
            Citizen.Wait(1500)
        end,
        function(data,menu)
            menu.close()
            CurrentActionEnabled = true
        end)
    end, CurrentJobName, CurrentZoneName)

end






-------------
-- récolte --
-------------

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
	while true do
		Citizen.Wait(200)
        for jobName, job in pairs(playerJobs) do
            if job.FieldZones then
                for k, v in pairs(job.FieldZones) do
                    if #(playerCoords - v.Pos) < 20 then
                        Spawnplants(jobName, k, v)
                        Citizen.Wait(500)
                    else
                        Citizen.Wait(500)
                    end
                end
                -- for debug
                -- for i=1, #spawnedPlants, 1 do
                -- 	print(spawnedPlants[i].name ..' : '.. spawnedPlants[i].quantity)
                -- end
            end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
        for jobName, job in pairs(playerJobs) do
			local nearbyObject, nearbyID

			for i=1, #plants, 1 do
				if #(playerCoords - GetEntityCoords(plants[i].obj)) < 1.3 then
					nearbyObject, nearbyID = plants[i], i
				end
			end

			if nearbyObject and nearbyObject.obj and IsPedOnFoot(playerPed) then

				if not isPickingUp then
                    SetTextComponentFormat('STRING')
                    AddTextComponentString(_('press_collect'))
                    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
				end

				if IsControlJustReleased(0, 38) and not isPickingUp then -- E
					isPickingUp = true

					ESX.TriggerServerCallback('esx_ava_jobs:canPickUp', function(canPickUp)
						if canPickUp == true then
							TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)

							Citizen.Wait(2000)
							ClearPedTasks(playerPed)

                            ESX.Game.DeleteObject(nearbyObject.obj)

                            table.remove(plants, nearbyID)

							local sPIndex = spawnedPlantsFindName(nearbyObject.name)
							spawnedPlants[sPIndex].quantity = spawnedPlants[sPIndex].quantity - 1
                            TriggerServerEvent('esx_ava_jobs:pickUp', nearbyObject.jobName, nearbyObject.name)
                        elseif canPickUp == 'max_count' then
							ESX.ShowNotification(_('max_pickup_day'))
                        elseif canPickUp == 'max_countillegal' then
							ESX.ShowNotification(_('max_pickup_day_illegal'))
                        else
							ESX.ShowNotification(_('inventoryfull'))
						end

						isPickingUp = false

					end, nearbyObject.jobName, nearbyObject.name)
				end

			else
				Citizen.Wait(500)
			end
		end

	end

end)

function Spawnplants(jobName, k, v)
	local sPIndex = spawnedPlantsFindName(k)
	if sPIndex == nil then
		table.insert(spawnedPlants, {jobName = jobName, name = k, quantity = 0})
		sPIndex = spawnedPlantsFindName(k)
	end

	while spawnedPlants[sPIndex].quantity < 5 do
		Citizen.Wait(0)
		local plantCoords = GeneratePlantCoords(k, v)

		ESX.Game.SpawnLocalObject(v.PropHash, plantCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(plants, {obj = obj, jobName = jobName, name = k})
			spawnedPlants[sPIndex].quantity = spawnedPlants[sPIndex].quantity + 1
		end)
	end
end

function GeneratePlantCoords(k, v)
	while true do
		Citizen.Wait(1)

		local plantCoordX, plantCoordY

        if (v.Radius == nil) then
            v.Radius = 8
        end

		math.randomseed(GetGameTimer())
        local modX = math.random(- v.Radius,  v.Radius)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(- v.Radius,  v.Radius)

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
        if not v.DistanceValidate then
            v.DistanceValidate = v.Radius / 2
        end

		for k2, v2 in pairs(plants) do
			if #(plantCoord - GetEntityCoords(v2.obj)) < v.DistanceValidate then
				validate = false
			end
		end

		if #(plantCoord - v.Pos) > 50 then
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



function tableHasValue(table, val)
    for k, value in ipairs(table) do
        if value == val then
            return true
        end
    end

    return false
end




