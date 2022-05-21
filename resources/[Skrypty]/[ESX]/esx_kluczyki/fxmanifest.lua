fx_version 'adamant'

game 'gta5'
lua54 'yes'
shared_script '@Exile-Handler/shared/shared.lua'

client_scripts {
    '@es_extended/locale.lua',
    "config/shared.lua",
    "client/client.lua",
}

server_scripts {
    '@es_extended/locale.lua',
	'@oxmysql/lib/MySQL.lua',
    "config/shared.lua",
    "server/server.lua",
}
exports{
    "LockSystem"
}