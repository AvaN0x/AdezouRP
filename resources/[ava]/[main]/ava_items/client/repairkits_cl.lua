-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local isWorking = false

---------------
-- repairkit --
---------------

RegisterNetEvent("ava_items:client:useRepairkit", function(engineHealth)
    if isWorking then
        return
    end

    local playerPed = PlayerPedId()

    if IsPedInAnyVehicle(playerPed, true) then
        exports.ava_core:ShowNotification(GetString("repairkits_cant_inside_vehicle"))
        return
    end

    local vehicle = exports.ava_core:GetVehicleInFrontOrChooseClosest()
    if vehicle == 0 then return end

    isWorking = true
    local duration = 20000

    Citizen.CreateThread(function()
        local animDirectory, animName = "amb@world_human_vehicle_mechanic@male@base", "base"
        RequestAnimDict(animDirectory)
        while not HasAnimDictLoaded(animDirectory) do
            Wait(0)
        end
        FreezeEntityPosition(playerPed, true)
        SetEntityHeading(playerPed, (GetEntityHeading(playerPed) + 180) % 360)
        TaskPlayAnim(playerPed, animDirectory, animName, 2.0, 2.0, duration, 1, 0, false, false, false)
        RemoveAnimDict(animDirectory)

        exports.progressBars:startUI(duration, GetString("repairkits_repairkit_using"))
        Wait(duration)

        SetVehicleEngineHealth(vehicle, engineHealth + 0.0)
        SetVehicleUndriveable(vehicle, false)
        ClearPedTasks(playerPed)
        FreezeEntityPosition(playerPed, false)

        TriggerServerEvent("ava_items:repairkit:remove")
        exports.ava_core:ShowNotification(GetString("repairkits_repairkit_done"))

        isWorking = false
        Wait(1000)
        ClearPedTasksImmediately(playerPed)
        SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
    end)
end)

-------------
-- bodykit --
-------------

RegisterNetEvent("ava_items:client:useBodykit", function()
    if isWorking then
        return
    end

    local playerPed = PlayerPedId()

    if IsPedInAnyVehicle(playerPed, true) then
        exports.ava_core:ShowNotification(GetString("repairkits_cant_inside_vehicle"))
        return
    end

    local vehicle = exports.ava_core:GetVehicleInFrontOrChooseClosest()
    if vehicle == 0 then return end

    isWorking = true
    local duration = 20000

    Citizen.CreateThread(function()
        local animDirectory, animName = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer"
        RequestAnimDict(animDirectory)
        while not HasAnimDictLoaded(animDirectory) do
            Wait(0)
        end
        FreezeEntityPosition(playerPed, true)
        TaskPlayAnim(playerPed, animDirectory, animName, 2.0, 2.0, duration, 1, 0, false, false, false)
        RemoveAnimDict(animDirectory)

        exports.progressBars:startUI(duration, GetString("repairkits_bodykit_using"))
        Wait(duration)
        local engineHealth = GetVehicleEngineHealth(vehicle)

        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)

        SetVehicleEngineHealth(vehicle, engineHealth)

        ClearPedTasks(playerPed)
        FreezeEntityPosition(playerPed, false)
        TriggerServerEvent("ava_items:bodykit:remove")
        exports.ava_core:ShowNotification(GetString("repairkits_bodykit_done"))

        isWorking = false
        Wait(1000)
        ClearPedTasksImmediately(playerPed)
        SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
    end)

end)

-----------
-- rag --
-----------

RegisterNetEvent("ava_items:client:useRag", function()
    if isWorking then
        return
    end

    local playerPed = PlayerPedId()

    if IsPedInAnyVehicle(playerPed, true) then
        exports.ava_core:ShowNotification(GetString("repairkits_cant_inside_vehicle"))
        return
    end

    local vehicle = exports.ava_core:GetVehicleInFrontOrChooseClosest()
    if vehicle == 0 then return end

    isWorking = true
    local duration = 20000
    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_MAID_CLEAN", 0, true)
    Citizen.CreateThread(function()
        exports.progressBars:startUI(duration, GetString("repairkits_rag_using"))
        Wait(duration)

        SetVehicleDirtLevel(vehicle, 0)
        ClearPedTasks(playerPed)

        exports.ava_core:ShowNotification(GetString("repairkits_rag_done"))
        isWorking = false

        Wait(1000)
        ClearPedTasksImmediately(playerPed)
        SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
    end)

end)

-------------
-- blowtorch --
-------------

RegisterNetEvent("ava_items:client:useBlowtorch", function()
    if isWorking then
        return
    end

    local playerPed = PlayerPedId()

    if IsPedInAnyVehicle(playerPed, true) then
        exports.ava_core:ShowNotification(GetString("repairkits_cant_inside_vehicle"))
        return
    end

    local vehicle = exports.ava_core:GetVehicleInFrontOrChooseClosest()
    if vehicle == 0 then return end

    isWorking = true
    local duration = 20000
    Citizen.CreateThread(function()

        local locked = GetVehicleDoorLockStatus(vehicle)
        if locked == 1 or locked == 0 then
            exports.ava_core:ShowNotification(GetString("repairkits_blowtorch_not_closed"))

        else
            TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)

            exports.progressBars:startUI(duration, GetString("repairkits_blowtorch_using"))
            Wait(duration)
            local engineHealth = GetVehicleEngineHealth(vehicle)

            SetVehicleDoorsLocked(vehicle, 1)
            SetVehicleDoorsLockedForAllPlayers(vehicle, false)
            Citizen.InvokeNative(0xDBC631F109350B8C, vehicle, false)

            ClearPedTasks(playerPed)
            FreezeEntityPosition(playerPed, false)

            TriggerServerEvent("ava_items:blowtorch:remove")
            exports.ava_core:ShowNotification(GetString("repairkits_blowtorch_done"))
        end

        isWorking = false
        Wait(1000)
        ClearPedTasksImmediately(playerPed)
        SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
    end)

end)
