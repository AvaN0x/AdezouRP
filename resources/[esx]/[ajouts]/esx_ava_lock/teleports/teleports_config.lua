-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
Config.Teleports = {

	DrawDistance = 10,
	DefaultSize = {x = 1.5, y = 1.5, z = 1.0},
	DefaultColor = {r = 255, g = 255, b = 255},
	
	TeleportersList = {
		{ -- hospital elevator
			tpEnter = {
				pos = vector3(329.78, -600.99, 42.3),
				heading = 64.0,
				-- size  = {x = 1.5, y = 1.5, z = 1.0},
				-- color = {r = 255, g = 0, b = 255},
				label = "Monter sur le toit"
			},
			tpExit = {
				pos = vector3(339.02, -584.04, 73.18),
				heading = 265.0,
				label = "Descendre"
			},
			authorizedJobs = { 'ems' },
			locked = true
		},
		{ -- hospital elevator
			tpEnter = {
				pos = vector3(331.75, -595.42, 42.3),
				heading = 64.0,
				-- size  = {x = 1.5, y = 1.5, z = 1.0},
				-- color = {r = 255, g = 0, b = 255},
				label = "Descendre"
			},
			tpExit = {
				pos = vector3(342.46, -585.49, 27.82),
				heading = 250.0,
				label = "Monter à l'étage"
			},
			authorizedJobs = { 'ems' },
			locked = false
		},
		{ -- nightclub entry
			tpEnter = {
				pos = vector3(-676.83, -2458.72, 12.96),
				heading = 141.0,
				-- size  = {x = 1.5, y = 1.5, z = 1.0},
				-- color = {r = 255, g = 0, b = 255},
				label = "Entrer"
			},
			tpExit = {
				pos = vector3(-1569.3, -3017.41, -75.39),
				heading = 356.0,
				label = "Sortir"
			},
			authorizedJobs = { 'nightclub' },
			locked = true
		},
		{ -- nightclub vehicle entry
			tpEnter = {
				pos = vector3(-1641.32, -2989.73, -78.07),
				heading = 270.0,
				size  = {x = 2.5, y = 2.5, z = 1.0},
				-- color = {r = 255, g = 0, b = 255},
				label = "Sortir"
			},
			tpExit = {
				pos = vector3(-675.28, -2390.24, 12.88),
				heading = 60.0,
				size  = {x = 2.5, y = 2.5, z = 1.0},
				distance = 20,
				label = "Entrer"
			},
			authorizedJobs = { 'nightclub' },
			allowVehicles = true,
			locked = true
		},

	
		{ -- arcade entry
			tpEnter = {
				pos = vector3(-1270.27, -305.18, 36.01),
				heading = 250.0,
				-- size  = {x = 1.5, y = 1.5, z = 1.0},
				-- color = {r = 255, g = 0, b = 255},
				label = "Entrer"
			},
			tpExit = {
				pos = vector3(2737.95, -374.35, -48.97),
				heading = 180.0,
				label = "Sortir"
			},
			locked = false
		},
		{ -- arcade vehicle entry
			tpEnter = {
				pos = vector3(-1288.73, -275.0, 37.81),
				heading = 30.0,
				size  = {x = 2.5, y = 2.5, z = 1.0},
				-- color = {r = 255, g = 0, b = 255},
				label = "Entrer"
			},
			tpExit = {
				pos = vector3(2680.36, -361.16, -56.17),
				heading = 270.0,
				size  = {x = 2.5, y = 2.5, z = 1.0},
				label = "Sortir"
			},
			allowVehicles = true,
			locked = false
		},
	
	
		{ -- comedy club
			tpEnter = {
				pos = vector3(-430.142, 261.665, 82.02),
				heading = 175.0,
				-- size  = {x = 1.5, y = 1.5, z = 1.0},
				-- color = {r = 255, g = 0, b = 255},
				label = "Entrer"
			},
			tpExit = {
				pos = vector3(-458.790, 284.750, 77.54),
				heading = 265.0,
				label = "Sortir"
			},
			locked = false
		},
	

		-- bunker
		{ -- arcade vehicle entry
			tpEnter = {
				pos = vector3(2116.71, 3329.63, 45.58),
				heading = 120.0,
				size  = {x = 2.5, y = 2.5, z = 1.0},
				-- color = {r = 255, g = 0, b = 255},
				label = "Entrer"
			},
			tpExit = {
				pos = vector3(891.13, -3245.97, -99.25),
				heading = 85.0,
				size  = {x = 2.5, y = 2.5, z = 1.0},
				label = "Sortir"
			},
			authorizedJobs = { 'ammunation' },
			allowVehicles = true,
			locked = true
		},


		-- { -- maze bank arena
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
	
	}
}

