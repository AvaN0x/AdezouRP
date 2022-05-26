resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Menu Default edited by AvaN0x'
version '1.0.0'

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
	'html/fonts/*.ttf',
	'html/img/**/*.png',
	'html/img/header/*.png',
}

dependencies {
	'es_extended'
}
