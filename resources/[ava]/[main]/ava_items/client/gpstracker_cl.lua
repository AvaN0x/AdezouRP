-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

RegisterNetEvent("ava_items:client:useGPSTracker", function()
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed, true) then
        exports.ava_core:ShowNotification(GetString("gpstracker_cant_inside_vehicle"))
        return
    end

    local vehicle = GetVehicleInFrontOrChooseClosestVehicle()
    if not vehicle then
        return
    end

    -- Start anim
    local animDirectory, animName = "amb@code_human_police_investigate@idle_b", "idle_f"
    RequestAnimDict(animDirectory)
    while not HasAnimDictLoaded(animDirectory) do Wait(0) end
    FreezeEntityPosition(playerPed, true)
    TaskPlayAnim(playerPed, animDirectory, animName, 8.0, 1.0, -1, 1, 0, false, false, false)
    RemoveAnimDict(animDirectory)

    -- Wait anim duration
    Wait(8000)
    TriggerServerEvent("ava_items:server:gpstracker:remove")
    ClearPedTasks(playerPed)
    FreezeEntityPosition(playerPed, false)

    local blip = AddBlipForEntity(vehicle)
    SetBlipSprite(blip, 56)
    SetBlipColour(blip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(GetString("gpstracker"))
    EndTextCommandSetBlipName(blip)

    PlaySoundFrontend(-1, "BACK", "HUD_AMMO_SHOP_SOUNDSET", false)

    -- Remove the blip after 30 minutes
    Citizen.SetTimeout(30 * 60 * 1000, function()
        RemoveBlip(blip)
    end)
end)
