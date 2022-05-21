fx_version "bodacious"
games {"gta5"}
lua54 'yes'

client_scripts {
    '@es_extended/locale.lua',
    'locales/pl.lua',
    'config.lua',
    'client/client.lua',
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@es_extended/locale.lua',
    'locales/pl.lua',
    'server/server.lua'
}

ui_page('html/index.html')

files {
    'html/index.html',
    'html/worek.png'
}

exports {
	'IsWorek',
    'GetOrgsServer',
}