fx_version "cerulean"
game "gta5"

version "1.0"
author "github.com/AvaN0x"
description "Personal menu"
repository "https://github.com/AvaN0x/AdezouRP"

lua54 "yes"

files {"languages/**.json"}

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
    "client/vehicle_management.lua",
    "client/speedlimiter.lua",

    "client/admin/main.lua",
    "client/admin/playerlist.lua",
    "client/admin/vehicles.lua",
}

server_scripts {"server/main.lua", "server/admin/main.lua", "server/admin/commands.lua"}

shared_scripts {"@ava_core/shared/import.lua", "@ava_core/shared/language.lua"}

dependencies {"ava_core"}

