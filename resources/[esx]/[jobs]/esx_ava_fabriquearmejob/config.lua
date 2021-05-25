-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config                            = {}
Config.DrawDistance               = 50.0
Config.Locale                     = 'fr'
Config.SocietyName 				  = 'society_fabriquearme'
Config.LabelName 				  = 'Fabricant d\'armes'
Config.JobName 				 	  = 'fabriquearme'
-- Don't forget to change every `esx_ava_ammunationjob`

Config.Blip = {
	Sprite = 556,
	Colour = 31
}

Config.Zones = {
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
					{name = 'steel', quantity = 1},
					{name = 'gunpowder', quantity = 4}
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
        Title = "Fabrication de pistolets",
		Process = {
			PistolProcess = {
				Name = 'Pistolet 9mm',
				ItemsGive = {
					{name = 'steel', quantity = 40},
					{name = 'plastic', quantity = 30},
					{name = 'grease', quantity = 5}
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
					{name = 'plastic', quantity = 60},
					{name = 'grease', quantity = 10}
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
					{name = 'grease', quantity = 5}
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
					{name = 'grease', quantity = 10}
				},
				ItemsGet = {
					{name = 'weapon_sawnoffshotgun', quantity = 1}
				},
				Delay = 40000,
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
					{name = 'grease', quantity = 15}
				},
				ItemsGet = {
					{name = 'weapon_gusenberg', quantity = 1}
				},
				Delay = 40000,
				Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
			},
			ARProcess = {
				Name = 'AK-47',
				ItemsGive = {
					{name = 'steel', quantity = 145},
					{name = 'plastic', quantity = 120},
					{name = 'grease', quantity = 15}
				},
				ItemsGet = {
					{name = 'weapon_assaultrifle', quantity = 1}
				},
				Delay = 50000,
				Scenario = 'WORLD_HUMAN_CLIPBOARD', -- https://pastebin.com/6mrYTdQv
			},
			CompactARProcess = {
				Name = 'AK compact',
				ItemsGive = {
					{name = 'steel', quantity = 130},
					{name = 'plastic', quantity = 100},
					{name = 'grease', quantity = 10}
				},
				ItemsGet = {
					{name = 'weapon_compactrifle', quantity = 1}
				},
				Delay = 35000,
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
	}
}


Config.BuyZones = {
	BuyBox = {
		Items = {
			{name = 'steel', price = 800},
			{name = 'plastic', price = 350},
			{name = 'gunpowder', price = 100},
			{name = 'grease', price = 60},
		},
		Pos   = {x = 612.6, y = -3074.04, z = 5.09},
		Size  = {x = 1.5, y = 1.5, z = 1.5},
		Color = {r = 136, g = 232, b = 9},
		Name  = "Achat de matériaux",
		Marker = 27,
		Blip = true
	}
}