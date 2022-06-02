-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config.Jobs.gang_marabunta = {
    isGang = true,
    LabelName = "Marabunta",
    Zones = {
        Stock = {
            Coord = vector3(1294.62, -1745.05, 53.30),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 136, g = 243, b = 216 },
            Name = "Coffre",
            InventoryName = "gang_marabunta_stock",
            HelpText = GetString("press_to_open"),
            Marker = 27,
        },
        Cloakroom = {
            Coord = vector3(1301.05, -1745.58, 53.30),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 136, g = 243, b = 216 },
            Name = "Vestiaire",
            HelpText = GetString("press_to_open"),
            Marker = 27,
        },
    },
    Garages = {
        {
            Name = "garage_marabunta",
            Coord = vector3(1329.94, -1724.45, 56.04),
            Size = { x = 2.0, y = 2.0, z = 2.0 },
            Color = { r = 255, g = 255, b = 255 },
            Marker = 36,
            Blip = { Sprite = 357, Color = 0 },
            VehicleType = 0,
            IsCommonGarage = true,
            JobNeeded = "gang_marabunta",
            SpawnPoint = { Coord = vector3(1329.94, -1724.45, 56.04), Heading = 10.77 },
        },
    },
}
