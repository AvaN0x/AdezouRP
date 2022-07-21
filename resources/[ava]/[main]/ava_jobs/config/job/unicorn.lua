-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config.Jobs.unicorn = {
    LabelName = "Unicorn",
    Blip = { Sprite = 121, Color = 0 },
    Zones = {
        ManagerMenu = {
            Coord = vector3(95.80, -1294.25, 28.28),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 136, g = 243, b = 216 },
            Name = "Actions patron",
            HelpText = GetString("press_to_open"),
            Marker = 27,
        },
        Fridge1 = {
            Coord = vector3(129.40, -1281.06, 28.29),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 207, g = 169, b = 47 },
            Name = "Stockage",
            InventoryName = "job_unicorn_stock",
            HelpText = GetString("press_to_open"),
            Marker = 27,
        },
        Fridge2 = {
            Coord = vector3(132.04, -1285.84, 28.29),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 207, g = 169, b = 47 },
            Name = "Stockage",
            InventoryName = "job_unicorn_stock2",
            HelpText = GetString("press_to_open"),
            Marker = 27,
        },
        Cloakroom = {
            Coord = vector3(106.71, -1299.75, 27.79),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 136, g = 243, b = 216 },
            Name = "Vestiaire",
            HelpText = GetString("press_to_open"),
            Marker = 27,
            Blip = true,
            Outfits = {
                {
                    Label = "Tenue videur",
                    Male = json.decode(
                        '{"hats":-1,"glasses_txd":0,"bodyarmor_txd":0,"hats_txd":0,"undershirt":75,"bracelets":-1,"watches_txd":0,"watches":-1,"bag_txd":0,"bracelets_txd":0,"leg":10,"undershirt_txd":3,"accessory_txd":0,"accessory":0,"bag":0,"leg_txd":0,"shoes":3,"decals":0,"torso_txd":0,"decals_txd":0,"tops":29,"tops_txd":1,"torso":4,"mask":121,"bodyarmor":0,"glasses":13,"ears":-1,"shoes_txd":4,"mask_txd":0,"ears_txd":0}'),
                    Female = json.decode(
                        '{"hats":-1,"glasses_txd":0,"bodyarmor_txd":0,"hats_txd":0,"undershirt":67,"bracelets":-1,"watches_txd":0,"watches":-1,"bag_txd":0,"bracelets_txd":0,"leg":6,"undershirt_txd":3,"accessory_txd":0,"accessory":0,"bag":0,"leg_txd":1,"shoes":3,"decals":0,"torso_txd":0,"decals_txd":0,"tops":340,"tops_txd":0,"torso":3,"mask":121,"bodyarmor":0,"glasses":-1,"ears":-1,"shoes_txd":0,"mask_txd":0,"ears_txd":0}'),
                },
            }
        },
    },
    Garages = {
        -- Job garage
        {
            Name = "jobgarage_unicorn",
            Coord = vector3(144.09, -1284.85, 28.34),
            Size = { x = 2.0, y = 2.0, z = 2.0 },
            Color = { r = 0, g = 122, b = 204 },
            Marker = 36,
            VehicleType = 0,
            IsJobGarage = "unicorn",
            JobNeeded = "unicorn",
            SpawnPoint = { Coord = vector3(144.09, -1284.85, 28.34), Heading = 301.13 },
        },
        -- Player garage
        {
            Name = "garage_unicorn",
            Coord = vector3(142.12, -1269.67, 28.03),
            Size = { x = 2.0, y = 2.0, z = 2.0 },
            Color = { r = 0, g = 122, b = 204 },
            Marker = 36,
            VehicleType = 0,
            JobNeeded = "unicorn",
            SpawnPoint = { Coord = vector3(142.12, -1269.67, 28.03), Heading = 161.57 },
        },
    },
    FieldZones = {
        OrangesField = {
            Items = { { name = "orange", quantity = 8 } },
            PropHash = `ex_mp_h_acc_fruitbowl_01`,
            Coord = vector3(373.23, 6511.44, 28.31),
            MinGroundHeight = 27,
            MaxGroundHeight = 29,
            Name = "1. Récolte d'oranges",
            Blip = true,
        },
    },
    SellZones = {
        OrangeSell = {
            Items = { { name = "orange", price = 40 } },
            Coord = vector3(106.17, -1280.60, 28.27),
            Size = { x = 1.5, y = 1.5, z = 1.5 },
            Color = { r = 136, g = 232, b = 9 },
            Name = "2. Vente d'oranges",
            HelpText = GetString("press_sell"),
            Marker = 27,
            Blip = true,
        },
    },
    BuyZones = {
        BuyBox = {
            Items = {
                { name = "ecola", price = 15 },
                { name = "sprunk", price = 15 },
                { name = "orangotang", price = 15 },
                { name = "munkyjuice", price = 15 },
                { name = "junkenergy", price = 15 },
                { name = "coffee", price = 13 },
                { name = "pisswasser", price = 20 },
            },
            Coord = vector3(387.02, -343.28, 45.85),
            Size = { x = 1.5, y = 1.5, z = 1.5 },
            Color = { r = 136, g = 232, b = 9 },
            Name = "Achat de boissons",
            HelpText = GetString("press_buy"),
            Marker = 27,
            Blip = true,
        },
    },
}
