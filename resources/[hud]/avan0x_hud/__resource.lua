resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'FiveM Custom UI for ESX'

ui_page 'html/ui.html'

description 'AvaN0x HUD - Made from esx_customui'

client_scripts {
	'client.lua'
}

server_scripts {
	'server.lua'
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
