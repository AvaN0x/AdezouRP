-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config                            = {}
Config.DrawDistance               = 50.0
Config.Locale                     = 'fr'
Config.SocietyName 				  = 'society_platinium'
Config.LabelName 				  = 'Platinium Motors'
Config.JobName 				 	  = 'platinium'
-- Don't forget to change every `esx_ava_platiniumjob`

Config.Blip = {
	Sprite = 566,
	Colour = 73
}

Config.Zones = {
	JobActions = {
		Pos   = {x = -206.57, y = -1341.67, z = 33.91},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Point d'action",
		Marker = 27
	},
	Dressing = {
		Pos   = {x = -224.34, y = -1319.87, z = 30.89},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Dressing",
		Marker = 27,
		Blip = true
	},
	SocietyGarage = {	
		Name  = "Garage véhicule",
		Pos = {x = -213.88, y = -1331.54, z = 30.89},
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Color = {r = 0, g = 255, b = 0},
		Marker = 36,
		Type = "car",
		SpawnPoint = {
			Pos = {x = -213.88, y = -1331.54, z = 30.89},
			Heading = 355.44
		},
		Blip = true
	},

}
