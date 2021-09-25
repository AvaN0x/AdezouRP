-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
Config = {}
Config.DrawDistance = 30.0
Config.Locale = "fr"
Config.MaxPickUp = 70
Config.MaxPickUpIllegal = 70
Config.JobMenuKey = "F6"

Config.Jobs = {
}

Config.JobCenter = {
    Blip = {Sprite = 682, Colour = 27},
    JobList = {
        {JobName = "unemployed", Label = "Chômage", Desc = "Inscrivez vous au chômage pour recevoir des aides"},
        {JobName = "winemaker", Label = "🍇 Intérimaire Vigneron", Desc = "Travail dans les vignes pour la fabrication de jus et de vin"},
        {JobName = "tailor", Label = "🧶 Intérimaire Couturier", Desc = "Travail dans la couture et la fabrique de vêtements"},
    },
    Pos = vector3(-266.94, -960.04, 30.24),
    Size = {x = 1.5, y = 1.5, z = 1.0},
    Color = {r = 255, g = 133, b = 85},
    Name = "Pole Emploi",
    HelpText = GetString("press_to_open"),
    Marker = 27,
}
