-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config                            = {}
Config.DrawDistance               = 50.0
Config.Locale                     = 'fr'
Config.SocietyName 				  = 'society_unicorn'
Config.LabelName 				  = 'Unicorn'
Config.JobName 				 	  = 'unicorn'
-- Don't forget to change every `esx_ava_unicornjob`

Config.Blip = {
	Sprite = 121,
	Colour = 0
}

Config.Zones = {
	JobActions = {
		Pos   = {x = 132.14, y = -1290.15, z = 28.29},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Point d'action",
		Marker = 27
	},
	Dressing = {
		Pos   = {x = 106.71, y = -1299.75, z = 27.79},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Dressing",
		Marker = 27,
		Blip = true
	},
	SocietyGarage = {	
		Name  = "Garage véhicule",
		Pos = {x = 143.47, y = -1285.09, z = 29.34},
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Color = {r = 0, g = 255, b = 0},
		Marker = 36,
		Type = "car",
		SpawnPoint = {
			Pos = {x = 143.47, y = -1285.09, z = 29.34},
			Heading = 293.0
		},
		Blip = true
	},

}

Config.BuyZones = {
	BuyBox = {
		Items = {
			{name = 'icetea', price = 20},
			{name = 'sprite', price = 20},
			{name = 'orangina', price = 20},
			{name = 'cocacola', price = 20}
		},
		Pos   = {x = 387.02, y = -343.28, z = 45.85},
		Size  = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 136, g = 232, b = 9},
		Name  = "Achat de boissons",
		Marker = 27,
		Blip = true
	}
}