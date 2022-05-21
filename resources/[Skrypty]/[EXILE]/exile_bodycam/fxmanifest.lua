fx_version 'adamant'

game 'gta5'

lua54 'yes'

shared_script '@Exile-Handler/shared/shared.lua'

description 'w chuj autorskie'

version '1.0.0'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua'
}

client_script 'client/main.lua'

ui_page 'html/cam.html'

files {
	'html/cam.html',
	'html/style.css',
	'html/listener.js',
	'html/DJBGetDigital.ttf',
	'html/logo.png'
}