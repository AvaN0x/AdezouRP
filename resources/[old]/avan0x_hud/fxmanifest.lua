fx_version 'cerulean'
games { 'gta5' }

version '1.0.0'
author 'github.com/AvaN0x'
description 'AvaN0x HUD and speedometer'

ui_page 'html/ui.html'

client_scripts {
	'client/client.lua'
}

server_scripts {
	'server/server.lua'
}

files {
	'html/ui.html',
	'html/style.css',
	'html/main.js',
	'html/img/**/*.png',
	'html/img/**/*.svg'
}

export {
    "copyToClipboard"
}