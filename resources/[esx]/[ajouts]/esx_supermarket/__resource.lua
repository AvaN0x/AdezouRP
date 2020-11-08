resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Supermarket modified by AvaN0x'

version '1.0.1'

files {
	'html/ui.html',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js',
	'html/iransans.otf',
	-- default
	'html/img/*.png'
}

ui_page 'html/ui.html'

client_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'client/main.lua'
}

server_scripts {
	'@es_extended/locale.lua',
	'@mysql-async/lib/MySQL.lua',
	'locales/*.lua',
	'config.lua',
	'server/main.lua'
}

dependency 'es_extended'
