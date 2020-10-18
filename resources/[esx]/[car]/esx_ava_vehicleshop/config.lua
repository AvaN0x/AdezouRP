-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
---------- FROM esx_vehicleshop -----------
-------------------------------------------

Config                            = {}
Config.Locale                     = 'fr'

Config.DrawDistance               = 20.0
Config.MarkerColor                = { r = 120, g = 120, b = 240 }
Config.ResellPercentage           = 80

Config.Shops = {
	Motorsport = {
		Name = "Premium Deluxe Motorsport",
		Blip = {
			Sprite = 326,
			Color = 0
		},
		Categories = {
			"compact",
			"coupes",
			"motorcycles",
			"muscles",
			"offroad",
			"sedans",
			"sports",
			"sportsclassics",
			"super",
			"suvs",
			"vans"
		},
		JobOthers = "hide_car",
		Zones = {
			ShopMenu = {
				Pos   = { x = -33.777, y = -1102.021, z = 25.54 },
				Size  = { x = 1.5, y = 1.5, z = 1.0 },
				Type  = 27
			},
			ShopInside = {
				Pos     = { x = -44.72, y = -1097.94, z = 26.42 },
				Size    = { x = 1.5, y = 1.5, z = 1.0 },
				Heading = 161.03,
				Type    = -1
			},
			ShopSpawnCar = { -- vehicule spawn position
				Pos     = { x = -32.46, y = -1090.95, z = 25.43 },
				Size    = { x = 1.5, y = 1.5, z = 1.0 },
				Heading = 340.5,
				Type    = -1
			},
			ShopSpawnCarSecond = { -- vehicule spawn for bigger vehicle (truck...)
				Pos     = { x = -31.19, y = -1080.54, z = 26.14 },
				Size    = { x = 1.5, y = 1.5, z = 1.0 },
				Heading = 71.5,
				Type    = -1
			},
			ResellVehicle = {
				Pos   = { x = -44.630, y = -1080.738, z = 25.683 },
				Size  = { x = 3.0, y = 3.0, z = 1.0 },
				Type  = 27
			}
		}
	},
	Planes = {
		Name = "Concessionnaire avion",
		Blip = {
			Sprite = 582,
			Color = 0
		},
		Categories = {
			"planes"
		},
		JobOthers = "hide_plane",
		Zones = {
			ShopMenu = {
				Pos   = { x = -1242.65, y = -3392.72, z = 12.96 },
				Size  = { x = 1.5, y = 1.5, z = 1.0 },
				Type  = 27
			},
			ShopInside = {
				Pos     = { x = -1275.83, y = -3388.13, z = 13.94 },
				Size    = { x = 1.5, y = 1.5, z = 1.0 },
				Heading = 330.0,
				Type    = -1
			},
			ShopSpawnCar = { -- vehicule spawn position
				Pos     = { x = -1253.16, y = -3343.53, z = 13.95 },
				Size    = { x = 1.5, y = 1.5, z = 1.0 },
				Heading = 330.0,
				Type    = -1
			},
			ShopSpawnCarSecond = { -- vehicule spawn for bigger vehicle (truck...)
				Pos     = { x = -1253.16, y = -3343.53, z = 13.95 },
				Size    = { x = 1.5, y = 1.5, z = 1.0 },
				Heading = 330.0,
				Type    = -1
			},
			ResellVehicle = {
				Pos   = { x = -1479.16, y = -3214.87, z = 12.96 },
				Size  = { x = 3.0, y = 3.0, z = 1.0 },
				Type  = 27,
				Blip = true
			}
		}
	},
	Helis = {
		Name = "Concessionnaire hélicoptère",
		Blip = {
			Sprite = 574,
			Color = 0
		},
		Categories = {
			"helis"
		},
		JobOthers = "hide_heli",
		Zones = {
			ShopMenu = {
				Pos   = { x = -1147.44, y = -2825.16, z = 12.97 },
				Size  = { x = 1.5, y = 1.5, z = 1.0 },
				Type  = 27
			},
			ShopInside = {
				Pos     = { x = -1178.42, y = -2845.89, z = 13.95 },
				Size    = { x = 1.5, y = 1.5, z = 1.0 },
				Heading = 330.0,
				Type    = -1
			},
			ShopSpawnCar = { -- vehicule spawn position
				Pos     = { x = -1145.87, y = -2864.63, z = 13.95 },
				Size    = { x = 1.5, y = 1.5, z = 1.0 },
				Heading = 330.0,
				Type    = -1
			},
			ShopSpawnCarSecond = { -- vehicule spawn for bigger vehicle (truck...)
				Pos     = { x = -1145.87, y = -2864.63, z = 13.95 },
				Size    = { x = 1.5, y = 1.5, z = 1.0 },
				Heading = 330.0,
				Type    = -1
			},
			ResellVehicle = {
				Pos   = { x = -1112.41, y = -2883.97, z = 12.97 },
				Size  = { x = 3.0, y = 3.0, z = 1.0 },
				Type  = 27,
				Blip = true
			}
		}
	},
	Boats = {
		Name = "Concessionnaire hélicoptère",
		Blip = {
			Sprite = 427,
			Color = 0
		},
		Categories = {
			"boats"
		},
		JobOthers = "hide_boat",
		Zones = {
			ShopMenu = {
				Pos   = { x = -816.27, y = -1346.25, z = 4.17 },
				Size  = { x = 1.5, y = 1.5, z = 1.0 },
				Type  = 27
			},
			ShopInside = {
				Pos     = { x =-712.93, y = -1340.18, z = 1.01 },
				Size    = { x = 1.5, y = 1.5, z = 1.0 },
				Heading = 140.0,
				Type    = -1
			},
			ShopSpawnCar = { -- vehicule spawn position
				Pos     = { x = -733.62, y = -1364.88, z = 1.01 },
				Size    = { x = 1.5, y = 1.5, z = 1.0 },
				Heading = 140.0,
				Type    = -1
			},
			ShopSpawnCarSecond = { -- vehicule spawn for bigger vehicle (truck...)
				Pos     = { x = -733.62, y = -1364.88, z = 1.01 },
				Size    = { x = 1.5, y = 1.5, z = 1.0 },
				Heading = 140.0,
				Type    = -1
			},
			ResellVehicle = {
				Pos   = { x = -725.74, y = -1328.29, z = 1.01 },
				Size  = { x = 3.0, y = 3.0, z = 1.0 },
				Type  = 27,
				Blip = true
			}
		}
	}


}