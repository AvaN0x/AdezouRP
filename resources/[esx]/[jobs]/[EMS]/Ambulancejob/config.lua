Config                            = {}

Config.DrawDistance               = 100.0

Config.Marker                     = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }

Config.ReviveReward               = 250  -- revive reward, set to 0 if you don't want it enabled
Config.AntiCombatLog              = true -- enable anti-combat logging?
Config.LoadIpl                    = true -- disable if you're using fivem-ipl or other IPL loaders

Config.Locale                     = 'fr'

local second = 1000
local minute = 60 * second

Config.EarlyRespawnTimer          = 15 * minute  -- Time til respawn is available
Config.BleedoutTimer              = 20 * minute -- Time til the player bleeds out

Config.EnablePlayerManagement     = true

Config.RemoveWeaponsAfterRPDeath  = false
Config.RemoveCashAfterRPDeath     = false
Config.RemoveItemsAfterRPDeath    = false

-- Let the player pay for respawning early, only if he can afford it.
Config.EarlyRespawnFine           = true
Config.EarlyRespawnFineAmount     = 1000

Config.RespawnPoint = { coords = vector3(365.66, -1387.7, 37.96), heading = 50.73 }


Config.Hospitals = {

	CentralLosSantos = {


		Blip = {
			coords = vector3(298.48, -584.48, 43.28),
			sprite = 61,
			scale  = 0.8,
			color  = 26
		},

		AmbulanceActions = {
			vector3(299.03, -598.51, 43.28)
		},

		Pharmacies = {
			vector3(311.59, -563.91, 43.28)
		},

		-- Vehicles = {
		-- 	{
		-- 		Spawner = vector3(291.73, -594.12, 42.8),
		-- 		InsideShop = vector3(342.181, -558.66, -28.7),
		-- 		Marker = { type = 36, x = 1.0, y = 1.0, z = 1.0, r = 100, g = 50, b = 200, a = 100, rotate = true },
		-- 		SpawnPoints = {
		-- 			{ coords = vector3(329.05, -548.94, 28.74), heading = 268, radius = 4.0 }
		-- 		}
		-- 	}
		-- },

		-- VehiclesDelete = {
		-- 	vector3(296.41, -576.63, 43.0)
		-- },

		-- -- a fix
		-- Helicopters = {
		-- 	{
		-- 		Spawner = vector3(341.87, -591.567, -74.165),
		-- 		InsideShop = vector3(349.51, -593.86, -74.16),
		-- 		Marker = { type = 34, x = 1.5, y = 1.5, z = 1.5, r = 100, g = 150, b = 150, a = 100, rotate = true },
		-- 		SpawnPoints = {
		-- 			--{ coords = vector3(313.5, -1465.1, 46.5), heading = 142.7, radius = 10.0 },
		-- 			{ coords = vector3(351.457, -588.64, 74.165), heading = 142.7, radius = 10.0 }
		-- 		}
		-- 	}
		-- },

		-- SocietyGarage = {	
		-- 	Name = "society_ambulance",
		-- 	SpawnPoint = {
		-- 		Pos = {x = 291.73,  y = -594.12, z = 42.3},
		-- 		Heading = 345.0
		-- 	}
		-- }

		SocietyGarage = {	
			Name  = "Garage véhicule",
			Spawner = vector3(291.73, -594.12, 43.3),
			Marker = { type = 36, x = 1.5, y = 1.5, z = 1.5, r = 0, g = 255, b = 0, a = 100, rotate = true },
			Type = "car",
			SpawnPoint = {
				Pos = {x = 291.73,  y = -594.12, z = 42.3},
				Heading = 345.0
			}
		},
	
		SocietyHeliGarage = {	
			Name  = "Héliport",
			Spawner = vector3(351.05, -588.07, 74.17),
			Marker = { type = 34, x = 2.0, y = 2.0, z = 2.0, r = 0, g = 255, b = 0, a = 100, rotate = true },
			Type = "heli",
			SpawnPoint = {
				Pos = {x = 351.05, y = -588.07, z = 74.17},
				Heading = 245.0
			}
		},

	


		-- FastTravels = {
		-- 	{
		-- 		From = vector3(339.29, -583.79, 74.16),
		-- 		To = { coords = vector3(324.63, -558.15, 28.73), heading = 0.0 },
		-- 		Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
		-- 	},

			--{
			--	From = vector3(275.3, -1361, 23.5),
			--	To = { coords = vector3(295.8, -1446.5, 28.9), heading = 0.0 },
			--	Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
			--},
--
			--{
			--	From = vector3(247.3, -1371.5, 23.5),
			--	To = { coords = vector3(333.1, -1434.9, 45.5), heading = 138.6 },
			--	Marker = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
			--},
--
			--{
			--	From = vector3(335.5, -1432.0, 45.50),
			--	To = { coords = vector3(249.1, -1369.6, 23.5), heading = 0.0 },
			--	Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
			--},
--
			--{
			--	From = vector3(234.5, -1373.7, 20.9),
			--	To = { coords = vector3(320.9, -1478.6, 28.8), heading = 0.0 },
			--	Marker = { type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false }
			--},
--
			--{
			--	From = vector3(317.9, -1476.1, 28.9),
			--	To = { coords = vector3(238.6, -1368.4, 23.5), heading = 0.0 },
			--	Marker = { type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false }
			--}
		--},

		--FastTravelsPrompt = {
		--	{
		--		From = vector3(237.4, -1373.8, 26.0),
		--		To = { coords = vector3(251.9, -1363.3, 38.5), heading = 0.0 },
		--		Marker = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false },
		--		Prompt = _U('fast_travel')
		--	},
--
		--	{
		--		From = vector3(256.5, -1357.7, 36.0),
		--		To = { coords = vector3(235.4, -1372.8, 26.3), heading = 0.0 },
		--		Marker = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false },
		--		Prompt = _U('fast_travel')
		--	}
		--}

	}
}

Config.AuthorizedVehicles = {

	ambulance = {
		{ model = 'ambulance', label = 'Ambulance', price = 1000},
	},

	doctor = {
		{ model = 'ambulance', label = 'Ambulance', price = 1000},
	},

	chief_doctor = {
		{ model = 'ambulance', label = 'Ambulance', price = 1000},
	},

	boss = {
		{ model = 'ambulance', label = 'Ambulance', price = 1000},
		{ model = 'dodgeems', label = 'Dodge', price = 2500},
	}

}

Config.AuthorizedHelicopters = {

	ambulance = {},

	doctor = {},

	chief_doctor = {
		{ model = 'polmav', label = 'EMS Maverick', price = 5000 }
	},

	boss = {
		{ model = 'polmav', label = 'EMS Maverick', price = 5000 }
	}

}
