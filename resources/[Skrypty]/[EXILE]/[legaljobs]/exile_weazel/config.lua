Config = {}

Config.DrawDistance = 20.0
Config.MarkerType   = 27
Config.MarkerColor  = { r = 246, g = 93, b = 93 }
Config.MarkerSize   = { x = 1.5, y = 1.5, z = 1.0 }
Config.BossActions  = { x = -574.7299, y = -938.6641, z = 27.8676 }
Config.EndPoint = vector3(-588.0195, -931.5569, 22.8657)
Config.Printing = vector3(970.7792, 2724.6711, 38.5335)

Config.Cloakroom = {
	{coords = vector3(-558.7379, -878.4404, 24.3)},
	{coords = vector3(984.0024, 2718.6196, 38.5534)},
}

Config.VehicleActions = {
	{
		Spawner = {x = -543.399, y = -891.9129, z = 23.7892},
		SpawnPoint = {x = -543.399, y = -891.9129, z = 23.7892, Heading = 181.83}
	},
	{
		Spawner = {x = 968.3636, y = 2709.0466, z = 38.5776},
		SpawnPoint = {x = 968.3636, y = 2709.0466, z = 38.5776, Heading = 179.7}
	}
}

Config.VehicleDeleters = {
	{
		Spawner = {x = -532.4387, y = -889.3776, z = 23.9999}
	},
	{
		Spawner = {x = 968.4774, y = 2717.1238, z = 38.5335}
	}
}

Config.Vehicles = {
	{
		grade = 0,
		model = 'weazelcar',
		label = 'Sprinter',
	},
}

Config.MissionLocations = {
	vector3(-1180.8723, -494.2203, 34.9143),
}

Config.Clothes = {
	Male = {
		['tshirt_1'] = 15, ['tshirt_2'] = 0,
		['torso_1'] = 420, ['torso_2'] = 0,
		['decals_1'] = 0, ['decals_2'] = 0,
		['arms'] = 0,
		['pants_1'] = 83, ['pants_2'] = 0,
		['shoes_1'] = 14, ['shoes_2'] = 0,
		['helmet_1'] = -1, ['helmet_2'] = 0,
		['chain_1'] = 0, ['chain_2'] = 0,
		['ears_1'] = -1, ['ears_2'] = 0,
		['bproof_1'] = 0, ['bproof_2'] = 0,
		['mask_1'] = 0, ['mask_2'] = 0,
		['bags_1'] = 108, ['bags_2'] = 14
	},
	Female = {
		['tshirt_1'] = 6, ['tshirt_2'] = 0,
		['torso_1'] = 406, ['torso_2'] = 3,
		['decals_1'] = 0, ['decals_2'] = 0,
		['arms'] = 33,
		['pants_1'] = 175, ['pants_2'] = 9,
		['shoes_1'] = 11, ['shoes_2'] = 1,
		['helmet_1'] = -1, ['helmet_2'] = 0,
		['chain_1'] = 0, ['chain_2'] = 0,
		['ears_1'] = -1, ['ears_2'] = 0,
		['bproof_1'] = 0, ['bproof_2'] = 0,
		['mask_1'] = 0, ['mask_2'] = 0,
		['bags_1'] = 21, ['bags_2'] = 14
	},
}