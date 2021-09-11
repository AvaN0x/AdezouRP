-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
Citizen.CreateThread(function()
    PlayerData = exports.ava_core:getPlayerData()

    -- mandatory wait!
    Wait(100)

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
    local playerPed = GetPlayerPed(-1)
    if not IsPedSittingInAnyVehicle(playerPed) then
        exports.ava_core:RequestAnimDict("anim@heists@keycard@")
        TaskPlayAnim(playerPed, "anim@heists@keycard@", "exit", 8.0, -8, 1200, 0, 0, 0, 0, 0)

        Wait(1200)
        ClearPedSecondaryTask(playerPed)
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

---Check if a given table has a condition
---@param table table
---@param condition fun(i: index, element: any)
---@return boolean
function TableHasCondition(table, condition)
    if type(table) == "table" and condition then
        for i = 1, #table do
            local element = table[i]
            if condition(i, element) then
                return true
            end
        end
    end
    return false
end

function ShowHelpNotification(text)
    AddTextEntry("AVA_NOTF_TE", text)
    BeginTextCommandDisplayHelp("AVA_NOTF_TE")
    EndTextCommandDisplayHelp(0, false, true, -1)
end
