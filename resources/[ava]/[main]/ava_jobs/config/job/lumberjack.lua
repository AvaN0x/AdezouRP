-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config.Jobs.lumberjack = {
    LabelName = "Bûcheron",
    Blip = { Sprite = 237, Color = 10 },
    Zones = {
        ManagerMenu = {
            Coord = vector3(-565.46, 5325.53, 72.64),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 252, g = 186, b = 3 },
            Name = "Actions patron",
            HelpText = GetString("press_to_open"),
            Marker = 27,
            MinimumGrade = "employee",
        },
        MainStock = {
            Coord = vector3(-538.10, 5288.33, 74.38),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 252, g = 186, b = 3 },
            Name = "Stockage",
            InventoryName = "job_lumberjack_stock",
            HelpText = GetString("press_to_open"),
            Marker = 27,
            Blip = true,
        },
        Cloakroom = {
            Coord = vector3(-535.13, 5296.49, 75.24),
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
                        '{"decals":0,"mask":0,"bracelets_txd":0,"torso":70,"bodyarmor_txd":0,"decals_txd":0,"accessory":0,"leg_txd":0,"bag_txd":0,"tops":44,"glasses":-1,"accessory_txd":0,"undershirt_txd":0,"shoes_txd":0,"mask_txd":0,"hats_txd":2,"hats":145,"glasses_txd":0,"bag":0,"tops_txd":0,"torso_txd":0,"bracelets":-1,"leg":63,"undershirt":15,"ears_txd":0,"ears":-1,"watches":-1,"bodyarmor":0,"shoes":12,"watches_txd":0}'),
                    Female = json.decode(
                        '{"decals":0,"mask":0,"bracelets_txd":0,"torso":80,"bodyarmor_txd":0,"decals_txd":0,"accessory":0,"leg_txd":0,"bag_txd":0,"tops":109,"glasses":-1,"accessory_txd":0,"undershirt_txd":0,"shoes_txd":0,"mask_txd":0,"hats_txd":2,"hats":144,"glasses_txd":0,"bag":0,"tops_txd":0,"torso_txd":0,"bracelets":-1,"leg":51,"undershirt":15,"ears_txd":0,"ears":-1,"watches":-1,"bodyarmor":0,"shoes":25,"watches_txd":0}'),
                },
            },
        },
    },
    FieldZones = {
        WoodField = {
            Items = { { name = "woodpile", quantity = 1 } },
            PropHash = GetHashKey("prop_woodpile_04b"),
            Coord = vector3(-513.54, 5242.46, 79.32),
            MinGroundHeight = 78,
            MaxGroundHeight = 80,
            Name = "1. Récolte",
            Radius = 2 ,
            Blip = true,
        },
    },
    ProcessZones = {
        WoodProcess = {
            ItemsGive = { { name = "woodpile", quantity = 1 } },
            ItemsGet = { { name = "woodchipsbag", quantity = 50 } },
            Delay = 6000,
            Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
            Coord = vector3(-580.32, 5277.04, 69.28),
            Size = { x = 2.5, y = 2.5, z = 1.5 },
            Color = { r = 252, g = 186, b = 3 },
            Name = "2. Brouillage",
            HelpText = GetString("press_traitement"),
            Marker = 27,
            Blip = true,
        },
    },
    SellZones = {
        woodSell = {
            Items = { { name = "woodchipsbag", price = 1400 } },
            Coord = vector3(618.96, 2785.04, 42.50),
            Size = { x = 1.5, y = 1.5, z = 1.5 },
            Color = { r = 252, g = 186, b = 3 },
            Name = "5. Vente des sacs",
            HelpText = GetString("press_sell"),
            Marker = 27,
            Blip = true,
        },
    },
    Garages = {
        -- Job garages
        {
            Name = "jobgarage_lumberjack",
            Coord = vector3(-509.77, 5266.37, 79.63),
            Size = { x = 2.0, y = 2.0, z = 2.0 },
            Color = { r = 252, g = 186, b = 3 },
            Marker = 36,
            VehicleType = 0,
            IsJobGarage = "lumberjack",
            JobNeeded = "lumberjack",
            SpawnPoint = { Coord = vector3(-509.77, 5266.37, 79.63), Heading = 158.20 },
            Blip = { Name = "Garage entreprise" },
        },
        --Player garages
        {
            Name = "garage_lumberjack",
            Coord = vector3(-600.62, 5343.32, 69.49),
            Size = { x = 2.0, y = 2.0, z = 2.0 },
            Color = { r = 255, g = 255, b = 255 },
            Marker = 36,
            VehicleType = 0,
            JobNeeded = "lumberjack",
            SpawnPoint = { Coord = vector3(-600.62, 5343.32, 69.49), Heading = 172.93 },
            Blip = { Name = "Garage", Sprite = 357, Color = 0, Scale = 0.4 },
        },
    }
}
