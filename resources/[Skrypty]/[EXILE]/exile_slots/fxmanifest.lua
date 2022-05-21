fx_version "bodacious"

games {"gta5"}
lua54 'yes'
shared_script '@Exile-Handler/shared/shared.lua'
ui_page 'client/html/ui.html'

client_scripts {
	'client/config.lua',
	'client/client.lua'
}

server_scripts {
	'server/server.lua',
	'@oxmysql/lib/MySQL.lua',
	'@es_extended/locale.lua',
}

files {
  'client/html/ui.html',
  'client/html/script.js',
  'client/html/design.css',
  -- Images
  'client/html/img/black.png',
  'client/html/img/item1.png',
  'client/html/img/item2.png',
  'client/html/img/item3.png',
  'client/html/img/item4.png',
  'client/html/img/item5.png',
  'client/html/img/item6.png',
  'client/html/img/item7.png',
  'client/html/img/red.png',
  'client/html/img/lever.png',
  -- Audio
  'client/html/audio/alarma.wav',
  'client/html/audio/apasaButonul.wav',
  'client/html/audio/changeBet.wav',
  'client/html/audio/collect.wav',
  'client/html/audio/pornestePacanele.wav',
  'client/html/audio/seInvarte.wav',
  'client/html/audio/winDouble.wav',
  'client/html/audio/winLine.wav'
}

exports {
	'GetCasinoMoney'
}