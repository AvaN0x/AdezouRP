-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config.Jobs.coke = {
    isIllegal = true,
    KeyName = "keycoke",
    FieldZones = {
        CokeField = {
            Items = { { name = "cokeleaf", quantity = 5 } },
            PropHash = GetHashKey("prop_plant_fern_02a"),
            Coord = vector3(-294.48, 2524.97, 74.62),
            MinGroundHeight = 74,
            MaxGroundHeight = 75,
            Radius = 4,
        },
    },
    ProcessZones = {
        CokeProcess = {
            ItemsGive = { { name = "cokeleaf", quantity = 2 } },
            ItemsGet = { { name = "coke", quantity = 2 } },
            Delay = 8000,
            Scenario = "world_human_clipboard", -- https://pastebin.com/6mrYTdQv
            Coord = vector3(1092.83, -3196.70, -39.97),
            NeedKey = true,
        },
        BagProcess = {
            ItemsGive = { { name = "coke", quantity = 5 }, { name = "dopebag", quantity = 1 } },
            ItemsGet = { { name = "bagcoke", quantity = 1 } },
            Delay = 10000,
            Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
            Coord = vector3(1101.83, -3193.73, -39.97),
            NeedKey = true,
        },
    },
}
