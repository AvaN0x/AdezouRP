-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local currentGamePromise = nil

function StartMinigame()
    if currentGamePromise then
        print("[DEBUG] Game already started")
        return false
    end
    currentGamePromise = promise.new()
    SetNuiFocus(true, true)
    SendNUIMessage({type = "openGeneral"})

    local success = Citizen.Await(currentGamePromise)
    currentGamePromise = nil
    SetNuiFocus(false, false)
    SendNUIMessage({type = "closeAll"})
    print("[DEBUG] success ", success)

    return not not success
end
exports("StartMinigame", StartMinigame)

RegisterNUICallback("NUIFocusOff", function(data, cb)
    currentGamePromise:resolve(false)
    cb({success = true})
end)
RegisterNUICallback("NUILose", function(data, cb)
    currentGamePromise:resolve(false)
    cb({success = true})
end)
RegisterNUICallback("NUIWin", function(data, cb)
    currentGamePromise:resolve(true)
    cb({success = true})
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() and currentGamePromise then
        currentGamePromise:resolve(false)
    end
end)

