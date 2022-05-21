fx_version 'bodacious'

game 'gta5'


client_script "client/main.lua"
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	"server/server.lua",
	"permissions.lua"
}

ui_page 'client/index.html'

files {
	'client/index.html'
}

