fx_version "cerulean"
games { "gta5" }

version "1.0.0"
author "github.com/AvaN0x"
description "Handler for Bills"
repository "https://github.com/AvaN0x/AdezouRP"

lua54 "yes"
use_experimental_fxv2_oal "yes"

server_only "yes"

files { "languages/**.json" }

server_scripts { "@oxmysql/lib/MySQL.lua", "server/main.lua" }

shared_scripts { "@ava_lib/shared/language.lua" }

dependencies { "ava_core", "oxmysql" }
