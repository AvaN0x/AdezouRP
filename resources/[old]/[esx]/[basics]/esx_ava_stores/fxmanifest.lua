fx_version 'cerulean'
games { 'gta5' }

version '1.0.0'
author 'github.com/AvaN0x'
description 'Stores handler'

client_scripts {
    '@es_extended/locale.lua',
    'locales/*.lua',
    'config.lua',
    'client/main.lua',
    '**/*_cl.lua'
}

server_scripts {
    "@es_extended/locale.lua",
    'locales/*.lua',
    'config.lua',
    'server/main.lua',
    '**/*_sv.lua'
}
