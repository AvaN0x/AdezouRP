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
    -- vehicleHash = GetHashKey("premier"), --
    vehicleHash = GetHashKey("ignus"), --
    vehicleCoord = vector4(223.33, -1403.24, 29.93, 138.0),
}
