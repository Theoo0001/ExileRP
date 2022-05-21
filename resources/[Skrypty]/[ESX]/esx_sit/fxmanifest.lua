fx_version "bodacious"

games {"gta5"}
lua54 'yes'
shared_script '@Exile-Handler/shared/shared.lua'
version '1.0.3'

client_scripts {
	'config.lua',
	'lists/seat.lua',
	'client.lua'
}

server_scripts {
	'config.lua',
	'lists/seat.lua',
	'server.lua'
}