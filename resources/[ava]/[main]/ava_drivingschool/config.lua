-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVAConfig = {}
AVAConfig.DrawDistance = 15.0

AVAConfig.DrivingSchool = {
    Blip = {Sprite = 764, Colour = 0, Scale = 0.8},
    Coord = vector3(208.52, -1383.02, 29.60),
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
    MaxNumberOfErrorsAccepted = 8,
    DefaultSpeedType = "city",
}

AVAConfig.DriverTest.Checkpoints = {
    {Coord = vector3(212.51, -1418.44, 28.36)},
    {Coord = vector3(175.81, -1400.10, 28.36)},
    {Coord = vector3(110.45, -1364.71, 28.36)},
    {Coord = vector3(-75.96, -1364.45, 28.44)},
    {Coord = vector3(-268.73, -1419.64, 30.25)},
    {Coord = vector3(-267.24, -1162.18, 22.06), MissionText = GetString("job_center_on_left")},
    {Coord = vector3(-198.36, -914.64, 28.33)},
    {Coord = vector3(-489.31, -826.33, 29.36)},
    {Coord = vector3(-545.39, -680.51, 32.28)},
    {Coord = vector3(-622.59, -647.95, 30.66)},
    {Coord = vector3(-614.73, -339.40, 33.68), MissionText = GetString("city_hall_on_left")},
    {Coord = vector3(-448.71, -260.34, 34.84)},
    {Coord = vector3(-228.78, -410.77, 29.73)},
    {Coord = vector3(-147.06, -370.51, 32.88)},
    {Coord = vector3(-109.29, -252.04, 43.29)},
    {Coord = vector3(-83.18, -132.42, 56.68)},
    {Coord = vector3(-240.91, -37.49, 48.43)},
    {Coord = vector3(-218.16, 106.61, 68.62)},
    {Coord = vector3(-123.21, 96.84, 70.27)},
    {Coord = vector3(-105.98, 234.06, 96.43)},
    {Coord = vector3(-130.83, 259.72, 94.85)},
    {Coord = vector3(-642.38, 278.63, 80.26)},
    {Coord = vector3(-833.66, 298.98, 85.28), MissionText = GetString("new_driving_speed_limit_residence", AVAConfig.DriverTest.Speeds["residence"])},
    {Coord = vector3(-854.24, 425.71, 86.03), ChangeSpeedType = "residence"},
    {Coord = vector3(-569.32, 510.19, 103.90)},
    {Coord = vector3(-500.89, 583.56, 120.09)},
    {Coord = vector3(-515.42, 659.16, 138.28)},
    {Coord = vector3(-92.31, 599.05, 206.97), ChangeSpeedType = "city"},
    {Coord = vector3(279.68, 828.23, 190.68)},
    {Coord = vector3(243.18, 426.80, 118.36)},
    {Coord = vector3(263.24, 355.72, 104.48)},
    {Coord = vector3(208.29, 221.42, 104.59)},
    {Coord = vector3(124.75, -10.23, 66.67)},
    {Coord = vector3(77.35, -136.21, 54.11)},
    {Coord = vector3(34.45, -257.82, 46.69)},
    {Coord = vector3(-57.21, -528.96, 39.34)},
    {Coord = vector3(81.12, -562.41, 30.89), MissionText = GetString("hospital_on_left")},
    {Coord = vector3(333.27, -661.94, 28.26)},
    {Coord = vector3(438.07, -544.72, 27.59), ChangeSpeedType = "freeway"},
    {Coord = vector3(660.26, -229.95, 42.70)},
    {Coord = vector3(1029.69, 308.14, 82.66)},
    {Coord = vector3(1574.80, 966.84, 77.09), MissionText = GetString("take_next_exit")},
    {Coord = vector3(1700.12, 1333.23, 85.83)},
    {Coord = vector3(1857.07, 1633.74, 81.09)},
    {Coord = vector3(2199.15, 1241.02, 75.37)},
    {Coord = vector3(2525.47, 601.74, 108.13)},
    {Coord = vector3(2457.78, -113.44, 89.47), MissionText = GetString("take_next_exit")},
    {Coord = vector3(2380.65, -242.99, 84.09), MissionText = GetString("new_driving_speed_limit_city", AVAConfig.DriverTest.Speeds["city"])},
    {Coord = vector3(2411.35, -462.99, 70.68), ChangeSpeedType = "city"},
    {Coord = vector3(2532.92, -618.73, 61.37)},
    {Coord = vector3(2209.93, -749.27, 66.18)},
    {Coord = vector3(1343.47, -1596.91, 51.09)},
    {Coord = vector3(1260.12, -1449.96, 34.16)},
    {Coord = vector3(820.20, -1430.90, 26.26)},
    {Coord = vector3(562.56, -1428.60, 28.49)},
    {Coord = vector3(467.05, -1424.61, 28.32)},
    {Coord = vector3(338.09, -1494.86, 28.28)},
    {Coord = vector3(258.52, -1448.24, 28.25)},
    {Coord = vector3(222.95, -1413.29, 28.27)},
    {Coord = vector3(246.23, -1400.04, 29.52)},
}

