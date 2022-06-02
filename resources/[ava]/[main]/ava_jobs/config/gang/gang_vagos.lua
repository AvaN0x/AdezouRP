-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config.Jobs.gang_vagos = {
    isGang = true,
    LabelName = "Vagos",
    Zones = {
        Stock = {
            Coord = vector3(364.99, -2064.68, 20.76),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 250, g = 197, b = 50 },
            Name = "Coffre",
            InventoryName = "gang_vagos_stock",
            HelpText = GetString("press_to_open"),
            Marker = 27,
        },
        Cloakroom = {
            Coord = vector3(335.83, -2021.79, 21.37),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 250, g = 197, b = 50 },
            Name = "Vestiaire",
            HelpText = GetString("press_to_open"),
            Marker = 27,
        },
    },
    Garages = {
        {
            Name = "garage_vagos",
            Coord = vector3(335.46, -2039.61, 21.13),
            Size = { x = 2.0, y = 2.0, z = 2.0 },
            Color = { r = 255, g = 255, b = 255 },
            Marker = 36,
            Blip = { Sprite = 357, Color = 0 },
            VehicleType = 0,
            IsCommonGarage = true,
            JobNeeded = "gang_vagos",
            SpawnPoint = { Coord = vector3(335.46, -2039.61, 21.13), Heading = 50.0 },
        },
    },
}
