-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config                            = {}
Config.DrawDistance               = 50.0
Config.Locale                     = 'fr'
Config.SocietyName 				  = 'society_cluckin'
Config.LabelName 				  = 'Cluckin Bell'
Config.JobName 				 	  = 'cluckin'
-- Don't forget to change every `esx_ava_cluckinjob`

Config.Blip = {
	Sprite = 141,
	Colour = 46
}

Config.Zones = {
	JobActions = {
		Pos   = {x = -513.13, y = -699.59, z = 32.19},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Point d'action",
		Marker = 27
	},
	Dressing = {
		Pos   = {x = -510.19, y = -700.42, z = 32.19},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 136, g = 243, b = 216},
		Name  = "Dressing",
		Marker = 27,
		Blip = true
	},
	SocietyGarage = {	
		Name  = "Garage véhicule",
		Pos = {x = -465.3, y = -619.36, z = 31.17},
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Color = {r = 0, g = 255, b = 0},
		Marker = 36,
		Type = "car",
		SpawnPoint = {
			Pos = {x = -465.3, y = -619.36, z = 31.17},
			Heading = 86.0
		},
		Blip = true
	},

}

Config.FieldZones = {
	WoolField = {
		Items = {
			{name = 'alive_chicken', quantity = 2}
		},
		Prop = 'prop_int_cf_chick_01',
		Pos   = {x = 85.95, y = 6331.61, z = 30.25},
		GroundCheckHeights = {29, 30, 31, 32},
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
	PluckProcess = {
		ItemsGive = {
			{name = 'alive_chicken', quantity = 2}
		},
		ItemsGet = {
			{name = 'plucked_chicken', quantity = 4}
		},
		Delay = 8000,
		Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
		Pos   = {x = -91.05, y = 6240.41, z = 30.11},
		Size  = {x = 2.5, y = 2.5, z = 1.5},
		Color = {r = 252, g = 186, b = 3},
		Name  = "2. Déplumage",
		Marker = 27,
		Blip = true
	},
	RawProcess = {
		ItemsGive = {
			{name = 'plucked_chicken', quantity = 2}
		},
		ItemsGet = {
			{name = 'raw_chicken', quantity = 8}
		},
		Delay = 10000,
		Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
		Pos   = {x = -103.89, y = 6206.29, z = 30.05},
		Size  = {x = 2.5, y = 2.5, z = 1.5},
		Color = {r = 252, g = 186, b = 3},
		Name  = "3. Découpe",
		Marker = 27,
		Blip = true
	}

}

Config.ProcessMenuZones = {
	{
		Title = 'Cuisine',
		Process = {
			NuggetsProcess = {
				Name = 'Nuggets',
				ItemsGive = {
					{name = 'raw_chicken', quantity = 2}
				},
				ItemsGet = {
					{name = 'nuggets', quantity = 1}
				},
				Delay = 2000,
				Scenario = 'PROP_HUMAN_BBQ', -- https://pastebin.com/6mrYTdQv
			},
			ChickenBurgerProcess = {
				Name = 'Chicken Burger',
				ItemsGive = {
					{name = 'raw_chicken', quantity = 2}
				},
				ItemsGet = {
					{name = 'chickenburger', quantity = 1}
				},
				Delay = 2000,
				Scenario = 'PROP_HUMAN_BBQ', -- https://pastebin.com/6mrYTdQv
			},
			DoubleChickenBurgerProcess = {
				Name = 'Double Chicken Burger',
				ItemsGive = {
					{name = 'raw_chicken', quantity = 4}
				},
				ItemsGet = {
					{name = 'doublechickenburger', quantity = 1}
				},
				Delay = 3000,
				Scenario = 'PROP_HUMAN_BBQ', -- https://pastebin.com/6mrYTdQv
			},
			TendersProcess = {
				Name = 'Tenders',
				ItemsGive = {
					{name = 'raw_chicken', quantity = 2}
				},
				ItemsGet = {
					{name = 'tenders', quantity = 1}
				},
				Delay = 2000,
				Scenario = 'PROP_HUMAN_BBQ', -- https://pastebin.com/6mrYTdQv
			},
			ChickenWrapProcess = {
				Name = 'Wrap au poulet',
				ItemsGive = {
					{name = 'raw_chicken', quantity = 2}
				},
				ItemsGet = {
					{name = 'chickenwrap', quantity = 1}
				},
				Delay = 2000,
				Scenario = 'PROP_HUMAN_BBQ', -- https://pastebin.com/6mrYTdQv
			},
			FritesProcess = {
				Name = 'Frites',
				ItemsGive = {
					{name = 'potato', quantity = 2}
				},
				ItemsGet = {
					{name = 'frites', quantity = 1}
				},
				Delay = 2000,
				Scenario = 'PROP_HUMAN_BBQ', -- https://pastebin.com/6mrYTdQv
			},
			PotatoesProcess = {
				Name = 'Potatoes',
				ItemsGive = {
					{name = 'potato', quantity = 2}
				},
				ItemsGet = {
					{name = 'potatoes', quantity = 1}
				},
				Delay = 2000,
				Scenario = 'PROP_HUMAN_BBQ', -- https://pastebin.com/6mrYTdQv
			}
		},
		MaxProcess = 5,
		Pos   = {x = -520.07, y = -701.52, z = 32.19},
		Size  = {x = 2.5, y = 2.5, z = 1.5},
		Color = {r = 252, g = 186, b = 3},
		Name  = "Cuisine",
		Marker = 27,
		Blip = true
	}

}

Config.SellZones = {
	ClothesSell = {
		Items = {
			{name = 'raw_chicken', price = 50}
		},
		Pos   = {x = -138.13, y = -256.69, z = 42.61},
		Size  = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 136, g = 232, b = 9},
		Name  = "4. Vente des produits",
		Marker = 27,
		Blip = true
	}
}

Config.BuyZones = {
	BuyBox = {
		Items = {
			{name = 'potato', price = 20},
			{name = 'icetea', price = 20},
			{name = 'sprite', price = 20},
			{name = 'orangina', price = 20},
			{name = 'cocacola', price = 20}
		},
		Pos   = {x = 406.5, y = -350.02, z = 45.84},
		Size  = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 136, g = 232, b = 9},
		Name  = "Achat de composants",
		Marker = 27,
		Blip = true
	}
}