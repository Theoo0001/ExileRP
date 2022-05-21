fx_version 'adamant'

game 'gta5'
lua54 'yes'
shared_script '@Exile-Handler/shared/shared.lua'

description 'ESX Car Wash'

version '1.1.0'

server_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/sv.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/sv.lua',
	'config.lua',
	'client/main.lua',
}

dependency 'es_extended'