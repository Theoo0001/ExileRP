fx_version "bodacious"

games {"gta5"}
lua54 'yes'
description 'ESX Addon Inventory'
shared_script '@Exile-Handler/shared/shared.lua'
version '1.1.0'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/classes/addoninventory.lua',
	'server/main.lua'
}

dependency 'es_extended'