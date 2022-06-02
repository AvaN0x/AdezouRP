-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config.Jobs.weed = {
    isIllegal = true,
    KeyName = "keyweed",
    FieldZones = {
        CannaField = {
            Items = { { name = "weed", quantity = 5 } },
            PropHash = GetHashKey("bkr_prop_weed_lrg_01b"),
            Coord = vector3(173.44, -1004.21, -99.98),
            MinGroundHeight = -100,
            MaxGroundHeight = 98,
            Radius = 3,
        },
    },
    ProcessZones = {
        BagProcess = {
            ItemsGive = { { name = "weed", quantity = 5 }, { name = "dopebag", quantity = 1 } },
            ItemsGet = { { name = "bagweed", quantity = 1 } },
            Delay = 8000,
            Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
            Coord = vector3(859.08, 2877.4, 57.98),
            NeedKey = true,
        },
    },
}
