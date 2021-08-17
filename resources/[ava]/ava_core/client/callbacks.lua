-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local nextRequestId = 0

---Trigger a server callback
---@param eventName string
---@return any
AVA.TriggerServerCallback = function(eventName, ...)
    if type(eventName) ~= "string" then return end

    local p = promise:new()

    local thisRequestId = nextRequestId
    -- can have up to 65,536 values (from 0 to 65,535)
    nextRequestId = nextRequestId < 65535 and (nextRequestId + 1) or 0

    -- create the event that will be called by server
    local netEventName = ("ava_core:callbacks:client:%s:%s"):format(eventName, thisRequestId)
    RegisterNetEvent(netEventName)
    local event = AddEventHandler(netEventName, function(...)
        p:resolve({...})
    end)

    -- trigger the server
    TriggerServerEvent("ava_core:callbacks:server", eventName, tostring(thisRequestId), ...)

    -- we wait for the result so we can delete the eventHandler
    local promiseResult = Citizen.Await(p)
    RemoveEventHandler(event)

    -- we finally can return results
    return table.unpack(promiseResult)
end
exports("TriggerServerCallback", AVA.TriggerServerCallback)
