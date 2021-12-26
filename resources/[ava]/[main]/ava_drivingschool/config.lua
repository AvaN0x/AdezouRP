-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVAConfig = {}
AVAConfig.DrawDistance = 15.0

AVAConfig.DrivingSchool = {
    Blip = {Sprite = 764, Colour = 0, Scale = 0.8},
    -- Coord = vector3(208.52, -1383.02, 29.60),
    Coord = vector3(223.41, -1394.31, 29.61), -- FIXME DELETE
    Marker = 27,
    Size = {x = 1.5, y = 1.5, z = 1.0},
    Color = {r = 0, g = 122, b = 204},
    Name = GetString("driving_school_blip"),
    HelpText = GetString("press_open_menu", 80),
}

-- AVAConfig.MenuStyle = {textureName = nil, textureDirectory = nil}

AVAConfig.Prices = {trafficLaws = 250, driver = 500}

AVAConfig.TrafficLawsQuestions = json.decode(LoadResourceFile(GetCurrentResourceName(), "questions.json") or "{}") or {}

AVAConfig.DriverTest = {
    vehicleHash = GetHashKey("ignus"),
    vehicleCoord = vector4(223.33, -1403.24, 29.93, 138.0),
    Speeds = {residence = 50, city = 90, freeway = 130},
    CheckpointColor = {r = 254, g = 235, b = 169},
    CheckpointIconColor = {r = 255, g = 133, b = 85},
    MaxNumberOfErrorsAccepted = 5,
    DefaultSpeedType = "city",
    Checkpoints = {
        {Coord = vector3(212.51, -1418.44, 28.36)},
        {
            Coord = vector3(175.81, -1400.10, 28.36),
            -- ChangeSpeedType = "residence"
        },
        {
            Coord = vector3(110.45, -1364.71, 28.36),
            -- ChangeSpeedType = "freeway"
        },
        {
            Coord = vector3(-75.96, -1364.45, 28.44),
            -- ChangeSpeedType = "city"
        },
        {Coord = vector3(-268.73, -1419.64, 30.25)},
    },
}
