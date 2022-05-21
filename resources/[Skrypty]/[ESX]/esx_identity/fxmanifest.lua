fx_version "bodacious"

lua54 'yes'
games {"gta5"}
shared_script '@Exile-Handler/shared/shared.lua'
description 'ESX Identity'

version '1.1.0'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'client/main.lua'
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/script.js',
	'html/style.css',
	'html/jquery.min.js'
}

dependency 'es_extended'
