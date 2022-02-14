-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local LastActionTimer = 0

PlayerData = nil
local AccessibleGarages = {}

local HasAlreadyEnteredMarker = false
local LastGarage = nil
CurrentGarageIndex = nil
CurrentActionEnabled = false

local blips = {}

Citizen.CreateThread(function()
    PlayerData = exports.ava_core:getPlayerData()
    setAccessibleGarages()
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        ClearBlips()
    end
end)

local playerCoords = nil
local playerPed = nil

Citizen.CreateThread(function()
    while true do
        playerPed = PlayerPedId()
        playerCoords = GetEntityCoords(playerPed)
        Wait(500)
    end
end)

-----------------------
-- AccessibleGarages --
-----------------------
RegisterNetEvent("ava_core:client:playerUpdatedData", function(data)
    for k, v in pairs(data) do
        PlayerData[k] = v
        if k == "jobs" then
            setAccessibleGarages()
        end
    end
end)

RegisterNetEvent("ava_core:client:playerLoaded", function(data)
    PlayerData = data
    setAccessibleGarages()
end)

function setAccessibleGarages()
    ClearBlips()
    AccessibleGarages = {}
    local count = 0
    for _, garage in pairs(AVAConfig.Garages) do
        local add = false
        if garage.JobNeeded then
            for i = 1, #PlayerData.jobs do
                if PlayerData.jobs[i].name == garage.JobNeeded then
                    add = true
                    if garage.IsJobGarage then
                        garage.canManage = PlayerData.jobs[i].canManage
                    end
                    break
                end
            end
        else
            add = true
        end

        if add then
            count = count + 1
            AccessibleGarages[count] = garage
        end
    end

    -- #region blips
    for _, v in pairs(AccessibleGarages) do
        if v.Blip then
            local blip = AddBlipForCoord(v.Blip.Coord or v.Coord)

            SetBlipSprite(blip, v.Blip.Sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, v.Blip.Scale or 0.6)
            SetBlipColour(blip, v.Blip.Color)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.Blip.Name or GetString("garage"))
            EndTextCommandSetBlipName(blip)

            table.insert(blips, blip)
        end
    end
    -- #endregion blips
end

function ClearBlips()
    if blips then
        for _, blip in ipairs(blips) do
            RemoveBlip(blip)
        end
    end
    blips = {}
end

---------------
-- AddGarage --
---------------

local addGarage = function(data)
    -- TODO add garage, used for job garages, appartements and things
end
exports("addGarage", addGarage)

-------------
-- Markers --
-------------

Citizen.CreateThread(function()
    while true do
        local wait = 500
        local isInMarker = false
        local currentGarageIndex = nil

        for k, v in pairs(AccessibleGarages) do
            local distance = #(playerCoords - v.Coord)
            if distance < AVAConfig.DrawDistance then
                if v.Marker ~= nil then
                    wait = 0
                    DrawMarker(v.Marker, v.Coord.x, v.Coord.y, v.Coord.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g,
                        v.Color.b, 100, false, true, 2, false, false, false, false)
                end
                if distance < (v.Distance or v.Size.x or 1.5) then
                    isInMarker = true
                    currentGarageIndex = k
                end
            end
        end

        if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and CurrentGarageIndex ~= currentGarageIndex) then
            HasAlreadyEnteredMarker = true
            LastGarage = currentGarageIndex
            TriggerEvent("ava_garages:client:hasEnteredMarker", currentGarageIndex)
        end

        if not isInMarker and HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = false
            TriggerEvent("ava_garages:client:hasExitedMarker", LastGarage)
        end
        Wait(wait)
    end
end)

AddEventHandler("ava_garages:client:hasEnteredMarker", function(zoneName)
    CurrentGarageIndex = zoneName
    CurrentActionEnabled = true
end)

AddEventHandler("ava_garages:client:hasExitedMarker", function(zoneName)
    RageUI.CloseAllInternal()
    CurrentGarageIndex = nil
end)

-----------------
-- Key Control --
-----------------
Citizen.CreateThread(function()
    while true do
        local wait = 50
        if CurrentGarageIndex ~= nil and CurrentActionEnabled then
            wait = 0
            SetTextComponentFormat("STRING")
            AddTextComponentString(GetString("press_open_garage"))
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)

            if IsControlJustReleased(0, 38) -- E
            and (GetGameTimer() - LastActionTimer) > 300 then
                CurrentActionEnabled = false
                LastActionTimer = GetGameTimer()
                local garage<const> = AccessibleGarages[CurrentGarageIndex]

                if garage.Insurance then
                    OpenInsuranceMenu(garage)
                elseif garage.Pound then
                    OpenPoundMenu(garage)
                else
                    OpenGarageMenu(garage)
                end
            end
        end
        Wait(0)
    end
end)
