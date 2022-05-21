Config                            = {}

Config.Vehicles = {
	{
		spawn = 'victoriataxi',
		name = 'Ford Crown Victoria',
		grade = 0
	},
	{
		spawn = 'priustaxi',
		name = 'Toyota Prius',
		grade = 2
	},
	{
		spawn = 'kiataxi',
		name = 'Kia Stinger GT',
		grade = 4
	},
	{
		spawn = 'focustaxi',
		name = 'Ford Focus RS',
		grade = 6
	},
	{
		spawn = 'lexustaxi',
		name = 'Lexus GS350',
		grade = 8
	},
}

Config.Zones = {
	['taxi'] = {
		JobManager = {
			marker = {
				type = 1,
				offset = vector3(0.0, 0.0, -0.95),
				size = vector3(1.0, 1.0, 0.1),
				faceCamera = 0,
				colour = { r = 230, g = 219, b = 21 }
			},
			settings = {
				prompt = ("Naciśnij ~INPUT_CONTEXT~ aby %s"),
				control = 51,
				dutyOnly = false
			},
			coords = vector3(894.4, -171.72, 74.68)
		},
		Garage = {
			marker = {
				type = 36,
				offset = vector3(0.0, 0.0, -0.95),
				size = vector3(1.5, 1.5, 1.5),
				faceCamera = 1,
				colour = { r = 230, g = 219, b = 21 }
			},
			vehicles = {
				coords = vector3(902.51, -143.07, 76.2),
				heading = 329.29
			},
			settings = {
				prompt = ("Naciśnij ~INPUT_CONTEXT~ aby %s"),
				control = 51,
				dutyOnly = true
			},
			coords = vector3(894.91, -156.02, 76.94)
		},
		DeleteVeh = {
			marker = {
				type = 36,
				offset = vector3(0.0, 0.0, -0.95),
				size = vector3(1.5, 1.5, 1.5),
				faceCamera = 1,
				colour = { r = 230, g = 219, b = 21 }
			},
			settings = {
				prompt = ("Naciśnij ~INPUT_CONTEXT~ aby %s"),
				control = 51,
				dutyOnly = true
			},
			coords = vector3(897.11, -140.18, 76.97)
		},
		-- Invoices = {
		-- 	marker = {
		-- 		type = 1,
		-- 		offset = vector3(0.0, 0.0, -1.0),
		-- 		size = vector3(1.0, 1.0, 0.1),
		-- 		faceCamera = 0,
		-- 		colour = { r = 230, g = 219, b = 21 }
		-- 	},
		-- 	settings = {
		-- 		prompt = ("Naciśnij ~INPUT_CONTEXT~ aby %s"),
		-- 		control = 51,
		-- 		dutyOnly = true
		-- 	},
		-- 	coords = vector3(907.69, -157.03, 74.15)
		-- },
		BossMenu = {
			marker = {
				type = 1,
				offset = vector3(0.0, 0.0, -1.0),
				size = vector3(1.0, 1.0, 0.1),
				faceCamera = 0,
				colour = { r = 230, g = 219, b = 21 }
			},
			settings = {
				prompt = ("Naciśnij ~INPUT_CONTEXT~ aby %s"),
				control = 51,
				dutyOnly = true
			},
			coords = vector3(899.27, -159.16, 74.15)
		}
	}
}

Config.PedsList = {
	"a_m_m_mexlabor_01",
	"a_m_m_prolhost_01",
	"a_m_m_soucent_03",
	"a_f_m_soucentmc_01",
	"a_f_y_business_04",
	"a_f_y_tourist_01"
}

Config.CoordsList = { -- 0.5
	vector3(889.26, -225.43, 68.9),
	vector3(1061.45, -357.68, 66.66),
	vector3(1182.6, -426.83, 66.77),
	vector3(1255.25, -579.08, 68.51),
	vector3(408.83, -272.41, 51.55),
	vector3(-179.83973693848,-819.89068603516,30.343788146973),
	vector3(-197.392578125,-868.55432128906,28.599687576294),
	vector3(-259.10861206055,-848.69464111328,30.701831817627),
	vector3(-326.92916870117,-831.83874511719,30.914512634277),
	vector3(-482.15655517578,-822.93994140625,29.740924835205),
	vector3(-693.00012207031,-821.50317382813,23.254812240601),
	vector3(-694.32598876953,-963.91833496094,19.036628723145),
	vector3(-594.40985107422,-964.93743896484,21.651950836182),
	vector3(-522.70074462891,-1051.5551757813,21.95997428894),
	vector3(-420.744140625,-1131.0079345703,28.882778167725),
	vector3(-290.8740234375,-1124.7941894531,22.346458435059),
	vector3(-292.21215820313,-1242.4311523438,27.185119628906),
	vector3(-379.86837768555,-1661.2337646484,18.377115249634),
	vector3(-302.15081787109,-1847.4598388672,24.744396209717),
	vector3(-264.81176757813,-1810.5842285156,27.694147109985),
	vector3(-35.462135314941,-1725.6593017578,28.627304077148),
	vector3(144.55616760254,-1597.6221923828,28.626466751099),
	vector3(271.68496704102,-1560.6143798828,28.581256866455),
	vector3(416.08697509766,-1442.1324462891,28.634511947632),
	vector3(637.86041259766,-1450.7924804688,29.7916431427),
	vector3(912.75439453125,-1421.9478759766,30.467342376709),
	vector3(1317.6712646484,-1609.6600341797,51.883666992188),
	vector3(1105.552734375,-2092.9645996094,37.096134185791),
	vector3(1035.3493652344,-2319.8217773438,29.868932723999),
	vector3(955.01055908203,-2473.4965820313,27.855108261108),
	vector3(788.04364013672,-2184.2734375,28.791170120239),
	vector3(634.22351074219,-2036.0308837891,28.629064559937),
	vector3(511.58193969727,-2066.7392578125,25.783437728882),
	vector3(298.7571105957,-1904.7858886719,25.97479057312),
	vector3(187.61613464355,-1891.4417724609,23.468441009521),
	vector3(98.74828338623,-1874.27734375,23.423675537109),
	vector3(116.13101959229,-1947.685546875,20.00079536438),
	vector3(-102.55401611328,-1777.1024169922,28.814544677734),
	vector3(-191.20677185059,-1613.5989990234,33.254104614258),
	vector3(-88.632453918457,-1230.0241699219,28.044130325317),
	vector3(-55.7878074646,-1060.0056152344,27.036518096924),
	vector3(92.934471130371,-656.29437255859,43.548126220703),
	vector3(118.6000213623,-477.93533325195,42.414920806885),
	vector3(370.53616333008,-383.70849609375,45.681137084961),
	vector3(658.40808105469,-381.01684570313,41.442356109619),
	vector3(727.72784423828,-293.83590698242,57.257205963135),
	vector3(864.71990966797,-235.33631896973,69.392623901367),
	vector3(890.25372314453,-224.52001953125,68.750991821289),
	vector3(793.91229248047,-169.72082519531,72.851722717285),
	vector3(687.15551757813,-122.13222503662,74.080307006836),
	vector3(562.59259033203,-71.41926574707,69.528999328613),
	vector3(519.24975585938,-157.88636779785,55.897212982178),
	vector3(477.84579467773,-166.19403076172,55.649662017822),
	vector3(425.96459960938,-121.86573791504,64.122703552246),
	vector3(251.40354919434,-83.816223144531,69.296905517578),
	vector3(142.51666259766,-21.404727935791,66.901084899902),
	vector3(-102.95763397217,-83.3583984375,56.639205932617),
	vector3(-189.05087280273,-88.157196044922,51.462623596191),
	vector3(-307.19384765625,-167.24827575684,39.353000640869),
	vector3(-392.39874267578,-232.01684570313,35.489025115967),
	vector3(-608.69482421875,-193.19688415527,36.890598297119),
	vector3(-672.64624023438,-218.33837890625,36.415077209473),
	vector3(-645.55895996094,-238.5941619873,37.226448059082),
	vector3(-536.67321777344,-153.36441040039,37.968456268311),
	vector3(-427.95181274414,-65.244300842285,42.182689666748),
	vector3(-382.68188476563,-20.376146316528,46.134124755859),
	vector3(-258.60366821289,-284.87811279297,30.156356811523),
	vector3(-221.27774047852,-457.05551147461,32.718887329102),
	vector3(-411.55911254883,-671.66613769531,29.486852645874),
	vector3(-757.92901611328,-643.962890625,29.48454284668),
	vector3(-969.25988769531,-692.65759277344,22.869150161743),
	vector3(-1041.9166259766,-809.64562988281,17.141124725342),
	vector3(-1100.1003417969,-928.23205566406,2.1443247795105),
	vector3(-887.03070068359,-1204.9379882813,4.2928581237793),
	vector3(-810.90380859375,-1122.8822021484,9.0873880386353),
	vector3(-658.04962158203,-1342.2415771484,9.9385366439819),
	vector3(-642.39196777344,-1668.5690917969,24.626993179321),
	vector3(-422.06954956055,-1777.6030273438,20.228666305542),
	vector3(-187.04786682129,-1997.7642822266,27.106863021851),
	vector3(-66.869606018066,-2137.4438476563,9.6536855697632),
	vector3(-692.98095703125,-1554.3403320313,15.47774887085),
	vector3(-553.77825927734,-1122.4404296875,20.534593582153),
	vector3(-619.74877929688,-943.81311035156,21.100994110107),
	vector3(-625.28118896484,-719.38848876953,28.253328323364),
	vector3(-649.87072753906,-525.44714355469,34.086166381836),
	vector3(-180.52496337891,269.69415283203,92.03401184082),
	vector3(54.422691345215,333.38226318359,111.7095413208),
	vector3(258.96899414063,1139.8072509766,221.40412902832),
	vector3(-583.95434570313,503.54840087891,105.14263153076),
	vector3(-1462.2062988281,275.00900268555,60.670886993408),
	vector3(-1668.6094970703,112.93830108643,62.922870635986),
	vector3(-2296.0458984375,468.66632080078,173.79951477051),
	vector3(-1640.0797119141,-96.070388793945,58.442085266113),
	vector3(-1416.7200927734,-372.2819519043,37.337867736816),
	vector3(-1018.3951416016,-817.47387695313,15.55628490448),
	vector3(-224.38496398926,-894.87176513672,29.073961257935),	
	vector3(1871.9925537109,3681.1315917969,32.892063140869),
	vector3(1939.3438720703,3704.8725585938,31.674068450928),
	vector3(1970.4719238281,3736.3381347656,31.654155731201),
	vector3(2027.1939697266,3753.8796386719,31.527265548706),
	vector3(2006.6975097656,3803.8959960938,31.510179519653),
	vector3(1922.9455566406,3771.3537597656,31.656896591187),
	vector3(1675.0174560547,3616.6901855469,34.832206726074),
	vector3(1546.5814208984,3649.2475585938,33.76416015625),
	vector3(1393.4490966797,3594.4260253906,34.243644714355),
	vector3(1302.0926513672,3640.048828125,32.376430511475),
	vector3(978.24847412109,3623.9184570313,31.607549667358),
	vector3(920.52471923828,3589.8371582031,32.537521362305),
	vector3(425.37112426758,3578.716796875,32.585399627686),
	vector3(88.849594116211,3589.158203125,39.072147369385),
	vector3(87.63011932373,3678.1953125,38.855369567871),
	vector3(56.842235565186,3739.0151367188,39.002620697021),
	vector3(834.03167724609,4237.24609375,51.979953765869),
	vector3(1441.7836914063,4490.4125976563,49.963520050049),
	vector3(1944.8914794922,4603.5053710938,38.834804534912),
	vector3(2181.9826660156,4908.3837890625,40.22265625),
	vector3(2413.4118652344,4987.255859375,45.552577972412),
	vector3(1684.8846435547,6407.5034179688,30.729131698608),
	vector3(1561.5541992188,6442.0307617188,23.586217880249),
	vector3(169.56959533691,6556.0454101563,31.230051040649),
	vector3(51.063735961914,6594.4047851563,30.644552230835),
	vector3(31.632383346558,6558.4848632813,30.65784072876),
	vector3(-29.374774932861,6512.7524414063,30.631359100342),
	vector3(-94.28630065918,6426.7309570313,30.678609848022),
	vector3(-189.4988861084,6359.095703125,30.797060012817),
	vector3(-358.8942565918,6161.703125,30.596113204956),
	vector3(-427.7350769043,6032.8715820313,30.834377288818),
	vector3(-272.45452880859,6084.7709960938,30.722162246704),
	vector3(-212.82972717285,6180.8725585938,30.51439666748),
	vector3(-24.480247497559,6331.703125,30.721502304077),
	vector3(163.2084197998,6515.1235351563,30.959915161133),	
}

Config.Uniforms = {
	taxi = {
		male = {
			['0'] = {
				['tshirt_1'] = 15, ['tshirt_2'] = 0,--TSHIRT
				['torso_1'] = 420, ['torso_2'] = 2, --TUŁÓW
				['arms'] = 30, --RAMIONA
				['pants_1'] = 28, ['pants_2'] = 0, --SPODNIE
				['shoes_1'] = 10, ['shoes_2'] = 0, --BUTY
				['helmet_1'] = -1, ['helmet_2'] = 0, --CZAPKA_TUTAJ_-1_OZNACZA_BRAK_CZAPKI
				['chain_1'] = 0, ['chain_2'] = 0, --ŁAŃCUCH
				['mask_1'] = 0, ['mask_2'] = 0, --MASKA
				['bags_1'] = 0, ['bags_2'] = 0 --TORBA
			},
			['1'] = {
				['tshirt_1'] = 15, ['tshirt_2'] = 0,--TSHIRT
				['torso_1'] = 420, ['torso_2'] = 2, --TUŁÓW
				['arms'] = 30, --RAMIONA
				['pants_1'] = 28, ['pants_2'] = 0, --SPODNIE
				['shoes_1'] = 10, ['shoes_2'] = 0, --BUTY
				['helmet_1'] = -1, ['helmet_2'] = 0, --CZAPKA_TUTAJ_-1_OZNACZA_BRAK_CZAPKI
				['chain_1'] = 0, ['chain_2'] = 0, --ŁAŃCUCH
				['mask_1'] = 0, ['mask_2'] = 0, --MASKA
				['bags_1'] = 0, ['bags_2'] = 0 --TORBA
			},
			['2'] = {
				['tshirt_1'] = 15, ['tshirt_2'] = 0,--TSHIRT
				['torso_1'] = 420, ['torso_2'] = 2, --TUŁÓW
				['arms'] = 30, --RAMIONA
				['pants_1'] = 28, ['pants_2'] = 0, --SPODNIE
				['shoes_1'] = 10, ['shoes_2'] = 0, --BUTY
				['helmet_1'] = -1, ['helmet_2'] = 0, --CZAPKA_TUTAJ_-1_OZNACZA_BRAK_CZAPKI
				['chain_1'] = 0, ['chain_2'] = 0, --ŁAŃCUCH
				['mask_1'] = 0, ['mask_2'] = 0, --MASKA
				['bags_1'] = 0, ['bags_2'] = 0 --TORBA
			},
			['3'] = {
				['tshirt_1'] = 15, ['tshirt_2'] = 0,--TSHIRT
				['torso_1'] = 420, ['torso_2'] = 2, --TUŁÓW
				['arms'] = 30, --RAMIONA
				['pants_1'] = 28, ['pants_2'] = 0, --SPODNIE
				['shoes_1'] = 10, ['shoes_2'] = 0, --BUTY
				['helmet_1'] = -1, ['helmet_2'] = 0, --CZAPKA_TUTAJ_-1_OZNACZA_BRAK_CZAPKI
				['chain_1'] = 0, ['chain_2'] = 0, --ŁAŃCUCH
				['mask_1'] = 0, ['mask_2'] = 0, --MASKA
				['bags_1'] = 0, ['bags_2'] = 0 --TORBA
			},
			['4'] = {
				['tshirt_1'] = 15, ['tshirt_2'] = 0,--TSHIRT
				['torso_1'] = 420, ['torso_2'] = 2, --TUŁÓW
				['arms'] = 30, --RAMIONA
				['pants_1'] = 28, ['pants_2'] = 0, --SPODNIE
				['shoes_1'] = 10, ['shoes_2'] = 0, --BUTY
				['helmet_1'] = -1, ['helmet_2'] = 0, --CZAPKA_TUTAJ_-1_OZNACZA_BRAK_CZAPKI
				['chain_1'] = 0, ['chain_2'] = 0, --ŁAŃCUCH
				['mask_1'] = 0, ['mask_2'] = 0, --MASKA
				['bags_1'] = 0, ['bags_2'] = 0 --TORBA
			},
			['5'] = {
				['tshirt_1'] = 15, ['tshirt_2'] = 0,--TSHIRT
				['torso_1'] = 420, ['torso_2'] = 2, --TUŁÓW
				['arms'] = 30, --RAMIONA
				['pants_1'] = 28, ['pants_2'] = 0, --SPODNIE
				['shoes_1'] = 10, ['shoes_2'] = 0, --BUTY
				['helmet_1'] = -1, ['helmet_2'] = 0, --CZAPKA_TUTAJ_-1_OZNACZA_BRAK_CZAPKI
				['chain_1'] = 0, ['chain_2'] = 0, --ŁAŃCUCH
				['mask_1'] = 0, ['mask_2'] = 0, --MASKA
				['bags_1'] = 0, ['bags_2'] = 0 --TORBA
			},
			['6'] = {
				['tshirt_1'] = 15, ['tshirt_2'] = 0,--TSHIRT
				['torso_1'] = 420, ['torso_2'] = 2, --TUŁÓW
				['arms'] = 30, --RAMIONA
				['pants_1'] = 28, ['pants_2'] = 0, --SPODNIE
				['shoes_1'] = 10, ['shoes_2'] = 0, --BUTY
				['helmet_1'] = -1, ['helmet_2'] = 0, --CZAPKA_TUTAJ_-1_OZNACZA_BRAK_CZAPKI
				['chain_1'] = 0, ['chain_2'] = 0, --ŁAŃCUCH
				['mask_1'] = 0, ['mask_2'] = 0, --MASKA
				['bags_1'] = 0, ['bags_2'] = 0 --TORBA
			},
			['7'] = {
				['tshirt_1'] = 15, ['tshirt_2'] = 0,--TSHIRT
				['torso_1'] = 420, ['torso_2'] = 2, --TUŁÓW
				['arms'] = 30, --RAMIONA
				['pants_1'] = 28, ['pants_2'] = 0, --SPODNIE
				['shoes_1'] = 10, ['shoes_2'] = 0, --BUTY
				['helmet_1'] = -1, ['helmet_2'] = 0, --CZAPKA_TUTAJ_-1_OZNACZA_BRAK_CZAPKI
				['chain_1'] = 0, ['chain_2'] = 0, --ŁAŃCUCH
				['mask_1'] = 0, ['mask_2'] = 0, --MASKA
				['bags_1'] = 0, ['bags_2'] = 0 --TORBA
			},
			['8'] = {
				['tshirt_1'] = 15, ['tshirt_2'] = 0,--TSHIRT
				['torso_1'] = 420, ['torso_2'] = 2, --TUŁÓW
				['arms'] = 30, --RAMIONA
				['pants_1'] = 28, ['pants_2'] = 0, --SPODNIE
				['shoes_1'] = 10, ['shoes_2'] = 0, --BUTY
				['helmet_1'] = -1, ['helmet_2'] = 0, --CZAPKA_TUTAJ_-1_OZNACZA_BRAK_CZAPKI
				['chain_1'] = 0, ['chain_2'] = 0, --ŁAŃCUCH
				['mask_1'] = 0, ['mask_2'] = 0, --MASKA
				['bags_1'] = 0, ['bags_2'] = 0 --TORBA
			},
			['9'] = {
				['tshirt_1'] = 15, ['tshirt_2'] = 0,--TSHIRT
				['torso_1'] = 420, ['torso_2'] = 2, --TUŁÓW
				['arms'] = 30, --RAMIONA
				['pants_1'] = 28, ['pants_2'] = 0, --SPODNIE
				['shoes_1'] = 10, ['shoes_2'] = 0, --BUTY
				['helmet_1'] = -1, ['helmet_2'] = 0, --CZAPKA_TUTAJ_-1_OZNACZA_BRAK_CZAPKI
				['chain_1'] = 0, ['chain_2'] = 0, --ŁAŃCUCH
				['mask_1'] = 0, ['mask_2'] = 0, --MASKA
				['bags_1'] = 0, ['bags_2'] = 0 --TORBA
			},
		},
		female = {
			['0'] = {
				['tshirt_1'] = 6, ['tshirt_2'] = 0,--TSHIRT
				['torso_1'] = 440, ['torso_2'] = 2, --TUŁÓW
				['arms'] = 14, --RAMIONA
				['pants_1'] = 168, ['pants_2'] = 1, --SPODNIE
				['shoes_1'] = 27, ['shoes_2'] = 0, --BUTY
				['helmet_1'] = -1, ['helmet_2'] = 0, --CZAPKA_TUTAJ_-1_OZNACZA_BRAK_CZAPKI
				['chain_1'] = 0, ['chain_2'] = 0, --ŁAŃCUCH
				['mask_1'] = 0, ['mask_2'] = 0, --MASKA
				['bags_1'] = 0, ['bags_2'] = 0 --TORBA
			},
			['1'] = {
				['tshirt_1'] = 6, ['tshirt_2'] = 0,--TSHIRT
				['torso_1'] = 440, ['torso_2'] = 2, --TUŁÓW
				['arms'] = 14, --RAMIONA
				['pants_1'] = 168, ['pants_2'] = 1, --SPODNIE
				['shoes_1'] = 27, ['shoes_2'] = 0, --BUTY
				['helmet_1'] = -1, ['helmet_2'] = 0, --CZAPKA_TUTAJ_-1_OZNACZA_BRAK_CZAPKI
				['chain_1'] = 0, ['chain_2'] = 0, --ŁAŃCUCH
				['mask_1'] = 0, ['mask_2'] = 0, --MASKA
				['bags_1'] = 0, ['bags_2'] = 0 --TORBA
			},
			['2'] = {
				['tshirt_1'] = 6, ['tshirt_2'] = 0,--TSHIRT
				['torso_1'] = 440, ['torso_2'] = 2, --TUŁÓW
				['arms'] = 14, --RAMIONA
				['pants_1'] = 168, ['pants_2'] = 1, --SPODNIE
				['shoes_1'] = 27, ['shoes_2'] = 0, --BUTY
				['helmet_1'] = -1, ['helmet_2'] = 0, --CZAPKA_TUTAJ_-1_OZNACZA_BRAK_CZAPKI
				['chain_1'] = 0, ['chain_2'] = 0, --ŁAŃCUCH
				['mask_1'] = 0, ['mask_2'] = 0, --MASKA
				['bags_1'] = 0, ['bags_2'] = 0 --TORBA
			},
			['3'] = {
				['tshirt_1'] = 6, ['tshirt_2'] = 0,--TSHIRT
				['torso_1'] = 440, ['torso_2'] = 2, --TUŁÓW
				['arms'] = 14, --RAMIONA
				['pants_1'] = 168, ['pants_2'] = 1, --SPODNIE
				['shoes_1'] = 27, ['shoes_2'] = 0, --BUTY
				['helmet_1'] = -1, ['helmet_2'] = 0, --CZAPKA_TUTAJ_-1_OZNACZA_BRAK_CZAPKI
				['chain_1'] = 0, ['chain_2'] = 0, --ŁAŃCUCH
				['mask_1'] = 0, ['mask_2'] = 0, --MASKA
				['bags_1'] = 0, ['bags_2'] = 0 --TORBA
			},
			['4'] = {
				['tshirt_1'] = 6, ['tshirt_2'] = 0,--TSHIRT
				['torso_1'] = 440, ['torso_2'] = 2, --TUŁÓW
				['arms'] = 14, --RAMIONA
				['pants_1'] = 168, ['pants_2'] = 1, --SPODNIE
				['shoes_1'] = 27, ['shoes_2'] = 0, --BUTY
				['helmet_1'] = -1, ['helmet_2'] = 0, --CZAPKA_TUTAJ_-1_OZNACZA_BRAK_CZAPKI
				['chain_1'] = 0, ['chain_2'] = 0, --ŁAŃCUCH
				['mask_1'] = 0, ['mask_2'] = 0, --MASKA
				['bags_1'] = 0, ['bags_2'] = 0 --TORBA
			},
			['5'] = {
				['tshirt_1'] = 6, ['tshirt_2'] = 0,--TSHIRT
				['torso_1'] = 440, ['torso_2'] = 2, --TUŁÓW
				['arms'] = 14, --RAMIONA
				['pants_1'] = 168, ['pants_2'] = 1, --SPODNIE
				['shoes_1'] = 27, ['shoes_2'] = 0, --BUTY
				['helmet_1'] = -1, ['helmet_2'] = 0, --CZAPKA_TUTAJ_-1_OZNACZA_BRAK_CZAPKI
				['chain_1'] = 0, ['chain_2'] = 0, --ŁAŃCUCH
				['mask_1'] = 0, ['mask_2'] = 0, --MASKA
				['bags_1'] = 0, ['bags_2'] = 0 --TORBA
			},
			['6'] = {
				['tshirt_1'] = 6, ['tshirt_2'] = 0,--TSHIRT
				['torso_1'] = 440, ['torso_2'] = 2, --TUŁÓW
				['arms'] = 14, --RAMIONA
				['pants_1'] = 168, ['pants_2'] = 1, --SPODNIE
				['shoes_1'] = 27, ['shoes_2'] = 0, --BUTY
				['helmet_1'] = -1, ['helmet_2'] = 0, --CZAPKA_TUTAJ_-1_OZNACZA_BRAK_CZAPKI
				['chain_1'] = 0, ['chain_2'] = 0, --ŁAŃCUCH
				['mask_1'] = 0, ['mask_2'] = 0, --MASKA
				['bags_1'] = 0, ['bags_2'] = 0 --TORBA
			},
			['7'] = {
				['tshirt_1'] = 6, ['tshirt_2'] = 0,--TSHIRT
				['torso_1'] = 440, ['torso_2'] = 2, --TUŁÓW
				['arms'] = 14, --RAMIONA
				['pants_1'] = 168, ['pants_2'] = 1, --SPODNIE
				['shoes_1'] = 27, ['shoes_2'] = 0, --BUTY
				['helmet_1'] = -1, ['helmet_2'] = 0, --CZAPKA_TUTAJ_-1_OZNACZA_BRAK_CZAPKI
				['chain_1'] = 0, ['chain_2'] = 0, --ŁAŃCUCH
				['mask_1'] = 0, ['mask_2'] = 0, --MASKA
				['bags_1'] = 0, ['bags_2'] = 0 --TORBA
			},
			['8'] = {
				['tshirt_1'] = 6, ['tshirt_2'] = 0,--TSHIRT
				['torso_1'] = 440, ['torso_2'] = 2, --TUŁÓW
				['arms'] = 14, --RAMIONA
				['pants_1'] = 168, ['pants_2'] = 1, --SPODNIE
				['shoes_1'] = 27, ['shoes_2'] = 0, --BUTY
				['helmet_1'] = -1, ['helmet_2'] = 0, --CZAPKA_TUTAJ_-1_OZNACZA_BRAK_CZAPKI
				['chain_1'] = 0, ['chain_2'] = 0, --ŁAŃCUCH
				['mask_1'] = 0, ['mask_2'] = 0, --MASKA
				['bags_1'] = 0, ['bags_2'] = 0 --TORBA
			},
			['9'] = {
				['tshirt_1'] = 6, ['tshirt_2'] = 0,--TSHIRT
				['torso_1'] = 440, ['torso_2'] = 2, --TUŁÓW
				['arms'] = 14, --RAMIONA
				['pants_1'] = 168, ['pants_2'] = 1, --SPODNIE
				['shoes_1'] = 27, ['shoes_2'] = 0, --BUTY
				['helmet_1'] = -1, ['helmet_2'] = 0, --CZAPKA_TUTAJ_-1_OZNACZA_BRAK_CZAPKI
				['chain_1'] = 0, ['chain_2'] = 0, --ŁAŃCUCH
				['mask_1'] = 0, ['mask_2'] = 0, --MASKA
				['bags_1'] = 0, ['bags_2'] = 0 --TORBA
			},
			
		}
	}
}