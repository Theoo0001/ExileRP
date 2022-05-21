fx_version 'adamant'

game 'gta5'

lua54 'yes'

client_scripts {
	'client.lua',
}

ui_page('html/index.html')
files({
	"html/index.html",
	"html/script.js",
	"html/styles.css",
	"html/img/*.svg",
	"html/img/*.png",
	'html/font/digital.ttf'
})


exports {
	'UpdateBelt'
}