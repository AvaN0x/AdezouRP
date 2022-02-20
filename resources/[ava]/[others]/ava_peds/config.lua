-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
Config = {}
-- ped types :
-- PED_TYPE_PLAYER_0, // michael
-- PED_TYPE_PLAYER_1, // franklin
-- PED_TYPE_PLAYER_2, // trevor
-- PED_TYPE_NETWORK_PLAYER, // mp character
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

-- variations component Id :
-- 0: Face
-- 1: Mask
-- 2: Hair
-- 3: Torso
-- 4: Leg
-- 5: Parachute / bag
-- 6: Shoes
-- 7: Accessory
-- 8: Undershirt
-- 9: Kevlar
-- 10: Badge
-- 11: Torso 2

-- props variations component Id :
-- 0: Hat
-- 1: Glasses
-- 2: Ear
-- 6: Watch
-- 7: Bracelet

Config.Peds = {
    -- lspd
    {
        PedName = "s_f_y_cop_01",
        PedType = "PED_TYPE_CIVFEMALE",
        pos = vector3(440.05, -978.86, 29.71),
        heading = 183.6,
        name = "Jessica",
        bubble = "Quelle est votre urgence ?",
        variations = { { componentId = 2, drawableId = 1 }, { componentId = 9, drawableId = 1 } },
    },
    -- lspd armory
    {
        PedName = "s_m_y_cop_01",
        PedType = "PED_TYPE_CIVMALE",
        pos = vector3(454.18, -980.11, 29.71),
        heading = 90.0,
        name = "George",
        bubble = "T'as besoin de quoi ?",
        variations = { { componentId = 0, drawableId = 0, textureId = 1 }, { componentId = 9, drawableId = 2 } },
        props = { { componentId = 1, drawableId = 1 } },
    },

    -- agatha gov
    {
        PedName = "ig_agatha",
        PedType = "PED_TYPE_CIVFEMALE",
        pos = vector3(-550.76, -190.07, 36.72),
        heading = 193.6,
        scenario = "PROP_HUMAN_SEAT_ARMCHAIR",
        -- name = "Agatha",
        bubble = "Bonjour, je suis ~y~Agatha~s~, que puis-je faire pour vous ?",
    },

    -- simeon premium deluxe motorsport
    {
        PedName = "ig_siemonyetarian",
        PedType = "PED_TYPE_CIVMALE",
        pos = vector3(-57.01, -1098.94, 25.44),
        heading = 20.0,
        scenario = "WORLD_HUMAN_HANG_OUT_STREET",
        name = "Simeon Yetarian",
        offsetZ = 0.25
    },

    -- ems
    {
        PedName = "s_m_m_doctor_01",
        PedType = "PED_TYPE_MEDIC",
        pos = vector3(309.28, -594.70, 41.80),
        heading = 45.0,
        scenario = "PROP_HUMAN_SEAT_ARMCHAIR",
        name = "Baker",
        variations = { { componentId = 8, drawableId = 2 } },
    },

    -- mechanic
    {
        PedName = "S_F_M_Autoshop_01",
        PedType = "PED_TYPE_CIVFEMALE",
        pos = vector3(-1144.08, -2001.85, 12.21),
        heading = 320.0,
        offsetZ = 0.33
    },

    -- pacific bank
    {
        PedName = "a_m_y_business_02",
        PedType = "PED_TYPE_CIVMALE",
        pos = vector3(248.95, 224.51, 104.97),
        heading = 166.76,
        scenario = "PROP_HUMAN_SEAT_BENCH",
        name = "Philippe",
        bubble = "Besoin de déposer de l'argent sur le compte de votre entreprise ?",
        variations = { { componentId = 8, drawableId = 0, textureId = 4 } },
    },
    {
        PedName = "a_m_y_business_02",
        PedType = "PED_TYPE_CIVMALE",
        pos = vector3(243.71, 226.4, 104.97),
        heading = 166.76,
        scenario = "PROP_HUMAN_SEAT_BENCH",
        name = "Robert",
        bubble = "Ici pour un retrait ?",
        variations = { { componentId = 0, drawableId = 1, textureId = 1 }, { componentId = 2, drawableId = 1 }, { componentId = 8, drawableId = 0, textureId = 4 } },
    },

    -- insurance office
    {
        PedName = "a_f_y_femaleagent",
        PedType = "PED_TYPE_CIVFEMALE",
        pos = vector3(-138.81, -633.84, 167.84),
        heading = 10.0,
        name = "Christine",
        bubble = "Bonjour, je vous laisse vous diriger vers le bureau au fond à gauche",
    },
    {
        PedName = "ig_barry",
        PedType = "PED_TYPE_CIVMALE",
        pos = vector3(-125.67, -641.90, 167.32),
        heading = 50.0,
        scenario = "PROP_HUMAN_SEAT_BENCH",
        name = "Barry",
        bubble = "Bonjour, que puis-je faire pour vous ?",
        props = { { componentId = 1, drawableId = 0 } },
    },

    -- tattoo
    {
        PedName = "a_m_y_ktown_01",
        PedType = "PED_TYPE_CIVMALE",
        pos = vector3(319.71, 180.9, 102.61),
        heading = 254.42,
        scenario = "WORLD_HUMAN_HANG_OUT_STREET"
    },
    {
        PedName = "a_m_y_ktown_01",
        PedType = "PED_TYPE_CIVMALE",
        pos = vector3(-1152.14, -1424.01, 3.97),
        heading = 128.46,
        scenario = "WORLD_HUMAN_HANG_OUT_STREET",
    },
    {
        PedName = "a_m_y_ktown_01",
        PedType = "PED_TYPE_CIVMALE",
        pos = vector3(-3170.54, 1073.1, 19.85),
        heading = 20.83,
        scenario = "WORLD_HUMAN_HANG_OUT_STREET",
    },
    {
        PedName = "a_m_y_ktown_01",
        PedType = "PED_TYPE_CIVMALE",
        pos = vector3(1862.45, 3748.43, 32.05),
        heading = 24.46,
        scenario = "WORLD_HUMAN_HANG_OUT_STREET",
    },
    {
        PedName = "a_m_y_ktown_01",
        PedType = "PED_TYPE_CIVMALE",
        pos = vector3(-292.04, 6199.83, 30.50),
        heading = 228.9,
        scenario = "WORLD_HUMAN_HANG_OUT_STREET",
    },

    { -- ammunation
      PedName = "s_m_y_ammucity_01",
      PedType = "PED_TYPE_CIVMALE",
      pos = vector3(22.07, -1104.93, 28.82),
      heading = 158.97,
      scenario = "WORLD_HUMAN_HANG_OUT_STREET",
    },

    -- Lost arme
    {
        PedName = "g_m_y_lost_03",
        PedType = "PED_TYPE_CIVMALE",
        pos = vector3(987.22, -144.19, 73.29),
        heading = 140.0,
        scenario = "WORLD_HUMAN_SMOKING_POT_CLUBHOUSE",
        name = "Johnny Grey",
        bubble = "Salut, Vielle charue, allez prend ta bécanne et trace chercher ta caisse!!! ",
        props = { { componentId = 1, drawableId = 0 } },
    },

    -- old format, need update
    -- Superettes = {
    -- PedName = "mp_m_shopkeep_01",
    -- PedType = "PED_TYPE_CIVMALE",
    -- PosList = {
    --     {
    --         pos = vector3(24.129, -1345.156, 28.497),
    --         heading = 266.946
    --     },
    --     {
    --         pos = vector3(2557.14, 380.53, 107.622),
    --         heading = 2.0
    --     },
    --     {
    --         pos = vector3(-3038.87, 584.37, 6.97),
    --         heading = 23.0
    --     },
    --     {
    --         pos = vector3(-3242.28, 999.72, 11.850),
    --         heading = 354.8
    --     },
    --     {
    --         pos = vector3(549.4, 2671.39, 41.176),
    --         heading = 96.5
    --     },
    --     {
    --         pos = vector3(1959.76, 3739.87, 31.363),
    --         heading = 289.7
    --     },
    --     {
    --         pos = vector3(2677.86, 3279.12, 54.261),
    --         heading = 332.8
    --     },
    --     {
    --         pos = vector3(1727.61, 6415.37, 34.057),
    --         heading = 246.5
    --     },
    --     {
    --         pos = vector3(1134.04, -982.48, 45.45),
    --         heading = 277.0
    --     },
    --     {
    --         pos = vector3(-1221.79, -908.63, 11.35),
    --         heading = 41.0
    --     },
    --     {
    --         pos = vector3(-1486.06, -377.75, 39.163),
    --         heading = 124.0
    --     },
    --     {
    --         pos = vector3(-2966.22, 390.79, 14.054),
    --         heading = 87.0
    --     },
    --     {
    --         pos = vector3(1166.05, 2710.94, 37.167),
    --         heading = 181.0
    --     },
    --     {
    --         pos = vector3(1392.39, 3606.44, 33.995),
    --         heading = 203.0
    --     },
    --     {
    --         pos = vector3(-46.49, -1758.17, 28.47),
    --         heading = 48.0
    --     },
    --     {
    --         pos = vector3(1165.04, -323.00, 68.27),
    --         heading = 104.0
    --     },
    --     {
    --         pos = vector3(-705.89, -913.97, 18.26),
    --         heading = 97.0
    --     },
    --     {
    --         pos = vector3(-1819.79, 794.18, 137.20),
    --         heading = 138.0
    --     },
    --     {
    --         pos = vector3(1697.71, 4922.87, 41.08),
    --         heading = 317.0
    --     },
    --     {
    --         pos = vector3(372.48, 326.44, 102.59),
    --         heading = 252.22
    --     },
    -- }
    -- },
}
