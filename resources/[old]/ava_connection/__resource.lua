resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

version '1.0.0'
author 'github.com/AvaN0x'
description "Connection management with discord whitelist. Discord connexion is based on sadboilogan's discord_perms"

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	"config.lua",
	"server.lua"
}

dependencies {
	'es_extended'
}