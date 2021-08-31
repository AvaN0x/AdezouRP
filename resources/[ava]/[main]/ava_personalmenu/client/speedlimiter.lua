----------------------------------------------------
------------ MADE BY GITHUB.COM/AVAN0X -------------
------------------- AvaN0x#6348 --------------------
-------------- TOOK INSPIRATION FROM ---------------
---- https://github.com/hojgr/teb_speed_control ----
----------------------------------------------------

AddEventHandler("teb_speed_control:setSpeedLimiter", function(speed)
    if speed > 0 then
        LimitVehicleSpeed(speed)
    else
        ResetCurrentVehicleMaxSpeed()
    end
end)

AddEventHandler("teb_speed_control:stop", function()
    ResetCurrentVehicleMaxSpeed()
end)

local LastSpeedLimitedVehicle = nil
local CurrentMaxSpeedMetersPerSecond = nil
local SpeedDiffTolerance = (2/3.6)
local LastForcedRpm = nil

function KmhToMps(kmh)
    return kmh * (1/3.6)
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if LastSpeedLimitedVehicle then
            local ped = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(ped)
            local newLastForcedRpm = nil

            if vehicle ~= LastSpeedLimitedVehicle then
                ResetVehicleMaxSpeed(LastSpeedLimitedVehicle)
                LastSpeedLimitedVehicle = nil
            else
                local rpm = GetVehicleCurrentRpm(vehicle)
                local curSpeed = GetEntitySpeed(vehicle)

                local diff = CurrentMaxSpeedMetersPerSecond - curSpeed

                if diff < SpeedDiffTolerance then -- lower RPM while speed is max
                    local newRpm = nil
                    if LastForcedRpm then
                        newRpm = LastForcedRpm - 0.03
                        LastForcedRpm = newRpm
                    else
                        newRpm = rpm - 0.03
                        LastForcedRpm = newRpm
                    end
                    if newRpm > 0.35 then
                        SetVehicleCurrentRpm(vehicle, newRpm)
                    end
                end
            end
        end

        LastForcedRpm = newLastForcedRpm
    end
end)

function LimitVehicleSpeed(kmh)
    kmh = kmh - 1 -- reduction of 1 kmh because the vehicle always go higher of 1
    local mpsSpeed = kmh * (1/3.6) -- KmH to Mps

    local vehicle = GetVehiclePedIsIn(PlayerPedId())

    LastSpeedLimitedVehicle = vehicle
    CurrentMaxSpeedMetersPerSecond = mpsSpeed

    SlowDownToLimitSpeed(vehicle, mpsSpeed)

    SetVehicleMaxSpeed(vehicle, mpsSpeed)
end

function SlowDownToLimitSpeed(vehicle, wantedSpeed)
    local timeout = 4.0 -- limits the slowing down to 4 seconds at most

    while timeout > 0.0 do
        Wait(0)

        timeout = timeout - GetFrameTime()

        local speed = GetEntitySpeed(vehicle)
        if wantedSpeed > speed then
            return
        else
            SetControlNormal(0, 72, 1.0)
            SetControlNormal(0, 71, 0.0)
        end
    end
end

function ResetCurrentVehicleMaxSpeed()
    if LastSpeedLimitedVehicle then
        ResetVehicleMaxSpeed(LastSpeedLimitedVehicle)
    else
        ResetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId()))
    end
end

function ResetVehicleMaxSpeed(vehicle)
    local maxSpeed = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
    SetVehicleMaxSpeed(vehicle, maxSpeed)
    LastSpeedLimitedVehicle = nil
    CurrentMaxSpeedMetersPerSecond = nil
    LastForcedRpm = nil
end
