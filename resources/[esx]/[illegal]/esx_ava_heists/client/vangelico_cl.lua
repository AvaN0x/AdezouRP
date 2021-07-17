-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

function SmashTray(heistName, stageIndex, stealableName, trayIndex)
    if playerIsInAction then return end

    local heist = Config.Heists[heistName]
    if heist == nil then return end
    local stage = heist.Stages[stageIndex]
    if stage == nil then return end
    local stealable = stage.Stealables[stealableName]
    if stealable == nil then return end
    local tray = stealable.Zones[trayIndex]
    if tray == nil then return end

    if tray.Stolen then
        print(trayIndex .. " is already Stolen")
    end

    Citizen.CreateThread(function()
        playerIsInAction = true
        ESX.TriggerServerCallback("esx_ava_heists:stealables:canSteal", function(canSteal)
            -- the tray is always set as Stolen, in case somebody manage to try stole an already stolen (on server side) tray
            tray.Stolen = true
            if canSteal then
                print("PropCoord", tray.PropCoord)

                TriggerServerEvent("esx_ava_heists:serverEvent", heistName, {
                    Steal = true,
                    StageIndex = stageIndex,
                    StealableName = stealableName,
                    TrayIndex = trayIndex,
                })
            end
            playerIsInAction = false
        end, heistName, stageIndex, stealableName, trayIndex)
    end)
end
