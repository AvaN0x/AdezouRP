fx_version 'cerulean'
games { 'gta5' }

description 'ESX deaths handler'
author 'github.com/AvaN0x'
version '1.0.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
    'server/main.lua',
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'client/main.lua',
}

dependencies {
	'es_extended'
}