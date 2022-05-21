fx_version 'bodacious'

game 'gta5'
lua54 'yes'
shared_script '@Exile-Handler/shared/shared.lua'

client_scripts {
    'config.weapons.lua',
    "client.lua"
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
    'config.weapons.lua',
    'server.lua'
}
