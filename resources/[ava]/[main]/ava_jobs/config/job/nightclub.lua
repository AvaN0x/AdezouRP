-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config.Jobs.nightclub = { --todo when anyone want
    LabelName = "Galaxy",
    Blip = { Coord = vector3(-676.83, -2458.79, 12.96), Sprite = 614, Color = 7 },
    Zones = {
        ManagerMenu = {
            Coord = vector3(-1583.19, -3014.04, -76.99),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 156, g = 110, b = 175 },
            Name = "Actions patron",
            HelpText = GetString("press_to_open"),
            Marker = 27,
        },
        -- TODO stock
        Cloakroom = {
            Coord = vector3(-1619.66, -3020.41, -76.19),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 156, g = 110, b = 175 },
            Name = "Vestiaire",
            HelpText = GetString("press_to_open"),
            Marker = 27,
            Outfits = {
                {
                    Label = "Tenue videur",
                    Male = json.decode(
                        '{"hats":-1,"glasses_txd":0,"bodyarmor_txd":0,"hats_txd":0,"undershirt":75,"bracelets":-1,"watches_txd":0,"watches":-1,"bag_txd":0,"bracelets_txd":0,"leg":10,"undershirt_txd":3,"accessory_txd":0,"accessory":0,"bag":0,"leg_txd":0,"shoes":3,"decals":0,"torso_txd":0,"decals_txd":0,"tops":29,"tops_txd":1,"torso":4,"mask":121,"bodyarmor":0,"glasses":13,"ears":-1,"shoes_txd":4,"mask_txd":0,"ears_txd":0}'),
                    Female = json.decode(
                        '{"hats":-1,"glasses_txd":0,"bodyarmor_txd":0,"hats_txd":0,"undershirt":67,"bracelets":-1,"watches_txd":0,"watches":-1,"bag_txd":0,"bracelets_txd":0,"leg":6,"undershirt_txd":3,"accessory_txd":0,"accessory":0,"bag":0,"leg_txd":1,"shoes":3,"decals":0,"torso_txd":0,"decals_txd":0,"tops":340,"tops_txd":0,"torso":3,"mask":121,"bodyarmor":0,"glasses":-1,"ears":-1,"shoes_txd":0,"mask_txd":0,"ears_txd":0}'),
                },
            },
        },
        CarGarage = { -- TODO properly add, this do not work
            Name = "Garage véhicule",
            HelpText = GetString("spawn_veh"),
            Coord = vector3(-685.96, -2481.24, 13.83),
            Size = { x = 2.0, y = 2.0, z = 2.0 },
            Color = { r = 156, g = 110, b = 175 },
            Marker = 36,
            Type = "car",
            SpawnPoint = { Coord = vector3(-685.96, -2481.24, 13.83), Heading = 299.0 },
            Blip = true,
        },
    },
    BuyZones = {
        BuyBox = {
            Items = {
                { name = "ecola", price = 15 },
                { name = "coffee", price = 13 },
                { name = "pisswasser", price = 20 },
            },
            Coord = vector3(376.81, -362.84, 45.85),
            Size = { x = 1.5, y = 1.5, z = 1.5 },
            Color = { r = 156, g = 110, b = 175 },
            Name = "Achat de boissons",
            HelpText = GetString("press_buy"),
            Marker = 27,
            Blip = true,
        },
    },
}
