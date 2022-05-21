fx_version "bodacious"

games {"gta5"}
shared_script '@Exile-Handler/shared/shared.lua'
lua54 'yes'
ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/play.ttf',
	'html/playb.ttf',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
    'config.lua',
	'server.lua'

}
client_script {
	'config.lua',
	'client.lua'
}

dependencies {
	'esx_vehicleshop'
}
