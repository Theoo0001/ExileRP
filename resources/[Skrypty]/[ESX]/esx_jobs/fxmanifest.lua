fx_version "bodacious"

games {"gta5"}
lua54 'yes'
description 'ESX Jobs'
shared_script '@Exile-Handler/shared/shared.lua'
version '1.1.0'

server_scripts {
	'@es_extended/locale.lua',
	'@oxmysql/lib/MySQL.lua',
	'locales/pl.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/pl.lua',
	'config.lua',
	--'client/jobs/fisherman.lua',
	--'client/jobs/grower.lua',
	--'client/jobs/baker.lua',
	--'client/jobs/milkman.lua',
	--'client/jobs/farmer.lua',
	--'client/jobs/courier.lua',
	--'client/jobs/kawiarnia.lua',
	--'client/jobs/weazel.lua',
	'client/main.lua'
}

server_exports {
	'ExportLevel'
}

dependencies {
	'es_extended',
	'esx_skin'
}