-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVAConfig = {}

-- If default exist, it will be used, else min will be the default
-- {min = 0, default = 0, max = 100} means that the value will be reduced to be between 0.00 and 1.00
-- {min = -100, default = 0, max = 100} means that the value will be reduced to be between -1.00 and 1.00
AVAConfig.skinComponents = {
    gender = {min = 0, max = 1},
    -- #region HeadBlendData
    father = {min = 0, max = 44}, -- Father ids : 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 42, 43, 44
    mother = {min = 0, default = 21, max = 45}, -- Mother ids : 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 45
    shape_mix = {min = 0, default = 50, max = 100},
    skin_mix = {min = 0, default = 50, max = 100},
    -- #endregion HeadBlendData

    -- #region Ped face
    -- Nose
    nose_width = {min = -100, default = 0, max = 100},
    nose_peak_hight = {min = -100, default = 0, max = 100},
    nose_peak_lenght = {min = -100, default = 0, max = 100},
    nose_bone_high = {min = -100, default = 0, max = 100},
    nose_peak_lowering = {min = -100, default = 0, max = 100},
    nose_bone_twist = {min = -100, default = 0, max = 100},
    -- Eyebrows
    eyebrow_high = {min = -100, default = 0, max = 100},
    eyebrow_forward = {min = -100, default = 0, max = 100},
    -- Cheeks
    cheeks_bone_high = {min = -100, default = 0, max = 100},
    cheeks_bone_width = {min = -100, default = 0, max = 100},
    cheeks_width = {min = -100, default = 0, max = 100},
    -- Eyes
    eyes_openning = {min = -100, default = 0, max = 100},
    eyes_color = {min = 0, max = 32},
    -- Lips
    lips_thickness = {min = -100, default = 0, max = 100},
    -- Jaw
    jaw_bone_width = {min = -100, default = 0, max = 100},
    jaw_bone_back_lenght = {min = -100, default = 0, max = 100},
    -- Chin
    chin_bone_lowering = {min = -100, default = 0, max = 100},
    chin_bone_lenght = {min = -100, default = 0, max = 100},
    chin_bone_width = {min = -100, default = 0, max = 100},
    chin_hole = {min = -100, default = 0, max = 100},
    -- Neck
    neck_thickness = {min = -100, default = 0, max = 100},
    -- #endregion Ped face

    -- #region Ped head overlays
    -- Blemishes
    blemishes = {min = 0},
    blemishes_op = {min = 0, max = 100},
    -- Beard
    beard = {min = 0},
    beard_op = {min = 0, default = 0, max = 100},
    beard_color = {min = 0},
    -- Eyebrows
    eyebrows = {min = 0},
    eyebrows_op = {min = 0, default = 50, max = 100},
    eyebrows_color = {min = 0},
    -- Ageing
    ageing = {min = 0},
    ageing_op = {min = 0, max = 100},
    -- Makeup
    makeup = {min = 0},
    makeup_op = {min = 0, max = 100},
    makeup_main_color = {min = 0},
    makeup_scnd_color = {min = 0},
    -- Blush
    blush = {min = 0},
    blush_op = {min = 0, max = 100},
    blush_color = {min = 0},
    -- Complexion
    complexion = {min = 0},
    complexion_op = {min = 0, max = 100},
    -- SunDamage
    sundamage = {min = 0},
    sundamage_op = {min = 0, max = 100},
    -- Lipstick
    lipstick = {min = 0},
    lipstick_op = {min = 0, max = 100},
    lipstick_color = {min = 0},
    -- Moles/Freckles
    moles = {min = 0},
    moles_op = {min = 0, max = 100},
    -- Chest Hair
    chesthair = {min = 0},
    chesthair_op = {min = 0, max = 100},
    chesthair_color = {min = 0},
    -- Body Blemishes
    bodyblemishes = {min = -1},
    bodyblemishes_op = {min = 0, max = 100},
    -- Add Body Blemishes
    addbodyblemishes = {min = -1},
    addbodyblemishes_op = {min = 0, max = 100},
    -- #endregion Ped head overlays

    -- #region Components
    -- Mask
    mask = {min = 0},
    mask_txd = {min = 0},
    -- Torso
    torso = {min = 0},
    torso_txd = {min = 0},
    -- Hairs
    hair = {min = 0},
    hair_txd = {min = 0},
    hair_main_color = {min = 0},
    hair_scnd_color = {min = 0},
    -- Leg
    leg = {min = 0},
    leg_txd = {min = 0},
    -- Bag
    bag = {min = 0},
    bag_txd = {min = 0},
    -- Shoes
    shoes = {min = 0},
    shoes_txd = {min = 0},
    -- Accessory
    accessory = {min = 0},
    accessory_txd = {min = 0},
    -- Undershirt
    undershirt = {min = 0},
    undershirt_txd = {min = 0},
    -- Kevlar
    bodyarmor = {min = 0},
    bodyarmor_txd = {min = 0},
    -- Decals
    decals = {min = 0},
    decals_txd = {min = 0},
    -- Torso
    tops = {min = 0},
    tops_txd = {min = 0},
    -- #endregion Components

    -- #region Props
    -- Hats
    hats = {min = -1},
    hats_txd = {min = 0},
    -- Glasses
    glasses = {min = -1},
    glasses_txd = {min = 0},
    -- Ears
    ears = {min = -1},
    ears_txd = {min = 0},
    -- Watches
    watches = {min = -1},
    watches_txd = {min = 0},
    -- Bracelets
    bracelets = {min = -1},
    bracelets_txd = {min = 0},
    -- #endregion Props

    tattoos = {default = {}},
}

AVAConfig.clothesComponents = {
    "mask",
    "mask_txd",
    "torso",
    "torso_txd",
    "leg",
    "leg_txd",
    "bag",
    "bag_txd",
    "shoes",
    "shoes_txd",
    "accessory",
    "accessory_txd",
    "undershirt",
    "undershirt_txd",
    "bodyarmor",
    "bodyarmor_txd",
    "decals",
    "decals_txd",
    "tops",
    "tops_txd",

    "hats",
    "hats_txd",
    "glasses",
    "glasses_txd",
    "ears",
    "ears_txd",
    "watches",
    "watches_txd",
    "bracelets",
    "bracelets_txd",
}

AVAConfig.ShouldReloadOverlay = {["tattoos"] = true, ["hair"] = true, ["hair_txd"] = true, ["hair_main_color"] = true, ["hair_scnd_color"] = true}

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

