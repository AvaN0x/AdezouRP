fx_version "cerulean"
games {"gta5"}

version "1.0.0"
author "github.com/AvaN0x"
description "Heists"
repository "https://github.com/AvaN0x/AdezouRP"

lua54 "yes"

files {"languages/**.json"}

shared_scripts {"@ava_core/shared/language.lua"}

client_scripts {"config.lua", "**/*_cfg.lua", "client/main.lua", "**/*_cl.lua"}

server_scripts {"config.lua", "**/*_cfg.lua", "server/main.lua", "**/*_sv.lua"}
dependencies {"ava_core", "ava_jobs"}
