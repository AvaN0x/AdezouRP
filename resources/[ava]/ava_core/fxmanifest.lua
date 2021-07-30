fx_version 'cerulean'
games { 'gta5' }

version '1.0'
author 'github.com/AvaN0x'
description 'Loading screen'
repository 'https://github.com/AvaN0x/AdezouRP'

lua54 'yes'

client_scripts {
    "client/main.lua"
}

server_scripts {
	'server/main.lua',
	'server/commands.lua',
}

shared_scripts {
	-- 'shared/import.lua',
}

dependencies {
	'mysql-async'
}