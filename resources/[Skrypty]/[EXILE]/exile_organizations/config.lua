Config                            = {}
Config.Locale                     = 'pl'

Config.DrawDistance               = 10.0

Config.AuthorizedWeapons = {
    { 
        name = 'clip',
        tableName = 'pistolmk2',
        price = 2000,
        ammo = 1000
    },
    { 
        name = 'WEAPON_SNSPISTOL',
        tableName = 'snspistol',
        price = 50000,
        ammo = 1000
    },
}

Config.InstanceOrgs = {
    Cloakroom = {
        coords = vector3(-785.89, -2570.34, -35.06 -0.99),
    },
    Inventory = {
        from = 1
    },
    Licenses = {
        from = 3
    },
    MainMenu = {
        coords = vector3(-786.40, -2580.33, -35.06 - 0.99),
        from = 4
    },
    Barabasz = {},
}

Config.Blips = {
    -- ORGANIZACJE MAFIA
    ['org27'] = vector3(1399.516, 1139.5142, 113.3857),
    -- ORGANIZACJE GANGI
    ['org2'] = vector3(-23.23, -1398.39, 29.5),
    ['org4'] = vector3(1439.06, -1487.57, 65.66),
    ['org7'] = vector3(-720.14, -866.94, 26.77),
    ['org8'] = vector3(-1565.02, -405.84, 48.26),
    ['org9'] = vector3(-103.1082, -1788.5537, 0.0),
    ['org10'] = vector3(-1145.0708, -1514.5787, 9.6827),
    ['org16'] = vector3(350.9563, -2028.8875, 27.5493),
    ['org19'] = vector3(449.0246, -1893.5128, 25.7869),
    ['org29'] = vector3(989.8188, -136.2335, 73.1243),
    ['org30'] = vector3(1373.7263, -2095.7183, 47.6543),
    ['org72'] = vector3(898.8, -480.32, 62.81),
    ['org73'] = vector3(-1973.26, 244.37, 91.22),
    ['org74'] = vector3(812.03, -2311.6, 30.46),
    -- ORGANIZACJE BOJÓWKI
    ['org1'] = vector3(691.26, 604.86, 128.9),
    ['org3'] = vector3(579.06, 134.62, 98.04),
    ['org5'] = vector3(189.95, 308.91, 105.39),
    ['org6'] = vector3(-1855.01, -313.34, 49.14),
    ['org11'] = vector3(-2956.52, 58.79, 11.6),
    ['org12'] = vector3(-84.14, 1880.37, 197.28),
    ['org13'] = vector3(1206.82, 1857.49, 78.91),
    ['org14'] = vector3(-2231.94, 2420.56, 12.18),
    ['org15'] = vector3(1693.54, 3608.46, 35.35),
    ['org17'] = vector3(1651.1696, 4829.5596, 41.9),
    ['org18'] = vector3(1720.68, 4670.11, 43.22),
    ['org21'] = vector3(-680.26, 5797.82, 17.33),
    ['org22'] = vector3(735.84, 2533.59, 73.18),
    ['org23'] = vector3(-896.88, -985.09, 2.16),
    ['org24'] = vector3(-106.35, 2796.28, 53.34),
    ['org25'] = vector3(348.64, 3392.09, 36.4),
    ['org26'] = vector3(919.43, 3658.91, 32.5),
    ['org28'] = vector3(557.34, 2661.16, 42.18),
    ['org31'] = vector3(2680.34, 3515.4, 52.71),
    ['org32'] = vector3(1409.12, 3620.06, 34.89),
    ['org33'] = vector3(2888.1, 4383.1, 50.3),
    ['org34'] = vector3(2934.44, 4631.88, 48.54),
    ['org35'] = vector3(2465.08, 4100.46, 38.06),
    ['org36'] = vector3(1948.63, 3823.39, 32.1),
    ['org37'] = vector3(2662.09, 3272.92, 55.24),
    ['org38'] = vector3(2592.44, 3161.17, 50.83),
    ['org39'] = vector3(1174.47, 2725.05, 38.0),
    ['org40'] = vector3(2041.27, 3183.13, 45.22),
    ['org41'] = vector3(2411.59, 3137.7, 48.2),
    ['org42'] = vector3(2549.3, 341.68, 108.46),
    ['org43'] = vector3(1706.6, -1555.51, 112.63),
    ['org44'] = vector3(2832.01, 2799.7, 57.51),
    ['org45'] = vector3(884.46, -2177.13, 30.51),
    ['org64'] = vector3(726.73, 4170.97, 40.7),
    ['org47'] = vector3(784.16, -1625.04, 31.02),
    ['org48'] = vector3(906.73, -1518.72, 30.43),
    ['org49'] = vector3(911.06, -1265.17, 25.58),
    ['org50'] = vector3(703.63, -1142.61, 23.59),
    ['org51'] = vector3(2107.67, 3324.05, 45.37),
    ['org52'] = vector3(-244.71, 6065.94, 32.34),
    ['org53'] = vector3(-1350.64, -751.73, 22.31),
    ['org54'] = vector3(-29.6681, 3045.1851, 39.99),
    ['org55'] = vector3(1242.99, -3155.83, 5.52),
    ['org56'] = vector3(841.95, -1162.71, 25.26),
    ['org57'] = vector3(-189.47, -1289.82, 31.29),
    ['org58'] = vector3(1551.36, 2194.76, 78.87),
    ['org59'] = vector3(-1485.11, -199.82, 50.39),
    ['org60'] = vector3(190.44, 2456.29, 55.72),
    ['org61'] = vector3(153.04, 2279.83, 94.01),
    ['org62'] = vector3(-42.1, 1884.59, 195.45),
    ['org63'] = vector3(-1805.18, 442.2, 128.5),
    ['org46'] = vector3(1192.15, -1267.83, 35.16),
    ['org65'] = vector3(-762.14, 5947.61, 20.15),
    ['org66'] = vector3(781.49, 1274.58, 361.28),
    ['org67'] = vector3(-7.89, 3344.16, 41.46),
    ['org68'] = vector3(-765.14, 650.72, 145.5),
    ['org69'] = vector3(1320.61, 4314.57, 38.14),
    ['org70'] = vector3(-55.42, 6393.42, 31.49),
    ['org71'] = vector3(315.91, 501.47, 153.17),
}

Config.MaleTshirt = 423
Config.MaleTshirtdrugi = 422
Config.FemaleTshirt = 520

Config.MaleVest = 199
Config.FemaleVest = 272

Config.Organizacje = {
    org1 = {
		praca = 'org1',
    },
    org2 = {
		praca = 'org2',
    },
    org3 = {
		praca = 'org3',
    },
    org4 = {
		praca = 'org4',
    },
    org5 = {
		praca = 'org5',
        Tshirt = 1,
		Vest = 21,
    },
    org6 = {
		praca = 'org6',
    },
    org7 = {
		praca = 'org7',
    },
    org8 = {
		praca = 'org8',
    },
    org9 = {
		praca = 'org9',
    },
    org10 = {
		praca = 'org10',
    },
    org11 = {
		praca = 'org11',
    },
    org12 = {
		praca = 'org12',
    },
    org13 = {
		praca = 'org13',
        Tshirt = 8,
		Vest = 10,
    },
    org14 = {
		praca = 'org14',
        Tshirt = 13,
    },
    org15 = {
		praca = 'org15',
    },
    org16 = {
		praca = 'org16',
    },
    org17 = {
		praca = 'org17',
    },
    org18 = {
		praca = 'org18',
    },
    org19 = {
		praca = 'org19',
    },  
    org20 = {
		praca = 'org20',
    },
    org21 = {
		praca = 'org21',
    },
    org22 = {
		praca = 'org22',
        Tshirt = 10,
		Vest = 6,
    },
    org23 = {
		praca = 'org23',
    },
    org24 = {
		praca = 'org24',
    },
    org25 = {
		praca = 'org25',
        Tshirt = 4,
		Vest = 20,
    },
    org26 = {
		praca = 'org26',
    },
    org27 = {
		praca = 'org27',
    },
    org28 = {
		praca = 'org28',
        Tshirt = 2,
		Vest = 15,
    },
    org29 = {
		praca = 'org29',
    },
    org30 = {
		praca = 'org30',
    },
    org31 = {
		praca = 'org31',
        Tshirt = 1,
		Vest = 5,
    },
    org32 = {
		praca = 'org32',
        Tshirt = 5,
		Vest = 8,
    },
    org33 = {
		praca = 'org33',
    },
    org34 = {
		praca = 'org34',
    },
    org35 = {
		praca = 'org35',
    },
    org36 = {
		praca = 'org36',
    },
    org37 = {
		praca = 'org37',
    },
    org38 = {
		praca = 'org38',
    },
    org39 = {
		praca = 'org39',
    },
    org40 = {
		praca = 'org40',
    },
    org41 = {
		praca = 'org41',
        Tshirt = 12,
    },
    org42 = {
		praca = 'org42',
    },
    org43 = {
		praca = 'org43',
    },
    org44 = {
		praca = 'org44',
        Tshirt = 9,
		Vest = 12,
    },
    org45 = {
		praca = 'org45',
    },
    org46 = {
		praca = 'org46',
    },
    org47 = {
		praca = 'org47',
    },
    org48 = {
		praca = 'org48',
    },
    org49 = {
		praca = 'org49',
    },
    org50 = {
		praca = 'org50',
    },
    org51 = {
		praca = 'org51',
    },
    org52 = {
		praca = 'org52',
    },
    org53 = {
		praca = 'org53',
    },
    org54 = {
		praca = 'org54',
    },
    org55 = {
		praca = 'org55',
    },
    org56 = {
		praca = 'org56',
    },
    org57 = {
		praca = 'org57',
    },
    org58 = {
		praca = 'org58',
    },
    org59 = {
		praca = 'org59',
    },
    org60 = {
		praca = 'org60',
    },
    org61 = {
		praca = 'org61',
    },
    org62 = {
		praca = 'org62',
    },
    org63 = {
		praca = 'org63',
    },
    org64 = {
		praca = 'org64',
    },
    org65 = {
		praca = 'org65',
    },
    org66 = {
		praca = 'org66',
    },
    org67 = {
		praca = 'org67',
    },
    org68 = {
		praca = 'org68',
    },
    org69 = {
		praca = 'org69',
        Tshirt = 11,
		Vest = 14,
    },
    org70 = {
		praca = 'org70',
    },
    org71 = {
		praca = 'org71',
    },
    org72 = {
		praca = 'org72',
    },
    org73 = {
		praca = 'org73',
    },
    org74 = {
		praca = 'org74',
    },
}

Config.Zones = {
    --ORGANIZACJE MAFIA
    ['org27'] = {
        Cloakroom = {
            coords = vector3(1399.516, 1139.5142, 113.3857),
        },
        Inventory = {
            from = 1
        },
        Licenses = {
            from = 3
        },
        MainMenu = {
            coords = vector3(1394.9, 1149.82, 114.33-0.95),
            from = 4
        },
        Barabasz = {
 
        }
    },
    --ORGANIZACJE ZAKON
    ['org63'] = {
        Cloakroom = {
            coords = vector3(-1802.36, 430.25, 127.82),
        },
        Inventory = {
            from = 1
        },
        Licenses = {
            from = 3
        },
        MainMenu = {
            coords = vector3(-1792.71, 438.64, 127.38),
            from = 4
        },
        Barabasz = {
 
        }
    },
    --ORGANIZACJE GANGI
    ['org2'] = {
        Cloakroom = {
            coords = vector3(-26.22, -1412.73, 29.5-0.95),
        },
        Inventory = {
            from = 1
        },
        Licenses = {
            from = 3
        },
        MainMenu = {
            coords = vector3(-29.57, -1412.55, 29.5-0.95),
            from = 4
        },
        Barabasz = {
 
        }
    },
    ['org4'] = {
        Cloakroom = {
            coords = vector3(1444.90, -1485.99, 65.67),
        },
        Inventory = {
            from = 1
        },
        Licenses = {
            from = 3
        },
        MainMenu = {
            coords = vector3(1436.54, -1489.74, 62.75),
            from = 4
        },
        Barabasz = {
 
        }
    },
    ['org7'] = {
        Cloakroom = {
            coords = vector3(-723.48, -860.05, 26.77-0.95),
        },
        Inventory = {
            from = 1
        },
        Licenses = {
            from = 3
        },
        MainMenu = {
            coords = vector3(-725.38, -858.13, 27.2-0.95),
            from = 4
        },
        Barabasz = {
 
        }
    },
    ['org8'] = {
        Cloakroom = {
            coords = vector3(-1574.45, -409.28, 48.26-0.95),
        },
        Inventory = {
            from = 1
        },
        Licenses = {
            from = 3
        },
        MainMenu = {
            coords = vector3(-1558.76, -404.49, 48.26-0.95),
            from = 4
        },
        Barabasz = {
 
        }
    },
    ['org9'] = {
        Cloakroom = {
            coords = vector3(-80.34, -1808.88, 32.61),
        },
        Inventory = {
            from = 1
        },
        Licenses = {
            from = 3
        },
        MainMenu = {
            coords = vector3(-90.68, -1799.13, 32.59),
            from = 4
        },
        Barabasz = {
 
        }
    },
    ['org10'] = {
        Cloakroom = {
            coords = vector3(-1150.3606, -1513.3174, 9.6827),
        },
        Inventory = {
            from = 1
        },
        Licenses = {
            from = 3
        },
        MainMenu = {
            coords = vector3(-1156.7886, -1517.8723, 9.6827),
            from = 4
        },
        Barabasz = {
 
        }
    },
    ['org16'] = {
        Cloakroom = {
            coords = vector3(344.7008, -2022.0562, 21.4449),
        },
        Inventory = {
            from = 1
        },
        Licenses = {
            from = 3
        },
        MainMenu = {
            coords = vector3(339.88, -2031.51, 21.71-0.95),
            from = 4
        },
        Barabasz = {
 
        }
    },
    ['org19'] = {
        Cloakroom = {
            coords = vector3(438.224, -1891.2438, 30.7867),
        },
        Inventory = {
            from = 1
        },
        Licenses = {
            from = 3
        },
        MainMenu = {
            coords = vector3(439.5503, -1886.1097, 30.7892),
            from = 4
        },
        Barabasz = {
 
        }
    },
    ['org29'] = {
        Cloakroom = {
            coords = vector3(991.9748, -135.6655, 73.1243),
        },
        Inventory = {
            from = 1
        },
        Licenses = {
            from = 3
        },
        MainMenu = {
            coords = vector3(989.8188, -136.2335, 73.1243),
            from = 4
        },
        Barabasz = {
 
        }
    },
    ['org30'] = {
        Cloakroom = {
            coords = vector3(1377.502, -2096.0151, 51.6982),
        },
        Inventory = {
            from = 1
        },
        Licenses = {
            from = 3
        },
        MainMenu = {
            coords = vector3(1388.5182, -2079.8884, 51.6983),
            from = 4
        },
        Barabasz = {
 
        }
    },
    ['org72'] = {
        Cloakroom = {
            coords = vector3(898.8, -480.31, 62.81-0.95),
        },
        Inventory = {
            from = 1
        },
        Licenses = {
            from = 3
        },
        MainMenu = {
            coords = vector3(903.18, -487.67, 59.44-0.95),
            from = 4
        },
        Barabasz = {
 
        }
    },
    ['org73'] = {
        Cloakroom = {
            coords = vector3(-1973.26, 244.37, 91.22-0.95),
        },
        Inventory = {
            from = 1
        },
        Licenses = {
            from = 3
        },
        MainMenu = {
            coords = vector3(-1971.83, 249.26, 91.22-0.95),
            from = 4
        },
        Barabasz = {
 
        }
    },
    ['org74'] = {
        Cloakroom = {
            coords = vector3(805.8, -2334.44, 30.46-0.95),
        },
        Inventory = {
            from = 1
        },
        Licenses = {
            from = 3
        },
        MainMenu = {
            coords = vector3(810.89, -2333.63, 30.46-0.95),
            from = 4
        },
        Barabasz = {
 
        }
    },
}


Config.OpiumMenu = {
	coords = vector3(-58.14, -808.14, 242.43),
	owner = 'org27',
	from = 3
}

Config.ExctasyMenu = {
	coords = vector3(-59.21, -811.30, 242.43),
	owner = 'org27',
	from = 3
}

Config.NotGang = {
    'org1',
    'org3',
    'org5',
    'org31',
    'org6',
    'org11',
    'org12',
    'org13',
    'org14',
    'org15',
    'org17',
    'org18',
    'org19',
    'org20',
    'org21',
    'org22',
    'org24',
    'org25',
    'org26',
    'org27',
    'org28',
    'org29',
    'org30',
    'org32',
    'org33',
    'org34',
    'org35',
    'org36',
    'org37',
    'org38',
    'org39',
    'org40',
    'org41',
    'org42',
    'org43',
    'org44',
    'org45',
    'org46',
    'org47',
    'org48',
    'org49',
    'org50',
    'org51',
    'org52',
    'org53',
    'org54',
    'org55',
    'org56',
    'org57',
    'org58',
    'org59',
    'org60',
    'org61',
    'org62',
    'org63',
    'org64',
    'org65',
    'org66',
    'org67',
    'org68',
    'org69',
    'org70',
    'org71',
}

Config.DriveByList = {
    ['org2'] = true,
	['org4'] = true,
    ['org7'] = true,
    ['org8'] = true,
    ['org9'] = true,
    ['org10'] = true,
    ['org16'] = true,
    ['org19'] = true,
	['org29'] = true,
	['org30'] = true,
    ['org72'] = true,
    ['org73'] = true,
    ['org74'] = true,
}