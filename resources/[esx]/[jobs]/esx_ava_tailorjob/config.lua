-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config                            = {}
Config.DrawDistance               = 50.0
Config.Locale                     = 'fr'
Config.SocietyName 				  = 'society_tailor'
Config.LabelName 				  = 'Couturier'
Config.JobName 				 	  = 'tailor'
-- Don't forget to change every `esx_ava_tailorjob`

Config.Blip = {
	Sprite = 366,
	Colour = 0
}

Config.Zones = {
	JobActions = {
		Pos   = {x = 708.48, y = -966.69, z = 29.42},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Point d'action",
		Marker = 27
	},
	Dressing = {
		Pos   = {x = 708.91, y = -959.63, z = 29.42},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Dressing",
		Marker = 27,
		Blip = true
	},
	SocietyGarage = {	
		Name  = "Garage véhicule",
		Pos = {x = 719.11, y = -989.22, z = 24.12},
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Color = {r = 0, g = 255, b = 0},
		Marker = 36,
		Type = "car",
		SpawnPoint = {
			Pos = {x = 719.11, y = -989.22, z = 23.12},
			Heading = 279.0
		},
		Blip = true
	},

}

Config.FieldZones = {
	WoolField = {
		Items = {
			{name = 'wool', quantity = 8}
		},
		Prop = 'prop_mk_race_chevron_02',
		Pos   = {x = 1887.45, y = 4630.05, z = 37.12},
		GroundCheckHeights = {36, 37, 38, 39, 40, 41},
		Name  = "1. Récolte",
		Marker = -1,
		Blip = true
	},
	-- PlusField = {
	-- 	Items = {
	-- 		{name = 'bread', quantity = 1}
	-- 	},
	-- 	Prop = 'prop_mk_cone',
	-- 	Pos   = {x = -1844.67, y = 2202.9, z = 94.93},
	-- 	GroundCheckHeights = {87.0, 88.0, 89.0, 90.0, 91.0, 92.0, 93.0, 94.0, 95.0, 96.0, 97.0, 98.0, 99.0, 100.0},
	-- 	Name  = "Récolte",
	-- 	Marker = -1,
	-- 	Blip = true
	-- }

}

Config.ProcessZones = {
	FabricProcess = {
		ItemsGive = {
			{name = 'wool', quantity = 10}
		},
		ItemsGet = {
			{name = 'fabric', quantity = 4}
		},
		Delay = 4000,
		Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
		Pos   = {x = 712.75, y = -973.78, z = 29.42},
		Size  = {x = 2.5, y = 2.5, z = 1.5},
		Color = {r = 252, g = 186, b = 3},
		Name  = "2. Traitement laine",
		Marker = 27,
		Blip = true
	},
	ClotheProcess = {
		ItemsGive = {
			{name = 'fabric', quantity = 2}
		},
		ItemsGet = {
			{name = 'clothe', quantity = 1}
		},
		Delay = 4000,
		Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
		Pos   = {x = 716.5, y = -961.82, z = 29.42},
		Size  = {x = 2.5, y = 2.5, z = 1.5},
		Color = {r = 252, g = 186, b = 3},
		Name  = "3. Traitement du tissu",
		NoInterim = false,
		Marker = 27,
		Blip = true
	},
	ClothesBoxProcess = {
		ItemsGive = {
			{name = 'clothe', quantity = 9},
			{name = 'cardboardbox', quantity = 1}
		},
		ItemsGet = {
			{name = 'clothebox', quantity = 1}
		},
		Delay = 3000,
		Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
		Pos   = {x = 718.73, y = -973.74, z = 29.42},
		Size  = {x = 2.5, y = 2.5, z = 1.5},
		Color = {r = 252, g = 186, b = 3},
		Name  = "5. Mise en caisse des vetements",
		NoInterim = false,
		Marker = 27,
		Blip = true
	}

}

Config.ProcessMenuZones = {
	-- {
	-- 	Title = 'Mise en caisse',
	-- 	Process = {
	-- 		VineProcess = {
	-- 			Name = 'Caisse de Vin',
	-- 			ItemsGive = {
	-- 				{name = 'vine', quantity = 6},
	-- 				{name = 'woodenbox', quantity = 1}
	-- 			},
	-- 			ItemsGet = {
	-- 				{name = 'vinebox', quantity = 1}
	-- 			},
	-- 			Delay = 2000,
	-- 			Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
	-- 		},
	-- 		JusRaisinProcess = {
	-- 			Name = 'Caisse de Jus de raisin',
	-- 			ItemsGive = {
	-- 				{name = 'jus_raisin', quantity = 6},
	-- 				{name = 'woodenbox', quantity = 1}
	-- 			},
	-- 			ItemsGet = {
	-- 				{name = 'jus_raisinbox', quantity = 1}
	-- 			},
	-- 			Delay = 2000,
	-- 			Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
	-- 		},
	-- 		ChampagneProcess = {
	-- 			Name = 'Caisse de Champagne',
	-- 			ItemsGive = {
	-- 				{name = 'champagne', quantity = 6},
	-- 				{name = 'woodenbox', quantity = 1}
	-- 			},
	-- 			ItemsGet = {
	-- 				{name = 'champagnebox', quantity = 1}
	-- 			},
	-- 			Delay = 2000,
	-- 			Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
	-- 		},
	-- 		GrandCruProcess = {
	-- 			Name = 'Caisse de Grand Cru',
	-- 			ItemsGive = {
	-- 				{name = 'grand_cru', quantity = 6},
	-- 				{name = 'woodenbox', quantity = 1}
	-- 			},
	-- 			ItemsGet = {
	-- 				{name = 'grand_crubox', quantity = 1}
	-- 			},
	-- 			Delay = 2000,
	-- 			Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
	-- 		}
	-- 	},
	-- 	MaxProcess = 3,
	-- 	Pos   = {x = -1933.06, y = 2061.9, z = 139.86},
	-- 	Size  = {x = 2.5, y = 2.5, z = 1.5},
	-- 	Color = {r = 252, g = 186, b = 3},
	-- 	Name  = "4. Traitement en caisses",
	-- 	Marker = 27,
	-- 	Blip = true


	-- }

}

Config.SellZones = {
	ClothesSell = {
		Items = {
			{name = 'clothebox', price = 1420}
		},
		Pos   = {x = 71.67, y = -1390.47, z = 28.4},
		Size  = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 136, g = 232, b = 9},
		Name  = "6. Vente des produits",
		Marker = 27,
		Blip = true
	}
}

Config.BuyZones = {
	BuyBox = {
		Items = {
			{name = 'cardboardbox', price = 20}
		},
		Pos   = {x = 406.5, y = -350.02, z = 45.84},
		Size  = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 136, g = 232, b = 9},
		Name  = "4. Achat de cartons",
		Marker = 27,
		Blip = true
	}
}