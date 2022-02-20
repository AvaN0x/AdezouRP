-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVAConfig = {}
AVAConfig.DrawDistance = 15.0

AVAConfig.DefaultGarage = "garage_pillbox"

AVAConfig.InsurancePriceMultiplier = 0.07
AVAConfig.InsurancePriceMinimum = 300
AVAConfig.InsurancePriceMaximum = 20000

AVAConfig.PoundPriceMultiplier = 0.12
AVAConfig.PoundPriceMinimum = 1000
AVAConfig.PoundPriceMaximum = 30000


AVAConfig.Garages = {
    -- #region garages
    {
        Name = "garage_pillbox",
        Coord = vector3(229.700, -800.1149, 30.5722),
        Size = { x = 2.0, y = 2.0, z = 2.0 },
        Color = { r = 255, g = 255, b = 255 },
        Marker = 36,
        Blip = { Sprite = 290, Color = 0 },
        VehicleType = 0,
        SpawnPoint = { Coord = vector3(229.700, -800.1149, 30.5722), Heading = 157.84 },
        -- DisablePark = true, -- Used when the player as a vehicle in a garage that he has lost access
        -- DisableTakeOut = true,
    },
    {
        -- TODO Add this with the export "addGarage" in ava_jobs
        Name = "jobgarage_lspd",
        Coord = vector3(447.77, -1019.28, 28.54),
        Size = { x = 2.0, y = 2.0, z = 2.0 },
        Color = { r = 0, g = 122, b = 204 },
        Marker = 36,
        Blip = { Sprite = 290, Color = 0 },
        VehicleType = 0,
        IsJobGarage = "lspd",
        JobNeeded = "lspd",
        SpawnPoint = { Coord = vector3(447.77, -1019.28, 28.54), Heading = 5.0 },
        -- DisablePark = true, -- Used when the player as a vehicle in a garage that he has lost access
    },
    {
        -- TODO Add this with the export "addGarage" in ava_jobs
        Name = "garage_lspd",
        Coord = vector3(454.79, -1024.43, 28.48),
        Size = { x = 2.0, y = 2.0, z = 2.0 },
        Color = { r = 255, g = 255, b = 255 },
        Marker = 36,
        Blip = { Sprite = 290, Color = 0 },
        VehicleType = 0,
        JobNeeded = "lspd",
        SpawnPoint = { Coord = vector3(454.79, -1024.43, 28.48), Heading = 5.0 },
        -- DisablePark = true, -- Used when the player as a vehicle in a garage that he has lost access
    },
    {
        -- TODO Add this with the export "addGarage" in ava_jobs
        Name = "garage_lost",
        Coord = vector3(971.55, -126.71, 74.32),
        Size = { x = 2.0, y = 2.0, z = 2.0 },
        Color = { r = 255, g = 255, b = 255 },
        Marker = 36,
        Blip = { Sprite = 290, Color = 0 },
        VehicleType = 0,
        IsCommonGarage = true,
        JobNeeded = "biker_lost",
        SpawnPoint = { Coord = vector3(971.55, -126.71, 74.32), Heading = 5.0 },
        -- DisablePark = true, -- Used when the player as a vehicle in a garage that he has lost access
    },
    -- #endregion garages

    -- #region insurance
    {
        Insurance = true,
        Name = "insurance_arcadius",
        Coord = vector3(-127.94, -641.77, 167.84),
        Size = { x = 1.5, y = 1.5, z = 1.0 },
        Color = { r = 255, g = 255, b = 255 },
        Marker = 27,
        Blip = { Coord = vector3(-116.68, -603.23, 36.28), Sprite = 620, Color = 64, Name = GetString("insurance") },
    },
    -- #endregion insurance

    -- #region pound
    {
        Pound = true,
        Name = "pound_davis",
        Coord = vector3(369.74, -1607.73, 28.31),
        Size = { x = 1.5, y = 1.5, z = 1.0 },
        Color = { r = 255, g = 255, b = 255 },
        Marker = 27,
        Blip = { Sprite = 524, Color = 64, Name = GetString("pound") },
        VehicleType = 0,
        SpawnPoint = { Coord = vector3(375.72, -1611.87, 29.29), Heading = 240.0 },
    },
    -- #endregion pound
}
