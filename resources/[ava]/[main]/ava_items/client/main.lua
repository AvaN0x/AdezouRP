-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
RegisterNetEvent("ava_items:client:useLockpick", function()
    if GetResourceState("ava_lockpicking") ~= "started" then
        print("^8[AVA] Lockpicking resource is not started! (^3ava_lockpicking^0)")
        return
    end
    local playerPed<const> = PlayerPedId()
    local playerCoords<const> = GetEntityCoords(playerPed)
    if IsAnyVehicleNearPoint(playerCoords.x, playerCoords.y, playerCoords.z, 2.0) and not IsPedInAnyVehicle(playerPed, false) then
        local vehicle = GetClosestVehicle(playerCoords.x, playerCoords.y, playerCoords.z, 5.0, 0, 71)
        if DoesEntityExist(vehicle) then
            TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
            local minigameSuccess<const> = exports.ava_lockpicking:StartMinigame()
            ClearPedTasksImmediately(playerPed)
            TriggerServerEvent("ava_items:server:usedLockpick", minigameSuccess)
            if minigameSuccess then
                exports.ava_core:ShowNotification(GetString("lockpick_success"))
                SetVehicleDoorsLocked(vehicle, 1)
                SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                Citizen.InvokeNative(0xDBC631F109350B8C, vehicle, false)
            else
                exports.ava_core:ShowNotification(GetString("lockpick_fail"))
            end
        end
    end
end)

