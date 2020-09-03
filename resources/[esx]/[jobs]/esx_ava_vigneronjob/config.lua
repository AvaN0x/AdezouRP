-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config                            = {}
Config.DrawDistance               = 50.0
Config.Locale                     = 'fr'
Config.SocietyName 				  = 'society_vigneron'
Config.LabelName 				  = 'Vigneron'
Config.JobName 				 	  = 'vigneron'
-- Don't forget to change every `esx_ava_vigneronjob`

Config.Blip = {
	Sprite = 85,
	Colour = 19
}

Config.Zones = {
	JobActions = {
		Pos   = {x = -1876.1, y = 2062.52, z = 144.59},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Point d'action",
		Type  = 27
	},
	Dressing = {
		Pos   = {x = -1870.68, y = 2056.32, z = 140.0},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Dressing",
		Type  = 27,
		Blip = true
	},
	VehicleMenu = {
		Pos   = {x = -1889.653, y = 2050.071, z = 140.0},
		Size = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Garage véhicule",
		Type  = 27,
		Blip = true
	},
	VehicleStock = {
		Pos   = {x = -1913.550, y = 2030.590, z = 139.82},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 255, g = 0, b = 0},
		Name  = "Ranger son véhicule",
		Type  = 27,
		Blip = false
	}


}

Config.SocietyGarage = {	
	Name = Config.SocietyName,
	SpawnPoint = {
		Pos = {x = -1903.01, y = 2044.02, z = 139.89},
		Heading = 161.0
	}
}

Config.FieldZones = {
	RaisinField = {
		Items = {
			{name = 'raisin', quantity = 8}
		},
		Prop = 'prop_mk_race_chevron_02',
		Pos   = {x = -1809.662, y = 2210.119, z = 90.681},
		GroundCheckHeights = {88.0, 89.0, 90.0, 91.0, 92.0, 93.0, 94.0, 95.0, 96.0, 97.0, 98.0, 99.0, 100.0},
		Name  = "1. Récolte",
		Type  = -1,
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
	-- 	Type  = -1,
	-- 	Blip = true
	-- }

}

Config.ProcessZones = {
	VineProcess = {
		ItemsGive = {
			{name = 'raisin', quantity = 10}
		},
		ItemsGet = {
			{name = 'vine', quantity = 1},
			{name = 'jus_raisin', quantity = 1}
		},
		Delay = 6000,
		Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
		Pos   = {x = -1928.48, y = 2060.74, z = 139.86},
		Size  = {x = 2.5, y = 2.5, z = 1.5},
		Color = {r = 252, g = 186, b = 3},
		Name  = "2. Traitement vin",
		Type  = 27,
		Blip = true
	},
	ChampagneProcess = {
		ItemsGive = {
			{name = 'raisin', quantity = 10}
		},
		ItemsGet = {
			{name = 'champagne', quantity = 1},
			{name = 'grand_cru', quantity = 1}
		},
		Delay = 8000,
		Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
		Pos   = {x = -1855.59, y = 2060.92, z = 140.05},
		Size  = {x = 2.5, y = 2.5, z = 1.5},
		Color = {r = 252, g = 186, b = 3},
		Name  = "Traitement champagne et grand cru",
		NoInterim = true,
		Type  = 27,
		Blip = true
	}

}

Config.ProcessMenuZones = {
	{
		Title = 'Mise en caisse',
		Process = {
			VineProcess = {
				Name = 'Caisse de Vin',
				ItemsGive = {
					{name = 'vine', quantity = 6},
					{name = 'woodenbox', quantity = 1}
				},
				ItemsGet = {
					{name = 'vinebox', quantity = 1}
				},
				Delay = 2000,
				Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
			},
			JusRaisinProcess = {
				Name = 'Caisse de Jus de raisin',
				ItemsGive = {
					{name = 'jus_raisin', quantity = 6},
					{name = 'woodenbox', quantity = 1}
				},
				ItemsGet = {
					{name = 'jus_raisinbox', quantity = 1}
				},
				Delay = 2000,
				Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
			},
			ChampagneProcess = {
				Name = 'Caisse de Champagne',
				ItemsGive = {
					{name = 'champagne', quantity = 6},
					{name = 'woodenbox', quantity = 1}
				},
				ItemsGet = {
					{name = 'champagnebox', quantity = 1}
				},
				Delay = 2000,
				Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
			},
			GrandCruProcess = {
				Name = 'Caisse de Grand Cru',
				ItemsGive = {
					{name = 'grand_cru', quantity = 6},
					{name = 'woodenbox', quantity = 1}
				},
				ItemsGet = {
					{name = 'grand_crubox', quantity = 1}
				},
				Delay = 2000,
				Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
			}
		},
		MaxProcess = 3,
		Pos   = {x = -1933.06, y = 2061.9, z = 139.86},
		Size  = {x = 2.5, y = 2.5, z = 1.5},
		Color = {r = 252, g = 186, b = 3},
		Name  = "4. Traitement en caisses",
		Type  = 27,
		Blip = true


	}

}

Config.SellZones = {
	WineMerchantSell = {
		Items = {
			{name = 'vinebox', price = 1800},
			{name = 'jus_raisinbox', price = 650}
		},
		Pos   = {x = -158.737, y = -54.651, z = 53.42},
		Size  = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 136, g = 232, b = 9},
		Name  = "5. Vente des produits",
		Type  = 27,
		Blip = true
	}
}

Config.BuyZones = {
	BuyBox = {
		Items = {
			{name = 'woodenbox', price = 20}
		},
		Pos   = {x = 396.77, y = -345.88, z = 45.86},
		Size  = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 136, g = 232, b = 9},
		Name  = "3. Achat de caisses",
		Type  = 27,
		Blip = true
	}
}