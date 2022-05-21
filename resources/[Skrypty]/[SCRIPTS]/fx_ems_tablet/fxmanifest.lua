fx_version 'adamant'

game 'gta5'

lua54 'yes'

shared_script '@Exile-Handler/shared/shared.lua'

description 'EMS tablet'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
	'server/server.lua'
}

client_scripts {
	'config.lua',
	'client/client.lua'
}

ui_page('client/html/UI.html')

files({
    'client/html/UI.html',
    'client/html/style.css',
    'client/html/metro-all.min.css',
    'client/html/metro.min.js'
})