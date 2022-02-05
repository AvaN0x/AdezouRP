fx_version "cerulean"
games {"gta5"}

version "1.0.0"
author "github.com/AvaN0x"
description "Handler for Bills"
repository "https://github.com/AvaN0x/AdezouRP"

lua54 "yes"

server_only "yes"

server_scripts {"@oxmysql/lib/MySQL.lua", "server/main.lua"}

dependencies {"ava_core", "oxmysql"}
