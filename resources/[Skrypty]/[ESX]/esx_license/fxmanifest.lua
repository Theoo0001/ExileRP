fx_version "bodacious"

games {"gta5"}
lua54 'yes'
shared_script '@Exile-Handler/shared/shared.lua'
description 'ESX License'

version '1.0.1'

server_scripts {
	'@async/async.lua',
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua'
}
