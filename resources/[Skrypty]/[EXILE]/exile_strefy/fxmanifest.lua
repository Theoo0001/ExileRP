fx_version "bodacious"
games {"gta5"}

lua54 'yes'

client_scripts {
   '@es_extended/locale.lua',
   'config.lua',
   'client.lua',
}

server_scripts {
   '@oxmysql/lib/MySQL.lua',
   '@es_extended/locale.lua',
   'config.lua',
   'server.lua',
}

exports {
	'ReturnConfig'
}