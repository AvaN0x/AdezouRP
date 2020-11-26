resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

version '0.0.1'
author 'github.com/AvaN0x'
description 'ESX Inventories'

client_scripts {
  "@es_extended/locale.lua",
  "locales/*.lua",
  'client/main.lua',
  "config.lua"
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  "@es_extended/locale.lua",
  "locales/*.lua",
  "server/classes/inventory.lua",
  "server/main.lua",
  "config.lua"
}
