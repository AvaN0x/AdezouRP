fx_version 'cerulean'
games { 'gta5' }

version '1.0.0'
author 'github.com/AvaN0x'
description 'ESX AvaN0x -- random shit'

client_scripts {
    "@es_extended/locale.lua",
    "locales/*.lua",
    'config.lua',
    'client/main.lua',
    'client/utils.lua',
    '**/*_cl.lua'
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "@es_extended/locale.lua",
    "locales/*.lua",
    'config.lua',
    'server/main.lua',
    '**/*_sv.lua'
}

data_file 'VEHICLE_METADATA_FILE' 'vehicles/*.meta'

files {
	'handling.meta'
}

export {
    "DrawText3D",
    "DrawBubbleText3D",
    "ChooseClosestPlayer",
    "ChooseClosestVehicle",
    "GetVehicleInFrontOrChooseClosestVehicle"
}

server_export {
    "SendWebhookMessage",
    "SendWebhookEmbedMessage"
}