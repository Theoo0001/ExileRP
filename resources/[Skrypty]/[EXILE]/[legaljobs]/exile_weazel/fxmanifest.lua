fx_version 'bodacious'

game 'gta5'
lua54 'yes'
shared_script '@Exile-Handler/shared/shared.lua'

client_scripts {
  '@es_extended/locale.lua',
  'locales/en.lua',
  'locales/fr.lua',
  'config.lua',
  'client/main.lua',
  'client/client.lua' 
}

server_scripts {
  '@es_extended/locale.lua',
  'locales/en.lua',
  'locales/fr.lua',
  'config.lua',
  'server/main.lua'
}
