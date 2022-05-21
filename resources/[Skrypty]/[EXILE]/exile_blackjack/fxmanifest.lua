fx_version "bodacious"

games {"gta5"}
lua54 'yes'
shared_script '@Exile-Handler/shared/shared.lua'
ui_page('client/html/index.html')

files({
    'client/html/index.html',
    'client/html/script.js',
    'client/html/style.css'
})

client_scripts {
	'client/html/shared.js',
	'client/html/blackjack.js',
	'client/html/client.js',
	'client/client.lua'
}

server_scripts {
    'server/server.lua'
}