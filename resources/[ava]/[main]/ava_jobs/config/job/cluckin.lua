-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config.Jobs.cluckin = {
    LabelName = "Cluckin Bell",
    Blip = { Sprite = 141, Color = 46 },
    Zones = {
        ManagerMenu = {
            Coord = vector3(-513.13, -699.59, 32.19),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 136, g = 243, b = 216 },
            Name = "Actions patron",
            HelpText = GetString("press_to_open"),
            Marker = 27,
        },
        MainStock = {
            Coord = vector3(-514.78, -702.17, 32.19),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 207, g = 169, b = 47 },
            Name = "Stockage",
            InventoryName = "job_cluckin_stock",
            HelpText = GetString("press_to_open"),
            Marker = 27,
        },
        Cloakroom = {
            Coord = vector3(-510.19, -700.42, 32.19),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 136, g = 243, b = 216 },
            Name = "Vestiaire",
            HelpText = GetString("press_to_open"),
            Marker = 27,
            Blip = true,
            Outfits = {
                {
                    Label = "Tenue de service",
                    Female = json.decode(
                        '{"decals":0,"torso":9,"leg":106,"hats":-1,"mask":0,"glasses":-1,"accessory":0,"shoes":13,"bracelets_txd":0,"watches_txd":0,"undershirt":15,"tops":294,"accessory_txd":0,"bag_txd":0,"shoes_txd":15,"ears_txd":0,"bodyarmor_txd":0,"ears":-1,"glasses_txd":0,"decals_txd":0,"undershirt_txd":0,"bodyarmor":0,"leg_txd":2,"bag":0,"tops_txd":10,"mask_txd":0,"hats_txd":0,"torso_txd":0,"bracelets":-1,"watches":-1}'),
                    Male = json.decode(
                        '{"decals":0,"torso":6,"leg":105,"hats":-1,"mask":0,"glasses":-1,"accessory":0,"shoes":12,"bracelets_txd":0,"watches_txd":0,"undershirt":15,"tops":281,"accessory_txd":0,"bag_txd":0,"shoes_txd":5,"ears_txd":0,"bodyarmor_txd":0,"ears":-1,"glasses_txd":0,"decals_txd":0,"undershirt_txd":0,"bodyarmor":0,"leg_txd":5,"bag":0,"tops_txd":10,"mask_txd":0,"hats_txd":0,"torso_txd":0,"bracelets":-1,"watches":-1}'),
                },
            },

        },
    },
    FieldZones = {
        ChickenField = {
            Items = { { name = "alive_chicken", quantity = 2 } },
            PropHash = 610857585,
            Coord = vector3(85.95, 6331.61, 30.25),
            MinGroundHeight = 29,
            MaxGroundHeight = 32,
            Name = "1. Récolte",
            Blip = true,
        },
    },
    ProcessZones = {
        PluckProcess = {
            ItemsGive = { { name = "alive_chicken", quantity = 2 } },
            ItemsGet = { { name = "plucked_chicken", quantity = 2 } },
            Delay = 8000,
            Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
            Coord = vector3(-91.05, 6240.41, 30.11),
            Size = { x = 2.5, y = 2.5, z = 1.5 },
            Color = { r = 252, g = 186, b = 3 },
            Name = "2. Déplumage",
            HelpText = GetString("press_traitement"),
            Marker = 27,
            Blip = true,
        },
        RawProcess = {
            ItemsGive = { { name = "plucked_chicken", quantity = 2 } },
            ItemsGet = { { name = "raw_chicken", quantity = 8 } },
            Delay = 10000,
            Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
            Coord = vector3(-103.89, 6206.29, 30.05),
            Size = { x = 2.5, y = 2.5, z = 1.5 },
            Color = { r = 252, g = 186, b = 3 },
            Name = "3. Découpe",
            HelpText = GetString("press_traitement"),
            Marker = 27,
            Blip = true,
        },
    },
    ProcessMenuZones = {
        CookingProcess = {
            Title = "Cuisine",
            Process = {
                NuggetsProcess = {
                    Name = "Nuggets",
                    ItemsGive = { { name = "raw_chicken", quantity = 2 } },
                    ItemsGet = { { name = "nuggets", quantity = 1 } },
                    Delay = 2000,
                    Scenario = "PROP_HUMAN_BBQ", -- https://pastebin.com/6mrYTdQv
                },
                ChickenBurgerProcess = {
                    Name = "Chicken Burger",
                    ItemsGive = { { name = "raw_chicken", quantity = 2 } },
                    ItemsGet = { { name = "chickenburger", quantity = 1 } },
                    Delay = 2000,
                    Scenario = "PROP_HUMAN_BBQ", -- https://pastebin.com/6mrYTdQv
                },
                DoubleChickenBurgerProcess = {
                    Name = "Double Chicken Burger",
                    ItemsGive = { { name = "raw_chicken", quantity = 4 } },
                    ItemsGet = { { name = "doublechickenburger", quantity = 1 } },
                    Delay = 3000,
                    Scenario = "PROP_HUMAN_BBQ", -- https://pastebin.com/6mrYTdQv
                },
                TendersProcess = {
                    Name = "Tenders",
                    ItemsGive = { { name = "raw_chicken", quantity = 2 } },
                    ItemsGet = { { name = "tenders", quantity = 1 } },
                    Delay = 2000,
                    Scenario = "PROP_HUMAN_BBQ", -- https://pastebin.com/6mrYTdQv
                },
                ChickenWrapProcess = {
                    Name = "Wrap au poulet",
                    ItemsGive = { { name = "raw_chicken", quantity = 2 } },
                    ItemsGet = { { name = "chickenwrap", quantity = 1 } },
                    Delay = 2000,
                    Scenario = "PROP_HUMAN_BBQ", -- https://pastebin.com/6mrYTdQv
                },
                FriesProcess = {
                    Name = "Frites",
                    ItemsGive = { { name = "potato", quantity = 2 } },
                    ItemsGet = { { name = "fries", quantity = 1 } },
                    Delay = 2000,
                    Scenario = "PROP_HUMAN_BBQ", -- https://pastebin.com/6mrYTdQv
                },
                PotatoesProcess = {
                    Name = "Potatoes",
                    ItemsGive = { { name = "potato", quantity = 2 } },
                    ItemsGet = { { name = "potatoes", quantity = 1 } },
                    Delay = 2000,
                    Scenario = "PROP_HUMAN_BBQ", -- https://pastebin.com/6mrYTdQv
                },
            },
            MaxProcess = 5,
            Coord = vector3(-520.07, -701.52, 32.19),
            Size = { x = 2.5, y = 2.5, z = 1.5 },
            Color = { r = 252, g = 186, b = 3 },
            Name = "Cuisine",
            HelpText = GetString("press_traitement"),
            Marker = 27,
            Blip = true,
        },
    },
    SellZones = {
        ChickenSell = {
            Items = { { name = "raw_chicken", price = 50 } },
            Coord = vector3(-138.13, -256.69, 42.61),
            Size = { x = 1.5, y = 1.5, z = 1.5 },
            Color = { r = 136, g = 232, b = 9 },
            Name = "4. Vente des produits",
            HelpText = GetString("press_sell"),
            Marker = 27,
            Blip = true,
        },
    },
    BuyZones = {
        BuyDrinks = {
            Items = {
                { name = "potato", price = 10 },
                { name = "ecola", price = 15 },
            },
            Coord = vector3(406.5, -350.02, 45.84),
            Size = { x = 1.5, y = 1.5, z = 1.5 },
            Color = { r = 136, g = 232, b = 9 },
            Name = "Achat de boissons",
            HelpText = GetString("press_buy"),
            Marker = 27,
            Blip = true,
        },
    },
    Garages = {
        -- Job garage
        {
            Name = "jobgarage_cluckin",
            Coord = vector3(-465.09, -619.23, 31.17),
            Size = { x = 2.0, y = 2.0, z = 2.0 },
            Color = { r = 136, g = 232, b = 9 },
            Marker = 36,
            VehicleType = 0,
            IsJobGarage = "cluckin",
            JobNeeded = "cluckin",
            SpawnPoint = { Coord = vector3(-465.09, -619.23, 31.17), Heading = 88.32 },
            Blip = { Name = "Garage entreprise" },
        },
        -- Player garages
        {
            Name = "garage_cluckin",
            Coord = vector3(-480.36, -600.63, 31.17),
            Size = { x = 2.0, y = 2.0, z = 2.0 },
            Color = { r = 255, g = 255, b = 255 },
            Marker = 36,
            VehicleType = 0,
            JobNeeded = "cluckin",
            SpawnPoint = { Coord = vector3(-480.36, -600.63, 31.17), Heading = 182.24 },
            Blip = { Name = "Garage", Sprite = 357, Color = 0, Scale = 0.4 },
        },
    },
}
