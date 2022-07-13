-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config.Jobs.exta = {
    isIllegal = true,
    KeyName = "keyexta",
    FieldZones = {
        MdmaField = {
            Items = { { name = "extamdma", quantity = 10 } },
            PropHash = `prop_drug_package_02`,
            Coord = vector3(-1063.23, -1113.14, 2.16),
            MinGroundHeight = 2,
            MaxGroundHeight = 2,
            Radius = 3,
        },
        AmphetField = {
            Items = { { name = "extaamphetamine", quantity = 10 } },
            PropHash = `ex_office_swag_pills2`,
            Coord = vector3(177.98, 306.6, 105.37),
            MinGroundHeightght = 105,
            MaxGroundHeight = 106,
            Radius = 3,
        },
    },
    ProcessZones = {
        ExtaProcess = {
            ItemsGive = { { name = "extamdma", quantity = 2 }, { name = "extaamphetamine", quantity = 2 } },
            ItemsGet = { { name = "extazyp", quantity = 10 } },
            Delay = 10000,
            Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
            Coord = vector3(1983.23, 3026.61, 47.69),
            NeedKey = true,
        },
        BagProcess = {
            ItemsGive = { { name = "extazyp", quantity = 5 }, { name = "dopebag", quantity = 1 } },
            ItemsGet = { { name = "bagexta", quantity = 1 } },
            Delay = 10000,
            Scenario = "WORLD_HUMAN_CLIPBOARD", -- https://pastebin.com/6mrYTdQv
            Coord = vector3(1984.5, 3054.88, 47.22),
            NeedKey = true,
        },
    },
}
