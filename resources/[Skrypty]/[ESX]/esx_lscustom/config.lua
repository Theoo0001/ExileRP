
local colors = {
	{name = "Black", colorindex = 0},
	{name = "Carbon Black", colorindex = 147},
	{name = "Hraphite", colorindex = 1},
	{name = "Anhracite Black", colorindex = 11},
	{name = "Black Steel", colorindex = 2},
	{name = "Dark Steel", colorindex = 3},
	{name = "Silver", colorindex = 4},
	{name = "Bluish Silver", colorindex = 5},
	{name = "Rolled Steel", colorindex = 6},
	{name = "Shadow Silver", colorindex = 7},
	{name = "Stone Silver", colorindex = 8},
	{name = "Midnight Silver", colorindex = 9},
	{name = "Cast Iron Silver", colorindex = 10},
	{name = "Red", colorindex = 27},
	{name = "Torino Red", colorindex = 28},
	{name = "Formula Red", colorindex = 29},
	{name = "Lava Red", colorindex = 150},
	{name = "Blaze Red", colorindex = 30},
	{name = "Grace Red", colorindex = 31},
	{name = "Garnet Red", colorindex = 32},
	{name = "Sunset Red", colorindex = 33},
	{name = "Cabernet Red", colorindex = 34},
	{name = "Wine Red", colorindex = 143},
	{name = "Candy Red", colorindex = 35},
	{name = "Hot Pink", colorindex = 135},
	{name = "Pfsiter Pink", colorindex = 137},
	{name = "Salmon Pink", colorindex = 136},
	{name = "Sunrise Orange", colorindex = 36},
	{name = "Orange", colorindex = 38},
	{name = "Bright Orange", colorindex = 138},
	{name = "Gold", colorindex = 99},
	{name = "Bronze", colorindex = 90},
	{name = "Yellow", colorindex = 88},
	{name = "Race Yellow", colorindex = 89},
	{name = "Dew Yellow", colorindex = 91},
	{name = "Dark Green", colorindex = 49},
	{name = "Racing Green", colorindex = 50},
	{name = "Sea Green", colorindex = 51},
	{name = "Olive Green", colorindex = 52},
	{name = "Bright Green", colorindex = 53},
	{name = "Gasoline Green", colorindex = 54},
	{name = "Lime Green", colorindex = 92},
	{name = "Midnight Blue", colorindex = 141},
	{name = "Galaxy Blue", colorindex = 61},
	{name = "Dark Blue", colorindex = 62},
	{name = "Saxon Blue", colorindex = 63},
	{name = "Blue", colorindex = 64},
	{name = "Mariner Blue", colorindex = 65},
	{name = "Harbor Blue", colorindex = 66},
	{name = "Diamond Blue", colorindex = 67},
	{name = "Surf Blue", colorindex = 68},
	{name = "Nautical Blue", colorindex = 69},
	{name = "Racing Blue", colorindex = 73},
	{name = "Ultra Blue", colorindex = 70},
	{name = "Light Blue", colorindex = 74},
	{name = "Chocolate Brown", colorindex = 96},
	{name = "Bison Brown", colorindex = 101},
	{name = "Creeen Brown", colorindex = 95},
	{name = "Feltzer Brown", colorindex = 94},
	{name = "Maple Brown", colorindex = 97},
	{name = "Beechwood Brown", colorindex = 103},
	{name = "Sienna Brown", colorindex = 104},
	{name = "Saddle Brown", colorindex = 98},
	{name = "Moss Brown", colorindex = 100},
	{name = "Woodbeech Brown", colorindex = 102},
	{name = "Straw Brown", colorindex = 99},
	{name = "Sandy Brown", colorindex = 105},
	{name = "Bleached Brown", colorindex = 106},
	{name = "Schafter Purple", colorindex = 71},
	{name = "Spinnaker Purple", colorindex = 72},
	{name = "Midnight Purple", colorindex = 142},
	{name = "Bright Purple", colorindex = 145},
	{name = "Cream", colorindex = 107},
	{name = "Ice White", colorindex = 111},
	{name = "Frost White", colorindex = 112}
}

local metalcolors = {
	{name = "Brushed Steel", colorindex = 117},
	{name = "Brushed Black Steel", colorindex = 118},
	{name = "Brushed Aluminum", colorindex = 119},
	{name = "Pure Gold", colorindex = 158},
	{name = "Brushed Gold", colorindex = 159}
}
local mattecolors = {
	{name = "Black", colorindex = 12},
	{name = "Gray", colorindex = 13},
	{name = "Light Gray", colorindex = 14},
	{name = "Ice White", colorindex = 131},
	{name = "Blue", colorindex = 83},
	{name = "Dark Blue", colorindex = 82},
	{name = "Midnight Blue", colorindex = 84},
	{name = "Midnight Purple", colorindex = 149},
	{name = "Schafter Purple", colorindex = 148},
	{name = "Red", colorindex = 39},
	{name = "Dark Red", colorindex = 40},
	{name = "Orange", colorindex = 41},
	{name = "Yellow", colorindex = 42},
	{name = "Lime Green", colorindex = 55},
	{name = "Green", colorindex = 128},
	{name = "Frost Green", colorindex = 151},
	{name = "Foliage Green", colorindex = 155},
	{name = "Olive Darb", colorindex = 152},
	{name = "Dark Earth", colorindex = 153},
	{name = "Desert Tan", colorindex = 154}
}

Config = {
	lock = false,
	mecanostolock = 2,
	repair = {
		required = true,
		bodyperhundredprice = 1000,
		engineperhundredprice = 1000,
		minhealthbody = 1050,
		minhealthengine = 1050,
		mecanostomultiply = 1
	},
	wheeltype = {
		frontwheel = { id = 6, price = 1000, mod = 23 },
		backwheel = { id = 6, price = 1000, mod = 24 },
		sportwheels = { id = 0, price = 2500, mod = 23 },
		suvwheels = { id = 3, price = 2500, mod = 23 },
		offroadwheels = { id = 4, price = 2500, mod = 23 },
		tunerwheels = { id = 5, price = 2500, mod = 23 },
		highendwheels = { id = 7, price = 2500, mod = 23 },
		lowriderwheels = { id = 2, price = 2500, mod = 23 },
		musclewheels = { id = 1, price = 2500, mod = 23 }
	},
	prices = {
		wash = 500,
		windowtint = {
			{ name = "Pure Black", tint = 1, price = 40000},
			{ name = "Darksmoke", tint = 2, price = 40000},
			{ name = "Lightsmoke", tint = 3, price = 40000},
			{ name = "Limo", tint = 4, price = 40000},
			{ name = "Green", tint = 5, price = 40000}
		},

		-- Coloring
		liveryvariant = 3500,
		-- Primary colors
		chrome = {
			colors = {
				{name = "Chrome", colorindex = 120}
			},
			price = 60000
		},
		classic = {
			colors = colors,
			price = 40000
		},
		matte = {
			colors = mattecolors,
			price = 80000
		},
		metallic = {
			colors = colors,
			price = 80000
		},
		metal = {
			colors = metalcolors,
			price = 60000
		},

		-- Secondary colors
		chrome2 = {
			colors = {
				{name = "Chrome", colorindex = 120}
			},
			price = 120000
		},
		classic2 = {
			colors = colors,
			price = 40000
		},
		matte2 = {
			colors = mattecolors,
			price = 80000
		},
		metallic2 = {
			colors = colors,
			price = 80000
		},
		metal2 = {
			colors = metalcolors,
			price = 60000
		},

		-- Neons
		neonlayout = {
			{name = "Z lewej", mod = 0, price = 10000},
			{name = "Z prawej", mod = 1, price = 10000},
			{name = "Z przodu", mod = 2, price = 10000},
			{name = "Z tyłu", mod = 3, price = 10000}
		},
		neoncolor = {
			{ name = "White", neon = {255,255,255}, price = 10000},
			{ name = "Blue", neon = {0,0,255}, price = 10000},
			{ name = "Light Blue", neon = {0,150,255}, price = 10000},
			{ name = "Sky Blue", neon = {135, 206, 235}, price = 10000},
			{ name = "Navy Blue", neon = {0,0,128}, price = 10000},
			{ name = "Turquoise", neon = {0,245,255}, price = 10000},
			{ name = "Mint Green", neon = {50,255,155}, price = 10000},
			{ name = "Lime Green", neon = {0,255,0}, price = 10000},
			{ name = "Olive", neon = {128, 128, 0}, price = 10000},
			{ name = "Wheat", neon = {245, 222, 179}, price = 10000},
			{ name = "Yellow", neon = {255,255,0}, price = 10000},
			{ name = "Golden Shower", neon = {204,204,0}, price = 10000},
			{ name = "Orange", neon = {255,128,0}, price = 10000},
			{ name = "Gold", neon = {255, 215, 0}, price = 10000},
			{ name = "Red", neon = {255,0,0}, price = 10000},
			{ name = "Pink", neon = {255, 161, 211}, price = 10000},
			{ name = "Pony Pink", neon = {255,102,255}, price = 10000},
			{ name = "Hot Pink",neon = {255,0,255}, price = 10000},
			{ name = "Purple", neon = {153,0,153}, price = 10000},
			{ name = "Brown", neon = {139,69,19}, price = 10000},
			{ name = "Slate Gray", neon = {112, 128, 144}, price = 10000},
			{ name = "Ivory", neon = {41, 36, 33}, price = 10000}
		},

		-- Plates
		plates = {
			{ name = "Blue on White #1", plateindex = 0, price = 2500},
			{ name = "Blue On White #2", plateindex = 3, price = 2500},
			{ name = "Blue On White #3", plateindex = 4, price = 2500},
			{ name = "Yellow on Blue", plateindex = 2, price = 3500},
			{ name = "Yellow on Black", plateindex = 1, price = 5000},
			{ name = "North Yankton", plateindex = 5, price = 2500}
		},

		-- Wheels
		wheelaccessories = {
			{ name = "Stock", price = 0},
			{ name = "Custom", price = 1000},
			{ name = "Kuloodporne", price = 500000},
			{ name = "Dym: Domyślny",smokecolor = true, price = 0},
			{ name = "Dym: White",smokecolor = {254,254,254}, price = 20000},
			{ name = "Dym: Blue", smokecolor = {0,0,255}, price = 20000},
			{ name = "Dym: Light Blue", smokecolor = {0,150,255}, price = 20000},
			{ name = "Dym: Sky Blue", smokecolor = {135, 206, 235}, price = 20000},
			{ name = "Dym: Navy Blue", smokecolor = {0,0,128}, price = 20000},
			{ name = "Dym: Turquoise", smokecolor = {0,245,255}, price = 20000},
			{ name = "Dym: Mint Green", smokecolor = {50,255,155}, price = 20000},
			{ name = "Dym: Lime Green", smokecolor = {0,255,0}, price = 20000},
			{ name = "Dym: Yellow", smokecolor = {255,255,50}, price = 20000},
			{ name = "Dym: Golden Shower", smokecolor = {204,204,0}, price = 20000},
			{ name = "Dym: Orange", smokecolor = {255,153,51}, price = 20000},
			{ name = "Dym: Gold", smokecolor = {255, 215, 0}, price = 20000},
			{ name = "Dym: Red", smokecolor = {255,10,10}, price = 20000},
			{ name = "Dym: Pink", smokecolor = {255, 161, 211}, price = 20000},
			{ name = "Dym: Pony Pink", smokecolor = {255,102,255}, price = 20000},
			{ name = "Dym: Hot Pink", smokecolor = {255,0,255}, price = 20000},
			{ name = "Dym: Purple", smokecolor = {153,10,153}, price = 20000},
			{ name = "Dym: Brown", smokecolor = {139,69,19}, price = 20000},
			{ name = "Dym: Gray",smokecolor = {128,128,128}, price = 20000},
			{ name = "Dym: Slate Gray", smokecolor = {112, 128, 144}, price = 20000},
			{ name = "Dym: Ivory", smokecolor = {41, 36, 33}, price = 20000},
			{ name = "Dym: Black", smokecolor = {1,1,1}, price = 20000}
		},
		wheelcolor = {
			colors = colors,
			price = 2500
		},
		frontwheel = {
			{name = "Stock", mod = -1, price = 0},
			{name = "Speedway", mod = 0},
			{name = "Street Special", mod = 1},
			{name = "Racer", mod = 2},
			{name = "Track Star", mod = 3},
			{name = "Overlord", mod = 4},
			{name = "Trident", mod = 5},
			{name = "Triple Threat", mod = 6},
			{name = "Stilleto", mod = 7},
			{name = "Wires", mod = 8},
			{name = "Bobber", mod = 9},
			{name = "Solidus", mod = 10},
			{name = "Ice Shield", mod = 11},
			{name = "Loops", mod = 12}
		},
		backwheel = {
			{name = "Stock", mod = -1, price = 0},
			{name = "Speedway", mod = 0},
			{name = "Street Special", mod = 1},
			{name = "Racer", mod = 2},
			{name = "Track Star", mod = 3},
			{name = "Overlord", mod = 4},
			{name = "Trident", mod = 5},
			{name = "Triple Threat", mod = 6},
			{name = "Stilleto", mod = 7},
			{name = "Wires", mod = 8},
			{name = "Bobber", mod = 9},
			{name = "Solidus", mod = 10},
			{name = "Ice Shield", mod = 11},
			{name = "Loops", mod = 12}
		},
		sportwheels = {
			{name = "Stock", mod = -1, price = 0},
			{name = "Inferno", mod = 0},
			{name = "Deep Five", mod = 1},
			{name = "Lozspeed", mod = 2},
			{name = "Diamond Cut", mod = 3},
			{name = "Chrono", mod = 4},
			{name = "Feroc", mod = 5},
			{name = "Fifty Nine", mod = 6},
			{name = "Mercie", mod = 7},
			{name = "Syntheticz", mod = 8},
			{name = "Organic Typed", mod = 9},
			{name = "Endo v1", mod = 10},
			{name = "Duper 7", mod = 11},
			{name = "Uzer", mod = 12},
			{name = "Ground Ride", mod = 13},
			{name = "Spacer", mod = 14},
			{name = "Venum", mod = 15},
			{name = "Cosmo", mod = 16},
			{name = "Dash Vip", mod = 17},
			{name = "Ice Kid", mod = 18},
			{name = "Ruffeld", mod = 19},
			{name = "Wangen Master", mod = 20},
			{name = "Super Five", mod = 21},
			{name = "Endo v2", mod = 22},
			{name = "Slit Six", mod = 23}
		},
		suvwheels = {
			{name = "Stock", mod = -1, price = 0},
			{name = "Vip", mod = 0},
			{name = "Bene Factor", mod = 1},
			{name = "Cosmo", mod = 2},
			{name = "Bippu", mod = 3},
			{name = "Royal Six", mod = 4},
			{name = "Fagorme", mod = 5},
			{name = "Deluxe", mod = 6},
			{name = "Iced Out", mod = 7},
			{name = "Cognscenti", mod = 8},
			{name = "Lozspeed Ten", mod = 9},
			{name = "Supernova", mod = 10},
			{name = "Obey RS", mod = 11},
			{name = "Lozspeed Baller", mod = 12},
			{name = "Extra Vaganzo", mod = 13},
			{name = "Split Six", mod = 14},
			{name = "Empowered", mod = 15},
			{name = "Sunrise", mod = 16},
			{name = "Dash Vip", mod = 17},
			{name = "Cutter", mod = 18}
		},
		offroadwheels = {
			{name = "Stock", mod = -1, price = 0},
			{name = "Raider", mod = 0},
			{name = "Mud Slinger", mod = 1},
			{name = "Nevis", mod = 2},
			{name = "Cairngorm", mod = 3},
			{name = "Amazon", mod = 4},
			{name = "Challenger", mod = 5},
			{name = "Dune Basher", mod = 6},
			{name = "Five Star", mod = 7},
			{name = "Rock Crawler", mod = 8},
			{name = "Milspec Steelie", mod = 9}
		},
		tunerwheels = {
			{name = "Stock", mod = -1, price = 0},
			{name = "Cosmo", mod = 0},
			{name = "Supermesh", mod = 1},
			{name = "Outsider", mod = 2},
			{name = "Rollas", mod = 3},
			{name = "Driff Meister", mod = 4},
			{name = "Slicer", mod = 5},
			{name = "El Quatro", mod = 6},
			{name = "Dubbed", mod = 7},
			{name = "Five Star", mod = 8},
			{name = "Slide Ways", mod = 9},
			{name = "Apex", mod = 10},
			{name = "Stance Deg", mod = 11},
			{name = "Counter Steer", mod = 12},
			{name = "Endov1", mod = 13},
			{name = "Endov2 Dish", mod = 14},
			{name = "Guppez", mod = 15},
			{name = "Chokadori", mod = 16},
			{name = "Chicane", mod = 17},
			{name = "Saisoku", mod = 18},
			{name = "Dished Eight", mod = 19},
			{name = "Fujiwara", mod = 20},
			{name = "Zokusha", mod = 21},
			{name = "Battle Vill", mod = 22},
			{name = "Rallymaster", mod = 23}
		},
		highendwheels = {
			{name = "Stock", mod = -1, price = 0},
			{name = "Shadow", mod = 0},
			{name = "Hyper", mod = 1},
			{name = "Blade", mod = 2},
			{name = "Diamond", mod = 3},
			{name = "Supagee", mod = 4},
			{name = "Chromaticz", mod = 5},
			{name = "Mercie Chlip", mod = 6},
			{name = "Obey RS", mod = 7},
			{name = "GT Chrome", mod = 8},
			{name = "Cheetah", mod = 9},
			{name = "Solar", mod = 10},
			{name = "Split Ten", mod = 11},
			{name = "Dash Vip", mod = 12},
			{name = "Lozspeed Ten", mod = 13},
			{name = "Carbon Inferno", mod = 14},
			{name = "Carbon Shadow", mod = 15},
			{name = "Carbonz", mod = 16},
			{name = "Carbon Solar", mod = 17},
			{name = "Carbon Cheetah", mod = 18},
			{name = "Carbon Racer", mod = 19}
		},
		lowriderwheels = {
			{name = "Stock", mod = -1, price = 0},
			{name = "Flare", mod = 0},
			{name = "Wired", mod = 1},
			{name = "Triple Golds", mod = 2},
			{name = "Big Worm", mod = 3},
			{name = "Seven Fives", mod = 4},
			{name = "Split Six", mod = 5},
			{name = "Fresh Mesh", mod = 6},
			{name = "Leads Led", mod = 7},
			{name = "Turbine", mod = 8},
			{name = "Super Fin", mod = 9},
			{name = "Classic Rod", mod = 10},
			{name = "Dollar", mod = 11},
			{name = "Dukes", mod = 12},
			{name = "Low Five", mod = 13},
			{name = "Gooch", mod = 14}
		},
		musclewheels = {
			{name = "Stock", mod = -1, price = 0},
			{name = "Classic Five", mod = 0},
			{name = "Dukes", mod = 1},
			{name = "Muscle Freak", mod = 2},
			{name = "Kracka", mod = 3},
			{name = "Azrea", mod = 4},
			{name = "Mecha", mod = 5},
			{name = "Blacktop", mod = 6},
			{name = "Drags", mod = 7},
			{name = "Revolver", mod = 8},
			{name = "Classic Rod", mod = 9},
			{name = "Spooner", mod = 10},
			{name = "Fivestar", mod = 11},
			{name = "Oldschool", mod = 12},
			{name = "Eljefe", mod = 13},
			{name = "Dodman", mod = 14},
			{name = "Sixgun", mod = 15},
			{name = "Mercenary", mod = 16}
		},

		-- Trim
		trim = {
			colors = colors,
			price = 2000
		},

		-- Extras
		extras = 5000,

		-- Mods
		mods = {
			-- Liveries
			[48] = { price = 10000 },
			
			-- Windows
			[46] = { price = 15000, percent = 1 },
			
			-- Tank
			[45] = { price = 15000, percent = 1 },
			
			-- Trim
			[44] = { price = 15000, percent = 1 },
			
			-- Aerials
			[43] = { price = 15000, percent = 1 },

			-- Arch cover
			[42] = { price = 15000, percent = 1 },

			-- Struts
			[41] = { price = 15000, percent = 1 },
			
			-- Air filter
			[40] = { price = 25000, percent = 1 },
			
			-- Engine block
			[39] = { price = 25000, percent = 1 },

			-- Hydraulics
			[38] = { price = 10000 },
			
			-- Trunk
			[37] = { price = 50000 },

			-- Speakers
			[36] = { price = 75000 },

			-- Plaques
			[35] = { price = 10000 },
			
			-- Shift lever
			[34] = { price = 10000, percent = 0.5 },
			
			-- Steering wheel
			[33] = { price = 10000, percent = 0.5 },
			
			-- Seats
			[32] = { price = 10000, percent = 1 },
			
			-- Door speakers
			[31] = { price = 25000, percent = 1 },

			-- Dials
			[30] = { price = 10000, percent = 0.5 },

			-- Dashboard
			[29] = { price = 10000, percent = 0.5 },
			
			-- Ornaments
			[28] = { price = 10000 },
			
			-- Trim
			[27] = { price = 25000, percent = 1 },
			
			-- Vanity plates
			[26] = { price = 25000 },
			
			-- Plate holder
			[25] = { price = 10000 },
			
			-- Headlights
			[22] = {
				{name = "Stock", mod = 0, price = 0},
				{name = "Xenon", mod = 1, price = 4000},
				{name = "Kolor: Niebieski", color = 1, price = 5000},
				{name = "Kolor: Niebieski v2", color = 2, price = 5000},
				{name = "Kolor: Miętowy", color = 3, price = 5000},
				{name = "Kolor: Limonkowy", color = 4, price = 5000},
				{name = "Kolor: Żółty", color = 5, price = 5000},
				{name = "Kolor: Złoty", color = 6, price = 5000},
				{name = "Kolor: Pomarańczowy", color = 7, price = 5000},
				{name = "Kolor: Czerwony", color = 8, price = 5000},
				{name = "Kolor: Różowy", color = 9, price = 5000},
				{name = "Kolor: Różowy v2", color = 10, price = 5000},
				{name = "Kolor: Fioletowy", color = 11, price = 5000},
				{name = "Kolor: Fioletowy v2", color = 12, price = 5000}
			},
			
			-- Turbo
			[18] = {
				{ name = "Brak", mod = 0, price = 0},
				{ name = "Tuning", mod = 1, price = 1000, percent = 13}
			},

			-- Armor
			[16] = {
				{name = "Armor +20%", mod = 0, price = 1000, percent = 7},
				{name = "Armor +40%", mod = 1, price = 1000, percent = 9},
				{name = "Armor +60%", mod = 2, price = 1000, percent = 11},
				{name = "Armor +80%", mod = 3, price = 1000, percent = 13},
				{name = "Armor +100%", mod = 4, price = 1000, percent = 15}
			},

			-- Suspension
			[15] = {
				{name = "Lowered", mod = 0, price = 1000, percent = 0.5},
				{name = "Street", mod = 1, price = 15000, percent = 1},
				{name = "Sport", mod = 2, price = 15000, percent = 1.5},
				{name = "Competition", mod = 3, price = 15000, percent = 2}
			},

			-- Horn
			[14] = {
				{name = "Truck", mod = 0, price = 3000},
				{name = "Police", mod = 1, price = 3000},
				{name = "Clown", mod = 2, price = 3000},
				{name = "Musical 1", mod = 3, price = 3000},
				{name = "Musical 2", mod = 4, price = 3000},
				{name = "Musical 3", mod = 5, price = 3000},
				{name = "Musical 4", mod = 6, price = 3000},
				{name = "Musical 5", mod = 7, price = 3000},
				{name = "Sad Trombone", mod = 8, price = 3000},
				{name = "Classical 1", mod = 9, price = 3000},
				{name = "Classical 2", mod = 10, price = 3000},
				{name = "Classical 3", mod = 11, price = 3000},
				{name = "Classical 4", mod = 12, price = 3000},
				{name = "Classical 5", mod = 13, price = 3000},
				{name = "Classical 6", mod = 14, price = 3000},
				{name = "Classical 7", mod = 15, price = 3000},
				{name = "Scaledo", mod = 16, price = 3000},
				{name = "Scalere", mod = 17, price = 3000},
				{name = "Scalemi", mod = 18, price = 3000},
				{name = "Scalefa", mod = 19, price = 3000},
				{name = "Scalesol", mod = 20, price = 3000},
				{name = "Scalela", mod = 21, price = 3000},
				{name = "Scaleti", mod = 22, price = 3000},
				{name = "Scaledo High", mod = 23, price = 3000},
				{name = "Jazz 1", mod = 24, price = 3000},
				{name = "Jazz 2", mod = 25, price = 3000},
				{name = "Jazz 3", mod = 26, price = 3000},
				{name = "Jazzloop", mod = 27, price = 3000},
				{name = "Star Spangled Banner 1", mod = 28, price = 3000},
				{name = "Star Spangled Banner 2", mod = 29, price = 3000},
				{name = "Star Spangled Banner 3", mod = 30, price = 3000},
				{name = "Star Spangled Banner 4", mod = 31, price = 3000},
				{name = "Classical Loop 8", mod = 32, price = 3000},
				{name = "Classical Loop 9", mod = 33, price = 3000},
				{name = "Classical Loop 10", mod = 34, price = 3000},
				{name = "Classical 8", mod = 35, price = 3000},
				{name = "Classical 9", mod = 36, price = 3000},
				{name = "Classical 10", mod = 37, price = 3000},
				{name = "Funeral Loop", mod = 38, price = 3000},
				{name = "Funeral", mod = 39, price = 3000},
				{name = "Spooky Loop", mod = 40, price = 3000},
				{name = "Spooky", mod = 41, price = 3000},
				{name = "San Andreas Loop", mod = 42, price = 3000},
				{name = "San Andreas", mod = 43, price = 3000},
				{name = "Liberty City Loop", mod = 44, price = 3000},
				{name = "Liberty City", mod = 45, price = 3000},
				{name = "Festive 1 Loop", mod = 46, price = 3000},
				{name = "Festive 1", mod = 47, price = 3000},
				{name = "Festive 2 Loop", mod = 48, price = 3000},
				{name = "Festive 2", mod = 49, price = 3000},
				{name = "Festive 3 Loop", mod = 50, price = 3000},
				{name = "Festive 3", mod = 51, price = 3000}
			},

			-- Transmission
			[13] = {
				{name = "Street", mod = 0, price = 1000, percent = 3},
				{name = "Sports", mod = 1, price = 1000, percent = 6},
				{name = "Race", mod = 2, price = 1000, percent = 9}
			},
			
			-- Brakes
			[12] = {
				{name = "Street", mod = 0, price = 1000, percent = 1.00},
				{name = "Sport", mod = 1, price = 1000, percent = 3.00},
				{name = "Race", mod = 2, price = 1000, percent = 6.00}
			},
			
			-- Engine
			[11] = {
				{name = "Chiptuning", mod = 0, price = 1000, percent = 1},
				{name = "Stage 1", mod = 1, price = 1000, percent = 4},
				{name = "Stage 2", mod = 2, price = 1000, percent = 7},
				{name = "Stage 3", mod = 3, price = 1000, percent = 10}
			},
			
			-- Roof
			[10] = { price = 2500, percent = 1 },

			-- Right Fender
			[9] = { price = 2500, percent = 1 },
			
			-- Fenders
			[8] = { price = 2500, percent = 1 },
	
			-- Hood
			[7] = { price = 2500, percent = 1 },
			
			-- Grille
			[6] = { price = 2500, percent = 1 },
			
			-- Frame
			[5] = { price = 2500, percent = 1 },
			
			-- Exhaust
			[4] = { price = 2500, percent = 1 },
			
			-- Skirts
			[3] = { price = 2500, percent = 1 },
			
			-- Rear bumper
			[2] = { price = 2500, percent = 1 },
			
			-- Front bumper
			[1] = { price = 2500, percent = 1 },
			
			-- Spoiler
			[0] = { price = 2500, percent = 1 }
		}
	},

	menu = {
		controls = {
			menu_up = 27,
			menu_down = 173,
			menu_left = 174,
			menu_right = 175,
			menu_select = 201,
			menu_back = 177
		},
		position = "left",
		theme = "light",
		maxbuttons = 10,
		width = 0.24,
		height = 0.36
	}
}