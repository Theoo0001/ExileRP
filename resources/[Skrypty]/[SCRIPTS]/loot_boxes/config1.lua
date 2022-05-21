Config = {}

-- [[ MARKERY/BLIPY ]] --
Config.DrawDistance = 5
Config.Size         = { x = 2, y = 2, z = 0.5 }
Config.Color        = {r = 0, g = 128, b = 255}
Config.Type         = 27
Config.Zones = {
	Exchange = {
		Pos = {
			{x = 0.0,   y = 0.183,  z = 00.095},
		}
	}
}
Config.Blips = {
	{name="Wymiana Serc", color=59, id=621, x=932.514, y=44.183, z=81.095, size = 1.0}
}

-- [[ WYMAGANA ILOSC ]] --
Config.RequiredLegalCase1 = 200
Config.RequiredLegalCase2 = 400
Config.RequiredLegalCase3 = 800
Config.RequiredLegalCase4 = 1500
Config.RequiredIllLegalCase1 = 200
Config.RequiredIllLegalCase2 = 400
Config.RequiredIllLegalCase3 = 800
Config.RequiredIllLegalCase4 = 1500

-- [[ SKRZYNKI ]] --
Config["image_source"] = "nui://loot_boxes/img/items/"

Config["chance"] = {
	[1] = { name = "Zwykła", rate = 51 },
	[2] = { name = "Rzadka", rate = 29 },
	[3] = { name = "Epicka", rate = 13 },
	[4] = { name = "Wyjątkowa", rate = 6 } ,
	[5] = { name = "Legendarna", rate = 1 },
}

Config["exilecases"] = {
	["legalna1"] = { ---200---
		name = "Baby Valentine's Chest",
		list = {
		    { money = 200000, tier = 1 },
			{ money = 220000, tier = 1 },
			{ money = 240000, tier = 1 },
			{ item = "serce", amount= 300, tier = 1 },
			{ item = "legalna1", amount= 1, tier = 1 },
			{ item = "kawa", amount= 250, tier = 1 },
			{ money = 400000, tier = 2 },
			{ money = 420000, tier = 2 },
			{ money = 440000, tier = 2 },
			{ item = "bon13", amount= 1, tier = 2 }, ---Zmiana rejestracji w pojeździe---
			{ item = "legalna2", amount= 1, tier = 2 }, 
			{ money = 800000, tier = 3 },
			{ money = 820000, tier = 3 },
			{ money = 840000, tier = 3 },
			{ item = "serce", amount= 600, tier = 3 },
			{ money = 1000000, tier = 4 },
			{ money = 1200000, tier = 4 },
			{ money = 1400000, tier = 4 },
			{ item = "legalna3", amount= 1, tier = 4 },
			{ item = "bon14", amount= 1, tier = 4 }, ---Wybrane mieszkanie do 2mln---
			{ money = 1700000, tier = 5 },
			{ money = 2000000, tier = 5 },
			{ money = 2300000, tier = 5 },
			{ item = "legalna3", amount= 1, tier = 5 }, 
			{ item = "bon4", amount= 1, tier = 5 }, ---Zniżka 2,5mln na auto z brokera---
			{ item = "bon3", amount= 1, tier = 5 }, ---Zniżka na tuning 50%---
		}
	},
	["legalna2"] = {  ---400---
        name = "Valentine's Chest",
        list = {
		    { money = 400000, tier = 1 },
			{ money = 420000, tier = 1 },
			{ money = 440000, tier = 1 },
			{ item = "bon13", amount= 1, tier = 1 }, ---Zmiana rejestracji w pojeździe---
			{ item = "serce", amount= 300, tier = 1 },
			{ money = 800000, tier = 2 },
			{ money = 820000, tier = 2 },
			{ money = 840000, tier = 2 },
			{ item = "bon13", amount= 2, tier = 2 }, ---Zmiana rejestracji w pojeździe---
			{ item = "serce", amount= 600, tier = 2 },
			{ money = 1700000, tier = 3 },
			{ money = 1900000, tier = 3 },
			{ money = 2100000, tier = 3 },
			{ item = "bon4", amount= 1, tier = 3 }, ---Zniżka 2,5mln na auto z brokera---
			{ item = "bon14", amount= 1, tier = 3 }, ---Wybrane mieszkanie do 2mln---
			{ money = 2500000, tier = 4 },
			{ money = 2700000, tier = 4 },
			{ money = 2900000, tier = 4 },
			{ item = "bon18", amount= 1, tier = 4 }, ---Zniżka na auto 6mln---
			{ item = "legalna3", amount= 1, tier = 4 },
			{ money = 3700000, tier = 5 },
			{ money = 4000000, tier = 5 },
			{ money = 4300000, tier = 5 },
			{ item = "bon17", amount= 1, tier = 5 }, ---BMW M8 Cabrio---
			{ item = "bon7", amount= 1, tier = 5 }, ---Darmowy tuning do jednego auta---
			{ item = "legalna4", amount= 1, tier = 5 }, 
        }
    },
	["legalna3"] = { ----800----
        name = "Giga Valentine's Chest",
        list = {
		    { money = 850000, tier = 1 },
			{ money = 880000, tier = 1 },
			{ money = 910000, tier = 1 },
			{ item = "bon13", amount= 2, tier = 1 }, ---Zmiana rejestracji w pojeździe---
			{ item = "serce", amount= 600, tier = 1 },
			{ money = 1700000, tier = 2 },
			{ money = 2000000, tier = 2 },
			{ money = 2100000, tier = 2 },
			{ item = "bon4", amount= 1, tier = 2 }, ---Zniżka 2,5mln na auto z brokera---
			{ item = "bon14", amount= 1, tier = 2 }, ---Wybrane mieszkanie do 2mln---
			{ item = "legalna3", amount= 1, tier = 2 }, 
			{ money = 3400000, tier = 3 },
			{ money = 3700000, tier = 3 },
			{ money = 4000000, tier = 3 },
			{ item = "bon17", amount= 1, tier = 3 }, ---BMW M8 Cabrio---
			{ item = "bon7", amount= 1, tier = 3 }, ---Darmowy tuning do jednego auta---
			{ item = "legalna4", amount= 1, tier = 3 }, 
			{ money = 5000000, tier = 4 },
			{ money = 5300000, tier = 4 },
			{ money = 5600000, tier = 4 },
			{ item = "bon18", amount= 1, tier = 4 }, ---Zniżka na auto 6mln---
			{ money = 7500000, tier = 5 },
			{ money = 7800000, tier = 5 },
			{ money = 8100000, tier = 5 },
			{ item = "bon16", amount= 1, tier = 5 }, ---Audi RS5 ABT---
			{ item = "bon6", amount= 1, tier = 5 }, ---Zniżka 8mln na auto z brokera---
        }
    },
	["legalna4"] = { ---1500---
        name = "Monster Valentine's Chest",
        list = {
		    { money = 1700000, tier = 1 },
			{ money = 2000000, tier = 1 },
			{ money = 2300000, tier = 1 },
			{ item = "bon13", amount= 3, tier = 1 }, ---Zmiana rejestracji w pojeździe---
			{ money = 3400000, tier = 2 },
			{ money = 3700000, tier = 2 },
			{ money = 4000000, tier = 2 },
			{ item = "bon7", amount= 1, tier = 2 }, ---Darmowy tuning do jednego auta---
			{ item = "bon2", amount= 1, tier = 2 }, ---Zniżka 4mln na auto z brokera---
			{ item = "legalna4", amount= 1, tier = 2 },
			{ money = 6800000, tier = 3 },
			{ money = 7100000, tier = 3 },
			{ money = 7400000, tier = 3 },
			{ item = "bon16", amount= 1, tier = 3 }, ---Audi RS5 ABT---
			{ item = "bon6", amount= 1, tier = 3 }, ---Zniżka 8mln na auto z brokera---
			{ item = "legalna4", amount= 2, tier = 3 },
			{ money = 10000000, tier = 4 },
			{ money = 10500000, tier = 4 },
			{ money = 11000000, tier = 4 },
			{ item = "bon15", amount= 1, tier = 4 }, ---Mercedes GT63S 2NCS---
			{ money = 15000000, tier = 5 },
			{ money = 15500000, tier = 5 },
			{ money = 16000000, tier = 5 },
           	{ item = "bon8", amount= 1, tier = 5 }, ---Auto limitowane---
	       	{ item = "bon9", amount= 1, tier = 5 }, ---Dom limitowany---		
        }
    },
	["crimowa1"] = { ---200---
        name = "Baby Airport Chest",
        list = {
			{ black_money = 250000, tier = 1 },
			{ black_money = 270000, tier = 1 },
			{ black_money = 290000, tier = 1 },
			{ weapon = "WEAPON_SNSPISTOL_MK2", amount= 5, tier = 1 },
			{ weapon = "WEAPON_VINTAGEPISTOL", amount= 5, tier = 1 },
			{ black_money = 500000, tier = 2 },
			{ black_money = 530000, tier = 2 },
			{ black_money = 560000, tier = 2 },
			{ weapon = "WEAPON_SNSPISTOL_MK2", amount= 10, tier = 2 },
			{ weapon = "WEAPON_VINTAGEPISTOL", amount= 10, tier = 2 },
			{ black_money = 1000000, tier = 3 },
			{ black_money = 1100000, tier = 3 },
			{ black_money = 1200000, tier = 3 },
			{ weapon = "WEAPON_MICROSMG", amount= 1, tier = 3 },
			{ weapon = "WEAPON_VINTAGEPISTOL", amount= 15, tier = 3 },
			{ black_money = 1500000, tier = 4 },
			{ black_money = 1700000, tier = 4 },
			{ black_money = 1900000, tier = 4 },
			{ weapon = "WEAPON_ASSAULTRIFLE", amount= 1, tier = 4 },
			{ weapon = "WEAPON_COMPACTRIFLE", amount= 2, tier = 4 },
			{ black_money = 2500000, tier = 5 },
			{ black_money = 2700000, tier = 5 },
			{ black_money = 2900000, tier = 5 },
			{ item = "bon3", amount= 1, tier = 5 }, ---Zniżka 50% na tuning do auta---
           	{ weapon = "WEAPON_SMG_MK2", amount= 1, tier = 5 },
        }
    },
	["crimowa2"] = { ---400---
        name = "Airport Chest",
        list = {
			{ black_money = 500000, tier = 1 },
			{ black_money = 520000, tier = 1 },
			{ black_money = 540000, tier = 1 },
			{ weapon = "WEAPON_SNSPISTOL_MK2", amount= 10, tier = 1 },
			{ weapon = "WEAPON_VINTAGEPISTOL", amount= 10, tier = 1 },
			{ black_money = 1000000, tier = 2 },
			{ black_money = 1300000, tier = 2 },
			{ black_money = 1600000, tier = 2 },
			{ weapon = "WEAPON_SNSPISTOL_MK2", amount= 18, tier = 2 },
			{ weapon = "WEAPON_MICROSMG", amount= 1, tier = 2 },
			{ weapon = "WEAPON_VINTAGEPISTOL", amount= 15, tier = 2 },
			{ black_money = 2000000, tier = 3 },
			{ black_money = 2300000, tier = 3 },
			{ black_money = 2600000, tier = 3 },
			{ weapon = "WEAPON_MICROSMG", amount= 2, tier = 3 },
			{ weapon = "WEAPON_VINTAGEPISTOL", amount= 30, tier = 3 },
			{ black_money = 3000000, tier = 4 },
			{ black_money = 3300000, tier = 4 },
			{ black_money = 3600000, tier = 4 },
			{ weapon = "WEAPON_ASSAULTRIFLE", amount= 1, tier = 4 },
			{ weapon = "WEAPON_COMPACTRIFLE", amount= 2, tier = 4 },
			{ black_money = 4500000, tier = 5 },
			{ black_money = 4800000, tier = 5 },
			{ black_money = 5100000, tier = 5 },
			{ item = "bon8", amount= 1, tier = 5 }, ---Darmowy tuning do jednego auta---
           	{ weapon = "WEAPON_GUSENBERG", amount= 2, tier = 5 },
        }
    },
	["crimowa3"] = { ---800---
        name = "Giga Airport Chest",
        list = {
			{ black_money = 1000000, tier = 1 },
			{ black_money = 1100000, tier = 1 },
			{ black_money = 1200000, tier = 1 },
			{ weapon = "WEAPON_VINTAGEPISTOL", amount= 15, tier = 1 },
			{ weapon = "WEAPON_VINTAGEPISTOL", amount= 25, tier = 1 },
			{ black_money = 2000000, tier = 2 },
			{ black_money = 2200000, tier = 2 },
			{ black_money = 2400000, tier = 2 },
			{ weapon = "WEAPON_MICROSMG", amount= 1, tier = 2 },
			{ black_money = 4000000, tier = 3 },
			{ black_money = 4200000, tier = 3 },
			{ black_money = 4400000, tier = 3 },
			{ weapon = "WEAPON_COMPACTRIFLE", amount= 1, tier = 3 },
			{ weapon = "WEAPON_GUSENBERG", amount= 1, tier = 3 },
			{ item = "bon8", amount= 1, tier = 3 }, ---Darmowy tuning do jednego auta---
			{ black_money = 6000000, tier = 4 },
			{ black_money = 6500000, tier = 4 },
			{ black_money = 7000000, tier = 4 },
			{ weapon = "WEAPON_ASSAULTRIFLE", amount= 1, tier = 4 },
			{ weapon = "WEAPON_COMPACTRIFLE", amount= 2, tier = 4 },
			{ black_money = 9000000, tier = 5 },
			{ black_money = 9500000, tier = 5 },
			{ black_money = 10000000, tier = 5 },
           	{ weapon = "WEAPON_GUSENBERG", amount= 2, tier = 5 },
          	{ item = "bon12", amount= 1, tier = 5 }, ---Brabus G500---	
        }
    },
	["crimowa4"] = { ---1500---
        name = "Monster Airport Chest",
        list = {
			{ black_money = 2000000, tier = 1 },
			{ black_money = 2400000, tier = 1 },
			{ black_money = 2800000, tier = 1 },
			{ weapon = "WEAPON_MICROSMG", amount= 2, tier = 1 },
			{ black_money = 4000000, tier = 2 },
			{ black_money = 4400000, tier = 2 },
			{ black_money = 4800000, tier = 2 },
			{ weapon = "WEAPON_SMG_MK2", amount= 1, tier = 2 },
			{ weapon = "WEAPON_COMPACTRIFLE", amount= 1, tier = 2 },
			{ item = "bon8", amount= 1, tier = 2 }, ---Darmowy tuning do jednego auta---
			{ black_money = 8000000, tier = 3 },
			{ black_money = 8400000, tier = 3 },
			{ black_money = 8800000, tier = 3 },
			{ weapon = "WEAPON_COMPACTRIFLE", amount= 2, tier = 3 },
			{ weapon = "WEAPON_ASSAULTRIFLE", amount= 1, tier = 3 },
			{ black_money = 12000000, tier = 4 },
			{ black_money = 12500000, tier = 4 },
			{ black_money = 13000000, tier = 4 },
			{ weapon = "WEAPON_PUMPSHOTGUN", amount= 1, tier = 4 },
			{ weapon = "WEAPON_GUSENBERG", amount= 2, tier = 4 },
			{ item = "bon10", amount= 1, tier = 4 }, ---X-PAKA---
			{ black_money = 18000000, tier = 5 },
			{ black_money = 18500000, tier = 5 },
			{ black_money = 19000000, tier = 5 },
           	{ weapon = "WEAPON_MUSKET", amount= 1, tier = 5 },
          	{ item = "bon9", amount= 1, tier = 5 }, ---Auto limitowane---
	     	{ item = "bon11", amount= 1, tier = 5 }, ---Nissan Titan---			
        }
    },
}