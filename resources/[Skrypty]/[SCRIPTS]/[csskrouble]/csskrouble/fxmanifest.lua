fx_version 'cerulean'
game 'gta5'

description 'ExileRP'

author 'csskrouble'

version '1.0.0'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/ocr.js'
}

client_scripts {
   'client/*.lua',
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
}

files {
    'data/vehiclelayouts.meta', 
    'data/vehicleaihandlinginfo.meta',
    'data/propsets.meta',
    'data/loadouts.meta', 
    'data/handling.meta',
    'data/carcols.meta', 
    'data/weapons.meta',
    'data/pedaccuracy.meta',
    'data/weaponanimations.meta',
    'data/weaponcomponents.meta',
    'data/weapons_pistol.meta',
    'data/weapon_ceramicpistol.meta',
    'data/weapons_pistol_mk2.meta',
    'data/weapons_snspistol_mk2.meta',
    'data/weaponheavypistol.meta',
    'data/weaponvintagepistol.meta',
    'data/weaponsnspistol.meta',
    'data/weaponmachinepistol.meta',
    'data/weaponcombatpdw.meta',
    'data/weaponmarksmanpistol.meta',
    'data/weapons_doubleaction.meta',
    'data/weapons_revolver_mk2.meta',
    'data/weapon_navyrevolver.meta',
    'data/weapon_gadgetpistol.meta',
    'scenario/weaponevents.ymt',
    'scenario/combattasks.ymt',
    'scenario/movementtasks.ymt',
    'scenario/playerinfo.ymt',
    'scenario/vehicletasks.ymt',
    'scenario/materials.dat',
    'data/popcycle.dat',
    'data/carvariations.meta',
    'data/weaponpipebomb.meta',
}

data_file 'WEAPONINFO_FILE_PATCH' 'data/weapon_gadgetpistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'data/weapon_navyrevolver.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'data/weaponcombatpdw.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'data/weapon_revolver_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'data/weapons_doubleaction.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'data/weaponmachinepistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'data/weaponmarksmanpistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'data/weapon_ceramicpistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'data/weaponheavypistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'data/weaponvintagepistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'data/weapons.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'data/weaponanimations.meta'
data_file 'WEAPONCOMPONENTSINFO_FILE' 'data/weaponcomponents.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'data/weapons_pistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'data/weapons_snspistol_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'data/weapons_pistol_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'data/weaponsnspistol.meta'
data_file 'CARCOLS_FILE' 'data/carcols.meta'
data_file 'HANDLING_FILE' 'data/handling.meta'
data_file 'LOADOUTS_FILE' 'data/loadouts.meta'
data_file 'AMBIENT_PROP_MODEL_SET_FILE' 'data/propsets.meta'
data_file 'VEHICLE_LAYOUTS_FILE' 'data/vehiclelayouts.meta'
data_file 'HANDLING_FILE' 'data/vehicleaihandlinginfo.meta'
data_file 'WEAPONINFO_FILE' 'data/weaponpipebomb.meta'
data_file 'VEHICLE_VARIATION_FILE' 'data/carvariations.meta'
data_file 'POPSCHED_FILE' 'data/popcycle.dat'