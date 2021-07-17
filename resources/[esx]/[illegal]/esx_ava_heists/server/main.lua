-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

ESX = nil
local heistsData = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

math.randomseed(GetGameTimer())

ESX.RegisterServerCallback('esx_ava_heists:canStartHeist', function(source, cb, heistName)
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
    local _source = source
    local configHeist = Config.Heists[heistName]
    -- check if options exist, if the heist exist and it is not disabled
    if not options or not configHeist or configHeist.Disabled then return end
    local xPlayer = nil

    TriggerClientEvent("esx_ava_heists:clientCallback", -1, heistName, options)

    if type(heistsData[heistName]) ~= "table" then
        heistsData[heistName] = {}
    end

    if options.TriggerHeist and not configHeist.Started then
        heistsData[heistName].Started = true
        if configHeist.ServerTriggerHeist then
            configHeist.ServerTriggerHeist()
        end
    end
    if options.Stage ~= nil then
        heistsData[heistName].CurrentStage = options.Stage
    end
    if options.TriggerAlarm and not heistsData[heistName].IsAlarmOn then
        heistsData[heistName].IsAlarmOn = true
        if configHeist.ServerTriggerAlarm then
            configHeist.ServerTriggerAlarm()
        end
    end
    if options.StopAlarm and heistsData[heistName].IsAlarmOn then
        heistsData[heistName].IsAlarmOn = false
        if configHeist.ServerStopAlarm then
            configHeist.ServerStopAlarm()
        end
    end
    if options.Steal and options.StageIndex and options.StealableName and options.TrayIndex then
        local stage = configHeist.Stages[options.StageIndex]
        if stage then
            local stealable = stage.Stealables[options.StealableName]
            if stealable then
                local tray = stealable.Zones[options.TrayIndex]
                if tray then
                    if type(heistsData[heistName]) ~= "table" then
                        heistsData[heistName] = {}
                    end
                    if type(heistsData[heistName].Stages) ~= "table" then
                        heistsData[heistName].Stages = {}
                    end
                    if type(heistsData[heistName].Stages[options.StageIndex]) ~= "table" then
                        heistsData[heistName].Stages[options.StageIndex] = {}
                    end
                    if type(heistsData[heistName].Stages[options.StageIndex].Stealables) ~= "table" then
                        heistsData[heistName].Stages[options.StageIndex].Stealables = {}
                    end
                    if type(heistsData[heistName].Stages[options.StageIndex].Stealables[options.StealableName]) ~= "table" then
                        heistsData[heistName].Stages[options.StageIndex].Stealables[options.StealableName] = {}
                    end
        
                    if not heistsData[heistName].Stages[options.StageIndex].Stealables[options.StealableName][options.TrayIndex] then
                        heistsData[heistName].Stages[options.StageIndex].Stealables[options.StealableName][options.TrayIndex] = true
                        if stealable.Loot then
                            if xPlayer == nil then
                                xPlayer = ESX.GetPlayerFromId(_source)
                            end
                            if stealable.Loot.Items then
                                local inventory = xPlayer.getInventory()
                                local min = type(stealable.Loot.ItemCount) == "table"
                                    and stealable.Loot.ItemCount.Min
                                    or stealable.Loot.ItemCount
                                    or 1
                                local max = type(stealable.Loot.ItemCount) == "table"
                                    and stealable.Loot.ItemCount.Max
                                    or stealable.Loot.ItemCount
                                    or 1
                                if max < min then
                                    max = min
                                end
                                for i = min, math.random(min, max), 1 do
                                    local item = stealable.Loot.Items[math.random(#stealable.Loot.Items)]
                                    if inventory.canAddItem(item, 1) then
                                        inventory.addItem(item, 1)
                                    end
                                    Citizen.Wait(250)
                                end
                            end
                        end
                    end

                end
            end
        end
    
    end
    if options.Reset then
        heistsData[heistName].Started = false
        heistsData[heistName].CurrentStage = 0
        configHeist.Reset()
    end
end)

ESX.RegisterServerCallback("esx_ava_heists:stealables:canSteal", function(source, cb, heistName, stageIndex, stealableName, trayIndex)
    -- does heist exist
    if Config.Heists[heistName] == nil 
        or Config.Heists[heistName].Stages == nil
        or Config.Heists[heistName].Stages[stageIndex] == nil
        or Config.Heists[heistName].Stages[stageIndex].Stealables == nil
        or Config.Heists[heistName].Stages[stageIndex].Stealables[stealableName] == nil
        or Config.Heists[heistName].Stages[stageIndex].Stealables[stealableName].Zones == nil
        or Config.Heists[heistName].Stages[stageIndex].Stealables[stealableName].Zones[trayIndex] == nil
    then 
        return
    end

    if type(heistsData[heistName]) ~= "table" then
        heistsData[heistName] = {}
    end
    if type(heistsData[heistName].Stages) ~= "table" then
        heistsData[heistName].Stages = {}
    end
    if type(heistsData[heistName].Stages[stageIndex]) ~= "table" then
        heistsData[heistName].Stages[stageIndex] = {}
    end
    if type(heistsData[heistName].Stages[stageIndex].Stealables) ~= "table" then
        heistsData[heistName].Stages[stageIndex].Stealables = {}
    end

    if type(heistsData[heistName].Stages[stageIndex].Stealables[stealableName]) == "table" then
        cb(not heistsData[heistName].Stages[stageIndex].Stealables[stealableName][trayIndex])
    else
        heistsData[heistName].Stages[stageIndex].Stealables[stealableName] = {}
        cb(true)
    end    
end)


RegisterNetEvent("esx_ava_heists:data:fetch")
AddEventHandler("esx_ava_heists:data:fetch", function()
    local _source = source
    TriggerClientEvent("esx_ava_heists:data:get", _source, heistsData)
end)