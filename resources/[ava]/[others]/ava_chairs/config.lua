-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVAConfig = {}

AVAConfig.Key = 23 -- F (38 is E)

AVAConfig.Props = {
    [`v_corp_offchair`] = {
        isChair = true,
        offset = vector4(0.0, 0.05, 0.5, 180.0)
    },
    [`prop_gc_chair02`] = {
        isChair = true,
        offset = vector4(0.0, 0.05, 0.0, 180.0)
    },
    [`imp_prop_impexp_offchair_01a`] = {
        isChair = true,
        offset = vector4(0.0, 0.05, 0.0, 180.0)
    },
    [`ba_prop_int_glam_stool`] = { -- gabz vu bar
        isChair = true,
        offset = vector4(0.0, 0.05, 0.8, 180.0)
    },
    [`prop_sol_chair`] = {
        isChair = true,
        offset = vector4(0.0, 0.05, 0.65, 180.0)
    },
    [`prop_bench_01a`] = {
        isChair = true,
        offsets = {
            vector4(0.6, 0.0, 0.5, 180.0),
            vector4(0.0, 0.0, 0.5, 180.0),
            vector4(-0.6, 0.0, 0.5, 180.0),
        }
    },
    [`prop_bench_02`] = {
        isChair = true,
        offsets = {
            vector4(0.82, 0.0, 0.5, 180.0),
            vector4(0.0, 0.0, 0.5, 180.0),
            vector4(-0.82, 0.0, 0.5, 180.0),
        }
    },
    [`prop_bench_06`] = {
        isChair = true,
        offsets = {
            vector4(0.82, 0.0, 0.5, 180.0),
            vector4(0.0, 0.0, 0.5, 180.0),
            vector4(-0.82, 0.0, 0.5, 180.0),
        }
    },
    [`prop_bench_09`] = {
        isChair = true,
        offsets = {
            vector4(0.82, 0.0, 0.32, 180.0),
            vector4(0.0, 0.0, 0.32, 180.0),
            vector4(-0.82, 0.0, 0.32, 180.0),
        }
    },
    [`prop_picnictable_01`] = {
        isChair = true,
        offsets = {
            vector4(0.5, 0.5, 0.5, 180.0),
            vector4(0.5, -0.5, 0.5, 0.0),
            vector4(-0.5, 0.5, 0.5, 180.0),
            vector4(-0.5, -0.5, 0.5, 0.0),
        }
    },
    [`prop_busstop_02`] = {
        isChair = true,
        offsets = {
            vector4(0.0, 0.3, 0.5, 180.0),
            vector4(0.7, 0.3, 0.5, 180.0),
            vector4(1.4, 0.3, 0.5, 180.0),
        }
    },
    [`prop_busstop_05`] = {
        isChair = true,
        offsets = {
            vector4(-0.15, 0.3, 0.6, 180.0),
            vector4(0.5, 0.3, 0.6, 180.0),
            vector4(1.15, 0.3, 0.6, 180.0),
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
    [`v_med_bed1`] = {
        isBed = true,
        offset = vector4(0.0, 0.0, 0.5, 185.0)
    },
    [`v_med_emptybed`] = {
        isBed = true,
        offset = vector4(0.0, 0.0, 0.3, 185.0)
    },
    [-1519439119] = { -- gabz pillbox radio
        isBed = true,
        offset = vector4(0.0, 0.0, 1.1, 185.0)
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
