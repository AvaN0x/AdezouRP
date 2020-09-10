-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
---------- FROM esx_vehicleshop -----------
-------------------------------------------

Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerColor                = { r = 120, g = 120, b = 240 }
Config.ResellPercentage           = 80

Config.Locale                     = 'fr'


Config.Zones = {
	ShopMenu = {
		Pos   = { x = -33.777, y = -1102.021, z = 25.422 },
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Type  = 1
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
		Type  = 1
	}
}
