fx_version "cerulean"

games {"gta5"}
lua54 'yes'
shared_script '@Exile-Handler/shared/shared.lua'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
	'server.lua'
}

client_scripts {
	'config.lua',
	'client.lua'
}

dependency 'es_extended'

exports {
	'GeneratePlate',
	'getVehicles'
}

server_exports {
	'GetVehicle'
}