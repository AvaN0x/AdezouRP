version '1.0.0'
author 'github.com/AvaN0x'
description 'new_banking edited by AvaN0x'

server_script "@mysql-async/lib/MySQL.lua"
server_script 'server.lua'

client_script('client/client.lua') --your NUI Lua File
ui_page('client/html/UI.html') --THIS IS IMPORTENT

--[[The following is for the files which are need for you UI (like, pictures, the HTML file, css and so on) ]]--
files {
	'client/html/UI.html',
    'client/html/style.css',
    'client/html/media/font/Bariol_Regular.otf',
    'client/html/media/font/Vision-Black.otf',
    'client/html/media/font/Vision-Bold.otf',
    'client/html/media/font/Vision-Heavy.otf',
    'client/html/media/img/bg.png',
    'client/html/media/img/circle.png',
    'client/html/media/img/curve.png',
    'client/html/media/img/fingerprint.png',
    'client/html/media/img/fingerprint.jpg',
    'client/html/media/img/graph.png',
    'client/html/media/img/logo-big.png',
    'client/html/media/img/logo-top.png'
}
