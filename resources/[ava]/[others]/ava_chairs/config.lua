-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVAConfig = {}

AVAConfig.Key = 23 -- F (38 is E)

-- AVAConfig.Props = {
--     { hash = -1531508740, offX = 0.0, offY = 0.0, offZ = -1.0, offHeading = 180.0, type = "Chair" },
--     { hash = GetHashKey("v_med_bed1"), offX = 0.0, offY = 0.0, offZ = -0.8, offHeading = 180.0, type = "Bed" },
--     { hash = GetHashKey("v_med_bed2"), offX = 0.0, offY = 0.0, offZ = -0.8, offHeading = 0.0, type = "Bed" },
--     { hash = GetHashKey("prop_bench_01a"), offX = 0.0, offY = 0.0, offZ = -0.4, offHeading = 180.0, type = "Chair" },
--     { hash = GetHashKey("prop_busstop_02"), offX = 0.0, offY = 0.5, offZ = -0.4, offHeading = 180.0, type = "Chair" },
--     { hash = GetHashKey("v_corp_offchair"), offX = 0.0, offY = 0.05, offZ = -0.4, offHeading = 180.0, type = "Chair" },
--     { hash = -853526657, offX = 0.0, offY = 0.05, offZ = -1.0, offHeading = 180.0, type = "Chair" }, -- ls custom office
--     { hash = 558578166, offX = 0.0, offY = 0.05, offZ = -0.9, offHeading = 180.0, type = "Chair" },
--     { hash = 1840174940, offX = 0.0, offY = 0.05, offZ = -0.1, offHeading = 180.0, type = "Chair" }, -- gabz vu bar
--     { hash = -1633198649, offX = 0.0, offY = 0.05, offZ = -0.35, offHeading = 180.0, type = "Chair" }, -- freedmanh city hall, gov chair
-- }

AVAConfig.Props = {
    [`v_corp_offchair`] = {
        isChair = true,
        offset = vector4(0.0, 0.05, 0.5, 180.0)
    },
    [`prop_bench_01a`] = {
        isChair = true,
        offsets = {
            vector4(0.6, 0.0, 0.5, 180.0),
            vector4(0.0, 0.0, 0.5, 180.0),
            vector4(-0.6, 0.0, 0.5, 180.0),
        }
    },
    [`fix_v_ilev_ph_bench`] = {
        isChair = true,
        offsets = {
            vector4(1.25, 0.0, 0.54, 180.0),
            vector4(0.62, 0.0, 0.54, 180.0),
            vector4(0.0, 0.0, 0.54, 180.0),
            vector4(-0.62, 0.0, 0.54, 180.0),
            vector4(-1.25, 0.0, 0.54, 180.0),
        }
    },
}


AVAConfig.SitAnims = {
    Male = {
        scenario = "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER",
        -- dict = ,
        -- anim =
    },
    Female = {
        scenario = "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER",
        -- dict = ,
        -- anim =
    },
}
AVAConfig.LayAnims = {
    Male = {
        dict = "switch@trevor@annoys_sunbathers",
        anim = "trev_annoys_sunbathers_loop_guy"
    },
    Female = {
        dict = "switch@trevor@annoys_sunbathers",
        anim = "trev_annoys_sunbathers_loop_guy"
    },
}

-- dict = "amb@world_human_sunbathe@female@front@base",
-- anim = "base"
