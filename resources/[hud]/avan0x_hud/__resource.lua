resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'AvaN0x HUD and speedometer'

ui_page 'html/ui.html'

client_scripts {
	'client/client.lua'
}

server_scripts {
	'server/server.lua'
}

files {
	-- Main Images
	'html/ui.html',
	'html/style.css',
	'html/grid.css',
	'html/main.js',
	'html/img/*.png',
	'html/img/jobs/*.png',
}
