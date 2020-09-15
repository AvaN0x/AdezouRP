-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config                            = {}
Config.DrawDistance               = 50.0
Config.Locale                     = 'fr'
Config.SocietyName 				  = 'society_nightclub'
Config.LabelName 				  = 'Galaxy'
Config.JobName 				 	  = 'nightclub'
-- Don't forget to change every `esx_ava_nightclubjob`

Config.Blip = {
	Sprite = 541,
	Colour = 7
}

Config.Zones = {
	JobBlip = {
		Pos   = {x = -676.83, y = -2458.79, z = 12.96},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Marker = -1
	},
	JobActions = {
		Pos   = {x = -1583.19, y = -3014.04, z = -76.99},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Point d'action",
		Marker = 27
	},
	Dressing = {
		Pos   = {x = -1619.66, y = -3020.41, z = -76.19},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Dressing",
		Marker = 27,
		Blip = true
	},
	SocietyGarage = {	
		Name  = "Garage véhicule",
		Pos   = {x = -685.96, y = -2481.24, z = 13.83},
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Color = {r = 0, g = 255, b = 0},
		Marker = 36,
		Type = "car",
		SpawnPoint = {
			Pos   = {x = -685.96, y = -2481.24, z = 13.83},
			Heading = 55.0
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
			{name = 'coffee', price = 20},
			{name = 'cocacola', price = 20},
			{name = 'ice', price = 5},
			{name = 'martini', price = 20},
			{name = 'martini2', price = 20},
			{name = 'rhum', price = 20},
			{name = 'tequila', price = 20},
			{name = 'vodka', price = 20},
			{name = 'whisky', price = 20}
		},
		Pos   = {x = 376.81, y = -362.84, z = 45.85},
		Size  = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 136, g = 232, b = 9},
		Name  = "Achat de boissons",
		Marker = 27,
		Blip = true
	}
}