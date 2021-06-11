fx_version 'cerulean'
games { 'gta5' }

description 'ESX deaths handler'
author 'github.com/AvaN0x'
version '1.0.0'


client_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'client/main.lua',
	'client/items.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
    'server/main.lua',
    'server/items.lua',
}

dependencies {
	'es_extended'
}