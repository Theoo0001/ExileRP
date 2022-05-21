Config               = {}

Config.DrawDistance  = 5
Config.Size          = { x = 1.2, y = 1.2, z = 0.5 }
Config.Color         = { r = 0, g = 0, b = 0 }
Config.Type          = 23
Config.Locale        = 'en'

Config.LicenseEnable = true
Config.LicensePrice  = 2115

Config.Zones = {
	GunShop = {
		Legal = true,
		Items = {
			{ weapon = 'WEAPON_PISTOL',  price = 100000, ammoPrice = 200, AmmoToGive = 48 },
			{ weapon = 'WEAPON_KNIFE', price = 5000 }
		},
		Locations = {
			vector3(-662.1, -935.3, 20.8),
			vector3(810.2, -2157.3, 28.6),
			vector3(1693.4, 3759.5, 33.7),
			vector3(-330.2, 6083.8, 30.4),
			vector3(252.3, -50.0, 68.9),
			vector3(22.0, -1107.2, 28.8),
			vector3(2567.6, 294.3, 107.7),
			vector3(-1117.5, 2698.6, 17.5),
			vector3(842.4, -1033.4, 27.1)
		}
	},

	GunShopDS = {
		Legal = false,
		Items = {
			{ weapon = 'WEAPON_PISTOL',  price = 100000, ammoPrice = 200, AmmoToGive = 100 },
			{ weapon = 'WEAPON_SNSPISTOL',  price = 100000, ammoPrice = 200, AmmoToGive = 100 },
			{ weapon = 'WEAPON_SNSPISTOL_MK2',  price = 100000, ammoPrice = 200, AmmoToGive = 100 },
			{ weapon = 'WEAPON_PISTOL_MK2',  price = 100000, ammoPrice = 200, AmmoToGive = 100 },
			{ weapon = 'WEAPON_VINTAGEPISTOL',  price = 100000, ammoPrice = 200, AmmoToGive = 100 },
			{ weapon = 'WEAPON_CERAMICPISTOL',  price = 100000, ammoPrice = 200, AmmoToGive = 100 },
			{ weapon = 'WEAPON_DOUBLEACTION',  price = 250000, ammoPrice = 200, AmmoToGive = 100 },
			{ weapon = 'WEAPON_MINISMG',  price = 1500000, ammoPrice = 200, AmmoToGive = 100 },
			{ weapon = 'WEAPON_MICROSMG',  price = 2000000, ammoPrice = 200, AmmoToGive = 100 },
			{ weapon = 'WEAPON_SMG_MK2',  price = 3000000, ammoPrice = 200, AmmoToGive = 100 },
			{ weapon = 'WEAPON_COMPACTRIFLE',  price = 4000000, ammoPrice = 200, AmmoToGive = 100 },
			{ weapon = 'WEAPON_COMBATPDW',  price = 4500000, ammoPrice = 200, AmmoToGive = 100 },
			{ weapon = 'WEAPON_ASSAULTRIFLE',  price = 12500000, ammoPrice = 200, AmmoToGive = 100 },
			{ weapon = 'WEAPON_ASSAULTRIFLE_MK2',  price = 15000000, ammoPrice = 200, AmmoToGive = 100 },
			{ weapon = 'WEAPON_MUSKET',  price = 35000000, ammoPrice = 200, AmmoToGive = 100 },
		},
		Locations = {
			vector3(1459.55, 1142.01, 114.33-0.95),
		}
	},
}


Config.Weapons = {
	WEAPON_KNIFE = { item = 'WEAPON_KNIFE', label = _U('weapon_knife') },
	WEAPON_NIGHTSTICK = { item = 'WEAPON_NIGHTSTICK', label = _U('weapon_nightstick') },
	WEAPON_HAMMER = { item = 'WEAPON_HAMMER', label = _U('weapon_hammer') },
	WEAPON_BAT = { item = 'WEAPON_BAT', label = _U('weapon_bat') },
	WEAPON_GOLFCLUB = { item = 'WEAPON_GOLFCLUB', label = _U('weapon_golfclub') },
	WEAPON_CROWBAR = { item = 'WEAPON_CROWBAR', label = _U('weapon_crowbar') },
	WEAPON_PISTOL = { item = 'WEAPON_PISTOL', label = _U('weapon_pistol') },
	WEAPON_COMBATPISTOL = { item = 'WEAPON_COMBATPISTOL', label = _U('weapon_combatpistol') },
	WEAPON_APPISTOL = { item = 'WEAPON_APPISTOL', label = _U('weapon_appistol') },
	WEAPON_PISTOL50 = { item = 'WEAPON_PISTOL50', label = _U('weapon_pistol50') },
	WEAPON_MICROSMG = { item = 'WEAPON_MICROSMG', label = _U('weapon_microsmg') },
	WEAPON_SMG = { item = 'WEAPON_SMG', label = _U('weapon_smg') },
	WEAPON_ASSAULTSMG = { item = 'WEAPON_ASSAULTSMG', label = _U('weapon_assaultsmg') },
	WEAPON_ASSAULTRIFLE = { item = 'WEAPON_ASSAULTRIFLE', label = _U('weapon_assaultrifle') },
	WEAPON_EMPLAUNCHER = { item = 'WEAPON_EMPLAUNCHER', label = _U('weapon_emplauncher') },
	WEAPON_HEAVYRIFLE = { item = 'WEAPON_HEAVYRIFLE', label = _U('weapon_heavyrifle') },
	WEAPON_FERTILIZERCAN = { item = 'WEAPON_FERTILIZERCAN', label = _U('weapon_fertilizercan') },
	WEAPON_CARBINERIFLE = { item = 'WEAPON_CARBINERIFLE', label = _U('weapon_carbinerifle') },
	WEAPON_ADVANCEDRIFLE = { item = 'WEAPON_ADVANCEDRIFLE', label = _U('weapon_advancedrifle') },
	WEAPON_MG = { item = 'WEAPON_MG', label = _U('weapon_mg') },
	WEAPON_COMBATMG = { item = 'WEAPON_COMBATMG', label = _U('weapon_combatmg') },
	WEAPON_PUMPSHOTGUN = { item = 'WEAPON_PUMPSHOTGUN', label = _U('weapon_pumpshotgun') },
	WEAPON_SAWNOFFSHOTGUN = { item = 'WEAPON_SAWNOFFSHOTGUN', label = _U('weapon_sawnoffshotgun') },
	WEAPON_ASSAULTSHOTGUN = { item = 'WEAPON_ASSAULTSHOTGUN', label = _U('weapon_assaultshotgun') },
	WEAPON_BULLPUPSHOTGUN = { item = 'WEAPON_BULLPUPSHOTGUN', label = _U('weapon_bullpupshotgun') },
	WEAPON_STUNGUN = { item = 'WEAPON_STUNGUN', label = _U('weapon_stungun') },
	WEAPON_SNIPERRIFLE = { item = 'WEAPON_SNIPERRIFLE', label = _U('weapon_sniperrifle') },
	WEAPON_HEAVYSNIPER = { item = 'WEAPON_HEAVYSNIPER', label = _U('weapon_heavysniper') },
	WEAPON_REMOTESNIPER = { item = 'WEAPON_REMOTESNIPER', label = _U('weapon_remotesniper') },
	WEAPON_GRENADELAUNCHER = { item = 'WEAPON_GRENADELAUNCHER', label = _U('weapon_grenadelauncher') },
	WEAPON_RPG = { item = 'WEAPON_RPG', label = _U('weapon_rpg') },
	WEAPON_STINGER = { item = 'WEAPON_STINGER', label = _U('weapon_stinger') },
	WEAPON_MINIGUN = { item = 'WEAPON_MINIGUN', label = _U('weapon_minigun') },
	WEAPON_GRENADE = { item = 'WEAPON_GRENADE', label = _U('weapon_grenade') },
	WEAPON_STICKYBOMB = { item = 'WEAPON_STICKYBOMB', label = _U('weapon_stickybomb') },
	WEAPON_SMOKEGRENADE = { item = 'WEAPON_SMOKEGRENADE', label = _U('weapon_smokegrenade') },
	WEAPON_BZGAS = { item = 'WEAPON_BZGAS', label = _U('weapon_bzgas') },
	WEAPON_MOLOTOV = { item = 'WEAPON_MOLOTOV', label = _U('weapon_molotov') },
	WEAPON_FIREEXTINGUISHER = { item = 'WEAPON_FIREEXTINGUISHER', label = _U('weapon_fireextinguisher') },
	WEAPON_PETROLCAN = { item = 'WEAPON_PETROLCAN', label = _U('weapon_petrolcan') },
	WEAPON_DIGISCANNER = { item = 'WEAPON_DIGISCANNER', label = _U('weapon_digiscanner') },
	WEAPON_BALL = { item = 'WEAPON_BALL', label = _U('weapon_ball') },
	WEAPON_SNSPISTOL = { item = 'WEAPON_SNSPISTOL', label = _U('weapon_snspistol') },
	WEAPON_BOTTLE = { item = 'WEAPON_BOTTLE', label = _U('weapon_bottle') },
	WEAPON_GUSENBERG = { item = 'WEAPON_GUSENBERG', label = _U('weapon_gusenberg') },
	WEAPON_SPECIALCARBINE = { item = 'WEAPON_SPECIALCARBINE', label = _U('weapon_specialcarbine') },
	WEAPON_HEAVYPISTOL = { item = 'WEAPON_HEAVYPISTOL', label = _U('weapon_heavypistol') },
	WEAPON_BULLPUPRIFLE = { item = 'WEAPON_BULLPUPRIFLE', label = _U('weapon_bullpuprifle') },
	WEAPON_DAGGER = { item = 'WEAPON_DAGGER', label = _U('weapon_dagger') },
	WEAPON_VINTAGEPISTOL = { item = 'WEAPON_VINTAGEPISTOL', label = _U('weapon_vintagepistol') },
	WEAPON_FIREWORK = { item = 'WEAPON_FIREWORK', label = _U('weapon_firework') },
	WEAPON_MUSKET = { item = 'WEAPON_MUSKET', label = _U('weapon_musket') },
	WEAPON_HEAVYSHOTGUN = { item = 'WEAPON_HEAVYSHOTGUN', label = _U('weapon_heavyshotgun') },
	WEAPON_MARKSMANRIFLE = { item = 'WEAPON_MARKSMANRIFLE', label = _U('weapon_marksmanrifle') },
	WEAPON_HOMINGLAUNCHER = { item = 'WEAPON_HOMINGLAUNCHER', label = _U('weapon_hominglauncher') },
	WEAPON_PROXMINE = { item = 'WEAPON_PROXMINE', label = _U('weapon_proxmine') },
	WEAPON_SNOWBALL = { item = 'WEAPON_SNOWBALL', label = _U('weapon_snowball') },
	WEAPON_FLAREGUN = { item = 'WEAPON_FLAREGUN', label = _U('weapon_flaregun') },
	WEAPON_GARBAGEBAG = { item = 'WEAPON_GARBAGEBAG', label = _U('weapon_garbagebag') },
	WEAPON_COMBATPDW = { item = 'WEAPON_COMBATPDW', label = _U('weapon_combatpdw') },
	WEAPON_MARKSMANPISTOL = { item = 'WEAPON_MARKSMANPISTOL', label = _U('weapon_marksmanpistol') },
	WEAPON_KNUCKLE = { item = 'WEAPON_KNUCKLE', label = _U('weapon_knuckle') },
	WEAPON_HATCHET = { item = 'WEAPON_HATCHET', label = _U('weapon_hatchet') },
	WEAPON_RAILGUN = { item = 'WEAPON_RAILGUN', label = _U('weapon_railgun') },
	WEAPON_MACHETE = { item = 'WEAPON_MACHETE', label = _U('weapon_machete') },
	WEAPON_MACHINEPISTOL = { item = 'WEAPON_MACHINEPISTOL', label = _U('weapon_machinepistol') },
	WEAPON_SWITCHBLADE = { item = 'WEAPON_SWITCHBLADE', label = _U('weapon_switchblade') },
	WEAPON_REVOLVER = { item = 'WEAPON_REVOLVER', label = _U('weapon_revolver') },
	WEAPON_DBSHOTGUN = { item = 'WEAPON_DBSHOTGUN', label = _U('weapon_dbshotgun') },
	WEAPON_COMPACTRIFLE = { item = 'WEAPON_COMPACTRIFLE', label = _U('weapon_compactrifle') },
	WEAPON_AUTOSHOTGUN = { item = 'WEAPON_AUTOSHOTGUN', label = _U('weapon_autoshotgun') },
	WEAPON_BATTLEAXE = { item = 'WEAPON_BATTLEAXE', label = _U('weapon_battleaxe') },
	WEAPON_COMPACTLAUNCHER = { item = 'WEAPON_COMPACTLAUNCHER', label = _U('weapon_compactlauncher') },
	WEAPON_MINISMG = { item = 'WEAPON_MINISMG', label = _U('weapon_minismg') },
	WEAPON_PIPEBOMB = { item = 'WEAPON_PIPEBOMB', label = _U('weapon_pipebomb') },
	WEAPON_POOLCUE = { item = 'WEAPON_POOLCUE', label = _U('weapon_poolcue') },
	WEAPON_WRENCH = { item = 'WEAPON_WRENCH', label = _U('weapon_wrench') },
	WEAPON_FLASHLIGHT = { item = 'WEAPON_FLASHLIGHT', label = _U('weapon_flashlight') },
	GADGET_NIGHTVISION = { item = 'GADGET_NIGHTVISION', label = _U('gadget_nightvision') },
	GADGET_PARACHUTE = { item = 'GADGET_PARACHUTE', label = _U('gadget_parachute') },
	WEAPON_FLARE = { item = 'WEAPON_FLARE', label = _U('weapon_flare') }, 
	WEAPON_SNSPISTOL_MK2 = { item = 'WEAPON_SNSPISTOL_MK2', label = _U('weapon_snspistol_mk2') }, 
	WEAPON_DOUBLEACTION = { item = 'WEAPON_DOUBLEACTION', label = _U('weapon_doubleaction') },    
	WEAPON_SPECIALCARBINE_MK2 = { item = 'WEAPON_SPECIALCARBINE_MK2', label = _U('weapon_specialcarabine_mk2') },  
	WEAPON_BULLPUPRIFLE_MK2 = { item = 'WEAPON_BULLPUPRIFLE_MK2', label = _U('weapon_bullpruprifle_mk2') },   
	WEAPON_PUMPSHOTGUN_MK2 = { item = 'WEAPON_PUMPSHOTGUN_MK2', label = _U('weapon_pumpshotgun_mk2') },
	WEAPON_MARKSMANRIFLE_MK2 = { item = 'WEAPON_MARKSMANRIFLE_MK2', label = _U('weapon_marksmanrifle_mk2') },  
	WEAPON_ASSAULTRIFLE_MK2 = { item = 'WEAPON_ASSAULTRIFLE_MK2', label = _U('weapon_assaultrifle_mk2') },
	WEAPON_STUNGUN_MP = { item = 'WEAPON_STUNGUN_MP', label = _U('weapon_stungun_mp') },
	WEAPON_CARBINERIFLE_MK2 = { item = 'WEAPON_CARBINERIFLE_MK2', label = _U('weapon_carbinerifle_mk2') },  
	WEAPON_COMBATMG_MK2 = { item = 'WEAPON_COMBATMG_MK2', label = _U('weapon_combatmg_mk2') },   
	WEAPON_HEAVYSNIPER_MK2 = { item = 'WEAPON_HEAVYSNIPER_MK2', label = _U('weapon_heavysniper_mk2') },   
	WEAPON_PISTOL_MK2 = { item = 'WEAPON_PISTOL_MK2', label = _U('weapon_pistol_mk2') }, 
	WEAPON_GADGETPISTOL = { item = 'WEAPON_GADGETPISTOL', label = _U('weapon_gadgetpistol') },
	WEAPON_NAVYREVOLVER = { item = 'WEAPON_NAVYREVOLVER', label = _U('weapon_navyrevolver') }, 
	WEAPON_REVOLVER_MK2 = { item = 'WEAPON_REVOLVER_MK2', label = _U('weapon_revolver_mk2') }, 
	WEAPON_SMG_MK2 = { item = 'WEAPON_SMG_MK2', label = _U('weapon_smg_mk2') }
  }
  
  Config.AmmoTypes = {
	CLIP = { item = 'clip' },
	AMMO_PISTOL = { item = 'pistol_ammo' },
	AMMO_SMG = { item = 'smg_ammo' },
	AMMO_FIREWORK = { item = 'firework_ammo' },
	AMMO_RIFLE = { item = 'rifle_ammo' },
	AMMO_MG = { item = 'mg_ammo' },
	AMMO_SHOTGUN = { item = 'shotgun_ammo' },
	AMMO_STUNGUN = { item = 'stungun_ammo' },
	AMMO_SNIPER = { item = 'sniper_ammo' },
	AMMO_SNIPER_REMOTE = { item = 'sniper_remote_ammo' },
	AMMO_MINIGUN = { item = 'minigun_ammo' },
	AMMO_GRENADELAUNCHER = { item = 'grenadelauncher_ammo' },
	AMMO_GRENADELAUNCHER_SMOKE = { item = 'grenadelauncher_smoke_ammo' },
	AMMO_RPG = { item = 'rpg_ammo' },
	AMMO_STINGER = { item = 'stinger_ammo' },
	AMMO_BALL = { item = 'WEAPON_BALL' },
	AMMO_STICKYBOMB = { item = 'WEAPON_STICKYBOMB' },
	AMMO_SMOKEGRENADE = { item = 'WEAPON_SMOKEGRENADE' },
	AMMO_BZGAS = { item = 'gzgas_ammo' },
	AMMO_FLARE = { item = 'flare_ammo' },
	AMMO_MOLOTOV = { item = 'WEAPON_MOLOTOV' },
	AMMO_TANK = { item = 'tank_ammo' },
	AMMO_SPACE_ROCKET = { item = 'space_rocket_ammo' },
	AMMO_PLANE_ROCKET = { item = 'plane_rocket_ammo' },
	AMMO_PLAYER_LASER = { item = 'player_laser_ammo' },
	AMMO_ENEMY_LASER = { item = 'enemy_laser_ammo' },
	AMMO_BIRD_CRAP = { item = 'bird_crap_ammo' }
  }