-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config.Jobs.gang_ballas = {
    isGang = true,
    LabelName = "Ballas",
    Zones = {
        Stock = {
            Coord = vector3(111.76, -1978.58, 20.00),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 152, g = 60, b = 137 },
            Name = "Coffre",
            InventoryName = "gang_ballas_stock",
            HelpText = GetString("press_to_open"),
            Marker = 27,
        },
        Cloakroom = {
            Coord = vector3(117.25, -1964.02, 20.35),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 152, g = 60, b = 137 },
            Name = "Vestiaire",
            HelpText = GetString("press_to_open"),
            Marker = 27,
        },
    },
    Garages = {
        {
            Name = "garage_ballas",
            Coord = vector3(91.82, -1964.06, 20.75),
            Size = { x = 2.0, y = 2.0, z = 2.0 },
            Color = { r = 255, g = 255, b = 255 },
            Marker = 36,
            Blip = { Sprite = 357, Color = 0 },
            VehicleType = 0,
            IsCommonGarage = true,
            JobNeeded = "gang_ballas",
            SpawnPoint = { Coord = vector3(91.82, -1964.06, 20.75), Heading = 321.59 },
            Blip = { Name = "Garage", Sprite = 357, Color = 0, Scale = 0.4 },
        },
    },
}
