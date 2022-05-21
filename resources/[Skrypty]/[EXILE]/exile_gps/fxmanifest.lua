fx_version 'adamant'

games { 'gta5' }
lua54 'yes'

client_script 'client.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}