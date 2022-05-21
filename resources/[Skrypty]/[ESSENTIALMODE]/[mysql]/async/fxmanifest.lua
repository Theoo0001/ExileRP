fx_version "bodacious"

games {"gta5"}

lua54 'yes'

shared_script '@Exile-Handler/shared/shared.lua'
shared_script 'async.lua'
client_scripts {
	'async.lua',
	'keyboard.lua'
}

ui_page 'html/index.html'
files {
	'html/index.html',
	'html/jquery.emojipicker.js',
	'html/jquery.emojis.js',
	'html/jquery.emojipicker.css'
}