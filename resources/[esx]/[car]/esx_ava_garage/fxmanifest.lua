fx_version 'cerulean'
games { 'gta5' }

version '2.0.0'
author 'github.com/AvaN0x'
description 'Garage'


client_script {
	'config.lua',
	'client.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    '@es_extended/locale.lua',
	'config.lua',
	'server.lua'
}