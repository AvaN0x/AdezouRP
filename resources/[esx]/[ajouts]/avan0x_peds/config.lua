-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config = {}
-- ped types : 
    -- PED_TYPE_PLAYER_0,// michael
    -- PED_TYPE_PLAYER_1,// franklin
    -- PED_TYPE_NETWORK_PLAYER,  // mp character
    -- PED_TYPE_PLAYER_2,// trevor
    -- PED_TYPE_CIVMALE,
    -- PED_TYPE_CIVFEMALE,
    -- PED_TYPE_COP,
    -- PED_TYPE_GANG_ALBANIAN,
    -- PED_TYPE_GANG_BIKER_1,
    -- PED_TYPE_GANG_BIKER_2,
    -- PED_TYPE_GANG_ITALIAN,
    -- PED_TYPE_GANG_RUSSIAN,
    -- PED_TYPE_GANG_RUSSIAN_2,
    -- PED_TYPE_GANG_IRISH,
    -- PED_TYPE_GANG_JAMAICAN,
    -- PED_TYPE_GANG_AFRICAN_AMERICAN,
    -- PED_TYPE_GANG_KOREAN,
    -- PED_TYPE_GANG_CHINESE_JAPANESE,
    -- PED_TYPE_GANG_PUERTO_RICAN,
    -- PED_TYPE_DEALER,
    -- PED_TYPE_MEDIC,
    -- PED_TYPE_FIREMAN,
    -- PED_TYPE_CRIMINAL,
    -- PED_TYPE_BUM,
    -- PED_TYPE_PROSTITUTE,
    -- PED_TYPE_SPECIAL,
    -- PED_TYPE_MISSION,
    -- PED_TYPE_SWAT,
    -- PED_TYPE_ANIMAL,
    -- PED_TYPE_ARMY

-- scenario list : https://pastebin.com/6mrYTdQv

Config.Peds = {
    -- Superettes = {
    --     Name = "mp_m_shopkeep_01",
    --     Type= "PED_TYPE_CIVMALE",
    --     PosList = {
    --         {x = 24.129, y = -1345.156, z = 28.497, h = 266.946},
    --         {x = 2557.14, y = 380.53, z = 107.622, h = 2.0},
    --         {x = -3038.87, y = 584.37, z = 6.97, h = 23.0},
    --         {x = -3242.28, y = 999.72, z = 11.850, h = 354.8},
    --         {x = 549.4, y = 2671.39, z = 41.176, h = 96.5},
    --         {x = 1959.76, y = 3739.87, z = 31.363, h = 289.7},
    --         {x = 2677.86, y = 3279.12, z = 54.261, h = 332.8},
    --         {x = 1727.61, y = 6415.37, z = 34.057, h = 246.5},
    --         {x = 1134.04, y = -982.48, z = 45.45, h = 277.0},
    --         {x = -1221.79, y = -908.63, z = 11.35, h = 41.0},
    --         {x = -1486.06, y = -377.75, z = 39.163, h = 124.0},
    --         {x = -2966.22, y = 390.79, z = 14.054, h = 87.0},
    --         {x = 1166.05, y = 2710.94, z = 37.167, h = 181.0},
    --         {x = 1392.39, y = 3606.44, z = 33.995, h = 203.0},
    --         {x = -46.49, y = -1758.17, z = 28.47, h = 48.0},
    --         {x = 1165.04, y = -323.00, z = 68.27, h = 104.0},
    --         {x = -705.89, y = -913.97, z = 18.26, h = 97.0},
    --         {x = -1819.79, y = 794.18, z = 137.20, h = 138.0},
    --         {x = 1697.71, y = 4922.87, z = 41.08, h = 317.0},
    --         {x = 372.48, y = 326.44, z = 102.59, h = 252.22},

    --         {x = 269.23, y = -978.3, z = 28.39, h = 156.0}, -- mapping place du cube        
    --     }
    -- },
    Gouv = {
        -- Name = "a_f_y_business_01",
        Name = "ig_agatha",
        Type= "PED_TYPE_CIVFEMALE",
        PosList = {
            {x = -550.76, y = -190.07, z = 36.72, h = 193.6, scenario = "PROP_HUMAN_SEAT_ARMCHAIR"},
        }
    },
    Pacifique = {
        Name = "a_m_y_business_02",
        Type= "PED_TYPE_CIVMALE",
        PosList = {
            {x = 248.95, y = 224.51, z = 104.97, h = 166.76, scenario = "PROP_HUMAN_SEAT_BENCH"},
            {x = 243.71, y = 226.4, z = 104.97, h = 166.76, scenario = "PROP_HUMAN_SEAT_BENCH"},
        }
    },
    -- Ammunation = {
    --     Name = "s_m_y_ammucity_01",
    --     Type= "PED_TYPE_CIVMALE",
    --     PosList = {
    --         {x = 22.07, y = -1104.93, z = 28.82, h = 158.97, scenario = "WORLD_HUMAN_HANG_OUT_STREET"},
    --     }
    -- },
    Tatoo = {
        Name = "a_m_y_ktown_01",
        Type= "PED_TYPE_CIVMALE",
        PosList = {
            {x = 319.71, y = 180.9, z = 102.61, h = 254.42, scenario = "WORLD_HUMAN_HANG_OUT_STREET"},
            {x = -1152.14, y = -1424.01, z = 3.97, h = 128.46, scenario = "WORLD_HUMAN_HANG_OUT_STREET"},
            {x = -3170.54, y = 1073.1, z = 19.85, h = 20.83, scenario = "WORLD_HUMAN_HANG_OUT_STREET"},
            {x = 1862.45, y = 3748.43, z = 32.05, h = 24.46, scenario = "WORLD_HUMAN_HANG_OUT_STREET"},
            {x = -292.04, y = 6199.83, z = 30.50, h = 228.9, scenario = "WORLD_HUMAN_HANG_OUT_STREET"},
        }

    },
}