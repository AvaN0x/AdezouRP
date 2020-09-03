Config                            = {}
Config.DrawDistance               = 100.0
Config.MaxInService               = -1
Config.EnablePlayerManagement     = true
Config.EnableSocietyOwnedVehicles = false
Config.Locale = 'fr'
Config.FacturesDays = 3 -- nb jours pour afficher les factures

Config.MinParkingSlots = 2
Config.MaxParkingSlots = 8

Config.Taxe = 0.1 

Config.AuthorizedVehicles = {
	{label = 'Limousine', model = 'Stretch'},
	{label = 'Oracle', model = 'umoracle'}, 
	{label = 'Schafter blindé', model = 'schafter5'},
	{label = 'XLS blindé', model = 'xls2'} 
}

Config.AuthorizedHelico = {
	{label = 'Buzzard', model = 'buzzard2'},
	{label = 'Volatus', model = 'volatus'}
}

Config.Zones = {

	CloakRoom = {
		Pos   = {x = -541.88, y = -192.23, z = 46.44},
		Size  = {x = 1.2, y = 1.2, z = 1.0},
		Color = {r = 0, g = 204, b = 3},
		Type  = 27
	},

	-- CloakRoom2 = {
	-- 	Pos   = {x = -572.85, y = -201.88, z = 41.75},
	-- 	Size  = {x = 1.5, y = 1.5, z = 1.0},
	-- 	Color = {r = 0, g = 204, b = 3},
	-- 	Type  = 27
	-- },

	Armurerie = {
		Pos   = {x = -541.14, y = -193.38, z = 46.44},
		Size  = {x = 1.2, y = 1.2, z = 1.0},
		Color = {r = 255, g = 0, b = 0},
		Type  = 27
	},

	Doorbell = {
		Pos   = {x = -543.14, y = -207.51, z = 36.67},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 0, g = 204, b = 3},
		Type  = 27
	},

	StateAction = {
		Pos   = {x = -546.82, y = -203.21, z = 46.43},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 0, g = 204, b = 3},
		Type  = 27
	},

	VehicleSpawner = {
		Pos   = {x = -582.96, y = -146.5, z = 37.25},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 242, g = 255, b = 0},
		Type  = 27
	},

	VehicleSpawnPoint = {
		Pos   = {x = -581.25, y = -136.68, z = 35.95},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 0, g = 204, b = 3},
		Type  = -1,
		Heading = 202.91
	},

	VehicleDeleter = {
		Pos   = {x = -575.36, y = -134.65, z = 35.04},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 0, b = 0},
		Type  = 1
	},

	HelicoSpawner = {
		Pos   = {x = -540.34, y = -231.68, z = 35.75},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 242, g = 255, b = 0},
		Type  = 27
	},

	HelicoSpawnPoint = {
		Pos   = {x = -540.18, y = -253.48, z = 35.0},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 0, g = 204, b = 3},
		Type  = -1,
		Heading = 210.82
	},

	HelicoDeleter = {
		Pos   = {x = -540.18, y = -253.48, z = 35.0},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 204, g = 0, b = 0},
		Type  = 27
	},
}

Config.SocietyGarage = {	
	Name = "society_state",
	SpawnPoint = {
		Pos = {x = -581.25, y = -136.68, z = 34.97},
		Heading = 202.91
	}
}