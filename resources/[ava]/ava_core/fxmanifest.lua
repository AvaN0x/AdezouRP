fx_version 'cerulean'
game 'gta5'

version '1.0'
author 'github.com/AvaN0x'
description 'Loading screen'
repository 'https://github.com/AvaN0x/AdezouRP'

lua54 'yes'

client_scripts {
    "client/main.lua",
    "client/player.lua"
}

server_scripts {
	'server/classes/player.lua',
	'server/main.lua',
	'server/commands.lua',
	'server/players.lua',
}

shared_scripts {
	-- 'shared/import.lua',
}

dependencies {
	'mysql-async'
}