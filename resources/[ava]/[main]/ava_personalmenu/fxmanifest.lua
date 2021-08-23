fx_version "cerulean"
game "gta5"

version "1.0"
author "github.com/AvaN0x"
description "Bank system"
repository "https://github.com/AvaN0x/AdezouRP"

lua54 "yes"

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
    "client/admin/main.lua",
}

server_scripts {"server/main.lua", "server/admin/main.lua"}

shared_scripts {"@ava_core/shared/import.lua"}

dependencies {"ava_core"}

