fx_version "bodacious"

games {"gta5"}
lua54 'yes'
description 'ESX Drugs'
shared_script '@Exile-Handler/shared/shared.lua'
version '1.0.2'

client_scripts {
	'client/config.lua',
	'client/esx_drugs_cl.lua',
	'client/esx_drugs_init.lua',
}

server_scripts {
	'server/esx_drugs_sv.lua'
}
