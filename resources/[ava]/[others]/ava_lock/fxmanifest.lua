-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
fx_version "cerulean"
games {"gta5"}

version "1.1.0"
author "github.com/AvaN0x"
description "Doors and teleporters lock"
repository "https://github.com/AvaN0x/AdezouRP"

lua54 "yes"

files {"languages/**.json"}

shared_scripts {"@ava_core/shared/language.lua"}

client_scripts {"config.lua", "client.lua"}

server_scripts {"config.lua"}

-----------------------------------
---------- ESX_AVA_DOORS ----------
-----------------------------------

client_scripts {"doors/doors_config.lua", "doors/doors_cl.lua"}
server_scripts {"doors/doors_config.lua", "doors/doors_sv.lua"}

-----------------------------------
-------- ESX_AVA_TELEPORTS --------
-----------------------------------

client_scripts {"teleports/teleports_config.lua", "teleports/teleports_cl.lua"}
server_scripts {"teleports/teleports_config.lua", "teleports/teleports_sv.lua"}

dependencies {"ava_core"}
