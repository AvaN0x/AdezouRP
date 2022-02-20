fx_version "cerulean"
games { "gta5" }

version "1.0.0"
author "github.com/AvaN0x"
description "Most of Jobs"
repository "https://github.com/AvaN0x/AdezouRP"

lua54 "yes"

files { "languages/**.json" }

shared_scripts { "@ava_core/shared/language.lua" }

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
    "client/jobmenu_cl.lua",
    "client/bank_managment_cl.lua",
    "client/manager_menu_cl.lua",
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",

    "config.lua",
    "server/main.lua",
    "server/jobmenu_sv.lua",
    "server/bank_managment_sv.lua",
    "server/manager_menu_sv.lua",
}

dependencies { "RageUI", "ava_core", "ava_mp_peds", "ava_garages" }
