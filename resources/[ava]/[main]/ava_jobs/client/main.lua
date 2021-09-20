-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local TimeLastAction = 0
PlayerData = {}
playerJobs = {}
playerServices = {}

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
    PlayerData = exports.ava_core:getPlayerData()

    -- mandatory wait!
    Wait(100)

    setJobsToUse()

    -- #region Set blips
    local countMainBlips = 0
    for _, job in pairs(Config.Jobs) do
        if not job.isIllegal and not job.isGang and not job.Disabled then
            local blip = AddBlipForCoord(job.Blip.Pos or job.Zones.JobActions.Pos)
            SetBlipSprite(blip, job.Blip.Sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 1.0)
            SetBlipColour(blip, job.Blip.Colour)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(job.Blip.Name or job.LabelName)
            EndTextCommandSetBlipName(blip)

            countMainBlips = countMainBlips + 1
            mainBlips[countMainBlips] = blip
        end
    end

    local jobCenterBlip = AddBlipForCoord(Config.JobCenter.Pos)
    SetBlipSprite(jobCenterBlip, Config.JobCenter.Blip.Sprite)
    SetBlipDisplay(jobCenterBlip, 4)
    SetBlipScale(jobCenterBlip, 1.0)
    SetBlipColour(jobCenterBlip, Config.JobCenter.Blip.Colour)
    SetBlipAsShortRange(jobCenterBlip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.JobCenter.Blip.Name)
    EndTextCommandSetBlipName(jobCenterBlip)

    countMainBlips = countMainBlips + 1
    mainBlips[countMainBlips] = jobCenterBlip
    -- #endregion Set blips
end)

RegisterNetEvent("ava_core:client:playerUpdatedData", function(data)
    for k, v in pairs(data) do
        PlayerData[k] = v
        if k == "jobs" then
            print(json.encode(PlayerData[k], {indent = true}))
            setJobsToUse()
        end
    end
end)

RegisterNetEvent("ava_core:client:playerLoaded", function(data)
    PlayerData = data
    setJobsToUse()
end)

AddEventHandler("onResourceStop", function(resource)
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
    if not PlayerData.jobs then
        return
    end

    CurrentZoneName = nil
    playerJobs = {}
    for i = 1, #PlayerData.jobs do
        local job<const> = PlayerData.jobs[i]
        if Config.Jobs[job.name] ~= nil and not Config.Jobs[job.name].Disabled then
            playerJobs[job.name] = Config.Jobs[job.name]
            playerJobs[job.name].grade = job.grade
            playerJobs[job.name].canManage = job.canManage
            playerJobs[job.name].underGrades = job.underGrades
        end
    end
    for name, farm in pairs(Config.Jobs) do
        if farm.isIllegal == true and not farm.Disabled then
            playerJobs[name] = farm
        end
    end

    for job, value in pairs(playerServices) do
        if not playerJobs[job] then
            if value then
                TriggerServerEvent("ava_jobs:setService", job, false)
            end
            playerServices[job] = nil
        end
    end

    checkAuthorizations()
    createBlips()
end

-- Citizen.CreateThread(function()
--     Wait(500)
--     while true do
--         for jobName, job in pairs(playerJobs) do
--             print(jobName .. " : " .. (job.SocietyName or "no society name") .. " - " .. (job.grade or "no grade") .. " - "
--                       .. (job.canManage and "true" or "false"))
--         end
--         Wait(50000)
--     end
-- end)

function checkAuthorizations()
    for jobName, job in pairs(playerJobs) do
        if job.Zones ~= nil then
            for k, v in pairs(job.Zones) do
                if job.isIllegal then
                    job.Zones[k].Allowed = true
                else
                    job.Zones[k].Allowed = not v.MinimumGrade or (job.grade == v.MinimumGrade or tableHasValue(job.underGrades, v.MinimumGrade))
                end
            end
        end
        if job.FieldZones ~= nil then
            for k, v in pairs(job.FieldZones) do
                job.FieldZones[k].Allowed = job.isIllegal
                                                or (not v.MinimumGrade or (job.grade == v.MinimumGrade or tableHasValue(job.underGrades, v.MinimumGrade)))
            end
        end
        if job.ProcessZones ~= nil then
            for k, v in pairs(job.ProcessZones) do
                job.ProcessZones[k].Allowed = job.isIllegal
                                                  or (not v.MinimumGrade or (job.grade == v.MinimumGrade or tableHasValue(job.underGrades, v.MinimumGrade)))
            end
        end
        if job.ProcessMenuZones ~= nil then
            for k, v in pairs(job.ProcessMenuZones) do
                job.ProcessMenuZones[k].Allowed = job.isIllegal
                                                      or (not v.MinimumGrade or (job.grade == v.MinimumGrade or tableHasValue(job.underGrades, v.MinimumGrade)))
            end
        end
        if job.SellZones ~= nil then
            for k, v in pairs(job.SellZones) do
                job.SellZones[k].Allowed = job.isIllegal
                                               or (not v.MinimumGrade or (job.grade == v.MinimumGrade or tableHasValue(job.underGrades, v.MinimumGrade)))
            end
        end
        if job.BuyZones ~= nil then
            for k, v in pairs(job.BuyZones) do
                job.BuyZones[k].Allowed = job.isIllegal
                                              or (not v.MinimumGrade or (job.grade == v.MinimumGrade or tableHasValue(job.underGrades, v.MinimumGrade)))
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
    clearJobBlips()
    local countJobBlips = 0
    local function addJobBlip(coords, label, sprite, colour)
        local blip = AddBlipForCoord(coords)

        SetBlipSprite(blip, sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, colour)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("~c~" .. label)
        EndTextCommandSetBlipName(blip)

        countJobBlips = countJobBlips + 1
        JobBlips[countJobBlips] = blip
    end

    for jobName, job in pairs(playerJobs) do
        if job.Zones ~= nil then
            for k, v in pairs(job.Zones) do
                if v.Blip and v.Allowed then
                    addJobBlip(v.Pos, v.Name, job.Blip.Sprite, job.Blip.Colour)
                end
            end
        end
        if job.Blips ~= nil then
            for k, v in pairs(job.Blips) do
                addJobBlip(v.Pos, v.Name, job.Blip.Sprite, job.Blip.Colour)
            end
        end
        if job.FieldZones ~= nil then
            for k, v in pairs(job.FieldZones) do
                if v.Blip and v.Allowed then
                    addJobBlip(v.Pos, v.Name, job.Blip.Sprite, job.Blip.Colour)
                end
            end
        end
        if job.ProcessZones ~= nil then
            for k, v in pairs(job.ProcessZones) do
                if v.Blip and v.Allowed then
                    addJobBlip(v.Pos, v.Name, job.Blip.Sprite, job.Blip.Colour)
                end
            end
        end
        if job.ProcessMenuZones ~= nil then
            for k, v in pairs(job.ProcessMenuZones) do
                if v.Blip and v.Allowed then
                    addJobBlip(v.Pos, v.Name, job.Blip.Sprite, job.Blip.Colour)
                end
            end
        end
        if job.SellZones ~= nil then
            for k, v in pairs(job.SellZones) do
                if v.Blip and v.Allowed then
                    addJobBlip(v.Pos, v.Name, job.Blip.Sprite, job.Blip.Colour)
                end
            end
        end
        if job.BuyZones ~= nil then
            for k, v in pairs(job.BuyZones) do
                if v.Blip and v.Allowed then
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
                    if (v.Marker ~= nil and #(playerCoords - v.Pos) < Config.DrawDistance) and v.Allowed then
                        DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g,
                            v.Color.b, 100, false, true, 2, false, false, false, false)
                        foundMarker = true
                    end
                end
            end
            if job.ProcessZones ~= nil then
                for k, v in pairs(job.ProcessZones) do
                    if (v.Marker ~= nil and #(playerCoords - v.Pos) < Config.DrawDistance) and v.Allowed then
                        DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g,
                            v.Color.b, 100, false, true, 2, false, false, false, false)
                        foundMarker = true
                    end
                end
            end
            if job.ProcessMenuZones ~= nil then
                for k, v in pairs(job.ProcessMenuZones) do
                    if (v.Marker ~= nil and #(playerCoords - v.Pos) < Config.DrawDistance) and v.Allowed then
                        DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g,
                            v.Color.b, 100, false, true, 2, false, false, false, false)
                        foundMarker = true
                    end
                end
            end
            if job.SellZones ~= nil then
                for k, v in pairs(job.SellZones) do
                    if (v.Marker ~= nil and #(playerCoords - v.Pos) < Config.DrawDistance) and v.Allowed then
                        DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g,
                            v.Color.b, 100, false, true, 2, false, false, false, false)
                        foundMarker = true
                    end
                end
            end
            if job.BuyZones ~= nil then
                for k, v in pairs(job.BuyZones) do
                    if (v.Marker ~= nil and #(playerCoords - v.Pos) < Config.DrawDistance) and v.Allowed then
                        DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g,
                            v.Color.b, 100, false, true, 2, false, false, false, false)
                        foundMarker = true
                    end
                end
            end
        end
        if Config.JobCenter ~= nil then
            local v = Config.JobCenter
            if (v.Marker ~= nil and #(playerCoords - v.Pos) < Config.DrawDistance) then
                DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100,
                    false, true, 2, false, false, false, false)
                foundMarker = true
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
        local isInMarker = false
        local zoneNamePlayerIsIn = nil
        local zoneCategoryPlayerIsIn = nil
        local zonePlayerIsIn = nil
        local zoneJob = nil

        for jobName, job in pairs(playerJobs) do
            if job.Zones ~= nil then
                for k, v in pairs(job.Zones) do
                    if (#(playerCoords - v.Pos) < (v.Distance or 1.5)) and v.Allowed then
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
                    if (#(playerCoords - v.Pos) < (v.Distance or 2)) and v.Allowed then
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
                    if (#(playerCoords - v.Pos) < (v.Distance or 2)) and v.Allowed then
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
                    if (#(playerCoords - v.Pos) < (v.Distance or 2)) and v.Allowed then
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
                    if (#(playerCoords - v.Pos) < (v.Distance or 2)) and v.Allowed then
                        isInMarker = true
                        zoneJob = jobName
                        zoneCategoryPlayerIsIn = "BuyZones"
                        zoneNamePlayerIsIn = k
                        zonePlayerIsIn = v
                    end
                end
            end

        end
        if Config.JobCenter ~= nil then
            local v<const> = Config.JobCenter
            if (#(playerCoords - v.Pos) < (v.Distance or 2)) then
                isInMarker = true
                zoneJob = "JobCenter"
                zoneCategoryPlayerIsIn = "JobCenter"
                zoneNamePlayerIsIn = "JobCenter"
                zonePlayerIsIn = v
            end
        end

        if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and CurrentZoneName ~= zoneNamePlayerIsIn) then
            HasAlreadyEnteredMarker = true
            TriggerEvent("ava_jobs:hasEnteredMarker", zoneJob, zoneNamePlayerIsIn, zoneCategoryPlayerIsIn, zonePlayerIsIn)
        end

        if not isInMarker and HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = false
            TriggerEvent("ava_jobs:hasExitedMarker", zoneJob, CurrentZoneName, CurrentZoneCategory)
        end
    end
end)

AddEventHandler("ava_jobs:hasEnteredMarker", function(jobName, zoneName, zoneCategory, zone)
    if zone.HelpText ~= nil then
        CurrentHelpText = zone.HelpText
    end

    CurrentJobName = jobName
    CurrentZoneName = zoneName
    CurrentZoneCategory = zoneCategory
    CurrentZoneValue = zone
    CurrentActionEnabled = true
end)

AddEventHandler("ava_jobs:hasExitedMarker", function(jobName, zoneName, zoneCategory)
    RageUI.CloseAllInternal()
    CurrentZoneName = nil
end)

------------------
-- Key Controls --
------------------
Citizen.CreateThread(function()
    while true do
        Wait(0)

        if CurrentZoneName ~= nil and CurrentActionEnabled then
            if CurrentHelpText ~= nil then
                SetTextComponentFormat("STRING")
                AddTextComponentString(CurrentHelpText)
                DisplayHelpTextFromStringLabel(0, 0, 1, -1)
            end

            if IsControlJustReleased(0, 38) -- E
            and (GetGameTimer() - TimeLastAction) > 300 then
                CurrentActionEnabled = false
                TimeLastAction = GetGameTimer()
                if CurrentZoneName == "JobCenter" then
                    JobCenterMenu()
                else
                    local job = playerJobs[CurrentJobName]

                    if CurrentZoneCategory == "Zones" then
                        if CurrentZoneName == "JobActions" then
                            -- OpenJobActionsMenu(CurrentJobName)
                        elseif CurrentZoneName == "Dressing" then
                            OpenCloakroomMenu()
                            -- elseif string.match(CurrentZoneName, "Stock$") then
                            --     TriggerEvent("esx_ava_inventories:OpenSharedInventory", CurrentZoneValue.StockName)
                            -- elseif string.match(CurrentZoneName, "Garage$") then
                            --     if CurrentZoneValue.IsNonProprietaryGarage then
                            --         TriggerEvent("esx_ava_garage:openSpecialVehicleMenu", CurrentZoneValue, CurrentJobName)

                            --     else
                            --         TriggerEvent("esx_ava_garage:OpenSocietyVehiclesMenu", job.SocietyName, CurrentZoneValue)
                            --     end
                            -- elseif CurrentZoneValue.Action then
                            --     CurrentZoneValue.Action()
                        end

                        -- elseif CurrentZoneCategory == "ProcessZones" then
                        --     ProcessZone(job)

                        -- elseif CurrentZoneCategory == "ProcessMenuZones" then
                        --     ProcessMenuZone(job)

                        -- elseif CurrentZoneCategory == "SellZones" then
                        --     SellZone(job)

                        -- elseif CurrentZoneCategory == "BuyZones" then
                        --     BuyZone(job)

                    end
                end

            end
        else
            Wait(50)
        end
    end
end)
function OpenCloakroomMenu()
    local jobName = CurrentJobName
    local job = playerJobs[jobName]
    local outfits = CurrentZoneValue.Outfits

    if outfits then
        for i = 1, #outfits do
            local outfit = outfits[i]
            outfit.IsDisabled = outfit.MinimumGrade and job.grade ~= outfit.MinimumGrade and not tableHasValue(job.underGrades, outfit.MinimumGrade)
        end
    end

    RageUI.CloseAll()
    RageUI.OpenTempMenu(GetString("cloakroom"), function(Items)
        Items:AddButton(GetString("clothes_civil"), GetString("clothes_civil_subtitle"), nil, function(onSelected)
            if onSelected then
                local skin = exports.ava_core:getPlayerSkinData()
                TriggerEvent("skinchanger:loadSkin", skin)
            end
        end)
        Items:AddButton(GetString("user_clothes"), GetString("user_clothes_subtitle"), nil, function(onSelected)
            if onSelected then
                local skin = exports.ava_core:getPlayerSkinData()
                TriggerEvent("skinchanger:loadSkin", skin)
            end
        end)
        Items:CheckBox(GetString("take_service"), GetString("take_service_subtitle"), playerServices[jobName], nil, function(onSelected, IsChecked)
            if (onSelected) then
                playerServices[jobName] = not playerServices[jobName]
                TriggerServerEvent("ava_jobs:setService", jobName, playerServices[jobName])
            end
        end)
        if outfits then
            for i = 1, #outfits do
                local outfit = outfits[i]

                Items:AddButton(outfit.Label, outfit.Desc, {IsDisabled = outfit.IsDisabled}, function(onSelected)
                    if onSelected then
                        TriggerEvent("skinchanger:getSkin", function(skin)
                            TriggerEvent("skinchanger:loadClothes", skin, skin.sex == 0 and outfit.Male or outfit.Female)
                        end)
                    end
                end)
            end
        end
    end)
end

-----------
-- Utils --
-----------

function tableHasValue(table, val)
    for k, value in ipairs(table) do
        if value == val then
            return true
        end
    end

    return false
end

