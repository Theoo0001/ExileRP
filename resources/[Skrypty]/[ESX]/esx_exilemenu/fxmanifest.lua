fx_version "bodacious"

lua54 'yes'
games {"gta5"}
shared_script '@Exile-Handler/shared/shared.lua'
client_script('client.lua')
server_script "@oxmysql/lib/MySQL.lua"
server_script 'server.lua'
ui_page('client/html/UI.html') --THIS IS IMPORTENT

--[[The following is for the files which are need for you UI (like, pictures, the HTML file, css and so on) ]]--
files({
    'client/html/UI.html',
    'client/html/style.css'
})

server_exports {
    'CheckInsuranceEMS',
    'CheckInsuranceLSC',
    'KursyChange'
}
