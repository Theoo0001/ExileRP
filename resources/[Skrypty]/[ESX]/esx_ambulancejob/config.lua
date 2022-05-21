Config                            = {}
Config.DrawDistance               = 15.0
Config.MarkerColor                = { r = 56, g = 197, b = 201 }
Config.MarkerSize                 = { x = 1.5, y = 1.5, z = 1.0 }
Config.Sprite  = 489
Config.Display = 4
Config.Scale   = 1.0
Config.Colour  = 19
Config.ReviveReward               = 1500
Config.AntiCombatLog              = true
Config.LoadIpl                    = false
Config.Locale = 'en'
Config.RespawnToHospitalDelay		= 300000
 
bedNames = {
	'v_med_bed2',
}
 
Config.CenaNaprawki = 3500
 
local second = 1000
local minute = 60 * second
 
-- How much time before auto respawn at hospital
Config.RespawnDelayAfterRPDeath   = 5 * minute
 
Config.EnablePlayerManagement       = true
Config.EnableSocietyOwnedVehicles   = false
 
Config.RemoveWeaponsAfterRPDeath    = true
Config.RemoveCashAfterRPDeath       = true
Config.RemoveItemsAfterRPDeath      = true
 
-- Will display a timer that shows RespawnDelayAfterRPDeath as a countdown
Config.ShowDeathTimer               = false
 
-- Will allow respawn after half of RespawnDelayAfterRPDeath has elapsed.
Config.EarlyRespawn                 = false
-- The player will be fined for respawning early (on bank account)
Config.EarlyRespawnFine                  = false
Config.EarlyRespawnFineAmount            = 500
 
Config.RespawnPlaceLS = vector3(365.85, -610.97, 28.79)
Config.RespawnPlaceSANDY = vector3(1836.2681, 3671.073, 33.3267)
Config.RespawnPlacePALETO = vector3(-247.4772, 6330.8159, 31.4761)
 
Config.Blips = {
	{
		coords = vector3(1817.81 , 3671.48, 44.64)
	},
	{
		coords = vector3(1143.64 , -1542.54, 51.71)
	},
	{
		coords = vector3(-253.73 , 6322.73, 39.56)
	}
}
 
Config.OnlySamsBlip = {
	{
		Pos     = { x = -718.77, y = -1326.51, z = 1.5 },
		Sprite  = 427,
		Display = 4,
		Scale   = 0.6,
		Colour  = 3
	},
	{
		Pos     = { x = 2836.1272, y = -732.8671, z = 0.416 },
		Sprite  = 427,
		Display = 4,
		Scale   = 0.6,
		Colour  = 3
	},
	{
		Pos     = { x = -3420.7292, y = 955.541, z = 7.3967 },
		Sprite  = 427,
		Display = 4,
		Scale   = 0.6,
		Colour  = 3
	},
	{
		Pos     = { x = 3373.7449, y = 5183.4521, z = 0.5102 },
		Sprite  = 427,
		Display = 4,
		Scale   = 0.6,
		Colour  = 3
	},
	{
		Pos     = { x = 1736.29, y = 3976.24, z = 31.98 },
		Sprite  = 427,
		Display = 4,
		Scale   = 0.6,
		Colour  = 3
	},
	{
		Pos	= { x = -285.01, y = 6627.6, z = 7.2 },
		Sprite  = 427,
		Display = 4,
		Scale   = 0.6,
		Colour  = 3
	},
}
 
Config.VehicleGroups = {
	'PATROL', -- 1
	'TRANSPORT', -- 2
	'DODATKOWE', -- 3
}
 
-- https://wiki.rage.mp/index.php?title=Vehicles
Config.AuthorizedVehicles = {
	{
		grade = 0,
		model = 'pd_dirtbike',
		label = 'Cross',
		groups = {3},
		livery = 2,
		extrason = {},
		extrasoff = {},
	},
		{
			grade = 0,
			model = 'ms_coach',
			label = 'Autobus',
			groups = {2},
			livery = 0,
			extrason = {1,3,4,5,6,7},
			extrasoff = {2},
			tint = 1,
		},
		{
			grade = 4,
			model = 'ms_explorer',
			label = 'Ford Explorer',
			groups = {1},
			livery = 0,
			extrason = {1,3,4,5,6,7},
			extrasoff = {2},
			tint = 1,
		},
		{
			grade = 2,
			model = 'ms_jeep',
			label = 'Jeep Cherokee',
			groups = {1},
			livery = 0,
			extrason = {1,3,4,5,6,7},
			extrasoff = {2},
			tint = 1,
		},
		{
			grade = 2,
			model = 'ms_impala',
			label = 'Chevrolet Imapala',
			groups = {1},
			livery = 0,
			extrason = {1,3,4,5,6,7},
			extrasoff = {2},
			tint = 1,
		},
		{
			grade = 6,
			model = 'ms_charger',
			label = 'Dodge Charger 2018',
			groups = {1},
			livery = 0,
			extrason = {1,3,4,5,6,7},
			extrasoff = {2},
			tint = 1,
		},
		{
			grade = 10,
			model = 'ms_m5',
			label = 'BMW M5',
			groups = {1},
			livery = 0,
			extrason = {1,3,4,5,6,7},
			extrasoff = {2},
			tint = 1,
		},
		{
			grade = 4,
			model = 'ms_raptor',
			label = 'Ford Raptor',
			groups = {1},
			livery = 0,
			extrason = {1,2,3},
			extrasoff = {4,5},
		},
		{
			grade = 4,
			model = 'ms_tahoe21',
			label = 'Chevrolet Tahoe 21',
			groups = {1},
			livery = 0,
			extrason = {1,2,3},
			extrasoff = {4,5},
		},
		{
			grade = 5,
			model = 'ms_tundra',
			label = 'Toyota Tundra',
			groups = {1},
			livery = 0,
			extrason = {1,2,3},
			extrasoff = {4,5},
		},
		{
			grade = 3,
			model = 'ms_ram19',
			label = 'Dodge Ram',
			groups = {1},
			livery = 0,
			extrason = {1,2,3},
			extrasoff = {4,5},
		},
		{
			grade = 1,
			model = 'ms_tahoe',
			label = 'Chevrolet Tahoe 19',
			groups = {1},
			livery = 0,
			extrason = {1,2,3},
			extrasoff = {4,5},
		},
		{
			grade = 0,
			model = 'ms_transformer',
			label = 'Ford F350',
			groups = {1},
			livery = 0,
			extrason = {1,2},
			extrasoff = {},
		},
		{
			grade = 1,
			model = 'ms_outlander',
			label = 'Quad',
			groups = {3},
			livery = 0,
			extrason = {1},
			extrasoff = {},
		},
		{
			grade = 0,
			model = 'ms_bike',
			label = 'Rower Medyczny',
			groups = {3},
			livery = 0,
			extrason = {1,2},
			extrasoff = {},
		},		
		{
			grade = 4,
			model = 'ms_Bronco',
			label = 'Ford Bronco',
			groups = {2},
			livery = 1,
			extrason = {1,3,4,5,6},
			extrasoff = {},
		},
		{
			grade = 0,
			model = 'ms_chair',
			label = 'Wózek Inwalidzki',
			groups = {2},
			livery = 0,
			extrason = {},
			extrasoff = {},
		},
		{
			grade = 4,
			model = 'ms_charger18',
			label = 'Dodge Charger 2018',
			groups = {2},
			livery = 2,
			extrason = {1,2,3,4,5,6,7},
			extrasoff = {},
		},
		{
			grade = 4,
			model = 'ms_colorado',
			label = 'Chevrolet Colorado',
			groups = {2},
			livery = 2,
			extrason = {1,2,3,4,5,6},
			extrasoff = {},
		},
		{
			grade = 1,
			model = 'ms_everest14',
			label = 'Ford Everest',
			groups = {1},
			livery = 1,
			extrason = {1,2,3,4,5,6},
			extrasoff = {},
		},
		{
			grade = 1,
			model = 'ms_f150',
			label = 'Ford F150',
			groups = {2},
			livery = 0,
			extrason = {1,2,3,4,5,6,7,8,9,10,12},
			extrasoff = {11},
		},
		{
			grade = 0,
			model = 'ms_fj',
			label = 'Toyota FJ',
			groups = {2},
			livery = 0,
			extrason = {1,2,3,4,5,6,7,10,11},
			extrasoff = {},
		},
		{
			grade = 5,
			model = 'ms_focus',
			label = 'Ford Focus',
			groups = {2},
			livery = 0,
			extrason = {1,2,3},
			extrasoff = {},
		},
		{
			grade = 4,
			model = 'ms_kawasaki',
			label = 'Kawasaki Medyczny',
			groups = {3},
			livery = 0,
			extrason = {1,2,3,4},
			extrasoff = {},
		},
		{
			grade = 4,
			model = 'ms_lexus',
			label = 'Lexus',
			groups = {2},
			livery = 1,
			extrason = {1,2},
			extrasoff = {},
		},
		{
			grade = 12,
			model = 'ms_mustang',
			label = 'Ford Mustang',
			groups = {2},
			livery = 0,
			extrason = {1,2,3,4,6,8,9},
			extrasoff = {5,7},
		},
		{
			grade = 0,
			model = 'ms_paka',
			label = 'Karetka',
			groups = {2},
			livery = 2,
			extrason = {5,8,10},
			extrasoff = {},
		},
		{
			grade = 1,
			model = 'ms_silv2020w',
			label = 'Chevrolet Silverado 2020',
			groups = {2},
			livery = 0,
			extrason = {1,2,3,4,5,6,7,8,9},
			extrasoff = {},
		},
		{
			grade = 1,
			model = 'ms_silvleo',
			label = 'Chevrolet Silverado',
			groups = {2},
			livery = 0,
			extrason = {1,2,4},
			extrasoff = {3},
		},
		{
			grade = 10,
			model = 'ms_tesla',
			label = 'Tesla',
			groups = {2},
			livery = 0,
			extrason = {1,2},
			extrasoff = {},
		},
		{
			grade = 2,
			model = 'ms_titan',
			label = 'Nissan Titan',
			groups = {2},
			livery = 1,
			extrason = {1,2,9},
			extrasoff = {},
		},
	}

Config.AuthorizedHeli = {
	{
	   model = 'ms_heli',
	   label = 'Helikopter'
	},
}
Config.AuthorizedBoats = {
	{
		model = 'dinghy',
		label = 'Łódź'
	},
	{
		model = 'ms_boat1',
		label = 'Łódka Medyczna',
	},
}
 
Config.Ambulance = {
	DutyList = {
		{
			coords = vector3(1133.25, -1554.31, 35.4-0.95),
		},
		{
			coords = vector3(-667.5441, 333.7712, 82.2046),
		},
	},
	LicensesMenu = {
		{
			coords = vector3(1133.13, -1560.08, 35.4-0.95),
		},
		{
			coords = vector3(-674.4889, 378.2427, 82.2047),
		}
	},
	Cloakrooms = {
		{
			coords = vector3(375.53, -1434.63, 31.61),
		},
		{
			coords = vector3(1825.7, 3674.91, 33.37),
		},
		{
			coords = vector3(1133.86, -1548.72, 34.45),
		},
		{
			coords = vector3(-434.43, -320.67, 33.96),
		},
		{
			coords = vector3(-264.05, 6325.01, 32.42-0.95),
		},
		{
			coords = vector3(-826.24, -1237.0, 6.38),
		},
		{
			coords = vector3(312.34, -601.61, 43.29-0.95),
		},
		{
			coords = vector3(-663.0905, 321.5105, 82.2046),
		},
	},
	Vehicles = {
		{
			coords = vector3(1205.97, -1528.08, 34.9-0.95),
			spawnPoint = vector3(1201.25, -1501.01, 34.69),
			heading = 180.34
		},
		{
			coords = vector3(309.45, -1437.66, 28.9),
			spawnPoint = vector3(309.4, -1439.63, 28.9),
			heading = 228.34
		},
		{
			coords = vector3(-659.84, 309.95, 82.19),
			spawnPoint = vector3(-656.59, 310.03, 82.47),
			heading = 175.14
		},
		{
			coords = vector3(1171.72, -1527.78, 34.1),
			spawnPoint = vector3(1177.06, -1545.05, 33.74),
			heading = 358.8
		},
		{
			coords = vector3(-483.53, -352.71, 23.28),
			spawnPoint = vector3(-475.83, -349.85, 23.28),
			heading = 206.33
		},
		{
			coords = vector3(1825.14, 3690.48, 33.32),
			spawnPoint = vector3(1826.99, 3693.65, 33.81),
			heading = 299.56
		},
		{
			coords = vector3(-262.35, 6308.11, 31.52),
			spawnPoint = vector3(-265.09, 6306.84, 32.01),
			heading = 225.37
		},
		{
			coords = vector3(-846.13, -1229.19, 5.98),
			spawnPoint = vector3(-844.06, -1231.93, 5.98),
			heading = 318.81
		},
		{
			coords = vector3(293.7124, -597.9155, 42.3245),
			spawnPoint = vector3(292.6684, -607.4559, 41.4887),
			heading = 70.9
		},
	},
	Boats = {
		{
			coords = vector3(-718.77, -1326.51, 0.7),
			spawnPoint = vector3(-724.68, -1328.62, 0.12),
			heading = 229.75
		},
		{
			coords = vector3(1736.29, 3976.24, 31.08),
			spawnPoint = vector3(1736.63, 3986.54, 30.33),
			heading = 17.2
		},
		{
			coords = vector3(-285.01, 6627.6, 6.24),
			spawnPoint = vector3(-287.84, 6624.39, -0.2),
			heading = 47.37
 
		},
		{
			coords = vector3(-3420.4172, 955.6319, 7.3967),
			spawnPoint = vector3(-3434.8318, 945.8564, 0.5458),
			heading = 88.32
 
		},
		{
			coords = vector3(2836.5044, -732.4112, 0.3822),
			spawnPoint = vector3(2853.5557, -728.2502, 0.3811),
			heading = 261.94
 
		},
		{
			coords = vector3(3373.8213, 5183.4863, 0.5161),
			spawnPoint = vector3(3384.6956, 5181.6299, 0.5161),
			heading = 271.24
 
		},
	},
	Helicopters = {
		{
			coords = vector3(-651.0096, 313.5203, 139.2006),
			spawnPoint = vector3(-642.0776, 311.5877, 140.2006),
			heading = 228.97
		},
		{
			coords = vector3(314.25, -1453.21, 45.61),
			spawnPoint = vector3(313.37, -1464.98, 46.51),
			heading = 143.87
		},
		{
			coords = vector3(-704.30, 319.73, 139.25),
			spawnPoint = vector3(-703.2, 323.97, 140.15),
			heading = 172.5
		},
		{
			coords = vector3(-256.98, 6314.35, 38.76),
			spawnPoint = vector3(-252.3, 6319.14, 38.76),
			heading = 317.67
		},
		{
			coords = vector3(1209.25, -1537.83, 39.4-0.95),
			spawnPoint = vector3(1188.41, -1563.78, 39.4),
			heading = 87.65
		},
		{
			coords = vector3(1832.7971, 3691.7437, 37.4334),
			spawnPoint = vector3(1833.4216, 3680.6487, 39.1894),
			heading = 33.05
		},
		{
			coords = vector3(-855.95, -1233.71, 13.88),
			spawnPoint = vector3(-847.95, -1233.71, 13.88),
			heading = 230.5
		},
		{
			coords = vector3(-783.27, -1200.8, 51.14),
			spawnPoint = vector3(-790.97, -1191.68, 53.02),
			heading = 53.55
		},
		{
			coords = vector3(341.52, -581.72, 73.21),
			spawnPoint = vector3(352.23, -588.06, 73.21),
			heading = 68.83
		},
	},
 
		SkinMenu = {
		{
			coords = vector3(1132.08, -1545.05, 35.4-0.95),
		},
	},
 
	VehicleDeleters = {
		{
			coords = vector3(1201.65, -1501.12, 34.69-0.95),
		},
		{
			coords = vector3(288.5753, -596.3782, 42.2297),
		},
		{
			coords = vector3(-642.0776, 311.5877, 139.2006),
		},
		{
			coords = vector3(-790.97, -1191.68, 53.02),
		},
		{
			coords = vector3(-847.95, -1233.71, 13.88),
		},
		{
			coords = vector3(-3434.8318, 945.8564, 0.5458),
		},
		{
			coords = vector3(2853.5557, -728.2502, 0.3811),
		},
		{
			coords = vector3(1188.41, -1563.78, 39.4-0.95),
		},
		{
			coords = vector3(-654.8444, 308.6201, 81.9401),
		},
		{
			coords = vector3(1833.5635, 3680.0391, 39.1894),
		},
		{
			coords = vector3(3384.6956, 5181.6299, 0.5161),
		},
		{
			coords = vector3(-728.14, -1325.99, 0.5),
		},
		{
			coords = vector3(1731.19, 3989.57, 30.25),
		},
		{
			coords = vector3(-470.66, -349.12, 23.28),
		},
		{
			coords = vector3(1178.93, -1518.74, 33.74),
		},
		{
			coords = vector3(-287.64, 6621.62, 0.8),
		},
		{
			coords = vector3(-703.2, 323.97, 139.25),
		},
		{
			coords = vector3(-252.62, 6318.73, 38.76),
		},
		{
			coords = vector3(313.27, -1465.07, 45.61),
		},
		{
			coords = vector3(1827.14, 3693.51, 33.32),
		},
		{
			coords = vector3(-268.8, 6310.72, 31.52),
		},
		{
			coords = vector3(-844.06, -1231.93, 5.98),
		},
		{
			coords = vector3(352.23, -588.06, 73.21),
		},
	},
	Inventories2 = {
		{
			coords = vector3(349.91, -600.02, 47.32-0.95),
		},
	},
	Inventories = {
		{
			coords = vector3(-443.66, -312.56, 33.96),
		},
		{
			coords = vector3(359.56, -1425.86, 31.61),
		},
		{
			coords = vector3(1133.12, -1569.7, 34.45),
		},
		{
			coords = vector3(-802.57, -1208.93, 6.38),
		},
		{
			coords = vector3(339.0, -581.94, 28.92-0.95),
		},
		{
			coords = vector3(-662.2331, 329.5356, 82.2047),
		},
		{
			coords = vector3(-262.54, 6324.03, 32.42-0.95),
		},
	},
	Pharmacies = {
		{
			coords = vector3(359.35, -1414.98, 31.61),
		},
		{
			coords = vector3(1133.22, -1557.07, 34.45),
		},
		{
			coords = vector3(-438.83, -318.44, 33.96),
		},
		{
			coords = vector3(1830.63, 3677.38, 33.37),
		},
		{
			coords = vector3(-259.36, 6309.51, 32.42-0.95),
		},
		{
			coords = vector3(-805.8, -1212.84, 6.38),
		},
		{
			coords = vector3(337.64, -586.29, 28.89-0.95),
		},
		{
			coords = vector3(-699.5998, 324.7575, 82.2047),
		},
	},
	BossActions = {
		{
		 	coords = vector3(1133.45, -1565.92, 35.4-0.95),
		},
		{
			coords = vector3(-814.69, -1236.69, 6.38),
		},
		{
			coords = vector3(344.15, -595.78, 47.32-0.95),--
		},
		{
			coords = vector3(-258.5, 6330.23, 32.42-0.95),--
		},
	}
}

Config.Uniforms = {
	pielegniarz_wear = {
		male = {
			['tshirt_1'] = 189,  ['tshirt_2'] = 0,
			['torso_1'] = 411,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 90,
			['pants_1'] = 26,   ['pants_2'] = 0,
			['shoes_1'] = 14,   ['shoes_2'] = 1,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 30,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['mask_1'] = 0,   ['mask_2'] = 0,
			['bags_1'] = 122,  ['bags_2'] = 0
		},
		female = {
			['tshirt_1'] = 30,  ['tshirt_2'] = 0,
			['torso_1'] = 432,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 109,
			['pants_1'] = 200,   ['pants_2'] = 8,
			['shoes_1'] = 11,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 96,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 117,  ['bags_2'] = 0
		}
	},
	ratownik_wear = {
		male = {
			['tshirt_1'] = 189,  ['tshirt_2'] = 0,
			['torso_1'] = 411,   ['torso_2'] = 9,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 90,
			['pants_1'] = 26,   ['pants_2'] = 0,
			['shoes_1'] = 14,   ['shoes_2'] = 1,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 30,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['mask_1'] = 0,   ['mask_2'] = 0,
			['bags_1'] = 122,  ['bags_2'] = 0
		},
		female = {
			['tshirt_1'] = 30,  ['tshirt_2'] = 0,
			['torso_1'] = 432,   ['torso_2'] = 9,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 109,
			['pants_1'] = 200,   ['pants_2'] = 8,
			['shoes_1'] = 11,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 96,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 117,  ['bags_2'] = 0
		}
	},
	stratownik_wear = {
		male = {
			['tshirt_1'] = 189,  ['tshirt_2'] = 0,
			['torso_1'] = 414,   ['torso_2'] = 5,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 90,
			['pants_1'] = 26,   ['pants_2'] = 0,
			['shoes_1'] = 14,   ['shoes_2'] = 1,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 30,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['mask_1'] = 0,   ['mask_2'] = 0,
			['bags_1'] = 122,  ['bags_2'] = 0
		},
		female = {
			['tshirt_1'] = 30,  ['tshirt_2'] = 0,
			['torso_1'] = 433,   ['torso_2'] = 5,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 101,
			['pants_1'] = 200,   ['pants_2'] = 8,
			['shoes_1'] = 11,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 96,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 117,  ['bags_2'] = 0
		}
	},
	lekarz_wear = {
		male = {
			['tshirt_1'] = 189,  ['tshirt_2'] = 0,
			['torso_1'] = 414,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 90,
			['pants_1'] = 26,   ['pants_2'] = 0,
			['shoes_1'] = 14,   ['shoes_2'] = 1,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 30,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['mask_1'] = 0,   ['mask_2'] = 0,
			['bags_1'] = 122,  ['bags_2'] = 0
		},
		female = {
			['tshirt_1'] = 30,  ['tshirt_2'] = 0,
			['torso_1'] = 433,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 101,
			['pants_1'] = 200,   ['pants_2'] = 8,
			['shoes_1'] = 11,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 96,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 117,  ['bags_2'] = 0
		}
	},
	lekarzsoru_wear = {
		male = {
			['tshirt_1'] = 189,  ['tshirt_2'] = 0,
			['torso_1'] = 416,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 90,
			['pants_1'] = 26,   ['pants_2'] = 0,
			['shoes_1'] = 14,   ['shoes_2'] = 1,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 30,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['mask_1'] = 0,   ['mask_2'] = 0,
			['bags_1'] = 122,  ['bags_2'] = 0
		},
		female = {
			['tshirt_1'] = 30,  ['tshirt_2'] = 0,
			['torso_1'] = 435,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 109,
			['pants_1'] = 200,   ['pants_2'] = 8,
			['shoes_1'] = 11,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 96,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 117,  ['bags_2'] = 0
		}
	},
	lekarzspecjalista_wear = {
        male = {
            ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
            ['torso_1'] = 415,   ['torso_2'] = 11,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['arms'] = 90,
            ['pants_1'] = 26,   ['pants_2'] = 0,
            ['shoes_1'] = 14,   ['shoes_2'] = 1,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['chain_1'] = 30,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['mask_1'] = 0,   ['mask_2'] = 0,
            ['bags_1'] = 122,  ['bags_2'] = 0
        },
		female = {
			['tshirt_1'] = 30,  ['tshirt_2'] = 0,
			['torso_1'] = 435,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 109,
			['pants_1'] = 200,   ['pants_2'] = 8,
			['shoes_1'] = 11,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 96,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 117,  ['bags_2'] = 0
		}
	},
	doktor_wear = {
		male = {
			['tshirt_1'] = 189,  ['tshirt_2'] = 0,
			['torso_1'] = 413,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 85,
			['pants_1'] = 26,   ['pants_2'] = 0,
			['shoes_1'] = 14,   ['shoes_2'] = 1,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 30,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['mask_1'] = 0,   ['mask_2'] = 0,
			['bags_1'] = 122,  ['bags_2'] = 0
		},
		female = {
			['tshirt_1'] = 30,  ['tshirt_2'] = 0,
			['torso_1'] = 434,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 109,
			['pants_1'] = 200,   ['pants_2'] = 8,
			['shoes_1'] = 11,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 96,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 117,  ['bags_2'] = 0
		}
	},
	chirurg_wear = {
		male = {
			['tshirt_1'] = 189,  ['tshirt_2'] = 0,
			['torso_1'] = 413,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 85,
			['pants_1'] = 26,   ['pants_2'] = 0,
			['shoes_1'] = 14,   ['shoes_2'] = 1,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 30,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['mask_1'] = 0,   ['mask_2'] = 0,
			['bags_1'] = 122,  ['bags_2'] = 0
		},
		female = {
			['tshirt_1'] = 30,  ['tshirt_2'] = 0,
			['torso_1'] = 434,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 109,
			['pants_1'] = 200,   ['pants_2'] = 8,
			['shoes_1'] = 11,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 96,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 117,  ['bags_2'] = 0
		}
	},
	neurochirurg_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 417,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 90,
			['pants_1'] = 26,   ['pants_2'] = 0,
			['shoes_1'] = 14,   ['shoes_2'] = 1,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 30,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['mask_1'] = 0,   ['mask_2'] = 0,
			['bags_1'] = 122,  ['bags_2'] = 0
		},
		female = {
			['tshirt_1'] = 2,  ['tshirt_2'] = 0,
			['torso_1'] = 436,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 109,
			['pants_1'] = 200,   ['pants_2'] = 8,
			['shoes_1'] = 11,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 96,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 117,  ['bags_2'] = 0
		}
	},
	nurek_wear = { 
		male = {
			['tshirt_1'] = 123,  ['tshirt_2'] = 0,
			['torso_1'] = 243,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 90,
			['pants_1'] = 94,   ['pants_2'] = 1,
			['shoes_1'] = 67,   ['shoes_2'] = 1,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 122,    ['chain_2'] = 0
 
		},
		female = {
			['tshirt_1'] = 153,  ['tshirt_2'] = 0,
			['torso_1'] = 251,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 106,
			['pants_1'] = 97,   ['pants_2'] = 1,
			['shoes_1'] = 70,   ['shoes_2'] = 1,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 96,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['bags_1'] = 117,  ['bags_2'] = 0
 
		}
	},
}
