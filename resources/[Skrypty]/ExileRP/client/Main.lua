-- GLOBALNE
ESX = nil
playerPed = PlayerPedId()
playerid = PlayerId()
playercoords = GetEntityCoords(playerPed)

Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

CreateThread( function()
    while true do
        playerPed = PlayerPedId()
        playerid = PlayerId()
		playercoords = GetEntityCoords(playerPed)
        Citizen.Wait(500)
    end
end)

SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_LOST"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_HILLBILLY"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_BALLAS"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_MEXICAN"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_FAMILY"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_MARABUNTE"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_SALVA"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AMBIENT_GANG_WEICHENG"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("GANG_1"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("GANG_2"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("GANG_9"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("GANG_10"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("FIREMAN"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("MEDIC"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("COP"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("ARMY"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("DEALER"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("CIVMALE"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("HEN"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("PRIVATE_SECURITY"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("SECURITY_GUARD"), GetHashKey('PLAYER'))
SetRelationshipBetweenGroups(1, GetHashKey("AGGRESSIVE_INVESTIGATE"), GetHashKey('PLAYER'))

CreateThread(function()
    while ESX == nil do
        Wait(100)
        TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)
    end
end)

local strike = 0
local newPlayer = false
 
Config = {
	FirstPersonShoot = true,
	
	DisplayCrosshair = {
		'WEAPON_SNIPERRIFLE',
		'WEAPON_HEAVYSNIPER',
		'WEAPON_HEAVYSNIPER_MK2',
		'WEAPON_MARKSMANRIFLE',
		'WEAPON_MARKSMANRIFLE_MK2'
	},
	
	Pumps = {
		"WEAPON_DBSHOTGUN",
		"WEAPON_SAWNOFFSHOTGUN",
		"WEAPON_PUMPSHOTGUN_MK2",
		"WEAPON_PUMPSHOTGUN"
	},
	
	StashWeapons = {
		{name = 'WEAPON_ASSAULTSMG', label = 'Assault smg', instash=true},
		{name = 'WEAPON_COMBATPDW', label = 'Combat pdw', instash=true},
		{name = 'WEAPON_ASSAULTRIFLE', label = 'Assault rifle', instash=true},
		{name = 'WEAPON_ASSAULTRIFLE_MK2', label = 'Assault rifle MK2', instash=true},
		{name = 'WEAPON_HEAVYRIFLE', label = 'Heavy rifle', instash=true},
		{name = 'WEAPON_FERTILIZERCAN', label = 'Fertilizer Can', instash=true},
		{name = 'WEAPON_EMPLAUNCHER', label = 'EMP Launcher', instash=true},
		{name = 'WEAPON_PIPEBOMB', label = 'Pipe Bomb', instash=true},
		{name = 'WEAPON_CARBINERIFLE', label = 'Carbine rifle', instash=true},
		{name = 'WEAPON_REVOLVER_MK2', label= 'Revolver MK2', instash=true},
		{name = 'WEAPON_ADVANCEDRIFLE', label= 'Zaawansowany Karabin', instash=true},
		{name = 'WEAPON_SPECIALCARBINE', label= 'Special carbine', instash=true},
		{name = 'WEAPON_BULLPUPRIFLE', label='Bullpup Rifle', instash=true},
		{name = 'WEAPON_COMPACTRIFLE', label= 'Compactrifle', instash=true},
		{name = 'WEAPON_PUMPSHOTGUN', label='Pumpshotgun', instash=true},
		{name = 'WEAPON_BULLPUPSHOTGUN', label='Bullpup shotgun', instash=true},
		{name = 'WEAPON_ASSAULTSHOTGUN', label='Assaut shotgun', instash=true},
		{name = 'WEAPON_HEAVYSHOTGUN', label='Heavy shotgun', instash=true},
		{name = 'WEAPON_SAWNOFFSHOTGUN', label='Sawoff shotgun', instash=true},
		{name = 'WEAPON_MILITARYRIFLE', label='Military Rifle', instash=true},
		{name = 'WEAPON_MUSKET', label='Musket', instash=true},
		{name = 'WEAPON_DBSHOTGUN', label='DB shotgun', instash=true},
		{name = 'WEAPON_AUTOSHOTGUN', label='Auto shotgun', instash=true},
		{name = 'WEAPON_COMBATMG', label='Combat smg', instash=true},
		{name = 'WEAPON_MG', label='Mg', instash=true},
		{name = 'WEAPON_SMG', label='SMG', instash=true},
		{name = 'WEAPON_GUSENBERG', label='Gunseberg', instash=true},
		{name = 'WEAPON_HEAVYSNIPER', label='Heavy Sniper', instash=true},
		{name = 'WEAPON_HEAVYSNIPER_MK2', label='Heavy Sniper MK2', instash=true},
		{name = 'WEAPON_HOMINGLAUNCHER', label='Homing Launcher', instash=true},
		{name = 'WEAPON_COMPACTLAUNCHER', label='Compact Launcher', instash=true},
		{name = 'WEAPON_MINISMG', label='MINISMG', instash=true},
	},

	Weapons = {
		[`WEAPON_ADVANCEDRIFLE`] = 1.0,-- 4 hitów advancedrifle
		[`WEAPON_MILITARYRIFLE`] = 1.3,-- 3 hitów militaryrifle
		[`WEAPON_COMBATPDW`] = 0.8,--6 hitów combatpdw
		[`WEAPON_SPECIALCARBINE`] = 0.9,-- 4 hitów specialcarbine
		[`WEAPON_GUSENBERG`] = 1.0,-- 4 hitów gusenberg
		[`WEAPON_COMPACTRIFLE`] = 0.7,-- 5 hitów compactrifle
		[`WEAPON_CARBINERIFLE`] = 1.1,-- 5 hitów carbinerifle
		[`WEAPON_CARBINERIFLE_MK2`] = 1.0,-- 4 hitów carbinerifle_mk2
		[`WEAPON_HEAVYRIFLE`] = 1.25,-- 3 hitów heavyrifle
		[`WEAPON_COMPACTLAUNCHER`] = 2.0,-- 1 hitów rakietnica
		[`WEAPON_HOMINGLAUNCHER`] = 4.0,-- 1 hitów rakietnica
		[`WEAPON_EMPLAUNCHER`] = 0.0,-- 0 hitów
		[`WEAPON_DBSHOTGUN`] = 8.0,-- 1 hitów pompa
		[`WEAPON_SAWNOFFSHOTGUN`] = 3.5,-- 1 hitów pompa
		[`WEAPON_PUMPSHOTGUN`] = 3.5,-- 1 hitów pompa
		[`WEAPON_BULLPUPSHOTGUN`] = 8.0,-- 1 hitów pompa
		[`WEAPON_SMOKEGRENADE`] = 0.0,-- 0 hitów granat
		[`WEAPON_MINIGUN`] = 15.0,-- 1 hitów minigun
		[`WEAPON_MUSKET`] = 5.0,-- 1 hitów muszkiet
		[`WEAPON_SMG`] = 0.9,--6 hitów smg 
		[`WEAPON_MINISMG`] = 0.8,-- 7 hitów minismg
		[`WEAPON_MICROSMG`] = 0.8,-- 7 hitów microsmg
		[`WEAPON_ASSAULTRIFLE`] = 1.2,-- 3 hitów assualtrifle 
		[`WEAPON_ASSAULTRIFLE_MK2`] = 1.2,-- 3 hitów assualtrifle_mk2
		[`WEAPON_GADGETPISTOL`] = 0.2,-- 3 hitów gadgetpistol
		[`WEAPON_HEAVYPISTOL`] = 1.6,-- 4 hitów heavypistol 
		[`WEAPON_REVOLVER`] = 0.8,-- 2 hitów revolver
		[`WEAPON_DOUBLEACTION`] = 1.0,-- 3 hitów double action revolver
		[`WEAPON_MACHINEPISTOL`] = 0.55,-- 7 hitów machinepistol
	},

	Melees = {
		[`WEAPON_NIGHTSTICK`] = 0.4,
		[`WEAPON_UNARMED`] = 0.1,
		[`WEAPON_GOLFCLUB`] = 0.4,
		[`WEAPON_FLASHLIGHT`] = 0.2,
		[`WEAPON_KNUCKLE`] = 0.7,
		[`WEAPON_BAT`] = 0.7,
		[`WEAPON_CROWBAR`] = 0.4,
		[`WEAPON_HAMMER`] = 0.4,
		[`WEAPON_WRENCH`] = 0.4,
		[`WEAPON_DAGGER`] = 1.0,
		[`WEAPON_MACHETE`] = 1.0,
		[`WEAPON_STONE_HATCHET`] = 1.0,
		[`WEAPON_SWITCHBLADE`] = 1.0,
		[`WEAPON_BATTLEAXE`] = 1.0,
		[`WEAPON_HATCHET`] = 1.0,
		[`WEAPON_KNIFE`] = 1.0
	},
	
	WeaponWhitelistEnabled = true,
	WeaponWhitelist = {
		`WEAPON_UNARMED`,
		`GADGET_PARACHUTE`,
		`GADGET_NIGHTVISION`,
		`WEAPON_BALL`,
		`WEAPON_SNOWBALL`,

		`WEAPON_HEAVYSNIPER`,
		`WEAPON_HEAVYSNIPER_MK2`,

		`WEAPON_HOMINGLAUNCHER`,
		`WEAPON_COMPACTLAUNCHER`,

		`WEAPON_FLARE`,
		`WEAPON_FLASHLIGHT`,
		`WEAPON_KNUCKLE`,
		`WEAPON_BAT`,
		`WEAPON_PISTOL_MK2`,
		`WEAPON_GADGETPISTOL`,

		`WEAPON_SWITCHBLADE`,
		`WEAPON_DAGGER`,
		`WEAPON_MACHETE`,
		`WEAPON_BATTLEAXE`,
		`WEAPON_SNSPISTOL`,
		`WEAPON_SNSPISTOL_MK2`,
		`WEAPON_VINTAGEPISTOL`,
		`WEAPON_PISTOL`,
		`WEAPON_DOUBLEACTION`,
		`WEAPON_DBSHOTGUN`,
		`WEAPON_SAWNOFFSHOTGUN`,
		`WEAPON_PUMPSHOTGUN`,
		`WEAPON_PUMPSHOTGUN_MK2`,
		`WEAPON_MICROSMG`,
		`WEAPON_SMG`,
		`WEAPON_MINISMG`,
		`WEAPON_SMG_MK2`,
		`WEAPON_GUSENBERG`,
		`WEAPON_COMPACTRIFLE`,
		`WEAPON_ASSAULTRIFLE`,
		`WEAPON_STUNGUN_MP`,
		`WEAPON_FERTILIZERCAN`,
		`WEAPON_PROXMINE`,
		`WEAPON_HEAVYRIFLE`,
		`WEAPON_EMPLAUNCHER`,
		`WEAPON_RPG`,
		`WEAPON_MARKSMANRIFLE`,
		`WEAPON_MOLOTOV`,
		`WEAPON_STICKYBOMB`,
		`WEAPON_MG`,
		`WEAPON_CERAMICPISTOL`,
		`WEAPON_MACHINEPISTOL`,

		`WEAPON_STICKYBOMB`,
		`WEAPON_BZGAS`,
		`WEAPON_SMOKEGRENADE`,
		`WEAPON_REVOLVER`,

		`WEAPON_STUNGUN`,
		`WEAPON_NIGHTSTICK`,
		`WEAPON_KNIFE`,
		`WEAPON_FLAREGUN`,
		`WEAPON_COMBATPISTOL`,
		`WEAPON_APPISTOL`,
		`WEAPON_HEAVYPISTOL`,
		`WEAPON_COMBATPDW`,
		`WEAPON_ASSAULTSMG`,
		`WEAPON_BULLPUPSHOTGUN`,
		`WEAPON_CARBINERIFLE`,
		`WEAPON_SNIPERRIFLE`,
		`WEAPON_FLASHBANG`,
		`WEAPON_SPECIALCARBINE`,
		`WEAPON_SPECIALCARBINE_MK2`,
		`WEAPON_ASSAULTRIFLE_MK2`,
		`WEAPON_ADVANCEDRIFLE`,
		`WEAPON_PIPEBOMB`,
		`WEAPON_REVOLVER_MK2`,
		`weapon_militaryrifle`,
		`WEAPON_FLASHBANG`,
		`WEAPON_CARBINERIFLE_MK2`,
		
		`WEAPON_FIREEXTINGUISHER`,
		`WEAPON_CROWBAR`,
		`WEAPON_HATCHET`,

		`WEAPON_HAMMER`,
		`WEAPON_WRENCH`,

		`WEAPON_PETROLCAN`,
		`WEAPON_STONE_HATCHET`,
		`WEAPON_GOLFCLUB`,
		`WEAPON_FIREWORK`,
		`WEAPON_MUSKET`,
		`WEAPON_PISTOL50`,

		`WEAPON_NAVYREVOLVER`,
		`weapon_minigun`,
	},
	
	Zones = {
		['AIRP'] = 'Los Santos International Airport',
		['ALAMO'] = 'Alamo Sea',
		['ALTA'] = 'Alta',
		['ARMYB'] = 'Fort Zancudo',
		['BANHAMC'] = 'Banham Canyon Dr',
		['BANNING'] = 'Banning',
		['BEACH'] = 'Vespucci Beach',
		['BHAMCA'] = 'Banham Canyon',
		['BRADP'] = 'Braddock Pass',
		['BRADT'] = 'Braddock Tunnel',
		['BURTON'] = 'Burton',
		['CALAFB'] = 'Calafia Bridge',
		['CANNY'] = 'Raton Canyon',
		['CCREAK'] = 'Cassidy Creek',
		['CHAMH'] = 'Chamberlain Hills',
		['CHIL'] = 'Vinewood Hills',
		['CHU'] = 'Chumash',
		['CMSW'] = 'Chiliad Mountain State Wilderness',
		['CYPRE'] = 'Cypress Flats',
		['DAVIS'] = 'Davis',
		['DELBE'] = 'Del Perro Beach',
		['DELPE'] = 'Del Perro',
		['DELSOL'] = 'La Puerta',
		['DESRT'] = 'Grand Senora Desert',
		['DOWNT'] = 'Downtown',
		['DTVINE'] = 'Downtown Vinewood',
		['EAST_V'] = 'East Vinewood',
		['EBURO'] = 'El Burro Heights',
		['ELGORL'] = 'El Gordo Lighthouse',
		['ELYSIAN'] = 'Elysian Island',
		['GALFISH'] = 'Galilee',
		['GOLF'] = 'GWC and Golfing Society',
		['GRAPES'] = 'Grapeseed',
		['GREATC'] = 'Great Chaparral',
		['HARMO'] = 'Harmony',
		['HAWICK'] = 'Hawick',
		['HORS'] = 'Vinewood Racetrack',
		['HUMLAB'] = 'Humane Labs and Research',
		['JAIL'] = 'Bolingbroke Penitentiary',
		['KOREAT'] = 'Little Seoul',
		['LACT'] = 'Land Act Reservoir',
		['LAGO'] = 'Lago Zancudo',
		['LDAM'] = 'Land Act Dam',
		['LEGSQU'] = 'Legion Square',
		['LMESA'] = 'La Mesa',
		['LOSPUER'] = 'La Puerta',
		['MIRR'] = 'Mirror Park',
		['MORN'] = 'Morningwood',
		['MOVIE'] = 'Richards Majestic',
		['MTCHIL'] = 'Mount Chiliad',
		['MTGORDO'] = 'Mount Gordo',
		['MTJOSE'] = 'Mount Josiah',
		['MURRI'] = 'Murrieta Heights',
		['NCHU'] = 'North Chumash',
		['NOOSE'] = 'N.O.O.S.E',
		['OCEANA'] = 'Pacific Ocean',
		['PALCOV'] = 'Paleto Cove',
		['PALETO'] = 'Paleto Bay',
		['PALFOR'] = 'Paleto Forest',
		['PALHIGH'] = 'Palomino Highlands',
		['PALMPOW'] = 'Palmer-Taylor Power Station',
		['PBLUFF'] = 'Pacific Bluffs',
		['PBOX'] = 'Pillbox Hill',
		['PROCOB'] = 'Procopio Beach',
		['RANCHO'] = 'Rancho',
		['RGLEN'] = 'Richman Glen',
		['RICHM'] = 'Richman',
		['ROCKF'] = 'Rockford Hills',
		['RTRAK'] = 'Redwood Lights Track',
		['SANAND'] = 'San Andreas',
		['SANCHIA'] = 'San Chianski Mountain Range',
		['SANDY'] = 'Sandy Shores',
		['SKID'] = 'Mission Row',
		['SLAB'] = 'Stab City',
		['STAD'] = 'Maze Bank Arena',
		['STRAW'] = 'Strawberry',
		['TATAMO'] = 'Tataviam Mountains',
		['TERMINA'] = 'Terminal',
		['TEXTI'] = 'Textile City',
		['TONGVAH'] = 'Tongva Hills',
		['TONGVAV'] = 'Tongva Valley',
		['VCANA'] = 'Vespucci Canals',
		['VESP'] = 'Vespucci',
		['VINE'] = 'Vinewood',
		['WINDF'] = 'Ron Alternates Wind Farm',
		['WVINE'] = 'West Vinewood',
		['ZANCUDO'] = 'Zancudo River',
		['ZP_ORT'] = 'Port of South Los Santos',
		['ZQ_UAR'] = 'Davis Quartz'
	},

	
	Directions = { [0] = 'N', [45] = 'NW', [90] = 'W', [135] = 'SW', [180] = 'S', [225] = 'SE', [270] = 'E', [315] = 'NE', [360] = 'N' },
	
	CustomStreets = {
		{ start_x = 296.66, start_y = -237.64, end_x = 354.17, end_y = -182.28, name = 'Urzędnicza Street' }
	},

	Visuals = {
		["trafficLight.near.intensity"] = 0.0,
		["trafficLight.near.radius"] = 0.0,
		["trafficLight.near.outerConeAngle"] = 20.0,
		["trafficLight.near.coronaHDR"] = 2.0,
		["trafficLight.near.coronaSize"] = 0.0,
		["trafficLight.farFadeStart"] = 200.0,
		["trafficLight.farFadeEnd"] = 250.0,
		["trafficLight.nearFadeStart"] = 100.0,
		["trafficLight.nearFadeEnd"] = 130.0,
		["car.sirens.ShadowFade"] = 35.0,
		["car.sirens.intensity"] = 75.0,
		["car.sirens.radius"] = 50.0,
		["Tonemapping.dark.filmic.A"] = 0.3,
		["Tonemapping.dark.filmic.B"] = 0.23,
		["Tonemapping.dark.filmic.C"] = 0.2,
		["lodlight.corona.size"] = 1.75,
		["misc.coronas.sizeScaleGlobal"] = 1.25,
		["misc.coronas.intensityScaleGlobal"] = 0.0,
		["misc.coronas.intensityScaleWater"] = 0.0,
		["misc.coronas.sizeScaleWater"] = 0.0,
		["misc.coronas.screenspaceExpansionWater"] = 0.0,
		["misc.coronas.zBiasMultiplier"] = 25.0,
		["misc.coronas.zBias.fromFinalSizeMultiplier"] = 0.1,
		["misc.coronas.underwaterFadeDist"] = 2.0,
		["misc.coronas.screenEdgeMinDistForFade"] = 0.0,
	},
	
	Strefy = {
		{
			Pos = vector3(2850.08, 1469.27, 24.55),
			Radius = 100.0,
			Colour = 1
		},
		{
			Pos = vector3(52.01, 3707.03, 40.2),
			Radius = 100.0,
			Colour = 1
		},
		{
			Pos = vector3(2372.13, 2525.75, 46.65),
			Radius = 100.0,
			Colour = 1
		},
		{
			Pos = vector3(-594.67, 5302.13, 70.21),
			Radius = 100.0,
			Colour = 1
		},
		{
			Pos = vector3(1661.5859, 1.8654, 165.5),
			Radius = 100.0,
			Colour = 1
		},
		{
			Pos = vector3(1441.18, 6338.81, 24.84),
			Radius = 100.0,
			Colour = 1
		},
		{
			Pos = vector3(1903.61, 4922.93, 51.28),
			Radius = 100.0,
			Colour = 1
		},
		{
			Pos = vector3(1539.4294, -2163.582, 77.6644),
			Radius = 100.0,
			Colour = 1
		},
		{
			Pos = vector3(-425.07, -1689.68, 19.02),
			Radius = 100.0,
			Colour = 1
		},
		{
			Pos = vector3(840.55, -2355.71, 30.33),
			Radius = 60.0,
			Colour = 17
		},
		{
			Pos = vector3(904.98, -485.84, 59.44),
			Radius = 60.0,
			Colour = 10
		},
		{
			Pos = vector3(-1980.32, 254.74, 87.21),
			Radius = 60.0,
			Colour = 24
		},
		{
			Pos = vector3(-725.46, -863.49, 26.78),
			Radius = 60.0,
			Colour = 4
		},
		{
			Pos = vector3(-94.0637, -1790.0352, 28.0442),
			Radius = 60.0,
			Colour = 7
		},
		{
			Pos = vector3(333.2, -2038.74, 21.05),
			Radius = 50.0,
			Colour = 5
		},
		{
			Pos = vector3(-19.17, -1398.55, 29.35),
			Radius = 70.0,
			Colour = 2
		},
		{
			Pos = vector3(972.63, -122.37, 74.34),
			Radius = 50.0,
			Colour = 72
		},
		{
			Pos = vector3(1377.49, -1552.52, 56.58),
			Radius = 70.0,
			Colour = 3
		},
		{
			Pos = vector3(-1555.9609, -401.6158, 41.0377),
			Radius = 70.0,
			Colour = 1
		},
		{
			Pos = vector3(449.031, -1894.219, 25.8005),
			Radius = 65.0,
			Colour = 29
		},
		{
			Pos = vector3(1378.9091, -2078.6506, 51.0489),
			Radius = 80.0,
			Colour = 40
		},
		{
			Pos = vector3(-1152.9735, -1526.145, 3.2986),
			Radius = 60.0,
			Colour = 26
		},
	}
	
}

PlayerData = {}
local disableShuffle = true
local can = true
local displayStreet = true

local currentWeather = 'EXTRASUNNY'
local lastweather = currentWeather
local blackout = false

local baseTime = 0
local timeOffset = 0
local timer = 0
local freezeTime = false

local lastPosition = nil
local loadingStatus = 0
local loadingPosition = false
local streetLabel = {}

local isHandcuffed = false
local inProperty = false
local aspectThread = nil

function AddTextEntry(key, value)
	Citizen.InvokeNative(`ADD_TEXT_ENTRY`, key, value)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	PlayerLoaded = true
	if not loadingPosition then
		print('[ExileRP]: PlayerLoaded')
		loadingStatus = 1
		ESX.UI.HUD.SetDisplay(0.0)
		loadingPosition = (xPlayer.coords or {x = -1037.86, y = -2738.11, z = 20.16})

		Citizen.InvokeNative(0x239528EACDC3E7DE, playerid, true)
		Citizen.InvokeNative(0xEA1C610A04DB6BBB, playerPed, false)
		
		FreezeEntityPosition(playerPed, true)
		SetEntityCoords(playerPed, 0, 0, 0)
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx:setGroup')
AddEventHandler('esx:setGroup', function(group)
	ESX.PlayerData.group = group
end)

local DisableShuffle = true
function DisableSeatShuffle(status)
	DisableShuffle = status
end

function SeatShuffle()
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		if GetPedInVehicleSeat(vehicle, 0) == playerPed then
			DisableSeatShuffle(false)
			Citizen.Wait(5000)
			DisableSeatShuffle(true)
		else
			TaskShuffleToNextVehicleSeat(playerPed, vehicle)
		end
	end
end

RegisterCommand("shuff", function(source, args, raw) 
    SeatShuffle()
end, false)

RegisterCommand("duty", function(source, args, raw)
    TriggerServerEvent("komendaduty:onoff")
end, false)

RegisterCommand("clearnui", function()
	StopAudioScene("MP_LEADERBOARD_SCENE")
    SetNuiFocus(false, false)
	SendNUIMessage({type = 'close'})
end)

CreateThread(function()
	while true do
		Citizen.Wait(2)
		DisplayAmmoThisFrame(false)

		AllowPauseMenuWhenDeadThisFrame()
		DisablePlayerVehicleRewards(playerid)	
		N_0x7669f9e39dc17063()
		Citizen.InvokeNative(0xC54A08C85AE4D410, 0.5)
		for _, iter in ipairs({1, 2, 3, 4, 6, 7, 8, 9, 13, 17, 18, 19}) do -- 6
			HideHudComponentThisFrame(iter)
		end

		DisableControlAction(0, 37)
		
		HudWeaponWheelIgnoreSelection()

		local currentWeaponHash = GetSelectedPedWeapon(playerPed)

		if currentWeaponHash == 100416529 then
			isSniper = true
		elseif currentWeaponHash == 205991906 then
			isSniper = true
		elseif currentWeaponHash == -952879014 then
			isSniper = true
		elseif currentWeaponHash == `WEAPON_HEAVYSNIPER_MK2` then
			isSniper = true
		else
			isSniper = false
		end

		if can and Config.FirstPersonShoot then
			if not isSniper then
				if not IsPedInAnyVehicle(playerPed, false) then
					HideHudComponentThisFrame(14)
					elseif IsPedInAnyVehicle(playerPed, false) and IsVehicleModel(GetVehiclePedIsIn(playerPed), `lazer`) == false then
					HideHudComponentThisFrame(14)
				end
			end
		end
	end
end)

CreateThread(function()
	while true do 
		Citizen.Wait(3)
		if DoesEntityExist(playerPed) then
			DisableControlAction(1, 157)
			DisableControlAction(1, 158)
			DisableControlAction(1, 160)
			DisableControlAction(1, 164)
			DisableControlAction(1, 165)
			EnableControlAction(0, 37)
			if IsPedArmed(playerPed, 6) then
				DisableControlAction(1, 140, true)
				DisableControlAction(1, 141, true)
				DisableControlAction(1, 142, true)
			end
		else
			Citizen.Wait(500)
		end
   	end
end)

CreateThread(function()
    local SCENARIO_TYPES = {
        "WORLD_VEHICLE_MILITARY_PLANES_SMALL", 
        "WORLD_VEHICLE_MILITARY_PLANES_BIG",
		"WORLD_VEHICLE_POLICE_BIKE",
		"WORLD_VEHICLE_POLICE_CAR",
		"WORLD_VEHICLE_POLICE",
		"WORLD_VEHICLE_POLICE_NEXT_TO_CAR",
		"WORLD_VEHICLE_AMBULANCE",
    }
    local SCENARIO_GROUPS = {
        2017590552, 
        2141866469, 
        1409640232, 
        "ng_planes", 
    }
    local SUPPRESSED_MODELS = {
        "SHAMAL", 
        "LUXOR", 
        "LUXOR2", 
        "JET", 
        "LAZER",
        "TITAN", 
        "BARRACKS",
        "BARRACKS2", 
        "CRUSADER", 
        "RHINO",
        "AIRTUG",
        "RIPLEY", 
        'FROGGER',
        'MAVERICK',
        'SWIFT',
        'SWIFT2',
    }

    while true do
        for _, sctyp in next, SCENARIO_TYPES do
            SetScenarioTypeEnabled(sctyp, false)
        end
        for _, scgrp in next, SCENARIO_GROUPS do
            SetScenarioGroupEnabled(scgrp, false)
        end
        for _, model in next, SUPPRESSED_MODELS do
            SetVehicleModelIsSuppressed(GetHashKey(model), true)
        end
        Wait(10000)
    end
end)

local recoils = {
	[`WEAPON_STUNGUN`] = {0.1, 1.1}, -- STUN GUN
	[`WEAPON_STUNGUN_MP`] = {0.1, 1.1}, -- STUN GUN
	[`WEAPON_FLAREGUN`] = {0.9, 1.9}, -- FLARE GUN

	[`WEAPON_SNSPISTOL`] = {3.2, 4.2}, -- SNS PISTOL
	[`WEAPON_SNSPISTOL_MK2`] = {2.7, 3.7}, -- SNS PISTOL MK2
	[`WEAPON_NAVYREVOLVER`] = {2.7, 3.7}, -- SNS PISTOL MK2
	[`WEAPON_GADGETPISTOL`] = {2.7, 3.7}, -- SNS PISTOL MK2
	[`WEAPON_VINTAGEPISTOL`] = {3.0, 4.0}, -- VINTAGE PISTOL
	[`WEAPON_PISTOL`] = {3.0, 4.0}, -- PISTOL
	[`WEAPON_PISTOL_MK2`] = {3.0, 4.0}, -- PISTOL MK2
	[`WEAPON_DOUBLEACTION`] = {3.0, 3.5}, -- DOUBLE ACTION REVOLVER
	[`WEAPON_REVOLVER`] = {3.0, 3.5}, -- DOUBLE ACTION REVOLVER
	[`WEAPON_REVOLVER_MK2`] = {3.0, 3.5}, -- DOUBLE ACTION REVOLVER
	[`WEAPON_COMBATPISTOL`] = {3.5, 4.0}, -- COMBAT PISTOL
	[`WEAPON_HEAVYPISTOL`] = {2.6, 3.1}, -- HEAVY PISTOL
	[`WEAPON_PISTOL50`] = {2.9, 3.4}, -- 50 PISTOL
	[`WEAPON_CERAMICPISTOL`] = {2.7, 3.7}, -- Ceramicpistol

	[`WEAPON_DBSHOTGUN`] = {0.1, 0.6}, -- DOUBLE BARREL SHOTGUN
	[`WEAPON_SAWNOFFSHOTGUN`] = {2.1, 2.6}, -- SAWNOFF SHOTGUN
	[`WEAPON_PUMPSHOTGUN`] = {8.7, 10.2}, -- PUMP SHOTGUN
	[`WEAPON_PUMPSHOTGUN_MK2`] = {2.7, 3.2}, -- PUMP SHOTGUN MK2
	[`WEAPON_BULLPUPSHOTGUN`] = {1.5, 2.0}, -- BULLPUP SHOTGUN

	[`WEAPON_MINISMG`] = {0.01, 0.03}, -- MINISMG
	[`WEAPON_SMG_MK2`] = {0.01, 0.01}, -- SMG MK2

	[`WEAPON_ASSAULTSMG`] = {0.04, 0.14}, -- ASSAULT SMG
	[`WEAPON_COMBATPDW`] = {0.01, 0.03}, -- COMBAT PDW
	[`WEAPON_GUSENBERG`] = {0.005, 0.005}, -- GUSENBERG
	[`WEAPON_ASSAULTRIFLE_MK2`] = {0.005, 0.005}, -- GUSENBERG
	[`WEAPON_CARBINERIFLE_MK2`] = {0.005, 0.005}, -- GUSENBERG

	[`WEAPON_COMPACTRIFLE`] = {0.01, 0.05}, -- COMPACT RIFLE
	[`WEAPON_ASSAULTRIFLE`] = {0.05, 0.1}, -- ASSAULT RIFLE
	[`WEAPON_EMPLAUNCHER`] = {0.15, 0.25}, -- ASSAULT RIFLE
	[`WEAPON_HEAVYRIFLE`] = {0.20, 0.34}, -- ASSAULT RIFLE
	[`WEAPON_CARBINERIFLE`] = {0.20, 0.34}, -- CARBINE RIFLE

	[`WEAPON_MARKSMANRIFLE`] = {0.5, 1.0}, -- MARKSMAN RIFLE
	[`WEAPON_SNIPERRIFLE`] = {0.5, 1.0}, -- SNIPER RIFLE
}

local recoilsOGHaze = {
	[`WEAPON_STUNGUN`] = {0.1, 1.1}, -- STUN GUN
	[`WEAPON_STUNGUN_MP`] = {0.1, 1.1}, -- STUN GUN
	[`WEAPON_FLAREGUN`] = {0.9, 1.9}, -- FLARE GUN

	[`WEAPON_SNSPISTOL`] = {2.2, 3.2}, -- SNS PISTOL
	[`WEAPON_SNSPISTOL_MK2`] = {1.7, 2.7}, -- SNS PISTOL MK2
	[`WEAPON_NAVYREVOLVER`] = {1.7, 2.7}, -- SNS PISTOL MK2
	[`WEAPON_GADGETPISTOL`] = {1.7, 2.7}, -- SNS PISTOL MK2
	[`WEAPON_VINTAGEPISTOL`] = {2.0, 3.0}, -- VINTAGE PISTOL
	[`WEAPON_PISTOL`] = {2.2, 3.2}, -- PISTOL
	[`WEAPON_PISTOL_MK2`] = {2.2, 3.2}, -- PISTOL MK2
	[`WEAPON_DOUBLEACTION`] = {2.0, 2.5}, -- DOUBLE ACTION REVOLVER
	[`WEAPON_REVOLVER_MK2`] = {2.0, 2.5}, -- DOUBLE ACTION REVOLVER
	[`WEAPON_REVOLVER`] = {2.0, 2.5}, -- DOUBLE ACTION REVOLVER
	[`WEAPON_COMBATPISTOL`] = {2.5, 3.0}, -- COMBAT PISTOL
	[`WEAPON_HEAVYPISTOL`] = {0.5, 1.0}, -- HEAVY PISTOL
	[`WEAPON_PISTOL50`] = {2.9, 3.4}, -- 50 PISTOL
	[`WEAPON_CERAMICPISTOL`] = {1.7, 2.7}, -- Ceramicpistol

	[`WEAPON_DBSHOTGUN`] = {0.1, 0.6}, -- DOUBLE BARREL SHOTGUN
	[`WEAPON_SAWNOFFSHOTGUN`] = {2.1, 2.6}, -- SAWNOFF SHOTGUN
	[`WEAPON_PUMPSHOTGUN`] = {8.7, 10.2}, -- PUMP SHOTGUN
	[`WEAPON_PUMPSHOTGUN_MK2`] = {2.7, 3.2}, -- PUMP SHOTGUN MK2
	[`WEAPON_BULLPUPSHOTGUN`] = {1.5, 2.0}, -- BULLPUP SHOTGUN

	[`WEAPON_MICROSMG`] = {0.01, 0.05}, -- MICRO SMG (UZI)
	[`WEAPON_SMG`] = {0.01, 0.01}, -- SMG
	[`WEAPON_MINISMG`] = {0.05, 0.55}, -- MINISMG
	[`WEAPON_SMG_MK2`] = {0.001, 0.01}, -- SMG MK2
	[`WEAPON_ASSAULTSMG`] = {0.04, 0.54}, -- ASSAULT SMG
	[`WEAPON_COMBATPDW`] = {0.01, 0.02}, -- COMBAT PDW
	[`WEAPON_GUSENBERG`] = {0.075, 0.575}, -- GUSENBERG
	[`WEAPON_ASSAULTRIFLE_MK2`] = {0.075, 0.575}, -- GUSENBERG
	[`WEAPON_CARBINERIFLE_MK2`] = {0.075, 0.575}, -- GUSENBERG

	[`WEAPON_COMPACTRIFLE`] = {0.01, 0.03}, -- COMPACT RIFLE
	[`WEAPON_ASSAULTRIFLE`] = {0.1, 0.4}, -- ASSAULT RIFLE
	[`WEAPON_EMPLAUNCHER`] = {0.35, 0.75}, -- ASSAULT RIFLE
	[`WEAPON_HEAVYRIFLE`] = {0.40, 0.74}, -- ASSAULT RIFLE
	[`WEAPON_CARBINERIFLE`] = {0.40, 0.74}, -- CARBINE RIFLE

	[`WEAPON_MARKSMANRIFLE`] = {0.5, 1.0}, -- MARKSMAN RIFLE
	[`WEAPON_SNIPERRIFLE`] = {0.5, 1.0}, -- SNIPER RIFLE
}

local effects = {
	[`WEAPON_STUNGUN`] = {0.01, 0.02}, -- STUN GUN
	[`WEAPON_STUNGUN_MP`] = {0.01, 0.02}, -- STUN GUN
	[`WEAPON_FLAREGUN`] = {0.01, 0.02}, -- FLARE GUN

	[`WEAPON_SNSPISTOL`] = {0.08, 0.16}, -- SNS PISTOL
	[`WEAPON_SNSPISTOL_MK2`] = {0.07, 0.14}, -- SNS PISTOL MK2
	[`WEAPON_NAVYREVOLVER`] = {0.07, 0.14}, -- SNS PISTOL MK2
	[`WEAPON_GADGETPISTOL`] = {0.07, 0.14}, -- SNS PISTOL MK2
	[`WEAPON_VINTAGEPISTOL`] = {0.08, 0.16}, -- VINTAGE PISTOL
	[`WEAPON_PISTOL`] = {0.10, 0.20}, -- PISTOL
	[`WEAPON_PISTOL_MK2`] = {0.11, 0.22}, -- PISTOL MK2
	[`WEAPON_CERAMICPISTOL`] = {0.07, 0.14}, -- Ceramicpistol
	[`WEAPON_DOUBLEACTION`] = {0.1, 0.2}, -- DOUBLE ACTION REVOLVER
	[`WEAPON_REVOLVER_MK2`] = {0.1, 0.2}, -- DOUBLE ACTION REVOLVER
	[`WEAPON_REVOLVER`] = {0.1, 0.2}, -- DOUBLE ACTION REVOLVER
	[`WEAPON_COMBATPISTOL`] = {0.1, 0.2}, -- COMBAT PISTOL
	[`WEAPON_HEAVYPISTOL`] = {0.1, 0.2}, -- HEAVY PISTOL
	[`WEAPON_PISTOL50`] = {0.1, 0.2}, -- 50 PISTOL

	[`WEAPON_DBSHOTGUN`] = {0.1, 0.2}, -- DOUBLE BARREL SHOTGUN
	[`WEAPON_SAWNOFFSHOTGUN`] = {0.095, 0.19}, -- SAWNOFF SHOTGUN
	[`WEAPON_PUMPSHOTGUN`] = {0.09, 0.18}, -- PUMP SHOTGUN
	[`WEAPON_PUMPSHOTGUN_MK2`] = {0.09, 0.18}, -- PUMP SHOTGUN MK2
	[`WEAPON_BULLPUPSHOTGUN`] = {0.085, 0.19}, -- BULLPUP SHOTGUN

	[`WEAPON_MICROSMG`] = {0.05, 0.1}, -- MICRO SMG (UZI)
	[`WEAPON_SMG`] = {0.01, 0.1}, -- SMG
	[`WEAPON_MINISMG`] = {0.05, 0.08}, -- MINISMG
	[`WEAPON_SMG_MK2`] = {0.01, 0.01}, -- SMG MK2
	[`WEAPON_ASSAULTSMG`] = {0.035, 0.07}, -- ASSAULT SMG
	[`WEAPON_COMBATPDW`] = {0.01, 0.02}, -- COMBAT PDW
	[`WEAPON_GUSENBERG`] = {0.035, 0.07}, -- GUSENBERG
	[`WEAPON_ASSAULTRIFLE_MK2`] = {0.035, 0.07}, -- GUSENBERG

	[`WEAPON_COMPACTRIFLE`] = {0.03, 0.08}, -- COMPACT RIFLE
	[`WEAPON_ASSAULTRIFLE`] = {0.023, 0.064}, -- ASSAULT RIFLE
	[`WEAPON_EMPLAUNCHER`] = {0.023, 0.064}, -- ASSAULT RIFLE
	[`WEAPON_HEAVYRIFLE`] = {0.03, 0.06}, -- ASSAULT RIFLE
	[`WEAPON_CARBINERIFLE`] = {0.03, 0.06}, -- CARBINE RIFLE

	[`WEAPON_MARKSMANRIFLE`] = {0.025, 0.05}, -- MARKSMAN RIFLE
	[`WEAPON_SNIPERRIFLE`] = {0.025, 0.05}, -- SNIPER RIFLE	

	[`WEAPON_FIREWORK`] = {0.5, 1.0} -- FIREWORKS
}

local drugged = false
function DisableEffects()
	drugged = true
end

function EnableEffects()
	drugged = false
end

CreateThread(function()
	while true do
		Citizen.Wait(0)
		if DoesEntityExist(playerPed) and Config.FirstPersonShoot then
			local status, weapon = GetCurrentPedWeapon(playerPed, true)
			if status == 1 then
				if weapon == 'WEAPON_FIREEXTINGUISHER' then
					Citizen.InvokeNative(0x3EDCB0505123623B, playerPed, true, 'WEAPON_FIREEXTINGUISHER')
				elseif IsPedShooting(playerPed) then
					if can then
						local inVehicle = IsPedInAnyVehicle(playerPed, false)							
						local recoil = recoils[weapon]
						if recoil and #recoil > 0 then
							local i, tv = (inVehicle and 2 or 1), 0
							if GetFollowPedCamViewMode() ~= 4 then
								repeat
									SetGameplayCamRelativePitch(GetGameplayCamRelativePitch() + 0.1, 0.2)
									tv = tv + 0.1
									Citizen.Wait(0)
								until tv >= recoil[i]
							else
								repeat
									local t = GetRandomFloatInRange(0.1, recoil[i])
									SetGameplayCamRelativePitch(GetGameplayCamRelativePitch() + t, (recoil[i] > 0.1 and 1.2 or 0.333))
									tv = tv + t
									Citizen.Wait(0)
								until tv >= recoil[i]
							end
						end
						if not drugged then	
							local effect = effects[weapon]
							if effect and #effect > 0 then
								ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', (inVehicle and (effect[1] * 3) or effect[2]))
							end
						end
					end
				end
			else
				Citizen.Wait(250)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

CreateThread(function()
	AddTextEntry('FE_THDR_GTAO', 'ExileRP WL OFF ~s~| ~b~ID: ' .. GetPlayerServerId(playerid))
	while true do
		Citizen.Wait(100)	
		if IsPedBeingStunned(playerPed) then
			SetPedMinGroundTimeForStungun(playerPed, 6000)
		end
		
		local melee = Config.Melees[weapon]
		if melee then
			SetPlayerMeleeWeaponDamageModifier(playerid, melee)
		else
			SetPlayerMeleeWeaponDamageModifier(playerid, 1.0)
		end		
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(1)
		local show, weapon = false, GetSelectedPedWeapon(playerPed)
		for _, model in ipairs(Config.DisplayCrosshair) do
			if weapon == GetHashKey(model) then
				show = true
				break
			end
		end
		
		local aiming, shooting = IsControlPressed(0, 25), IsPedShooting(playerPed)
		local inVehicle = IsPedInAnyVehicle(playerPed, false)
		if not show then
			if Config.FirstPersonShoot then
				local aiming, shooting = IsControlPressed(0, 25), IsPedShooting(playerPed)
				if aiming or shooting then
					if shooting and not aiming then
						isShooting = true
						aimTimer = 0
					else
						isShooting = false
					end
					if not isAiming then
						isAiming = true

						lastCamera = GetFollowPedCamViewMode()
						if lastCamera ~= 4 then
							SetFollowPedCamViewMode(4)
						end
					elseif GetFollowPedCamViewMode() ~= 4 then
						SetFollowPedCamViewMode(4)
					end
				elseif isAiming then
					local off = true
					if isShooting then
						off = false

						aimTimer = aimTimer + 20
						if aimTimer == 3000 then
							isShooting = false
							aimTimer = 0
							off = true
						end
					end
					if off then
						isAiming = false
						if lastCamera ~= 4 then
							SetFollowPedCamViewMode(lastCamera)
						end
					end
				elseif not inVehicle then
					DisableControlAction(0, 24, true)
					DisableControlAction(0, 140, true)
					DisableControlAction(0, 141, true)
					DisableControlAction(0, 142, true)
					DisableControlAction(0, 257, true)
					DisableControlAction(0, 263, true)
					DisableControlAction(0, 264, true)
				end
			end
		else
			Wait(250)
		end
	end
end)

local Radar, Vehicles = {
	shown = false,
	info = "~r~BRAK",
	info2 = "~r~BRAK",
	zamroz = "~g~Radar gotowy do działania! Naciśnij [Num8] aby zamrozić",
	odmroz = "~b~Radar zamrożony! Naciśnij [Num8] aby odmrozić",
	state = "~g~Radar gotowy do działania! Naciśnij [Num8] aby zamrozić",
	plate = nil,
	plate2 = nil,
	model = nil,
	model2 = nil,
}, {}

function DrawAdvancedText(x, y, w, h, sc, text, r, g, b, a, font, jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
    N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - 0.1 + w, y - 0.02 + h)
end

CreateThread(function()
	Citizen.Wait(5000)
	TriggerEvent('esx_vehicleshop:getVehicles', function(base)
		Vehicles = base
	end)

	Radar.state = "~g~Radar gotowy do działania! Naciśnij [Num8] aby zamrozić"

	while true do
		Citizen.Wait(0)
		if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
			if IsControlJustPressed(1, 128) and (IsPedInAnyPoliceVehicle(playerPed) or (IsVehicleModel(GetVehiclePedIsIn(playerPed, false), `police65`))) and not IsPedInAnyHeli(playerPed) then
				if Radar.shown then
					Radar.shown = false
					Radar.info = "~r~BRAK"
					Radar.info2 = "~r~BRAK"
					Radar.zamroz = "~g~Radar gotowy do działania! Naciśnij [Num8] aby zamrozić"
					Radar.odmroz = "~b~Radar zamrożony! Naciśnij [Num8] aby odmrozić"
					Radar.state = "~g~Radar gotowy do działania! Naciśnij [Num8] aby zamrozić"
					Radar.plate = nil
					Radar.plate2 = nil
					Radar.model = nil
					Radar.model2 = nil
				else
					Radar.shown = true
				end

				Citizen.Wait(75)
			end

			if IsControlJustPressed(1, 127) and Radar.shown then
				Radar.freeze = not Radar.freeze
			end

			if IsControlJustPressed(1, 124) and Radar.plate then
				TriggerEvent('esx_sprawdz:blachy', Radar.plate:gsub("%s$", ""), Radar.model)
			end

			if IsControlJustPressed(1, 125) and Radar.plate2 then
				TriggerEvent('esx_sprawdz:blachy', Radar.plate2:gsub("%s$", ""), Radar.model2)
			end

			if Radar.shown then
				if not Radar.freeze then
					Radar.state = Radar.zamroz
					local veh = GetVehiclePedIsIn(playerPed, false)
					local coordA = GetOffsetFromEntityInWorldCoords(veh, 0.0, 1.0, 1.0)

					local coordB = GetOffsetFromEntityInWorldCoords(veh, 0.0, 60.0, 0.0)
					local frontcar = StartShapeTestCapsule(coordA, coordB, 3.0, 10, veh, 7)
					local a, b, c, d, e = GetShapeTestResult(frontcar)
					
					local vehicleModel = GetEntityModel(e)
						
					if IsEntityAVehicle(e) then
						local fmodel = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(e)))
						if fmodel == 'NULL' then				
							local found = false
							for _, veh in ipairs(Vehicles) do
								if GetHashKey(veh.model) == vehicleModel then
									fmodel = veh.name
									found = true
									break
								end
							end

							if not found then							
								fmodel = GetDisplayNameFromVehicleModel(GetEntityModel(e))
							end
						end

						Radar.vehicle = e
						Radar.plate = GetVehicleNumberPlateText(e)
						Radar.model = fmodel
						Radar.info = string.format("~b~Nr rej.: ~w~%s  ~b~Model: ~w~%s  ~b~Prędkość: ~w~%s km/h", Radar.plate, fmodel, math.floor(GetEntitySpeed(e) * 3.6 + 0.5))
					end
						
					local bcoordB = GetOffsetFromEntityInWorldCoords(veh, 0.0, -105.0, 0.0)
					local rearcar = StartShapeTestCapsule(coordA, bcoordB, 3.0, 10, veh, 7)
					local f, g, h, i, j = GetShapeTestResult(rearcar)
					
					local vehicleModel = GetEntityModel(j)

					if IsEntityAVehicle(j) and j ~= Radar.vehicle2 then
						local bmodel = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(j)))
						if bmodel == 'NULL' then				
							local found = false
							for _, veh in ipairs(Vehicles) do
								if GetHashKey(veh.model) == vehicleModel then
									bmodel = veh.name
									found = true
									break
								end
							end

							if not found then
								bmodel = GetDisplayNameFromVehicleModel(GetEntityModel(j))
							end
						end

						Radar.vehicle2 = j
						Radar.plate2 = GetVehicleNumberPlateText(j)
						Radar.model2 = bmodel
						Radar.info2 = string.format("~b~Nr rej.: ~w~%s  ~b~Model: ~w~%s  ~b~Prędkość: ~w~%s km/h", Radar.plate2, bmodel, math.floor(GetEntitySpeed(j) * 3.6 + 0.5))
					end
				else
					Radar.state = Radar.odmroz
				end

				DrawAdvancedText(0.602, 0.870, 0.005, 0.0028, 0.4, Radar.state, 255, 255, 255, 255, 6, 0)
				DrawAdvancedText(0.602, 0.903, 0.005, 0.0028, 0.4, "~g~RADAR - Front ([Num4] aby sprawdzić bazę)", 0, 191, 255, 255, 6, 0)
				DrawAdvancedText(0.602, 0.953, 0.005, 0.0028, 0.4, "~g~RADAR - Tył ([Num6] aby sprawdzić bazę)", 0, 191, 255, 255, 6, 0)
				DrawAdvancedText(0.602, 0.928, 0.005, 0.0028, 0.4, Radar.info, 255, 255, 255, 255, 6, 0)
				DrawAdvancedText(0.602, 0.979, 0.005, 0.0028, 0.4, Radar.info2, 255, 255, 255, 255, 6, 0)
			end

			if not IsPedInAnyVehicle(playerPed) then
				Radar.shown = false
				Radar.vehicle = nil
				Radar.vehicle2 = nil
				Radar.plate = nil
				Radar.plate2 = nil
			end
		else
			Citizen.Wait(5000)
		end
	end
end)

RegisterNetEvent('esx_sprawdz:blachy')
AddEventHandler('esx_sprawdz:blachy', function(plate, model)
	ESX.ShowAdvancedNotification('ExileRP', plate, '~y~Pojazd: ~s~'..model..'\n~y~Właściciel: ~s~Wyszukiwanie')
	Wait(2000)

	ESX.TriggerServerCallback('esx_misiaczek:getVehicleFromPlate', function(data)
		CreateThread(function()			
			local poszukiwany = '~r~Nie'
			if data.poszukiwany then
				PlaySound(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
				poszukiwany = '~g~Tak'
			end
			
		
			local str = "Data urodzenia: ~y~"..data.dob.."~s~\n"
			str = str .. "Wzrost: ~y~"..data.height .. "~s~\n"
			str = str .. "Płeć: ~y~" ..data.sex

			TriggerEvent("FeedM:showAdvancedNotification", data.owner, '~s~Poszukiwany: ' ..poszukiwany, str, 'CHAR_BANK_MAZE', 10000)
		end)
		
	end, plate)
end)

CreateThread(function()
	while true do
		Citizen.Wait(60000)
		
		ESX.TriggerServerCallback("esx_scoreboard:getConnectedCops", function(MisiaczekPlayers)
			if MisiaczekPlayers then
				SetDiscordAppId(671452818502057990)

				SetDiscordRichPresenceAsset('logo')
				name = GetPlayerName(playerid)
				id = GetPlayerServerId(playerid)
				SetDiscordRichPresenceAssetText("ID: "..id.." | "..name.." ")
				SetRichPresence("ID: "..id.." | "..name.." | "..MisiaczekPlayers['players'].."/"..MisiaczekPlayers['maxPlayers'])
				SetDiscordRichPresenceAction(1, "Discord!", "https://discord.gg/exilerp")
				SetDiscordRichPresenceAction(0, "Zagraj z nami!", "fivem://connect/jbjjop")
			end
		end)
	end
end)

CreateThread(function()
    while true do
        Citizen.Wait(1000)
		for _, ped in ipairs(ESX.Game.GetPeds()) do
			SetPedDropsWeaponsWhenDead(ped, false)
		end
		SetWeaponDrops()
		ClearAreaOfCops(playercoords.x, playercoords.y, playercoords.z, 400.0)
    end
end)

function SetWeaponDrops()
	local handle, ped = FindFirstPed()
	local finished = false

	repeat
		if not IsEntityDead(ped) then
			SetPedDropsWeaponsWhenDead(ped, false)
		end
		finished, ped = FindNextPed(handle)
	until not finished

	EndFindPed(handle)
end

AddEventHandler('skinchanger:modelLoaded', function()
	ModelLoaded()
end)

AddEventHandler('misiaczek:newplayer', function()
	newPlayer = true
	ModelLoaded()
end)

function ModelLoaded()
	if loadingPosition ~= true and loadingStatus < 2 then
		print('[ExileRP]: ModelLoaded')
		CreateThread(function()
			while not loadingPosition do
				Citizen.Wait(0)
			end
			
			Citizen.Wait(1000)
			loadingStatus = 2
			SendLoadingScreenMessage(json.encode({allow = true}))
		end)
	end
end

CreateThread(function()
	SetManualShutdownLoadingScreenNui(false)
	StartAudioScene("MP_LEADERBOARD_SCENE")
	SendLoadingScreenMessage(json.encode({ready = true}))

	TriggerEvent('chat:display', false)
	while true do
		Citizen.Wait(0)
		if loadingStatus == 2 and (IsControlJustPressed(0, 18) or IsDisabledControlPressed(0, 18)) then
			StartWyspa()
			print('[ExileRP]: Wczytano')
			break
		end
	end
end)

RegisterCommand('play', function(source, args, raw)
	if loadingStatus == 2 then
		CreateThread(StartWyspa)
	end
end, false)

function StartWyspa()
	Citizen.InvokeNative(0xABA17D7CE615ADBF, "FMMC_STARTTRAN")
	Citizen.InvokeNative(0xBD12F8228410D9B4, 4)
	PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

	local ped = PlayerPedId()
	SetEntityCoords(ped, loadingPosition.x, loadingPosition.y, loadingPosition.z)
	FreezeEntityPosition(ped, false)

	Citizen.InvokeNative(0xEA1C610A04DB6BBB, ped, true)
	Citizen.InvokeNative(0x239528EACDC3E7DE, PlayerId(), false)
	StopAudioScene("MP_LEADERBOARD_SCENE")

	DoScreenFadeOut(0)	
	ShutdownLoadingScreen()
	ShutdownLoadingScreenNui()

	SetPedMaxHealth(ped, 200)
	Citizen.InvokeNative(0x6B76DC1F3AE6E6A3, ped, 200)

	loadingPosition = true
	loadingStatus = 3
	Citizen.Wait(1000)

	DoScreenFadeIn(1000)
	while IsScreenFadingIn() do
		Citizen.Wait(0)
	end

	Citizen.Wait(2000)

	ESX.UI.HUD.SetDisplay(1.0)
	
	TriggerEvent('chat:clear')
	TriggerEvent('wybranopostac', true)
	TriggerEvent('route68:kino_state', false)
	Citizen.InvokeNative(0x10D373323E5B9C0D)
	
	if newPlayer then
		TriggerEvent('esx_skin:openSaveableMenu')
	end
	TriggerEvent("csskrouble:connected")
end

AddEventHandler('misiaczek:load', function(cb)
	cb(loadingStatus)
end)

function DisplayingStreet()
	return displayStreet
end

function _DrawText(x, y, width, height, scale, text, r, g, b, a)
	SetTextFont(4)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()

	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width / 2, y - height / 2 + 0.005)
end

AddEventHandler('ExileRP:setDisplayStreet', function(val)
	displayStreet = val
end)

function GetStreetsCustom(coords)
	for _, street in ipairs(Config.CustomStreets) do
		if coords.x >= street.start_x and coords.x <= street.end_x and coords.y >= street.start_y and coords.y <= street.end_y then
			return "~y~" .. street.name
		end
	end

	local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
	local street1, street2 = GetStreetNameFromHashKey(s1), GetStreetNameFromHashKey(s2)
	return "~y~" .. street1 .. (street2 ~= "" and "~s~ / " .. street2 or "")
end

CreateThread(function()
	while true do
		SetBlackout(blackout)
		if lastWeather ~= currentWeather then
			lastWeather = currentWeather
			SetWeatherTypeOverTime(currentWeather, 30.0)
			Citizen.Wait(30000)
		end

		Citizen.Wait(100)
		ClearOverrideWeather()
		ClearWeatherTypePersist()

		SetWeatherTypePersist(lastWeather)
		SetWeatherTypeNow(lastWeather)
		SetWeatherTypeNowPersist(lastWeather)

		if lastWeather == 'XMAS' then
			SetForceVehicleTrails(true)
			SetForcePedFootstepsTracks(true)
		else
			SetForceVehicleTrails(false)
			SetForcePedFootstepsTracks(false)
		end
	end
end)

RegisterNetEvent('misiaczek:updateWeather')
AddEventHandler('misiaczek:updateWeather', function(_weather, _blackout)
	currentWeather = _weather
	blackout = _blackout
end)

RegisterNetEvent('misiaczek:updateTime')
AddEventHandler('misiaczek:updateTime', function(base, offest, freeze)
	freezeTime = freeze
	timeOffset = offest
	baseTime = base
end)

CreateThread(function()
	for i = 1, 15 do
		EnableDispatchService(i, false)
	end

	while true do
		Citizen.Wait(2)
		
		local inVehicle = IsPedInAnyVehicle(playerPed, false)
		if inVehicle then
			local vehicle = GetVehiclePedIsIn(playerPed, false)
				
			if GetPedInVehicleSeat(vehicle, -1) ~= playerPed then
				if DisableShuffle and GetPedInVehicleSeat(vehicle, 0) == playerPed and GetIsTaskActive(playerPed, 165) then
					SetPedIntoVehicle(playerPed, vehicle, 0)
				end
			end
		end
		
		if not IsPedArmed(playerPed, 1) and GetSelectedPedWeapon(playerPed) ~= `WEAPON_UNARMED` then
			SetPlayerLockon(playerId, false)
		else
			SetPlayerLockon(playerId, true)
		end

		SetPlayerHealthRechargeMultiplier(playerPed, 0.0)
		
		SetPedDensityMultiplierThisFrame(0.99)
		SetScenarioPedDensityMultiplierThisFrame(0.99, 0.99)
		SetRandomVehicleDensityMultiplierThisFrame(0.04)
		SetParkedVehicleDensityMultiplierThisFrame(0.02)
		SetVehicleDensityMultiplierThisFrame(0.06)

		SetCreateRandomCops(false)
		SetCreateRandomCopsNotOnScenarios(false)
		SetCreateRandomCopsOnScenarios(false)
		SetGarbageTrucks(false)
		SetRandomBoats(false)

		if inProperty then
			ClearAreaOfPeds(playercoords.x, playercoords.y, playercoords.z, 10.0, 0)
		end
	end
end)

CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/weather', 'Zmień pogode.', {{ name="Pogoda", help="Dostępne: extrasunny, clear, neutral, smog, foggy, overcast, clouds, clearing, rain, thunder, snow, blizzard, snowlight, xmas & halloween"}})
    TriggerEvent('chat:addSuggestion', '/freezeweather', 'Zamroź/odmroź opcje Dynamic Weather.')
    TriggerEvent('chat:addSuggestion', '/blackout', 'Zmień tryb blackout.')
	StatSetProfileSetting(226, 0)	
	for key, value in pairs(Config.Visuals) do
		SetVisualSettingFloat(key, value)
	end
	while not Citizen.InvokeNative(0xB8DFD30D6973E135, playerid) do
		Citizen.Wait(100)
	end
	
	TriggerServerEvent('misiaczek:playerConnected')
end)

local skinbag = nil
local time = 7000
local nbrDisplaying = 0
local tookWeapon = false
local LoadedIn = false
local timeout = false

CreateThread(function()
	while true do
		Citizen.Wait(18000)
		if not LoadedIn then
			LoadedIn = true
		end
	end
end)

local function timeOut()
    SetTimeout(4100, function()
        timeout = false
    end)
end


CreateThread(function()
	local wyslane = true
	while true do
		Citizen.Wait(100)

		if GetSelectedPedWeapon(playerPed) ~= nil then
			
			for i=1, #Config.StashWeapons, 1 do
				local weaponHash = GetHashKey(Config.StashWeapons[i].name)
				local weaponName = Config.StashWeapons[i].label
				if weaponHash == GetSelectedPedWeapon(playerPed) and not tookWeapon and GetSelectedPedWeapon(playerPed) ~= WeaponfromTrunk then
					tookWeapon = true
					wyslane = false
					WeaponfromTrunk = GetSelectedPedWeapon(playerPed)
					TriggerServerEvent('esx_bron:komunikat', 'wyciąga broń długą')
				end
			end
		end

		if GetSelectedPedWeapon(playerPed) ~= WeaponfromTrunk then
			WeaponfromTrunk = nil
			tookWeapon = false
			if not wyslane then
				wyslane = true
				TriggerServerEvent('esx_bron:komunikat', 'chowa broń długą')
			end
		end
		currentWeapon = GetSelectedPedWeapon(playerPed)
		if currentWeapon ~= -1569615261 and currentWeapon ~= 883325847 and currentWeapon ~= 966099553 and not IsPedInAnyVehicle(playerPed, 1) and LoadedIn then
			if not tookWeapon or WeaponfromTrunk ~= GetSelectedPedWeapon(playerPed) then
				tookWeapon = true
				WeaponfromTrunk = GetSelectedPedWeapon(playerPed)
			end
		end
	end
end)

local speaking = false
CreateThread(function()
	RequestAnimDict("amb@code_human_police_investigate@idle_a")
	while not HasAnimDictLoaded("amb@code_human_police_investigate@idle_a") do		
		Citizen.Wait(0)
	end

	while true do
		Citizen.Wait(0)
		if not IsPauseMenuActive() and PlayerData.job ~= nil and (PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'sheriff') then 
			if DoesEntityExist(playerPed) and not IsEntityDead(playerPed) and not IsEntityInWater(playerPed) and IsEntityVisible(playerPed)then
				if IsControlJustReleased(0, 244) or IsDisabledControlJustReleased(0, 82) and not exports['esx_policejob']:IsCuffed() then
					 ESX.TriggerServerCallback('gcphone:getItemAmount', function(qtty)
						if qtty > 0 then
							TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 8.0, 'off', 0.05)
							ClearPedTasks(playerPed)
							speaking = false
							TriggerServerEvent("csskrouble:walkieTalkie", true)
						end
					end, 'radio')
				else
					if IsControlJustPressed(0, 244) or IsDisabledControlJustPressed(0, 82) or (IsControlPressed(0, 249) and IsDisabledControlJustPressed(0, 81)) and not exports['esx_policejob']:IsCuffed() then
						ESX.TriggerServerCallback('gcphone:getItemAmount', function(qtty)
							if qtty > 0 then
								TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 8.0, 'on', 0.05)
								TaskPlayAnim(playerPed, "amb@code_human_police_investigate@idle_a", "idle_b", 8.0, -8, -1, 49, 0, 0, 0, 0 )
								SetCurrentPedWeapon(playerPed, `GENERIC_RADIO_CHATTER`, true)
								speaking = true
								TriggerServerEvent("csskrouble:walkieTalkie", true)
							end
						end, 'radio')
					end 

					if speaking then
						DisableControlAction(1, 140, true)
						DisableControlAction(1, 141, true)
						DisableControlAction(1, 142, true)
						DisablePlayerFiring(playerPed, true)
					end
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

CreateThread(function()
	local pausing = false
	while true do
		Citizen.Wait(255)
		
		local direction = nil
		for k, v in pairs(Config.Directions) do
			direction = GetEntityHeading(playerPed)
			if math.abs(direction - k) < 22.5 then
				direction = v
				break
			end
		end
		
		local coords = GetEntityCoords(ped, true)
		
		inProperty = exports['esx_property']:isProperty()
		isHandcuffed = exports['esx_policejob']:IsCuffed()

		local vehicle = nil
		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		end

		local status, weapon = GetCurrentPedWeapon(playerPed, true)
		if status == 1 then

			local mul = Config.Weapons[weapon]
			if mul then
				SetPlayerWeaponDamageModifier(playerid, mul)
			else
				mul = Config.Melees[weapon]
				if mul then
					SetPlayerMeleeWeaponDamageModifier(playerid, mul)
				else
					SetPlayerWeaponDamageModifier(playerid, 1.0)
					SetPlayerMeleeWeaponDamageModifier(playerid, 1.0)
				end
			end

			if Config.WeaponWhitelistEnabled then
				local found = false
				for _, model in ipairs(Config.WeaponWhitelist) do
					if weapon == model then
						found = true
						break
					end
				end

				if not found and GetWeapontypeModel(weapon) ~= 0 then
					strike = strike + 1
					if strike >= 6 then
						TriggerServerEvent('exile:sendnibba', "XD", "Wykryto zablokowane bronie: "..strike.." razy.", 'ExileRP')
						Citizen.InvokeNative(0x4899CB088EDF59B8, playerPed, weapon)
					else
						TriggerServerEvent('exile_logs:triggerLog', "Wykryto zablokowaną broń: " .. weapon, 'weapons')
						Citizen.InvokeNative(0x4899CB088EDF59B8, playerPed, weapon)
					end
				end
			end
		else
			SetPlayerMeleeWeaponDamageModifier(playerid, Config.Melees[`WEAPON_UNARMED`])
		end
	end
end)

function weather()
    CreateThread(function()
        while true do
            SetWeatherTypePersist("HALLOWEEN")
            SetWeatherTypeNowPersist("HALLOWEEN")
            SetWeatherTypeNow("HALLOWEEN")
            SetOverrideWeather("HALLOWEEN")
            Citizen.Wait(0)
        end
    end)
end
local vehicleRollThresh = 60
local vehicleClassDisable = {
    [0] = true,     --compacts
    [1] = true,     --sedans
    [2] = true,     --SUV's
    [3] = true,     --coupes
    [4] = true,     --muscle
    [5] = true,     --sport classic
    [6] = true,     --sport
    [7] = true,     --super
    [8] = false,    --motorcycle
    [9] = true,     --offroad
    [10] = true,    --industrial
    [11] = true,    --utility
    [12] = true,    --vans
    [13] = false,   --bicycles
    [14] = false,   --boats
    [15] = false,   --helicopter
    [16] = false,   --plane
    [17] = true,    --service
    [18] = true,    --emergency
    [19] = false    --military
}

CreateThread(function()
    while true do
        Citizen.Wait(0)
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        local vehicleClass = GetVehicleClass(vehicle)
        if ((GetPedInVehicleSeat(vehicle, -1) == playerPed) and vehicleClassDisable[vehicleClass]) then
			if not IsEntityInAir(vehicle) then
				local vehicleRoll = GetEntityRoll(vehicle)
				if (math.abs(vehicleRoll) > vehicleRollThresh) then
					DisableControlAction(2, 59)
					DisableControlAction(2, 60)
				end
            end
        else
            Wait(250)
        end
    end
end)

local blackBars = false
RegisterNetEvent('route68:kino_state')
AddEventHandler('route68:kino_state', function(rodzaj)
	if rodzaj then
		blackBars = true
		ESX.UI.HUD.SetDisplay(0.0)
		TriggerEvent('chat:toggleChat', true)
		TriggerServerEvent('misiaczek:kino', true)
		TriggerEvent('hungerthirst:hud_state', true)
		TriggerEvent('bodycam:state', true)
		TriggerEvent('esx_status:setDisplay', 0.0)
		TriggerEvent('esx_voice:setDisplay', 0.0)
		TriggerEvent('radar:setHidden', true)
		TriggerEvent('carhud:display', false)
		TriggerEvent('esx_customui:toggle', false)
		TriggerEvent('misiaczek_dzwon:display', false)
	elseif rodzaj == false then
		blackBars = false
		ESX.UI.HUD.SetDisplay(1.0)
		TriggerEvent('chat:toggleChat', false)
		TriggerEvent('hungerthirst:hud_state', false)
		TriggerEvent('bodycam:state', false)
		TriggerEvent('esx_status:setDisplay', 1.0)
		TriggerEvent('esx_voice:setDisplay', 1)
		TriggerEvent('radar:setHidden', false)
		TriggerEvent('carhud:display', true)
		TriggerEvent('misiaczek_dzwon:display', true)
		TriggerEvent('esx_customui:toggle', true)
	end
end)

RegisterNetEvent('route68:kino')
AddEventHandler('route68:kino', function()
	cam = not cam
	
	if cam then
		blackBars = true
		ESX.UI.HUD.SetDisplay(0.0)
		TriggerEvent('chat:toggleChat', true)
		TriggerServerEvent('misiaczek:kino', true)
		TriggerEvent('hungerthirst:hud_state', true)
		TriggerEvent('bodycam:state', true)
		TriggerEvent('esx_status:setDisplay', 0.0)
		TriggerEvent('radar:setHidden', true)
		TriggerEvent('carhud:display', false)
		TriggerEvent('exile:pasy', false)
		TriggerEvent('esx_customui:toggle', false)
	elseif not cam then
		blackBars = false
		ESX.UI.HUD.SetDisplay(1.0)
		TriggerEvent('chat:toggleChat', false)
		TriggerEvent('hungerthirst:hud_state', false)
		TriggerEvent('bodycam:state', false)
		TriggerEvent('esx_status:setDisplay', 1.0)
		TriggerEvent('radar:setHidden', false)
		TriggerEvent('carhud:display', true)
		TriggerEvent('exile:pasy', true)
		TriggerEvent('esx_customui:toggle', true)
	end
end)

CreateThread(function()
    while true do
        Citizen.Wait(0)
        if blackBars then
            DrawRect(1.0, 1.0, 2.0, 0.25, 0, 0, 0, 255)
            DrawRect(1.0, 0.0, 2.0, 0.25, 0, 0, 0, 255)
		else
			Citizen.Wait(333)
		end
    end
end)

local holstered = false
local hand = false
local weapons = {
    --BRON BIALA--
    "WEAPON_DAGGER",
    "WEAPON_BAT",
    "WEAPON_BOTTLE",
    "WEAPON_CROWBAR",
    "WEAPON_FLASHLIGHT",
    "WEAPON_GOLFCLUB",
    "WEAPON_HAMMER",
    "WEAPON_HATCHET",
    "WEAPON_KNIFE",
    "WEAPON_MACHETE",
    "WEAPON_NIGHTSTICK",
    "WEAPON_WRENCH",
    "WEAPON_BATTLEAXE",
    "WEAPON_POOLCUE",
    "WEAPON_STONE_HATCHET",

    --PISTOLETY--
    "WEAPON_PISTOL",
    "WEAPON_PISTOL_MK2",
	"WEAPON_NAVYREVOLVER",
    "WEAPON_COMBATPISTOL",
    "WEAPON_APPISTOL",
    "WEAPON_STUNGUN",
    "WEAPON_PISTOL50",
    "WEAPON_SNSPISTOL",
    "WEAPON_SNSPISTOL_MK2",
    "WEAPON_HEAVYPISTOL",
    "WEAPON_VINTAGEPISTOL",
    "WEAPON_FLAREGUN",
    "WEAPON_MARKSMANPISTOL",
	"WEAPON_SMOKEGRENADE",
	"WEAPON_NAVYREVOLVER",
	"WEAPON_GADGETPISTOL",
	"WEAPON_STUNGUN_MP",
    "WEAPON_REVOLVER",
    "WEAPON_REVOLVER_MK2",
    
    --MACHINE PISTOLE--
    "WEAPON_MICROSMG",
    "WEAPON_SMG",
    "WEAPON_SMG_MK2",
    "WEAPON_ASSAUTSMG",
    "WEAPON_COMBATPDW",
    "WEAPON_MACHINEPISTOL",
    "WEAPON_MINISMG",
    
   --POMPY-- 
    "WEAPON_PUMPSHOTGUN",
    "WEAPON_PUMPSHOTGUN_MK2",
    "WEAPON_SAWNOFFSHOTGUN",
    "WEAPON_ASSAULTSHOTGUN",
    "WEAPON_BULLPUPSHOTGUN",
    "WEAPON_MUSKET",
    "WEAPON_HEAVYSHOTGUN",
    "WEAPON_DBSHOTGUN",
    "WEAPON_AUTOSHOTGUN",

    --DLUGIE--
    "WEAPON_ASSAULTRIFLE",
	"weapon_bullpuprifle",
	"WEAPON_PIPEBOMB",
	"WEAPON_PROXMINE",
    "WEAPON_ASSAULTRIFLE_MK2",
	"WEAPON_HEAVYRIFLE",
	"WEAPON_FERTILIZERCAN",
	"WEAPON_EMPLAUNCHER",
    "WEAPON_CARBINERIFLE",
    "WEAPON_ADVANCEDRIFLE",
	"WEAPON_REVOLVER_MK2",
    "WEAPON_CARBINERIFLE_MK2",
    "WEAPON_MILITARYRIFLE",
    "WEAPON_SPECIALRIFLE",
    "WEAPON_SPECIALRIFLE_MK2",
    "WEAPON_BULLPUPRIFLE",
    "WEAPON_BULLPUPRIFLE_MK2",
    "WEAPON_COMPACTRIFLE",
    "WEAPON_MG",
    "WEAPON_COMBATMG",
    "WEAPON_COMBATMG_MK2",
    "WEAPON_GUSENBERG",
	"WEAPON_RPG",

    --SNIPERKI--
    "WEAPON_SNIPERRIFLE",
    "WEAPON_HEAVYSNIPER",
    "WEAPON_HEAVYSNIPER_MK2",
	"WEAPON_HOMINGLAUNCHER",
	"WEAPON_COMPACTLAUNCHER",
    "WEAPON_MARKSMANRIFLE",
    "WEAPON_MARKSMANRIFLE_MK2",

    --DODATKOWE--
    "WEAPON_GRANADE",
    "WEAPON_BZGAS",
    "WEAPON_MOLOTOV",
    "WEAPON_STICKYBOMB",
    "WEAPON_PROXMINE",
    "WEAPON_SNOWBALL",
    "WEAPON_BALL",

    "WEAPON_FLARE",
	"WEAPON_FIREEXTINGUISHER",
	"WEAPON_STICKYBOMB",

}

local simples = {
	`WEAPON_STUNGUN`,
	`WEAPON_FLAREGUN`,

	`WEAPON_SNSPISTOL`,
	`WEAPON_SNSPISTOL_MK2`,
	`WEAPON_VINTAGEPISTOL`,
	`WEAPON_PISTOL`,
	`WEAPON_PISTOL_MK2`,
	`WEAPON_GADGETPISTOL`,
	`WEAPON_DOUBLEACTION`,
	`WEAPON_COMBATPISTOL`,
	`WEAPON_APPISTOL`,
	`WEAPON_HEAVYPISTOL`,
	`WEAPON_CERAMICPISTOL`,
	`WEAPON_SNOWBALL`,
	`WEAPON_BALL`,
	`WEAPON_FLARE`,
	`WEAPON_FLASHLIGHT`,
	`WEAPON_KNUCKLE`,
	`WEAPON_SWITCHBLADE`,
	`WEAPON_NIGHTSTICK`,
	`WEAPON_KNIFE`,
	`WEAPON_DAGGER`,
	`WEAPON_MACHETE`,
	`WEAPON_HAMMER`,
	`WEAPON_WRENCH`,
	`WEAPON_CROWBAR`,
	`WEAPON_FERTILIZERCAN`,
	'WEAPON_REVOLVER',
	'WEAPON_REVOLVER_MK2',
	`WEAPON_STUNGUN_MP`,

	`WEAPON_STICKYBOMB`,
	`WEAPON_MOLOTOV`,
	`WEAPON_COMPACTLAUNCHER`,
	`WEAPON_DBSHOTGUN`,
	`WEAPON_SAWNOFFSHOTGUN`,
	`WEAPON_MICROSMG`,
	`WEAPON_SMG_MK2`,

	`WEAPON_NAVYREVOLVER`,
}

local types = {
	[2] = true,
	[3] = true,
	[5] = true,
	[6] = true,
	[10] = true,
	[12] = true
}

local holstered = 0
CreateThread(function()
	RequestAnimDict("rcmjosh4")
	while not HasAnimDictLoaded("rcmjosh4") do
		Citizen.Wait(0)
	end

	RequestAnimDict("reaction@intimidation@1h")
	while not HasAnimDictLoaded("reaction@intimidation@1h") do
		Citizen.Wait(0)
	end

	RequestAnimDict("weapons@pistol@")
	while not HasAnimDictLoaded("weapons@pistol@") do
		Citizen.Wait(0)
	end

	while true do
		Citizen.Wait(125)
		if DoesEntityExist(playerPed) and not IsEntityDead(playerPed) and not IsPedInAnyVehicle(playerPed, false) then
			local weapon = GetSelectedPedWeapon(playerPed)
			if weapon ~= `WEAPON_UNARMED` then
				if holstered == 0 then
					local t = 0
					if `WEAPON_SWITCHBLADE` == weapon then
						t = 1
					elseif CheckSimple(weapon) then
						TaskPlayAnim(playerPed, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 5, 0, 0, 0)
						t = 1
					elseif types[GetWeaponDamageType(weapon)] then
						TaskPlayAnim(playerPed, "reaction@intimidation@1h", "intro", 3.0,1.0, -1, 48, 0, 0, 0, 0)
						SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED` , true)
						t = 2
					end

					holstered = weapon
					if t > 0 then
						if t == 1 then
							Citizen.Wait(600)
						elseif t == 2 then
							Citizen.Wait(1000)
							SetCurrentPedWeapon(playerPed, weapon, true)
							Citizen.Wait(1500)
						end

						ClearPedTasks(playerPed)
					end
				elseif holstered ~= weapon then
					local t, h = 0, false
					if `WEAPON_SWITCHBLADE` == holstered then
						Citizen.Wait(1500)
						ClearPedTasks(playerPed)

						if CheckSimple(weapon) then
							TaskPlayAnim(playerPed, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 5, 0, 0, 0)
							t = 600
						elseif types[GetWeaponDamageType(weapon)] then
							TaskPlayAnim(playerPed, "reaction@intimidation@1h", "intro", 3.0,1.0, -1, 48, 0, 0, 0, 0)
							SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED` , true)
							h = true
							t = 1000
						end
					elseif `WEAPON_SWITCHBLADE` == weapon then
						t = 600
					elseif CheckSimple(holstered) and CheckSimple(weapon) then
						TaskPlayAnim(playerPed, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 5, 0, 0, 0)
						t = 600
					elseif types[GetWeaponDamageType(holstered)] and types[GetWeaponDamageType(weapon)] then
						TaskPlayAnim(playerPed, "reaction@intimidation@1h", "intro", 3.0,1.0, -1, 48, 0, 0, 0, 0)
						SetCurrentPedWeapon(playerPed, holstered, true)
						h = true
						t = 1000
					end

					holstered = weapon
					if t > 0 then
						Citizen.Wait(t)
						if h then
							SetCurrentPedWeapon(playerPed, weapon, true)
							Citizen.Wait(1500)
						end

						ClearPedTasks(playerPed)
					end
				end
			elseif holstered ~= 0 then
				local t, h = 0, false
				if `WEAPON_DOUBLEACTION` == holstered or `WEAPON_SWITCHBLADE` == holstered then
					t = 1500
				elseif CheckSimple(holstered) then
					TaskPlayAnim(playerPed, "weapons@pistol@", "aim_2_holster", 8.0, 2.0, -1, 48, 5, 0, 0, 0)
					t = 600
				elseif types[GetWeaponDamageType(holstered)] then
					TaskPlayAnim(playerPed, "reaction@intimidation@1h", "outro", 8.0,2.0, -1, 48, 1, 0, 0, 0)
					SetCurrentPedWeapon(playerPed, holstered, true)
					h = true
					t = 1500
				end

				holstered = 0
				if t > 0 then
					Citizen.Wait(t)
					if h then
						SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED` , true)
					end

					ClearPedTasks(playerPed)
				end
			end
		end
	end
end)

function CheckSimple(weapon)
	for _, simple in ipairs(simples) do
		if simple == weapon then
			return true
		end
	end

	return false
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(50)
    end
end


CreateThread(function()
	while hand do
		Citizen.Wait(0)
		DisableControlAction(0,24,true) -- disable attack
		DisableControlAction(0,25,true) -- disable aim
		DisableControlAction(0,47,true) -- disable weapon
		DisableControlAction(0,58,true) -- disable weapon
		DisableControlAction(0,263,true) -- disable melee
		DisableControlAction(0,264,true) -- disable melee
		DisableControlAction(0,257,true) -- disable melee
		DisableControlAction(0,140,true) -- disable melee
		DisableControlAction(0,141,true) -- disable melee
		DisableControlAction(0,142,true) -- disable melee
		DisableControlAction(0,143,true) -- disable melee
	end
end)

CreateThread(function()
    while true do
		Citizen.Wait(500)
		if IsPedOnFoot(playerPed) then 
			SetRadarZoom(1100)
		elseif IsPedInAnyVehicle(playerPed, true) then
			SetRadarZoom(1100)
		end
    end
end)

CreateThread(function()
    Citizen.Wait(1000)
	for i=1, #Config.Strefy, 1 do
		local blip = AddBlipForRadius(Config.Strefy[i].Pos, Config.Strefy[i].Radius)
		
		SetBlipHighDetail(blip, true)
		SetBlipColour(blip, Config.Strefy[i].Colour)
		SetBlipAlpha(blip, 150)
		SetBlipAsShortRange(blip, true)
	end
end)

local wait = false

RegisterCommand("propfix", function()
	if GetEntityHealth(playerPed) > 0 and not exports["esx_ambulancejob"]:isDead() then
		if not IsPedCuffed(playerPed) then
		if not IsPedSittingInAnyVehicle(playerPed) then
			if not wait then
					TriggerEvent('skinchanger:getSkin', function(skin)
					wait = true
					Citizen.Wait(50)
					local armour = Citizen.InvokeNative(0x9483AF821605B1D8, playerPed)
					local health = Citizen.InvokeNative(0xEEF059FAD016D209, playerPed)
					if skin.sex == 0 then
							TriggerEvent('skinchanger:loadSkin', {sex=1})
							Citizen.Wait(1000)
							TriggerEvent('skinchanger:loadSkin', {sex=0})
					elseif skin.sex == 1 then
							TriggerEvent('skinchanger:loadSkin', {sex=0})
							Citizen.Wait(1000)
							TriggerEvent('skinchanger:loadSkin', {sex=1})
					end
					--TriggerServerEvent('exile_logs:triggerLog', "Użył komendy /propfix", 'propfix')
					Citizen.Wait(1000)
					ESX.ShowNotification('Załadowano ~g~HP / ARMOR ~w~sprzed użycia ~g~/propfix')
					TriggerEvent("csskrouble:save")
					Citizen.InvokeNative(0x6B76DC1F3AE6E6A3, playerPed, health)
					Citizen.InvokeNative(0xCEA04D83135264CC, playerPed, armour)
					Citizen.Wait(300000)
					wait = false
					end)
				else
					ESX.ShowNotification('~r~Nie możesz tak często używać tej komendy!')
				end
			else
				ESX.ShowNotification('~r~Nie możesz używać propfixa w aucie')
			end
		else
			ESX.ShowNotification('~r~Nie możesz używać tej komendy podczas BW.')
		end
	else
		ESX.ShowNotification('~r~Nie możesz używać tej komendy podczas bycia zakutym.')
	end
end)

if not IsDuplicityVersion() then

	local _decorExists, _drawMarker = DecorExistOn, DrawMarker
	function DrawMarker(...)
		if playerPed and not _decorExists(playerPed, "misiaczek:marker") then
			_drawMarker(...)
		end
	end

	local _getVehicleNumberPlateText = GetVehicleNumberPlateText
	function GetVehicleNumberPlateText(vehicle, unveil)
		local plate = _getVehicleNumberPlateText(vehicle)
		if plate and unveil and plate:gsub("^%s*(.-)%s*$", "%1") == "" and _decorExists(vehicle, "misiaczek:plate") then
			return exports['esx_plates']:GetPlate(DecorGetInt(vehicle, "misiaczek:plate"))
		end

		return plate
	end
end

local HUD = {
	Blip = nil,
  }
  
CreateThread(function()
	SetMapZoomDataLevel(0, 0.96, 0.9, 0.08, 0.0, 0.0)
	SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0)
	SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0)
	SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0)
	SetMapZoomDataLevel(4, 22.3, 0.9, 0.08, 0.0, 0.0)

	SetBlipAlpha(GetMainPlayerBlipId(), 0)
	SetBlipAlpha(GetNorthRadarBlip(), 0)
	while true do
		Citizen.Wait(500)
		local ped = PlayerPedId()
		local heading = GetEntityHeading(ped)
		local vehicle = IsPedInAnyVehicle(ped, false)
		if HUD.Blip and DoesBlipExist(HUD.Blip) then
			RemoveBlip(HUD.Blip)
		end

		HUD.Blip = AddBlipForEntity(ped)
		SetBlipSprite(HUD.Blip, (vehicle and 545 or 1))

		SetBlipScale(HUD.Blip, 1.0)
		SetBlipCategory(HUD.Blip, 1)
		SetBlipPriority(HUD.Blip, 10)
		SetBlipColour(HUD.Blip, 55)
		SetBlipAsShortRange(HUD.Blip, true)

		SetBlipRotation(HUD.Blip, math.ceil(heading))
		ShowHeadingIndicatorOnBlip(HUD.Blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Twoja pozycja")
		EndTextCommandSetBlipName(HUD.Blip)
	end
end)