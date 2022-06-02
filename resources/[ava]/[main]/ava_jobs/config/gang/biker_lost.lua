-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config.Jobs.biker_lost = {
    isGang = true,
    LabelName = "The Lost",
    Blip = { Sprite = 556, Color = 31 },
    Blips = { { Name = "Bunker", Coord = vector3(2109.59, 3325.00, 45.36) } },
    Zones = {
        Stock = {
            Coord = vector3(977.11, -104.00, 73.87),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 136, g = 243, b = 216 },
            Name = "Coffre fort",
            InventoryName = "biker_lost_safe",
            HelpText = GetString("press_to_open"),
            Marker = 27,
        },
        Stock = {
            Coord = vector3(1010.16, -116.98, 72.95),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 136, g = 243, b = 216 },
            Name = "Stock",
            InventoryName = "biker_lost_stock",
            HelpText = GetString("press_to_open"),
            Marker = 27,
        },
        Cloakroom = {
            Coord = vector3(986.63, -92.71, 73.87),
            Size = { x = 1.5, y = 1.5, z = 1.0 },
            Color = { r = 136, g = 243, b = 216 },
            Name = "Vestiaire",
            HelpText = GetString("press_to_open"),
            Marker = 27,
        },
    },
    Garages = {
        {
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
            Blip = { Name = "Garage", Sprite = 357, Color = 0, Scale = 0.4 },
        },
    },
    -- Crate = {
    --     Coord = vector3(987.05, -144.41, 73.29),
    --     Name = "Crate",
    --     HelpText = GetString("press_to_talk"),
    --     Action = function()
    --         -- TriggerEvent("ava_lock:dooranim")
    --         -- TriggerEvent("esx_ava_crate_lost:startMission") -- TODO
    --     end,
    -- },
    ProcessMenuZones = {
        -- ammos
        {
            Title = "Fabrication de munitions",
            Process = {
                AsseultProcess = {
                    Name = "Munitions assaut x125",
                    ItemsGive = { { name = "steel", quantity = 1 }, { name = "gunpowder", quantity = 4 } },
                    ItemsGet = { { name = "ammo_rifle", quantity = 125 } },
                    Delay = 2000,
                    Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                },
                ShotgunProcess = {
                    Name = "Munitions pompe x125",
                    ItemsGive = { { name = "steel", quantity = 1 }, { name = "gunpowder", quantity = 4 } },
                    ItemsGet = { { name = "ammo_shotgun", quantity = 125 } },
                    Delay = 2000,
                    Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                },
                SMGProcess = {
                    Name = "Munitions SMG x125",
                    ItemsGive = { { name = "steel", quantity = 1 }, { name = "gunpowder", quantity = 4 } },
                    ItemsGet = { { name = "ammo_smg", quantity = 125 } },
                    Delay = 2000,
                    Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                },
                MGProcess = {
                    Name = "Munitions MG x125",
                    ItemsGive = { { name = "steel", quantity = 1 }, { name = "gunpowder", quantity = 4 } },
                    ItemsGet = { { name = "ammo_mg", quantity = 125 } },
                    Delay = 2000,
                    Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                },
                PistolProcess = {
                    Name = "Munitions pistolet x125",
                    ItemsGive = { { name = "steel", quantity = 1 }, { name = "gunpowder", quantity = 4 } },
                    ItemsGet = { { name = "ammo_pistol", quantity = 125 } },
                    Delay = 2000,
                    Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                },
            },
            MaxProcess = 5,
            Coord = vector3(898.04, -3221.57, -99.23),
            Size = { x = 1.5, y = 1.5, z = 1.5 },
            Color = { r = 72, g = 34, b = 43 },
            Name = "Fabrication de munitions",
            HelpText = GetString("press_traitement"),
            Marker = 27,
            Blip = false,
        },

        -- pistols
        {
            Title = "Fabrication de pistolets",
            Process = {
                PistolProcess = {
                    Name = "Pistolet 9mm",
                    ItemsGive = { { name = "steel", quantity = 25 }, { name = "plastic", quantity = 10 }, { name = "grease", quantity = 5 } },
                    ItemsGet = { { name = "weapon_pistol", quantity = 1 } },
                    Delay = 20000,
                    Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                },
                PistolCal50Process = {
                    Name = "Pistolet Cal50",
                    ItemsGive = { { name = "steel", quantity = 40 }, { name = "plastic", quantity = 70 }, { name = "grease", quantity = 13 } },
                    ItemsGet = { { name = "weapon_pistol50", quantity = 1 } },
                    Delay = 20000,
                    Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                },
                VintagePistolProcess = {
                    Name = "Pistolet Vintage",
                    ItemsGive = { { name = "steel", quantity = 32 }, { name = "plastic", quantity = 10 }, { name = "grease", quantity = 5 } },
                    ItemsGet = { { name = "weapon_vintagepistol", quantity = 1 } },
                    Delay = 20000,
                    Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                },
            },
            MaxProcess = 5,
            Coord = vector3(905.98, -3230.79, -99.27),
            Size = { x = 1.5, y = 1.5, z = 1.5 },
            Color = { r = 72, g = 34, b = 43 },
            Name = "Fabrication de pistolets",
            HelpText = GetString("press_traitement"),
            Marker = 27,
            Blip = false,
        },

        -- smgs
        {
            Title = "Fabrication de pistolets mitrailleurs",
            Process = {
                UZIProcess = {
                    Name = "Uzi",
                    ItemsGive = { { name = "steel", quantity = 60 }, { name = "plastic", quantity = 45 }, { name = "grease", quantity = 10 } },
                    ItemsGet = { { name = "weapon_microsmg", quantity = 1 } },
                    Delay = 20000,
                    Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                },
                MachinePistolProcess = {
                    Name = "Tec-9",
                    ItemsGive = { { name = "steel", quantity = 50 }, { name = "plastic", quantity = 35 }, { name = "grease", quantity = 5 } },
                    ItemsGet = { { name = "weapon_machinepistol", quantity = 1 } },
                    Delay = 20000,
                    Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                },
                MiniSmgProcess = {
                    Name = "Scorpion",
                    ItemsGive = { { name = "steel", quantity = 58 }, { name = "plastic", quantity = 35 }, { name = "grease", quantity = 5 } },
                    ItemsGet = { { name = "weapon_minismg", quantity = 1 } },
                    Delay = 20000,
                    Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                },
            },
            MaxProcess = 5,
            Coord = vector3(896.58, -3217.3, -99.24),
            Size = { x = 1.5, y = 1.5, z = 1.5 },
            Color = { r = 72, g = 34, b = 43 },
            Name = "Fabrication de pistolets mitrailleurs",
            HelpText = GetString("press_traitement"),
            Marker = 27,
            Blip = false,
        },

        -- shotguns
        {
            Title = "Fabrication de fusils à pompe",
            Process = {
                SawnOffProcess = {
                    Name = "Fusil à pompe",
                    ItemsGive = { { name = "steel", quantity = 60 }, { name = "plastic", quantity = 45 }, { name = "grease", quantity = 10 } },
                    ItemsGet = { { name = "weapon_sawnoffshotgun", quantity = 1 } },
                    Delay = 40000,
                    Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                },
                DoubleBarrelProcess = {
                    Name = "Double canon scié",
                    ItemsGive = { { name = "steel", quantity = 55 }, { name = "plastic", quantity = 40 }, { name = "grease", quantity = 10 } },
                    ItemsGet = { { name = "weapon_dbshotgun", quantity = 1 } },
                    Delay = 40000,
                    Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                },
            },
            MaxProcess = 5,
            Coord = vector3(891.73, -3196.8, -99.18),
            Size = { x = 1.5, y = 1.5, z = 1.5 },
            Color = { r = 72, g = 34, b = 43 },
            Name = "Fabrication de fusils à pompe",
            HelpText = GetString("press_traitement"),
            Marker = 27,
            Blip = false,
        },
        -- assault rifles
        {
            Title = "Fabrication de fusils d'assaut",
            Process = {
                GusenbergProcess = {
                    Name = "Gusenberg",
                    ItemsGive = { { name = "steel", quantity = 130 }, { name = "plastic", quantity = 110 }, { name = "grease", quantity = 15 } },
                    ItemsGet = { { name = "weapon_gusenberg", quantity = 1 } },
                    Delay = 40000,
                    Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                },
                ARProcess = {
                    Name = "AK-47",
                    ItemsGive = { { name = "steel", quantity = 125 }, { name = "plastic", quantity = 100 }, { name = "grease", quantity = 15 } },
                    ItemsGet = { { name = "weapon_assaultrifle", quantity = 1 } },
                    Delay = 50000,
                    Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                },
                CompactARProcess = {
                    Name = "AK compact",
                    ItemsGive = { { name = "steel", quantity = 115 }, { name = "plastic", quantity = 85 }, { name = "grease", quantity = 10 } },
                    ItemsGet = { { name = "weapon_compactrifle", quantity = 1 } },
                    Delay = 35000,
                    Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
                },
            },
            MaxProcess = 5,
            Coord = vector3(884.92, -3199.9, -99.18),
            Size = { x = 1.5, y = 1.5, z = 1.5 },
            Color = { r = 72, g = 34, b = 43 },
            Name = "Fabrication de fusils d'assaut",
            HelpText = GetString("press_traitement"),
            Marker = 27,
            Blip = false,
        },
    },
    BuyZones = {
        BuyMaterials = {
            Items = {
                { name = "steel", price = 800, isDirtyMoney = true },
                { name = "plastic", price = 350, isDirtyMoney = true },
                { name = "gunpowder", price = 100, isDirtyMoney = true },
                { name = "grease", price = 60, isDirtyMoney = true },
            },
            Coord = vector3(612.6, -3074.04, 5.09),
            Size = { x = 1.5, y = 1.5, z = 1.5 },
            Color = { r = 72, g = 34, b = 43 },
            Name = "Achat de matériaux",
            HelpText = GetString("press_buy"),
            Marker = 27,
            Blip = true,
        },
    },
}
