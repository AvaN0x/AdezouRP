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
AddEventHandler('esx_avan0x:repairkit', function()
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
        TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
        Citizen.CreateThread(function()
            exports.progressBars:startUI(20000, _("repairkits_repairkit_using"))
            Citizen.Wait(20000)

            -- TODO if is mechanic, full repair, if not, only repair the minimum
            SetVehicleEngineHealth(vehicle, 1000.0)
            SetVehicleUndriveable(vehicle, false)
            ClearPedTasks(playerPed)

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
        TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_HAMMERING", 0, true)
        Citizen.CreateThread(function()
            exports.progressBars:startUI(20000, _("repairkits_bodykit_using"))
            Citizen.Wait(20000)
            local engineHealth = GetVehicleEngineHealth(vehicle)

            SetVehicleFixed(vehicle)
            SetVehicleDeformationFixed(vehicle)

            SetVehicleEngineHealth(vehicle, engineHealth)

            ClearPedTasks(playerPed)
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
        TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_MAID_CLEAN", 0, true)
        Citizen.CreateThread(function()
            exports.progressBars:startUI(20000, _("repairkits_cloth_using"))
            Citizen.Wait(20000)

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

