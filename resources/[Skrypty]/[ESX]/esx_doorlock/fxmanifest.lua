fx_version "bodacious"

games {"gta5"}
lua54 'yes'
shared_script '@Exile-Handler/shared/shared.lua'
description 'ESX door lock'

version '1.3.0'

server_scripts {
	"@oxmysql/lib/MySQL.lua",
	'@es_extended/locale.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'config.lua',
	'client/main.lua'
}

dependency 'es_extended'
