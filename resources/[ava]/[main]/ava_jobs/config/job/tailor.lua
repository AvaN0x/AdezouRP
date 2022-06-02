-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config.Jobs.tailor = {
    LabelName = "Couturier",
    Blip = { Sprite = 366, Colour = 0 },
    Zones = {
        ManagerMenu = {
            Coord = vector3(708.48, -966.69, 29.42),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 136, g = 243, b = 216 },
            Name = "Actions patron",
            HelpText = GetString("press_to_open"),
            Marker = 27,
            MinimumGrade = "employee",
        },
        MainStock = {
            Coord = vector3(708.73, -963.44, 29.42),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 207, g = 169, b = 47 },
            Name = "Stockage",
            InventoryName = "job_tailor_stock",
            HelpText = GetString("press_to_open"),
            Marker = 27,
        },
        Cloakroom = {
            Coord = vector3(708.91, -959.63, 29.42),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 136, g = 243, b = 216 },
            Name = "Vestiaire",
            HelpText = GetString("press_to_open"),
            Marker = 27,
            Blip = true,
            Outfits = {
                {
                    Label = "Tenue de Travail",
                    Male = json.decode(
                        '{"watches":-1,"watches_txd":0,"bag":87,"leg":0,"accessory_txd":0,"bodyarmor_txd":0,"undershirt_txd":0,"bracelets_txd":0,"bracelets":-1,"decals_txd":0,"accessory":0,"torso_txd":0,"tops":1,"ears_txd":0,"ears":-1,"tops_txd":0,"mask":0,"bodyarmor":0,"mask_txd":0,"hats":-1,"leg_txd":2,"glasses":-1,"glasses_txd":0,"undershirt":163,"bag_txd":6,"shoes_txd":0,"decals":0,"torso":0,"hats_txd":0,"shoes":1}'),
                    Female = json.decode(
                        '{"watches":-1,"watches_txd":0,"bag":87,"leg":1,"accessory_txd":0,"bodyarmor_txd":0,"undershirt_txd":0,"bracelets_txd":0,"bracelets":-1,"decals_txd":0,"accessory":0,"torso_txd":0,"tops":0,"ears_txd":0,"ears":-1,"tops_txd":0,"mask":0,"bodyarmor":0,"mask_txd":0,"hats":-1,"leg_txd":2,"glasses":-1,"glasses_txd":0,"undershirt":199,"bag_txd":6,"shoes_txd":2,"decals":0,"torso":0,"hats_txd":0,"shoes":1}'),
                },
            },
        },
    },
    FieldZones = {
        WoolField = {
            Items = { { name = "wool", quantity = 8 } },
            PropHash = GetHashKey("prop_mk_race_chevron_02"),
            Coord = vector3(1887.45, 4630.05, 37.12),
            MinGroundHeight = 36,
            MaxGroundHeight = 41,
            Name = "1. Récolte",
            Blip = true,
        },
    },
    ProcessZones = {
        FabricProcess = {
            ItemsGive = { { name = "wool", quantity = 10 } },
            ItemsGet = { { name = "fabric", quantity = 4 } },
            Delay = 4000,
            Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
            Coord = vector3(712.75, -973.78, 29.42),
            Size = { x = 2.5, y = 2.5, z = 1.5 },
            Color = { r = 252, g = 186, b = 3 },
            Name = "2. Traitement laine",
            HelpText = GetString("press_traitement"),
            Marker = 27,
            Blip = true,
        },
        ClotheProcess = {
            ItemsGive = { { name = "fabric", quantity = 2 } },
            ItemsGet = { { name = "clothe", quantity = 1 } },
            Delay = 4000,
            Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
            Coord = vector3(716.5, -961.82, 29.42),
            Size = { x = 2.5, y = 2.5, z = 1.5 },
            Color = { r = 252, g = 186, b = 3 },
            Name = "3. Traitement du tissu",
            HelpText = GetString("press_traitement"),
            NoInterim = false,
            Marker = 27,
            Blip = true,
        },
        ClothesBoxProcess = {
            ItemsGive = { { name = "clothe", quantity = 9 }, { name = "cardboardbox", quantity = 1 } },
            ItemsGet = { { name = "clothebox", quantity = 1 } },
            Delay = 3000,
            Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
            Coord = vector3(718.73, -973.74, 29.42),
            Size = { x = 2.5, y = 2.5, z = 1.5 },
            Color = { r = 252, g = 186, b = 3 },
            Name = "5. Mise en caisse des vetements",
            HelpText = GetString("press_traitement"),
            NoInterim = false,
            Marker = 27,
            Blip = true,
        },
    },
    SellZones = {
        ClothesSell = {
            Items = { { name = "clothebox", price = 1420 } },
            Coord = vector3(71.67, -1390.47, 28.4),
            Size = { x = 1.5, y = 1.5, z = 1.5 },
            Color = { r = 136, g = 232, b = 9 },
            Name = "6. Vente des produits",
            HelpText = GetString("press_sell"),
            Marker = 27,
            Blip = true,
        },
    },
    BuyZones = {
        BuyBox = {
            Items = { { name = "cardboardbox", price = 20 } },
            Coord = vector3(406.5, -350.02, 45.84),
            Size = { x = 1.5, y = 1.5, z = 1.5 },
            Color = { r = 136, g = 232, b = 9 },
            Name = "4. Achat de cartons",
            HelpText = GetString("press_buy"),
            Marker = 27,
            Blip = true,
        },
    },
    Garages = {
        -- Job garage
        {
            Name = "jobgarage_tailor",
            Coord = vector3(719.12, -989.25, 24.10),
            Size = { x = 2.0, y = 2.0, z = 2.0 },
            Color = { r = 0, g = 122, b = 204 },
            Marker = 36,
            VehicleType = 0,
            IsJobGarage = "tailor",
            JobNeeded = "tailor",
            SpawnPoint = { Coord = vector3(719.12, -989.25, 24.10), Heading = 272.05 },
            Blip = { Name = "Garage entreprise", Sprite = 366, Color = 0 },
        },
        --Players Garage
        {
            Name = "garage_tailor",
            Coord = vector3(691.05, -965.24, 23.61),
            Size = { x = 2.0, y = 2.0, z = 2.0 },
            Color = { r = 0, g = 122, b = 204 },
            Marker = 36,
            VehicleType = 0,
            JobNeeded = "tailor",
            SpawnPoint = { Coord = vector3(691.05, -965.24, 23.61), Heading = 166.25 },
            Blip = { Name = "Garage", Sprite = 366, Color = 0 },
        },
    },
}
