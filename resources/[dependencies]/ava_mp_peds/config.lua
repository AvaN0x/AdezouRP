-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVAConfig = {}

-- If default exist, it will be used, else min will be the default
AVAConfig.allComponents = {
    gender = {category = "gender", min = 0, max = 1},
    -- Hairs
    hair = {category = "hair", min = 0},
    hair_txd = {category = "hair", min = 0},
    main_hair_color = {category = "hair", min = 0},
    scnd_hair_color = {category = "hair", min = 0},
}

AVAConfig.skinComponents = {"gender", "hair", "hair_txd", "main_hair_color", "scnd_hair_color"}
AVAConfig.clothesComponents = {}

AVAConfig.HairOverlays = {
    [0] = {
        -- source https://gist.github.com/Stuyk/c65f345b73a7eab4a0ee30b540e57c76
        [0] = {collection = "mpbeach_overlays", overlay = "FM_Hair_Fuzz"},
        [1] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_001"},
        [2] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_002"},
        [3] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_003"},
        [4] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_004"},
        [5] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_005"},
        [6] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_006"},
        [7] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_007"},
        [8] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_008"},
        [9] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_009"},
        [10] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_013"},
        [11] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_002"},
        [12] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_011"},
        [13] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_012"},
        [14] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_014"},
        [15] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_015"},
        [16] = {collection = "multiplayer_overlays", overlay = "NGBea_M_Hair_000"},
        [17] = {collection = "multiplayer_overlays", overlay = "NGBea_M_Hair_001"},
        [18] = {collection = "multiplayer_overlays", overlay = "NGBus_M_Hair_000"},
        [19] = {collection = "multiplayer_overlays", overlay = "NGBus_M_Hair_001"},
        [20] = {collection = "multiplayer_overlays", overlay = "NGHip_M_Hair_000"},
        [21] = {collection = "multiplayer_overlays", overlay = "NGHip_M_Hair_001"},
        [22] = {collection = "multiplayer_overlays", overlay = "NGInd_M_Hair_000"},
        [24] = {collection = "mplowrider_overlays", overlay = "LR_M_Hair_000"},
        [25] = {collection = "mplowrider_overlays", overlay = "LR_M_Hair_001"},
        [26] = {collection = "mplowrider_overlays", overlay = "LR_M_Hair_002"},
        [27] = {collection = "mplowrider_overlays", overlay = "LR_M_Hair_003"},
        [28] = {collection = "mplowrider2_overlays", overlay = "LR_M_Hair_004"},
        [29] = {collection = "mplowrider2_overlays", overlay = "LR_M_Hair_005"},
        [30] = {collection = "mplowrider2_overlays", overlay = "LR_M_Hair_006"},
        [31] = {collection = "mpbiker_overlays", overlay = "MP_Biker_Hair_000_M"},
        [32] = {collection = "mpbiker_overlays", overlay = "MP_Biker_Hair_001_M"},
        [33] = {collection = "mpbiker_overlays", overlay = "MP_Biker_Hair_002_M"},
        [34] = {collection = "mpbiker_overlays", overlay = "MP_Biker_Hair_003_M"},
        [35] = {collection = "mpbiker_overlays", overlay = "MP_Biker_Hair_004_M"},
        [36] = {collection = "mpbiker_overlays", overlay = "MP_Biker_Hair_005_M"},
        [37] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_001"},
        [38] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_002"},
        [39] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_003"},
        [40] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_004"},
        [41] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_005"},
        [42] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_006"},
        [43] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_007"},
        [44] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_008"},
        [45] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_009"},
        [46] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_013"},
        [47] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_002"},
        [48] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_011"},
        [49] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_012"},
        [50] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_014"},
        [51] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_015"},
        [52] = {collection = "multiplayer_overlays", overlay = "NGBea_M_Hair_000"},
        [53] = {collection = "multiplayer_overlays", overlay = "NGBea_M_Hair_001"},
        [54] = {collection = "multiplayer_overlays", overlay = "NGBus_M_Hair_000"},
        [55] = {collection = "multiplayer_overlays", overlay = "NGBus_M_Hair_001"},
        [56] = {collection = "multiplayer_overlays", overlay = "NGHip_M_Hair_000"},
        [57] = {collection = "multiplayer_overlays", overlay = "NGHip_M_Hair_001"},
        [58] = {collection = "multiplayer_overlays", overlay = "NGInd_M_Hair_000"},
        [59] = {collection = "mplowrider_overlays", overlay = "LR_M_Hair_000"},
        [60] = {collection = "mplowrider_overlays", overlay = "LR_M_Hair_001"},
        [61] = {collection = "mplowrider_overlays", overlay = "LR_M_Hair_002"},
        [62] = {collection = "mplowrider_overlays", overlay = "LR_M_Hair_003"},
        [63] = {collection = "mplowrider2_overlays", overlay = "LR_M_Hair_004"},
        [64] = {collection = "mplowrider2_overlays", overlay = "LR_M_Hair_005"},
        [65] = {collection = "mplowrider2_overlays", overlay = "LR_M_Hair_006"},
        [66] = {collection = "mpbiker_overlays", overlay = "MP_Biker_Hair_000_M"},
        [67] = {collection = "mpbiker_overlays", overlay = "MP_Biker_Hair_001_M"},
        [68] = {collection = "mpbiker_overlays", overlay = "MP_Biker_Hair_002_M"},
        [69] = {collection = "mpbiker_overlays", overlay = "MP_Biker_Hair_003_M"},
        [70] = {collection = "mpbiker_overlays", overlay = "MP_Biker_Hair_004_M"},
        [71] = {collection = "mpbiker_overlays", overlay = "MP_Biker_Hair_005_M"},
        [72] = {collection = "mpgunrunning_overlays", overlay = "MP_Gunrunning_Hair_M_000_M"},
        [73] = {collection = "mpgunrunning_overlays", overlay = "MP_Gunrunning_Hair_M_001_M"},
        -- source https://forum.cfx.re/t/how-to-implement-your-original-freemode-ped-haircuts-correctly/4794727
        [74] = {collection = "mpvinewood_overlays", overlay = "MP_Vinewood_Hair_M_000_M"},
        [75] = {collection = "mptuner_overlays", overlay = "MP_Tuner_Hair_001_M"},
        [76] = {collection = "mpsecurity_overlays", overlay = "MP_Security_Hair_001_M"},
    },
    [1] = {
        -- source https://gist.github.com/Stuyk/c65f345b73a7eab4a0ee30b540e57c76
        [0] = {collection = "mpbeach_overlays", overlay = "FM_Hair_Fuzz"},
        [1] = {collection = "multiplayer_overlays", overlay = "NG_F_Hair_001"},
        [2] = {collection = "multiplayer_overlays", overlay = "NG_F_Hair_002"},
        [3] = {collection = "multiplayer_overlays", overlay = "NG_F_Hair_003"},
        [4] = {collection = "multiplayer_overlays", overlay = "NG_F_Hair_004"},
        [5] = {collection = "multiplayer_overlays", overlay = "NG_F_Hair_005"},
        [6] = {collection = "multiplayer_overlays", overlay = "NG_F_Hair_006"},
        [7] = {collection = "multiplayer_overlays", overlay = "NG_F_Hair_007"},
        [8] = {collection = "multiplayer_overlays", overlay = "NG_F_Hair_008"},
        [9] = {collection = "multiplayer_overlays", overlay = "NG_F_Hair_009"},
        [10] = {collection = "multiplayer_overlays", overlay = "NG_F_Hair_010"},
        [11] = {collection = "multiplayer_overlays", overlay = "NG_F_Hair_011"},
        [12] = {collection = "multiplayer_overlays", overlay = "NG_F_Hair_012"},
        [13] = {collection = "multiplayer_overlays", overlay = "NG_F_Hair_013"},
        [14] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_014"},
        [15] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_015"},
        [16] = {collection = "multiplayer_overlays", overlay = "NGBea_F_Hair_000"},
        [17] = {collection = "multiplayer_overlays", overlay = "NGBea_F_Hair_001"},
        [18] = {collection = "multiplayer_overlays", overlay = "NG_F_Hair_007"},
        [19] = {collection = "multiplayer_overlays", overlay = "NGBus_F_Hair_000"},
        [20] = {collection = "multiplayer_overlays", overlay = "NGBus_F_Hair_001"},
        [21] = {collection = "multiplayer_overlays", overlay = "NGBea_F_Hair_001"},
        [22] = {collection = "multiplayer_overlays", overlay = "NGHip_F_Hair_000"},
        [23] = {collection = "multiplayer_overlays", overlay = "NGInd_F_Hair_000"},
        [25] = {collection = "mplowrider_overlays", overlay = "LR_F_Hair_000"},
        [26] = {collection = "mplowrider_overlays", overlay = "LR_F_Hair_001"},
        [27] = {collection = "mplowrider_overlays", overlay = "LR_F_Hair_002"},
        [28] = {collection = "mplowrider2_overlays", overlay = "LR_F_Hair_003"},
        [29] = {collection = "mplowrider2_overlays", overlay = "LR_F_Hair_003"},
        [30] = {collection = "mplowrider2_overlays", overlay = "LR_F_Hair_004"},
        [31] = {collection = "mplowrider2_overlays", overlay = "LR_F_Hair_006"},
        [32] = {collection = "mpbiker_overlays", overlay = "MP_Biker_Hair_000_F"},
        [33] = {collection = "mpbiker_overlays", overlay = "MP_Biker_Hair_001_F"},
        [34] = {collection = "mpbiker_overlays", overlay = "MP_Biker_Hair_002_F"},
        [35] = {collection = "mpbiker_overlays", overlay = "MP_Biker_Hair_003_F"},
        [36] = {collection = "multiplayer_overlays", overlay = "NG_F_Hair_003"},
        [37] = {collection = "mpbiker_overlays", overlay = "MP_Biker_Hair_006_F"},
        [38] = {collection = "mpbiker_overlays", overlay = "MP_Biker_Hair_004_F"},
        [39] = {collection = "multiplayer_overlays", overlay = "NG_F_Hair_001"},
        [40] = {collection = "multiplayer_overlays", overlay = "NG_F_Hair_002"},
        [41] = {collection = "multiplayer_overlays", overlay = "NG_F_Hair_003"},
        [42] = {collection = "multiplayer_overlays", overlay = "NG_F_Hair_004"},
        [43] = {collection = "multiplayer_overlays", overlay = "NG_F_Hair_005"},
        [44] = {collection = "multiplayer_overlays", overlay = "NG_F_Hair_006"},
        [45] = {collection = "multiplayer_overlays", overlay = "NG_F_Hair_007"},
        [46] = {collection = "multiplayer_overlays", overlay = "NG_F_Hair_008"},
        [47] = {collection = "multiplayer_overlays", overlay = "NG_F_Hair_009"},
        [48] = {collection = "multiplayer_overlays", overlay = "NG_F_Hair_010"},
        [49] = {collection = "multiplayer_overlays", overlay = "NG_F_Hair_011"},
        [50] = {collection = "multiplayer_overlays", overlay = "NG_F_Hair_012"},
        [51] = {collection = "multiplayer_overlays", overlay = "NG_F_Hair_013"},
        [52] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_014"},
        [53] = {collection = "multiplayer_overlays", overlay = "NG_M_Hair_015"},
        [54] = {collection = "multiplayer_overlays", overlay = "NGBea_F_Hair_000"},
        [55] = {collection = "multiplayer_overlays", overlay = "NGBea_F_Hair_001"},
        [56] = {collection = "multiplayer_overlays", overlay = "NG_F_Hair_007"},
        [57] = {collection = "multiplayer_overlays", overlay = "NGBus_F_Hair_000"},
        [58] = {collection = "multiplayer_overlays", overlay = "NGBus_F_Hair_001"},
        [59] = {collection = "multiplayer_overlays", overlay = "NGBea_F_Hair_001"},
        [60] = {collection = "multiplayer_overlays", overlay = "NGHip_F_Hair_000"},
        [61] = {collection = "multiplayer_overlays", overlay = "NGInd_F_Hair_000"},
        [62] = {collection = "mplowrider_overlays", overlay = "LR_F_Hair_000"},
        [63] = {collection = "mplowrider_overlays", overlay = "LR_F_Hair_001"},
        [64] = {collection = "mplowrider_overlays", overlay = "LR_F_Hair_002"},
        [65] = {collection = "mplowrider2_overlays", overlay = "LR_F_Hair_003"},
        [66] = {collection = "mplowrider2_overlays", overlay = "LR_F_Hair_003"},
        [67] = {collection = "mplowrider2_overlays", overlay = "LR_F_Hair_004"},
        [68] = {collection = "mplowrider2_overlays", overlay = "LR_F_Hair_006"},
        [69] = {collection = "mpbiker_overlays", overlay = "MP_Biker_Hair_000_F"},
        [70] = {collection = "mpbiker_overlays", overlay = "MP_Biker_Hair_001_F"},
        [71] = {collection = "mpbiker_overlays", overlay = "MP_Biker_Hair_002_F"},
        [72] = {collection = "mpbiker_overlays", overlay = "MP_Biker_Hair_003_F"},
        [73] = {collection = "multiplayer_overlays", overlay = "NG_F_Hair_003"},
        [74] = {collection = "mpbiker_overlays", overlay = "MP_Biker_Hair_006_F"},
        [75] = {collection = "mpbiker_overlays", overlay = "MP_Biker_Hair_004_F"},
        [76] = {collection = "mpgunrunning_overlays", overlay = "MP_Gunrunning_Hair_F_000_F"},
        [77] = {collection = "mpgunrunning_overlays", overlay = "MP_Gunrunning_Hair_F_001_F"},
        -- source https://forum.cfx.re/t/how-to-implement-your-original-freemode-ped-haircuts-correctly/4794727
        [78] = {collection = "mpvinewood_overlays", overlay = "MP_Vinewood_Hair_F_000_F"},
        [79] = {collection = "mptuner_overlays", overlay = "MP_Tuner_Hair_000_F"},
        [80] = {collection = "mpsecurity_overlays", overlay = "MP_Security_Hair_000_F"},
    },
}

--[[


0               Blemishes             0 - 23,   255  
1               Facial Hair           0 - 28,   255  
2               Eyebrows              0 - 33,   255  
3               Ageing                0 - 14,   255  
4               Makeup                0 - 74,   255  
5               Blush                 0 - 6,    255  
6               Complexion            0 - 11,   255  
7               Sun Damage            0 - 10,   255  
8               Lipstick              0 - 9,    255  
9               Moles/Freckles        0 - 17,   255  
10              Chest Hair            0 - 16,   255  
11              Body Blemishes        0 - 11,   255  
12              Add Body Blemishes    0 - 1,    255  

]]
