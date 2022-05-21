fx_version "bodacious"

games {"gta5"}
lua54 'yes'

description 'esx_policejob Edited By ExileRP Developers'
shared_script '@Exile-Handler/shared/shared.lua'
version '1.0'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/br.lua',
	'locales/de.lua',
	'locales/en.lua',
	'locales/pl.lua',
	'locales/fr.lua',
	'locales/fi.lua',
	'locales/es.lua',
	'locales/sv.lua',
	'config.lua',
	'server/main.lua',
	'10-13/server.lua',
	'okup/server.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/br.lua',
	'locales/de.lua',
	'locales/en.lua',
	'locales/pl.lua',
	'locales/fr.lua',
	'locales/fi.lua',
	'locales/es.lua',
	'locales/sv.lua',
	'config.lua',
	'client/main.lua',
	'client/radio.lua',
	'10-13/client.lua',
	'okup/client.lua'
}

exports {
	'IsCuffed',
	'HandcuffMenu',
	'checkzakutedxD',
}

dependencies {
	'es_extended',
}