fx_version "cerulean"
game "gta5"

version "1.0"
author "github.com/AvaN0x"
description "Death script manager"
repository "https://github.com/AvaN0x/AdezouRP"

lua54 "yes"
use_experimental_fxv2_oal "yes"

files { "languages/**.json" }

client_scripts { "config.lua", "client/main.lua", "client/items.lua" }

server_scripts { "config.lua", "server/main.lua", "server/items.lua" }

shared_scripts { "@ava_lib/shared/language.lua" }

dependencies { "ava_core" }
