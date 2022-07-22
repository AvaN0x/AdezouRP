fx_version "cerulean"
games { "gta5" }

version "1.0.0"
author "github.com/AvaN0x"
description "Stores handler"
repository "https://github.com/AvaN0x/AdezouRP"

lua54 "yes"
use_fxv2_oal "yes"

files {
    "languages/**.json",
    "tattooList.json",
    "vehicleshop.json"
}

shared_scripts {
    "@ava_lib/shared/language.lua",
    "config.lua",
    "shared/vehicleshop.lua",
    "shared/lscustoms.lua",
    "shared/prop_stores.lua",
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

    "client/main.lua",
    "client/clothes_stores.lua",
    "client/player_outfits.lua",
    "client/vehicleshop.lua",
    "client/lscustoms.lua",
    "client/vehicle_rental.lua",
    "client/prop_stores.lua",
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "server/main.lua",
    "server/player_outfits.lua",
    "server/vehicleshop.lua",
    "server/lscustoms.lua",
    "server/vehicle_rental.lua",
    "server/prop_stores.lua",
}

dependencies {
    "ava_core",
    "RageUI"
}
