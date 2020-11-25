Config                            = {}
Config.Locale                     = 'fr'

Config.DrawDistance               = 30.0

Config.Marker                     = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }

Config.ReviveReward               = 250  -- revive reward for ems job


-- Config.EarlyRespawnTimer          = 15 * 60 * 1000  -- Time til respawn is available
Config.EarlyRespawnTimer = 10 * 60 * 1000  -- Time til respawn is available
Config.ForceRespawnTimer = 20 * 60 * 1000 -- Time til the player bleeds out

Config.RemoveWeaponsAfterRPDeath  = false
Config.RemoveCashAfterRPDeath     = false
Config.RemoveItemsAfterRPDeath    = false

-- Let the player pay for respawning early, only if he can afford it.
Config.EarlyRespawnFineAmount     = 2000

Config.RespawnPoint = {
	coords = vector3(323.15, -582.64, 42.3),
	heading = 50.73
}

Config.Hospitals = {
	CentralLosSantos = {
		Blip = {
			Pos   = {x = 298.48, y = -584.48, z = 43.28},
			Sprite = 61,
			Scale  = 0.8,
			Color  = 26
		},
		AmbulanceActions = {
			Pos = {x = 299.03, y = -598.51, z = 43.28},
		},
		Pharmacies = {
			Pos = {x = 311.59, y = -563.91, z = 43.28},
		},
		SocietyGarage = {
			Name  = "Garage véhicule",
			Spawner = vector3(291.73, -594.12, 43.3),
			Marker = {type = 36, x = 1.5, y = 1.5, z = 1.5, r = 0, g = 255, b = 0, a = 100, rotate = true},
			Type = "car",
			SpawnPoint = {
				Pos = {x = 291.73,  y = -594.12, z = 42.3},
				Heading = 345.0
			}
		},
		SocietyHeliGarage = {
			Name  = "Héliport",
			Spawner = vector3(351.05, -588.07, 74.17),
			Marker = {type = 34, x = 2.0, y = 2.0, z = 2.0, r = 0, g = 255, b = 0, a = 100, rotate = true},
			Type = "heli",
			SpawnPoint = {
				Pos = {x = 351.05, y = -588.07, z = 74.17},
				Heading = 245.0
			}
		},
	}
}
