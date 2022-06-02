-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config.Jobs.meth = {
    isIllegal = true,
    KeyName = "keymeth",
    FieldZones = {
        MethyField = {
            Items = { { name = "methylamine", quantity = 15 } },
            PropHash = GetHashKey("prop_barrel_exp_01c"),
            Coord = vector3(1595.49, -1702.09, 88.12),
            MinGroundHeight = 88,
            MaxGroundHeight = 89,
            Radius = 5,
        },
        PseudoField = {
            Items = { { name = "methpseudophedrine", quantity = 15 } },
            PropHash = GetHashKey("prop_barrel_01a"),
            Coord = vector3(584.86, -491.21, 24.75),
            MinGroundHeight = 23,
            MaxGroundHeight = 24,
            Radius = 5,
        },
        MethaField = {
            Items = { { name = "methacide", quantity = 15 } },
            PropHash = GetHashKey("prop_barrel_exp_01c"),
            Coord = vector3(1112.49, -2299.49, 30.5),
            MinGroundHeight = 30,
            MaxGroundHeight = 31,
            Radius = 4,
        },
    },
    ProcessZones = {
        BagProcess = {
            ItemsGive = {
                { name = "methylamine", quantity = 5 },
                { name = "methpseudophedrine", quantity = 5 },
                { name = "methacide", quantity = 5 },
                { name = "dopebag", quantity = 1 },
            },
            ItemsGet = { { name = "methamphetamine", quantity = 1 } },
            Delay = 10000,
            Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
            Coord = vector3(1010.84, -3196.70, -38.99),
            NeedKey = true,
        },
    },
}
