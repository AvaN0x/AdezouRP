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
    inventory = {
        {name = "cash", quantity = 4000},
    }
}

AVAConfig.Items = {
    cash = {label = "Argent", weight = 1, limit = nil, noIcon = true},
    -- inventory = {}
}