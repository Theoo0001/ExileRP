fx_version "bodacious"
games {"gta5"}
lua54 'yes'

author 'XD'
description 'XD'



server_scripts {
	'@async/async.lua',
	"@oxmysql/lib/MySQL.lua",
	'server/*.lua',
}

client_scripts {
	'config.lua',
	'shared/shared.lua',
	'client/main.lua',
	'client/vehicles.lua',
}