fx_version "cerulean"
games { "gta5" }

version "1.0.0"
author "github.com/AvaN0x"
description "Garages and vehicles"
repository "https://github.com/AvaN0x/AdezouRP"

lua54 "yes"
use_experimental_fxv2_oal "yes"

files {
    "languages/**.json"
}

shared_scripts {
    "@ava_lib/shared/language.lua"
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

    "config.lua",
    "client/main.lua",
    "client/garage.lua",
    "client/insurance.lua",
    "client/pound.lua",
    "client/keys.lua",
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "config.lua",
    "server/main.lua",
    "server/pound.lua",
    "server/insurance.lua",
    "server/keys.lua",
}

dependencies {
    "ava_core",
    "RageUI"
}
