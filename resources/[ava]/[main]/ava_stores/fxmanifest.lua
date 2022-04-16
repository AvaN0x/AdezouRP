fx_version "cerulean"
games { "gta5" }

version "1.0.0"
author "github.com/AvaN0x"
description "Stores handler"
repository "https://github.com/AvaN0x/AdezouRP"

lua54 "yes"

files {
    "languages/**.json",
    "tattooList.json",
    "vehicleshop.json"
}

shared_scripts {
    "@ava_core/shared/language.lua",
    "config.lua",
    "shared/vehicleshop.lua",
    "shared/lscustoms.lua",
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
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "server/main.lua",
    "server/player_outfits.lua",
    "server/vehicleshop.lua",
    "server/lscustoms.lua",
    "server/vehicle_rental.lua",
}

dependencies {
    "ava_core",
    "RageUI"
}
