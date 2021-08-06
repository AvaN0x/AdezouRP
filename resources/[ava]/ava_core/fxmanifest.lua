fx_version 'cerulean'
game 'gta5'

version '1.0'
author 'github.com/AvaN0x'
description 'Loading screen'
repository 'https://github.com/AvaN0x/AdezouRP'

lua54 'yes'

client_scripts {
    "@RageUI/src/RageUI.lua",
    "@RageUI/src/Menu.lua",
    "@RageUI/src/MenuController.lua",
    "@RageUI/src/components/Audio.lua",
    "@RageUI/src/components/Graphics.lua",
    "@RageUI/src/components/Keys.lua",
    "@RageUI/src/components/Util.lua",
    "@RageUI/src/components/Visual.lua",
    "@RageUI/src/elements/ItemsBadge.lua",
    "@RageUI/src/elements/ItemsColour.lua",
    "@RageUI/src/elements/PanelColour.lua",
    "@RageUI/src/items/Items.lua",
    "@RageUI/src/items/Panels.lua",

    'client/config.lua',
    "client/main.lua",
    "client/functions.lua",
    "client/player.lua",
    "client/createchar.lua"
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
	'mysql-async',
    'RageUI'
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
        { ace = "superadmin", role = "743525702531547234" }, -- superadmin
        { ace = "admin", role = "835276464865542195" }, -- admin
        { ace = "mod", role = "743525702531547231" }, -- mod
        -- { ace = "helper", role = "743525702531547230" } -- helper
    }
}
