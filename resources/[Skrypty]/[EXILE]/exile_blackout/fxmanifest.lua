fx_version 'bodacious'

game 'gta5'

shared_script '@Exile-Handler/shared/shared.lua'

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "server/main.lua",
}

client_scripts {
    "client/main.lua",
}


ui_page 'html/index.html'

files {
    'html/index.html',
    'html/heartbeat.ogg',
}

exports {
	'pasyState',
}