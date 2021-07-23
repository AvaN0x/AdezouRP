fx_version 'cerulean'
games { 'gta5' }

version '1.0.0'
author 'github.com/AvaN0x'
description 'ESX Personal menu'

client_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'client/main.lua',
	'client/**/*_cl.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'server/main.lua',
	'server/**/*_sv.lua'
}

dependencies {
	'es_extended'
}