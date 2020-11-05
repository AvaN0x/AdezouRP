-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

RegisterNetEvent('esx_avan0x:blipgps')
AddEventHandler('esx_avan0x:blipgps', function()
    local playerPed = GetPlayerPed(-1)
    local vehicle = ESX.Game.GetVehicleInDirection()

    if DoesEntityExist(vehicle) then
        RequestAnimDict("amb@code_human_police_investigate@idle_b")
        while not HasAnimDictLoaded("amb@code_human_police_investigate@idle_b") do
            Citizen.Wait(0)
        end

        TaskPlayAnim(playerPed, "amb@code_human_police_investigate@idle_b", "idle_f", 8.0, 1.0, -1, 1, 0, 0, 0, 0)

        Citizen.Wait(8000)
        ClearPedTasks(playerPed)

        TriggerServerEvent('esx_avan0x:useBlipgps')

        SetEntityAsMissionEntity(vehicle)

        local blip = AddBlipForEntity(vehicle)
        SetBlipSprite(blip, 56)
        SetBlipColour(blip, 1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Balise GPS')
        EndTextCommandSetBlipName(blip)

        PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

        ESX.ShowNotification("Balise GPS placée", true, true, nil)

        Citizen.Wait(3600000)
        RemoveBlip(blip)
    else
        ESX.ShowHelpNotification('Pas de véhicule à proximité')
    end
end)









