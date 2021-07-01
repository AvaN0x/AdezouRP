-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config = {}
Config.DrawDistance = 30
Config.DamageMultiplier = 1
Config.InsurancePriceMultiplier = 0.07
Config.InsuranceMinPrice = 300
Config.InsuranceMaxPrice = 20000
Config.PoundPriceMultiplier = 0.12
Config.PoundMinPrice = 1000
Config.PoundMaxPrice = 30000

Config.DefaultGarage = "first_opened"

Config.Garages = {
	-- cars
	Garage_car_01 = {
		Name = "Garage",
		Pos = vector3(229.700, -800.1149, 30.5722),
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Color = {r = 255, g = 255, b = 255},
		Marker = 36,
		Blip = {
			Sprite = 290,
			Color = 0
		},
		Type = "car",
		SpawnPoint = {
			Pos = vector3(229.700, -800.1149, 30.5722),
			Heading = 157.84
		},
		Identifier = "garage_pillbox"
	},
	Garage_car_02 = {
		Name = "Garage",
		Pos = vector3(154.13, 6561.41, 31.83),
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Color = {r = 255, g = 255, b = 255},
		Marker = 36,
		Blip = {
			Sprite = 290,
			Color = 0
		},
		Type = "car",
		SpawnPoint = {
			Pos = vector3(154.13, 6561.41, 31.83),
			Heading = 345.0
		},
		Identifier = "garage_paleto"
	},
	Garage_car_03 = {
		Name = "Garage",
		Pos = vector3(1709.29, 4799.75, 41.33),
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Color = {r = 255, g = 255, b = 255},
		Marker = 36,
		Blip = {
			Sprite = 290,
			Color = 0
		},
		Type = "car",
		SpawnPoint = {
			Pos = vector3(1709.29, 4799.75, 41.33),
			Heading = 11.84
		},
		Identifier = "garage_grapeseed"
	},
	Garage_car_04 = {
		Name = "Garage",
		Pos = vector3(1520.39, 3765.16, 34.04),
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Color = {r = 255, g = 255, b = 255},
		Marker = 36,
		Blip = {
			Sprite = 290,
			Color = 0
		},
		Type = "car",
		SpawnPoint = {
			Pos = vector3(1520.39, 3765.16, 34.04),
			Heading = 157.84
		},
		Identifier = "garage_sandy"
	},
	Garage_LSPD = {
		Name = "hide",
		Pos = vector3(442.53, -1026.09, 28.71),
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
			Pos = vector3(442.53, -1026.09, 28.71),
			Heading = 5.0
		},
		Identifier = "garage_lspd"
	},
	Garage_EMS = {
		Name = "hide",
		Pos = vector3(317.56, -573.87, 28.8),
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
			Pos = vector3(317.56, -573.87, 28.8),
			Heading = 250.0
		},
		Identifier = "garage_ems"
	},
	Garage_TAXI = {
		Name = "hide",
		Pos = vector3(900.67, -186.91, 73.79),
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
			Pos = vector3(900.67, -186.91, 73.79),
			Heading = 328.76
		},
		Identifier = "garage_taxi"
	},
	Garage_GOUV = {
		Name = "hide",
		Pos = vector3(-579.05, -170.05, 38.23),
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
			Pos = vector3(-579.05, -170.05, 38.23),
			Heading = 292.0
		},
		Identifier = "garage_gouv"
	},
	Garage_VIGNERON = {
		Name = "hide",
		Pos = vector3(-1886.24, 2018.52, 140.84),
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
			Pos = vector3(-1886.5, 2015.78, 141.04),
			Heading = 169.0
		},
		Identifier = "garage_vigneron"
	},
	Garage_MECHANIC = {
		Name = "hide",
		Pos = vector3(-1153.75, -2038.21, 13.16),
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Color = {r = 255, g = 255, b = 255},
		Marker = 36,
		Blip = {
			Sprite = 290,
			Color = 0
		},
		Type = "car",
		Job = 'mechanic',
		SpawnPoint = {
			Pos = vector3(-1153.75, -2038.21, 13.16),
			Heading = 230.0
		},
		Identifier = "garage_mechanic"
	},
	Garage_CLUCKIN = {
		Name = "hide",
		Pos = vector3(-479.99, -604.52, 31.17),
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
			Pos = vector3(-479.99, -604.52, 31.17),
			Heading = 180.0
		},
		Identifier = "garage_cluckin"
	},
	Garage_PLATINIUM = {
		Name = "hide",
		Pos = vector3(-189.82, -1290.17, 31.30),
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
			Pos = vector3(-189.82, -1290.17, 31.30),
			Heading = 180.0
		},
		Identifier = "garage_platinium"
	},
	Garage_TAILOR = {
		Name = "hide",
		Pos = vector3(705.19, -991.21, 24.0),
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
			Pos = vector3(705.19, -991.21, 23.02),
			Heading = 280.0
		},
		Identifier = "garage_tailor"
	},
    Garage_UNICORN = {
		Name = "hide",
		Pos = vector3(151.42, -1308.48, 29.20),
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
			Pos = vector3(151.42, -1308.48, 29.20),
			Heading = 65.0
		},
		Identifier = "garage_unicorn"
	},
    Garage_ATTACKATACO = {
		Name = "hide",
		Pos = vector3(23.76, -1589.26, 29.22),
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
			Pos = vector3(23.76, -1589.26, 29.22),
			Heading = 230.0
		},
		Identifier = "garage_attackataco"
	},







	Garage_boat_01 = {
		Name = "Marina",
		Pos = vector3(-852.73, -1345.86, 1.61),
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
			Pos = vector3(-852.73, -1345.86, 1.01),
			Heading = 107.84
		},
		Identifier = "garage_tackle_street"
	},









	Garage_heli_01 = {
		Name = "Héliport",
		Pos = vector3(-724.71, -1444.0, 5.0),
		Size  = {x = 2.0, y = 2.0, z = 2.0},
		Color = {r = 255, g = 255, b = 255},
		Marker = 34,
		Blip = {
			Sprite = 360,
			Color = 0
		},
		Type = "heli",
		SpawnPoint = {
			Pos = vector3(-724.71, -1444.0, 5.0),
			Heading = 138.7
		},
		Identifier = "garage_shank_street"
	},






	Garage_plane_01 = {
		Name = "Hangar",
		Pos = vector3(-988.43, -3001.67, 13.95),
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
			Pos = vector3(-988.43, -3001.67, 13.95),
			Heading = 60.56
		},
		Identifier = "garage_ls_airport"
	},


}

Config.Insurance = {
	insurance_arcadius = {
		Name = "Assurance",
		Pos = vector3(-127.94, -641.77, 167.84),
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 255, g = 255, b = 255},
		Marker = 27,
		Blip = {
            Pos = vector3(-116.68, -603.23, 36.28),
			Sprite = 620,
			Color = 64
		},
		Identifier = "garage_INSURANCE"
	},
}

Config.Pound = {
	pound = {
		Name = "Fourrière",
		Pos = vector3(369.74, -1607.73, 28.31),
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 255, g = 255, b = 255},
		Marker = 27,
		Blip = {
			Sprite = 524,
			Color = 64
		},
        SpawnPoint = {
			Pos = vector3(375.72, -1611.87, 29.29),
			Heading = 240.0
		},
		Identifier = "garage_POUND"
	},
}


