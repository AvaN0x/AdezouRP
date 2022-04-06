-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
-- AddEventHandler("ava_core:client:enteredVehicle", function(vehicle)
--     print(Entity(vehicle).state.id)
-- end)

local LastActionTimer = 0

RegisterCommand("vehicleKey", function()
    if GetGameTimer() - LastActionTimer < 500 then return end
    local vehicle = exports.ava_core:GetVehicleInFront()
    if vehicle == 0 then
        vehicle = exports.ava_core:GetClosestVehicle(1.5)
    end

    if vehicle > 0 then
        LastActionTimer = GetGameTimer()
        exports.ava_core:NetworkRequestControlOfEntity(vehicle)
        TriggerServerEvent("ava_garages:server:tryToLockVehicle", VehToNet(vehicle))

        -- Player animation
        local animDirectory, animName = "anim@mp_player_intmenu@key_fob@", "fob_click_fp"
        RequestAnimDict(animDirectory)
        while not HasAnimDictLoaded(animDirectory) do Wait(0) end
        TaskPlayAnim(PlayerPedId(), animDirectory, animName, 8.0, 8.0, -1, 48, 1, false, false, false)
        RemoveAnimDict(animDirectory)
    end
end)

RegisterKeyMapping("vehicleKey", GetString("vehicle_key"), "keyboard", AVAConfig.VehicleKey)


RegisterNetEvent("ava_garages:client:vehicleDoorsLockAnim", function(vehNet, state)
    local vehicle = NetToVeh(vehNet)
    if vehicle <= 0 then return end

    if state then
        PlayVehicleDoorOpenSound(vehicle, 0)
        exports.ava_core:ShowNotification(GetString("vehicle_keys_vehicle_unlocked"))
    else
        PlayVehicleDoorCloseSound(vehicle, 0)
        exports.ava_core:ShowNotification(GetString("vehicle_keys_vehicle_locked"))
    end

    SetVehicleLights(vehicle, 2)
    Wait(200)
    SetVehicleLights(vehicle, 0)
    Wait(200)
    SetVehicleLights(vehicle, 2)
    Wait(400)
    SetVehicleLights(vehicle, 0)
end)


-------------------
-- Open key menu --
-------------------
