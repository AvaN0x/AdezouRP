-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
ConfigTeleports = {

    DrawDistance = 10,
    DefaultSize = { x = 1.5, y = 1.5, z = 1.0 },
    DefaultColor = { r = 255, g = 255, b = 255 },

    TeleportersList = {
        -- hospital elevator
        {
            tpEnter = {
                pos = vector3(336.92, -589.34, 42.29),
                heading = 64.0,
                -- size  = {x = 1.5, y = 1.5, z = 1.0},
                -- color = {r = 255, g = 0, b = 255},
                label = "Monter sur le toit",
            },
            tpExit = {
                pos = vector3(339.02, -584.04, 73.18),
                heading = 265.0,
                label = "Descendre"
            },
            authorizedJobs = { "ems" },
            locked = true,
        },
        -- hospital elevator
        {
            tpEnter = {
                pos = vector3(335.78, -592.50, 42.29),
                heading = 64.0,
                -- size  = {x = 1.5, y = 1.5, z = 1.0},
                -- color = {r = 255, g = 0, b = 255},
                label = "Descendre",
            },
            tpExit = {
                pos = vector3(323.50, -583.24, 27.87),
                heading = 250.0,
                label = "Monter à l'étage"
            },
            authorizedJobs = { "ems" },
            locked = false,
        },
        -- morgue
        {
            tpEnter = {
                pos = vector3(240.65, -1379.29, 32.76),
                heading = 140.0,
                -- size  = {x = 1.5, y = 1.5, z = 1.0},
                -- color = {r = 255, g = 0, b = 255},
                label = "Entrer dans la morgue",
            },
            tpExit = {
                pos = vector3(248.99, -1369.80, 28.67),
                heading = 330.0,
                label = "Sortir de la morgue"
            },
            authorizedJobs = { "ems" },
            locked = true,
        },
        -- nightclub entry
        {
            tpEnter = {
                pos = vector3(-676.83, -2458.72, 12.96),
                heading = 141.0,
                -- size  = {x = 1.5, y = 1.5, z = 1.0},
                -- color = {r = 255, g = 0, b = 255},
                label = "Entrer",
            },
            tpExit = {
                pos = vector3(-1569.3, -3017.41, -75.39),
                heading = 356.0,
                label = "Sortir"
            },
            authorizedJobs = { "nightclub" },
            locked = true,
        },
        -- nightclub vehicle entry
        {
            tpEnter = {
                pos = vector3(-1641.32, -2989.73, -78.07),
                heading = 270.0,
                size = { x = 2.5, y = 2.5, z = 1.0 },
                -- color = {r = 255, g = 0, b = 255},
                label = "Sortir",
            },
            tpExit = {
                pos = vector3(-675.28, -2390.24, 12.88),
                heading = 60.0, size = { x = 2.5, y = 2.5, z = 1.0 }, distance = 20,
                label = "Entrer"
            },
            authorizedJobs = { "nightclub" },
            allowVehicles = true,
            locked = true,
        },

        -- arcade entry
        {
            tpEnter = {
                pos = vector3(-1270.27, -305.18, 36.01),
                heading = 250.0,
                -- size  = {x = 1.5, y = 1.5, z = 1.0},
                -- color = {r = 255, g = 0, b = 255},
                label = "Entrer",
            },
            tpExit = {
                pos = vector3(2737.95, -374.35, -48.97),
                heading = 180.0,
                label = "Sortir"
            },
            locked = false,
        },
        -- arcade vehicle entry
        {
            tpEnter = {
                pos = vector3(-1288.73, -275.0, 37.81),
                heading = 30.0,
                size = { x = 2.5, y = 2.5, z = 1.0 },
                -- color = {r = 255, g = 0, b = 255},
                label = "Entrer",
            },
            tpExit = {
                pos = vector3(2680.36, -361.16, -56.17),
                heading = 270.0, size = { x = 2.5, y = 2.5, z = 1.0 },
                label = "Sortir"
            },
            allowVehicles = true,
            locked = false,
        },

        -- comedy club
        {
            tpEnter = {
                pos = vector3(-430.142, 261.665, 82.02),
                heading = 175.0,
                -- size  = {x = 1.5, y = 1.5, z = 1.0},
                -- color = {r = 255, g = 0, b = 255},
                label = "Entrer",
            },
            tpExit = {
                pos = vector3(-458.790, 284.750, 77.54),
                heading = 265.0,
                label = "Sortir"
            },
            locked = false,
        },

        -- bahama
        {
            tpEnter = {
                pos = vector3(-1389.31, -592.07, 29.34),
                heading = 30.0, size = { x = 1.2, y = 1.2, z = 1.0 },
                label = "Entrer au bar"
            },
            tpExit = {
                pos = vector3(-1385.06, -606.44, 29.34),
                heading = 120.0, size = { x = 1.2, y = 1.2, z = 1.0 },
                label = "Sortir du bar"
            },
            authorizedJobs = { "bahama" },
            locked = true,
        },

        -- bunker
        -- arcade vehicle entry
        {
            tpEnter = {
                pos = vector3(2109.64, 3325.24, 44.38),
                heading = 120.0,
                size = { x = 2.5, y = 2.5, z = 1.0 },
                -- color = {r = 255, g = 0, b = 255},
                label = "Entrer",
            },
            tpExit = {
                pos = vector3(891.13, -3245.97, -99.25),
                heading = 85.0, size = { x = 2.5, y = 2.5, z = 1.0 },
                label = "Sortir"
            },
            authorizedJobs = { "biker_lost" },
            allowVehicles = true,
            locked = true,
        },

        -- télésiege
        {
            tpEnter = {
                pos = vector3(-741.06, 5593.22, 40.67),
                heading = 0.0,
                -- size  = {x = 1.5, y = 1.5, z = 1.0},
                -- color = {r = 255, g = 0, b = 255},
                label = "Monter",
            },
            tpExit = {
                pos = vector3(446.35, 5569.02, 780.21),
                heading = 0.0,
                label = "Descendre"
            },
            locked = false,
        },

        -- fib
        {
            tpEnter = {
                pos = vector3(136.08, -761.77, 44.77),
                heading = 160.00,
                -- size  = {x = 1.5, y = 1.5, z = 1.0},
                -- color = {r = 255, g = 0, b = 255},
                label = "Monter à l'étage",
            },
            tpExit = {
                pos = vector3(136.05, -762.05, 241.17),
                heading = 160.00,
                label = "Descendre"
            },
            authorizedJobs = { "lspd" },
            locked = true,
        },

        -- insurance
        {
            tpEnter = {
                pos = vector3(-116.64, -603.31, 35.30),
                heading = 250.00,
                -- size  = {x = 1.0, y = 1.0, z = 1.0},
                -- color = {r = 255, g = 0, b = 255},
                label = "Monter au Bureau d'assurances",
            },
            tpExit = {
                pos = vector3(-141.72, -617.62, 167.84),
                heading = 270.00,
                label = "Descendre"
            },
            locked = false,
        },

        -- ls tuner car meet
        {
            tpEnter = {
                pos = vector3(783.37, -1867.88, 28.26),
                heading = 260.0, size = { x = 2.5, y = 2.5, z = 1.0 },
                label = "Entrer"
            },
            tpExit = {
                pos = vector3(-2219.78, 1156.36, 28.79),
                heading = 220.0, size = { x = 2.5, y = 2.5, z = 1.0 },
                label = "Sortir"
            },
            allowVehicles = true,
            locked = false,
        },

        -- Weed Field
        {
            tpEnter = {
                pos = vector3(717.16, -657.72, 26.76),
                heading = 90.29, size = { x = 2.5, y = 2.5, z = 1.0 },
                label = "Entrer",
                noMarker = true
            },
            tpExit = {
                pos = vector3(172.80, -1008.20, -99.98),
                heading = 181.09, size = { x = 1.2, y = 1.2, z = 1.0 },
                label = "Sortir"
            },
        },

        -- Cocaïne Treatment
        {
            tpEnter = {
                pos = vector3(1017.72, -2529.38, 27.32),
                heading = 84.94, size = { x = 2.5, y = 2.5, z = 1.0 },
                label = "Entrer",
                noMarker = true
            },
            tpExit = {
                pos = vector3(1088.66, -3187.79, -39.97),
                heading = 183, size = { x = 1.2, y = 1.2, z = 1.0 },
                label = "Sortir"
            },
        },
        -- Meth Treatment
        {
            tpEnter = {
                pos = vector3(201.56, 2462.38, 54.71),
                heading = 183.10, size = { x = 2.5, y = 2.5, z = 1.0 },
                label = "Entrer",
                noMarker = true
            },
            tpExit = {
                pos = vector3(996.82, -3200.67, -37.37),
                heading = 294.02, size = { x = 1.2, y = 1.2, z = 1.0 },
                label = "Sortir"
            },
        },
        -- Go fast
        {
            tpEnter = {
                pos = vector3(-1408.52, 538.33, 121.94),
                heading = 269.67, size = { x = 2.5, y = 2.5, z = 1.0 },
                label = "Entrer"
            },
            tpExit = {
                pos = vector3(202.08, -1002.99, -99.98),
                heading = 177.86, size = { x = 2.5, y = 2.5, z = 1.0 },
                label = "Sortir"
            },
            allowvehicles = true,
        },




        -- maze bank arena
        -- {
        -- 	tpEnter = {
        -- 		pos = vector3(-366.0, -1867.94, 19.55),
        -- 		heading = 15.0,
        -- 		size  = {x = 5.0, y = 5.0, z = 1.0},
        -- 		-- color = {r = 255, g = 0, b = 255},
        -- 		label = "Entrer"
        -- 	},
        -- 	tpExit = {
        -- 		pos = vector3(2844.9, -3911.09, 139.02),
        -- 		heading = 0.0,
        -- 		size  = {x = 2.5, y = 2.5, z = 1.0},
        -- 		label = "Sortir"
        -- 	},
        -- 	authorizedJobs = { '' },
        -- 	allowVehicles = true,
        -- 	locked = false
        -- },

        -- exemple to teleport vehicle
        -- {
        -- 	tpEnter = {
        -- 		pos = vector3(-1908.68, 2049.63, 139.76),
        -- 		heading = 180.0,
        -- 		size  = {x = 2.5, y = 2.5, z = 1.0},
        -- 		-- color = {r = 255, g = 0, b = 255},
        --      -- distance = 15,
        -- 		label = "Entrer"
        -- 	},
        -- 	tpExit = {
        -- 		pos = vector3(-1899.85, 2018.84, 139.86),
        -- 		heading = 0.0,
        -- 		size  = {x = 2.5, y = 2.5, z = 1.0},
        --      -- distance = 15,
        -- 		label = "Sortir"
        -- 	},
        -- 	authorizedJobs = { '' },
        -- 	allowVehicles = true,
        -- 	locked = false
        -- },

    },
}
