-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
Config = {}
Config.Locale = 'fr'

Config.DefaultSize = {x = 1.5, y = 1.5, z = 1.0}
Config.DefaultColor = {r = 255, g = 255, b = 255}

Config.Teleporters = {
	{
		tpEnter = {
			pos = vector3(-482.72, -246.7, 34.90),
			-- size  = {x = 1.5, y = 1.5, z = 1.0},
			-- color = {r = 255, g = 0, b = 255},
			label = "Monter sur le toit"
		},
		tpExit = {
			pos = vector3(-545.02, -271.55, 34.28),
			label = "Descendre"
		},
		authorizedJobs = { 'state' },
		locked = true,
		distance = 5
	},
		
	-- ['ToitHopital'] = {
	-- 	['Job'] = 'none',
	-- 	['Enter'] = { 
	-- 		['x'] = 329.78, 
	-- 		['y'] = -600.99, 
	-- 		['z'] = 42.3,
	-- 		['Information'] = '[E] Monter sur le toit',
	-- 	},
	-- 	['Exit'] = {
	-- 		['x'] = 339.02, 
	-- 		['y'] = -584.04, 
	-- 		['z'] = 73.18, 
	-- 		['Information'] = '[E] Descendre' 
	-- 	}
	-- },

	-- ['Boite de nuit'] = {
	-- 	['Job'] = 'none',
	-- 	['Enter'] = { 
	-- 		['x'] = -676.83, 
	-- 		['y'] = -2458.72,
	-- 		['z'] = 12.96,
	-- 		['Information'] = '[E] Rentrer' 
	-- 	},

	-- 	['Exit'] = {
	-- 		['x'] = -1569.3, 
	-- 		['y'] = -3017.41, 
	-- 		['z'] = -75.39, 
	-- 		['Information'] = '[E] Sortir' 
	-- 	}
	-- }

	--Next here
}