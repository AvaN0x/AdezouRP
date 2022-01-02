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

-- edit 'npwd' in fxmanifest.lua, any value mean true, remove if false
AVAConfig.NPWD = false

-- edit 'max_characters' in fxmanifest.lua, value must be > 0
AVAConfig.MaxChars = 5

-- edit 'max_jobs_count' in fxmanifest.lua, value must be > 0
AVAConfig.MaxJobsCount = 1
-- edit 'max_gangs_count' in fxmanifest.lua, value must be > 0
AVAConfig.MaxGangsCount = 1

-- time between each save all players (in minutes)
-- remove to disable auto saves
AVAConfig.SaveTimeout = 10

-- time between each paychecks (in minutes)
-- remove to disable auto saves
AVAConfig.PayCheckTimeout = 48

AVAConfig.InventoryMaxWeight = 75000

AVAConfig.DefaultPlayerData = {
    position = vector3(-1042.89, -2746.54, 20.37),
    inventory = {{name = "cash", quantity = 2000}},
    accounts = {{name = "bank", balance = 4000}},

    metadata = {health = 200},
}

-- List of all accounts that exists
AVAConfig.Licenses = {
    trafficLaws = {label = "Code de la route"},
    driver = {label = "Permis", hasPoints = true, defaultPoints = 12, maxPoints = 12},

    weapon = {label = "Permis de Port d'Armes"},
}

-- List of all accounts that exists
AVAConfig.Accounts = {bank = {label = "Banque"}}

-- List of all items and their datas
AVAConfig.Items = json.decode(LoadResourceFile(GetCurrentResourceName(), "items.json") or "{}") or {}

-- List of all jobs
AVAConfig.Jobs = json.decode(LoadResourceFile(GetCurrentResourceName(), "jobs.json") or "{}") or {}

-- List of all weapons
local weaponsJSON = json.decode(LoadResourceFile(GetCurrentResourceName(), "weapons.json") or "{}") or {}
AVAConfig.Weapons = weaponsJSON.weapons or {}
AVAConfig.WeaponsTypes = weaponsJSON.weaponsTypes or {}
weaponsJSON = nil
