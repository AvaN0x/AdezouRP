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
    reloadAccessibleGarages()
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        ClearBlips()
    else
        -- Remove garages from this resource
        local modified = false
        for i = #AVAConfig.Garages, 1, -1 do
            if AVAConfig.Garages[i].InvokingResource == resource then
                table.remove(AVAConfig.Garages, i)
                modified = true
            end
        end
        if modified then
            reloadAccessibleGarages()
        end
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
            reloadAccessibleGarages()
        end
    end
end)

RegisterNetEvent("ava_core:client:playerLoaded", function(data)
    PlayerData = data
    reloadAccessibleGarages()
end)

reloadAccessibleGarages = function()
    while not PlayerData do Wait(5) end

    ClearBlips()
    AccessibleGarages = {}
    local count = 0
    for _, garage in ipairs(AVAConfig.Garages) do
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
    for _, v in ipairs(AccessibleGarages) do
        if v.Blip then
            local blip = AddBlipForCoord(v.Blip.Coord or v.Coord)

            SetBlipSprite(blip, v.Blip.Sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, v.Blip.Scale or 0.6)
            SetBlipColour(blip, v.Blip.Color)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(v.Blip.Name or GetString("garage"))
            EndTextCommandSetBlipName(blip)

            table.insert(blips, blip)
        end
    end
    -- #endregion blips
end
exports("reloadAccessibleGarages", reloadAccessibleGarages)


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

local addGarage = function(data, noReloadGarageList)
    if type(data) ~= "table"
        or not data.Name
        or not data.Coord
        or not data.Size
        or not data.Color
        or not data.SpawnPoint
        or not data.SpawnPoint.Coord
        or not data.SpawnPoint.Heading then
        print("^1[AVA]^0 Missing data for garage, check the config file to figure out what is missing")
        return
    end

    data.InvokingResource = GetInvokingResource()
    table.insert(AVAConfig.Garages, data)

    if not noReloadGarageList then
        reloadAccessibleGarages()
    end
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

        for k, v in ipairs(AccessibleGarages) do
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
            AddTextComponentSubstringPlayerName(GetString("press_open_garage"))
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


function canTakeOutVehicle(garage)
    if exports.ava_core:IsPlayerInVehicle() then return false end
    if IsPositionOccupied(garage.SpawnPoint.Coord.x, garage.SpawnPoint.Coord.y, garage.SpawnPoint.Coord.z, 0.7, false, true, false, false, false, 0, false) then
        exports.ava_core:ShowNotification(GetString("garage_area_is_occupied"))
        return false
    end
    return true
end

function takeOutVehicle(garage, model, id)
    local vehicle = exports.ava_core:SpawnVehicle(model, garage.SpawnPoint.Coord, garage.SpawnPoint.Heading)
    if vehicle then
        TriggerServerEvent("ava_garages:server:spawnedVehicle", VehToNet(vehicle), id, garage.IsCommonGarage, garage.Name)
        SetVehRadioStation(vehicle, "OFF")
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)

        -- keys
    end
end
