fx_version "bodacious"

game "gta5"

version '3.0'
author 'github.com/AvaN0x'
description 'Loading screen'

loadscreen_manual_shutdown "yes"
client_script "client.lua"

files {
    'loadingscreen.html',
    'style.css',
    'script.js',
    'img/**/*.png'
}

loadscreen 'loadingscreen.html'
