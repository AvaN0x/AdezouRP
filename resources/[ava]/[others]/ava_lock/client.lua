-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
importGlobal("DrawText3D")
import("table:has")

Citizen.CreateThread(function()
    PlayerData = exports.ava_core:getPlayerData()

    TriggerEvent("ava_lock:client:reloadAuthorizations")
end)

RegisterNetEvent("ava_core:client:playerUpdatedData", function(data)
    for k, v in pairs(data) do
        PlayerData[k] = v
        if k == "jobs" then
            TriggerEvent("ava_lock:client:reloadAuthorizations")
        end
    end
end)

RegisterNetEvent("ava_core:client:playerLoaded", function(data)
    PlayerData = data
    TriggerEvent("ava_lock:client:reloadAuthorizations")
end)

AddEventHandler("ava_lock:client:dooranim", function()
    local playerPed = PlayerPedId()
    if not IsPedSittingInAnyVehicle(playerPed) then
        exports.ava_core:RequestAnimDict("anim@heists@keycard@")
        TaskPlayAnim(playerPed, "anim@heists@keycard@", "exit", 8.0, -8, 1200, 0, 0, 0, 0, 0)
        RemoveAnimDict("anim@heists@keycard@")

        Wait(1200)
        ClearPedSecondaryTask(playerPed)
    end
end)

function ShowHelpNotification(text)
    AddTextEntry("AVA_NOTF_HELP", text)
    BeginTextCommandDisplayHelp("AVA_NOTF_HELP")
    EndTextCommandDisplayHelp(0, false, true, -1)
end
