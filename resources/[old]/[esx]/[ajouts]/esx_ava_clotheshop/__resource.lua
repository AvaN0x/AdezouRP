resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX ClotheShop'
version '1.0.0'
author 'github.com/AvaN0x'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    '@es_extended/locale.lua',
    'locales/*.lua',
    'config.lua',
    'server/main.lua'
}

client_scripts {
    '@es_extended/locale.lua',
    'locales/*.lua',
    'config.lua',
    'client/main.lua'
}

