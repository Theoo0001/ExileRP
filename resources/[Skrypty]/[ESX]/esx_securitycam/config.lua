Config = {}
Config.Locale = 'pl'
Config.DrawDistance = 30.0

Config.Zones = {
	MISSIONROW = {
		Pos   = {x = 446.1725, y = -982.1795, z = 34.9811},
		Size  = {x = 1.7, y = 1.7, z = 0.5},
		Color = {r = 26, g = 55, b = 186},
		Type = 1
	},
	DOKI = {
		Pos   = {x = -56.9, y = -2505.83, z = 6.49},
		Size  = {x = 1.7, y = 1.7, z = 0.5},
		Color = {r = 26, g = 55, b = 186},
		Type = 1
	},
	VINEWOOD = {
		Pos   = {x = 623,19, y = -8.13, z = 81.82},
		Size  = {x = 1.7, y = 1.7, z = 0.5},
		Color = {r = 26, g = 55, b = 186},
		Type = 1
	},
	VESPUCCI = {
		Pos   = {x = -1093.8579, y = -837.4148, z = 29.807},
		Size  = {x = 1.7, y = 1.7, z = 0.5},
		Color = {r = 26, g = 55, b = 186},
		Type = 1
	},
	ROCKFORD = {
		Pos   = {x = -560.9699, y = -86.5904, z = 32.8092},
		Size  = {x = 1.7, y = 1.7, z = 0.5},
		Color = {r = 26, g = 55, b = 186},
		Type = 1
	},
	SANDYSHORES = {
		Pos   = {x = 1852.13, y = 3688.9, z = 34.21-0.99},
		Size  = {x = 1.7, y = 1.7, z = 0.5},
		Color = {r = 26, g = 55, b = 186},
		Type = 1
	},
	PALETOBAY = {
		Pos   = {x = -449.39, y = 6011.6, z = 30.82},
		Size  = {x = 1.7, y = 1.7, z = 0.5},
		Color = {r = 26, g = 55, b = 186},
		Type = 1
	},
}

Config.Locations = {
	{
		label = _U('pacific_standard_bank'),
		cameras = {
			{label = _U('bcam1'), x = 232.86, y = 221.46, z = 106.83, r = {x = -25.0, y = 0.0, z = -140.91}, canRotate = true},
			{label = _U('bcam2'), x = 257.45, y = 210.07, z = 108.08, r = {x = -25.0, y = 0.0, z = 28.05}, canRotate = true},
			{label = _U('bcam3'), x = 261.50, y = 218.08, z = 106.95, r = {x = -25.0, y = 0.0, z = -149.49}, canRotate = true},
			{label = _U('bcam4'), x = 241.64, y = 233.83, z = 110.48, r = {x = -35.0, y = 0.0, z = 120.46}, canRotate = true},
			{label = _U('bcam5'), x = 269.66, y = 223.67, z = 112.23, r = {x = -30.0, y = 0.0, z = 111.29}, canRotate = true},
			{label = _U('bcam6'), x = 261.98, y = 217.92, z = 112.25, r = {x = -40.0, y = 0.0, z = -159.49}, canRotate = true},
			{label = _U('bcam7'), x = 258.44, y = 204.97, z = 112.25, r = {x = -30.0, y = 0.0, z = 10.50}, canRotate = true},
			{label = _U('bcam8'), x = 235.53, y = 227.37, z = 112.23, r = {x = -35.0, y = 0.0, z = -160.29}, canRotate = true},
			{label = _U('bcam9'), x = 254.72, y = 206.06, z = 112.28, r = {x = -35.0, y = 0.0, z = 44.70}, canRotate = true},
			{label = _U('bcam10'), x = 269.89, y = 223.76, z = 105.48, r = {x = -35.0, y = 0.0, z = 112.62}, canRotate = true},
			{label = _U('bcam11'), x = 252.27, y = 225.52, z = 102.99, r = {x = -35.0, y = 0.0, z = -74.87}, canRotate = true}
		}
	},
	{
		label = _U('police_station'),
		cameras = {
			{label = _U('pcam1'), x = 416.744, y = -1009.270, z = 33.08, r = {x = -25.0, y = 0.0, z = 28.05}, canRotate = true},
			{label = _U('pcam2'), x = 465.151, y = -994.266, z = 26.1, r = {x = -30.0, y = 0.0, z = 100.29}, canRotate = true},
			{label = _U('pcam3'), x = 465.631, y = -997.777, z = 26.1, r = {x = -35.0, y = 0.0, z = 90.46}, canRotate = true},
			{label = _U('pcam4'), x = 465.544, y = -1001.583, z = 26.1, r = {x = -25.0, y = 0.0, z = 90.01}, canRotate = true},
			{label = _U('pcam5'), x = 420.241, y = -1009.010, z = 33.95, r = {x = -25.0, y = 0.0, z = 230.95}, canRotate = true},
			{label = _U('pcam6'), x = 433.249, y = -977.786, z = 32.456, r = {x = -40.0, y = 0.0, z = 100.49}, canRotate = true},
			{label = _U('pcam7'), x = 449.440, y = -987.639, z = 32.25, r = {x = -30.0, y = 0.0, z = 50.50}, canRotate = true}
		}
	},
	{
		label = 'Urzędnicza',
		cameras = {
			{label = 'Dziedziniec', x = 306.3044, y = -216.2804, z = 62.2712, r = {x = -25.0, y = 0.0, z = 285.15}, canRotate = true}
		}
	},
	{
		label = 'Pope John Paul II St.',
		cameras = {
			{label = 'Dziedziniec', x = 355.2752, y = -2075.1851, z = 24.1004, r = {x = -25.0, y = 0.0, z = 285.15}, canRotate = true}, --heading 22
			{label = 'Parking', x = 301.5952, y = -2021.81, z = 26.4904, r = {x = -25.0, y = 0.0, z = 285.15}, canRotate = true} --heading 258
		}
	},
	{
		label = 'Jubiler',
		cameras = {
			{label = 'Wejście', x = -644.720, y = -240.689, z = 43.668, r = {x = -25.0, y = 0.0, z = 268.54}, canRotate = true},
			{label = 'Główna', x = -632.705, y = -233.556, z = 40.014, r = {x = -25.0, y = 0.0, z = 268.54}, canRotate = true},
			{label = 'Wnęka', x = -625.387, y = -223.268, z = 39.636, r = {x = -25.0, y = 0.0, z = 188.65}, canRotate = true}
		}
	},
	{
		label = 'Humane Labs',
		cameras = {
			{label = 'Wjazd', x = 3618.727, y = 3719.559, z = 31.656, r = {x = -25.0, y = 0.0, z = 4.79}, canRotate = true},
			{label = 'Korytarz 1', x = 3600.899, y = 3699.125, z = 31.215, r = {x = -25.0, y = 0.0, z = 346.79}, canRotate = true},
			{label = 'Korytarz 2', x = 3582.826, y = 3683.294, z = 29.388, r = {x = -25.0, y = 0.0, z = 274.6}, canRotate = true},
			{label = 'Laboratorium', x = 3539.530, y = 3658.344, z = 30.018, r = {x = -25.0, y = 0.0, z = 35.42}, canRotate = true},
			{label = 'Zewnątrz', x = 3612.441, y = 3810.460, z = 34.176, r = {x = -25.0, y = 0.0, z = 183.31}, canRotate = true}
		}
	},
	{
		label = 'Więzienie',
		cameras = {
			{label = 'Wjazd', x = 1827.749, y = 2618.837, z = 64.353, r = {x = -25.0, y = 0.0, z = 239.01}, canRotate = true},
			{label = 'Brama więzienna', x = 1678.565, y = 2613.142, z = 48.351, r = {x = -25.0, y = 0.0, z = 231.97}, canRotate = true},
			{label = 'Dziedziniec', x = 1664.991, y = 2502.652, z = 60.740, r = {x = -25.0, y = 0.0, z = 3.06}, canRotate = true}
		}
	},
	{
		label = 'Bank Fleeca (Pillbox Hill)',
		cameras = {
			{label = 'Kamera 1', x = 145.1848, y = -1036.1704, z = 29.3885, r = {x = -25.0, y = 0.0, z = 28.05}, canRotate = true} 
		}
	},
	{
		label = 'Bank Fleeca (Great Ocean Hwy)',
		cameras = {
			{label = 'Kamera 1', x = -2965.5989, y = 476.7128, z = 15.6511, r = {x = -25.0, y = 0.0, z = 28.05}, canRotate = true} 
		}
	},
	{
		label = 'Bank Fleeca (Hawick Ave)', 
		cameras = {
			{label = 'Kamera 1', x = 309.3091, y = -274.4125, z = 53.8926, r = {x = -25.0, y = 0.0, z = 28.05}, canRotate = true} 
		}
	},
	{
		label = 'Bank BCS (Paleto)', 
		cameras = {
			{label =  'Hol', x = -118.5675, y = 6468.9409, z = 31.8211, r = {x = -25.0, y = 0.0, z = 28.05}, canRotate = true}, 
			{label = 'Drzwi', x = -102.296, y = 6469.5283, z = 32.4021, r = {x = -25.0, y = 0.0, z = 28.05}, canRotate = true}, 
			{label = 'Koryatrz', x = -99.4368, y = 6461.3594, z = 32.0101, r = {x = -25.0, y = 0.0, z = 28.05}, canRotate = false} 
		}
	},
	{
		label = 'Komenda Sandy Shores', 
		cameras = {
			{label = 'Zewnątrz 1', x = 1868.3867, y = 3687.19141, z = 34.3413, r = {x = -25.0, y = 0.0, z = 28.05}, canRotate = true}, 
			{label = 'Lobby', x = 1847.7113, y = 3689.6780, z = 34.6563, r = {x = -25.0, y = 0.0, z = 28.05}, canRotate = true},
			{label = 'Cele', x = 1854.85, y = 3695.88, z = 31.34, r = {x = -25.0, y = 0.0, z = 28.05}, canRotate = true} 
		}
	},
	{
		label = 'Car Dealer',
		cameras = {
			{label = 'Tył', x = -1.778, y = -1081.437, z = 35.100, r = {x = -25.0, y = 0.0, z = 108.39}, canRotate = true},
			{label = 'Środek', x = -56.335, y = -1087.545, z = 28.275, r = {x = -25.0, y = 0.0, z = 218.96}, canRotate = true},
			{label = 'Przód', x = -62.792, y = -1127.206, z = 37.158, r = {x = -25.0, y = 0.0, z = 319.19}, canRotate = true}
		}
	},
	{
		label = 'Jacht Vespucci Beach',
		cameras = {
			{label = 'Dół', x = -2029.5795, y = -1037.4678, z = 3.2664, r = {x = -25.0, y = 0.0, z = 281.79}, canRotate = true},
			{label = 'Skarbiec', x = -2081.342, y = -1012.058, z = 6.5839, r = {x = -25.0, y = 0.0, z = 105.81}, canRotate = true},
			{label = 'Flaga', x = -2018.1141, y = -1039.8704, z = 7.4418, r = {x = -25.0, y = 0.0, z = 65.98}, canRotate = true}
		}
	},
	{
		label = 'Elektrownia',
		cameras = {
			{label = 'Latarnia', x = 2667.6978, y = 1641.6978, z = 35.2002, r = {x = -25.0, y = 0.0, z = 107.53}, canRotate = true}
		}
	},
	{
		label = 'Diamond Casino',
		cameras = {
			{label = 'Wejście', x = 928.7231, y = 61.5789, z = 84.1058, r = {x = -25.0, y = 0.0, z = 143.16}, canRotate = true},
			{label = 'Parking', x = 904.611, y = 6.423, z = 84.1058, r = {x = -25.0, y = 0.0, z = 163.04}, canRotate = true},
			{label = 'Garaż', x = 940.0165, y = -1.602, z = 83.7158, r = {x = -25.0, y = 0.0, z = 105.91}, canRotate = true},
			{label = 'Taras 1', x = 962.5016, y = 71.8936, z = 118.0097, r = {x = -25.0, y = 0.0, z = 121.8019}, canRotate = true},
			{label = 'Taras 2', x = 963.007, y = 68.9678, z = 115.1493, r = {x = -25.0, y = 0.0, z = 160.64}, canRotate = true}
		}
	}
}