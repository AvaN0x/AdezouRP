fx_version "cerulean"
games { "gta5" }

version "1.0.0"
author "github.com/AvaN0x"
description "Burglary system"
repository "https://github.com/AvaN0x/AdezouRP"

lua54 "yes"
use_experimental_fxv2_oal "yes"

files { "languages/**.json" }

shared_scripts { "@ava_lib/import.lua", "@ava_lib/shared/language.lua" }

client_scripts { "config.lua", "burglaries_cl.lua" }

server_scripts { "config.lua", "burglaries_sv.lua" }

dependencies { "ava_core", "ava_lockpicking" }
