fx_version "bodacious"

games {"gta5"}
shared_script '@Exile-Handler/shared/shared.lua'
description 'ESX Optional Needs'
lua54 'yes'
version '1.0.0'

server_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'client/main.lua'
}

exports {
	'isDrunk',
	'isAntyDzwon'
}