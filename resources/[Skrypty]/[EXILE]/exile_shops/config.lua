Config              = {}
Config.DrawDistance = 5
Config.Size   		= {x = 1.3, y = 1.3, z = 1.0}
Config.Color  		= {r = 15, g = 163, b = 255}
Config.Type   		= 27

Config.LombardItems = {
	{
		label = "Telefon",
		price = '250',
		item = "phone",
	},
	{
		label = "Biżuteria",
		price = '5000',
		item = "bizuteria",
	},
	{
		label = "Kajdanki",
		price = '1000',
		item = "handcuff",
	},
	{
		label = "Krótkofalówka",
		price = '1000',
		item = "krotkofalowka",
	},
	{
		label = "Zestaw Naprawczy",
		price = '500',
		item = "fixkit2",
	},
	{
		label = "GoPro",
		price = '250',
		item = "gopro",
	},
	{
		label = "Zmiana rejestracji w pojeździe",
		price = '100000',
		item = "bon1",
	},
}

Config.Zones = {

	Gofry = {
		Blips = false,
		Blip = {
			Sprite = 52,
			Color = 11,
			Name = "Gofry",
		},
		info = 'shop247',
		Items = {
			{title = 'Gofry z cukrem pudrem', item = 'gofry', price = 100, limit = 30},
			{title = 'Gofry z owocami', item = 'gofry2', price = 100, limit = 30},
			{title = 'Gofry z bitą śmietaną', item = 'gofry3', price = 100, limit = 30},
		},
		Name = "Gofry",	
		Pos = {
			{x = -1193.66, y = -1539.97, z = 4.37-0.95},
		}
	},

	Apteka = {
		Blips = false,
		Blip = {
			Sprite = 621,
			Color = 1,
			Name = "Apteka",
		},
		info = 'apteka',
		Items = {
			{title = 'Bandaż', item = 'bandaz', price = 5000, limit = 30},
		},
		Name = "Apteka",	
		Pos = {
			{x = 326.97, y = -1073.5, z = 29.47-0.95},
		}
	},

	SpozywczySZ = {
		Blips = false,
		Blip = {
			Sprite = 52,
			Color = 11,
			Name = "24/7 Sklep",
		},
		info = 'shop247',
		Items = {
			{title = 'X-Gamer', item = 'kawa', price = 1200, limit = 100},
			{title = 'Chleb', item = 'bread', price = 25, limit = 30},
			{title = 'Chipsy', item = 'chipsy', price = 30, limit = 30},
			{title = 'Ciasteczka', item = 'cupcake', price = 35, limit = 30},
			{title = 'Hamburger', item = 'hamburger', price = 40, limit = 30},
			{title = 'Czekolada', item = 'chocolate', price = 30, limit = 30},
			{title = 'Woda', item = 'water', price = 20, limit = 30},
			{title = 'CocaCola', item = 'cola', price = 30, limit = 30},
			{title = 'IceTea', item = 'icetea', price = 25, limit = 30},
			{title = 'Mleko', item = 'milk', price = 25, limit = 30},
			{title = 'Zapalniczka', item = 'zapalniczka', price = 250, limit = 5},
			{title = 'Papieros', item = 'papieros', price = 50, limit = 30},
			{title = 'Crusher', item = 'crusher', price = 200, limit = 30},
			{title = 'Bletka', item = 'bletka', price = 20, limit = 30},
			{title = 'Róża', item = 'roza', price = 3000, limit = 5},
			{title = 'Kocyk', item = 'kocyk', price = 10000, limit = 5},
			{title = 'Lek dla Seniora', item = 'lekemeryt', price = 1000, limit = 5},
			{title = 'Zdrapka Silver', item = 'scratchcard', price = 3000, limit = 30},
			{title = 'Zdrapka Gold', item = 'scratchcardgold', price = 15000, limit = 30},
			{title = 'Zdrapka Diamond', item = 'scratchcarddiamond', price = 50000, limit = 30},
		},
		Name = "Sklep Szpitalny",	
		Pos = {
			{x = 316.37, y = -588.85, z = 43.29-0.95},
		}
	},

	Spozywczy = {
		Blips = true,
		Blip = {
			Sprite = 52,
			Color = 11,
			Name = "24/7 Sklep",
		},
		info = 'shop247',
		Items = {
			{title = 'X-Gamer', item = 'kawa', price = 1200, limit = 100},
			{title = 'Chleb', item = 'bread', price = 25, limit = 30},
			{title = 'Chipsy', item = 'chipsy', price = 30, limit = 30},
			{title = 'Ciasteczka', item = 'cupcake', price = 35, limit = 30},
			{title = 'Hamburger', item = 'hamburger', price = 40, limit = 30},
			{title = 'Czekolada', item = 'chocolate', price = 30, limit = 30},
			{title = 'Woda', item = 'water', price = 20, limit = 30},
			{title = 'CocaCola', item = 'cola', price = 30, limit = 30},
			{title = 'IceTea', item = 'icetea', price = 25, limit = 30},
			{title = 'Mleko', item = 'milk', price = 25, limit = 30},
			{title = 'Zapalniczka', item = 'zapalniczka', price = 250, limit = 5},
			{title = 'Papieros', item = 'papieros', price = 50, limit = 30},
			{title = 'Crusher', item = 'crusher', price = 200, limit = 30},
			{title = 'Bletka', item = 'bletka', price = 20, limit = 30},
			{title = 'Róża', item = 'roza', price = 3000, limit = 5},
			{title = 'Kocyk', item = 'kocyk', price = 10000, limit = 5},
			{title = 'Lek dla Seniora', item = 'lekemeryt', price = 1000, limit = 5},
			{title = 'Zdrapka Silver', item = 'scratchcard', price = 3000, limit = 30},
			{title = 'Zdrapka Gold', item = 'scratchcardgold', price = 15000, limit = 30},
			{title = 'Zdrapka Diamond', item = 'scratchcarddiamond', price = 50000, limit = 30},
		},
		Name = "24/7 Sklep",	
		Pos = {
			{x = 373.875,   y = 325.896,  z = 102.566},--
			{x = 2557.458,  y = 382.282,  z = 107.622},--
			{x = -3038.939, y = 585.954,  z = 6.908},--
			{x = -3241.927, y = 1001.462, z = 11.830},--
			{x = 547.431,   y = 2671.710, z = 41.156},--
			{x = 1961.464,  y = 3740.672, z = 31.343},--
			{x = 2678.916,  y = 3280.671, z = 54.241},--
			{x = 1729.216,  y = 6414.131, z = 34.037},--
			{x = 1135.808,  y = -982.281,  z = 45.415},--
			{x = -1222.915, y = -906.983,  z = 11.326},--
			{x = -1487.553, y = -379.107,  z = 39.163},--
			{x = -2968.243, y = 390.910,   z = 14.043},--
			{x = 1166.024,  y = 2708.930,  z = 37.157},--
			{x = 1392.562,  y = 3604.684,  z = 33.980},--
			{x = 25.723,   y = -1346.966, z = 28.497}, --
			{x = -48.519,   y = -1757.514, z = 28.421},--
			{x = -1076.792,   y = -2785.769, z = 28.471},--
			{x = 1163.373,  y = -323.801,  z = 68.205},--
			{x = -707.501,  y = -914.260,  z = 18.215},---
			{x = -1820.523, y = 792.518,   z = 137.118},---
			{x = 1698.388,  y = 4924.404,  z = 41.063}, -- 
			{x = 4467.88,  y = -4465.3218,  z = 3.34},--
		}
	},

	Klub = {
		Blips = true,
		Blip = {
			Sprite = 93,
			Color = 27,
			Name = "Klub Nocny",
		},
		info = 'klub',
		Items = {
			{title = 'Piwo', item = 'beer', price = 200, limit = 30},
			{title = 'Vodka', item = 'vodka', price = 300, limit = 30},
			{title = 'Whisky', item = 'whisky', price = 500, limit = 30},
		},
		Pos = {
			{x = 128.0,  y = -1285.18,  z = 28.30},
			{x = -560.05,  y = 287.01,  z = 81.20},
			{x = -116.014,  y = 6390.022,  z = 31.23},
			{x = -16.6969, y = 219.516,  z = 98.7536}

		}
	},

	saspgeje = {
		Blips = false,
		Blip = {
			Sprite = 93,
			Color = 27,
			Name = "",
		},
		Items = {
			{title = 'X-Gamer', item = 'kawa', price = 1000, limit = 100},
		},
		Pos = {
			{x = 448.8, y = -974.37, z = 34.97-0.95},
			{x = -542.68, y = -126.98, z = 47.51-0.99},
			{x = -1089.26, y = -834.4, z = 23.03-0.99},
			{x = 462.37, y = -981.7, z = 30.68-0.95}

		}
	},

	Alkoholowy = {
		Blips = true,
		Blip = {
			Sprite = 93,
			Color = 26,
			Name = "Sklep z alkoholami",
		},
		info = 'exilerp_alkoholowybieda',
		Items = {
			{title = 'Harnaś 0.5L', item = 'beer', price = 150, limit = 100},
			{title = 'Soplica 0.7L', item = 'vodka', price = 300, limit = 100},
			{title = 'Tequila 0.7L', item = 'tequila', price = 400, limit = 100},
			{title = 'Jack Daniels 0.7L', item = 'whisky', price = 600, limit = 100},
		},
		Pos = {
			{x = 456.0774,  y = 129.9193,  z = 98.5},
			{x = 463.9065,  y = -1851.266,  z = 26.8733},
			{x = -768.4551,  y = -2063.2896,  z = 8.0652},
			{x = -1360.1785, y = -963.9705,  z = 8.7494}

		}
	},

	AlkoholowyDeluxe = {
		Blips = true,
		Blip = {
			Sprite = 93,
			Color = 4,
			Name = "Sklep z alkoholami Premium",
		},
		info = 'exilerp_alkoholowykox',
		Items = {
			{title = 'Shot czystej wódki 30ml', item = 'shot', price = 300, limit = 10},
			{title = 'Drink Północno-Amerykański', item = 'drink', price = 350, limit = 10},
			{title = 'Szklanka Burbonu', item = 'burbon', price = 400, limit = 10},
			{title = 'Butelka Cydru', item = 'cydr', price = 450, limit = 10},
			{title = 'Koniak 200ml', item = 'koniak', price = 500, limit = 10},
		},
		Pos = {
			{x = -818.78646,  y = -575.2828,  z = 29.3263},
			{x = 287.0104,  y = 137.1539,  z = 103.3489},
			{x = -1471.0352,  y = -134.725,  z = 50.1398},
			{x = -1040.4861, y = -1475.2366,  z = 4.6266}

		}
	},

	Sportowy = {
		Blips = true,
		Blip = {
			Sprite = 112,
			Color = 0,
			Name = "Sklep X-Gamer",
		},
		info = 'shop247',
		Items = {
			{title = 'X-Gamer', item = 'kawa', price = 1200, limit = 100},
			{title = 'Piłka do nogi', item = 'pilka', price = 1000, limit = 1},
			{title = 'Boombox', item = 'hifi', price = 5000, limit = 1},
		},
		Pos = {
			{x = 2562.4204,  y = 2591.0056,  z = 37.1331},
			{x = -325.3929,  y = 6228.1602,  z =30.5508},
			{x = 1776.7349,  y = 3327.7078,  z = 40.4833},
			{x = -1123.052, y = 2682.2957,  z = 17.7706},
			{x = -2205.2744, y = -373.1517,  z = 12.3705},
			{x = -171.2003, y = -1449.3615,  z = 30.6765},
			{x = -697.8109, y = -1182.4044,  z = 9.7615},
			{x = 66.0744, y = -138.4398,  z = 54.0838},
			{x = -658.8039, y = -814.5027,  z = 23.5958},
			{x = 908.4388, y = -2220.8406,  z = 29.5452},
			{x = -632.8151, y = 235.0899, z = 80.9316},
			{x = -1111.5009, y = -1661.5798, z = 3.4067}
		}
	},

	Stragan = {
		Blips = true,
		Blip = {
			Sprite = 514,
			Color = 25,
			Name = "Stragan",
		},
		info = 'stragan',
		Items = {
			{title = 'Jabłko', item = 'jablko', price = 20, limit = 150},
			{title = 'Pomarańcza', item = 'pomarancza', price = 20, limit = 150},
			{title = 'Mandarynka', item = 'mandarynka', price = 15, limit = 150},
			{title = 'Winogrono', item = 'winogrono', price = 5, limit = 150},
			{title = 'Brzoskwinia', item = 'brzoskwinia', price = 25, limit = 150},
			{title = 'Cytryna', item = 'cytryna', price = 18, limit = 150},
		},
		Pos = {
			{x = 1476.4946,  y = 2724.4111,  z = 36.6284},
			{x = -1043.9531,  y = 5327.4683,  z =43.6239},
			{x = 2741.9812, y = 4412.1807, z = 47.6733},
			{x = 1088.0549, y = 6508.4473, z = 20.1067},
			{x = 1168.7771, y = -426.2951, z = 66.1457},
			{x = -1297.2968, y = -1387.4865, z = 3.5918}
		}
	},


	Techniczny = {
		Blips = true,
		Blip = {
			Sprite = 52,
			Color = 6,
			Name = "Hurtownia",		
		},
		info = 'hurtownia',
		Items = {
			{title = 'Kajdanki', item = 'handcuff', price = 10000, limit = 5},
			{title = 'Zestaw naprawczy', item = 'fixkit2', price = 3000, limit = 5},
			{title = 'Wytrych', item = 'blowpipe', price = 7500, limit = 5},
			{title = 'Wiertło', item = 'drill', price = 15000, limit = 20},
			{title = 'GoPro', item = 'gopro', price = 1000, limit = 5},
			{title = 'Lornetka', item = 'lornetka', price = 5000, limit = 5},
			{title = 'Worek', item = 'worek', price = 2000, limit = 5},
			{title = 'Krótkofalówka', item = 'krotkofalowka', price = 10000, limit = 5},
			{title = 'Skarpeta na głowe', item = 'skarpetka', price = 2000, limit = 5},
			{title = 'Worek', item = 'worek', price = 2000, limit = 5},
			{title = 'Wodoodporna Torba', item = 'odpornetorba', price = 2000, limit = 5},
		},
		Pos = {
			{x = 46.44,   y = -1749.56, z = 28.68},
			{x = 2747.74,   y = 3473.0, z = 54.70},
			{x = -57.3203,   y = 6523.5781, z = 30.54086523}
		}
	},

	Narkotyki = {
		Blips = false,
		Blip = {
			Sprite = 93,
			Color = 26,
			Name = "",
		},
		Items = {
			{title = 'Mieszacz', item = 'mieszacz', price = 65000, limit = 1},
			{title = 'Nożyczki', item = 'nozyczki', price = 3000, limit = 10},
		},
		Pos = {
			{x = 1008.075,  y = -1854.8383,  z = 30.0898},

		}
	},

	Magazynki = {
		Blips = false,
		Blip = {
			Sprite = 93,
			Color = 26,
			Name = "",
		},
		Items = {
			{title = 'Magazynek', item = 'clip', price = 1000, limit = 100},
		},
		Pos = {
			{x = 22.01, y = -1110.05, z = 29.79-0.95},
			{x = 249.37, y = -50.13, z = 69.94-0.95},
			{x = -327.83, y = 6082.7, z = 31.45-0.95},
			{x = -1115.06, y = 2697.18, z = 18.55-0.95},

		}
	},

	Wiertlo = {
		Blips = false,
		Blip = {
			Sprite = 93,
			Color = 26,
			Name = "",
		},
		Items = {
			{title = 'Wiertło II Generacji', item = 'drill2', price = 300000, limit = 1},
		},
		Pos = {
			{x = 1207.34, y = -3122.12, z = 5.54-0.99},

		}
	},

	--[[Grooveshop = {
		Blips = true,
		Blip = {
			Sprite = 52,
			Color = 7,
			Name = "Groove Shop",		
		},
		Items = {
			{title = 'Papieros', item = 'papieros', price = 2, limit = 30},
			{title = 'Bletka', item = 'bletka', price = 4, limit = 30},
			{title = 'OG Bletka', item = 'og_bletka', price = 4, limit = 30},
			{title = 'Zapalniczka', item = 'zapalniczka', price = 75, limit = 10},
			{title = 'Crusher', item = 'crusher', price = 30, limit = 10},
			{title = 'E-Papieros', item = 'vape', price = 5000, limit = 2},
			{title = 'Liquid', item = 'liquid', price = 15, limit = 15},
		},
		Pos = {
			{x = -10.4466,   y = -1828.3452, z = 24.437}
		}
	},]]

	Czarny = {
		Blips = false,
		Blip = {},
		Items = {
			{title = 'Tłumik', item = 'suppressor', price = 30000, limit = 5},
			{title = 'Latarka do broni', item = 'flashlight', price = 10000, limit = 5},
			{title = 'Celownik', item = 'scope', price = 100000, limit = 5},
		},
		Pos = {
			{x = -79.2,   y = -810.65, z = 284.05}
		}
	},
	
	Multimedialny = {
		Blips = true,
		Blip = {
			Sprite = 459,
			Color = 30,
			Name = "Operator komórkowy",			
		},
		info = 'phone',
		Items = {
			{title = 'Telefon', item = 'phone', price = 1500, limit = 10},
			{title = 'Karta SIM', item = 'sim', price = 1000, limit = 5},
			{title = 'Wodoodporne Etui', item = 'odporneetui', price = 1000, limit = 5},
			--{title = 'Tablet Exile-Book', item = 'tablet', price = 5000, limit = 5},
		},
		Pos = {
			{x = 149.7362, y = -232.22, z = 53.474},
			{x = -1081.88, y = -248.134, z = 36.8132}
		}
	},

	Kasyno = {
		Blips = false,
		Blip = {},
		Items = {
			{title = 'Zdrapka Silver', item = 'scratchcard', price = 2000, limit = 30},
			{title = 'Zdrapka Gold', item = 'scratchcardgold', price = 10000, limit = 30},
			{title = 'Zdrapka Diamond', item = 'scratchcarddiamond', price = 40000, limit = 30},
		},
		info = 'casino',
		Pos = {
			{x = 931.34,   y = 41.94, z = 80.13},
			{x = 922.6276, y = 46.4416, z = 71.1234}
		}
	},

	Wiezienie = {
		Blips = false,
		Blip = {},
		Items = {
			{title = 'Woda', item = 'water', price = 8, limit = 30},
			{title = 'Chleb', item = 'bread', price = 10, limit = 30},
		},
		Pos = {
			{x = 1653.75,   y = 2543.41, z = 44.60}
		}
	},

	Lombard = {
		Blips = true,
		Blip = {
			Sprite = 617,
			Color = 3,
			Name = "Lombard",
		},
		Items = {},
		Pos = {
			{x = -624.63,  y = -231.77,  z = 37.26}
		}
	},

 }