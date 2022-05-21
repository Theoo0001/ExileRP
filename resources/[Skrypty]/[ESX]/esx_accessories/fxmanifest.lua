fx_version "bodacious"

games {"gta5"}

lua54 'yes'

description 'ESX Accessories'
shared_script '@Exile-Handler/shared/shared.lua'
version '1.0.1'

server_scripts {
	'@async/async.lua',
	'@oxmysql/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/pl.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/pl.lua',
	'config.lua',
	'client/main.lua'
}