

description 'esx_cichybudowlaniec'


server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua'
	
}

client_scripts {
	'client/main.lua'
	
}
