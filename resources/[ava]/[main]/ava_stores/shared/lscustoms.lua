-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------

Config.LSCustoms = {
    MinimumBodyHealth = 950.0,
    MinimumEngineHealth = 950.0,

    Menu = {
        { label = GetString("lscustoms_brakes"), mod = "modBrakes" },
        { label = GetString("lscustoms_spoilers"), mod = "modSpoilers" },
        {
            label = GetString("lscustoms_wheels"),
            menu = {
                { label = GetString("lscustoms_wheelsType"), mod = "wheelsType" },
                { label = GetString("lscustoms_wheelColor"), mod = "wheelsColor" },
            }
        },

    },
    Mods = {
        modSpoilers = {
            -- label = "",
            priceMultiplier = 0.01,
            -- staticPrice = 10000,

            -- Used to apply the custom
            type = "mod",
            mod = 0
        },
        wheelsColor = {
            -- label = "",
            priceMultiplier = 0.01,
            -- staticPrice = 10000,

            type = "color",
            target = "wheels"
        },
        wheelsType = {
            -- label = "",
            priceMultiplier = 0.01,
            -- staticPrice = 10000,
            type = "wheels",
            -- Somehow get type and select the correct wheel
        }
    }
}
