Config = {}
Config.Locale = 'pl'
Config.MaxDistance = 20

Config.typeNapad = {
	['sejf'] = {
		drill = true,
		secondsRemaining = 400,
		cops = 5,
	},
	['muzeum'] = {
		drill = true,
		secondsRemaining = 400,
		cops = 5,
	},
	['bank'] = {
		drill = true,
		secondsRemaining = 500,
		cops = 6,
	},
	['yacht'] = {
		drill = true,
		secondsRemaining = 600,
		cops = 8,
	},
	['humanelabs'] = {
		drill = true,
		secondsRemaining = 600,
		cops = 8,
	},
	['zbrojownia'] = {
		drill = true,
		secondsRemaining = 600,
		cops = 8,
	},
	['bazawojskowa'] = {
		drill2 = true,
		secondsRemaining = 800,
		cops = 16,
	},
	['magazyn'] = {
		drill = true,
		secondsRemaining = 700,
		cops = 14,
	},
}

Stores = {
	["fleeca"] = {
		position = { x = 147.04908752441, y = -1044.9448242188, z = 29.46802482605 },
		reward = math.random(1900000, 2500000),
		requiredItems = {
			{
				item = "dysk",
				label = "Dysk z danymi"
			}
		},
		secondChance = 100,
		secondRewards = {
			{
				chance = 100,
				item = 'gwiazdki',
				label = "Jajko Wielkanoce",
				count = 600
			},
			{
				chance = 100,
				item = 'laptop',
				label = "Zaszyfrowany laptop",
				count = 1
			},
			{
				chance = 100,
				item = 'kawa',
				label = "X-Gamer",
				count = 50
			},
			{
				chance = 20,
				item = 'clip_extended',
				label = "Powiększony magazynek",
				count = 1
			},
			{
				chance = 20,
				item = 'scope',
				label = "Celownik",
				count = 1
			},
			{
				chance = 20,
				item = 'suppressor',
				label = "Tłumik",
				count = 1
			},
			{
				chance = 20,
				item = 'grip',
				label = "Uchwyt",
				count = 1
			},
			{
				chance = 100,
				item = 'clip',
				label = "Magazynek",
				count = 80
			},
			{
				chance = 100,
				weapon = "WEAPON_PISTOL",
				label = "Pistolet",
				count = 1,
				ammo = 50,
			}
		},
		name = "Fleeca Bank",
		blip = {
			id = 500,
			scale = 0.6,
			color = 49,
			label = 'Napad na Bank',
		},	
		type = 'bank',
		delay = {
			success = 1000,
			failure = 60,
		},
	},
	["fleeca2"] = {
		position = { x = -2957.6674804688, y = 481.45776367188, z = 15.797026252747 },
		reward = math.random(1900000, 2500000),
		requiredItems = {
			{
				item = "dysk",
				label = "Dysk z danymi"
			}
		},
		secondChance = 100,
		secondRewards = {
			{
				chance = 100,
				item = 'gwiazdki',
				label = "Jajko Wielkanoce",
				count = 600
			},
			{
				chance = 100,
				item = 'laptop',
				label = "Zaszyfrowany laptop",
				count = 1
			},
			{
				chance = 100,
				item = 'kawa',
				label = "X-Gamer",
				count = 50
			},
			{
				chance = 20,
				item = 'clip_extended',
				label = "Powiększony magazynek",
				count = 1
			},
			{
				chance = 20,
				item = 'scope',
				label = "Celownik",
				count = 1
			},
			{
				chance = 20,
				item = 'suppressor',
				label = "Tłumik",
				count = 1
			},
			{
				chance = 20,
				item = 'grip',
				label = "Uchwyt",
				count = 1
			},
			{
				chance = 100,
				item = 'clip',
				label = "Magazynek",
				count = 80
			}
		},
		name = "Fleeca Bank",
		blip = {
			id = 500,
			scale = 0.6,
			color = 49,
			label = 'Napad na Bank',
		},	
		type = 'bank',
		delay = {
			success = 1000,
			failure = 60,
		},
	},
	["fleeca3"] = {
		position = { x = 1648.2958, y = 4851.5972, z = 42.0599 },
		reward = math.random(1900000, 2500000),
		requiredItems = {
			{
				item = "dysk",
				label = "Dysk z danymi"
			}
		},
		secondChance = 100,
		secondRewards = {
			{
				chance = 100,
				item = 'gwiazdki',
				label = "Jajko Wielkanoce",
				count = 600
			},
			{
				chance = 100,
				item = 'laptop',
				label = "Zaszyfrowany laptop",
				count = 1
			},
			{
				chance = 100,
				item = 'kawa',
				label = "X-Gamer",
				count = 50
			},
			{
				chance = 20,
				item = 'clip_extended',
				label = "Powiększony magazynek",
				count = 1
			},
			{
				chance = 20,
				item = 'scope',
				label = "Celownik",
				count = 1
			},
			{
				chance = 20,
				item = 'suppressor',
				label = "Tłumik",
				count = 1
			},
			{
				chance = 20,
				item = 'grip',
				label = "Uchwyt",
				count = 1
			},
			{
				chance = 100,
				item = 'clip',
				label = "Magazynek",
				count = 80
			}
		},
		name = "Fleeca Bank",
		blip = {
			id = 500,
			scale = 0.6,
			color = 49,
			label = 'Napad na Bank',
		},	
		type = 'bank',
		delay = {
			success = 1000,
			failure = 60,
		},
	},
	["blainecounty"] = {
		position = { x = -107.06505584717, y = 6474.8012695313, z = 31.72670135498 },
		reward = math.random(1900000, 2500000),
		requiredItems = {
			{
				item = "dysk",
				label = "Dysk z danymi"
			}
		},
		secondChance = 100,
		secondRewards = {
			{
				chance = 100,
				item = 'gwiazdki',
				label = "Jajko Wielkanoce",
				count = 600
			},
			{
				chance = 100,
				item = 'laptop',
				label = "Zaszyfrowany laptop",
				count = 1
			},
			{
				chance = 100,
				item = 'kawa',
				label = "X-Gamer",
				count = 50
			},
			{
				chance = 20,
				item = 'clip_extended',
				label = "Powiększony magazynek",
				count = 1
			},
			{
				chance = 20,
				item = 'scope',
				label = "Celownik",
				count = 1
			},
			{
				chance = 20,
				item = 'suppressor',
				label = "Tłumik",
				count = 1
			},
			{
				chance = 20,
				item = 'grip',
				label = "Uchwyt",
				count = 1
			},
			{
				chance = 100,
				item = 'clip',
				label = "Magazynek",
				count = 80
			}
		},
		name = "Blaine County Savings Bank",
		blip = {
			id = 500,
			scale = 0.6,
			color = 49,
			label = 'Napad na Bank',
		},	
		type = 'bank',
		delay = {
			success = 1000,
			failure = 60,
		},
	},
	["Route68Bank"] = {
		position = { x = 1176.77, y = 2711.82, z = 38.19 },
		reward = math.random(1900000, 2500000),
		requiredItems = {
			{
				item = "dysk",
				label = "Dysk z danymi"
			}
		},
		secondChance = 100,
		secondRewards = {
			{
				chance = 100,
				item = 'gwiazdki',
				label = "Jajko Wielkanoce",
				count = 600
			},
			{
				chance = 100,
				item = 'laptop',
				label = "Zaszyfrowany laptop",
				count = 1
			},
			{
				chance = 100,
				item = 'kawa',
				label = "X-Gamer",
				count = 50
			},
			{
				chance = 20,
				item = 'clip_extended',
				label = "Powiększony magazynek",
				count = 1
			},
			{
				chance = 20,
				item = 'scope',
				label = "Celownik",
				count = 1
			},
			{
				chance = 20,
				item = 'suppressor',
				label = "Tłumik",
				count = 1
			},
			{
				chance = 20,
				item = 'grip',
				label = "Uchwyt",
				count = 1
			},
			{
				chance = 100,
				item = 'clip',
				label = "Magazynek",
				count = 80
			}
		},
		name = "Fleeca Bank",
		blip = {
			id = 500,
			scale = 0.6,
			color = 49,
			label = 'Napad na Bank',
		},		
		type = 'bank',
		delay = {
			success = 1000,
			failure = 60,
		},
	},
	["RockfordBank"] = {
		position = { x = -1211.88, y = -336.17, z = 37.89 },
		reward = math.random(1900000, 2500000),
		requiredItems = {
			{
				item = "dysk",
				label = "Dysk z danymi"
			}
		},
		secondChance = 100,
		secondRewards = {
			{
				chance = 100,
				item = 'gwiazdki',
				label = "Jajko Wielkanoce",
				count = 600
			},
			{
				chance = 100,
				item = 'laptop',
				label = "Zaszyfrowany laptop",
				count = 1
			},
			{
				chance = 100,
				item = 'kawa',
				label = "X-Gamer",
				count = 50
			},
			{
				chance = 20,
				item = 'clip_extended',
				label = "Powiększony magazynek",
				count = 1
			},
			{
				chance = 20,
				item = 'scope',
				label = "Celownik",
				count = 1
			},
			{
				chance = 20,
				item = 'suppressor',
				label = "Tłumik",
				count = 1
			},
			{
				chance = 20,
				item = 'grip',
				label = "Uchwyt",
				count = 1
			},
			{
				chance = 100,
				item = 'clip',
				label = "Magazynek",
				count = 80
			}
		},
		name = "Fleeca Bank",
		blip = {
			id = 500,
			scale = 0.6,
			color = 49,
			label = 'Napad na Bank',
		},	
		type = 'bank',
		delay = {
			success = 1000,
			failure = 60,
		},
	},
	["EVinewoodBank"] = {
		position = { x = 310.85, y = -283.32, z = 54.27 },
		reward = math.random(1900000, 2500000),
		requiredItems = {
			{
				item = "dysk",
				label = "Dysk z danymi"
			}
		},
		secondChance = 100,
		secondRewards = {
			{
				chance = 100,
				item = 'gwiazdki',
				label = "Jajko Wielkanoce",
				count = 600
			},
			{
				chance = 100,
				item = 'laptop',
				label = "Zaszyfrowany laptop",
				count = 1
			},
			{
				chance = 100,
				item = 'kawa',
				label = "X-Gamer",
				count = 50
			},
			{
				chance = 20,
				item = 'clip_extended',
				label = "Powiększony magazynek",
				count = 1
			},
			{
				chance = 20,
				item = 'scope',
				label = "Celownik",
				count = 1
			},
			{
				chance = 20,
				item = 'suppressor',
				label = "Tłumik",
				count = 1
			},
			{
				chance = 20,
				item = 'grip',
				label = "Uchwyt",
				count = 1
			},
			{
				chance = 100,
				item = 'clip',
				label = "Magazynek",
				count = 80
			}
		},
		name = "Fleeca Bank",
		blip = {
			id = 500,
			scale = 0.6,
			color = 49,
			label = 'Napad na Bank',
		},	
		type = 'bank',
		delay = {
			success = 1000,
			failure = 60,
		},
	},
	["WVinewoodBank2"] = {
		position = { x = -354.32, y = -54.02, z = 49.14 },
		reward = math.random(1900000, 2500000),
		requiredItems = {
			{
				item = "dysk",
				label = "Dysk z danymi"
			}
		},
		secondChance = 100,
		secondRewards = {
			{
				chance = 100,
				item = 'gwiazdki',
				label = "Jajko Wielkanoce",
				count = 600
			},
			{
				chance = 100,
				item = 'laptop',
				label = "Zaszyfrowany laptop",
				count = 1
			},
			{
				chance = 100,
				item = 'kawa',
				label = "X-Gamer",
				count = 50
			},
			{
				chance = 20,
				item = 'clip_extended',
				label = "Powiększony magazynek",
				count = 1
			},
			{
				chance = 20,
				item = 'scope',
				label = "Celownik",
				count = 1
			},
			{
				chance = 20,
				item = 'suppressor',
				label = "Tłumik",
				count = 1
			},
			{
				chance = 20,
				item = 'grip',
				label = "Uchwyt",
				count = 1
			},
			{
				chance = 100,
				item = 'clip',
				label = "Magazynek",
				count = 80
			}
		},
		name = "Fleeca Bank",
		blip = {
			id = 500,
			scale = 0.6,
			color = 49,
			label = 'Napad na Bank',
		},	
		type = 'bank',
		delay = {
			success = 1000,
			failure = 60,
		},
	},
	
	
	--SEJFY 50-80kk


	["jubiler"] = {
		position = { x = -619.72, y = -229.08, z = 38.05 },
		reward = math.random(1500000, 2000000),
		requiredItems = {
			{
				item = "pendrive",
				label = "Pendrive"
			}
		},
		secondChance = 100,
		secondRewards = {
			{
				chance = 100,
				item = 'gwiazdki',
				label = "Jajko Wielkanoce",
				count = 450
			},
			{
				chance = 100,
				item = 'dysk',
				label = "Dysk z danymi",
				count = 1
			},
			{
				chance = 100,
				item = 'kawa',
				label = "X-Gamer",
				count = 30
			},
			{
				chance = 100,
				item = 'scratchcarddiamond',
				label = "Diamentowa Zdrapka",
				count = 2
			},
			{
				chance = 100,
				item = 'scratchcardgold',
				label = "Złota Zdrapka",
				count = 10
			},
			{
				chance = 100,
				item = 'clip',
				label = "Magazynek",
				count = 60
			}
		},
		name = "Jubiler",
		blip = {
			id = 615,
			scale = 0.6,
			color = 49,
			label = 'Napad na Jubilera',
		},	
		type = 'sejf',
		delay = {
			success = 1000,
			failure = 60,
		},
	},

	["jubiler2"] = {
		position = { x = -613.26, y = -604.53, z = -2.4 },
		reward = math.random(1500000, 2000000),
		requiredItems = {
			{
				item = "pendrive",
				label = "Pendrive"
			}
		},
		secondChance = 100,
		secondRewards = {
			{
				chance = 100,
				item = 'gwiazdki',
				label = "Jajko Wielkanoce",
				count = 450
			},
			{
				chance = 100,
				item = 'dysk',
				label = "Dysk z danymi",
				count = 1
			},
			{
				chance = 100,
				item = 'kawa',
				label = "X-Gamer",
				count = 30
			},
			{
				chance = 100,
				item = 'scratchcarddiamond',
				label = "Diamentowa Zdrapka",
				count = 2
			},
			{
				chance = 100,
				item = 'scratchcardgold',
				label = "Złota Zdrapka",
				count = 10
			},
			{
				chance = 100,
				item = 'clip',
				label = "Magazynek",
				count = 60
			}
		},
		name = "Muzeum",
		blip = {
			id = 616,
			scale = 0.6,
			color = 49,
			label = 'Napad na Muzeum',
		},	
		type = 'muzeum',
		delay = {
			success = 1000,
			failure = 60,
		},
	},

	["yacht1"] = {
		position = { x = -2345.42, y = -655.24, z = 13.41 },
		reward = math.random(2900000, 3500000),
		requiredItems = {
			{
				item = "zlotakarta",
				label = "Złota Karta"
			}
		},
		secondChance = 100,
		secondRewards = {
			{
				chance = 100,
				item = 'nurek_3',
				label = "strój do nurkowania",
				count = 2
			},
			{
				chance = 100,
				item = 'gwiazdki',
				label = "Jajko Wielkanoce",
				count = 800
			},
			{
				chance = 100,
				item = 'diamentowakarta',
				label = "Diamentowa karta",
				count = 1
			},
			{
				chance = 100,
				item = 'kawa',
				label = "X-Gamer",
				count = 80
			},
			{
				chance = 35,
				item = 'clip_extended',
				label = "Powiększony magazynek",
				count = 1
			},
			{
				chance = 35,
				item = 'scope',
				label = "Celownik",
				count = 1
			},
			{
				chance = 35,
				item = 'suppressor',
				label = "Tłumik",
				count = 1
			},
			{
				chance = 35,
				item = 'grip',
				label = "Uchwyt",
				count = 1
			},
			{
				chance = 100,
				item = 'clip',
				label = "Magazynek",
				count = 140
			},
			{
				chance = 50,
				item = 'clipsmg',
				label = "Magazynek SMG",
				count = 3
			},
			{
				chance = 50,
				item = 'extendedclip',
				label = "Magazynek Długa",
				count = 3
			},
			{
				chance = 40,
				item = 'kamzaduza',
				label = "Duża kamizelka",
				count = 2
			},
			{
				chance = 40,
				item = 'kamzasmall',
				label = "Mała kamizelka",
				count = 3
			}
		},
		name = "Yacht",
		blip = {
			id = 455,
			scale = 0.8,
			color = 49,
			label = 'Napad na Yacht',
		},	
		type = 'yacht',
		delay = {
			success = 2000,
			failure = 60,
		},
	},
	
	["yacht"] = {
		position = { x = -2084.4868, y = -1014.0796, z = 5.9341 },
		reward = math.random(2900000, 3500000),
		requiredItems = {
			{
				item = "zlotakarta",
				label = "Złota Karta"
			}
		},
		secondChance = 100,
		secondRewards = {
			{
				chance = 100,
				item = 'nurek_3',
				label = "strój do nurkowania",
				count = 2
			},
			{
				chance = 100,
				item = 'gwiazdki',
				label = "Jajko Wielkanoce",
				count = 800
			},
			{
				chance = 100,
				item = 'diamentowakarta',
				label = "Diamentowa karta",
				count = 1
			},
			{
				chance = 100,
				item = 'kawa',
				label = "X-Gamer",
				count = 80
			},
			{
				chance = 35,
				item = 'clip_extended',
				label = "Powiększony magazynek",
				count = 1
			},
			{
				chance = 35,
				item = 'scope',
				label = "Celownik",
				count = 1
			},
			{
				chance = 35,
				item = 'suppressor',
				label = "Tłumik",
				count = 1
			},
			{
				chance = 35,
				item = 'grip',
				label = "Uchwyt",
				count = 1
			},
			{
				chance = 100,
				item = 'clip',
				label = "Magazynek",
				count = 140
			},
			{
				chance = 50,
				item = 'clipsmg',
				label = "Magazynek SMG",
				count = 3
			},
			{
				chance = 50,
				item = 'extendedclip',
				label = "Magazynek Długa",
				count = 3
			},
			{
				chance = 100,
				item = 'kamzaduza',
				label = "Duża kamizelka",
				count = 2
			},
			{
				chance = 40,
				item = 'kamzaduza',
				label = "Duża kamizelka",
				count = 2
			}
		},
		name = "Yacht",
		blip = {
			id = 455,
			scale = 0.8,
			color = 49,
			label = 'Napad na Yacht',
		},	
		type = 'yacht',
		delay = {
			success = 2000,
			failure = 60,
		},
	},

	["bazawojskowa"] = {
		position = { x = -2422.16, y = 3274.71, z = 32.83 },
		reward = math.random(100000, 500000),
		requiredItems = {
			{
				item = "platynowakarta",
				label = "Platynowa karta"
			}
		},
		secondChance = 100,
		secondRewards = {
			{
				chance = 100,
				item = 'gwiazdki',
				label = "Jajko Wielkanoce",
				count = 1200
			},
			{
				chance = 100,
				item = 'kawa',
				label = "X-Gamer",
				count = 150
			},
			{
				chance = 60,
				item = 'clip_extended',
				label = "Powiększony magazynek",
				count = 3
			},
			{
				chance = 60,
				item = 'scope',
				label = "Celownik",
				count = 3
			},
			{
				chance = 60,
				item = 'suppressor',
				label = "Tłumik",
				count = 3
			},
			{
				chance = 60,
				item = 'grip',
				label = "Uchwyt",
				count = 3
			},
			{
				chance = 100,
				item = 'clip',
				label = "Magazynek",
				count = 250
			},
			{
				chance = 60,
				item = 'clipsmg',
				label = "Magazynek SMG",
				count = 8
			},
			{
				chance = 60,
				item = 'extendedclip',
				label = "Magazynek Długa",
				count = 8
			},
			{
				chance = 100,
				item = 'kamzaduza',
				label = "Duża kamizelka",
				count = 4
			},
			{
				chance = 40,
				item = 'kamzaduza',
				label = "Duża kamizelka",
				count = 4
			},
			{
				chance = 50,
				item = 'pendrive',
				label = "Pendrive",
				count = 1
			},
			{
				chance = 40,
				item = 'dysk',
				label = "Dysk z danymi",
				count = 1
			},
			{
				chance = 30,
				item = 'laptop',
				label = "Zaszyfrowany Laptop",
				count = 1
			},
			{
				chance = 15,
				weapon = 'WEAPON_COMBATPDW',
				label = "PDW",
				count = 1
			},
			{
				chance = 15,
				weapon = 'WEAPON_COMPACTRIFLE',
				label = "Mini Kałach",
				count = 1
			},
			{
				chance = 10,
				weapon = 'WEAPON_CARABINERIFLE',
				label = "M4",
				count = 1
			},
			{
				chance = 1,
				weapon = 'WEAPON_ASSAULTRIFLE',
				label = "Kałach",
				count = 1
			},
			{
				chance = 100,
				weapon = 'WEAPON_DOUBLEACTION',
				label = "Złoty Rewolwer",
				count = 2
			},
			{
				chance = 40,
				weapon = 'WEAPON_APPISTOL',
				label = "AP Pistol",
				count = 1
			},
			{
				chance = 15,
				weapon = 'WEAPON_ASSAULTSMG',
				label = "Famas",
				count = 1
			},
			{
				chance = 20,
				item = 'zlotakarta',
				label = "Złota karta",
				count = 1
			},
			{
				chance = 20,
				item = 'diamentowakarta',
				label = "Diamentowa karta",
				count = 1
			},
		},
		name = "Baza Wojskowa",
		blip = {
			id = 563,
			scale = 0.8,
			color = 49,
			label = 'Napad na Baze Wojskową',
		},	
		type = 'bazawojskowa',
		delay = {
			success = 2000,
			failure = 60,
		},
	},

	["magazyn"] = {
		position = { x = 34.01, y = -2656.29, z = 12.04 },
		reward = math.random(3700000, 4400000),
		requiredItems = {
			{
				item = "diamentowakarta",
				label = "Diamentowa karta"
			}
		},
		secondChance = 100,
		secondRewards = {
			{
				chance = 100,
				item = 'gwiazdki',
				label = "Jajko Wielkanoce",
				count = 1000
			},
			{
				chance = 100,
				item = 'kawa',
				label = "X-Gamer",
				count = 100
			},
			{
				chance = 50,
				item = 'clip_extended',
				label = "Powiększony magazynek",
				count = 2
			},
			{
				chance = 50,
				item = 'scope',
				label = "Celownik",
				count = 2
			},
			{
				chance = 50,
				item = 'suppressor',
				label = "Tłumik",
				count = 2
			},
			{
				chance = 50,
				item = 'grip',
				label = "Uchwyt",
				count = 2
			},
			{
				chance = 100,
				item = 'clip',
				label = "Magazynek",
				count = 180
			},
			{
				chance = 60,
				item = 'clipsmg',
				label = "Magazynek SMG",
				count = 5
			},
			{
				chance = 60,
				item = 'extendedclip',
				label = "Magazynek Długa",
				count = 5
			},
			{
				chance = 100,
				item = 'kamzaduza',
				label = "Duża kamizelka",
				count = 3
			},
			{
				chance = 40,
				item = 'kamzaduza',
				label = "Duża kamizelka",
				count = 3
			},
			{
				chance = 100,
				item = 'platynowakarta',
				label = "Platynowa karta",
				count = 1
			},
			{
				chance = 10,
				weapon = 'WEAPON_SMG',
				label = "SMG",
				count = 1
			},
			{
				chance = 10,
				weapon = 'WEAPON_COMBATPDW',
				label = "PDW",
				count = 1
			},
			{
				chance = 10,
				weapon = 'WEAPON_COMPACTRIFLE',
				label = "Mini Kałach",
				count = 1
			},
			{
				chance = 50,
				weapon = 'WEAPON_DOUBLEACTION',
				label = "Złoty Rewolwer",
				count = 1
			},
			{
				chance = 100,
				item = 'drill2',
				label = "Wiertło Drugiej Generacji",
				count = 1
			}
		},
		name = "Magazyn",
		blip = {
			id = 549,
			scale = 1.0,
			color = 49,
			label = 'Napad na Magazyn',
		},	
		type = 'magazyn',
		delay = {
			success = 2000,
			failure = 60,
		},
	},
	
	--Human 1,4-2,1
	["HumaneLabs"] = {
		position = { x = 3537.7297, y = 3659.6885, z = 28.1719 },
		reward = math.random(2900000, 3500000),
		name = "Humane Labs",
		requiredItems = {
			{
				item = "zlotakarta",
				label = "Złota karta"
			}
		},
		secondChance = 100,
		secondRewards = {
			{
				chance = 100,
				item = 'gwiazdki',
				label = "Jajko Wielkanoce",
				count = 800
			},
			{
				chance = 100,
				item = 'diamentowakarta',
				label = "Diamentowa karta",
				count = 1
			},
			{
				chance = 100,
				item = 'kawa',
				label = "X-Gamer",
				count = 80
			},
			{
				chance = 35,
				item = 'clip_extended',
				label = "Powiększony magazynek",
				count = 1
			},
			{
				chance = 35,
				item = 'scope',
				label = "Celownik",
				count = 1
			},
			{
				chance = 35,
				item = 'suppressor',
				label = "Tłumik",
				count = 1
			},
			{
				chance = 35,
				item = 'grip',
				label = "Uchwyt",
				count = 1
			},
			{
				chance = 100,
				item = 'clip',
				label = "Magazynek",
				count = 140
			},
			{
				chance = 50,
				item = 'clipsmg',
				label = "Magazynek SMG",
				count = 3
			},
			{
				chance = 50,
				item = 'extendedclip',
				label = "Magazynek Długa",
				count = 3
			},
			{
				chance = 100,
				item = 'kamzaduza',
				label = "Duża kamizelka",
				count = 1
			},
			{
				chance = 50,
				weapon = 'WEAPON_MACHINEPISTOL',
				label = "Pistolet Maszynowy",
				count = 1
			}
		},
		blip = {
			id = 499,
			scale = 0.8,
			color = 49,
			label = 'Napad na Humane Labs',
		},	
		type = 'humanelabs',
		delay = {
			success = 2800,
			failure = 60,
		},
	},

	["ZbrojowniaSASP"] = {
		position = { x = 569.08, y = -3124.75, z = 18.76 },
		reward = math.random(2900000, 3500000),
		name = "Zbrojownia",
		requiredItems = {
			{
				item = "zlotakarta",
				label = "Złota Karta"
			}
		},
		secondChance = 100,
		secondRewards = {
			{
				chance = 100,
				item = 'gwiazdki',
				label = "Jajko Wielkanoce",
				count = 800
			},
			{
				chance = 100,
				item = 'diamentowakarta',
				label = "Diamentowa karta",
				count = 1
			},
			{
				chance = 100,
				item = 'kawa',
				label = "X-Gamer",
				count = 80
			},
			{
				chance = 35,
				item = 'clip_extended',
				label = "Powiększony magazynek",
				count = 1
			},
			{
				chance = 35,
				item = 'scope',
				label = "Celownik",
				count = 1
			},
			{
				chance = 35,
				item = 'suppressor',
				label = "Tłumik",
				count = 1
			},
			{
				chance = 35,
				item = 'grip',
				label = "Uchwyt",
				count = 1
			},
			{
				chance = 100,
				item = 'clip',
				label = "Magazynek",
				count = 140
			},
			{
				chance = 50,
				item = 'clipsmg',
				label = "Magazynek SMG",
				count = 3
			},
			{
				chance = 50,
				item = 'extendedclip',
				label = "Magazynek Długa",
				count = 3
			},
			{
				chance = 100,
				item = 'kamzaduza',
				label = "Duża kamizelka",
				count = 1
			},
			{
				chance = 50,
				weapon = 'WEAPON_MACHINEPISTOL',
				label = "Pistolet Maszynowy",
				count = 1
			}
		},
		blip = {
			id = 556,
			scale = 0.8,
			color = 49,
			label = 'Napad na Zbrojownie',
		},	
		type = 'zbrojownia',
		delay = {
			success = 2600,
			failure = 60,
		},
	},
		
	--Maze
	["MazeBank"] = {
		position = { x = -1310.0148, y = -810.8741, z = 17.19 },
		reward = math.random(1900000, 2500000),
		requiredItems = {
			{
				item = "dysk",
				label = "Dysk z danymi"
			}
		},
		secondChance = 100,
		secondRewards = {
			{
				chance = 100,
				item = 'gwiazdki',
				label = "Jajko Wielkanoce",
				count = 600
			},
			{
				chance = 100,
				item = 'laptop',
				label = "Zaszyfrowany laptop",
				count = 1
			},
			{
				chance = 100,
				item = 'kawa',
				label = "X-Gamer",
				count = 50
			},
			{
				chance = 20,
				item = 'clip_extended',
				label = "Powiększony magazynek",
				count = 1
			},
			{
				chance = 20,
				item = 'scope',
				label = "Celownik",
				count = 1
			},
			{
				chance = 20,
				item = 'suppressor',
				label = "Tłumik",
				count = 1
			},
			{
				chance = 20,
				item = 'grip',
				label = "Uchwyt",
				count = 1
			},
			{
				chance = 100,
				item = 'clip',
				label = "Magazynek",
				count = 80
			}
		},
		name = "Maze Bank",
		blip = {
			id = 500,
			scale = 0.6,
			color = 49,
			label = 'Napad na Bank',
		},
		type = 'bank',
		delay = {
			success = 1000,
			failure = 60,
		},
	},
	-- 50-75
	["Casino"] = {
		position = { x = 1000.7908, y = 66.3221, z = 59.87 },
		reward = math.random(1500000, 2000000),
		requiredItems = {
            {
                item = "pendrive",
                label = "Pendrive"
            }
		},
		secondChance = 100,
		secondRewards = {
			{
				chance = 100,
				item = 'gwiazdki',
				label = "Jajko Wielkanoce",
				count = 450
			},
			{
				chance = 100,
				item = 'dysk',
				label = "Dysk z danymi",
				count = 1
			},
			{
				chance = 100,
				item = 'kawa',
				label = "X-Gamer",
				count = 30
			},
			{
				chance = 100,
				item = 'scratchcarddiamond',
				label = "Diamentowa Zdrapka",
				count = 2
			},
			{
				chance = 100,
				item = 'scratchcardgold',
				label = "Złota Zdrapka",
				count = 10
			},
			{
				chance = 100,
				item = 'clip',
				label = "Magazynek",
				count = 60
			}
		},
		name = "Casino",
		blip = {
			id = 674,
			scale = 0.8,
			color = 49,
			label = 'Napad na Casino Royale',
		},	
		type = 'sejf',
		delay = {
			success = 1000,
			failure = 60,
		},
	},
	
	--Pacyfik 800-1,115
	["Pacyfik"] = {
		position = { x = 254.238, y = 225.5682, z = 101.8257 },
		reward = math.random(2300000, 2700000),
		requiredItems = {
			{
				item = "laptop",
				label = "Zaszyfrowany laptop"
			}
		},
		secondChance = 100,
		secondRewards = {
			{
				chance = 100,
				item = 'zlotakarta',
				label = "Złota karta",
				count = 1
			},
			{
				chance = 100,
				item = 'gwiazdki',
				label = "Jajko Wielkanoce",
				count = 700
			},
			{
				chance = 100,
				item = 'kawa',
				label = "X-Gamer",
				count = 60
			},
			{
				chance = 25,
				item = 'clip_extended',
				label = "Powiększony magazynek",
				count = 1
			},
			{
				chance = 25,
				item = 'scope',
				label = "Celownik",
				count = 1
			},
			{
				chance = 25,
				item = 'suppressor',
				label = "Tłumik",
				count = 1
			},
			{
				chance = 25,
				item = 'grip',
				label = "Uchwyt",
				count = 1
			},
			{
				chance = 100,
				item = 'clip',
				label = "Magazynek",
				count = 100
			},
			{
				chance = 40,
				item = 'clipsmg',
				label = "Magazynek SMG",
				count = 2
			},
			{
				chance = 40,
				item = 'extendedclip',
				label = "Magazynek Długa",
				count = 2
			}
		},
		name = "Pacific Bank",
		blip = {
			id = 500,
			scale = 0.6,
			color = 49,
			label = 'Napad na Bank',
		},	
		type = 'yacht',
		delay = {
			success = 1000,
			failure = 60,
		},

	},
}
