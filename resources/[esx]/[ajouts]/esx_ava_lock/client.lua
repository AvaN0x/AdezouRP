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