-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config.Jobs.winemaker = {
    LabelName = "Vigneron",
    Blip = { Sprite = 85, Color = 19 },
    Zones = {
        ManagerMenu = {
            Coord = vector3(-1895.18, 2063.98, 140.03),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 252, g = 186, b = 3 },
            Name = "Actions patron",
            HelpText = GetString("press_to_open"),
            Marker = 27,
            MinimumGrade = "employee",
        },
        MainStock = {
            Coord = vector3(-1881.15, 2070.18, 140.03),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 252, g = 186, b = 3 },
            Name = "Stockage",
            InventoryName = "job_winemaker_stock",
            HelpText = GetString("press_to_open"),
            Marker = 27,
            Blip = true,
        },
        Cloakroom = {
            Coord = vector3(-1874.90, 2054.53, 140.09),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 252, g = 186, b = 3 },
            Name = "Vestiaire",
            HelpText = GetString("press_to_open"),
            Marker = 27,
            Blip = true,
            Outfits = {
                {
                    Label = "Tenue de travail",
                    Male = json.decode(
                        '{"undershirt":15,"bodyarmor":0,"decals":0,"ears":-1,"leg_txd":0,"bracelets_txd":0,"mask_txd":0,"bag_txd":0,"bodyarmor_txd":0,"mask":0,"glasses_txd":0,"hats_txd":0,"accessory_txd":0,"shoes_txd":2,"ears_txd":0,"accessory":0,"tops":43,"decals_txd":0,"shoes":51,"bracelets":-1,"torso_txd":0,"torso":11,"bag":40,"tops_txd":0,"watches_txd":0,"undershirt_txd":0,"leg":9,"watches":-1,"hats":-1,"glasses":-1}'),
                    Female = json.decode(
                        '{"undershirt":15,"bodyarmor":0,"decals":0,"ears":-1,"leg_txd":2,"bracelets_txd":0,"mask_txd":0,"bag_txd":0,"bodyarmor_txd":0,"mask":0,"glasses_txd":0,"hats_txd":0,"accessory_txd":0,"shoes_txd":1,"ears_txd":0,"accessory":0,"tops":118,"decals_txd":0,"shoes":52,"bracelets":-1,"torso_txd":0,"torso":4,"bag":40,"tops_txd":2,"watches_txd":0,"undershirt_txd":0,"leg":93,"watches":-1,"hats":-1,"glasses":-1}'),
                },
            },
        },
    },
    FieldZones = {
        GrapeField = {
            Items = { { name = "grape", quantity = 8 } },
            PropHash = GetHashKey("prop_mk_race_chevron_02"),
            Coord = vector3(-1809.662, 2210.119, 90.681),
            MinGroundHeight = 88,
            MaxGroundHeight = 100,
            Name = "1. Récolte",
            -- Distance = 1.3,
            Blip = true,
        },
    },
    ProcessZones = {
        WineProcess = {
            ItemsGive = { { name = "grape", quantity = 10 } },
            ItemsGet = { { name = "wine", quantity = 1 }, { name = "grapejuice", quantity = 1 } },
            Delay = 6000,
            Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
            Coord = vector3(-1930.97, 2055.08, 139.83),
            Size = { x = 2.5, y = 2.5, z = 1.5 },
            Color = { r = 252, g = 186, b = 3 },
            Name = "2. Traitement vin",
            HelpText = GetString("press_traitement"),
            Marker = 27,
            Blip = true,
        },
        ChampagneProcess = {
            ItemsGive = { { name = "grape", quantity = 10 } },
            ItemsGet = { { name = "champagne", quantity = 1 }, { name = "luxurywine", quantity = 1 } },
            Delay = 8000,
            Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
            Coord = vector3(-1866.50, 2058.95, 140.02),
            Size = { x = 2.5, y = 2.5, z = 1.5 },
            Color = { r = 252, g = 186, b = 3 },
            Name = "Traitement champagne et grand cru",
            HelpText = GetString("press_traitement"),
            MinimumGrade = "employee",
            Marker = 27,
            Blip = true,
        },
    },
    ProcessMenuZones = {
        BoxingProcess = {
            Title = "Mise en caisse",
            Process = {
                WineProcess = {
                    Name = "Caisse de Vin",
                    Desc = "Une caisse de six bouteilles",
                    ItemsGive = { { name = "wine", quantity = 6 }, { name = "woodenbox", quantity = 1 } },
                    ItemsGet = { { name = "winebox", quantity = 1 } },
                    Delay = 2000,
                    Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                },
                JusRaisinProcess = {
                    Name = "Caisse de Jus de raisin",
                    Desc = "Une caisse de six bouteilles",
                    ItemsGive = { { name = "grapejuice", quantity = 6 }, { name = "woodenbox", quantity = 1 } },
                    ItemsGet = { { name = "grapejuicebox", quantity = 1 } },
                    Delay = 2000,
                    Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                },
                ChampagneProcess = {
                    Name = "Caisse de Champagne",
                    Desc = "Une caisse de six bouteilles",
                    ItemsGive = { { name = "champagne", quantity = 6 }, { name = "woodenbox", quantity = 1 } },
                    ItemsGet = { { name = "champagnebox", quantity = 1 } },
                    Delay = 2000,
                    Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                },
                luxurywineProcess = {
                    Name = "Caisse de Grand Cru",
                    Desc = "Une caisse de six bouteilles",
                    ItemsGive = { { name = "luxurywine", quantity = 6 }, { name = "woodenbox", quantity = 1 } },
                    ItemsGet = { { name = "luxurywinebox", quantity = 1 } },
                    Delay = 2000,
                    Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                },
            },
            MaxProcess = 3,
            Coord = vector3(-1933.06, 2061.9, 139.86),
            Size = { x = 2.5, y = 2.5, z = 1.5 },
            Color = { r = 252, g = 186, b = 3 },
            Name = "4. Traitement en caisses",
            HelpText = GetString("press_traitement"),
            Marker = 27,
            Blip = true,
        },
    },
    SellZones = {
        WineMerchantSell = {
            Items = { { name = "winebox", price = 1600 }, { name = "grapejuicebox", price = 650 } },
            Coord = vector3(-158.737, -54.651, 53.42),
            Size = { x = 1.5, y = 1.5, z = 1.5 },
            Color = { r = 252, g = 186, b = 3 },
            Name = "5. Vente des produits",
            HelpText = GetString("press_sell"),
            Marker = 27,
            Blip = true,
        },
    },
    BuyZones = {
        BuyBox = {
            Items = { { name = "woodenbox", price = 20 } },
            Coord = vector3(396.77, -345.88, 45.86),
            Size = { x = 1.5, y = 1.5, z = 1.5 },
            Color = { r = 252, g = 186, b = 3 },
            Name = "3. Achat de caisses",
            HelpText = GetString("press_buy"),
            Marker = 27,
            Blip = true,
        },
    },
    Garages = {
        -- Job garages
        {
            Name = "jobgarage_winemaker",
            Coord = vector3(-1888.97, 2045.06, 140.87),
            Size = { x = 2.0, y = 2.0, z = 2.0 },
            Color = { r = 252, g = 186, b = 3 },
            Marker = 36,
            VehicleType = 0,
            IsJobGarage = "winemaker",
            JobNeeded = "winemaker",
            SpawnPoint = { Coord = vector3(-1898.16, 2048.77, 139.89), Heading = 70.0 },
            Blip = { Name = "Garage entreprise" },
        },
        --Player garages
        {
            Name = "garage_winemaker",
            Coord = vector3(-1911.01, 2031.90, 140.74),
            Size = { x = 2.0, y = 2.0, z = 2.0 },
            Color = { r = 255, g = 255, b = 255 },
            Marker = 36,
            VehicleType = 0,
            JobNeeded = "winemaker",
            SpawnPoint = { Coord = vector3(-1911.01, 2031.90, 140.74), Heading = 344.98 },
            Blip = { Name = "Garage", Sprite = 357, Color = 0, Scale = 0.4 },
        },
    }
}
