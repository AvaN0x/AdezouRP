-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config.Heists.vangelico = {
    -- Disabled = true,
    Started = false,
    InteriorId = 82690,
    -- InteriorIds = {82690},
    CopsCount = 4,
    CurrentStage = 0,
    -- TriggerHeist = function()
    -- end,
    -- ServerTriggerHeist = function()
    -- end,
    TriggerAlarm = function()
        ToggleAlarm("JEWEL_STORE_HEIST_ALARMS", true)
    end,
    ServerTriggerAlarm = function()
        TriggerEvent("esx_phone:sendEmergency",
            "lspd",
            "L'alarme de la bijouterie a été activée, rendez-vous y au plus vite !",
            true,
            vector3(-631.88, -237.82, 37.09)
        )
    end,
    StopAlarm = function()
        ToggleAlarm("JEWEL_STORE_HEIST_ALARMS", false)
    end,
    -- ServerStopAlarm = function()
    -- end,
    Stages = {
        [0] = {
            Function = function(playerPed)
                if IsPedShooting(playerPed) then
                    ESX.TriggerServerCallback("esx_ava_heists:canStartHeist", function(canRob)
                        if canRob then
                            TriggerServerEvent("esx_ava_heists:serverEvent", "vangelico", {
                                TriggerHeist = true,
                                TriggerAlarm = true,
                                Stage = 1
                            })
                        else
                            ESX.ShowNotification("Il n'y a pas assez de policiers en service.")
                        end
                    end, "vangelico")
                end
            end
        },
        [1] = {
            Stealables = {
                Trays = {
                    Zones = {
                        {
                            MarkerCoord = vector3(-627.60, -234.38, 38.42),
                            Coord = vector3(-628.18, -233.53, 37.09),
                        },
                        {
                            MarkerCoord = vector3(-626.56, -233.60, 38.42),
                            Coord = vector3(-627.13, -232.77, 37.09),
                        },
                        {
                            MarkerCoord = vector3(-627.18, -234.92, 38.42),
                            Coord = vector3(-626.62, -235.72, 37.09),
                        },
                        {
                            MarkerCoord = vector3(-626.14, -234.13, 38.42),
                            Coord = vector3(-625.57, -234.96, 37.09),
                        },

                        {
                            MarkerCoord = vector3(-626.35, -239.03, 38.42),
                            Coord = vector3(-626.89, -238.2, 37.08),
                        },
                        {
                            MarkerCoord = vector3(-625.30, -238.26, 38.42),
                            Coord = vector3(-625.86, -237.45, 37.09),
                        },

                        {
                            MarkerCoord = vector3(-623.98, -230.76, 38.42),
                            Coord = vector3(-624.93, -231.24, 37.09),
                        },
                        {
                            MarkerCoord = vector3(-622.63, -232.59, 38.42),
                            Coord = vector3(-623.3596, -233.2296, 37.09),
                        },
                        {
                            MarkerCoord = vector3(-620.52, -232.93, 38.42),
                            Coord = vector3(-620.18, -233.72, 37.09),
                        },
                        {
                            MarkerCoord = vector3(-620.15, -230.75, 38.42),
                            Coord = vector3(-619.408, -230.19, 37.09),
                        },
                        {
                            MarkerCoord = vector3(-621.51, -228.93, 38.42),
                            Coord = vector3(-620.86, -228.48, 37.09),
                        },
                        {
                            MarkerCoord = vector3(-623.63, -228.61, 38.42),
                            Coord = vector3(-624.29, -227.83, 37.09),
                        },

                        {
                            MarkerCoord = vector3(-625.33, -227.35, 38.42),
                            Coord = vector3(-624.73, -228.2, 37.09),
                        },
                        {
                            MarkerCoord = vector3(-624.26, -226.59, 38.42),
                            Coord = vector3(-623.68, -227.43, 37.09),
                        },

                        {
                            MarkerCoord = vector3(-619.88, -234.89, 38.42),
                            Coord = vector3(-620.44, -234.08, 37.09),
                        },
                        {
                            MarkerCoord = vector3(-618.85, -234.13, 38.42),
                            Coord = vector3(-619.39, -233.32, 37.09),
                        },

                        {
                            MarkerCoord = vector3(-619.99, -226.22, 38.42),
                            Coord = vector3(-620.79, -226.79, 37.09),
                        },
                        {
                            MarkerCoord = vector3(-619.21, -227.26, 38.42),
                            Coord = vector3(-620.05, -227.81, 37.08),
                        },
                        {
                            MarkerCoord = vector3(-617.83, -229.13, 38.42),
                            Coord = vector3(-618.67, -229.70, 37.09),
                        },
                        {
                            MarkerCoord = vector3(-617.08, -230.16, 38.42),
                            Coord = vector3(-617.93, -230.73, 37.08),
                        }       
                    },
                    Loot = {
                        Items = {
                            'diamond',
                            'gold'
                        },
                        ItemCount = {
                            Min = 1,
                            Max = 3
                        },
                        -- ItemCount = 1,
                    },
                    Size = {x = 0.1, y = 0.1, z = 0.1},
                    Color = {r = 255, g = 255, b = 255},
                    MarkerRotation = vector3(180.0, 0.0, 0.0),
                    BobUpAndDown = true,
                    Distance = 1.2,
                    HelpText = "Appuyez sur ~INPUT_CONTEXT~ pour ~r~casser~s~ la vitrine.",
                    Marker = 20,
                    Type = Config.StealablesType.Tray
                }
            }
        }
    },
    Interactables = {
        {
            Pos = vector3(-631.59, -230.01, 37.08),
            Size = {x = 1.5, y = 1.5, z = 1.0},
            Color = {r = 255, g = 255, b = 255},
            Name = "Alarme",
            HelpText = "Appuyez sur ~INPUT_CONTEXT~ pour arrêter l'~y~alarme~s~.",
            Marker = 27,
            Action = function(playerPed)
                TriggerServerEvent("esx_ava_heists:serverEvent", "vangelico", {
                    StopAlarm = true,
                })
            end,
            JobNeeded = {"lspd"}
        }
    },
    -- Reset = function()
    -- end,
    ClientReset = function()
        ToggleAlarm("JEWEL_STORE_HEIST_ALARMS", false)
        
        -- for _, trayData in ipairs(Config.Trays) do
        --     local object = GetRayfireMapObject(trayData.PropCoord, 0.5, trayData.Ray)
                
        --     SetStateOfRayfireMapObject(object, 2)
        -- end
    end
}