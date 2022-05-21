Config = {}

-- [[ MARKERY/BLIPY ]] --
Config.DrawDistance = 5
Config.Size         = { x = 2, y = 2, z = 0.5 }
Config.Color        = {r = 0, g = 128, b = 255}
Config.Type         = 27
Config.Zones = {}
Config.Blips = {}

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
	[1] = { name = "Zwykła", rate = 52 },
	[2] = { name = "Rzadka", rate = 28 },
	[3] = { name = "Epicka", rate = 13 },
	[4] = { name = "Wyjątkowa", rate = 6 },
	[5] = { name = "Legendarna", rate = 1 },
}

Config["exilecases"] = {
	["legalna"] = { 
        name = "Exile Legal Chest",
        list = {
			{ money = 1000000, tier = 1 },
			{ item = "bon1", amount= 2, tier = 1 }, ---Zmiana rejestracji w pojeździe---
			{ item = "bon17", amount= 1, tier = 1 }, ---Zniżka 25% na tuning do auta---
			{ money = 3000000, tier = 2 },
			{ item = "bon2", amount= 1, tier = 2 }, ---Zniżka 50% na tuning do auta---
			{ item = "bon3", amount= 1, tier = 2 }, ---Auto z brokera do 5mln---
			{ item = "bon4", amount= 1, tier = 2 }, ---Zniżka do brokera 20%---
			{ item = "bon1", amount= 5, tier = 2 }, ---Zmiana rejestracji w pojeździe---
			{ item = "legalna", amount= 1, tier = 2 },
			{ item = "crimowa", amount= 1, tier = 2 },
			{ money = 7000000, tier = 3 },
			{ item = "bon5", amount= 1, tier = 3 }, ---Auto z brokera do 10mln---
			{ item = "bon6", amount= 1, tier = 3 }, ---Zniżka 40% do brokera---
			{ item = "bon7", amount= 1, tier = 3 }, ---Bon na darmowy tuning do auta---
			{ item = "legalna", amount= 2, tier = 3 },
			{ item = "crimowa", amount= 2, tier = 3 },
			{ item = "legalna", amount= 2, tier = 3 },
			{ money = 12000000, tier = 4 },
			{ item = "bon8", amount= 1, tier = 4 }, ---Auto z brokera do 15mln---
			{ item = "bon9", amount= 1, tier = 4 }, ---Zniżka 50% do brokera---
			{ item = "bon10", amount= 1, tier = 4 }, ---Skrócenie bana o 24h---
			{ money = 20000000, tier = 5 },
           	{ item = "bon11", amount= 1, tier = 5 }, ---Auto limitowane---
	       	{ item = "bon12", amount= 1, tier = 5 }, ---Dom limitowany---	
	       	{ item = "bon13", amount= 1, tier = 5 }, ---Śmigłowiec lub Samolot---	
			{ item = "bon15", amount= 1, tier = 4 }, ---Skrócenie bana o 72h---			
        }
    },
	["crimowa"] = { 
        name = "Exile Illegal Chest",
        list = {
			{ black_money = 1500000, tier = 1 },
			{ black_money = 1500000, tier = 1 },
			{ item = "clip", amount= 350, tier = 1 },
			{ item = "clipsmg", amount= 40, tier = 1 },
			{ item = "extendedclip", amount= 30, tier = 1 },
			{ item = "kawa", amount= 1000, tier = 1 },
			{ item = "krotkofalowka", amount= 150, tier = 1 },
			{ weapon = "WEAPON_SNSPISTOL_MK2", amount= 15, tier = 1 },
			{ weapon = "WEAPON_VINTAGEPISTOL", amount= 15, tier = 1 },
			{ weapon = "WEAPON_DOUBLEACTION", amount= 4, tier = 1 },
			{ item = "kamzasmall", amount= 10, tier = 1 },
			{ item = "kamzaduza", amount= 5, tier = 1 },
			{ item = "coke_pooch", amount= 350, tier = 1 },
			{ item = "meth_pooch", amount= 500, tier = 1 },
			{ black_money = 3500000, tier = 2 },
			{ weapon = "WEAPON_SNSPISTOL_MK2", amount= 35, tier = 2 },
			{ weapon = "WEAPON_VINTAGEPISTOL", amount= 30, tier = 2 },
			{ item = "opium_pooch", amount= 400, tier = 2 },
			{ item = "kamzaduza", amount= 10, tier = 2 },
			{ item = "kamzasmall", amount= 20, tier = 2 },
			{ item = "clip_drum", amount= 8, tier = 2 },
			{ item = "clip_extended", amount= 14, tier = 2 },
			{ weapon = "WEAPON_DOUBLEACTION", amount= 8, tier = 2 },
			{ item = "crimowa", amount= 1, tier = 2 },
			{ item = "legalna", amount= 1, tier = 2 },
			{ black_money = 8000000, tier = 3 },
			{ weapon = "WEAPON_MICROSMG", amount= 1, tier = 3 },
			{ weapon = "WEAPON_MINISMG", amount= 1, tier = 3 },
			{ item = "crimowa", amount= 2, tier = 3 },
			{ item = "legalna", amount= 2, tier = 3 },
			{ black_money = 15000000, tier = 4 },
			{ weapon = "WEAPON_COMPACTRIFLE", amount= 1, tier = 4 },
			{ weapon = "WEAPON_COMBATPDW", amount= 1, tier = 4 },
			{ item = "bon10", amount= 1, tier = 4 }, ---Skrócenie bana o 24h---
			{ black_money = 25000000, tier = 5 },
			{ weapon = "WEAPON_PUMPSHOTGUN", amount= 1, tier = 5 },
			{ weapon = "WEAPON_ASSAULTRIFLE", amount= 1, tier = 5 },
			{ weapon = "WEAPON_RPG", amount= 1, tier = 5 },
           	{ weapon = "WEAPON_MUSKET", amount= 1, tier = 5 },
          	{ item = "bon11", amount= 1, tier = 5 }, ---Auto limitowane---
	     	{ item = "bon16", amount= 1, tier = 5 }, ---HMMWV z salonu + FT---
			{ item = "bon15", amount= 1, tier = 5 }, ---Skrócenie bana o 72h---
        }
    },
	["weaponchest"] = { 
        name = "Exile Weapon Chest",
        list = {
		{ weapon = "WEAPON_VINTAGEPISTOL", amount= 20, tier = 1 },
		{ weapon = "WEAPON_SNSPISTOL_MK2", amount= 20, tier = 1 },
		{ weapon = "WEAPON_CERAMICPISTOL", amount= 20, tier = 1 },
		{ weapon = "WEAPON_DOUBLEACTION", amount= 5, tier = 1 },
		{ weapon = "WEAPON_MINISMG", amount= 2, tier = 2 },
		{ weapon = "WEAPON_MICROSMG", amount= 2, tier = 2 },
		{ weapon = "WEAPON_MACHINEPISTOL", amount= 2, tier = 2 },
		{ weapon = "WEAPON_DOUBLEACTION", amount= 10, tier = 2 },
		{ weapon = "WEAPON_GUSENBERG", amount= 2, tier = 3 },
		{ weapon = "WEAPON_COMPACTRIFLE", amount= 2, tier = 3 },
		{ weapon = "WEAPON_COMBATPDW", amount= 2, tier = 3 },
		{ weapon = "WEAPON_APPISTOL", amount= 3, tier = 3 },
		{ weapon = "WEAPON_CARBINERIFLE", amount= 1, tier = 4 },
		{ weapon = "WEAPON_ASSAULTRIFLE", amount= 1, tier = 4 },
		{ weapon = "WEAPON_RPG", amount= 1, tier = 5 },
		{ weapon = "WEAPON_MUSKET", amount= 1, tier = 5 },
		{ weapon = "WEAPON_POMPSHOTGUN", amount= 1, tier = 5 },
		{ weapon = "WEAPON_MG", amount= 1, tier = 5 },
		{ weapon = "WEAPON_SAWNOFFSHOTGUN", amount= 1, tier = 5 },
        }
    },
	["carchest"] = { 
        name = "Exile Car Chest",
        list = {
		{ money = 1000000, tier = 1 },
		{ item = "bon17", amount= 1, tier = 1 }, ---Zniżka 25% na tuning do auta---	
		{ item = "bon1", amount= 2, tier = 1 }, ---Zmiana rejestracji w aucie---	
		{ item = "bon4", amount= 1, tier = 2 }, ---Zniżka do brokera 20%---	
		{ item = "bon1", amount= 4, tier = 2 }, ---Zmiana rejestracji w aucie---
		{ item = "bon2", amount= 1, tier = 2 }, ---Zniżka 50% na tuning do auta---
		{ item = "bon3", amount= 1, tier = 2 }, ---Auto z brokera do 5mln---
		{ money = 3000000, tier = 2 },
		{ money = 7000000, tier = 3 },
		{ item = "bon19", amount= 1, tier = 3 }, ---Ubranie z wybraną przez ciebie grafiką---	
		{ item = "bon6", amount= 1, tier = 3 }, ---Zniżka 40% do brokera---
		{ item = "bon7", amount= 2, tier = 3 }, ---Bon na darmowy tuning do auta---
		{ item = "bon5", amount= 1, tier = 3 }, ---Auto z brokera do 10mln---
		{ item = "bon10", amount= 1, tier = 3 }, ---Skrócenie bana o 24h---
		{ item = "bon20", amount= 1, tier = 4 }, ---Limitowane malowanie na dowolne auto---	
		{ item = "bon15", amount= 1, tier = 4 }, ---Skrócenie bana o 72h---	
		{ item = "bon7", amount= 3, tier = 4 }, ---Darmowy Full Tune do auta---	
		{ item = "bon21", amount= 1, tier = 4 }, ---Dowolne auto car dealera---
		{ item = "bon8", amount= 1, tier = 4 }, ---Auto z brokera do 15mln---
		{ money = 12000000, tier = 4 },
		{ item = "bon22", amount= 1, tier = 5 }, ---BMW M2 EXILE EDITION---
		{ item = "bon23", amount= 1, tier = 5 }, ---Challenger Kim3n EDITION---
		{ item = "bon13", amount= 1, tier = 5 }, ---Śmigłowiec lub Samolot---	
		{ item = "bon24", amount= 1, tier = 5 }, ---Dowolna limitka z limited dźwiękiem---
		{ item = "bon25", amount= 1, tier = 5 }, ---Pakiet limitek 2+1---
		}
	},
}