fx_version "cerulean"
game "gta5"

version "1.0.0"
author "github.com/NewWayRP and github.com/AvaN0x"
description "new_banking edited by AvaN0x for ava_core"
-- https://github.com/NewWayRP/new_banking

lua54 "yes"
use_experimental_fxv2_oalntal_fxv2_oal "yes"

server_script "@mysql-async/lib/MySQL.lua"
server_script "server.lua"

client_script("client/client.lua")
ui_page("client/html/index.html")

files { "client/html/index.html", "client/html/style.css", "client/html/media/font/*", "client/html/media/img/*" }

dependencies { "ava_core" }
