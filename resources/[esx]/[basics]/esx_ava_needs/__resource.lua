resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

version '1.1.0'
author 'github.com/AvaN0x'
description 'ESX Needs : Drink, food, alcohol, drug'


client_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'client/main.lua'
}

server_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'server/main.lua',
	'server/drink.lua',
	'server/food.lua',
	'server/alcohol.lua',
	'server/drug.lua'
}

dependencies {
	'es_extended',
	'esx_status'
}
