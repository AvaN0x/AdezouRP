resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX teleporter'

version '0.1'

server_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'client/main.lua'
}

dependency 'es_extended'
