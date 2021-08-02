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
    '@mysql-async/lib/MySQL.lua',

	'server/config.lua',
	'server/main.lua',
	'server/classes/player.lua',
	'server/utils.lua',
	'server/commands.lua',
	'server/players.lua',
}

shared_scripts {
	-- 'shared/import.lua',
}

dependencies {
	'mysql-async'
}

-- comment this line to disable debug prints
my_data 'debug_prints' 'yes'

my_data 'discord_config' {
    GuildId = "743525702157992018",
    Whitelist = {
		-- "743525702531547234", -- superadmin
		-- "835276464865542195", -- admin
		-- "743525702531547231", -- mod
		-- "743525702531547230" -- helper
		"743525702531547228" -- citizen
	},
    Ace = {
        { ace = "superadmin", role = "743525702531547234" },
        { ace = "admin", role = "835276464865542195" },
        { ace = "mod", role = "743525702531547231" },
        { ace = "helper", role = "743525702531547230" }
    }
}
