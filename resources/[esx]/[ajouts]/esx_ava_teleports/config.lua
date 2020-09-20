-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
Config = {}
Config.Locale = 'fr'

Config.DrawDistance = 10
Config.DefaultSize = {x = 1.5, y = 1.5, z = 1.0}
Config.DefaultColor = {r = 255, g = 255, b = 255}

Config.Teleporters = {
<<<<<<< HEAD
	{ -- hospital elevator
=======
	-- TODO add the ability to hide the marker
	{
>>>>>>> 3a9da8ad4e50277ca0ff041e581327f31f2eefdc
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
		authorizedJobs = { 'ambulance' },
		locked = true,
		distance = 5
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
		locked = true,
		distance = 5
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
		authorizedJobs = { '' },
		locked = false,
		distance = 5
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
		authorizedJobs = { '' },
		allowVehicles = true,
		locked = false,
		distance = 5
	},


	-- exemple to teleport vehicle
	-- {
	-- 	tpEnter = {
	-- 		pos = vector3(-1908.68, 2049.63, 139.76),
	-- 		heading = 180.0,
	-- 		size  = {x = 2.5, y = 2.5, z = 1.0},
	-- 		-- color = {r = 255, g = 0, b = 255},
	-- 		label = "Entrer"
	-- 	},
	-- 	tpExit = {
	-- 		pos = vector3(-1899.85, 2018.84, 139.86),
	-- 		heading = 0.0,
	-- 		size  = {x = 2.5, y = 2.5, z = 1.0},
	-- 		label = "Sortir"
	-- 	},
	-- 	authorizedJobs = { '' },
	-- 	allowVehicles = true,
	-- 	locked = false,
	-- 	distance = 5
	-- },

}