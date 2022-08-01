fx_version "cerulean"
game "gta5"

version "1.0"
author "github.com/AvaN0x"
description "Items"
repository "https://github.com/AvaN0x/AdezouRP"

lua54 "yes"
use_experimental_fxv2_oalntal_fxv2_oal "yes"

files { "languages/**.json" }

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
    "client/**/*_cl.lua",
}

server_scripts { "config.lua", "server/main.lua", "server/**/*_sv.lua" }

shared_scripts { "@ava_lib/shared/language.lua" }

dependencies { "ava_core" }
