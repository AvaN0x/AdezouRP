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

AVAConfig.VehicleKey = "U"
AVAConfig.PlayerLockedInLockedVehicle = false

AVAConfig.Garages = {
    -- #region garages
    {
        Name = "garage_pillbox",
        Coord = vector3(229.700, -800.1149, 30.5722),
        Size = { x = 2.0, y = 2.0, z = 2.0 },
        Color = { r = 255, g = 255, b = 255 },
        Marker = 36,
        Blip = { Sprite = 357, Color = 0 },
        VehicleType = 0,
        SpawnPoint = { Coord = vector3(229.700, -800.1149, 30.5722), Heading = 157.84 },
        -- DisablePark = true, -- Used when the player as a vehicle in a garage that he has lost access
        -- DisableTakeOut = true,
    },
    {
        Name = "garage_sandyshores",
        Coord = vector3(1885.48, 3762.80, 32.78),
        Size = { x = 2.0, y = 2.0, z = 2.0 },
        Color = { r = 255, g = 255, b = 255 },
        Marker = 36,
        Blip = { Sprite = 357, Color = 0 },
        VehicleType = 0,
        SpawnPoint = { Coord = vector3(1885.48, 3762.80, 32.78), Heading = 177.12 },
        -- DisablePark = true, -- Used when the player as a vehicle in a garage that he has lost access
        -- DisableTakeOut = true,
    },
    {
        Name = "garage_paletobay",
        Coord = vector3(-32.73, 6415.39, 31.48),
        Size = { x = 2.0, y = 2.0, z = 2.0 },
        Color = { r = 255, g = 255, b = 255 },
        Marker = 36,
        Blip = { Sprite = 357, Color = 0 },
        VehicleType = 0,
        SpawnPoint = { Coord = vector3(-32.73, 6415.39, 31.48), Heading = 217.90 },
        -- DisablePark = true, -- Used when the player as a vehicle in a garage that he has lost access
        -- DisableTakeOut = true,
    },
    {
        Name = "garage_delperro",
        Coord = vector3(-1374.51, -474.13, 31.59),
        Size = { x = 2.0, y = 2.0, z = 2.0 },
        Color = { r = 255, g = 255, b = 255 },
        Marker = 36,
        Blip = { Sprite = 357, Color = 0 },
        VehicleType = 0,
        SpawnPoint = { Coord = vector3(-1374.51, -474.13, 31.59), Heading = 101.12 },
        -- DisablePark = true, -- Used when the player as a vehicle in a garage that he has lost access
        -- DisableTakeOut = true,
    },
    {
        Name = "garage_lstuner",
        Coord = vector3(-2149.91, 1156.29, 28.66),
        Size = { x = 2.0, y = 2.0, z = 2.0 },
        Color = { r = 255, g = 255, b = 255 },
        Marker = 36,
        VehicleType = 0,
        SpawnPoint = { Coord = vector3(-2149.91, 1156.29, 28.66), Heading = 148.70 },
        -- DisablePark = true, -- Used when the player as a vehicle in a garage that he has lost access
        -- DisableTakeOut = true,
    },
    {
        Name = "garage_lapuerta",
        Coord = vector3(-973.84, -1477.11, 5.02),
        Size = { x = 2.0, y = 2.0, z = 2.0 },
        Color = { r = 255, g = 255, b = 255 },
        Marker = 36,
        Blip = { Sprite = 357, Color = 0 },
        VehicleType = 0,
        SpawnPoint = { Coord = vector3(-973.84, -1477.11, 5.02), Heading = 42.63 },
        -- DisablePark = true, -- Used when the player as a vehicle in a garage that he has lost access
        -- DisableTakeOut = true,
    },
    -- {
    --     -- TODO Add this with the export "addGarage" in ava_jobs
    --     Name = "jobgarage_lspd",
    --     Coord = vector3(447.77, -1019.28, 28.54),
    --     Size = { x = 2.0, y = 2.0, z = 2.0 },
    --     Color = { r = 0, g = 122, b = 204 },
    --     Marker = 36,
    --     Blip = { Sprite = 357, Color = 0 },
    --     VehicleType = 0,
    --     IsJobGarage = "lspd",
    --     JobNeeded = "lspd",
    --     SpawnPoint = { Coord = vector3(447.77, -1019.28, 28.54), Heading = 5.0 },
    --     -- DisablePark = true, -- Used when the player as a vehicle in a garage that he has lost access
    -- },
    -- {
    --     -- TODO Add this with the export "addGarage" in ava_jobs
    --     Name = "garage_lspd",
    --     Coord = vector3(454.79, -1024.43, 28.48),
    --     Size = { x = 2.0, y = 2.0, z = 2.0 },
    --     Color = { r = 255, g = 255, b = 255 },
    --     Marker = 36,
    --     Blip = { Sprite = 357, Color = 0 },
    --     VehicleType = 0,
    --     JobNeeded = "lspd",
    --     SpawnPoint = { Coord = vector3(454.79, -1024.43, 28.48), Heading = 5.0 },
    --     -- DisablePark = true, -- Used when the player as a vehicle in a garage that he has lost access
    -- },
    {
        -- TODO Add this with the export "addGarage" in ava_jobs
        Name = "garage_lost",
        Coord = vector3(971.55, -126.71, 74.32),
        Size = { x = 2.0, y = 2.0, z = 2.0 },
        Color = { r = 255, g = 255, b = 255 },
        Marker = 36,
        Blip = { Sprite = 357, Color = 0 },
        VehicleType = 0,
        IsCommonGarage = true,
        JobNeeded = "biker_lost",
        SpawnPoint = { Coord = vector3(971.55, -126.71, 74.32), Heading = 5.0 },
        -- DisablePark = true, -- Used when the player as a vehicle in a garage that he has lost access
    },

    -- boats
    {
        Name = "garage_marina",
        Coord = vector3(-941.29, -1478.10, 1.60),
        Size = { x = 2.0, y = 2.0, z = 2.0 },
        Color = { r = 255, g = 255, b = 255 },
        Marker = 35,
        Distance = 10,
        Blip = { Sprite = 356, Color = 0 },
        VehicleType = 1,
        SpawnPoint = { Coord = vector3(-937.23, -1469.76, 1.19), Heading = 292.0 },
        -- DisablePark = true, -- Used when the player as a vehicle in a garage that he has lost access
        -- DisableTakeOut = true,
    },

    -- planes
    {
        Name = "garage_lsairport",
        Coord = vector3(-1551.14, -3183.38, 13.94),
        Size = { x = 2.0, y = 2.0, z = 2.0 },
        Color = { r = 255, g = 255, b = 255 },
        Marker = 33,
        Blip = { Sprite = 359, Color = 0 },
        VehicleType = 2,
        SpawnPoint = { Coord = vector3(-1551.14, -3183.38, 13.94), Heading = 330.0 },
        -- DisablePark = true, -- Used when the player as a vehicle in a garage that he has lost access
        -- DisableTakeOut = true,
    },

    -- helis
    {
        Name = "garage_marina",
        Coord = vector3(-724.51, -1444.04, 5.00),
        Size = { x = 2.0, y = 2.0, z = 2.0 },
        Color = { r = 255, g = 255, b = 255 },
        Marker = 34,
        Blip = { Sprite = 360, Color = 0 },
        VehicleType = 3,
        SpawnPoint = { Coord = vector3(-724.51, -1444.04, 5.00), Heading = 135.0 },
        -- DisablePark = true, -- Used when the player as a vehicle in a garage that he has lost access
        -- DisableTakeOut = true,
    },
    -- #endregion garages

    -- #region insurance
    {
        Insurance = true,
        Name = "insurance_arcadius",
        Coord = vector3(-723.65, 262.10, 83.12),
        Size = { x = 1.5, y = 1.5, z = 1.0 },
        Color = { r = 255, g = 255, b = 255 },
        Marker = 27,
        Blip = { Sprite = 620, Color = 64, Name = GetString("insurance") },
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
