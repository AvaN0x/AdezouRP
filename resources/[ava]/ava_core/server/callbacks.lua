-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local callbacks = {}

RegisterNetEvent("ava_core:callbacks:server", function(eventName, requestId, ...)
    local src = source
    local result

    if type(callbacks[eventName]) == "function" or (type(callbacks[eventName]) == "table" and callbacks[eventName]["__cfx_functionReference"] ~= nil) then
        result = { callbacks[eventName](src, ...) }

        TriggerClientEvent(("ava_core:callbacks:client:%s:%s"):format(eventName, requestId), src, table.unpack(result))
    else
        TriggerClientEvent(("ava_core:callbacks:client:%s:%s"):format(eventName, requestId), src)
    end
end)

---Register a server callback
---@param eventName string
---@param callback function
AVA.RegisterServerCallback = function(eventName, callback)
    if type(eventName) ~= "string" then
        print("^3[WARN] Could not create server callback because ^eventName^3 is not a ^0string^3.^0")
        return
    elseif type(callback) ~= "function" and (type(callback) == "table" and callback["__cfx_functionReference"] == nil) then
        print("^3[WARN]^0 Could not create server callback ^3" .. name .. "^0 because ^3callback^0 is not a ^3function^0.^0")
        return
    end

    callbacks[eventName] = callback
end
exports("RegisterServerCallback", AVA.RegisterServerCallback)

AVA.RegisterServerCallback("ava_core:IsPlayerAceAllowed", function(source, ace)
    return IsPlayerAceAllowed(source, ace)
end)
