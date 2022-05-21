fx_version 'adamant'


shared_script '@Exile-Handler/shared/shared.lua'
lua54 'yes'
game 'gta5'

description 'CruiseControl System for ESX'

version '1.0.0'

dependencies {
  'es_extended'
}

client_scripts {
  '@es_extended/locale.lua',
  'locales/pl.lua',
  'client/main.lua',
  'config.lua',
}

exports {
	'IsEnabled'
}