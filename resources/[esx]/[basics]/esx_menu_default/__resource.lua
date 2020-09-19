resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Menu Default'

version '1.0.2'

client_scripts {
	'client/main.lua'
}

ui_page {
	'html/ui.html'
}

files {
	'html/ui.html',
	'html/css/app.css',
	'html/js/mustache.min.js',
	'html/js/app.js',
	'html/fonts/pdown.ttf',
	'html/fonts/bankgothic.ttf',
    'html/fonts/v.ttf',
	'html/img/*.png',
	'html/img/keys/*.png',
	'html/img/header/*.png',

}

dependencies {
	'es_extended'
}
