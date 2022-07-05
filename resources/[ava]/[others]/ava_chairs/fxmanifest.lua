fx_version "cerulean"
games { "gta5" }

version "1.0.0"
author "github.com/AvaN0x"
description "Chairs and beds"
repository "https://github.com/AvaN0x/AdezouRP"

lua54 "yes"
use_fxv2_oal "yes"

files { "languages/**.json" }

shared_scripts { "@ava_core/shared/language.lua" }

client_scripts { "config.lua", "client/main.lua" }

server_scripts { "config.lua", "server/main.lua" }

dependencies { "ava_core" }
