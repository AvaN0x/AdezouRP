resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

version '1.0.0'
author 'github.com/AvaN0x'
description 'ESX Personal menu'

client_scripts {
	'@es_extended/locale.lua',
	'locales/fr.lua',
	'config.lua',
	'client/teb_speed_control/speedlimiter.lua',
	'client/main.lua',
	'client/admin.lua',
	'client/dev.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/fr.lua',
	'config.lua',
	'server/main.lua',
	'server/admin.lua'
}

dependencies {
	'es_extended'
}