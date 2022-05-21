fx_version 'adamant'

game 'gta5'
lua54 'yes'
shared_script '@Exile-Handler/shared/shared.lua'

description 'Misiaczek Impound'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua'
}

client_scripts {
	'client/main.lua',
}
 