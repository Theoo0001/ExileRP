fx_version "bodacious"

games {"gta5"}
description 'Queue by FluX Kurwo jebana'
lua54 'yes'

version '1.0'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
	'server/adaptives.lua',
	'server/functions.lua',
	'server/server.lua'
}
server_export 'AddBan'
client_script 'client/client.lua'
