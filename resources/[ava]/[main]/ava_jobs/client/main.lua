-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local TimeLastAction = 0
PlayerData = {}
playerJobs = {}
playerServices = {}
playerIsAManager = false

local mainBlips = {}
local JobBlips = {}

local HasAlreadyEnteredMarker = false
local CurrentZoneName = nil
local CurrentZoneCategory = nil
local CurrentZoneValue = nil
local CurrentHelpText = nil
local CurrentJobName = nil
CurrentActionEnabled = true

local fieldObjects = {}

Citizen.CreateThread(function()
    PlayerData = exports.ava_core:getPlayerData()

    setJobsToUse()

    -- #region Set blips
    local countMainBlips = 0
    for _, job in pairs(Config.Jobs) do
        if not job.isIllegal and not job.isGang and not job.Disabled then
            local blip = AddBlipForCoord(job.Blip.Coord or job.Zones.ManagerMenu.Coord)
            SetBlipSprite(blip, job.Blip.Sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, job.Blip.Scale or 1.0)
            SetBlipColour(blip, job.Blip.Colour)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(job.Blip.Name or job.LabelName)
            EndTextCommandSetBlipName(blip)

            countMainBlips = countMainBlips + 1
            mainBlips[countMainBlips] = blip
        end
    end

    local jobCenterBlip = AddBlipForCoord(Config.JobCenter.Coord)
    SetBlipSprite(jobCenterBlip, Config.JobCenter.Blip.Sprite)
    SetBlipDisplay(jobCenterBlip, 4)
    SetBlipScale(jobCenterBlip, Config.JobCenter.Blip.Scale or 1.0)
    SetBlipColour(jobCenterBlip, Config.JobCenter.Blip.Colour)
    SetBlipAsShortRange(jobCenterBlip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.JobCenter.Name)
    EndTextCommandSetBlipName(jobCenterBlip)

    countMainBlips = countMainBlips + 1
    mainBlips[countMainBlips] = jobCenterBlip
    -- #endregion Set blips

    -- #region Set garages
    while GetResourceState("ava_garages") ~= "started" do Wait(0) end
    for _, job in pairs(Config.Jobs) do
        if job.Garages then
            for _, garage in pairs(job.Garages) do
                exports.ava_garages:addGarage(garage, true)
            end
        end
    end
    exports.ava_garages:reloadAccessibleGarages()
    -- #endregion Set garages
end)

RegisterNetEvent("ava_core:client:playerUpdatedData", function(data)
    for k, v in pairs(data) do
        PlayerData[k] = v
        if k == "jobs" then
            -- print(json.encode(PlayerData[k], { indent = true }))
            setJobsToUse()
        end
    end
end)

RegisterNetEvent("ava_core:client:playerLoaded", function(data)
    PlayerData = data
    setJobsToUse()

    -- mandatory wait!
    Wait(500)
    -- if player loaded, we remove all objects (we remove them if the player changed of character)
    if fieldObjects then
        for fieldName, field in pairs(fieldObjects) do
            for i = 1, #field do
                exports.ava_core:DeleteObject(field[i].obj)
            end
            fieldObjects[fieldName] = nil
        end
        fieldObjects = {}
    end
end)

RegisterNetEvent("ava_core:client:updateAccountData", function(jobName, accountName, accountBalance)
    print("ava_core:client:updateAccountData", jobName, accountName, accountBalance)
    if accountName == "bank" and playerJobs[jobName] then
        playerJobs[jobName].bankBalance = accountBalance
        playerJobs[jobName].bankBalanceString = exports.ava_core:FormatNumber(playerJobs[jobName].bankBalance)
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        if fieldObjects then
            for k, field in pairs(fieldObjects) do
                for i = 1, #field do
                    exports.ava_core:DeleteObject(field[i].obj)
                end
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

RegisterNetEvent("ava_core:client:jobRemoved", function(jobName)
    local job = Config.Jobs[jobName]
    if fieldObjects and job then
        if job.FieldZones then
            for zoneName, _ in pairs(job.FieldZones) do
                local field = fieldObjects[jobName .. zoneName]
                if field and #field > 0 then
                    for i = 1, #field do
                        exports.ava_core:DeleteObject(field[i].obj)
                    end
                    fieldObjects[jobName .. zoneName] = nil
                end
            end
        end
    end
end)

function setJobsToUse()
    if not PlayerData.jobs then
        return
    end

    CurrentZoneName = nil
    playerJobs = {}
    playerIsAManager = false
    for i = 1, #PlayerData.jobs do
        local job<const> = PlayerData.jobs[i]
        if Config.Jobs[job.name] ~= nil and not Config.Jobs[job.name].Disabled then
            playerJobs[job.name] = Config.Jobs[job.name]
            playerJobs[job.name].grade = job.grade
            playerJobs[job.name].canManage = job.canManage
            playerJobs[job.name].underGrades = job.underGrades
            if job.canManage and not playerJobs[job.name].isGang then
                playerIsAManager = true
                Citizen.CreateThread(function()
                    playerJobs[job.name].bankBalance = exports.ava_core:TriggerServerCallback("ava_core:server:getJobAccountBalance", job.name, "bank")
                    playerJobs[job.name].bankBalanceString = exports.ava_core:FormatNumber(playerJobs[job.name].bankBalance)
                end)
            end
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
                elseif k == "ManagerMenu" then
                    job.Zones[k].Allowed = job.canManage
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
        AddTextComponentSubstringPlayerName("~c~" .. label)
        EndTextCommandSetBlipName(blip)

        countJobBlips = countJobBlips + 1
        JobBlips[countJobBlips] = blip
    end

    for jobName, job in pairs(playerJobs) do
        if job.Zones ~= nil then
            for k, v in pairs(job.Zones) do
                if v.Blip and v.Allowed then
                    addJobBlip(v.Coord, v.Name, job.Blip.Sprite, job.Blip.Colour)
                end
            end
        end
        if job.Blips ~= nil then
            for k, v in pairs(job.Blips) do
                addJobBlip(v.Coord, v.Name, job.Blip.Sprite, job.Blip.Colour)
            end
        end
        if job.FieldZones ~= nil then
            for k, v in pairs(job.FieldZones) do
                if v.Blip and v.Allowed then
                    addJobBlip(v.Coord, v.Name, job.Blip.Sprite, job.Blip.Colour)
                end
            end
        end
        if job.ProcessZones ~= nil then
            for k, v in pairs(job.ProcessZones) do
                if v.Blip and v.Allowed then
                    addJobBlip(v.Coord, v.Name, job.Blip.Sprite, job.Blip.Colour)
                end
            end
        end
        if job.ProcessMenuZones ~= nil then
            for k, v in pairs(job.ProcessMenuZones) do
                if v.Blip and v.Allowed then
                    addJobBlip(v.Coord, v.Name, job.Blip.Sprite, job.Blip.Colour)
                end
            end
        end
        if job.SellZones ~= nil then
            for k, v in pairs(job.SellZones) do
                if v.Blip and v.Allowed then
                    addJobBlip(v.Coord, v.Name, job.Blip.Sprite, job.Blip.Colour)
                end
            end
        end
        if job.BuyZones ~= nil then
            for k, v in pairs(job.BuyZones) do
                if v.Blip and v.Allowed then
                    addJobBlip(v.Coord, v.Name, job.Blip.Sprite, job.Blip.Colour)
                end
            end
        end
    end

    if Config.BankManagment and Config.BankManagment.Blip and playerIsAManager then
        local bankManagmentBlip = AddBlipForCoord(Config.BankManagment.Coord)
        SetBlipSprite(bankManagmentBlip, Config.BankManagment.Blip.Sprite)
        SetBlipDisplay(bankManagmentBlip, 5)
        SetBlipScale(bankManagmentBlip, Config.BankManagment.Blip.Scale or 1.0)
        SetBlipColour(bankManagmentBlip, Config.BankManagment.Blip.Colour)
        SetBlipAsShortRange(bankManagmentBlip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.BankManagment.Name)
        EndTextCommandSetBlipName(bankManagmentBlip)

        countJobBlips = countJobBlips + 1
        JobBlips[countJobBlips] = bankManagmentBlip
    end
end

local playerCoords = nil
playerPed = nil

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
                    if (v.Marker ~= nil and #(playerCoords - v.Coord) < Config.DrawDistance) and v.Allowed then
                        DrawMarker(v.Marker, v.Coord.x, v.Coord.y, v.Coord.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g,
                            v.Color.b, v.Color.a or 100, false, true, 2, false, false, false, false)
                        foundMarker = true
                    end
                end
            end
            if job.ProcessZones ~= nil then
                for k, v in pairs(job.ProcessZones) do
                    if (v.Marker ~= nil and #(playerCoords - v.Coord) < Config.DrawDistance) and v.Allowed then
                        DrawMarker(v.Marker, v.Coord.x, v.Coord.y, v.Coord.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g,
                            v.Color.b, v.Color.a or 100, false, true, 2, false, false, false, false)
                        foundMarker = true
                    end
                end
            end
            if job.ProcessMenuZones ~= nil then
                for k, v in pairs(job.ProcessMenuZones) do
                    if (v.Marker ~= nil and #(playerCoords - v.Coord) < Config.DrawDistance) and v.Allowed then
                        DrawMarker(v.Marker, v.Coord.x, v.Coord.y, v.Coord.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g,
                            v.Color.b, v.Color.a or 100, false, true, 2, false, false, false, false)
                        foundMarker = true
                    end
                end
            end
            if job.SellZones ~= nil then
                for k, v in pairs(job.SellZones) do
                    if (v.Marker ~= nil and #(playerCoords - v.Coord) < Config.DrawDistance) and v.Allowed then
                        DrawMarker(v.Marker, v.Coord.x, v.Coord.y, v.Coord.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g,
                            v.Color.b, v.Color.a or 100, false, true, 2, false, false, false, false)
                        foundMarker = true
                    end
                end
            end
            if job.BuyZones ~= nil then
                for k, v in pairs(job.BuyZones) do
                    if (v.Marker ~= nil and #(playerCoords - v.Coord) < Config.DrawDistance) and v.Allowed then
                        DrawMarker(v.Marker, v.Coord.x, v.Coord.y, v.Coord.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g,
                            v.Color.b, v.Color.a or 100, false, true, 2, false, false, false, false)
                        foundMarker = true
                    end
                end
            end
        end
        if Config.JobCenter ~= nil then
            local v = Config.JobCenter
            if (v.Marker ~= nil and #(playerCoords - v.Coord) < Config.DrawDistance) then
                DrawMarker(v.Marker, v.Coord.x, v.Coord.y, v.Coord.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b,
                    v.Color.a or 100, false, true, 2, false, false, false, false)
                foundMarker = true
            end
        end
        if Config.BankManagment ~= nil and playerIsAManager then
            local v = Config.BankManagment
            if (v.Marker ~= nil and #(playerCoords - v.Coord) < Config.DrawDistance) then
                DrawMarker(v.Marker, v.Coord.x, v.Coord.y, v.Coord.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b,
                    v.Color.a or 100, false, true, 2, false, false, false, false)
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
                    if (#(playerCoords - v.Coord) < (v.Distance or 1.5)) and v.Allowed then
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
                    if (#(playerCoords - v.Coord) < (v.Distance or 2)) and v.Allowed then
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
                    if (#(playerCoords - v.Coord) < (v.Distance or 2)) and v.Allowed then
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
                    if (#(playerCoords - v.Coord) < (v.Distance or 2)) and v.Allowed then
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
                    if (#(playerCoords - v.Coord) < (v.Distance or 2)) and v.Allowed then
                        isInMarker = true
                        zoneJob = jobName
                        zoneCategoryPlayerIsIn = "BuyZones"
                        zoneNamePlayerIsIn = k
                        zonePlayerIsIn = v
                    end
                end
            end
        end
        if fieldObjects then
            for fieldName, field in pairs(fieldObjects) do
                for i = 1, #field do
                    local object = field[i]
                    if object and #(playerCoords - object.coords) < object.distance then
                        isInMarker = true
                        zoneJob = fieldName
                        zoneCategoryPlayerIsIn = "field"
                        zoneNamePlayerIsIn = fieldName .. i
                        zonePlayerIsIn = i
                    end
                end
            end
        end

        if Config.JobCenter ~= nil then
            local v<const> = Config.JobCenter
            if (#(playerCoords - v.Coord) < (v.Distance or 2)) then
                isInMarker = true
                zoneJob = "JobCenter"
                zoneCategoryPlayerIsIn = "JobCenter"
                zoneNamePlayerIsIn = "JobCenter"
                zonePlayerIsIn = v
            end
        end

        if Config.BankManagment ~= nil and playerIsAManager then
            local v<const> = Config.BankManagment
            if (#(playerCoords - v.Coord) < (v.Distance or 2)) then
                isInMarker = true
                zoneJob = "BankManagment"
                zoneCategoryPlayerIsIn = "BankManagment"
                zoneNamePlayerIsIn = "BankManagment"
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
    if zoneCategory == "field" then
        CurrentHelpText = GetString("press_collect")
    else
        CurrentHelpText = zone.HelpText
    end

    CurrentJobName = jobName
    CurrentZoneName = zoneName
    CurrentZoneCategory = zoneCategory
    CurrentZoneValue = zone
    CurrentActionEnabled = true
end)

AddEventHandler("ava_jobs:hasExitedMarker", function(jobName, zoneName, zoneCategory)
    -- In some cases, we have to close a menu from another script
    if not CurrentActionEnabled and CurrentZoneValue and CurrentZoneValue.LSCustom then
        RageUI.CloseAll()
    else
        RageUI.CloseAllInternal()
    end
    CurrentJobName = nil
    CurrentZoneName = nil
    CurrentZoneCategory = nil
    CurrentZoneValue = nil
end)

------------------
-- Key Controls --
------------------
Citizen.CreateThread(function()
    while true do
        Wait(0)

        if CurrentZoneName ~= nil and CurrentActionEnabled then
            if CurrentHelpText ~= nil then
                AddTextEntry("AVA_JBS_NOTF_TE", CurrentHelpText)
                BeginTextCommandDisplayHelp("AVA_JBS_NOTF_TE")
                EndTextCommandDisplayHelp(0, false, true, -1)
            end

            if IsControlJustReleased(0, 38) -- E
                and (GetGameTimer() - TimeLastAction) > 300 then
                CurrentActionEnabled = false
                TimeLastAction = GetGameTimer()
                if CurrentZoneName == "JobCenter" then
                    JobCenterMenu()
                elseif CurrentZoneName == "BankManagment" then
                    BankManagmentMenu()
                else
                    local job = playerJobs[CurrentJobName]

                    if CurrentZoneCategory == "Zones" then
                        if CurrentZoneName == "ManagerMenu" then
                            OpenManagerMenuMenu(CurrentJobName)
                        elseif CurrentZoneName == "Cloakroom" then
                            OpenCloakroomMenu()
                            -- elseif string.match(CurrentZoneName, "Stock$") then
                            --     TriggerEvent("esx_ava_inventories:OpenSharedInventory", CurrentZoneValue.StockName)
                            -- elseif string.match(CurrentZoneName, "Garage$") then
                            --     if CurrentZoneValue.IsNonProprietaryGarage then
                            --         TriggerEvent("esx_ava_garage:openSpecialVehicleMenu", CurrentZoneValue, CurrentJobName)

                            --     else
                            --         TriggerEvent("esx_ava_garage:OpenSocietyVehiclesMenu", job.SocietyName, CurrentZoneValue)
                            --     end
                        elseif CurrentZoneValue.Action then
                            CurrentZoneValue.Action()

                        elseif CurrentZoneValue.LSCustom then
                            exports.ava_stores:OpenLSCustomsMenu(CurrentZoneValue, CurrentJobName)
                        end
                    elseif CurrentZoneCategory == "field" then
                        Harvest(fieldObjects[CurrentJobName], CurrentZoneValue)

                    elseif CurrentZoneCategory == "ProcessZones" then
                        ProcessZone(job)

                    elseif CurrentZoneCategory == "ProcessMenuZones" then
                        if not exports.ava_core:canOpenMenu() then
                            return
                        end
                        ProcessMenuZone(job)

                    elseif CurrentZoneCategory == "SellZones" then
                        SellZone(job)

                    elseif CurrentZoneCategory == "BuyZones" then
                        BuyZone(job)

                    end
                end

            end
        else
            Wait(50)
        end
    end
end)

local function applyClothesAnimation()
    local playerPed = PlayerPedId()
    exports.ava_core:RequestAnimDict("mp_safehouseshower@male@")
    TaskPlayAnim(playerPed, "mp_safehouseshower@male@", "male_shower_towel_dry_to_get_dressed", 8.0, -8, 9500, 0, 0, 0, 0, 0)
    RemoveAnimDict("mp_safehouseshower@male@")

    exports.progressBars:startUI(9500, "")
    Wait(9500)
    ClearPedSecondaryTask(playerPed)
end

function OpenCloakroomMenu()
    if not exports.ava_core:canOpenMenu() then
        return
    end
    local playerSkin = exports.ava_core:getPlayerSkinData()

    local jobName = CurrentJobName
    local job = playerJobs[jobName]
    local zoneOutfits, outfits = CurrentZoneValue.Outfits

    if zoneOutfits then
        outfits = {}
        local count = 0
        for i = 1, #zoneOutfits do
            local outfit = zoneOutfits[i]
            if outfit[playerSkin.gender == 0 and "Male" or "Female"] then
                outfit.IsDisabled = outfit.MinimumGrade and job.grade ~= outfit.MinimumGrade and not tableHasValue(job.underGrades, outfit.MinimumGrade)
                count = count + 1
                outfits[count] = outfit
            end
        end
    end

    RageUI.CloseAll()
    RageUI.OpenTempMenu(GetString("cloakroom"), function(Items)
        Items:AddButton(GetString("clothes_civil"), GetString("clothes_civil_subtitle"), nil, function(onSelected)
            if onSelected then
                applyClothesAnimation()
                exports.ava_mp_peds:setPlayerSkin(playerSkin)
            end
        end)
        Items:AddButton(GetString("user_clothes"), GetString("user_clothes_subtitle"), nil, function(onSelected)
            if onSelected then
                TriggerEvent("ava_stores:client:OpenPlayerOutfitsMenu")
            end
        end)
        if job.ServiceCounter then
            Items:CheckBox(GetString("take_service"), GetString("take_service_subtitle"), playerServices[jobName], nil, function(onSelected, IsChecked)
                if (onSelected) then
                    playerServices[jobName] = not playerServices[jobName]
                    TriggerServerEvent("ava_jobs:server:setService", jobName, playerServices[jobName])
                end
            end)
        end
        if outfits then
            for i = 1, #outfits do
                local outfit = outfits[i]

                Items:AddButton(outfit.Label, outfit.Desc, { IsDisabled = outfit.IsDisabled }, function(onSelected)
                    if onSelected then
                        applyClothesAnimation()
                        exports.ava_mp_peds:setPlayerClothes(outfit[playerSkin.gender == 0 and "Male" or "Female"])
                    end
                end)
            end
        end
    end, function()
        CurrentActionEnabled = true
    end)
end

function Process(process, pos)
    local canProcess = exports.ava_core:TriggerServerCallback("ava_jobs:canprocess", process, CurrentJobName)
    if canProcess then
        TriggerServerEvent("ava_jobs:server:process", process)
        local timeLeft = process.Delay / 1000

        exports["progressBars"]:startUI(process.Delay, GetString("process_in_progress"))
        TaskStartScenarioInPlace(playerPed, process.Scenario, 0, true)
        while timeLeft > 0 do
            Wait(1000)
            timeLeft = timeLeft - 1

            if #(playerCoords - (process.Coord or pos)) > 2 then
                TriggerServerEvent("ava_jobs:server:cancelProcessing")
                break
            end
        end
        Wait(1500)
        ClearPedTasks(playerPed)
        SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"), true)

        if process.Scenario == "WORLD_HUMAN_CLIPBOARD" then
            ClearAreaOfObjects(playerCoords.x, playerCoords.y, playerCoords.z, 0.5, 0)
        end
    end
    return canProcess
end

function ProcessZone(job)
    Process(CurrentZoneValue)
    CurrentActionEnabled = true
end

function ProcessMenuZone(job)
    local elements = {}
    for k, v in pairs(CurrentZoneValue.Process) do
        table.insert(elements, { label = v.Name, desc = v.Desc, delay = v.Delay, value = v })
    end

    RageUI.CloseAll()
    RageUI.OpenTempMenu(CurrentZoneValue.Title, function(Items)
        for i = 1, #elements do
            local element = elements[i]
            Items:AddButton(element.label, element.desc, nil, function(onSelected)
                if onSelected then
                    RageUI.GoBack()
                    local count = tonumber(exports.ava_core:KeyboardInput(GetString("process_how_much", CurrentZoneValue.MaxProcess), "", 10))

                    if type(count) == "number" and math.floor(count) == count and count > 0 and count <= CurrentZoneValue.MaxProcess then
                        for i = 1, count, 1 do
                            if not Process(element.value, CurrentZoneValue.Coord) then
                                break
                            end
                            Wait(500)
                        end
                    else
                        exports.ava_core:ShowNotification(GetString("invalid_quantity"))
                    end
                    CurrentActionEnabled = true
                end
            end)
        end
    end, function()
        CurrentActionEnabled = true
    end)

end

function SellZone(job)
    local elements = exports.ava_core:TriggerServerCallback("ava_jobs:getSellElements", CurrentJobName, CurrentZoneName)
    if not elements then
        return
    end

    RageUI.CloseAll()
    RageUI.OpenTempMenu(GetString("buyer_for", job.LabelName), function(Items)
        for i = 1, #elements do
            local element = elements[i]
            Items:AddButton(element.label, element.desc, nil, function(onSelected)
                if onSelected then
                    RageUI.GoBack()
                    local count = tonumber(exports.ava_core:KeyboardInput(GetString("sell_how_much", element.owned), "", 10))

                    if type(count) == "number" and math.floor(count) == count and count > 0 then
                        if tonumber(count) > tonumber(element.owned) then
                            exports.ava_core:ShowNotification(GetString("sell_not_that_much", element.itemLabel))
                        else
                            TriggerServerEvent("ava_jobs:server:sellItems", CurrentJobName, CurrentZoneName, element.name, count)
                        end
                    else
                        exports.ava_core:ShowNotification(GetString("invalid_quantity"))
                    end
                    CurrentActionEnabled = true
                end
            end)
        end
    end, function()
        CurrentActionEnabled = true
    end)
end

function BuyZone(job)
    local items = exports.ava_core:TriggerServerCallback("ava_jobs:GetBuyElements", CurrentJobName, CurrentZoneName)
    if not items then
        return
    end

    local elements = {}
    local count = 0
    for i = 1, #items do
        local item = items[i]
        count = count + 1
        elements[count] = {
            label = item.label,
            rightLabel = GetString("buy_item_right_label", item.isDirtyMoney and "~r~" or "", item.price),
            leftBadge = not item.noIcon and function()
                return { BadgeDictionary = "ava_items", BadgeTexture = item.name }
            end or nil,
            price = item.price,
            name = item.name,
            maxCanTake = item.maxCanTake,
            desc = item.desc,
        }
    end

    if count > 0 then
        RageUI.CloseAll()
        RageUI.OpenTempMenu(GetString("seller_for", job.LabelName), function(Items)
            for i = 1, #elements do
                local element = elements[i]
                Items:AddButton(element.label, element.desc, { RightLabel = element.rightLabel, LeftBadge = element.leftBadge }, function(onSelected)
                    if onSelected then
                        local count = tonumber(exports.ava_core:KeyboardInput(GetString("buy_how_much_max", element.maxCanTake or 0), "", 10))

                        if type(count) == "number" and math.floor(count) == count and count > 0 then
                            if count > element.maxCanTake then
                                exports.ava_core:ShowNotification(GetString("buy_cant_carry"))
                            else
                                TriggerServerEvent("ava_jobs:server:buyItem", CurrentJobName, CurrentZoneName, element.name, count)
                                RageUI.CloseAllInternal()
                            end
                        else
                            exports.ava_core:ShowNotification(GetString("invalid_quantity"))
                        end
                    end
                end)
            end
        end, function()
            CurrentActionEnabled = true
        end)
    else
        exports.ava_core:ShowNotification(GetString("buy_nothing_can_buy"))
    end

end

-------------
-- Harvest --
-------------

Citizen.CreateThread(function()
    while true do
        Wait(200)
        for jobName, job in pairs(playerJobs) do
            if job.FieldZones then
                for k, v in pairs(job.FieldZones) do
                    if #(playerCoords - v.Coord) < 20 then
                        SpawnPlants(jobName, k, v)
                    end
                end
            end
            Wait(500)
        end
    end
end)

function Harvest(field, i)
    local object = field[i]
    if object then
        CurrentActionEnabled = false

        local canPickUp = exports.ava_core:TriggerServerCallback("ava_jobs:canPickUp", object.jobName, object.zoneName)
        if canPickUp then
            TaskStartScenarioInPlace(playerPed, "world_human_gardener_plant", 0, false)

            exports["progressBars"]:startUI(2000, GetString("harvest_in_progress"))
            Wait(2000)
            ClearPedTasks(playerPed)

            exports.ava_core:DeleteObject(object.obj)
            table.remove(field, i)

            TriggerServerEvent("ava_jobs:server:pickUp", object.jobName, object.zoneName)
        else
            exports.ava_core:ShowNotification(GetString("inventoryfull"))
        end

        CurrentZoneName = nil
        CurrentActionEnabled = true
    end
end

local function ValidateplantCoord(plantCoord, jobName, zoneName, zone)
    local field = fieldObjects[jobName .. zoneName]

    -- check if coords are not too close from an other plant
    if #field > 0 then
        if not zone.DistanceValidate then
            zone.DistanceValidate = zone.Radius / 2
        end
        for i = 1, #field do
            if #(plantCoord - field[i].coords) < zone.DistanceValidate then
                return false
            end
        end
    end

    -- coords should not be at a distance superior to 50 from central point
    if #(plantCoord - zone.Coord) > 50 then
        return false
    end
    return true
end

local function GetObjectCoordZ(x, y, zone)
    -- we use MinGroundHeight and MaxGroundHeight to be try and get the lowest possible ground
    for i = zone.MinGroundHeight or (zone.Coord.z - 2.0), zone.MaxGroundHeight or (zone.Coord.z + 2.0), 1 do
        local foundGround, z = GetGroundZFor_3dCoord(x, y, i + 0.0)

        if foundGround then
            return z
        end
    end

    return zone.Coord.z
end

local function GeneratePlantCoords(jobName, zoneName, zone)
    local coords
    repeat
        Wait(0)
        if (zone.Radius == nil) then
            zone.Radius = 8
        end

        local x = zone.Coord.x + math.random(-zone.Radius, zone.Radius)
        local y = zone.Coord.y + math.random(-zone.Radius, zone.Radius)
        local z = GetObjectCoordZ(x, y, zone)

        coords = vector3(x, y, z)
    until ValidateplantCoord(coords, jobName, zoneName, zone)
    return coords
end

function SpawnPlants(jobName, zoneName, zone)
    if type(fieldObjects[jobName .. zoneName]) ~= "table" then
        fieldObjects[jobName .. zoneName] = {}
    end
    local field = fieldObjects[jobName .. zoneName]

    while #field < 5 do
        Wait(0)
        local plantCoords = GeneratePlantCoords(jobName, zoneName, zone)

        local obj = exports.ava_core:SpawnObjectLocal(zone.PropHash, plantCoords)
        PlaceObjectOnGroundProperly(obj)
        FreezeEntityPosition(obj, true)

        table.insert(field, { obj = obj, jobName = jobName, zoneName = zoneName, coords = GetEntityCoords(obj), distance = zone.Distance or 1.3 })
    end
end

----------------
-- Job Center --
----------------

function JobCenterMenu()
    if not exports.ava_core:canOpenMenu() then
        return
    end
    local elements = {}

    for i = 1, #Config.JobCenter.JobList, 1 do
        local element = Config.JobCenter.JobList[i]
        table.insert(elements, { index = i, Label = element.Label, Desc = element.Desc })
    end

    RageUI.CloseAll()
    RageUI.OpenTempMenu(GetString("job_center"), function(Items)
        Items:AddButton(GetString("job_center_unsubscribe"), GetString("job_center_unsubscribe_subtitle"), nil, function(onSelected)
            if onSelected then
                TriggerServerEvent("ava_jobs:server:job_center:unsubscribe")
                RageUI.GoBack()
                CurrentActionEnabled = true
            end
        end)
        for i = 1, #elements do
            local element = elements[i]
            Items:AddButton(element.Label, element.Desc, nil, function(onSelected)
                if onSelected then
                    TriggerServerEvent("ava_jobs:server:job_center:subscribe", element.index)
                    RageUI.GoBack()
                    CurrentActionEnabled = true
                end
            end)
        end
    end, function()
        CurrentActionEnabled = true
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
