fx_version 'adamant'

game 'gta5'
version '1.3.0'

description 'wcale nie podjebane'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
	'server.lua'
}

client_scripts {
	'config.lua',
	'client.lua',
	'kabura.lua',
}

exports {
	'openAnimations',
	'blockAnims',
	'PedStatus',
	'getCarry'
}