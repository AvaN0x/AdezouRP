-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local testVehicle = 0
local testVehicleHealth = nil
local currentSpeedType = nil
local isInsideTestVehicle = false
local isPassive = false

local countErrors = 0

function DriverLicense()
    RageUI.CloseAll()

    startDrivingTest()
    -- TriggerServerEvent("ava_drivingschool:client:passedDrivingTest", 0)
end

function spawnDrivingCar()
    local playerPed = PlayerPedId()
    -- Spawns vehicle
    testVehicle = exports.ava_core:SpawnVehicle(AVAConfig.DriverTest.vehicleHash, AVAConfig.DriverTest.vehicleCoord.xyz, AVAConfig.DriverTest.vehicleCoord.w)
    TriggerServerEvent("ava_drivingschool:server:setDrivingTestVehicle", VehToNet(testVehicle))
    -- TODO set vehicle fuel
    SetVehRadioStation(testVehicle, "OFF")
    SetEntityAsMissionEntity(testVehicle)
    TaskWarpPedIntoVehicle(playerPed, testVehicle, -1)
    isInsideTestVehicle = true
    testVehicleHealth = GetEntityHealth(testVehicle)

    -- Set player passive
    isPassive = true
    NetworkSetPlayerIsPassive(true)
    SetNetworkVehicleAsGhost(testVehicle, true)
    SetLocalPlayerAsGhost(true, false)

    SetVehicleDoorsLocked(testVehicle, 4)

    Citizen.CreateThread(function()
        -- Let the player and vehicle be passive and ghost while at the spawning point
        local SpawnCoords<const> = AVAConfig.DriverTest.vehicleCoord.xyz
        local vehicleCoords
        repeat
            vehicleCoords = GetEntityCoords(testVehicle)
            Wait(500)
            DrawMissionText(GetString("drive_to_the_road_on_right"), 500)
        until (not IsPositionOccupied(SpawnCoords.x, SpawnCoords.y, SpawnCoords.z, 4.0, false, true, false, false, false, testVehicle, false)
            and #(vehicleCoords - SpawnCoords) > 5.0)

        Wait(1500)

        print("Vehicle back to normal")
        SetVehicleDoorsLocked(testVehicle, 0)

        NetworkSetPlayerIsPassive(false)
        SetNetworkVehicleAsGhost(testVehicle, false)
        SetLocalPlayerAsGhost(false, false)
        isPassive = false
    end)
end

function startDrivingTest()
    playerIsPassingTest = true
    Citizen.CreateThread(function()
        spawnDrivingCar()
        currentSpeedType = AVAConfig.DriverTest.DefaultSpeedType
        exports.ava_core:ShowNotification(GetString("new_driving_speed_limit_" .. currentSpeedType, AVAConfig.DriverTest.Speeds[currentSpeedType]), nil,
            "CHAR_BEVERLY", GetString("driving_school"), GetString("driving_test"))

        while playerIsPassingTest and countErrors >= 0 do
            local newHealth = GetEntityHealth(testVehicle)
            if newHealth < testVehicleHealth then
                countErrors = countErrors + 1
                showAndHideNotification(GetString("you_damaged_the_vehicle", tostring(countErrors)), nil, "CHAR_BEVERLY", GetString("driving_school"),
                    GetString("driving_test"))
            end
            testVehicleHealth = newHealth

            if AVAConfig.DriverTest.Speeds[currentSpeedType] and math.ceil(GetEntitySpeed(testVehicle) * 3.6)
                > (AVAConfig.DriverTest.Speeds[currentSpeedType] + 3) then
                countErrors = countErrors + 1
                showAndHideNotification(GetString("you_are_driving_too_fast", AVAConfig.DriverTest.Speeds[currentSpeedType], tostring(countErrors)), nil,
                    "CHAR_BEVERLY", GetString("driving_school"), GetString("driving_test"))
                Wait(1000)
            end

            -- TODO checkpoints things
            Wait(500)
        end

        if countErrors == -1 then
            -- FAILED
            exports.ava_core:ShowNotification(GetString("driving_test_failed_gaveup_or_destroyed"), nil, "CHAR_BEVERLY", GetString("driving_school"),
                GetString("driving_test"))
        else
            TriggerServerEvent("ava_drivingschool:client:drivingTestScore", countErrors)
        end

        testVehicle = 0
        testVehicleHealth = nil
    end)
end

local function DrawPlayerIsNotInsideVehicle()
    if not isInsideTestVehicle then
        return
    end
    isInsideTestVehicle = false

    Citizen.CreateThread(function()
        while playerIsPassingTest and not isInsideTestVehicle do
            Wait(100)
            DrawMissionText(GetString("you_are_not_inside_the_vehicle"), 100)

            if testVehicleHealth == 0 or not DoesEntityExist(testVehicle) then
                Wait(0)
                countErrors = -1
                playerIsPassingTest = false
                DrawMissionText(GetString("your_vehicle_cannot_be_driven"), 5000)
            end
        end
    end)
end

-- Entering and leaving vehicle events
AddEventHandler("ava_core:client:enteringVehicle", function(vehicle)
    if vehicle ~= testVehicle and Entity(vehicle).state.drivingTestVehicle then
        ClearPedTasks(PlayerPedId())
        SetVehicleIsConsideredByPlayer(vehicle, false)
    end
end)

AddEventHandler("ava_core:client:enteredVehicle", function(vehicle)
    if testVehicle ~= 0 then
        if vehicle == testVehicle then
            isInsideTestVehicle = true
        else
            countErrors = -1
            playerIsPassingTest = false
            Wait(0)
            DrawMissionText(GetString("you_gave_up_the_test"), 5000)
        end
    elseif vehicle ~= testVehicle and Entity(vehicle).state.drivingTestVehicle then
        TaskLeaveVehicle(PlayerPedId(), vehicle, 16)
        SetVehicleIsConsideredByPlayer(vehicle, false)
    end
end)

AddEventHandler("ava_core:client:leftVehicle", function(vehicle)
    if vehicle == testVehicle then
        DrawPlayerIsNotInsideVehicle()
    end
end)

-- On resource stop
AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        if isPassive then
            NetworkSetPlayerIsPassive(false)
            SetNetworkVehicleAsGhost(testVehicle, false)
            SetLocalPlayerAsGhost(false, false)
        end
        if testVehicle ~= 0 then
            SetEntityAsMissionEntity(testVehicle)
            DeleteVehicle(testVehicle)
            testVehicle = 0
            print("Deleted test vehicle")

            -- FIXME DELETE THIS
            SetEntityCoords(PlayerPedId(), AVAConfig.DrivingSchool.Coord)
        end
    end
end)

-- Utils
function DrawMissionText(text, duration)
    -- TODO problem, it shows behind car HUD
    ClearPrints()
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName(text or "")
    EndTextCommandPrint(duration or 1000, true)
end

local lastNotification = 0
function showAndHideNotification(...)
    if lastNotification then
        ThefeedRemoveItem(lastNotification)
    end
    lastNotification = exports.ava_core:ShowNotification(...)
end