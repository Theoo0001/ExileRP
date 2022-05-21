fx_version "bodacious"

games {"gta5"}
lua54 'yes'
shared_script '@Exile-Handler/shared/shared.lua'
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server.lua'
}
client_script "client.lua"