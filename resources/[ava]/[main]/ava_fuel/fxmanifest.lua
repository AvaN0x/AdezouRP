fx_version "cerulean"
game "gta5"

version "1.0"
author "github.com/AvaN0x"
description "Fuel manager"
repository "https://github.com/AvaN0x/AdezouRP"

lua54 "yes"

files { "languages/**.json" }

shared_scripts { "@ava_core/shared/language.lua", "config.lua" }

client_scripts { "client/main.lua" }

server_scripts { "server/main.lua" }

dependencies { "ava_core" }