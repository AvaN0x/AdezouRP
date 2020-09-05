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
		Marker = 27
	},

	-- CloakRoom2 = {
	-- 	Pos   = {x = -572.85, y = -201.88, z = 41.75},
	-- 	Size  = {x = 1.5, y = 1.5, z = 1.0},
	-- 	Color = {r = 0, g = 204, b = 3},
	-- 	Marker = 27
	-- },

	Armurerie = {
		Pos   = {x = -541.14, y = -193.38, z = 46.44},
		Size  = {x = 1.2, y = 1.2, z = 1.0},
		Color = {r = 255, g = 0, b = 0},
		Marker = 27
	},

	Doorbell = {
		Pos   = {x = -543.14, y = -207.51, z = 36.67},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 0, g = 204, b = 3},
		Marker = 27
	},

	StateAction = {
		Pos   = {x = -546.82, y = -203.21, z = 46.43},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 0, g = 204, b = 3},
		Marker = 27
	},

	SocietyGarage = {	
		Name  = "Garage véhicule",
		Pos = {x = -580.9, y = -155.41, z = 37.93},
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Color = {r = 0, g = 255, b = 0},
		Marker = 36,
		Type = "car",
		SpawnPoint = {
			Pos = {x = -580.9, y = -155.41, z = 37.93},
			Heading = 111.0
		}
	},

	SocietyHeliGarage = {	
		Name  = "Héliport",
		Pos = {x = -540.18, y = -253.48, z = 36.0},
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Color = {r = 0, g = 255, b = 0},
		Marker = 34,
		Type = "heli",
		SpawnPoint = {
			Pos = {x = -540.18, y = -253.48, z = 36.0},
			Heading = 208.0
		}
	},

}
