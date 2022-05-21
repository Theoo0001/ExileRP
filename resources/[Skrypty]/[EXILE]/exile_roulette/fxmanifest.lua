fx_version "bodacious"

games {"gta5"}
lua54 'yes'
shared_script '@Exile-Handler/shared/shared.lua'
client_scripts {
	'client/client.lua'
}

server_scripts {
    'server/server.lua'
}

ui_page('client/index.html')

files {
    'client/index.html',
}