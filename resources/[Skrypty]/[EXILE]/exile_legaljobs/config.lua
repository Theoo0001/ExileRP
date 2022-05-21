Config                            = {}
Config.Locale                     = 'pl'

Config.DrawDistance               = 10.0

Config.Blips = {
}
Config.DystansMarkerowPrac = 3.5
Config.MarkeryPrac = {
	{
		coords = {x = -539.2766, y = -184.7799, y = 46.5961},
        nazwa  = "~y~TAXI"
    },
}

Config.Zones = {
	['casino'] = {
		Hiddenjob = false,
        Cloakroom = {
            coords = vector3(958.1458, 63.09597, 74.44268),
            jobCloakroom = true
        },
        Inventory = {
            coords = vector3(960.0262, 55.23758, 74.44268),
            from = 1
        },
		Shops = {
			coords = vector3(962.3283, 59.92532, 74.4427),
		},
        Vehicles = {
            coords = vector3(932.5914, 30.9081, 80.2564),
            heading = 237.28,
            from = 4
        },
        BossMenu = {
            coords = vector3(955.3198, 56.15408, 74.45261),
            from = 5
        }
    },
    ['cardealer'] = {
			Hiddenjob = false,
			Cloakroom = {
					coords = vector3(129.91, -1506.85, 28.30),
					jobCloakroom = false
			},
			Inventory = {
					coords = vector3(113.32, -1523.57, 28.30),
					from = 1
			},
			Vehicles = {
					coords = vector3(150.6037, -120.6873, 53.4639),
					heading = 109.79,
					from = 2
			},
			BossMenu = {
					coords = vector3(112.285, -1517.25, 28.30),
					from = 5
			}
	},
	['galaxy'] = {
		Hiddenjob = false,
        Cloakroom = {
            coords = vector3(-1368.014, -613.19, 30.31926),
            jobCloakroom = false
        },
        Inventory = {
            coords = vector3(-1369.169, -624.5537, 30.31941),
            from = 6
		},
		Inventory2 = {
            coords = vector3(-1392.005, -611.8149, 29.31926),
            from = 6
        },
        Vehicles = {
            coords = vector3(-1403.3220, -633.7329, 27.71927),
            heading = 75.36,
            from = 6
        },
        BossMenu = {
            coords = vector3(-1366.265, -624.1773, 30.3254),
            from = 8
        }
    },
    ['kawiarnia'] = {
		Hiddenjob = false,
        Cloakroom = {
            coords = vector3(-634.5056, 226.1294, 80.9315),
            jobCloakroom = false
        },
        Inventory = {
            coords = vector3(-631.0939, 224.6994, 80.9315),
            from = 7
		},
	},
	['winiarz'] = {
		Hiddenjob = false,
        Cloakroom = {
            coords = vector3(-1915.885, 2084.544, 139.393),
            jobCloakroom = false
        },
        Inventory = {
            coords = vector3(-1923.362, 2054.509, 139.8413),
            from = 7
		},
	},
	['weazel'] = {
		Hiddenjob = false,
        Inventory = {
            coords = vector3(-560.1867, -884.0121, 24.30),
            from = 6
		},
	},
	['taxi'] = {
		Hiddenjob = false,
        Inventory = {
            coords = vector3(891.2372, -177.1373, 73.8),
            from = 7
		},
	},
	['burgershot'] = {
		Hiddenjob = false,
        Inventory = {
            coords = vector3(-1202.41, -895.03, 13.99-0.95),
            from = 7
		},
	},
	['pizzeria'] = {
		Hiddenjob = false,
        Inventory = {
            coords = vector3(796.2, -756.41, 31.26-0.95),
            from = 7
		},
	},
	['milkman'] = {
		Hiddenjob = false,
        Inventory = {
            coords = vector3(55.09, -1585.81, 29.72-0.99),
            from = 7
		},
	},
	['slaughter'] = {
		Hiddenjob = false,
        Inventory = {
            coords = vector3(-75.96, 6256.21, 31.09-0.99),
            from = 7
		},
	},
	['courier'] = {
		Hiddenjob = false,
        Inventory = {
            coords = vector3(-427.55, -2789.59, 6.53-0.99),
            from = 7
		},
	},
	['fisherman'] = {
		Hiddenjob = false,
        Inventory = {
            coords = vector3(-796.1714, -1351.6652, 4.28),
            from = 7
		},
	},
	['krawiec'] = {
		Hiddenjob = false,
        Inventory = {
            coords = vector3(739.23, -948.7, 25.63-0.95),
            from = 7
		},
	},
	['doj'] = {
        Hiddenjob = false,
        Cloakroom = {
            coords = vector3(253.2805, -1100.3337, 35.183),
            jobCloakroom = false
        },
        Inventory = {
            coords = vector3(247.7734, -1095.5784, 35.183),
            from = 2
        },
        BossMenu = {
            coords = vector3(249.2341, -1100.3411, 35.2041),
            from = 5
        }
    },
		['psycholog'] = {
			Hiddenjob = false,
					Cloakroom = {
							coords = vector3(-1004.25, -476.89, 49.13),
							jobCloakroom = false
					},
					Inventory = {
							coords = vector3(-1006.44, -473.8, 49.13),
							from = 3
					},
					BossMenu = {
							coords = vector3(-1008.27, -475.14, 49.13),
							from = 5
					}
			},
	['extreme'] = {
		Hiddenjob = false,
        Cloakroom = {
            coords = vector3(-786.86, -1351.29, 4.31),
            jobCloakroom = true
        },
        Inventory = {
            coords = vector3(-789.53, -1349.58, 4.31),
            from = 1
        },
        Vehicles = {
            coords = vector3(-777.61, -1336.11, 4.10),
			heading = 79.63,
            from = 2
        },
		Planes = {
			coords = vector3(2142.42, 4783.86, 40.07),
			spawn = vector3(2122.99, 4805.55, 40.3),
            heading = 111.81,
            from = 2
		},
		Boats = {
			coords = vector3(-848.85, -1367.66, 0.71),
			spawn = vector3(-863.44, -1373.47, 0.4),
            heading = 112.17,
            from = 2
		},
		Shops = {
			coords = vector3(-786.98, -1349.36, 4.31)
		},
		DeleteBoats = {
			coords = vector3(-863.44, -1373.47, 0.02),
		},
		DeleteVehicles = {
			coords = vector3(2122.99, 4805.55, 40.3),
		},
        BossMenu = {
            coords = vector3(-804.27, -1368.97, 4.32),
            from = 3
        }
    },
	['sheriff'] = {
		Hiddenjob = true,
		BossMenu = {
			coords = vector3(1852.5, 3689.62, 33.37),
			from = 10
		},
		Inventory = {
            coords = vector3(1850.8741, 3688.5896, 33.36),
            from = 0
        }
	},
	['wiesbuda'] = {
		Hiddenjob = false,
         Cloakroom = {
             coords = vector3(726.5392, -1066.6198, 27.3611),
             jobCloakroom = true
         },
        Vehicles = {
            coords = vector3(710.6559, -1083.4513, 21.4543),
			heading = 3.74,
            from = 0
        },
		DeleteVehicles = {
			coords = vector3(707.5789, -1077.0809, 21.4523),
		},
        BossMenu = {
            coords = vector3(726.3586, -1069.6901, 27.3611),
            from = 1
        }
    },
}

Config.Interactions = {
	['casino'] = {
		Repair = 4,
		Handcuff = 0
	},
	['cardealer'] = {
		Repair = 2,
		kontrakt = 0
	},
	['doj'] = {
		Repair = 2,
		Handcuff = 2
	},
    ['extreme'] = {
		Repair = 3,
        License = 4
    },
	['psycholog'] = {
		Repair = 5,
		Handcuff = 0
        --License = 4
    },
	['wiesbuda'] = {
		CostamxD = 0,
        --License = 4
    },
}

Config.Shops = {
	['casino'] = {
		{
			label = "Harnaś 0.5L",
			value = "beer",
			from = 2,
			type = 'item',
			quantity = 10
		},
		{
			label = "Soplica 0.7L",
			value = "vodka",
			from = 2,
			type = 'item',
			quantity = 10
		},
		{
			label = "Jack Daniels 0.7L",
			value = "whisky",
			from = 2,
			type = 'item',
			quantity = 10
		},
		{
			label = "Tequila 0.7L",
			value = "tequila",
			from = 2,
			type = 'item',
			quantity = 10
		},
		{
			label = "Szklanka burbonu",
			value = "burbon",
			from = 2,
			type = 'item',
			quantity = 10
		},
		{
			label = "Butelka cydru",
			value = "cydr",
			from = 2,
			type = 'item',
			quantity = 10
		},
		{
			label = "200ml koniaku",
			value = "koniak",
			from = 2,
			type = 'item',
			quantity = 10
		},
	},
	['extreme'] = {
		{
			label = "Spadochron",
			value = "GADGET_PARACHUTE",
			from = 2,
			type = 'weapon',
			quantity = 1
		},
		{
			label = "Strój nurka - Czerwony",
			value = "nurek_1",
			from = 2,
			type = 'item',
			quantity = 1
		},
		{
			label = "Strój nurka - Zielony",
			value = "nurek_2",
			from = 2,
			type = 'item',
			quantity = 1
		},
		{
			label = "Strój nurka - Żółty",
			value = "nurek_3",
			from = 2,
			type = 'item',
			quantity = 1
		},
		{
			label = "Strój nurka - Panterka",
			value = "nurek_4",
			from = 2,
			type = 'item',
			quantity = 1
		},{
			label = "Strój nurka - Moro",
			value = "nurek_5",
			from = 2,
			type = 'item',
			quantity = 1
		},
		{
			label = "Strój nurka - Różowy",
			value = "nurek_6",
			from = 2,
			type = 'item',
			quantity = 1
		},
	}
}

Config.Planes = {
	['extreme'] = {
		{
            name = 'Supervolito2',
            label = "[HELI] Volito",
            from = 2
		},
		{
            name = 'volatus',
            label = "[HELI] Volatus",
            from = 2
        },
		{
            name = 'microlight',
            label = "[PLANE] Microlight",
            from = 2
        },
		{
            name = 'vestra',
            label = "[PLANE] Vestra",
            from = 2
        },
		{
            name = 'luxor',
            label = "[PLANE] Luxor",
            from = 2
        },
	}
}

Config.Boats = {
	['extreme'] = {
		{
            name = 'dinghy',
            label = "[BOAT] Dinghy",
            from = 2
        },
		{
            name = 'toro',
            label = "[BOAT] Toro",
            from = 2
        },
		{
            name = 'marquis',
            label = "[BOAT] Marquis",
            from = 2
        },
		{
            name = 'submersible',
            label = "[BOAT] Submersible",
            from = 2
        },
		{
            name = 'submersible2',
            label = "[BOAT] Submersible 2",
            from = 2
        }
	}
}

Config.Vehicles = {
	['casino'] = {
		{
			name = 'mb300sl',
			label = "Mercedes 300 SL",
			from = 5
		},
		{
			name = 'case63',
			label = "Mercedes E63 AMG",
			from = 5
		},
		{
			name = 'casgle',
			label = "Mercedes GLE53S AMG",
			from = 6
		}
	},
	['cardealer'] = {
		{ 
			name = 'nero2',
			label = "Nero 2",
			from = 2
		}
	},
	['galaxy'] = {
		{ 
			name = 'pbus2',
			label = "PBus",
			from = 0
		},
		{ 
			name = 'nspeedo5',
			label = "Dostawczak",
			from = 0
		},
		
		{ 
			name = 'patriot2',
			label = "Patriot",
			from = 0
		},
		{ 
			name = 'stretch',
			label = "Stretch",
			from = 0
		}
	},
	['extreme'] = {
		{ 
			name = 'nero2',
			label = "Nero 2",
			from = 2
		}
	},
	['wiesbuda'] = {
		{
			name = 'Mule3',
			label = "Ciezarowka",
			from = 0
		},
		{
			name = 'Rallytruck',
			label = "Wieksza Cieżarówka",
			from = 1
		},
		{
			name = 'Forklift',
			label = "Podnośnik",
			from = 0
		},
		{
			name = 'Boxville',
			label = "Cieżaróweczka",
			from = 0
		},
		{
			name = 'Trailers2',
			label = "Naczepa",
			from = 0
		},
		{
			name = 'Hauler',
			label = "Tir",
			from = 0
		},
		{
			name = 'Caddy3',
			label = "Narzędnik",
			from = 0
		}
	},
}	

Config.ItemsUniforms = {
	nurek_1 = {
		male = {
			['tshirt_1'] = 123,  ['tshirt_2'] = 0,
			['torso_1'] = 243,   ['torso_2'] = 3,
			['arms'] = 1,
			['pants_1'] = 94,   ['pants_2'] = 3,
			['shoes_1'] = 67,   ['shoes_2'] = 0,
			['glasses_1'] = 26, ['glasses_2'] = 0,
			['bags_1'] = 0,	['bags_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['mask_1'] = 0,	['mask_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
		},
		female = {
			['tshirt_1'] = 153,  ['tshirt_2'] = 0,
			['torso_1'] = 251,   ['torso_2'] = 3,
			['arms'] = 0,
			['pants_1'] = 97,   ['pants_2'] = 3,
			['shoes_1'] = 70,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['bags_1'] = 0,	['bags_2'] = 0,
			['glasses_1'] = 28,	['glasses_2'] = 0,
			['mask_1'] = 0,	['mask_2'] = 0,
		}
	},
	nurek_2 = {
		male = {
			['tshirt_1'] = 123,  ['tshirt_2'] = 0,
			['torso_1'] = 243,   ['torso_2'] = 5,
			['arms'] = 1,
			['pants_1'] = 94,   ['pants_2'] = 5,
			['shoes_1'] = 67,   ['shoes_2'] = 0,
			['glasses_1'] = 26, ['glasses_2'] = 0,
			['bags_1'] = 0,	['bags_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['mask_1'] = 0,	['mask_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
		},
		female = {
			['tshirt_1'] = 153,  ['tshirt_2'] = 0,
			['torso_1'] = 251,   ['torso_2'] = 5,
			['arms'] = 0,
			['pants_1'] = 97,   ['pants_2'] = 5,
			['shoes_1'] = 70,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['bags_1'] = 0,	['bags_2'] = 0,
			['glasses_1'] = 28,	['glasses_2'] = 0,
			['mask_1'] = 0,	['mask_2'] = 0,
		}
	},
	nurek_3 = {
		male = {
			['tshirt_1'] = 123,  ['tshirt_2'] = 0,
			['torso_1'] = 243,   ['torso_2'] = 7,
			['arms'] = 1,
			['pants_1'] = 94,   ['pants_2'] = 7,
			['shoes_1'] = 67,   ['shoes_2'] = 0,
			['glasses_1'] = 26, ['glasses_2'] = 0,
			['bags_1'] = 0,	['bags_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['mask_1'] = 0,	['mask_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
		},
		female = {
			['tshirt_1'] = 153,  ['tshirt_2'] = 0,
			['torso_1'] = 251,   ['torso_2'] = 7,
			['arms'] = 0,
			['pants_1'] = 97,   ['pants_2'] = 7,
			['shoes_1'] = 70,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['bags_1'] = 0,	['bags_2'] = 0,
			['glasses_1'] = 28,	['glasses_2'] = 0,
			['mask_1'] = 0,	['mask_2'] = 0,
		}
	},
	nurek_4 = {
		male = {
			['tshirt_1'] = 123,  ['tshirt_2'] = 0,
			['torso_1'] = 243,   ['torso_2'] = 16,
			['arms'] = 1,
			['pants_1'] = 94,   ['pants_2'] = 16,
			['shoes_1'] = 67,   ['shoes_2'] = 0,
			['glasses_1'] = 26, ['glasses_2'] = 0,
			['bags_1'] = 0,	['bags_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['mask_1'] = 0,	['mask_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
		},
		female = {
			['tshirt_1'] = 153,  ['tshirt_2'] = 0,
			['torso_1'] = 251,   ['torso_2'] = 16,
			['arms'] = 0,
			['pants_1'] = 97,   ['pants_2'] = 16,
			['shoes_1'] = 70,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['bags_1'] = 0,	['bags_2'] = 0,
			['glasses_1'] = 28,	['glasses_2'] = 0,
			['mask_1'] = 0,	['mask_2'] = 0,
		}
	},
	nurek_5 = {
		male = {
			['tshirt_1'] = 123,  ['tshirt_2'] = 0,
			['torso_1'] = 243,   ['torso_2'] = 18,
			['arms'] = 1,
			['pants_1'] = 94,   ['pants_2'] = 18,
			['shoes_1'] = 67,   ['shoes_2'] = 0,
			['glasses_1'] = 26, ['glasses_2'] = 0,
			['bags_1'] = 0,	['bags_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['mask_1'] = 0,	['mask_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
		},
		female = {
			['tshirt_1'] = 153,  ['tshirt_2'] = 0,
			['torso_1'] = 251,   ['torso_2'] = 18,
			['arms'] = 0,
			['pants_1'] = 97,   ['pants_2'] = 18,
			['shoes_1'] = 70,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['bags_1'] = 0,	['bags_2'] = 0,
			['glasses_1'] = 28,	['glasses_2'] = 0,
			['mask_1'] = 0,	['mask_2'] = 0,
		}
	},
	nurek_6 = {
		male = {
			['tshirt_1'] = 123,  ['tshirt_2'] = 0,
			['torso_1'] = 243,   ['torso_2'] = 25,
			['arms'] = 1,
			['pants_1'] = 94,   ['pants_2'] = 25,
			['shoes_1'] = 67,   ['shoes_2'] = 0,
			['glasses_1'] = 26, ['glasses_2'] = 0,
			['bags_1'] = 0,	['bags_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['mask_1'] = 0,	['mask_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
		},
		female = {
			['tshirt_1'] = 153,  ['tshirt_2'] = 0,
			['torso_1'] = 251,   ['torso_2'] = 25,
			['arms'] = 0,
			['pants_1'] = 97,   ['pants_2'] = 25,
			['shoes_1'] = 70,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['bproof_1'] = 0,  ['bproof_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['bags_1'] = 0,	['bags_2'] = 0,
			['glasses_1'] = 28,	['glasses_2'] = 0,
			['mask_1'] = 0,	['mask_2'] = 0,
		}
	},
}

Config.Uniforms = {
    ['extreme'] = {
        {
            label = "Pracownik",
            values = {
				male = {
					['tshirt_1'] = 22,  ['tshirt_2'] = 4,
					['torso_1'] = 21,   ['torso_2'] = 0,
					['arms'] = 35,
					['pants_1'] = 10,   ['pants_2'] = 7,
					['shoes_1'] = 101,   ['shoes_2'] = 24,
					['glasses_1'] = 5, ['glasses_2'] = 0,
					['bags_1'] = 0,	['bags_2'] = 0,
					['bproof_1'] = 0,  ['bproof_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['mask_1'] = 169,	['mask_2'] = 0,
					['chain_1'] = 0, ['chain_2'] = 0,
				},
				female = {
					['tshirt_1'] = 153,  ['tshirt_2'] = 0,
					['torso_1'] = 251,   ['torso_2'] = 18,
					['arms'] = 0,
					['pants_1'] = 97,   ['pants_2'] = 18,
					['shoes_1'] = 70,   ['shoes_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['bproof_1'] = 0,  ['bproof_2'] = 0,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['bags_1'] = 0,	['bags_2'] = 0,
					['glasses_1'] = 28,	['glasses_2'] = 0,
					['mask_1'] = 0,	['mask_2'] = 0,
				}
			},
            ranks = {0,1,2,3,4}
        },
    },
	['casino'] = {
		{
			label = 'Ubranie pracownika - Biała koszula',
			values = {
				male = {
					['tshirt_1'] = 15,  ['tshirt_2'] = 0,
					['torso_1'] = 349,   ['torso_2'] = 1,
					['arms'] = 37, 		['arms_2'] = 0,
					['pants_1'] = 134,   ['pants_2'] = 0,
					['shoes_1'] = 10,   ['shoes_2'] = 0,
					['glasses_1'] = 5, ['glasses_2'] = 1,
					['bags_1'] = 0,	['bags_2'] = 0,
					['bproof_1'] = 0,  ['bproof_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['mask_1'] = 169,	['mask_2'] = 0,
					['chain_1'] = 165, ['chain_2'] = 1,
				},
				female = {
					['tshirt_1'] = 22,  ['tshirt_2'] = 4,
					['torso_1'] = 11,   ['torso_2'] = 1,
					['arms'] = 4, 		['arms_2'] = 0,
					['pants_1'] = 24,   ['pants_2'] = 0,
					['shoes_1'] = 10,   ['shoes_2'] = 0,
					['glasses_1'] = 5, ['glasses_2'] = 1,
					['bags_1'] = 0,	['bags_2'] = 0,
					['bproof_1'] = 0,  ['bproof_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['mask_1'] = 0,	['mask_2'] = 0,
					['chain_1'] = 0, ['chain_2'] = 0,
				}
			},
			ranks = {0,1,2,3,4,5,6}
		},
		{
			label = 'Ubranie pracownika - Kamizelka',
			values = {
				male = {
					['tshirt_1'] = 15,  ['tshirt_2'] = 0,
					['torso_1'] = 349,   ['torso_2'] = 1,
					['arms'] = 37, 		['arms_2'] = 0,
					['pants_1'] = 134,   ['pants_2'] = 0,
					['shoes_1'] = 10,   ['shoes_2'] = 0,
					['glasses_1'] = 5, ['glasses_2'] = 1,
					['bags_1'] = 0,	['bags_2'] = 0,
					['bproof_1'] = 7,  ['bproof_2'] = 1,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['mask_1'] = 169,	['mask_2'] = 0,
					['chain_1'] = 165, ['chain_2'] = 1,
				},
				female = {
					['tshirt_1'] = 22,  ['tshirt_2'] = 4,
					['torso_1'] = 11,   ['torso_2'] = 1,
					['arms'] = 4, 		['arms_2'] = 0,
					['pants_1'] = 24,   ['pants_2'] = 0,
					['shoes_1'] = 10,   ['shoes_2'] = 0,
					['glasses_1'] = 5, ['glasses_2'] = 1,
					['bags_1'] = 0,	['bags_2'] = 0,
					['bproof_1'] = 0,  ['bproof_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['mask_1'] = 0,	['mask_2'] = 0,
					['chain_1'] = 0, ['chain_2'] = 0,
				}
			},
			ranks = {2,3,4,5,6}
		},
		{
			label = 'Ubranie managera',
			values = {
				male = {
					['tshirt_1'] = 31,  ['tshirt_2'] = 0,
					['torso_1'] = 294,   ['torso_2'] = 0,
					['arms'] = 37, 		['arms_2'] = 0,
					['pants_1'] = 134,   ['pants_2'] = 0,
					['shoes_1'] = 10,   ['shoes_2'] = 0,
					['glasses_1'] = 5, ['glasses_2'] = 1,
					['bags_1'] = 0,	['bags_2'] = 0,
					['bproof_1'] = 0,  ['bproof_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['mask_1'] = 169,	['mask_2'] = 0,
					['chain_1'] = 165, ['chain_2'] = 1,
				},
				female = {
					['tshirt_1'] = 22,  ['tshirt_2'] = 4,
					['torso_1'] = 11,   ['torso_2'] = 1,
					['arms'] = 4, 		['arms_2'] = 0,
					['pants_1'] = 24,   ['pants_2'] = 0,
					['shoes_1'] = 10,   ['shoes_2'] = 0,
					['glasses_1'] = 5, ['glasses_2'] = 1,
					['bags_1'] = 0,	['bags_2'] = 0,
					['bproof_1'] = 0,  ['bproof_2'] = 0,
					['helmet_1'] = -1,  ['helmet_2'] = 0,
					['decals_1'] = 0,   ['decals_2'] = 0,
					['mask_1'] = 0,	['mask_2'] = 0,
					['chain_1'] = 0, ['chain_2'] = 0,
				}
			},
			ranks = {4,5,6}
		},
	}
}