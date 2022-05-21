fx_version "bodacious"

games {"gta5"}
lua54 'yes'
shared_script '@Exile-Handler/shared/shared.lua'
description 'ESX Police Job'

version '1.0.0'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'translation/sv.lua',
	'translation/en.lua',
	'config.lua',
	'server/main.lua',
}

client_scripts {
	'@es_extended/locale.lua',
	'translation/sv.lua',
	'translation/en.lua',
	'config.lua',
	'client/main.lua',
}