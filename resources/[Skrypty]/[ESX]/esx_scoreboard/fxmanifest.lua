fx_version 'adamant'

game 'gta5'
lua54 'yes'
shared_script '@Exile-Handler/shared/shared.lua'

server_script 'server/main.lua'

client_script 'client/main.lua'

ui_page 'html/scoreboard.html'

files {
	'html/scoreboard.html',
	'html/style.css',
	'html/reset.css',
	'html/listener.js',
	'html/img.png'
}

server_exports {
	'MisiaczekPlayers',
	'CounterPlayers'
}