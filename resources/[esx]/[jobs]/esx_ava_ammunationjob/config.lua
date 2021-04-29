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
	Sprite = 110,
	Colour = 1
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
		Pos = {x = -8.6, y = -1112.36, z = 28.51},
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Color = {r = 0, g = 255, b = 0},
		Marker = 36,
		Type = "car",
		SpawnPoint = {
			Pos = {x = -8.6, y = -1112.36, z = 28.51},
			Heading = 157.0
		},
		Blip = true
	},

	Bunker = {
		Name  = "Bunker",
		Pos = {x = 2116.71, y = 3329.63, z = 45.58},
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Marker = -1,
		Blip = true
	},

}



Config.ProcessMenuZones = {
	-- clips
	{
		Title = "Fabrication de chargeurs",
		Process = {
			ClipProcess = {
				Name = 'Chargeurs',
				ItemsGive = {
					{name = 'steel', quantity = 2},
					{name = 'gunpowder', quantity = 2}
				},
				ItemsGet = {
					{name = 'clip', quantity = 5}
				},
				Delay = 2000,
				Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
			},
		},
		MaxProcess = 5,
		Pos   = {x = 898.04, y = -3221.57, z = -99.23},
		Size  = {x = 2.5, y = 2.5, z = 1.5},
		Color = {r = 252, g = 186, b = 3},
		Name  = "Fabrication de chargeurs",
		Marker = 27,
		Blip = false
	},

	-- pistols
	{
			PistolProcess = {
				Name = 'Pistolet 9mm',
				ItemsGive = {
					{name = 'plastic', quantity = 70},
					{name = 'gunpowder', quantity = 10}
				},
				ItemsGet = {
					{name = 'weapon_pistol', quantity = 1}
				},
				Delay = 20000,
				Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
			},
		},
		MaxProcess = 5,
		Pos   = {x = 905.98, y = -3230.79, z = -99.27},
		Size  = {x = 2.5, y = 2.5, z = 1.5},
		Color = {r = 252, g = 186, b = 3},
		Name  = "Fabrication de pistolets",
		Marker = 27,
		Blip = false
	},

	-- smgs
	{
		Title = "Fabrication de pistolets mitrailleurs",
		Process = {
			UZIProcess = {
				Name = 'Uzi',
				ItemsGive = {
					{name = 'steel', quantity = 80},
					{name = 'plastic', quantity = 70},
					{name = 'gunpowder', quantity = 20}
				},
				ItemsGet = {
					{name = 'weapon_microsmg', quantity = 1}
				},
				Delay = 20000,
				Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
			},
			MachinePistolProcess = {
				Name = 'Tec-9',
				ItemsGive = {
					{name = 'steel', quantity = 70},
					{name = 'plastic', quantity = 50},
					{name = 'gunpowder', quantity = 20}
				},
				ItemsGet = {
					{name = 'weapon_machinepistol', quantity = 1}
				},
				Delay = 20000,
				Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
			},
		},
		MaxProcess = 5,
		Pos   = {x = 896.58, y = -3217.3, z = -99.21},
		Size  = {x = 2.5, y = 2.5, z = 1.5},
		Color = {r = 252, g = 186, b = 3},
		Name  = "Fabrication de pistolets mitrailleurs",
		Marker = 27,
		Blip = false
	},

	-- shotguns
	{
		Title = "Fabrication de fusils à pompe",
		Process = {
			SawnOffProcess = {
				Name = 'Fusil à pompe',
				ItemsGive = {
					{name = 'steel', quantity = 80},
					{name = 'plastic', quantity = 60},
					{name = 'gunpowder', quantity = 30}
				},
				ItemsGet = {
					{name = 'weapon_sawnoffshotgun', quantity = 1}
				},
				Delay = 20000,
				Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
			},
		},
		MaxProcess = 5,
		Pos   = {x = 891.73, y = -3196.8, z = -99.18},
		Size  = {x = 2.5, y = 2.5, z = 1.5},
		Color = {r = 252, g = 186, b = 3},
		Name  = "Fabrication de fusils à pompe",
		Marker = 27,
		Blip = false
	},


	-- assault rifles
	{
		Title = "Fabrication de fusils d'assaut",
		Process = {
			GusenbergProcess = {
				Name = 'Gusenberg',
				ItemsGive = {
					{name = 'steel', quantity = 130},
					{name = 'plastic', quantity = 110},
					{name = 'gunpowder', quantity = 40}
				},
				ItemsGet = {
					{name = 'weapon_gusenberg', quantity = 1}
				},
				Delay = 20000,
				Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
			},
			ARProcess = {
				Name = 'AK-47',
				ItemsGive = {
					{name = 'steel', quantity = 130},
					{name = 'plastic', quantity = 110},
					{name = 'gunpowder', quantity = 40}
				},
				ItemsGet = {
					{name = 'weapon_assaultrifle', quantity = 1}
				},
				Delay = 20000,
				Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
			},
			CompactARProcess = {
				Name = 'AK compact',
				ItemsGive = {
					{name = 'steel', quantity = 130},
					{name = 'plastic', quantity = 100},
					{name = 'gunpowder', quantity = 40}
				},
				ItemsGet = {
					{name = 'weapon_compactrifle', quantity = 1}
				},
				Delay = 20000,
				Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
			},
		},
		MaxProcess = 5,
		Pos   = {x = 884.92, y = -3199.9, z = -99.18},
		Size  = {x = 2.5, y = 2.5, z = 1.5},
		Color = {r = 252, g = 186, b = 3},
		Name  = "Fabrication de fusils d'assaut",
		Marker = 27,
		Blip = false
	},



Config.BuyZones = {
	BuyBox = {
		Items = {
			{name = 'steel', price = 200},
			{name = 'plastic', price = 150},
			{name = 'cutted_wood', price = 50},
			{name = 'gunpowder', price = 100},
			{name = 'gold', price = 5250}
		},
		Pos   = {x = 612.6, y = -3074.04, z = 5.09},
		Size  = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 136, g = 232, b = 9},
		Name  = "Achat de matériaux",
		Marker = 27,
		Blip = true
	}
}