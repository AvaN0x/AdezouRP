-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
local heistsData = {}

exports.ava_core:RegisterServerCallback("ava_heists:server:canStartHeist", function(source, heistName)
    local heist = AVAConfig.Heists[heistName]

    if not heist or heist.Disabled then
        return false
    end

    local cops<const> = exports.ava_jobs:getCountInService("lspd")
    if AVAConfig.Debug or (heist.CopsCount and cops >= heist.CopsCount) then
        return true
    end
    return false
end)

-- TODO add some sort of reset for heists

RegisterNetEvent("ava_heists:server:triggerAction", function(heistName, options)
    local src = source
    local configHeist = AVAConfig.Heists[heistName]
    -- check if options exist, if the heist exist and it is not disabled
    if not options or not configHeist or configHeist.Disabled then
        return
    end

    TriggerClientEvent("ava_heists:client:actionTriggered", -1, heistName, options)

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
                            local aPlayer = exports.ava_core:GetPlayer(src)
                            if stealable.Loot.Items then
                                local inventory = aPlayer.getInventory()
                                local min = type(stealable.Loot.ItemCount) == "table" and stealable.Loot.ItemCount.Min or stealable.Loot.ItemCount or 1
                                local max = type(stealable.Loot.ItemCount) == "table" and stealable.Loot.ItemCount.Max or stealable.Loot.ItemCount or 1
                                if max < min then
                                    max = min
                                end
                                for i = 1, math.random(min, max), 1 do
                                    local item = stealable.Loot.Items[math.random(#stealable.Loot.Items)]
                                    inventory.addOrDropItem(item, 1)
                                    Wait(250)
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

exports.ava_core:RegisterServerCallback("ava_heists:server:stealables:canSteal", function(source, heistName, stageIndex, stealableName, trayIndex)
    -- does heist exist
    if AVAConfig.Heists[heistName] == nil or AVAConfig.Heists[heistName].Stages == nil or AVAConfig.Heists[heistName].Stages[stageIndex] == nil
        or AVAConfig.Heists[heistName].Stages[stageIndex].Stealables == nil or AVAConfig.Heists[heistName].Stages[stageIndex].Stealables[stealableName] == nil
        or AVAConfig.Heists[heistName].Stages[stageIndex].Stealables[stealableName].Zones == nil
        or AVAConfig.Heists[heistName].Stages[stageIndex].Stealables[stealableName].Zones[trayIndex] == nil then
        return false
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
        return not heistsData[heistName].Stages[stageIndex].Stealables[stealableName][trayIndex]
    end
    heistsData[heistName].Stages[stageIndex].Stealables[stealableName] = {}
    return true
end)

RegisterNetEvent("ava_heists:server:data:fetch", function()
    TriggerClientEvent("ava_heists:client:data:get", source, heistsData)
end)
