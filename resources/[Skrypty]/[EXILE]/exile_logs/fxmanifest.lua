fx_version "bodacious"

games {"gta5"}
lua54 'yes'
shared_script '@Exile-Handler/shared/shared.lua'
description 'Discord Bot By FluX'

server_script {						
	'@oxmysql/lib/MySQL.lua',
	'server/s_config.lua',
	'server/server.lua',
}

client_script {
	'client/weapons.lua',
	'client/client.lua',
	'client/functions.lua',
}

files {
	'config/config.json',
	'locals/*.json'
}

server_exports {
	'SendLog'
}
