Config                            = {}
Config.Locale                     = 'pl'

Config.JobBlip = {
	coord = vector3(129.3908, -1054.587, 22.0103),
	sprite = 436,
	display = 4,
	scale = 1.2,
	colour = 64,
	name = 'Piekarz'
}

Config.PriceForBread = 92

Config.TimeToPickupFlavour = 20
Config.TimeToMixFlavour = 10
Config.TimeToCookCake = 10
Config.TimeToSell = 15

Config.Ped = {
	model = 's_m_y_chef_01',
	coord = Config.JobBlip.coord,
	name = '~o~Piekarz: ~w~Ben'
}

Config.Zones = {
	{coord = vector3(111.7741, -1049.8677, 28.2621), sprite = 569, scale = 5.0, bscale = 1.0, name = '#1 Garaż',                        action = 'getVehicle'},
	{coord = vector3(2660.84, 3276.13, 54.24), sprite = 515, scale = 5.0, bscale = 1.0, name = '#5 Punkt dostawy chleba',               action = 'deliverybread'},
	{coord = vector3(1232.4454, 1898.5167, 77.6951), sprite = 266,   scale = 5.0, bscale = 1.0, name = '#2 Zbieranie mąki',             action = 'mill'},
	{coord = vector3(146.3126, -1055.0365, 22.0102), sprite = 648, scale = 3.0, bscale = 0.7, name = '#4 Wypiekanie ciasta',            action = 'furnace', temp = 0}, --5
	{coord = vector3(143.1105, -1057.0011, 22.0102), sprite = 467, scale = 3.0, bscale = 0.7, name = '#3 Przygotowywanie porcji',       action = 'mixer'},
}

Config.CarSpawners = {
	{coord = vector3(123.1893, -1053.6255, 28.2421), heading = 335.74, model = 'autopiekarz'}
}

Config.Temperatures = {
	{label = '200°C', value = 200},
	{label = '210°C', value = 210},
	{label = '220°C', value = 220},
	{label = '225°C', value = 225},
	{label = '230°C', value = 230},
	{label = '240°C', value = 240},
	{label = '250°C', value = 250}
}

Config.Clothes = {
	Male = {
		['tshirt_1'] = 15, ['tshirt_2'] = 0,
		['torso_1'] = 241, ['torso_2'] = 2,
		['decals_1'] = 0, ['decals_2'] = 0,
		['arms'] = 74,
		['pants_1'] = 68, ['pants_2'] = 2,
		['shoes_1'] = 69, ['shoes_2'] = 7,
		['helmet_1'] = -1, ['helmet_2'] = 0,
		['chain_1'] = 0, ['chain_2'] = 0,
		['ears_1'] = -1, ['ears_2'] = 0,
		['bproof_1'] = 0, ['bproof_2'] = 0,
		['mask_1'] = 0, ['mask_2'] = 0,
		['bags_1'] = 0, ['bags_2'] = 0
	},
	Female = {
		['tshirt_1'] = 15, ['tshirt_2'] = 0,
		['torso_1'] = 249, ['torso_2'] = 2,
		['decals_1'] = 0, ['decals_2'] = 0,
		['arms'] = 96,
		['pants_1'] = 80, ['pants_2'] = 0,
		['shoes_1'] = 62, ['shoes_2'] = 7,
		['helmet_1'] = -1, ['helmet_2'] = 0,
		['chain_1'] = 0, ['chain_2'] = 0,
		['ears_1'] = -1, ['ears_2'] = 0,
		['bproof_1'] = 0, ['bproof_2'] = 0,
		['mask_1'] = 0, ['mask_2'] = 0,
		['bags_1'] = 0, ['bags_2'] = 0
	},
}