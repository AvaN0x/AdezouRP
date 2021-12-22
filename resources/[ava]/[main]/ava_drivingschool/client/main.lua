-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local GUI = {Time = 0}

local HasAlreadyEnteredMarker = false
local LastZone = nil
local CurrentZoneName = nil
local CurrentHelpText = nil
local CurrentActionEnabled = false

local mainBlips = {}

Citizen.CreateThread(function()
    Wait(1000)

    local blip = AddBlipForCoord(AVAConfig.DrivingSchool.Coord)

    SetBlipSprite(blip, AVAConfig.DrivingSchool.Blip.Sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, AVAConfig.DrivingSchool.Blip.Scale)
    SetBlipColour(blip, AVAConfig.DrivingSchool.Blip.Colour)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(AVAConfig.DrivingSchool.Blip.Name or AVAConfig.DrivingSchool.Name)
    EndTextCommandSetBlipName(blip)

    table.insert(mainBlips, blip)
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        if mainBlips then
            for _, blip in ipairs(mainBlips) do
                RemoveBlip(blip)
            end
        end
        mainBlips = {}
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

-------------
-- Markers --
-------------

Citizen.CreateThread(function()
    while true do
        local waitTimer = 500
        local isInMarker = false
        local currentZoneName = nil

        local distance = #(playerCoords - AVAConfig.DrivingSchool.Coord)
        if distance < AVAConfig.DrawDistance then
            if AVAConfig.DrivingSchool.Marker ~= nil then
                DrawMarker(AVAConfig.DrivingSchool.Marker, AVAConfig.DrivingSchool.Coord.x, AVAConfig.DrivingSchool.Coord.y, AVAConfig.DrivingSchool.Coord.z,
                    0.0, 0.0, 0.0, 0, 0.0, 0.0, AVAConfig.DrivingSchool.Size.x, AVAConfig.DrivingSchool.Size.y, AVAConfig.DrivingSchool.Size.z,
                    AVAConfig.DrivingSchool.Color.r, AVAConfig.DrivingSchool.Color.g, AVAConfig.DrivingSchool.Color.b, 100, false, true, 2, false, false, false,
                    false)
            end
            waitTimer = 0
            if distance < (AVAConfig.DrivingSchool.Distance or AVAConfig.DrivingSchool.Size.x or 1.5) then
                isInMarker = true
                currentZoneName = "DrivingSchool"
            end
        end

        if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and CurrentZoneName ~= currentZoneName) then
            HasAlreadyEnteredMarker = true
            LastZone = currentZoneName
            TriggerEvent("ava_drivingchool:client:hasEnteredMarker", currentZoneName)
        end

        if not isInMarker and HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = false
            TriggerEvent("ava_drivingchool:client:hasExitedMarker", LastZone)
        end
        Wait(waitTimer)
    end
end)

AddEventHandler("ava_drivingchool:client:hasEnteredMarker", function(zoneName)
    if AVAConfig.DrivingSchool.HelpText ~= nil then
        CurrentHelpText = AVAConfig.DrivingSchool.HelpText
    end

    CurrentZoneName = zoneName
    CurrentActionEnabled = true
end)

AddEventHandler("ava_drivingchool:client:hasExitedMarker", function(zoneName)
    RageUI.CloseAllInternal()
    CurrentZoneName = nil
end)

-----------------
-- Key Control --
-----------------
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
            and (GetGameTimer() - GUI.Time) > 300 then
                CurrentActionEnabled = false
                GUI.Time = GetGameTimer()

                OpenDrivingSchoolMenu()
            end
        else
            Wait(50)
        end
    end
end)

function OpenDrivingSchoolMenu()
    local playerLicenses = exports.ava_core:TriggerServerCallback("ava_core:server:getPlayerLicenses") or {}
    local trafficLawsLicense = nil
    local driverLicense = nil

    for i = 1, #playerLicenses do
        if playerLicenses[i].name == "trafficLaws" then
            trafficLawsLicense = playerLicenses[i]
        elseif playerLicenses[i].name == "driver" then
            driverLicense = playerLicenses[i]
        end
    end

    if trafficLawsLicense and driverLicense then
        exports.ava_core:ShowNotification(GetString("driving_school_already_has_licenses"))
        CurrentActionEnabled = true
        return
    end

    local DriverLicenseDisabled = not not driverLicense or not trafficLawsLicense

    RageUI.CloseAll()
    RageUI.OpenTempMenu(GetString("driving_school"), function(Items)
        Items:AddButton(GetString("menu_traffic_laws"), GetString("menu_traffic_laws_subtitle"),
            {RightLabel = GetString("right_label_price", AVAConfig.Prices["trafficLaws"]), IsDisabled = not not trafficLawsLicense}, function(onSelected)
                if onSelected then
                    if exports.ava_core:TriggerServerCallback("ava_drivingschool:server:payForLicense", "trafficLaws") then
                        RageUI.CloseAllInternal()
                        TrafficLawsLicense()
                    else
                        exports.ava_core:ShowNotification(GetString("not_enough_money"))
                    end
                end
            end)
        Items:AddButton(GetString("menu_driver"), DriverLicenseDisabled and GetString("menu_driver_subtitle_disabled") or GetString("menu_driver_subtitle"),
            {RightLabel = GetString("right_label_price", AVAConfig.Prices["driver"]), IsDisabled = DriverLicenseDisabled}, function(onSelected)
                if onSelected then
                    if exports.ava_core:TriggerServerCallback("ava_drivingschool:server:payForLicense", "driver") then
                        RageUI.CloseAllInternal()
                        DriverLicense()
                    else
                        exports.ava_core:ShowNotification(GetString("not_enough_money"))
                    end
                end
            end)

    end, function()
        CurrentActionEnabled = true
    end, AVAConfig.MenuStyle and AVAConfig.MenuStyle.textureName, AVAConfig.MenuStyle and AVAConfig.MenuStyle.textureDirectory)

end
