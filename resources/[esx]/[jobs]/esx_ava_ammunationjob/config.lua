-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config                            = {}
Config.DrawDistance               = 50.0
Config.Locale                     = 'fr'
Config.SocietyName 				  = 'society_ammunation'
Config.LabelName 				  = 'Ammunation'
Config.JobName 				 	  = 'ammunation'
-- Don't forget to change every `esx_ava_ammunationjob`

Config.Blip = {
	Sprite = 141,
	Colour = 46
}

Config.Zones = {
	JobActions = {
		Pos   = {x = 12.43, y = -1105.72, z = 28.82},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Point d'action",
		Marker = 27
	},
	Dressing = {
		Pos   = {x = 4.18, y = -1108.85, z = 28.82},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Dressing",
		Marker = 27,
		Blip = true
	},
	SocietyGarage = {
		Name  = "Garage véhicule",
		Pos = {x = -8.6, y = -1112.36, z = 27.55},
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Color = {r = 0, g = 255, b = 0},
		Marker = 36,
		Type = "car",
		SpawnPoint = {
			Pos = {x = -8.6, y = -1112.36, z = 27.55},
			Heading = 86.0
		},
		Blip = true
	},

}



Config.ProcessMenuZones = {
	{
		Title = "Fabrication d'armes",
		Process = {
			-- TemplateProcess = {
			-- 	Name = 'Template',
			-- 	ItemsGive = {
			-- 		{name = 'from', quantity = 2}
			-- 	},
			-- 	ItemsGet = {
			-- 		{name = 'to', quantity = 1}
			-- 	},
			-- 	Delay = 2000,
			-- 	Scenario = 'PROP_HUMAN_BBQ', -- https://pastebin.com/6mrYTdQv
			-- },
		},
		MaxProcess = 5,
		Pos   = {x = -520.07, y = -701.52, z = 32.19},
		Size  = {x = 2.5, y = 2.5, z = 1.5},
		Color = {r = 252, g = 186, b = 3},
		Name  = "Fabrication d'armes",
		Marker = 27,
		Blip = true
	}

}

Config.BuyZones = {
	BuyBox = {
		Items = {
			-- {name = 'template', price = -1},
		},
		Pos   = {x = 612.6, y = -3074.04, z = 5.09},
		Size  = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 136, g = 232, b = 9},
		Name  = "Achat de matériaux",
		Marker = 27,
		Blip = true
	}
}