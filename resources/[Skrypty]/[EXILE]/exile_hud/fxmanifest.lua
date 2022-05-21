fx_version 'cerulean'

game 'gta5'
lua54 'yes'

client_scripts {
	'config/config_cl.lua',
	'client/hud_cl.lua'
}

ui_page 'html/ui.html'
exports {'HudConf'}
files {
	'html/ui.html',
	'html/css/*.css',
	'html/fonts/*.ttf',
	'config/config.js',
	'html/js/*.js',
	'html/img/noti.wav',
	'html/img/*.png',
	'html/img/logos/*.png'
}

exports {
	'SetVoiceMode',
	'ChangeStatus'
}