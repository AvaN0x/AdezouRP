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
	-- TODO add the ability to hide the marker
	{
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
	{
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