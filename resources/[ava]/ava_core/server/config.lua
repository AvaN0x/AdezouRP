-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVAConfig = {}

AVAConfig.DiscordWhitelist = GetConvar("ava_core_discord_whitelist", "false") ~= "false"
-- edit 'discord_config' in fxmanifest.lua
AVAConfig.Discord = {}

-- edit 'debug_prints' in fxmanifest.lua, any value mean true, remove if false
AVAConfig.Debug = false

-- edit 'max_characters' in fxmanifest.lua, value must be > 0
AVAConfig.MaxChars = 5

AVAConfig.InventoryMaxWeight = 75000

AVAConfig.DefaultPlayerData = {
    position = vector3(-1042.89, -2746.54, 20.37),
    inventory = {{name = "cash", quantity = 4000}},
}

AVAConfig.Items = {
    cash = {
        label = "Argent",
        type = "money",
        description = "Argent liquide",
        weight = 1,
        alwaysDisplayed = true,
    },
    dirtycash = {label = "Argent sale", type = "money", weight = 1, noIcon = true},

    bread = {label = "Pain", type = "food", weight = 100, limit = nil},
    egochaser = {
        label = "EgoChaser",
        type = "food",
        description = "La barre énergétique qui prend soin de vous.",
        weight = 100,
        noIcon = true,
    },
    meteorite = {
        label = "Meteorite",
        type = "food",
        description = "Un cœur fondant enrobé de chocolat noir.",
        weight = 100,
        noIcon = true,
    },

    waterbottle = {label = "Bouteille d'eau", type = "liquid", weight = 100, limit = nil},
    ecola = {
        label = "eCola",
        type = "liquid",
        description = "Un soda délicieusement infect.",
        weight = 100,
        noIcon = true,
    },
    pisswasser = {
        label = "Pisswasser",
        type = "liquid",
        description = "Bière de baston bavaroise.",
        weight = 100,
        noIcon = true,
    },

    lockpick = {label = "Lockpick", weight = 100, limit = nil, closeInv = true, noIcon = true},

    grape = {label = "Raisin", weight = 10, limit = 180, noIcon = true},
}
