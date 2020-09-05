resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

version '1.0.0'
author 'github.com/AvaN0x'
description 'Garage'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server.lua'
}
client_script {
	'config.lua',
	'client.lua'
}
