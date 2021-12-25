-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local testVehicle = 0
local isInsideTestVehicle = false
local isPassive = false

function DriverLicense()
    RageUI.CloseAll()
    print("DriverLicense")
    spawnDrivingCar()
    startDrivingTest()
    -- TriggerServerEvent("ava_drivingschool:client:passedDrivingTest", 0)
end

function spawnDrivingCar()
    Citizen.CreateThread(function()
        local playerPed = PlayerPedId()
        -- Spawns vehicle
        testVehicle =
            exports.ava_core:SpawnVehicle(AVAConfig.DriverTest.vehicleHash, AVAConfig.DriverTest.vehicleCoord.xyz, AVAConfig.DriverTest.vehicleCoord.w)
        TriggerServerEvent("ava_drivingschool:server:setDrivingTestVehicle", VehToNet(testVehicle))
        -- TODO set vehicle fuel
        SetVehRadioStation(testVehicle, "OFF")
        SetEntityAsMissionEntity(testVehicle)
        TaskWarpPedIntoVehicle(playerPed, testVehicle, -1)
        isInsideTestVehicle = true

        -- Set player passive
        isPassive = true
        NetworkSetPlayerIsPassive(true)
        SetNetworkVehicleAsGhost(testVehicle, true)
        SetLocalPlayerAsGhost(true, false)

        SetVehicleDoorsLocked(testVehicle, 4)

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
        while playerIsPassingTest do
            Wait(1000)
            -- TODO checkpoints things
        end
        testVehicle = 0
    end)
end

local function DrawPlayerIsNotInsideVehicle()
    if not isInsideTestVehicle then
        return
    end
    isInsideTestVehicle = false

    Citizen.CreateThread(function()
        while playerIsPassingTest and not isInsideTestVehicle do
            Wait(0)
            DrawMissionText(GetString("you_are_not_inside_the_vehicle"), 0)
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
