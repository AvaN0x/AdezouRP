fx_version "cerulean"
game "gta5"

version "1.0"
author "github.com/AvaN0x"
description "Fuel manager"
repository "https://github.com/AvaN0x/AdezouRP"

lua54 "yes"
use_experimental_fxv2_oal "yes"

files { "languages/**.json" }

shared_scripts { "@ava_lib/import.lua", "@ava_lib/shared/language.lua", "config.lua", "shared/utils.lua" }

client_scripts { "client/main.lua" }

server_scripts { "server/main.lua" }

dependencies { "ava_core" }
