-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config.Heists.Vangelico = {
    -- Disabled = true,
    Started = false,
    InteriorId = 82690,
    -- InteriorIds = {82690},
    CopsCount = 4,
    CurrentStage = 0,
    TriggerHeist = function()
        ToggleAlarm("JEWEL_STORE_HEIST_ALARMS", true)
    end,
    TriggerAlarm = function()
        TriggerServerEvent("esx_phone:sendEmergency",
            "lspd",
            "L'alarme de la bijouterie a été activée, rendez-vous y au plus vite !",
            true,
            -- { ["x"] = -631.88, ["y"] = -237.82, ["z"] = 37.09 }
            vector3(-631.88, -237.82, 37.09)
        )
    end,
    Stages = {
        [0] = {
            Function = function(playerPed)
                if Config.Heists.Vangelico.Started then
                    if IsPedShooting(playerPed) then
                        Config.Heists.Vangelico.TriggerHeist()
                        Config.Heists.Vangelico.TriggerAlarm()
                        Config.Heists.Vangelico.CurrentStage = 1
                    end
                end
            end
        },
        [1] = {
            Stealables = {
                Trays = {
                    Zones = {
                    
                    },
                    Loot = {
                        'diamond',
                        'gold'
                    }
                }
            }
        }
    },
    Interactables = {
        {
            Pos = vector3(-631.59, -230.01, 37.08),
            Size  = {x = 1.5, y = 1.5, z = 1.0},
            Color = {r = 255, g = 255, b = 255},
            Name  = "Alarme",
            HelpText = "Appuyez sur ~INPUT_CONTEXT~ pour arrêter l'~y~alarme~s~.",
            Marker = 27,
            Action = function(playerPed)
                ToggleAlarm("JEWEL_STORE_HEIST_ALARMS", false)
            end,
            JobNeeded = {"lspd"}
        }
    },
    Reset = function()
        if Config.Heists.Vangelico.Started then
            ToggleAlarm("JEWEL_STORE_HEIST_ALARMS", true)
            
            -- for _, trayData in ipairs(Config.Trays) do
            --     local object = GetRayfireMapObject(trayData.Coord, 0.5, trayData.Ray)
                
            --     SetStateOfRayfireMapObject(object, 2)
            -- end
        end
        Config.Heists.Vangelico.CurrentStage = 0
        Config.Heists.Vangelico.Started = false
    end
}