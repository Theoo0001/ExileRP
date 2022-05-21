fx_version 'adamant'

game 'gta5'

lua54 'yes'


ui_page 'html/index.html'

files {
--[[	'html/index.html',
	'html/static/css/app.css',
	'html/static/js/app.js',
	'html/static/js/manifest.js',
	'html/static/js/vendor.js',

	'html/static/config/config.json',

	-- Coque
	'html/static/img/coque/s8.png',
	'html/static/img/coque/iphonex.png',
	'html/static/img/coque/huawei.png',
	'html/static/img/coque/iphone5s.png',

	-- Background
	'html/static/img/background/*.png',
	'html/static/img/background/*.jpg',

	'html/static/img/icons_app/*.png',

	'html/static/img/app_bank/logo_mazebank.jpg',

	'html/static/img/app_tchat/splashtchat.png',

	'html/static/img/twitter/bird.png',
	'html/static/img/twitter/default_profile.png',
	'html/static/sound/Twitter_Sound_Effect.ogg',

	'html/static/img/courbure.png',
	'html/static/fonts/fontawesome-webfont.ttf',
	'html/static/fonts/fontawesome-webfont.svg',
	
	'html/static/sound/ring.ogg',
	'html/static/sound/tchatNotification.ogg',
	'html/static/sound/Phone_Call_Sound_Effect.ogg',]]
	'html/index.html',
	'html/static/css/app.css',
	'html/static/js/app.js',
	'html/static/js/manifest.js',
	'html/static/js/vendor.js',

	'html/static/config/config.json',
	
	-- Coque
	'html/static/img/coque/iphone11.png',
	'html/static/img/coque/iphonex.png',
	'html/static/img/coque/huawei.png',
	'html/static/img/coque/blue.png',
	'html/static/img/coque/red.png',
	'html/static/img/coque/grey.png',
	'html/static/img/coque/mint.png',
	'html/static/img/coque/pink.png',
	'html/static/img/coque/transparent.png',
	
	-- Background
	'html/static/img/background/exile.png',
	'html/static/img/background/1.jpg',
	'html/static/img/background/2.jpg',
	'html/static/img/background/3.jpg',
	'html/static/img/background/4.jpg',
	'html/static/img/background/5.jpg',
	'html/static/img/background/6.jpg',
	'html/static/img/background/7.jpg',

	'html/static/img/icons_app/9gag.png',
	'html/static/img/icons_app/bank.png',
	'html/static/img/icons_app/borrado.png',
	'html/static/img/icons_app/call.png',
	'html/static/img/icons_app/cardealer.png',
	'html/static/img/icons_app/cardealer2.png',
	'html/static/img/icons_app/contacts.png',
	'html/static/img/icons_app/home.png',
	'html/static/img/icons_app/mechanic.png',
	'html/static/img/icons_app/medic.png',
	'html/static/img/icons_app/menu.png',
	'html/static/img/icons_app/news.png',
	'html/static/img/icons_app/notes.png',
	'html/static/img/icons_app/photo.png',
	'html/static/img/icons_app/police.png',
	'html/static/img/icons_app/rzad.png',
	'html/static/img/icons_app/sad.png',
	'html/static/img/icons_app/settings.png',
	'html/static/img/icons_app/sms.png',
	'html/static/img/icons_app/fire.png',
	'html/static/img/icons_app/taxi.png',
	'html/static/img/icons_app/tchat.png',
	
	'html/static/img/app_bank/fleeca_tar.png',
	'html/static/img/app_bank/tarjetas.png',

	'html/static/img/app_tchat/reddit.png',

	'html/static/fonts/fontawesome-webfont.eot',
	'html/static/fonts/fontawesome-webfont.ttf',
	'html/static/fonts/fontawesome-webfont.woff',
	'html/static/fonts/fontawesome-webfont.woff2',

	'html/static/sound/*.ogg',

}

client_script {
	"config.lua",
	"client/animation.lua",
	"client/client.lua",
	"client/game.lua",

	"client/photo.lua",
	"client/app_tchat.lua",
	"client/bank.lua",
	"client/twitter.lua"
}

server_script {
	'@oxmysql/lib/MySQL.lua',
	"config.lua",
	"server/server.lua",

	"server/app_tchat.lua",
	"server/twitter.lua",
	"server/bank.lua"
}

exports {
  'openPhone',
  'getMenuIsOpen',
  'TooglePhone',
  'PhoneNumber',
  'Start',
	'addContact'
}

server_export 'sendlog'