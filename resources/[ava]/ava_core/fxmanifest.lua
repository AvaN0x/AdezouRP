fx_version "cerulean"
game "gta5"

version "1.0"
author "github.com/AvaN0x"
description "Core script"
repository "https://github.com/AvaN0x/AdezouRP"

lua54 "yes"
use_fxv2_oal "yes"

files { "shared/import.lua", "languages/**.json" }

shared_scripts {
    "@ava_lib/import.lua",
    "@ava_lib/shared/language.lua",
    "chat/chat.lua"
}

client_scripts {
    "@RageUI/src/RageUI.lua",
    "@RageUI/src/Menu.lua",
    "@RageUI/src/MenuController.lua",
    "@RageUI/src/components/Audio.lua",
    "@RageUI/src/components/Graphics.lua",
    "@RageUI/src/components/Keys.lua",
    "@RageUI/src/components/Util.lua",
    "@RageUI/src/components/Visual.lua",
    "@RageUI/src/elements/ItemsBadge.lua",
    "@RageUI/src/elements/ItemsColour.lua",
    "@RageUI/src/elements/PanelColour.lua",
    "@RageUI/src/items/Items.lua",
    "@RageUI/src/items/Panels.lua",

    "client/config.lua",
    "client/main.lua",
    "client/callbacks.lua",
    "shared/utils.lua",
    "client/utils.lua",
    "client/player.lua",
    "client/vehicles.lua",
    "client/deaths.lua",
    "client/weapons.lua",
    "client/createchar.lua",
    "client/commands.lua",
    "client/inventories.lua",
    "client/pickup.lua",
    "client/tweaks.lua",
    "client/licenses.lua",
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",

    "server/config.lua",
    "server/main.lua",
    "server/callbacks.lua",
    "server/classes/inventory.lua",
    "server/classes/player.lua",
    "server/classes/job_accounts.lua",
    "server/jobs.lua",
    "shared/utils.lua",
    "server/utils.lua",
    "server/commands.lua",
    "server/routing_buckets.lua",
    "server/players.lua",
    "server/inventories.lua",
    "server/pickup.lua",
    "server/licenses.lua",
}

dependencies { "spawnmanager", "oxmysql", "RageUI", "ava_base64toruntime", "ava_mp_peds" }

file 'chat/style.css'
chat_theme 'ava_chat' {
    styleSheet = 'chat/style.css',
}


ava_config "npwd" "yes"

ava_config "max_characters" "5"

ava_config "max_jobs_count" "2"
ava_config "max_gangs_count" "2"

ava_config "discord_config" {
    GuildId = "743525702157992018",
    Whitelist = {
        -- "743525702531547234", -- superadmin
        -- "835276464865542195", -- admin
        -- "743525702531547231", -- mod
        -- "743525702531547230" -- helper
        "743525702531547228", -- citizen
    },
    Ace = {
        { ace = "superadmin", role = "743525702531547234" }, -- superadmin
        { ace = "admin", role = "835276464865542195" }, -- admin
        { ace = "mod", role = "743525702531547231" }, -- mod
        -- { ace = "helper", role = "743525702531547230" } -- helper
    },
}
