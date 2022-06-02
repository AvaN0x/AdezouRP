-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config.Jobs.bahama = { --todo when anyone want
    Disabled = true,
    LabelName = "Bahama",
    Blip = { Sprite = 93, Colour = 0 },
    Zones = {
        ManagerMenu = {
            Coord = vector3(-1390.48, -600.57, 29.34),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 136, g = 243, b = 216 },
            Name = "Actions patron",
            HelpText = GetString("press_to_open"),
            Marker = 27,
        },
        -- TODO stock
        Cloakroom = {
            Coord = vector3(-1386.81, -608.41, 29.34),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 136, g = 243, b = 216 },
            Name = "Vestiaire",
            HelpText = GetString("press_to_open"),
            Marker = 27,
            Blip = true,
            Outfits = {
                {
                    Label = "Tenue barman",
                    Male = json.decode(
                        '{"undershirt":24,"bodyarmor":0,"decals":0,"ears":-1,"leg_txd":0,"bracelets_txd":0,"mask_txd":0,"bag_txd":0,"bodyarmor_txd":0,"mask":0,"glasses_txd":0,"hats_txd":0,"accessory_txd":0,"shoes_txd":6,"ears_txd":0,"accessory":0,"tops":60,"decals_txd":0,"shoes":77,"bracelets":-1,"torso_txd":0,"torso":0,"bag":0,"tops_txd":2,"watches_txd":0,"undershirt_txd":0,"leg":4,"watches":-1,"hats":-1,"glasses":-1}'),
                    Female = json.decode(
                        '{"undershirt":20,"bodyarmor":0,"decals":0,"ears":-1,"leg_txd":0,"bracelets_txd":0,"mask_txd":0,"bag_txd":0,"bodyarmor_txd":0,"mask":0,"glasses_txd":0,"hats_txd":0,"accessory_txd":0,"shoes_txd":7,"ears_txd":0,"accessory":0,"tops":6,"decals_txd":0,"shoes":81,"bracelets":-1,"torso_txd":0,"torso":1,"bag":0,"tops_txd":4,"watches_txd":0,"undershirt_txd":0,"leg":44,"watches":-1,"hats":-1,"glasses":-1}'),
                },
                {
                    Label = "Tenue Videur",
                    Male = json.decode(
                        '{"undershirt":23,"bodyarmor":0,"decals":0,"ears":-1,"leg_txd":0,"bracelets_txd":0,"mask_txd":0,"bag_txd":0,"bodyarmor_txd":0,"mask":121,"glasses_txd":0,"hats_txd":0,"accessory_txd":0,"shoes_txd":6,"ears_txd":0,"accessory":0,"tops":23,"decals_txd":0,"shoes":77,"bracelets":-1,"torso_txd":0,"torso":1,"bag":0,"tops_txd":0,"watches_txd":0,"undershirt_txd":1,"leg":35,"watches":-1,"hats":-1,"glasses":-1}'),
                    Female = json.decode(
                        '{"undershirt":67,"bodyarmor":0,"decals":0,"ears":-1,"leg_txd":0,"bracelets_txd":0,"mask_txd":0,"bag_txd":0,"bodyarmor_txd":0,"mask":121,"glasses_txd":0,"hats_txd":0,"accessory_txd":0,"shoes_txd":3,"ears_txd":0,"accessory":0,"tops":90,"decals_txd":0,"shoes":81,"bracelets":-1,"torso_txd":0,"torso":3,"bag":0,"tops_txd":0,"watches_txd":0,"undershirt_txd":3,"leg":50,"watches":-1,"hats":-1,"glasses":-1}'),
                },
            },
        },
        CarGarage = { -- TODO properly add, this do not work
            Name = "Garage véhicule",
            HelpText = GetString("spawn_veh"),
            Coord = vector3(-1419.26, -596.3, 30.45),
            Size = { x = 2.0, y = 2.0, z = 2.0 },
            Color = { r = 0, g = 255, b = 0 },
            Marker = 36,
            Type = "car",
            SpawnPoint = { Coord = vector3(-1419.26, -596.3, 30.45), Heading = 299.0 },
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
            Color = { r = 136, g = 232, b = 9 },
            Name = "Achat de boissons",
            HelpText = GetString("press_buy"),
            Marker = 27,
            Blip = true,
        },
    },
}
