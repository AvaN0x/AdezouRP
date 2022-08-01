fx_version "cerulean"
games { "gta5" }

version "1.0.0"
author "github.com/AvaN0x"
description "Interact with entities or points"
repository "https://github.com/AvaN0x/AdezouRP"

lua54 "yes"
use_experimental_fxv2_oalntal_fxv2_oal "yes"

files { "languages/**.json" }

shared_scripts { "@ava_lib/import.lua", "@ava_lib/shared/language.lua" }

client_scripts { "config.lua", "client/main.lua" }
client_script "client/test.lua"

server_scripts { "config.lua", "server/main.lua" }

dependencies { "ava_core" }
