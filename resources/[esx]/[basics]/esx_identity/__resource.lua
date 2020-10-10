version '1.0.0'
author 'github.com/AvaN0x'
description "esx_identity edited from ARKSEYONET's version by AvaN0x"

client_script('client.lua')

server_script "@mysql-async/lib/MySQL.lua"
server_script "server.lua"

ui_page('html/index.html')

files({
  'html/index.html',
  'html/script.js',
  'html/style.css',
  'html/img/*.jpg',
  'html/img/*.png',
  'html/js/jquery-3.3.1.js'
})

exports {
  'openRegistry'
}