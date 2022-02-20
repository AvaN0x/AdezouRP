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

        SetVehicleDoorsLocked(testVehicle, 0)

        NetworkSetPlayerIsPassive(false)
        SetNetworkVehicleAsGhost(testVehicle, false)
        SetLocalPlayerAsGhost(false, false)
        isPassive = false
    end)
end

function startDrivingTest()
    playerIsPassingTest = true
    countErrors = 0

    Citizen.CreateThread(function()
        spawnDrivingCar()
        currentSpeedType = AVAConfig.DriverTest.DefaultSpeedType
        exports.ava_core:ShowNotification(GetString("new_driving_speed_limit_" .. currentSpeedType, AVAConfig.DriverTest.Speeds[currentSpeedType]), nil,
            "CHAR_BEVERLY", GetString("driving_school"), GetString("driving_test"))

        local cannotHaveSpeedError = 0 -- Will go down to zero if above zero
        local i = 1
        SetCheckpointAtIndex(i)
        while playerIsPassingTest and countErrors >= 0 do
            -- Health error handling
            local newHealth = GetEntityHealth(testVehicle)
            if newHealth < testVehicleHealth then
                countErrors = countErrors + 1
                showAndHideNotification(GetString("you_damaged_the_vehicle", tostring(countErrors), AVAConfig.DriverTest.MaxNumberOfErrorsAccepted), nil,
                    "CHAR_BEVERLY", GetString("driving_school"), GetString("driving_test"))
            end
            testVehicleHealth = newHealth

            -- Speed error handling
            if cannotHaveSpeedError > 0 then
                cannotHaveSpeedError = cannotHaveSpeedError - 1
            end
            -- If speed is above speed limit + 3
            if cannotHaveSpeedError == 0 and AVAConfig.DriverTest.Speeds[currentSpeedType] and math.ceil(GetEntitySpeed(testVehicle) * 3.6)
                > (AVAConfig.DriverTest.Speeds[currentSpeedType] + 3) then
                countErrors = countErrors + 1
                showAndHideNotification(GetString("you_are_driving_too_fast", AVAConfig.DriverTest.Speeds[currentSpeedType], tostring(countErrors),
                    AVAConfig.DriverTest.MaxNumberOfErrorsAccepted), nil, "CHAR_BEVERLY", GetString("driving_school"), GetString("driving_test"))
                cannotHaveSpeedError = 7 -- cannotSpeedError * 250 ms
            end

            -- Checkpoints handling
            local checkpointCoords = AVAConfig.DriverTest.Checkpoints[i].Coord
            if isInsideTestVehicle and #(GetEntityCoords(testVehicle) - checkpointCoords) < 8.0 then
                PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", false)
                local checkpointData<const> = AVAConfig.DriverTest.Checkpoints[i]

                -- Change speed limit type
                if checkpointData.ChangeSpeedType then
                    currentSpeedType = checkpointData.ChangeSpeedType
                    exports.ava_core:ShowNotification(GetString("new_driving_speed_limit_" .. currentSpeedType, AVAConfig.DriverTest.Speeds[currentSpeedType]),
                        nil, "CHAR_BEVERLY", GetString("driving_school"), GetString("driving_test"))
                end

                if checkpointData.MissionText then
                    DrawMissionText(checkpointData.MissionText, 5000)
                end

                i = i + 1
                if i > #AVAConfig.DriverTest.Checkpoints then
                    playerIsPassingTest = false
                    break
                end
                SetCheckpointAtIndex(i)
            end
            Wait(250)
        end

        SetCheckpointAtIndex(#AVAConfig.DriverTest.Checkpoints + 1)
        if countErrors == -1 then
            -- FAILED
            exports.ava_core:ShowNotification(GetString("driving_test_failed_gaveup_or_destroyed"), nil, "CHAR_BEVERLY", GetString("driving_school"),
                GetString("driving_test"))
        else
            TriggerServerEvent("ava_drivingschool:client:drivingTestScore", countErrors)
        end

        if testVehicle then
            exports.ava_core:DeleteVehicle(testVehicle)
        end

        testVehicle = 0
        testVehicleHealth = nil
    end)
end

local currentCheckpoint = 0
local currentBlip = 0
local nextBlip = 0
local function createNextBlip(x, y, z)
    local blip = AddBlipForCoord(x, y, z)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(GetString("driving_test"))
    EndTextCommandSetBlipName(blip)
    SetBlipSprite(blip, 1)
    SetBlipColour(blip, 5)
    SetBlipScale(blip, 0.4)
    return blip
end

function SetCheckpointAtIndex(i)
    if currentCheckpoint then
        DeleteCheckpoint(currentCheckpoint)
        currentCheckpoint = 0
    end

    -- One checkpoint too much, used to delete checkpoint and blip
    if i > #AVAConfig.DriverTest.Checkpoints then
        if currentBlip then
            RemoveBlip(currentBlip)
            currentBlip = 0
        end
        if nextBlip then
            RemoveBlip(nextBlip)
            nextBlip = 0
        end
        return
    end

    local checkpointData<const> = AVAConfig.DriverTest.Checkpoints[i]
    -- Blips logic
    -- If first checkpoint, we need to create the first blip as nextBlip for it to become the currentBlip
    if i == 1 then
        nextBlip = createNextBlip(checkpointData.Coord.x, checkpointData.Coord.y, checkpointData.Coord.z)
    end

    -- Next blip will become current blip
    if currentBlip then
        RemoveBlip(currentBlip)
        currentBlip = 0
    end
    currentBlip = nextBlip
    nextBlip = 0
    SetBlipScale(currentBlip, 0.8)
    SetBlipRoute(currentBlip, true)

    -- If is last checkpoint
    if i == #AVAConfig.DriverTest.Checkpoints then
        currentCheckpoint = CreateCheckpoint(4, checkpointData.Coord.x, checkpointData.Coord.y, checkpointData.Coord.z, 0.0, 0.0, 0.0, 4.0,
            AVAConfig.DriverTest.CheckpointColor.r, AVAConfig.DriverTest.CheckpointColor.g, AVAConfig.DriverTest.CheckpointColor.b, 180, 0)

    else
        local nextCheckpointData<const> = AVAConfig.DriverTest.Checkpoints[i + 1]
        currentCheckpoint = CreateCheckpoint(0, checkpointData.Coord.x, checkpointData.Coord.y, checkpointData.Coord.z, nextCheckpointData.Coord.x,
            nextCheckpointData.Coord.y, nextCheckpointData.Coord.z, 4.0, AVAConfig.DriverTest.CheckpointColor.r, AVAConfig.DriverTest.CheckpointColor.g,
            AVAConfig.DriverTest.CheckpointColor.b, 180, 0)

        -- Create a new next blip
        nextBlip = createNextBlip(nextCheckpointData.Coord.x, nextCheckpointData.Coord.y, nextCheckpointData.Coord.z)

    end
    SetCheckpointRgba2(currentCheckpoint, AVAConfig.DriverTest.CheckpointIconColor.r, AVAConfig.DriverTest.CheckpointIconColor.g,
        AVAConfig.DriverTest.CheckpointIconColor.b, 200)
    SetCheckpointCylinderHeight(currentCheckpoint, 1.0, 1.0, 3.0)
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
            exports.ava_core:DeleteVehicle(testVehicle)
            testVehicle = 0
            print("Deleted test vehicle")

            -- FIXME DELETE THIS
            SetEntityCoords(PlayerPedId(), AVAConfig.DrivingSchool.Coord)
        end
    end
end)

-- Utils
function DrawMissionText(text, duration)
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

-- Citizen.CreateThread(function()
--     Wait(1000)
--     for i = 1, #AVAConfig.DriverTest.Checkpoints do
--         local blip = AddBlipForCoord(AVAConfig.DriverTest.Checkpoints[i].Coord.x, AVAConfig.DriverTest.Checkpoints[i].Coord.y,
--             AVAConfig.DriverTest.Checkpoints[i].Coord.z)
--         SetBlipColour(blip, AVAConfig.DriverTest.Checkpoints[i].ChangeSpeedType and 48 or AVAConfig.DriverTest.Checkpoints[i].MissionText and 1 or 5)
--         SetBlipScale(blip, 0.6)

--         BeginTextCommandSetBlipName("STRING")
--         AddTextComponentSubstringPlayerName(AVAConfig.DriverTest.Checkpoints[i].ChangeSpeedType and tostring(AVAConfig.DriverTest.Checkpoints[i].ChangeSpeedType)
--                                    or AVAConfig.DriverTest.Checkpoints[i].MissionText and tostring(AVAConfig.DriverTest.Checkpoints[i].MissionText)
--                                    or tostring(i))
--         EndTextCommandSetBlipName(blip)
--     end
-- end)
