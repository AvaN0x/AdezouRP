-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
Config = {}
Config.DrawDistance = 15.0

Config.Stores = {
    -- #region item shops
    TwentyFourSeven = {
        Title = { textureName = "shopui_title_conveniencestore", textureDirectory = "shopui_title_conveniencestore" },
        Blip = { Name = "Supérette", Sprite = 52, Color = 4, Scale = 0.6 },
        Coords = {
            vector3(373.87, 325.87, 102.59), -- Clinton Ave
            vector3(2557.45, 382.28, 107.64), -- Route 15
            vector3(-3039.55, 586.05, 6.93), -- Inesedo Rd.
            vector3(-3241.91, 1001.52, 11.85), -- Barberego Rd.
            vector3(547.70, 2671.29, 41.18), -- Route 68
            vector3(1961.46, 3740.67, 31.36), -- Alhambra Drive
            vector3(2678.90, 3280.81, 54.26), -- Route 13
            vector3(1729.06, 6414.20, 34.06), -- Route 1
            vector3(26.12, -1345.49, 28.52), -- Innocence Blvd
        },
        Items = {
            { name = "bread", price = 13 },
            { name = "waterbottle", price = 12 },
            { name = "donut", price = 4 },
            { name = "dopebag", price = 5 },
            { name = "phone", price = 500 },
            { name = "radio", price = 200 },
            { name = "weapon_flashlight", price = 700 },
        },
        Marker = 27,
        Size = { x = 1.0, y = 1.0, z = 1.0 },
        Color = { r = 134, g = 180, b = 84 },
        Distance = 1.5,
        Name = "Twenty Four Seven",
        HelpText = GetString("press_buy"),
    },
    RobsLiquor = {
        Title = { textureName = "shopui_title_liquorstore2", textureDirectory = "shopui_title_liquorstore2" },
        Blip = { Name = "Supérette", Sprite = 52, Color = 4, Scale = 0.6 },
        Coords = {
            vector3(1135.83, -982.10, 45.44), -- Vespucci Blvd
            vector3(-1222.91, -906.98, 11.34), -- San Andreas Ave
            vector3(-1487.55, -379.10, 39.18), -- Prosperity St
            vector3(-2967.99, 390.96, 14.06), -- Great Route 1
            vector3(1165.98, 2709.03, 37.18), -- Route 68
            vector3(1392.56, 3604.68, 34.01), -- Algonquin Blvd
        },
        Items = {
            { name = "bread", price = 13 },
            { name = "waterbottle", price = 12 },
            { name = "donut", price = 4 },
            { name = "dopebag", price = 5 },
            { name = "phone", price = 500 },
            { name = "radio", price = 200 },
            { name = "weapon_flashlight", price = 700 },
        },
        Marker = 27,
        Size = { x = 1.0, y = 1.0, z = 1.0 },
        Color = { r = 134, g = 180, b = 84 },
        Distance = 1.5,
        Name = "Robs Liquor",
        HelpText = GetString("press_buy"),
    },
    LTDgasoline = {
        Title = { textureName = "shopui_title_gasstation", textureDirectory = "shopui_title_gasstation" },
        Blip = { Name = "Supérette", Sprite = 52, Color = 4, Scale = 0.6 },
        Coords = {
            vector3(-48.05, -1756.84, 28.44), -- Grove Street
            vector3(1163.27, -323.11, 68.23), -- W Mirror Drive
            vector3(-707.54, -913.97, 18.24), -- Little Seoul
            vector3(-1820.84, 793.00, 137.13), -- North Rockford Drive
            vector3(1698.63, 4924.23, 41.08), -- Grapeseed Ave
        },
        Items = {
            { name = "bread", price = 13 },
            { name = "waterbottle", price = 12 },
            { name = "donut", price = 4 },
            { name = "dopebag", price = 5 },
            { name = "phone", price = 500 },
            { name = "radio", price = 200 },
            { name = "weapon_flashlight", price = 700 },
        },
        Marker = 27,
        Size = { x = 1.0, y = 1.0, z = 1.0 },
        Color = { r = 134, g = 180, b = 84 },
        Distance = 1.5,
        Name = "LTD gasoline",
        HelpText = GetString("press_buy"),
    },

    BlackMarket = {
        Title = { textureName = "shopui_title_arenawar", textureDirectory = "shopui_title_arenawar" },
        Coord = vector3(1716.30, 3295.09, 40.32),
        Items = {
            -- { name = "headbag", price = 200, isDirtyMoney = true }, -- TODO disabled atm
            -- {name = "tenuecasa", price = 200, isDirtyMoney = true}, -- TODO disabled atm
            { name = "gpsbeacon", price = 200, isDirtyMoney = true },
            { name = "lockpick", price = 200, isDirtyMoney = true },
            -- { name = "ziptie", price = 200, isDirtyMoney = true }, -- TODO disabled atm
        },
        Distance = 1,
        Name = "Black Market",
        HelpText = GetString("press_buy"),
    },
    BlackMarketMeth = {
        Title = { textureName = "shopui_title_arenawar", textureDirectory = "shopui_title_arenawar" },
        Coord = vector3(-312.04, -2711.91, 5.17),
        Items = {
            { name = "methylamine", price = 200, isDirtyMoney = true },
            { name = "methpseudophedrine", price = 200, isDirtyMoney = true },
            { name = "methacide", price = 200, isDirtyMoney = true },
        },
        Distance = 1,
        Name = "Black Market",
        HelpText = GetString("press_buy"),
    },
    -- #endregion item shops

    -- #region ammunations
    Ammunation = {
        Title = { textureName = "shopui_title_gunclub", textureDirectory = "shopui_title_gunclub" },
        Blip = { Sprite = 110, Color = 1, Scale = 0.6 },
        Coords = {
            vector3(-662.31, -935.17, 20.85), -- Little Seoul
            vector3(1693.02, 3759.61, 33.73), -- Sandy Shores
            vector3(-330.28, 6083.78, 30.47), -- Paleto
            vector3(252.30, -50.00, 68.97), -- Spanish Ave
            vector3(2568.04, 294.26, 107.75), -- Route 15
            vector3(-1117.89, 2698.55, 17.57), -- Route 68
            vector3(-1305.71, -394.37, 35.72), -- Del Perro
            vector3(-3172.21, 1087.77, 19.86), -- Great Route 1
            vector3(842.40, -1033.40, 27.21), -- Vespucci Blvd
        },
        Items = {
            { name = "ammo_pistol", price = 8, license = "weapon" },
            { name = "weapon_doubleaction", price = 100000, license = "weapon" },
            { name = "weapon_pistol", price = 40000, license = "weapon" },
            { name = "weapon_flare", price = 50000, license = "weapon" },
            { name = "weapon_knife", price = 2200 },
            { name = "weapon_switchblade", price = 1500 },
            { name = "weapon_bat", price = 1000 },
            { name = "gadget_parachute", price = 5000 },
        },
        Marker = 27,
        Size = { x = 1.0, y = 1.0, z = 1.0 },
        Color = { r = 175, g = 0, b = 0 },
        Distance = 1.5,
        Name = "Ammunation",
        HelpText = GetString("press_buy"),
    },

    ShootingAmmunation = {
        Title = { textureName = "shopui_title_gunclub", textureDirectory = "shopui_title_gunclub" },
        Blip = { Sprite = 313, Color = 1, Scale = 0.6 },
        Coords = {
            vector3(21.56, -1106.61, 28.82), -- Adam's Apple Blvd
            vector3(810.37, -2157.41, 28.64), -- Dry Dock Street
        },
        Items = {
            { name = "ammo_pistol", price = 8, license = "weapon" },
            { name = "weapon_doubleaction", price = 100000, license = "weapon" },
            { name = "weapon_pistol", price = 40000, license = "weapon" },
            { name = "weapon_flare", price = 50000, license = "weapon" },
            { name = "weapon_knife", price = 2200 },
            { name = "weapon_switchblade", price = 1500 },
            { name = "weapon_bat", price = 1000 },
            { name = "gadget_parachute", price = 5000 },
        },
        Marker = 27,
        Size = { x = 1.0, y = 1.0, z = 1.0 },
        Color = { r = 175, g = 0, b = 0 },
        Distance = 1.5,
        Name = "Ammunation",
        HelpText = GetString("press_buy"),
    },
    -- #endregion ammunations

    -- #region player_outfits
    SavedOutfits = {
        Coords = {
            -- discount stores
            vector3(75.70, -1392.91, 28.40),
            vector3(4.83, 6512.59, 30.90),
            vector3(1693.62, 4822.74, 41.08),
            vector3(1196.74, 2710.06, 37.24),
            vector3(-1101.29, 2710.32, 18.13),
            -- ponsonbys
            vector3(-710.11, -152.83, 36.44),
            vector3(-163.28, -303.10, 38.75),
            vector3(-1450.34, -237.19, 48.83),
            -- binco
            vector3(425.34, -806.22, 28.51),
            vector3(-822.32, -1073.78, 10.35),
            -- suburban
            vector3(125.83, -222.88, 53.58),
            vector3(614.61, 2761.71, 41.11),
            vector3(-1193.84, -768.85, 16.34),
            vector3(-3170.48, 1044.45, 19.88),
        },
        SavedOutfits = true,
        Distance = 1.5,
        Marker = 27,
        Size = { x = 0.6, y = 0.6, z = 1.0 },
        Color = { r = 0, g = 2255, b = 255 },
        HelpText = GetString("press_access_saved_outfits"),
    },
    -- #endregion player_outfits

    -- #region clothes stores
    DiscountStore = {
        Title = { textureName = "shopui_title_lowendfashion", textureDirectory = "shopui_title_lowendfashion" }, -- CHECKOUT! DISCOUNT STORE
        Subtitle = "DiscountStore",
        Blip = { Sprite = 73, Color = 47, Scale = 0.8 },
        Coords = {
            vector3(72.254, -1399.102, 28.40),
            vector3(11.632, 6514.224, 30.90),
            vector3(1696.291, 4829.312, 41.08),
            vector3(1190.550, 2713.441, 37.24),
            vector3(-1108.441, 2708.923, 18.13),
        },
        ClothesStore = true,
        SkinElements = {
            "torso",
            "leg",
            "bag",
            "shoes",
            "accessory",
            "undershirt",
            "decals",
            "tops",
            "bodyarmor",
            "hats",
            "glasses",
            "ears",
            "watches",
            "bracelets",
        },
        Price = 250,
        Marker = 27,
        Size = { x = 1.0, y = 1.0, z = 1.0 },
        Color = { r = 255, g = 255, b = 255 },
        Distance = 2.0,
        Name = "Magasin de vêtements",
        HelpText = GetString("press_open_menu"),
    },
    Ponsonbys = {
        Title = { textureName = "shopui_title_highendfashion", textureDirectory = "shopui_title_highendfashion" }, -- PONSONBYS
        Subtitle = "Ponsonbys",
        Blip = { Sprite = 73, Color = 47, Scale = 0.8 },
        Coords = { vector3(-703.776, -152.258, 36.44), vector3(-167.863, -298.969, 38.75), vector3(-1447.797, -242.461, 48.83) },
        ClothesStore = true,
        SkinElements = {
            "torso",
            "leg",
            "bag",
            "shoes",
            "accessory",
            "undershirt",
            "decals",
            "tops",
            "bodyarmor",
            "hats",
            "glasses",
            "ears",
            "watches",
            "bracelets",
        },
        Price = 250,
        Marker = 27,
        Size = { x = 1.0, y = 1.0, z = 1.0 },
        Color = { r = 255, g = 255, b = 255 },
        Distance = 2.0,
        Name = "Magasin de vêtements",
        HelpText = GetString("press_open_menu"),
    },
    Binco = {
        Title = { textureName = "shopui_title_lowendfashion2", textureDirectory = "shopui_title_lowendfashion2" }, -- binco
        Subtitle = "Binco",
        Blip = { Sprite = 73, Color = 47, Scale = 0.8 },
        Coords = { vector3(428.694, -800.106, 28.51), vector3(-829.413, -1073.710, 10.35) },
        ClothesStore = true,
        SkinElements = {
            "torso",
            "leg",
            "bag",
            "shoes",
            "accessory",
            "undershirt",
            "decals",
            "tops",
            "bodyarmor",
            "hats",
            "glasses",
            "ears",
            "watches",
            "bracelets",
        },
        Price = 250,
        Marker = 27,
        Size = { x = 1.0, y = 1.0, z = 1.0 },
        Color = { r = 255, g = 255, b = 255 },
        Distance = 2.0,
        Name = "Magasin de vêtements",
        HelpText = GetString("press_open_menu"),
    },
    Suburban = {
        Title = { textureName = "shopui_title_midfashion", textureDirectory = "shopui_title_midfashion" }, -- suburban
        Subtitle = "Suburban",
        Blip = { Sprite = 73, Color = 47, Scale = 0.8 },
        Coords = {
            vector3(123.646, -219.440, 53.58),
            vector3(618.093, 2759.629, 41.11),
            vector3(-1193.429, -772.262, 16.34),
            vector3(-3172.496, 1048.133, 19.88),
        },
        ClothesStore = true,
        SkinElements = {
            "torso",
            "leg",
            "bag",
            "shoes",
            "accessory",
            "undershirt",
            "decals",
            "tops",
            "bodyarmor",
            "hats",
            "glasses",
            "ears",
            "watches",
            "bracelets",
        },
        Price = 250,
        Marker = 27,
        Size = { x = 1.0, y = 1.0, z = 1.0 },
        Color = { r = 255, g = 255, b = 255 },
        Distance = 2.0,
        Name = "Magasin de vêtements",
        HelpText = GetString("press_open_menu"),
    },

    MaskShop = {
        Title = { textureName = "shopui_title_movie_masks", textureDirectory = "shopui_title_movie_masks" },
        Subtitle = "Vespucci movie masks",
        Blip = { Sprite = 671, Color = 31, Scale = 0.8 },
        Coords = { vector3(-1336.87, -1278.91, 3.88) },
        ClothesStore = true,
        SkinElements = { "mask" },
        Price = 50,
        MinCamVerticalOffset = 0.5,
        Marker = 27,
        Size = { x = 1.0, y = 1.0, z = 1.0 },
        Color = { r = 255, g = 255, b = 255 },
        Distance = 2.0,
        Name = "Magasin de masques",
        HelpText = GetString("press_open_menu"),
    },
    -- #endregion clothes stores

    -- #region barber shops
    HairOnHawickBarber = {
        Title = { textureName = "shopui_title_barber4", textureDirectory = "shopui_title_barber4" }, -- HAIR ON HAWICK TRADITIONAL BARBERS
        Subtitle = "Hair On Hawick Traditional Barbers",
        Blip = { Sprite = 71, Color = 51, Scale = 0.8 },
        Coords = { vector3(-32.885, -152.319, 56.10) },
        ClothesStore = true,
        SkinElements = { "hair", "beard", "eyebrows", "chesthair", "eyes_color", "makeup", "lipstick", "blush" },
        Price = 150,
        MinCamVerticalOffset = 0.2,
        Marker = 27,
        Size = { x = 1.0, y = 1.0, z = 1.0 },
        Color = { r = 255, g = 255, b = 255 },
        Distance = 2.0,
        Name = "Coiffeur",
        HelpText = GetString("press_open_menu"),
    },
    BobMuletBarber = {
        Title = { textureName = "shopui_title_highendsalon", textureDirectory = "shopui_title_highendsalon" }, -- bob mulét
        Subtitle = "Bob Mulét",
        Blip = { Sprite = 71, Color = 51, Scale = 0.8 },
        Coords = { vector3(-814.308, -183.823, 36.59) },
        ClothesStore = true,
        SkinElements = { "hair", "beard", "eyebrows", "chesthair", "eyes_color", "makeup", "lipstick", "blush" },
        Price = 150,
        MinCamVerticalOffset = 0.2,
        Marker = 27,
        Size = { x = 1.0, y = 1.0, z = 1.0 },
        Color = { r = 255, g = 255, b = 255 },
        Distance = 2.0,
        Name = "Coiffeur",
        HelpText = GetString("press_open_menu"),
    },
    HerrKutzBarber = {
        Title = { textureName = "shopui_title_barber", textureDirectory = "shopui_title_barber" }, -- HERR KUTZ BARBER
        Subtitle = "Herr Kutz Barber",
        Blip = { Sprite = 71, Color = 51, Scale = 0.8 },
        Coords = { vector3(136.826, -1708.373, 28.31), vector3(1212.840, -473.921, 65.23), vector3(-278.077, 6228.463, 30.72) },
        ClothesStore = true,
        SkinElements = { "hair", "beard", "eyebrows", "chesthair", "eyes_color", "makeup", "lipstick", "blush" },
        Price = 150,
        MinCamVerticalOffset = 0.2,
        Marker = 27,
        Size = { x = 1.0, y = 1.0, z = 1.0 },
        Color = { r = 255, g = 255, b = 255 },
        Distance = 2.0,
        Name = "Coiffeur",
        HelpText = GetString("press_open_menu"),
    },
    BeachComboverBarber = {
        Title = { textureName = "shopui_title_barber2", textureDirectory = "shopui_title_barber2" }, -- BEACHCOMBOVER BARBERS
        Subtitle = "Beachcombover Barber",
        Blip = { Sprite = 71, Color = 51, Scale = 0.8 },
        Coords = { vector3(-1282.604, -1116.757, 6.01) },
        ClothesStore = true,
        SkinElements = { "hair", "beard", "eyebrows", "chesthair", "eyes_color", "makeup", "lipstick", "blush" },
        Price = 150,
        MinCamVerticalOffset = 0.2,
        Marker = 27,
        Size = { x = 1.0, y = 1.0, z = 1.0 },
        Color = { r = 255, g = 255, b = 255 },
        Distance = 2.0,
        Name = "Coiffeur",
        HelpText = GetString("press_open_menu"),
    },
    OSheasBarber = {
        Title = { textureName = "shopui_title_barber3", textureDirectory = "shopui_title_barber3" }, -- O'SHEAS BARBERS
        Subtitle = "O'Sheas Barbers",
        Blip = { Sprite = 71, Color = 51, Scale = 0.8 },
        Coords = { vector3(1931.513, 3729.671, 31.86) },
        ClothesStore = true,
        SkinElements = { "hair", "beard", "eyebrows", "chesthair", "eyes_color", "makeup", "lipstick", "blush" },
        Price = 150,
        MinCamVerticalOffset = 0.2,
        Marker = 27,
        Size = { x = 1.0, y = 1.0, z = 1.0 },
        Color = { r = 255, g = 255, b = 255 },
        Distance = 2.0,
        Name = "Coiffeur",
        HelpText = GetString("press_open_menu"),
    },
    -- #endregion barber shops

    -- #region tattoos shops
    BlazingTattoo = {
        Title = { textureName = "shopui_title_tattoos", textureDirectory = "shopui_title_tattoos" }, -- Blazing tattoo
        Subtitle = "Blazing tattoo",
        Blip = { Sprite = 75, Color = 1, Scale = 0.8 },
        Coords = { vector3(322.50, 180.80, 102.61) },
        ClothesStore = true,
        SkinElements = { "tattoos" },
        Price = 250,
        Marker = 27,
        Size = { x = 1.0, y = 1.0, z = 1.0 },
        Color = { r = 255, g = 255, b = 255 },
        Distance = 2.0,
        Name = "Tatoueur",
        HelpText = GetString("press_open_menu"),
    },
    BodyArtPiercingTattoo = {
        Title = { textureName = "shopui_title_tattoos2", textureDirectory = "shopui_title_tattoos2" }, -- Tattoo Body art & Piercing
        Subtitle = "Tatto Body Art & Piercing",
        Blip = { Sprite = 75, Color = 1, Scale = 0.8 },
        Coords = { vector3(1864.63, 3747.74, 32.04), vector3(-293.87, 6199.93, 30.51) },
        ClothesStore = true,
        SkinElements = { "tattoos" },
        Price = 250,
        Marker = 27,
        Size = { x = 1.0, y = 1.0, z = 1.0 },
        Color = { r = 255, g = 255, b = 255 },
        Distance = 2.0,
        Name = "Tatoueur",
        HelpText = GetString("press_open_menu"),
    },
    ThePitTattoo = {
        Title = { textureName = "shopui_title_tattoos3", textureDirectory = "shopui_title_tattoos3" }, -- The PIT
        Subtitle = "The PIT",
        Blip = { Sprite = 75, Color = 1, Scale = 0.8 },
        Coords = { vector3(-1153.74, -1425.80, 3.97) },
        ClothesStore = true,
        SkinElements = { "tattoos" },
        Price = 250,
        Marker = 27,
        Size = { x = 1.0, y = 1.0, z = 1.0 },
        Color = { r = 255, g = 255, b = 255 },
        Distance = 2.0,
        Name = "Tatoueur",
        HelpText = GetString("press_open_menu"),
    },
    LosSantosTattoo = {
        Title = { textureName = "shopui_title_tattoos4", textureDirectory = "shopui_title_tattoos4" }, -- Los Santos TATTOOS
        Subtitle = "Los Santos Tattoos",
        Blip = { Sprite = 75, Color = 1, Scale = 0.8 },
        Coords = { vector3(1322.65, -1652.43, 51.30) },
        ClothesStore = true,
        SkinElements = { "tattoos" },
        Price = 250,
        Marker = 27,
        Size = { x = 1.0, y = 1.0, z = 1.0 },
        Color = { r = 255, g = 255, b = 255 },
        Distance = 2.0,
        Name = "Tatoueur",
        HelpText = GetString("press_open_menu"),
    },
    InkIncTattoo = {
        Title = { textureName = "shopui_title_tattoos5", textureDirectory = "shopui_title_tattoos5" }, -- InkInc tattoos
        Subtitle = "InkInc Tattoos",
        Blip = { Sprite = 75, Color = 1, Scale = 0.8 },
        Coords = { vector3(-3170.02, 1075.80, 19.85) },
        ClothesStore = true,
        SkinElements = { "tattoos" },
        Price = 250,
        Marker = 27,
        Size = { x = 1.0, y = 1.0, z = 1.0 },
        Color = { r = 255, g = 255, b = 255 },
        Distance = 2.0,
        Name = "Tatoueur",
        HelpText = GetString("press_open_menu"),
    },
    -- #endregion tattoos shops

    -- #region car washs
    Carwash_InnocenceBlvd = {
        Blip = { Sprite = 100, Color = 0, Scale = 0.6 },
        Coord = vector3(29.06, -1391.93, 28.38),
        Carwash = {
            Particles = {
                -- right
                { Coord = vector3(29.15, -1389.88, 29.0), Name = "ent_amb_car_wash_jet", Heading = 180.0 },
                { Coord = vector3(29.15, -1389.88, 30.0), Name = "ent_amb_car_wash_jet", Heading = 180.0 },

                -- left
                { Coord = vector3(29.15, -1393.80, 29.0), Name = "ent_amb_car_wash_jet", Heading = 0.0 },
                { Coord = vector3(29.15, -1393.80, 30.0), Name = "ent_amb_car_wash_jet", Heading = 0.0 },
            },
            Price = 80,
            Duration = 5000,
        },
        Marker = 27,
        Size = { x = 3.5, y = 3.5, z = 3.0 },
        Distance = 2,
        Color = { r = 198, g = 183, b = 222 },
        Name = "Station de lavage",
        HelpText = GetString("press_wash_car", 80),
    },
    Carwash_LittleSeoul = {
        Blip = { Sprite = 100, Color = 0, Scale = 0.6 },
        Coord = vector3(-699.65, -933.13, 18.03),
        Carwash = {
            Particles = {
                -- right
                { Coord = vector3(-702.59, -933.14, 18.5), Name = "ent_amb_car_wash_jet", Heading = 90.0 },
                { Coord = vector3(-702.59, -933.14, 19.5), Name = "ent_amb_car_wash_jet", Heading = 90.0 },

                -- left
                { Coord = vector3(-697.40, -933.10, 18.5), Name = "ent_amb_car_wash_jet", Heading = 270.0 },
                { Coord = vector3(-697.40, -933.10, 19.5), Name = "ent_amb_car_wash_jet", Heading = 270.0 },
            },
            Price = 80,
            Duration = 5000,
        },
        Marker = 27,
        Size = { x = 3.5, y = 3.5, z = 3.0 },
        Distance = 2,
        Color = { r = 198, g = 183, b = 222 },
        Name = "Station de lavage",
        HelpText = GetString("press_wash_car", 80),
    },
    Carwash_CarsonAve = {
        Blip = { Sprite = 100, Color = 0, Scale = 0.6 },
        Coord = vector3(167.90, -1715.70, 28.31),
        Carwash = {
            Particles = {
                -- right
                { Coord = vector3(169.25, -1716.62, 29.5), Name = "ent_amb_car_wash_jet", Heading = 310.0 },
                { Coord = vector3(169.25, -1716.62, 29.0), Name = "ent_amb_car_wash_jet", Heading = 310.0 },

                -- left
                { Coord = vector3(166.44, -1714.57, 29.5), Name = "ent_amb_car_wash_jet", Heading = 130.0 },
                { Coord = vector3(166.44, -1714.57, 29.0), Name = "ent_amb_car_wash_jet", Heading = 130.0 },
            },
            Price = 80,
            Duration = 5000,
        },
        Marker = 27,
        Size = { x = 3.5, y = 3.5, z = 3.0 },
        Distance = 2,
        Color = { r = 198, g = 183, b = 222 },
        Name = "Station de lavage",
        HelpText = GetString("press_wash_car", 80),
    },
    Carwash_Paleto = {
        Blip = { Sprite = 100, Color = 0, Scale = 0.6 },
        Coord = vector3(-75.27, 6424.31, 30.51),
        Carwash = { Particles = { { Coord = vector3(-70.69, 6423.91, 31.68), Name = "ent_amb_car_wash_jet", Heading = -80.0 } }, Price = 80, Duration = 5000 },
        Marker = 27,
        Size = { x = 3.5, y = 3.5, z = 3.0 },
        Distance = 2,
        Color = { r = 198, g = 183, b = 222 },
        Name = "Station de lavage",
        HelpText = GetString("press_wash_car", 80),
    },
    Carwash_Sandy = {
        Blip = { Sprite = 100, Color = 0, Scale = 0.6 },
        Coord = vector3(1362.08, 3592.20, 33.94),
        Carwash = { Price = 80, Duration = 5000 },
        Marker = 27,
        Size = { x = 3.5, y = 3.5, z = 3.0 },
        Distance = 2,
        Color = { r = 198, g = 183, b = 222 },
        Name = "Station de lavage",
        HelpText = GetString("press_wash_car", 80),
    },
    -- #endregion car washs

    -- #region vehicleshops
    Motorsport = {
        Name = "Premium Deluxe Motorsport",
        Blip = { Sprite = 326, Color = 0 },
        Coord = vector3(-56.59, -1097.87, 26.84),
        Size = { x = 1.0, y = 1.0, z = 1.0 },
        Color = { r = 255, g = 255, b = 255 },
        Distance = 2.6,
        Marker = 36,
        VehicleShop = {
            VehicleType = 0,
            -- Categories = {"compacts", "coupes", "motorcycles", "muscles", "offroads", "sedans", "sports", "sportsclassics", "super", "suvs", "vans", "industrial", "utility", "commercials", "emergency", },
            Inside = { Coord = vector3(-47.56, -1096.10, 26.42), Heading = 70.0, Distance = 15 },
            SpawnVehicle = { Coord = vector3(-31.02, -1090.68, 25.43), Heading = 330.5 },
            SpawnLargeVehicle = { Coord = vector3(-31.19, -1080.54, 26.14), Heading = 71.5 },
        },
        HelpText = GetString("press_open_menu"),
    },
    MotorsportSell = {
        Name = "Vente de véhicules",
        Coord = vector3(-45.56, -1081.63, 26.69),
        Size = { x = 2.0, y = 2.0, z = 2.0 },
        Color = { r = 201, g = 24, b = 30, a = 128 },
        Marker = 29,
        Blip = { Sprite = 810, Color = 0xffaaaaa0, Scale = 0.5 },
        SellVehicle = { VehicleType = 0 },
        HelpText = GetString("press_open_sell_vehicle"),
    },
    FlyUsP = {
        Name = "FlyUs Avions",
        Blip = { Sprite = 307, Color = 0 },
        Coord = vector3(-923.93, -2965.77, 19.85),
        Size = { x = 1.0, y = 1.0, z = 1.0 },
        Color = { r = 255, g = 255, b = 255 },
        Distance = 2.6,
        Marker = 33,
        VehicleShop = {
            VehicleType = 2,
            Inside = { Coord = vector3(-959.16, -2979.31, 12.96), Heading = 22.68, Distance = 50 },
            SpawnVehicle = { Coord = vector3(-986.22, -3012.65, 12.97), Heading = 58.03 },
        },
        HelpText = GetString("press_open_menu"),
    },
    FlyUsPSell = {
        Name = "Vente d'avions",
        Coord = vector3(-1273.77, -3384.78, 13.94),
        Size = { x = 2.0, y = 2.0, z = 2.0 },
        Color = { r = 201, g = 24, b = 30, a = 128 },
        Marker = 29,
        Distance = 5,
        Blip = { Sprite = 307, Color = 0xffaaaaa0, Scale = 0.5 },
        SellVehicle = { VehicleType = 2 },
        HelpText = GetString("press_open_sell_vehicle"),
    },
    FlyUsH = {
        Name = "FlyUs Hélicopteres",
        Blip = { Sprite = 64, Color = 0 },
        Coord = vector3(-941.06, -2954.13, 19.85),
        Size = { x = 1.0, y = 1.0, z = 1.0 },
        Color = { r = 255, g = 255, b = 255 },
        Distance = 2.6,
        Marker = 34,
        VehicleShop = {
            VehicleType = 3,
            Inside = { Coord = vector3(-959.16, -2979.31, 12.96), Heading = 22.68, Distance = 50 },
            SpawnVehicle = { Coord = vector3(-1112.42, -2883.81, 12.97), Heading = 331.25 },
        },
        HelpText = GetString("press_open_menu"),
    },
    FlyUsHSell = {
        Name = "Vente d'hélicoptères",
        Coord = vector3(-1178.45, -2845.75, 13.95),
        Size = { x = 2.0, y = 2.0, z = 2.0 },
        Color = { r = 201, g = 24, b = 30, a = 128 },
        Distance = 5,
        Marker = 29,
        Blip = { Sprite = 64, Color = 0xffaaaaa0, Scale = 0.5 },
        SellVehicle = { VehicleType = 3 },
        HelpText = GetString("press_open_sell_vehicle"),
    },
    Marina = {
        Name = "Marina",
        Blip = { Sprite = 427, Color = 0 },
        Coord = vector3(-724.69, -1334.49, 1.60),
        Size = { x = 1.0, y = 1.0, z = 1.0 },
        Color = { r = 255, g = 255, b = 255 },
        Distance = 2.6,
        Marker = 35,
        VehicleShop = {
            VehicleType = 1,
            Inside = { Coord = vector3(-720.56, -1338.50, 1.20), Heading = 142.61, Distance = 35 },
            SpawnVehicle = { Coord = vector3(-730.75, -1352.40, 1.19), Heading = 142.61 },
        },
        HelpText = GetString("press_open_menu"),
    },
    MarinaSell = {
        Name = "Vente de bateaux",
        Coord = vector3(-765.33, -1416.03, 1.22),
        Size = { x = 2.0, y = 2.0, z = 2.0 },
        Color = { r = 201, g = 24, b = 30, a = 128 },
        Marker = 29,
        Blip = { Sprite = 427, Color = 0xffaaaaa0, Scale = 0.5 },
        SellVehicle = { VehicleType = 1 },
        HelpText = GetString("press_open_sell_vehicle"),
    },
    -- #endregion vehicleshops

    -- #region lscustoms
    -- LSCustoms = {
    --     Title = { textureName = "shopui_title_carmod", textureDirectory = "shopui_title_carmod" }, -- Los Santos Customs
    --     Name = "Los Santos Customs",
    --     Coord = vector3(-1157.75, -2013.92, 12.21),
    --     Size = { x = 2.0, y = 2.0, z = 2.0 },
    --     Color = { r = 201, g = 24, b = 30, a = 128 },
    --     Marker = 27,
    --     Blip = { Sprite = 72, Color = 0, Scale = 0.8 },
    --     LSCustoms = {
    --         DirtyCash = false,
    --         -- Elements = { "engine", "colors", "mods" }
    --     },
    --     HelpText = GetString("press_open_lscustoms"),
    -- },
    -- BeekersCustom = {
    --     Title = { textureName = "shopui_title_carmod2", textureDirectory = "shopui_title_carmod2" }, -- Beeker's GARAGE & PARTS
    --     Name = "Beeker's GARAGE & PARTS",
    --     Coord = vector3(-1150.34, -2011.13, 12.25),
    --     Size = { x = 2.0, y = 2.0, z = 2.0 },
    --     Color = { r = 201, g = 24, b = 30, a = 128 },
    --     Marker = 27,
    --     Blip = { Sprite = 72, Color = 0, Scale = 0.8 },
    --     LSCustoms = {
    --         DirtyCash = false,
    --         -- Elements = { "engine", "colors", "mods" }
    --     },
    --     HelpText = GetString("press_open_lscustoms"),
    -- },
    -- #endregion lscustoms

    AirportRental = {
        -- Title = { textureName = "shopui_title_carmod", textureDirectory = "shopui_title_carmod" }, -- Los Santos Customs
        Name = "Location",
        Coord = vector3(-1038.11, -2731.25, 19.19),
        Size = { x = 1.0, y = 1.0, z = 1.0 },
        Color = { r = 255, g = 187, b = 51 },
        Distance = 1.5,
        Marker = 27,
        Blip = { Sprite = 225, Color = 66, Scale = 0.6 },
        Rental = {
            Vehicles = {
                { name = "faggio2", price = 499 }
            },
            SpawnCoord = vector4(-1036.37, -2728.19, 19.12, 240.0)
        },
        HelpText = GetString("press_open_menu"),
    },

}

Config.ClothesStore = {
    DefaultCamVerticalOffset = 0.6,
    MaxCamVerticalOffset = 0.95,
    MinCamVerticalOffset = -0.85,
    Tattoos = json.decode(LoadResourceFile(GetCurrentResourceName(), "tattooList.json") or "{}") or {},
    ElementsHiddenOnItems = {
        -- Don't change the order
        -- Head
        [1] = {
            [0] = { hats = -1, hats_txd = 0, mask = 0, mask_txd = 0, glasses = 0, glasses_txd = 0 },
            [1] = { hats = -1, hats_txd = 0, mask = 0, mask_txd = 0, glasses = -1, glasses_txd = 0 },
        },
        -- All clothes
        [2] = {
            [0] = { tops = 15, tops_txd = 0, torso = 15, torso_txd = 0, undershirt = 15, undershirt_txd = 0, leg = 61, leg_txd = 1, shoes = 5, shoes_txd = 0, bag = 0, bag_txd = 0, decals = 0, decals_txd = 0, bodyarmor = 0, bodyarmor_txd = 0 },
            [1] = { tops = 15, tops_txd = 0, torso = 15, torso_txd = 0, undershirt = 14, undershirt_txd = 0, leg = 15, leg_txd = 0, shoes = 5, shoes_txd = 0, bag = 0, bag_txd = 0, decals = 0, decals_txd = 0, bodyarmor = 0, bodyarmor_txd = 0 },
        },
        -- All clothes and head
        [3] = {
            [0] = { tops = 15, tops_txd = 0, torso = 15, torso_txd = 0, undershirt = 15, undershirt_txd = 0, leg = 61, leg_txd = 1, shoes = 5, shoes_txd = 0, bag = 0, bag_txd = 0, decals = 0, decals_txd = 0, bodyarmor = 0, bodyarmor_txd = 0, hats = -1, hats_txd = 0, mask = 0, mask_txd = 0, glasses = 0, glasses_txd = 0 },
            [1] = { tops = 15, tops_txd = 0, torso = 15, torso_txd = 0, undershirt = 14, undershirt_txd = 0, leg = 15, leg_txd = 0, shoes = 5, shoes_txd = 0, bag = 0, bag_txd = 0, decals = 0, decals_txd = 0, bodyarmor = 0, bodyarmor_txd = 0, hats = -1, hats_txd = 0, mask = 0, mask_txd = 0, glasses = -1, glasses_txd = 0 },
        },
    },
}

Config.VehicleShops = {
    Vehicles = json.decode(LoadResourceFile(GetCurrentResourceName(), "vehicleshop.json") or "{}") or {},
    DefaultStockValue = 5,
    SellMultiplier = 0.8,
    MaxVehiclePerPlayer = 30,
}
