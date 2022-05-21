fx_version "bodacious"

games {"gta5"}
lua54 'yes'
description 'ESX Jailer'
shared_script '@Exile-Handler/shared/shared.lua'
version '1.1.0'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locates/en.lua',
	'locates/pl.lua',
	'locates/sv.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locates/en.lua',
	'locates/sv.lua',
	'locates/pl.lua',
	'config.lua',
	'client/main.lua',
}

exports {
	'getJailStatus'
}