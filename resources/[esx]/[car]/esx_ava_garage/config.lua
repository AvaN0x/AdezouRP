
Config = {
	DrawDistance = 30,
	MinPrice = 300,
	MaxPrice = 20000,
	DamageMultiplier = 1,
    PoundPriceMultiplier = 0.07
}

Config.Garages = {
	-- cars
	Garage_car_01 = {	
		Name = "Garage",
		Pos = {x=229.700, y=-800.1149, z=30.5722},
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Color = {r = 255, g = 255, b = 255},
		Marker = 36,
		Blip = {
			Sprite = 290,
			Color = 0
		},
		Type = "car",
		SpawnPoint = {
			Pos = {x=229.700, y=-800.1149, z=30.5722},
			Heading = 157.84
		},
		Identifier = "garage_pillbox"
	},
	Garage_car_02 = {	
		Name = "Garage",
		Pos = {x=154.13, y=6561.41, z=31.83},
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Color = {r = 255, g = 255, b = 255},
		Marker = 36,
		Blip = {
			Sprite = 290,
			Color = 0
		},
		Type = "car",
		SpawnPoint = {
			Pos = {x=154.13, y=6561.41, z=31.83},
			Heading = 345.0
		},
		Identifier = "garage_paleto"
	},
	Garage_car_03 = {	
		Name = "Garage",
		Pos = {x = 1709.29,y = 4799.75,z = 41.33 },
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Color = {r = 255, g = 255, b = 255},
		Marker = 36,
		Blip = {
			Sprite = 290,
			Color = 0
		},
		Type = "car",
		SpawnPoint = {
			Pos = {x = 1709.29,y = 4799.75,z = 41.33 },
			Heading = 11.84
		},
		Identifier = "garage_grapeseed"
	},
	Garage_car_04 = {	
		Name = "Garage",
		Pos = {x = 1520.39,y = 3765.16,z = 34.04 },
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Color = {r = 255, g = 255, b = 255},
		Marker = 36,
		Blip = {
			Sprite = 290,
			Color = 0
		},
		Type = "car",
		SpawnPoint = {
			Pos = {x = 1520.39,y = 3765.16,z = 34.04 },
			Heading = 157.84
		},
		Identifier = "garage_sandy"
	},
	Garage_LSPD = {
		Name = "hide",
		Pos = {x = 442.53,y = -1026.09,z = 28.71 },
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Color = {r = 255, g = 255, b = 255},
		Marker = 36,
		Blip = {
			Sprite = 290,
			Color = 0
		},
		Type = "car",
		Job = 'lspd',
		SpawnPoint = {
			Pos = {x = 442.53,y = -1026.09,z = 28.71 },
			Heading = 5.0
		},
		Identifier = "garage_lspd"
	},
	Garage_EMS = {
		Name = "hide",
		Pos = {x = 317.56, y = -573.87, z = 28.8 },
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Color = {r = 255, g = 255, b = 255},
		Marker = 36,
		Blip = {
			Sprite = 290,
			Color = 0
		},
		Type = "car",
		Job = 'ems',
		SpawnPoint = {
			Pos = {x = 317.56, y = -573.87, z = 28.8 },
			Heading = 250.0
		},
		Identifier = "garage_ems"
	},
	Garage_TAXI = {
		Name = "hide",
		Pos = {x = 900.67,y = -186.91,z = 73.79 },
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Color = {r = 255, g = 255, b = 255},
		Marker = 36,
		Blip = {
			Sprite = 290,
			Color = 0
		},
		Type = "car",
		Job = 'taxi',
		SpawnPoint = {
			Pos = {x = 900.67,y = -186.91,z = 73.79 },
			Heading = 328.76
		},
		Identifier = "garage_taxi"
	},
	Garage_GOUV = {
		Name = "hide",
		Pos = {x = -579.05,y = -170.05,z = 38.23},
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Color = {r = 255, g = 255, b = 255},
		Marker = 36,
		Blip = {
			Sprite = 290,
			Color = 0
		},
		Type = "car",
		Job = 'state',
		SpawnPoint = {
			Pos = {x = -579.05,y = -170.05,z = 38.23},
			Heading = 292.0
		},
		Identifier = "garage_gouv"
	},
	Garage_VIGNERON = {
		Name = "hide",
		Pos = {x = -1886.24,y = 2018.52,z = 140.84},
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Color = {r = 255, g = 255, b = 255},
		Marker = 36,
		Blip = {
			Sprite = 290,
			Color = 0
		},
		Type = "car",
		Job = 'vigneron',
		SpawnPoint = {
			Pos = {x = -1886.5,y = 2015.78,z = 141.04},
			Heading = 169.0
		},
		Identifier = "garage_vigneron"
	},
	Garage_MECANO = {
		Name = "hide",
		Pos = {x = -362.35, y = -145.63, z = 38.25},
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Color = {r = 255, g = 255, b = 255},
		Marker = 36,
		Blip = {
			Sprite = 290,
			Color = 0
		},
		Type = "car",
		Job = 'mecano',
		SpawnPoint = {
			Pos = {x = -362.35, y = -145.63, z = 38.25},
			Heading = 50.0
		},
		Identifier = "garage_mecano"
	},
	Garage_CLUCKIN = {
		Name = "hide",
		Pos = {x = -479.99,y = -604.52, z = 31.17},
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Color = {r = 255, g = 255, b = 255},
		Marker = 36,
		Blip = {
			Sprite = 290,
			Color = 0
		},
		Type = "car",
		Job = 'cluckin',
		SpawnPoint = {
			Pos = {x = -479.99,y = -604.52, z = 31.17},
			Heading = 180.0
		},
		Identifier = "garage_cluckin"
	},
	Garage_PLATINIUM = {
		Name = "hide",
		Pos = {x = -189.82,y = -1290.17, z = 31.30},
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Color = {r = 255, g = 255, b = 255},
		Marker = 36,
		Blip = {
			Sprite = 290,
			Color = 0
		},
		Type = "car",
		Job = 'platinium',
		SpawnPoint = {
			Pos = {x = -189.82,y = -1290.17, z = 31.30},
			Heading = 180.0
		},
		Identifier = "garage_platinium"
	},
	Garage_TAILOR = {
		Name = "hide",
		Pos = {x = 705.19,y = -991.21, z = 24.0},
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Color = {r = 255, g = 255, b = 255},
		Marker = 36,
		Blip = {
			Sprite = 290,
			Color = 0
		},
		Type = "car",
		Job = 'tailor',
		SpawnPoint = {
			Pos = {x = 705.19,y = -991.21, z = 23.02},
			Heading = 280.0
		},
		Identifier = "garage_tailor"
	},
    Garage_UNICORN = {
		Name = "hide",
		Pos = {x = 151.42, y = -1308.48, z = 29.20},
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Color = {r = 255, g = 255, b = 255},
		Marker = 36,
		Blip = {
			Sprite = 290,
			Color = 0
		},
		Type = "car",
		Job = 'unicorn',
		SpawnPoint = {
			Pos = {x = 151.42, y = -1308.48, z = 29.20},
			Heading = 65.0
		},
		Identifier = "garage_unicorn"
	},
    Garage_ATTACKATACO = {
		Name = "hide",
		Pos = {x = 23.76, y = -1589.26, z = 29.22},
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Color = {r = 255, g = 255, b = 255},
		Marker = 36,
		Blip = {
			Sprite = 290,
			Color = 0
		},
		Type = "car",
		Job = 'attackataco',
		SpawnPoint = {
			Pos = {x = 23.76, y = -1589.26, z = 29.22},
			Heading = 230.0
		},
		Identifier = "garage_attackataco"
	},







	Garage_boat_01 = {	
		Name = "Marina",
		Pos = {x=-852.73, y=-1345.86, z=1.61},
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Distance = 10,
		Color = {r = 255, g = 255, b = 255},
		Marker = 35,
		Blip = {
			Sprite = 356,
			Color = 0
		},
		Type = "boat",
		SpawnPoint = {
			Pos = {x=-852.73, y=-1345.86, z=1.01},
			Heading = 107.84
		},
		Identifier = "garage_tackle_street"
	},









	Garage_heli_01 = {	
		Name = "Héliport",
		Pos = {x=-724.71, y=-1444.0, z=5.0},
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Color = {r = 255, g = 255, b = 255},
		Marker = 34,
		Blip = {
			Sprite = 360,
			Color = 0
		},
		Type = "heli",
		SpawnPoint = {
			Pos = {x=-724.71, y=-1444.0, z=5.0},
			Heading = 138.7
		},
		Identifier = "garage_shank_street"
	},






	Garage_plane_01 = {	
		Name = "Hangar",
		Pos = {x=-988.43, y=-3001.67, z=13.95},
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Color = {r = 255, g = 255, b = 255},
		Distance = 10,
		Marker = 33,
		Blip = {
			Sprite = 569,
			Color = 0
		},
		Type = "plane",
		SpawnPoint = {
			Pos = {x=-988.43, y=-3001.67, z=13.95},
			Heading = 60.56
		},
		Identifier = "garage_ls_airport"
	},


}

Config.Pound = {
	fourriere1 = {	
		Name = "Fourrière",
		Pos = {x = 369.82,y = -1607.76,z = 29.29 },
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 255, g = 255, b = 255},
		Marker = 1,
		Blip = {
			Sprite = 524,
			Color = 64
		},
		MunicipalPoundPoint = {
			Pos = {x = 369.82,y = -1607.76,z = 28.31 },
			Size  = {x = 1.5, y = 1.5, z = 1.0},
			Color = {r=25,g=25,b=112},
			Marker = 27
		},
		SpawnMunicipalPoundPoint = {
			Pos = {x = 377.11,y = -1613.29, z = 28.31 },
			Size  = {x = 3.0, y = 3.0, z = 1.0},
			Color = {r=0,g=255,b=0},
			Heading = 230.0,
			Marker = 27
		},
		Identifier = "garage_POUND"
	},


}


