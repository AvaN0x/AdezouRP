-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
RegisterNetEvent('esx_ava_lock:dooranim')
AddEventHandler('esx_ava_lock:dooranim', function()
    local playerPed = GetPlayerPed(-1)
    if not IsPedSittingInAnyVehicle(playerPed) then
        ESX.Streaming.RequestAnimDict("anim@heists@keycard@", function()
            TaskPlayAnim(playerPed, "anim@heists@keycard@", "exit", 8.0, -8, 1200, 0, 0, 0, 0, 0)

            Citizen.Wait(1200)
            ClearPedSecondaryTask(playerPed)
        end)
    end
end)

function DrawText3D(x, y, z, text, size)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    
    if onScreen then
        SetTextScale(0.35, size or 0.35)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        SetTextOutline()

        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)
        -- local factor = (string.len(text)) / 350
        -- DrawRect(_x, _y + 0.0125, factor + 0.015, 0.03, 35, 35, 35, 150)
    end
end