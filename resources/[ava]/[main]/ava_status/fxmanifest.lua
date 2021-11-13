fx_version "cerulean"
game "gta5"

version "1.0"
author "github.com/AvaN0x"
description "Status handler"
repository "https://github.com/AvaN0x/AdezouRP"

lua54 "yes"

files {"languages/**.json", "status.json"}

client_scripts {"config.lua", "client/classes/status.lua", "client/main.lua"}

server_scripts {"config.lua", "server/main.lua"}

shared_scripts {"@ava_core/shared/language.lua"}

dependencies {"ava_core"}

