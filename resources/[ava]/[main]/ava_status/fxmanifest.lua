fx_version "cerulean"
game "gta5"

version "1.0"
author "github.com/AvaN0x"
description "Status handler"
repository "https://github.com/AvaN0x/AdezouRP"

lua54 "yes"
use_fxv2_oal "yes"

files { "languages/**.json", "status.json" }

client_scripts { "config.lua", "client/classes/status.lua", "client/main.lua", "client/animations.lua",
    "client/handlers.lua" }

server_scripts { "config.lua", "server/main.lua" }

shared_scripts { "@ava_lib/shared/language.lua" }

dependencies { "ava_core" }
