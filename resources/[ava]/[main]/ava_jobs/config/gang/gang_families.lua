-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config.Jobs.gang_families = {
    isGang = true,
    LabelName = "Families",
    Zones = {
        Stock = {
            Coord = vector3(-134.14, -1580.55, 33.23),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 72, g = 171, b = 57 },
            Name = "Coffre",
            InventoryName = "gang_families_stock",
            HelpText = GetString("press_to_open"),
            Marker = 27,
        },
        Cloakroom = {
            Coord = vector3(-147.68, -1596.57, 33.85),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 72, g = 171, b = 57 },
            Name = "Vestiaire",
            HelpText = GetString("press_to_open"),
            Marker = 27,
        },
    },
    Garages = {
        {
            Name = "garage_families",
            Coord = vector3(-109.22, -1599.54, 31.64),
            Size = { x = 2.0, y = 2.0, z = 2.0 },
            Color = { r = 255, g = 255, b = 255 },
            Marker = 36,
            Blip = { Sprite = 357, Color = 0 },
            VehicleType = 0,
            IsCommonGarage = true,
            JobNeeded = "gang_families",
            SpawnPoint = { Coord = vector3(-109.22, -1599.54, 31.64), Heading = 316.36 },
            Blip = { Name = "Garage", Sprite = 357, Color = 0, Scale = 0.4 },
        },
    },
}
