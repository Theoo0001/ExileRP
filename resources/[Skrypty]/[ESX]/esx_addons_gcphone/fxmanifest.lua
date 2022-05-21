fx_version 'adamant'

game 'gta5'
lua54 'yes'
shared_script '@Exile-Handler/shared/shared.lua'

client_script {
	"client.lua",
	"klawiatura.lua"
}

server_script {
	'@oxmysql/lib/MySQL.lua',
	"server.lua"
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/jquery.emojis.js',
	'html/jquery.emojipicker.js',
	'html/jquery.emojipicker.css',

}

