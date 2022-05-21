fx_version "bodacious"

games {"gta5"}
lua54 'yes'
server_scripts {
	'@oxmysql/lib/MySQL.lua',
    '@es_extended/locale.lua',
	'client/config.lua',
	'server/server.lua',
}

client_scripts {
	'@es_extended/locale.lua',
	'client/config.lua',
	'client/client.lua',
	'client/init.lua',
}