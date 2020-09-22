-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

version '1.1.0'
author 'github.com/AvaN0x'
description 'Doors and teleporters lock'


client_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua'
}

server_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua'
}

-----------------------------------
---------- ESX_AVA_DOORS ----------
-----------------------------------

client_scripts {
	'doors/doors_config.lua',
	'doors/doors_cl.lua'
}
server_scripts {
	'doors/doors_config.lua',
	'doors/doors_sv.lua'
}


-----------------------------------
-------- ESX_AVA_TELEPORTS --------
-----------------------------------

client_scripts {
	'teleports/teleports_config.lua',
	'teleports/teleports_cl.lua'
}
server_scripts {
	'teleports/teleports_config.lua',
	'teleports/teleports_sv.lua'
}



dependency 'es_extended'
