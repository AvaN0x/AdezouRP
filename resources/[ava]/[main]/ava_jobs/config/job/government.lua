-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config.Jobs.government = {
    LabelName = "Gouvernement",
    ServiceCounter = true,
    PhoneNumber = "555-1508",
    Blip = { Name = "Gouvernement", Coord = vector3(-545.17, -204.17, 37.24), Sprite = 419, Colour = 0 },
    Zones = {
        ManagerMenu = {
            Coord = vector3(-536.25, -189.45, 46.76),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 207, g = 169, b = 47 },
            Name = "Actions patron",
            HelpText = GetString("press_to_open"),
            Marker = 27,
            MinimumGrade = "governor",
        },
        MainStock = {
            Coord = vector3(-536.75, -180.95, 37.24),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 207, g = 169, b = 47 },
            Name = "Stockage",
            InventoryName = "job_government_stock",
            HelpText = GetString("press_to_open"),
            Marker = 27,
        },
        Cloakroom = {
            Coord = vector3(-527.59, -186.21, 46.76),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 207, g = 169, b = 47 },
            Blip = true,
            Name = "Vestiaire",
            HelpText = GetString("press_to_open"),
            Marker = 27,
            Outfits = {
                {
                    Label = "Agent de sécurité",
                    -- TODO remake Female outfit
                    Female = json.decode(
                        "{\"decals\":0,\"torso\":23,\"leg\":133,\"hats\":-1,\"mask\":0,\"glasses\":-1,\"accessory\":0,\"shoes\":27,\"bracelets_txd\":0,\"watches_txd\":0,\"undershirt\":37,\"tops\":92,\"accessory_txd\":0,\"bag_txd\":0,\"shoes_txd\":0,\"ears_txd\":0,\"bodyarmor_txd\":0,\"ears\":-1,\"glasses_txd\":0,\"decals_txd\":0,\"undershirt_txd\":0,\"bodyarmor\":0,\"leg_txd\":23,\"bag\":0,\"tops_txd\":2,\"mask_txd\":0,\"hats_txd\":0,\"torso_txd\":0,\"bracelets\":-1,\"watches\":-1}"),
                    Male = json.decode(
                        "{\"decals\":0,\"torso\":22,\"leg\":10,\"hats\":-1,\"mask\":0,\"glasses\":-1,\"accessory\":0,\"shoes\":10,\"bracelets_txd\":0,\"watches_txd\":0,\"undershirt\":32,\"tops\":294,\"accessory_txd\":0,\"bag_txd\":0,\"shoes_txd\":0,\"ears_txd\":0,\"bodyarmor_txd\":0,\"ears\":-1,\"glasses_txd\":0,\"decals_txd\":0,\"undershirt_txd\":0,\"bodyarmor\":0,\"leg_txd\":0,\"bag\":0,\"tops_txd\":0,\"mask_txd\":0,\"hats_txd\":0,\"torso_txd\":0,\"bracelets\":-1,\"watches\":-1}"),
                },

            },
        },
    },
    Garages = {
        -- Job garages
        {
            Name = "jobgarage_government",
            Coord = vector3(-580.48, -171.22, 37.86),
            Size = { x = 2.0, y = 2.0, z = 2.0 },
            Color = { r = 0, g = 122, b = 204 },
            Marker = 36,
            VehicleType = 0,
            IsJobGarage = "government",
            JobNeeded = "government",
            SpawnPoint = { Coord = vector3(-580.48, -171.22, 37.86), Heading = 298.75 },
            Blip = { Name = "Garage entreprise", Sprite = 419, Color = 0 },
        },
        --Player garages
        {
            Name = "garage_government",
            Coord = vector3(-561.64, -172.14, 38.18),
            Size = { x = 2.0, y = 2.0, z = 2.0 },
            Color = { r = 0, g = 122, b = 204 },
            Marker = 36,
            VehicleType = 0,
            JobNeeded = "government",
            SpawnPoint = { Coord = vector3(-561.64, -172.14, 38.18), Heading = 31.07 },
            Blip = { Name = "Garage", Sprite = 419, Color = 0 },
        },
    }
}
