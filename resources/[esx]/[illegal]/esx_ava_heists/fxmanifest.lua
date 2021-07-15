fx_version 'cerulean'
games { 'gta5' }

version '1.0.0'
author 'github.com/AvaN0x'
description 'Heists'

client_scripts {
    '@es_extended/locale.lua',
    'locales/*.lua',
    'config.lua',
    '**/*_cfg.lua'
    'client/main.lua',
    '**/*_cl.lua'
}

server_scripts {
    -- '@mysql-async/lib/MySQL.lua',
    "@es_extended/locale.lua",
    'locales/*.lua',
    'config.lua',
    '**/*_cfg.lua'
    'server/main.lua',
    '**/*_sv.lua'
}
