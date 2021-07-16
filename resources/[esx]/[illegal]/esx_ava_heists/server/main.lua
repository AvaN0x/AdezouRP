-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_ava_heists:canRob', function(source, cb, heistName)
    local heist = Config.Heists[heistName]
    local cops = exports.esx_ava_jobs:getCountInService("lspd")
    
    if not heist or heist.Disabled then
        cb(false)
    elseif Config.Debug or (heist.CopsCount and cops >= heist.CopsCount) then
        cb(true)
    else
        cb(false)
    end
end)

RegisterNetEvent("esx_ava_heists:serverEvent")
AddEventHandler("esx_ava_heists:serverEvent", function(heistName, options)
    local heist = Config.Heists[heistName]
    if not heist or heist.Disabled then return end

    TriggerClientEvent("esx_ava_heists:clientCallback", -1, heistName, options)
    if not options then return end

    if options.TriggerHeist and not heist.Started and heist.ServerTriggerHeist then
        heist.Started = true
        heist.ServerTriggerHeist()
    end
    if options.Stage ~= nil then
        heist.CurrentStage = options.Stage
    end
    if options.TriggerAlarm and not heist.IsAlarmOn then
        heist.IsAlarmOn = true
        if heist.ServerTriggerAlarm then
            heist.ServerTriggerAlarm()
        end
    end
    if options.StopAlarm and heist.IsAlarmOn then
        heist.IsAlarmOn = false
        if heist.ServerStopAlarm then
            heist.ServerStopAlarm()
        end
    end
    if options.Reset then
        heist.Started = false
        heist.CurrentStage = 0
        heist.Reset()
    end
end)

RegisterNetEvent("esx_ava_heists:data:fetch")
AddEventHandler("esx_ava_heists:data:fetch", function()
    local _source = source
    local data = {}

    for heistName, heist in pairs(Config.Heists) do
        data[heistName] = {}
        if heist.Started then
            data[heistName].Started = heist.Started
        end
        if heist.CurrentStage and heist.CurrentStage > 0 then
            data[heistName].CurrentStage = heist.CurrentStage
        end
        if heist.IsAlarmOn then
            data[heistName].IsAlarmOn = heist.IsAlarmOn
        end
        print("data[heistName]", json.encode(data[heistName]))
    end
    print("data", json.encode(data))
    TriggerClientEvent("esx_ava_heists:data:get", _source, data)
end)