resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

version '1.0.0'
author 'github.com/AvaN0x'
description 'Lockpicking animation'

client_script 'client.lua' --your NUI Lua File
server_script "@mysql-async/lib/MySQL.lua"
server_script 'server.lua'

ui_page "html/ui.html"

--[[The following is for the files which are need for you UI (like, pictures, the HTML file, css and so on) ]]--
files {
	'html/ui.html',
    'html/style.css',
}
