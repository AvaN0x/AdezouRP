fx_version "cerulean"
games { "gta5" }

version "1.0.0"
author "github.com/AvaN0x"
description "Heists"
repository "https://github.com/AvaN0x/AdezouRP"

lua54 "yes"
use_experimental_fxv2_oalntal_fxv2_oal "yes"

files { "languages/**.json" }

shared_scripts { "@ava_lib/shared/language.lua" }

client_scripts { "config.lua", "**/*_cfg.lua", "client/main.lua", "**/*_cl.lua" }

server_scripts { "config.lua", "**/*_cfg.lua", "server/main.lua", "**/*_sv.lua" }
dependencies { "ava_core", "ava_jobs" }
