fx_version "bodacious"

games {"gta5"}
lua54 'yes'
shared_script '@Exile-Handler/shared/shared.lua'

client_scripts {
	'client/*.lua',
	'scripts/**/client.lua',
}

server_scripts {
	'@async/async.lua',
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua',
	'scripts/**/server.lua'
}

exports {
	'DisplayingStreet',
	'DisableEffects',
	'EnableEffects',
	'isPlayerProne',
	'DrawProcent',
	'SetBlip',
	'WybijBlachyMenu',
	'blip_info',
}