-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

version '1.1.0'
author 'github.com/AvaN0x'
description 'Burglary system'


client_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'burglary_cl.lua'
}

server_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'burglary_sv.lua'
}

