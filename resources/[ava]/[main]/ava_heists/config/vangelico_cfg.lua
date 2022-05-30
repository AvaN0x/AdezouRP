-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVAConfig.Heists.vangelico = {
    -- Disabled = true,
    Started = false,
    InteriorId = 82690,
    -- InteriorIds = {82690},
    CopsCount = 3,
    CurrentStage = 0,
    -- TriggerHeist = function()
    -- end,
    -- ServerTriggerHeist = function()
    -- end,
    TriggerAlarm = function()
        ToggleAlarm("JEWEL_STORE_HEIST_ALARMS", true)
    end,
    ServerTriggerAlarm = function()
        exports.ava_jobs:sendMessageToJob("lspd", {
            message = GetString("vangelico_alarm_notif"),
            location = vector3(-631.88, -237.82, 38.06)
        })
    end,
    StopAlarm = function()
        ToggleAlarm("JEWEL_STORE_HEIST_ALARMS", false)
    end,
    -- ServerStopAlarm = function()
    -- end,
    Stages = {
        [0] = {
            Function = function(playerPed)
                if IsPedShooting(playerPed) and GetSelectedPedWeapon(playerPed) ~= GetHashKey("weapon_stungun") then
                    if (GetGameTimer() - LastActionTimer) > 300 and exports.ava_core:TriggerServerCallback("ava_heists:server:canStartHeist", "vangelico") then
                        TriggerServerEvent("ava_heists:server:triggerAction", "vangelico", { TriggerHeist = true, TriggerAlarm = true, Stage = 1 })
                    else
                        LastActionTimer = GetGameTimer()
                        exports.ava_core:ShowNotification(GetString("not_enough_cops"))
                    end
                end
            end,
        },
        [1] = {
            Stealables = {
                Trays = {
                    Zones = {
                        -- in front of the entry door
                        {
                            PropCoord = vector3(-627.73, -234.43, 37.87),
                            MarkerCoord = vector3(-627.60, -234.38, 38.42),
                            Coord = vector3(-628.18, -233.53, 38.06),
                            Heading = 212.0,
                            RayFireName = "DES_Jewel_Cab",
                        },
                        {
                            PropCoord = vector3(-626.716, -233.68, 37.858),
                            MarkerCoord = vector3(-626.56, -233.60, 38.42),
                            Coord = vector3(-627.13, -232.77, 38.06),
                            Heading = 212.0,
                            RayFireName = "DES_Jewel_Cab",
                        },
                        {
                            PropCoord = vector3(-627.35, -234.94, 37.85),
                            MarkerCoord = vector3(-627.18, -234.92, 38.42),
                            Coord = vector3(-626.62, -235.72, 38.06),
                            Heading = 38.0,
                            RayFireName = "DES_Jewel_Cab3",
                        },
                        {
                            PropCoord = vector3(-626.29, -234.19, 37.84),
                            MarkerCoord = vector3(-626.14, -234.13, 38.42),
                            Coord = vector3(-625.57, -234.96, 38.06),
                            Heading = 38.0,
                            RayFireName = "DES_Jewel_Cab4",
                        },

                        -- on the right
                        {
                            PropCoord = vector3(-626.39, -239.1, 37.86),
                            MarkerCoord = vector3(-626.35, -239.03, 38.42),
                            Coord = vector3(-626.89, -238.2, 37.08),
                            Heading = 212.0,
                            RayFireName = "DES_Jewel_Cab2",
                        },
                        {
                            PropCoord = vector3(-625.37, -238.35, 37.86),
                            MarkerCoord = vector3(-625.30, -238.26, 38.42),
                            Coord = vector3(-625.86, -237.45, 38.06),
                            Heading = 212.0,
                            RayFireName = "DES_Jewel_Cab3",
                        },

                        -- center 6 trays
                        {
                            PropCoord = vector3(-624.12, -230.74, 37.86),
                            MarkerCoord = vector3(-623.98, -230.76, 38.42),
                            Coord = vector3(-624.93, -231.24, 38.06),
                            Heading = 303.0,
                            RayFireName = "DES_Jewel_Cab4",
                        },
                        {
                            PropCoord = vector3(-622.7541, -232.614, 37.86),
                            MarkerCoord = vector3(-622.63, -232.59, 38.42),
                            Coord = vector3(-623.3596, -233.2296, 38.06),
                            Heading = 303.0,
                            RayFireName = "DES_Jewel_Cab",
                        },
                        {
                            PropCoord = vector3(-620.64, -232.93, 37.84),
                            MarkerCoord = vector3(-620.52, -232.93, 38.42),
                            Coord = vector3(-620.18, -233.72, 38.06),
                            Heading = 38.0,
                            RayFireName = "DES_Jewel_Cab4",
                        },
                        {
                            PropCoord = vector3(-620.32, -230.82, 37.85),
                            MarkerCoord = vector3(-620.15, -230.75, 38.42),
                            Coord = vector3(-619.408, -230.19, 38.06),
                            Heading = 126.0,
                            RayFireName = "DES_Jewel_Cab",
                        },
                        {
                            PropCoord = vector3(-621.71, -228.96, 37.84),
                            MarkerCoord = vector3(-621.51, -228.93, 38.42),
                            Coord = vector3(-620.86, -228.48, 38.06),
                            Heading = 126.0,
                            RayFireName = "DES_Jewel_Cab3",
                        },
                        {
                            PropCoord = vector3(-623.81, -228.63, 37.85),
                            MarkerCoord = vector3(-623.63, -228.61, 38.42),
                            Coord = vector3(-624.29, -227.83, 38.06),
                            Heading = 212.0,
                            RayFireName = "DES_Jewel_Cab2",
                        },

                        -- 2 on the right
                        {
                            PropCoord = vector3(-619.97, -234.93, 37.85),
                            MarkerCoord = vector3(-619.88, -234.89, 38.42),
                            Coord = vector3(-620.44, -234.08, 38.06),
                            Heading = 212.0,
                            RayFireName = "DES_Jewel_Cab",
                        },
                        {
                            PropCoord = vector3(-618.93, -234.16, 37.84),
                            MarkerCoord = vector3(-618.85, -234.13, 38.42),
                            Coord = vector3(-619.39, -233.32, 38.06),
                            Heading = 212.0,
                            RayFireName = "DES_Jewel_Cab3",
                        },

                        -- 2 on the left
                        {
                            PropCoord = vector3(-625.51, -227.42, 37.86),
                            MarkerCoord = vector3(-625.33, -227.35, 38.42),
                            Coord = vector3(-624.73, -228.2, 38.06),
                            Heading = 38.0,
                            RayFireName = "DES_Jewel_Cab3",
                        },
                        {
                            PropCoord = vector3(-624.46, -226.65, 37.86),
                            MarkerCoord = vector3(-624.26, -226.59, 38.42),
                            Coord = vector3(-623.68, -227.43, 38.06),
                            Heading = 38.0,
                            RayFireName = "DES_Jewel_Cab4",
                        },

                        -- 4 in the back
                        {
                            PropCoord = vector3(-620.16, -226.21, 37.82),
                            MarkerCoord = vector3(-619.99, -226.22, 38.42),
                            Coord = vector3(-620.79, -226.79, 38.06),
                            Heading = 303.0,
                            RayFireName = "DES_Jewel_Cab",
                        },
                        {
                            PropCoord = vector3(-619.38, -227.25, 37.83),
                            MarkerCoord = vector3(-619.21, -227.26, 38.42),
                            Coord = vector3(-620.05, -227.81, 38.06),
                            Heading = 303.0,
                            RayFireName = "DES_Jewel_Cab2",
                        },
                        {
                            PropCoord = vector3(-618.01, -229.11, 37.83),
                            MarkerCoord = vector3(-617.83, -229.13, 38.42),
                            Coord = vector3(-618.67, -229.70, 38.06),
                            Heading = 303.0,
                            RayFireName = "DES_Jewel_Cab3",
                        },
                        {
                            PropCoord = vector3(-617.24, -230.15, 37.82),
                            MarkerCoord = vector3(-617.08, -230.16, 38.42),
                            Coord = vector3(-617.93, -230.73, 38.06),
                            Heading = 303.0,
                            RayFireName = "DES_Jewel_Cab2",
                        },
                    },
                    Loot = {
                        Items = {
                            "diamond",
                            "watch_gold",
                            "watch_diamond",
                            "watch_steel",
                            "watch_emerald",
                            "watch_ruby",
                            "necklace_gold",
                            "necklace_diamond",
                            "necklace_steel",
                            "necklace_emerald",
                            "necklace_ruby",
                            "ring_gold",
                            "ring_diamond",
                            "ring_steel",
                            "ring_emerald",
                            "ring_ruby",
                            "bracelet_gold",
                            "bracelet_diamond",
                            "bracelet_steel",
                            "bracelet_emerald",
                            "bracelet_ruby",
                        },
                        ItemCount = { Min = 3, Max = 6 },
                        -- ItemCount = 1,
                    },
                    Size = { x = 0.1, y = 0.1, z = 0.1 },
                    Color = { r = 255, g = 255, b = 255 },
                    MarkerRotation = vector3(180.0, 0.0, 0.0),
                    BobUpAndDown = true,
                    Distance = 1.2,
                    HelpText = GetString("vangelico_press_break_tray"),
                    Marker = 20,
                    Type = AVAConfig.StealablesType.Tray,
                },
            },
        },
    },
    Interactables = {
        {
            Coord = vector3(-631.59, -230.01, 37.08),
            Size = { x = 1.0, y = 1.0, z = 1.0 },
            Color = { r = 255, g = 255, b = 255 },
            Distance = 1.2,
            Name = GetString("alarm"),
            HelpText = GetString("press_stop_alarm"),
            Marker = 27,
            Action = function(playerPed)
                TriggerServerEvent("ava_heists:server:triggerAction", "vangelico", { StopAlarm = true })
            end,
            JobNeeded = { "lspd" },
        },
    },
    -- Reset = function()
    -- end,
    ClientReset = function()
        ToggleAlarm("JEWEL_STORE_HEIST_ALARMS", false)

        for _, tray in ipairs(AVAConfig.Heists.vangelico.Stages[1].Stealables.Trays.Zones) do
            local object = GetRayfireMapObject(tray.PropCoord, 0.5, tray.RayFireName)
            SetStateOfRayfireMapObject(object, 2)
        end
    end,
}

AVAConfig.Heists.vangelico_paleto = {
    Started = false,
    InteriorId = 122626,
    CopsCount = 6,
    CurrentStage = 0,
    ServerTriggerAlarm = function()
        exports.ava_jobs:sendMessageToJob("lspd", {
            message = GetString("vangelico_alarm_notif"),
            location = vector3(-380.74, 6044.95, 31.51)
        })
    end,
    Stages = {
        [0] = {
            Function = function(playerPed)
                if IsPedShooting(playerPed) and GetSelectedPedWeapon(playerPed) ~= GetHashKey("weapon_stungun") then
                    if (GetGameTimer() - LastActionTimer) > 300 and exports.ava_core:TriggerServerCallback("ava_heists:server:canStartHeist", "vangelico") then
                        TriggerServerEvent("ava_heists:server:triggerAction", "vangelico_paleto", { TriggerHeist = true, Stage = 1 })
                    else
                        LastActionTimer = GetGameTimer()
                        exports.ava_core:ShowNotification(GetString("not_enough_cops"))
                    end
                end
            end,
        },
        [1] = {
            Stealables = {
                Trays = {
                    Zones = {
                        -- two on the right
                        {
                            PropCoord = vector3(-377.91, 6042.32, 30.95),
                            MarkerCoord = vector3(-377.91, 6042.32, 31.95),
                            Coord = vector3(-378.45, 6042.90, 31.51),
                            Heading = 225.0,
                            RayFireName = "DES_Jewel_Cab3",
                        },
                        {
                            PropCoord = vector3(-376.93, 6043.26, 31.51),
                            MarkerCoord = vector3(-376.94, 6043.14, 31.95),
                            Coord = vector3(-377.52, 6043.53, 31.51),
                            Heading = 225.0,
                            RayFireName = "DES_Jewel_Cab3",
                        },
                        -- middle front
                        {
                            PropCoord = vector3(-379.29, 6046.21, 30.95),
                            MarkerCoord = vector3(-379.39, 6046.21, 31.95),
                            Coord = vector3(-378.67, 6045.61, 30.53),
                            Heading = 45.0,
                            RayFireName = "DES_Jewel_Cab",
                        },
                        {
                            PropCoord = vector3(-378.39, 6047.04, 30.99),
                            MarkerCoord = vector3(-378.43, 6047.00, 31.95),
                            Coord = vector3(-377.90, 6046.57, 31.51),
                            Heading = 45.0,
                            RayFireName = "DES_Jewel_Cab2",
                        },
                        {
                            PropCoord = vector3(-379.11, 6047.62, 30.99),
                            MarkerCoord = vector3(-379.11, 6047.62, 31.95),
                            Coord = vector3(-379.38, 6048.07, 31.51),
                            Heading = 225.0,
                            RayFireName = "DES_Jewel_Cab3",
                        },
                        -- back left
                        {
                            PropCoord = vector3(-379.15, 6049.89, 31.21),
                            MarkerCoord = vector3(-379.15, 6049.89, 31.95),
                            Coord = vector3(-379.71, 6049.33, 31.51),
                            Heading = 315.0,
                            RayFireName = "DES_Jewel_Cab4",
                        },
                    },
                    Loot = {
                        Items = {
                            "diamond",
                            "watch_gold",
                            "watch_diamond",
                            "watch_steel",
                            "watch_emerald",
                            "watch_ruby",
                            "necklace_gold",
                            "necklace_diamond",
                            "necklace_steel",
                            "necklace_emerald",
                            "necklace_ruby",
                            "ring_gold",
                            "ring_diamond",
                            "ring_steel",
                            "ring_emerald",
                            "ring_ruby",
                            "bracelet_gold",
                            "bracelet_diamond",
                            "bracelet_steel",
                            "bracelet_emerald",
                            "bracelet_ruby",
                        },
                        ItemCount = { Min = 5, Max = 8 },
                    },
                    Size = { x = 0.1, y = 0.1, z = 0.1 },
                    Color = { r = 255, g = 255, b = 255 },
                    MarkerRotation = vector3(180.0, 0.0, 0.0),
                    BobUpAndDown = true,
                    Distance = 1.2,
                    HelpText = GetString("vangelico_press_break_tray"),
                    Marker = 20,
                    Type = AVAConfig.StealablesType.Tray,
                },
            },
        },
    },
    Interactables = {
        {
            Coord = vector3(-631.59, -230.01, 37.08),
            Size = { x = 1.0, y = 1.0, z = 1.0 },
            Color = { r = 255, g = 255, b = 255 },
            Distance = 1.2,
            Name = GetString("alarm"),
            HelpText = GetString("press_stop_alarm"),
            Marker = 27,
            Action = function(playerPed)
                TriggerServerEvent("ava_heists:server:triggerAction", "vangelico_paleto", { StopAlarm = true })
            end,
            JobNeeded = { "lspd" },
        },
    },
    -- Reset = function()
    -- end,
    ClientReset = function()
        ToggleAlarm("JEWEL_STORE_HEIST_ALARMS", false)

        for _, tray in ipairs(AVAConfig.Heists.vangelico_paleto.Stages[1].Stealables.Trays.Zones) do
            local object = GetRayfireMapObject(tray.PropCoord, 0.5, tray.RayFireName)
            SetStateOfRayfireMapObject(object, 2)
        end
    end,
}

AVAConfig.Heists.vangelico_grapeseed = {
    Started = false,
    InteriorId = 122882,
    CopsCount = 6,
    CurrentStage = 0,
    ServerTriggerAlarm = function()
        -- exports.ava_jobs:sendMessageToJob("lspd", {
        --     message = GetString("vangelico_alarm_notif"),
        --     location = vector3(-380.74, 6044.95, 31.51)
        -- })
    end,
    Stages = {
        [0] = {
            Function = function(playerPed)
                if IsPedShooting(playerPed) and GetSelectedPedWeapon(playerPed) ~= GetHashKey("weapon_stungun") then
                    if (GetGameTimer() - LastActionTimer) > 300 and exports.ava_core:TriggerServerCallback("ava_heists:server:canStartHeist", "vangelico") then
                        TriggerServerEvent("ava_heists:server:triggerAction", "vangelico_grapeseed", { TriggerHeist = true, Stage = 1 })
                    else
                        LastActionTimer = GetGameTimer()
                        exports.ava_core:ShowNotification(GetString("not_enough_cops"))
                    end
                end
            end,
        },
        [1] = {
            Stealables = {
                Trays = {
                    Zones = {
                        -- two on the right
                        {
                            PropCoord = vector3(1649.94, 4886.56, 42.16),
                            MarkerCoord = vector3(1649.94, 4886.56, 42.50),
                            Coord = vector3(1650.03, 4885.55, 42.16),
                            Heading = 5.0,
                            RayFireName = "DES_Jewel_Cab3",
                        },
                        {
                            PropCoord = vector3(1648.67, 4886.42, 42.16),
                            MarkerCoord = vector3(1648.67, 4886.42, 42.50),
                            Coord = vector3(1648.80, 4885.49, 42.16),
                            Heading = 5.0,
                            RayFireName = "DES_Jewel_Cab3",
                        },
                        -- middle front
                        {
                            PropCoord = vector3(1648.76, 4882.67, 41.82),
                            MarkerCoord = vector3(1648.76, 4882.67, 42.50),
                            Coord = vector3(1648.65, 4883.45, 42.16),
                            Heading = 185.0,
                            RayFireName = "DES_Jewel_Cab",
                        },
                        {
                            PropCoord = vector3(1647.49, 4882.38, 42.16),
                            MarkerCoord = vector3(1647.49, 4882.38, 42.50),
                            Coord = vector3(1647.44, 4883.30, 42.16),
                            Heading = 185.0,
                            RayFireName = "DES_Jewel_Cab2",
                        },
                        {
                            PropCoord = vector3(1647.59, 4881.70, 42.16),
                            MarkerCoord = vector3(1647.59, 4881.70, 42.50),
                            Coord = vector3(1647.72, 4880.88, 42.16),
                            Heading = 5.0,
                            RayFireName = "DES_Jewel_Cab3",
                        },
                        -- back left
                        {
                            PropCoord = vector3(1646.36, 4879.63, 42.16),
                            MarkerCoord = vector3(1646.36, 4879.63, 42.50),
                            Coord = vector3(1647.18, 4879.71, 42.16),
                            Heading = 95.0,
                            RayFireName = "DES_Jewel_Cab4",
                        },
                    },
                    Loot = {
                        Items = {
                            "diamond",
                            "watch_gold",
                            "watch_diamond",
                            "watch_steel",
                            "watch_emerald",
                            "watch_ruby",
                            "necklace_gold",
                            "necklace_diamond",
                            "necklace_steel",
                            "necklace_emerald",
                            "necklace_ruby",
                            "ring_gold",
                            "ring_diamond",
                            "ring_steel",
                            "ring_emerald",
                            "ring_ruby",
                            "bracelet_gold",
                            "bracelet_diamond",
                            "bracelet_steel",
                            "bracelet_emerald",
                            "bracelet_ruby",
                        },
                        ItemCount = { Min = 5, Max = 8 },
                    },
                    Size = { x = 0.1, y = 0.1, z = 0.1 },
                    Color = { r = 255, g = 255, b = 255 },
                    MarkerRotation = vector3(180.0, 0.0, 0.0),
                    BobUpAndDown = true,
                    Distance = 1.2,
                    HelpText = GetString("vangelico_press_break_tray"),
                    Marker = 20,
                    Type = AVAConfig.StealablesType.Tray,
                },
            },
        },
    },
    Interactables = {
        {
            Coord = vector3(-631.59, -230.01, 37.08),
            Size = { x = 1.0, y = 1.0, z = 1.0 },
            Color = { r = 255, g = 255, b = 255 },
            Distance = 1.2,
            Name = GetString("alarm"),
            HelpText = GetString("press_stop_alarm"),
            Marker = 27,
            Action = function(playerPed)
                TriggerServerEvent("ava_heists:server:triggerAction", "vangelico_grapeseed", { StopAlarm = true })
            end,
            JobNeeded = { "lspd" },
        },
    },
    -- Reset = function()
    -- end,
    ClientReset = function()
        ToggleAlarm("JEWEL_STORE_HEIST_ALARMS", false)

        for _, tray in ipairs(AVAConfig.Heists.vangelico_grapeseed.Stages[1].Stealables.Trays.Zones) do
            local object = GetRayfireMapObject(tray.PropCoord, 0.5, tray.RayFireName)
            SetStateOfRayfireMapObject(object, 2)
        end
    end,
}