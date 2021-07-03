-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

local windows = {
    VEH_EXT_WINDSCREEN = 0,
    VEH_EXT_WINDSCREEN_R = 1,
    VEH_EXT_WINDOW_LF = 2,
    VEH_EXT_WINDOW_RF = 3,
    VEH_EXT_WINDOW_LR = 4,
    VEH_EXT_WINDOW_RR = 5,
    VEH_EXT_WINDOW_LM = 6,
    VEH_EXT_WINDOW_RM = 7
}

local isWorking = false

---------------
-- repairkit --
---------------

RegisterNetEvent('esx_avan0x:repairkit')
AddEventHandler('esx_avan0x:repairkit', function(engineHealth)
    if isWorking then
        return
    end

	local playerPed = PlayerPedId()

    if IsPedInAnyVehicle(playerPed, true) then
        ESX.ShowNotification(_('repairkits_cant_inside_vehicle'))
        return
    end

    exports.esx_avan0x:GetVehicleInFrontOrChooseClosestVehicle(function(vehicle)
        isWorking = true
        local duration = 20000
        -- TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
        Citizen.CreateThread(function()
            local animDirectory, animName = "amb@world_human_vehicle_mechanic@male@base", "base"
            RequestAnimDict(animDirectory)
            while not HasAnimDictLoaded(animDirectory) do
                Citizen.Wait(0)
            end
            FreezeEntityPosition(playerPed, true)
            SetEntityHeading(playerPed, (GetEntityHeading(playerPed) + 180) % 360)
            TaskPlayAnim(playerPed, animDirectory, animName, 2.0, 2.0, duration, 1, 0, false, false, false)
            RemoveAnimDict(animDirectory)

            exports.progressBars:startUI(duration, _("repairkits_repairkit_using"))
            Citizen.Wait(duration)

            SetVehicleEngineHealth(vehicle, engineHealth + 0.0)
            SetVehicleUndriveable(vehicle, false)
            ClearPedTasks(playerPed)
            FreezeEntityPosition(playerPed, false)

            TriggerServerEvent('esx_avan0x:repairkit:remove')
            ESX.ShowNotification(_('repairkits_repairkit_done'))

            isWorking = false
            Citizen.Wait(1000)
            ClearPedTasksImmediately(playerPed)
            SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
        end)
    end)
end)

-------------
-- bodykit --
-------------

RegisterNetEvent('esx_avan0x:bodykit')
AddEventHandler('esx_avan0x:bodykit', function()
    if isWorking then
        return
    end

	local playerPed = PlayerPedId()

    if IsPedInAnyVehicle(playerPed, true) then
        ESX.ShowNotification(_('repairkits_cant_inside_vehicle'))
        return
    end

    exports.esx_avan0x:GetVehicleInFrontOrChooseClosestVehicle(function(vehicle)
        isWorking = true
        local duration = 20000
        -- TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_HAMMERING", 0, true)
        Citizen.CreateThread(function()
            local animDirectory, animName = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer"
            RequestAnimDict(animDirectory)
            while not HasAnimDictLoaded(animDirectory) do
                Citizen.Wait(0)
            end
            FreezeEntityPosition(playerPed, true)
            TaskPlayAnim(playerPed, animDirectory, animName, 2.0, 2.0, duration, 1, 0, false, false, false)
            RemoveAnimDict(animDirectory)

            exports.progressBars:startUI(duration, _("repairkits_bodykit_using"))
            Citizen.Wait(duration)
            local engineHealth = GetVehicleEngineHealth(vehicle)

            SetVehicleFixed(vehicle)
            SetVehicleDeformationFixed(vehicle)

            SetVehicleEngineHealth(vehicle, engineHealth)

            ClearPedTasks(playerPed)
            FreezeEntityPosition(playerPed, false)
            TriggerServerEvent('esx_avan0x:bodykit:remove')
            ESX.ShowNotification(_('repairkits_bodykit_done'))

            isWorking = false
            Citizen.Wait(1000)
            ClearPedTasksImmediately(playerPed)
            SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
        end)
	end)
end)

-----------
-- cloth --
-----------

RegisterNetEvent('esx_avan0x:cloth')
AddEventHandler('esx_avan0x:cloth', function()
    if isWorking then
        return
    end

    local playerPed = PlayerPedId()

    if IsPedInAnyVehicle(playerPed, true) then
        ESX.ShowNotification(_('repairkits_cant_inside_vehicle'))
        return
    end

    exports.esx_avan0x:GetVehicleInFrontOrChooseClosestVehicle(function(vehicle)
        isWorking = true
        local duration = 20000
        TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_MAID_CLEAN", 0, true)
        Citizen.CreateThread(function()
            exports.progressBars:startUI(duration, _("repairkits_cloth_using"))
            Citizen.Wait(duration)

            SetVehicleDirtLevel(vehicle, 0)
            ClearPedTasks(playerPed)

            ESX.ShowNotification(_('repairkits_cloth_done'))
            isWorking = false

            Citizen.Wait(1000)
            ClearPedTasksImmediately(playerPed)
            SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
        end)
    end)
end)

