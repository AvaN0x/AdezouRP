-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local callbacks = {}

RegisterNetEvent("ava_core:callbacks:server", function(eventName, requestId, ...)
    local src = source
    local result

    if type(callbacks[eventName]) == "function" then
        result = {callbacks[eventName](src, ...)}
    end

    TriggerClientEvent(("ava_core:callbacks:client:%s:%s"):format(eventName, requestId), src, table.unpack(result))
end)

---Register a server callback
---@param eventName string
---@param callback function
AVA.RegisterServerCallback = function(eventName, callback)
    if type(eventName) ~= "string" then
        return
    elseif type(callback) ~= "function" then
        return
    end

    callbacks[eventName] = callback
end
exports("RegisterServerCallback", AVA.RegisterServerCallback)

AVA.RegisterServerCallback("ava_core:IsPlayerAceAllowed", function(source, ace)
    return IsPlayerAceAllowed(source, ace)
end)
