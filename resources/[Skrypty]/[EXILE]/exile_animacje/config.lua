Config = {}
Config.Animations = {
    {
        name  = 'Style chodzenia',
        label = 'Obywatel - Styl Chodzenia',
        items = {
            {label = "Normalny [K]", type = "walkstyle", data = {lib = "move_f@generic", anim = "move_f@generic", e = "normalnyk"}},
            {label = "Normalny [M]", type = "walkstyle", data = {lib = "move_m@generic", anim = "move_m@generic", e = "normalnym"}},
            {label = "Pewniak [K]", type = "walkstyle", data = {lib = "move_f@heels@d", anim = "move_f@heels@d", e = "pewniakk"}},
            {label = "Pewniak [M]", type = "walkstyle", data = {lib = "move_m@confident", anim = "move_m@confident", e = "pewniakm"}},
            {label = "Gruby [K]", type = "walkstyle", data = {lib = "move_f@fat@a", anim = "move_f@fat@a", e = "grubyk"}},
            {label = "Gruby [M]", type = "walkstyle", data = {lib = "move_m@fat@a", anim = "move_m@fat@a", e = "grubym"}},
            {label = "Poszkodowany [K]", type = "walkstyle", data = {lib = "move_f@injured", anim = "move_f@injured", e = "poszkodowanyk"}},
            {label = "Poszkodowany [M]", type = "walkstyle", data = {lib = "move_m@injured", anim = "move_m@injured", e = "poszkodowanym"}},
            {label = "Policjant", type = "walkstyle", data = {lib = "move_m@tool_belt@a", anim = "move_m@tool_belt@a", e = "policjant"}},
            {label = "Policjantka", type = "walkstyle", data = {lib = "move_f@tool_belt@a", anim = "move_f@tool_belt@a", e = "policjantka"}},
            {label = "Zuchwały [K]", type = "walkstyle", data = {lib = "move_f@sassy", anim = "move_f@sassy", e = "zuchwalyk"}},
            {label = "Zuchwały [M]", type = "walkstyle", data = {lib = "move_m@sassy", anim = "move_m@sassy", e = "zuchwalym"}},
            {label = "Smutny", type = "walkstyle", data = {lib = "move_m@depressed@a", anim = "move_m@depressed@a", e = "smutny"}},
            {label = "Biznes", type = "walkstyle", data = {lib = "move_m@business@a", anim = "move_m@business@a", e = "biznes"}},
            {label = "Odważny", type = "walkstyle", data = {lib = "move_m@brave@a", anim = "move_m@brave@a", e = "odwazny"}},
            {label = "Luzak", type = "walkstyle", data = {lib = "move_m@casual@e", anim = "move_m@casual@e", e = "luzak"}},
            {label = "Hipster", type = "walkstyle", data = {lib = "move_m@hipster@a", anim = "move_m@hipster@a", e = "hipster"}},
            {label = "Smutny", type = "walkstyle", data = {lib = "move_m@sad@a", anim = "move_m@sad@a", e = "smutny"}},
            {label = "Siłacz", type = "walkstyle", data = {lib = "move_m@muscle@a", anim = "move_m@muscle@a", e = "silacz"}},
            {label = "Gangster 1", type = "walkstyle", data = {lib = "move_m@gangster@generic", anim = "move_m@gangster@generic", e = "gangster1"}},
            {label = "Gangster 2", type = "walkstyle", data = {lib = "move_m@money", anim = "move_m@money", e = "gangster2"}},
            {label = "Wspinaczka", type = "walkstyle", data = {lib = "move_m@hiking", anim = "move_m@hiking", e = "wspinaczka"}},
            {label = "Bezdomny", type = "walkstyle", data = {lib = "move_m@hobo@a", anim = "move_m@hobo@a", e = "bezdomny"}},
            {label = "Podpity", type = "walkstyle", data = {lib = "move_m@buzzed", anim = "move_m@buzzed", e = "podpity"}},
            {label = "Średnio Pijany", type = "walkstyle", data = {lib = "move_m@drunk@moderatedrunk", anim = "move_m@drunk@moderatedrunk", e = "sredniopijany"}},
            {label = "Bardzo Pijany", type = "walkstyle", data = {lib = "move_m@drunk@verydrunk", anim = "move_m@drunk@verydrunk", e = "bardzopijany"}},
            {label = "W pośpiechu 1", type = "walkstyle", data = {lib = "move_m@hurry_butch@b", anim = "move_m@hurry_butch@b", e = "wpospiechu1"}},
            {label = "W pośpiechu 2", type = "walkstyle", data = {lib = "move_m@hurry@b", anim = "move_m@hurry@b", e = "wpospiechu2"}},
            {label = "Szybki", type = "walkstyle", data = {lib = "move_m@quick", anim = "move_m@quick", e = "szybki"}},
        }
    },  

    {
        name = 'Wyrazy twarzy',
        label = 'Obywatel - Wyraz Twarzy',
        items = {
		    {label = "Neutralny", type = "faceexpression", data = {anim = "mood_Normal_1", e = "neutralny"}},
		    {label = "Szczęśliwy", type = "faceexpression", data = {anim = "mood_Happy_1", e = "szczesliwy"}},
		    {label = "Zły", type = "faceexpression", data = {anim = "mood_Angry_1", e = "zly"}},		
		    {label = "Podejrzliwy", type = "faceexpression", data = {anim = "mood_Aiming_1", e = "podejrzliwy"}},
		    {label = "Ból", type = "faceexpression", data = {anim = "mood_Injured_1", e = "bol"}},
		    {label = "Zdenerwowany", type = "faceexpression", data = {anim = "mood_stressed_1", e = "zdenerwowany"}},
		    {label = "Zadowolony", type = "faceexpression", data = {anim = "mood_smug_1", e = "zadowolony"}},
		    {label = "Podpity", type = "faceexpression", data = {anim = "mood_drunk_1", e = "podpity"}},
		    {label = "Zszokowany", type = "faceexpression", data = {anim = "shocked_1", e = "zszokowany"}},
		    {label = "Zamknięte oczy", type = "faceexpression", data = {anim = "mood_sleeping_1", e = "oczy"}},
		    {label = "Przeżuwanie", type = "faceexpression", data = {anim = "eating_1", e = "zucie"}},
        }
    },

    {
        name = 'Przywitania',
        label = 'Obywatel - Powitania',
        items = {
            {label = "Machanie ręką", type = "anim", data = {lib = "random@hitch_lift", anim = "come_here_idle_c", car = 0, loop = 51, e = "machanie"}},
            {label = "Machanie ręką 2", type = "anim", data = {lib = "friends@fra@ig_1", anim = "over_here_idle_a", car = 0, loop = 51, e = "machanie2"}},
            {label = "Machnięcie ręką 3", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_hello", car = 0, loop = 50, e = "machanie3"}},
            {label = "Żółwik", type = "anim", data = {lib = "anim@am_hold_up@male", anim = "shoplift_high", car = 0, loop = 50, e = "zolwik"}},
            {label = "Graba", type = "anim", data = {lib = "mp_ped_interaction", anim = "handshake_guy_a", car = 0, loop = 1, e = "graba"}},
            {label = "Piąteczka", type = "anim", data = {lib = "anim@arena@celeb@flat@paired@no_props@", anim = "high_five_c_player_b", car = 0, loop = 50, e = "piateczka"}},            
        }
    },
	
	{
        name = 'Reakcje',
        label = 'Zachowanie - Humor',
        items = {
	     	{label = "Facepalm 1", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@face_palm", anim = "face_palm", car = 1, loop = 56, e = "facepalm"}},      
	     	{label = "Facepalm 2", type = "anim", data = {lib = "anim@mp_player_intupperface_palm", anim = "enter", car = 1, loop = 50, e = "facepalm2"}},   
            {label = "Nie wierze", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@face_palm", anim = "face_palm", car = 1, loop = 56, e = "niewierze"}},
            {label = "Drapanie się po głowie", type = "anim", data = {lib = "mp_cp_stolen_tut", anim = "b_think", car = 1, loop = 51, e = "drapanie"}},
			{label = "Złapanie się za głowę", type = "anim", data = {lib = "mini@dartsoutro", anim = "darts_outro_01_guy2", car = 0, loop = 56, e = "zaglowe"}},			
		    {label = "Tak", type = "anim", data = {lib = "gestures@f@standing@casual", anim = "gesture_pleased", car = 1, loop = 57, e = "tak"}},
            {label = "Nie", type = "anim", data = {lib = "gestures@f@standing@casual", anim = "gesture_head_no", car = 1, loop = 57, e = "nie"}},
            {label = "Nie 2", type = "anim", data = {lib = "anim@heists@ornate_bank@chat_manager", anim = "fail", car = 1, loop = 57, e = "nie2"}},
	     	{label = "Nie ma mowy", type = "anim", data = {lib = "gestures@f@standing@casual", anim = "gesture_no_way", car = 0, loop = 56, e = "niemamowy"}},
            {label = "Wzruszenie ramionami", type = "anim", data = {lib = "gestures@f@standing@casual", anim = "gesture_shrug_hard", car = 1, loop = 56, e = "wzruszenie"}},
			{label = "Chodź tu", type = "anim", data = {lib = "gestures@f@standing@casual", anim = "gesture_come_here_soft", car = 1, loop = 57, e = "chodz"}},
            {label = "Chodź tu 2", type = "anim", data = {lib = "misscommon@response", anim = "bring_it_on", car = 1, loop = 57, e = "chodz2"}},
            {label = "Chodź tu 3", type = "anim", data = {lib = "mini@triathlon", anim = "want_some_of_this", car = 1, loop = 57, e = "chodz3"}},
            {label = "Co?", type = "anim", data = {lib = "gestures@f@standing@casual", anim = "gesture_what_hard", car = 1, loop = 56, e = "co"}},
            {label = "Szlag!", type = "anim", data = {lib = "gestures@f@standing@casual", anim = "gesture_damn", car = 1, loop = 56, e = "szlag"}},
			{label = "Cicho!", type = "anim", data = {lib = "anim@mp_player_intuppershush", anim = "idle_a_fp", car = 1, loop = 58, e = "cicho"}},	           
		    {label = "Halo!", type = "anim", data = {lib = "friends@frj@ig_1", anim = "wave_d", car = 0, loop = 56, e = "halo"}},
		    {label = "Tu jestem!", type = "anim", data = {lib = "friends@frj@ig_1", anim = "wave_c", car = 0, loop = 56, e = "tujestem"}},
			{label = "To nie ja", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "taunt_b_player_a", car = 0, loop = 0, e = "tonieja"}},		
            {label = "Przepraszam", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "wow_a_player_b", car = 0, loop = 0, e = "przepraszam"}},		  
            {label = "Kciuki w górę", type = "anim", data = {lib = "anim@mp_player_intincarthumbs_upbodhi@ps@", anim = "enter", car = 1, loop = 58, e = "kciuk"}},
            {label = "Kciuk w górę", type = "anim", data = {lib = "anim@mp_player_intincarthumbs_uplow@ds@", anim = "idle_a", car = 1, loop = 58, e = "kciuk2"}},
			{label = "Kciuk w dół", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "thumbs_down_a_player_b", car = 0, loop = 0, e = "kciuk3"}},
            {label = "Kciuk jednak w dół", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "thumbs_down_a_player_a", car = 0, loop = 0, e = "kciuk4"}},			   
            {label = "Uspokój się", type = "anim", data = {lib = "gestures@f@standing@casual", anim = "gesture_easy_now", car = 0, loop = 56, e = "spokojnie"}},   
            {label = "Brawa 1", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "angry_clap_a_player_a", car = 0, loop = 0, e = "brawa"}},
            {label = "Brawa 2", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "angry_clap_b_player_a", car = 0, loop = 0, e = "brawa2"}},
            {label = "Brawa 3", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "angry_clap_b_player_b", car = 0, loop = 0, e = "brawa3"}},
            {label = "Cieszynka", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "jump_a_player_a", car = 0, loop = 50, e = "cieszynka"}},
			{label = "Zwycięzca 1", type = "anim", data = {lib = "anim@arena@celeb@podium@no_prop@", anim = "dance_b_1st", car = 0, loop = 50, e = "zwyciezca"}},
            {label = "Zwycięzca 2", type = "anim", data = {lib = "anim@arena@celeb@podium@no_prop@", anim = "make_noise_a_1st", car = 0, loop = 50, e = "zwyciezca2"}},
            {label = "Głowa w dół", type = "anim", data = {lib = "mp_sleep", anim = "sleep_intro", car = 0, loop = 58, e = "glowadol"}},
            {label = "Znudzenie", type = "anim", data = {lib = "friends@fra@ig_1", anim = "base_idle", car = 0, loop = 56, e = "znudzenie"}},
            {label = "Ukłon", type = "anim", data = {lib = "anim@arena@celeb@podium@no_prop@", anim = "regal_c_1st", car = 0, loop = 51, e = "uklon"}},
            {label = "Ukłon 2", type = "anim", data = {lib = "anim@arena@celeb@podium@no_prop@", anim = "regal_a_1st", car = 0, loop = 51, e = "uklon2"}},
            {label = "Zmęczony", type = "anim", data = {lib = "re@construction", anim = "out_of_breath", car = 0, loop = 1, e = "zmeczony"}},
            {label = "Kaszel", type = "anim", data = {lib = "timetable@gardener@smoking_joint", anim = "idle_cough", car = 0, loop = 51, e = "kaszel"}},
            {label = "Śmianie się", type = "anim", data = {lib = "anim@arena@celeb@flat@paired@no_props@", anim = "laugh_a_player_b", car = 0, loop = 1, e = "smianiesie"}}, 
            {label = "Śmianie się 2", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "giggle_a_player_b", car = 0, loop = 1, e = "smianiesie2"}},
            {label = "Przestraszony", type = "anim", data = {lib = "random@domestic", anim = "f_distressed_loop", car = 0, loop = 1, e = "przestraszony"}},        
        }
    },
	
	{
        name = 'Postawa',
        label = 'Zachowanie - Pozy',
        items = {
            {label = "Ochroniarz 1", type = "scenario", data = {anim = "WORLD_HUMAN_GUARD_STAND", car = 0, loop = 0, e = "ochroniarz"}},
            {label = "Ochroniarz 2", type = "anim2", data = {lib = "amb@world_human_stand_guard@male@base", anim = "base", car = 0, loop = 51, e = "ochroniarz2"}},
			{label = "Ochroniarz 3", type = "animochroniarz", data = {lib = "mini@strip_club@idles@bouncer@stop", anim = "stop", car = 0, loop = 56, e = "ochroniarz3"}},
		    {label = "Policjant 1", type = "scenario", data = {anim = "WORLD_HUMAN_COP_IDLES", car = 0, loop = 1, e = "policjant"}},
			{label = "Policjant 2", type = "anim", data = {lib = "amb@world_human_cop_idles@male@base", anim = "base", car = 0, loop = 51, e = "policjant2"}},
            {label = "Policjant 3", type = "anim", data = {lib = "amb@world_human_cop_idles@female@base", anim = "base", car = 0, loop = 51, e = "policjant3"}},
            {label = "Wypadek 1 - lewy bok", type = "anim", data = {lib = "missheist_jewel", anim = "gassed_npc_customer4", car = 0, loop = 1, e = "wypadek"}},
            {label = "Wypadek 2 - prawy bok", type = "anim", data = {lib = "missheist_jewel", anim = "gassed_npc_guard", car = 0, loop = 1, e = "wypadek2"}},
            {label = "Ręce do tyłu", type = "anim", data = {lib = "anim@miss@low@fin@vagos@", anim = "idle_ped06", car = 0, loop = 49, e = "receztylu"}},
			{label = "Założone ręce 1", type = "anim", data = {lib = "mini@hookers_sp", anim = "idle_reject_loop_c", car = 1, loop = 57, e = "rece"}},
			{label = "Założone ręce 2", type = "anim", data = {lib = "anim@amb@nightclub@peds@", anim = "rcmme_amanda1_stand_loop_cop", car = 1, loop = 51, e = "rece2"}},
            {label = "Założone ręce 3", type = "anim", data = {lib = "amb@world_human_hang_out_street@female_arms_crossed@base", anim = "base", car = 1, loop =51, e = "rece3"}},
            {label = "Założone ręce 4", type = "anim", data = {lib = "anim@heists@heist_corona@single_team", anim = "single_team_loop_boss", car = 1, loop = 51, e = "rece4"}},
            {label = "Założone ręce 5", type = "anim", data = {lib = "random@street_race", anim = "_car_b_lookout", car = 1, loop =51, e = "rece5"}},
            {label = "Założone ręce 6", type = "anim", data = {lib = "rcmnigel1a_band_groupies", anim = "base_m2", car = 1, loop = 51, e = "rece6"}},
            {label = "Ręce na biodrach", type = "anim", data = {lib = "random@shop_tattoo", anim = "_idle", car = 0, loop = 50, e = "biodra"}},
            {label = "Ręce na biodrach 2", type = "anim", data = {lib = "anim@arena@celeb@podium@no_prop@", anim = "regal_c_3rd", car = 0, loop = 50, e = "biodra2"}},
            {label = "Ręka na biodrze", type = "anim", data = {lib = "anim@arena@celeb@podium@no_prop@", anim = "shrug_off_a_1st", car = 0, loop = 50, e = "biodra3"}},
            {label = "Ręka na biodrze 2", type = "anim", data = {lib = "rcmnigel1cnmt_1c", anim = "base", car = 0, loop = 51, e = "biodra4"}},
            {label = "Obejmowanie", type = "anim", data = {lib = "anim@arena@celeb@flat@paired@no_props@", anim = "this_guy_b_player_a", car = 0, loop = 50, e = "obejmowanie"}},
            {label = "Obejmowanie 2", type = "anim", data = {lib = "anim@arena@celeb@flat@paired@no_props@", anim = "this_guy_b_player_b", car = 0, loop = 50, e = "obejmowanie2"}},
            {label = "Poddanie się 1 - na kolanach", type = "anim", data = {lib = "random@arrests@busted", anim = "idle_a", car = 0, loop = 1, e = "poddanie"}},
            {label = "Poddanie się 2 ", type = "anim", data = {lib = "anim@move_hostages@male", anim = "male_idle", car = 0, loop = 51, e = "poddanie2"}},
            {label = "Poddanie się 3", type = "anim", data = {lib = "anim@move_hostages@female", anim = "female_idle", car = 0, loop = 51, e = "poddanie3"}},
            {label = "Niecierpliwosc", type = "anim", data = {lib = "rcmme_tracey1", anim = "nervous_loop", car = 0, loop = 51, e = "niecierpliwosc"}},
            {label = "Zastanowienie", type = "anim", data = {lib = "amb@world_human_prostitute@cokehead@base", anim = "base", car = 0, loop = 1, e = "zastanowienie"}},
            {label = "Drążenie butem", type = "anim", data = {lib = "anim@mp_freemode_return@f@idle", anim = "idle_c", car = 0, loop = 1, e = "drazenie"}},
            {label = "Myślenie", type = "anim", data = {lib = "rcmnigel3_idles", anim = "base_nig", car = 0, loop = 51, e = "myslenie"}},
            {label = "Superbohater", type = "anim", data = {lib = "rcmbarry", anim = "base", car = 0, loop = 51, e = "superbohater"}},
            {label = "Znak V", type = "anim", data = {lib = "anim@mp_player_intupperpeace", anim = "idle_a", car = 0, loop = 51, e = "znakv"}},
        }
    },

    {
        name = 'siedzenie',
        label = 'Zachowanie - Siadanie / Leżenie / Opieranie',
        items = {
            {label = "Siedzienie 1 - na krześle", type = "scenariosit", data = {anim = "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER", e = "siedzenie"}},	  
            {label = "Siedzienie 2 - na kanapie", type = "anim", data = {lib = "timetable@ron@ig_3_couch", anim = "base", car = 0, loop = 1, e = "siedzenie2"}},		
		    {label = "Siedzienie 3 - na ziemi", type = "anim", data = {lib = "anim@heists@fleeca_bank@ig_7_jetski_owner", anim = "owner_idle", car = 0, loop = 1, e = "siedzenie3"}},
            {label = "Siedzienie 4 - na pikniku", type = "anim", data = {lib = "amb@world_human_picnic@female@base", anim = "base", car = 0, loop = 1, e = "siedzenie4"}},
            {label = "Siedzenie 5", type = "anim", data = {lib = "timetable@jimmy@mics3_ig_15@", anim = "idle_a_jimmy", car = 0, loop = 1, e = "siedzenie5"}},
            {label = "Siedzenie 6 - przecholone", type = "anim", data = {lib = "timetable@amanda@ig_7", anim = "base", car = 0, loop = 1, e = "siedzenie6"}},
            {label = "Siedzenie 7 - przecholone2", type = "anim", data = {lib = "timetable@tracy@ig_14@", anim = "ig_14_base_tracy", car = 0, loop = 1, e = "siedzenie7"}},
            {label = "Siedzenie 8 - noga na noge", type = "anim", data = {lib = "timetable@reunited@ig_10", anim = "base_amanda", car = 0, loop = 1, e = "siedzenie8"}},
            {label = "Siedzenie 9 - załamany", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@lo_alone@", anim = "lowalone_base_laz", car = 0, loop = 1, e = "siedzenie9"}},
            {label = "Siedzenie 10 - na luzie", type = "anim", data = {lib = "timetable@jimmy@mics3_ig_15@", anim = "mics3_15_base_jimmy", car = 0, loop = 1, e = "siedzenie10"}},
            {label = "Siedzenie 11 - na luzie 2", type = "anim", data = {lib = "amb@world_human_stupor@male@idle_a", anim = "idle_a", car = 0, loop = 1, e = "siedzenie11"}},
            {label = "Siedzenie 12 - smutny", type = "anim", data = {lib = "anim@amb@business@bgen@bgen_no_work@", anim = "sit_phone_phoneputdown_sleeping-noworkfemale", car = 0, loop = 1, e = "siedzenie12"}},
            {label = "Siedzenie 13 - przestraszony", type = "anim", data = {lib = "anim@heists@ornate_bank@hostages@hit", anim = "hit_loop_ped_b", car = 0, loop = 1, e = "siedzenie13"}},
            {label = "Siedzenie 14 - przestraszony 2", type = "anim", data = {lib = "anim@heists@ornate_bank@hostages@ped_c@", anim = "flinch_loop", car = 0, loop = 1, e = "siedzenie14"}},
            {label = "Siedzenie 15 - dłoń na dłoni", type = "anim", data = {lib = "timetable@reunited@ig_10", anim = "base_jimmy", car = 0, loop = 1, e = "siedzenie15"}},
            {label = "Leżenie 1 - na brzuchu", type = "scenario", data = {anim = "WORLD_HUMAN_SUNBATHE", car = 0, loop = 1, e = "lezenie"}},
            {label = "Leżenie 2 - na brzuchu 2", type = "anim", data = {lib = "missfbi3_sniping", anim = "prone_dave", car = 0, loop = 1, e = "lezenie2"}},
            {label = "Leżenie 3 - na plecach", type = "scenario", data = {anim = "WORLD_HUMAN_SUNBATHE_BACK", car = 0, loop = 0, e = "lezenie3"}},
            {label = "Leżenie 4 - na kanapie", type = "anim", data = {lib = "timetable@ron@ig_3_couch", anim = "laying", car = 0, loop = 1, e = "lezenie4"}},
            {label = "Leżenie 5 - lewy bok", type = "anim", data = {lib = "amb@world_human_bum_slumped@male@laying_on_left_side@base", anim = "base", car = 0, loop = 1, e = "lezenie5"}},
            {label = "Leżenie 6 - prawy bok", type = "anim", data = {lib = "amb@world_human_bum_slumped@male@laying_on_right_side@base", anim = "base", car = 0, loop = 1, e = "lezenie6"}},
            {label = "Leżenie 6 - prawy bok 2", type = "anim", data = {lib = "switch@trevor@scares_tramp", anim = "trev_scares_tramp_idle_tramp", car = 0, loop = 1, e = "lezenie7"}},
            {label = "Leżenie 7 - patrzenie w góre", type = "anim", data = {lib = "switch@trevor@annoys_sunbathers", anim = "trev_annoys_sunbathers_loop_girl", car = 0, loop = 1, e = "lezenie8"}},
            {label = "Leżenie 8 - patrzenie w góre 2", type = "anim", data = {lib = "switch@trevor@annoys_sunbathers", anim = "trev_annoys_sunbathers_loop_guy", car = 0, loop = 1, e = "lezenie9"}},
            {label = "Opieranie o barierkę 1 - przód", type = "anim", data = {lib = "amb@prop_human_bum_shopping_cart@male@base", anim = "base", car = 0, loop = 1, e = "opieranie"}},
            {label = "Opieranie o barierkę 2 - przód", type = "anim", data = {lib = "missheistdockssetup1ig_12@base", anim = "talk_gantry_idle_base_worker2", car = 0, loop = 1, e = "opieranie2"}},
            {label = "Opieranie o barierkę 3 - przód", type = "anim", data = {lib = "misshair_shop@hair_dressers", anim = "assistant_base", car = 0, loop = 1, e = "opieranie3"}},
			{label = "Opieranie o barierkę 4 - z tyłu", type = "anim", data = {lib = "anim@amb@clubhouse@bar@bartender@", anim = "base_bartender", car = 0, loop = 1, e = "opieranie4"}},
			{label = "Opieranie o stół 1 - przód", type = "anim", data = {lib = "anim@amb@clubhouse@bar@drink@base", anim = "idle_a", car = 0, loop = 1, e = "opieranie5"}},
            {label = "Opieranie o stół 2 - przód", type = "anim", data = {lib = "anim@amb@board_room@diagram_blueprints@", anim = "base_amy_skater_01", car = 1, loop = 1, e = "opieranie6"}},
            {label = "Opieranie o stół 3 - przód", type = "anim", data = {lib = "anim@amb@facility@missle_controlroom@", anim = "idle", car = 0, loop = 1, e = "opieranie7"}},
            {label = "Opieranie ściana 1 - nogi na ziemi", type = "anim", data = {lib = "amb@world_human_leaning@male@wall@back@hands_together@base", anim = "base", car = 0, loop = 1, e = "opieranie8"}},
            {label = "Opieranie ściana 2 - noga w górze", type = "anim", data = {lib = "amb@world_human_leaning@male@wall@back@foot_up@base", anim = "base", car = 0, loop = 1, e = "opieranie9"}},
            {label = "Opieranie ściana 3 - nogi na krzyż", type = "anim", data = {lib = "amb@world_human_leaning@male@wall@back@legs_crossed@base", anim = "base", car = 0, loop = 1, e = "opieranie10"}},
            {label = "Opieranie ściana 4 - nogi na krzyż 2", type = "anim", data = {lib = "amb@world_human_leaning@female@wall@back@holding_elbow@idle_a", anim = "idle_a", car = 0, loop = 1, e = "opieranie11"}},
            {label = "Opieranie ściana 5 - głowa w dół", type = "anim", data = {lib = "anim@amb@business@bgen@bgen_no_work@", anim = "stand_phone_phoneputdown_sleeping_nowork", car = 0, loop = 1, e = "opieranie12"}},
            {label = "Opieranie łokciem 1", type = "anim", data = {lib = "rcmjosh2", anim = "josh_2_intp1_base", car = 0, loop = 1, e = "opieranie13"}},
			{label = "Opieranie łokciem 2", type = "anim", data = {lib = "timetable@mime@01_gc", anim = "idle_a", car = 0, loop = 1, e = "opieranie14"}},
            {label = "Opieranie łokciem 3", type = "anim", data = {lib = "misscarstealfinalecar_5_ig_1", anim = "waitloop_lamar", car = 0, loop = 1, e = "opieranie15"}},
            {label = "Opieranie ręką", type = "anim", data = {lib = "misscarstealfinale", anim = "packer_idle_1_trevor", car = 0, loop = 1, e = "opieranie16"}},
            {label = "Zimny łokieć [Kierowca]", type = "anim", data = {lib = "anim@amb@code_human_in_car_idles@arm@generic@ds@base", anim = "idle", car = 2, loop = 51, e = "zimnylokiec"}},
        }
    },
	
    {
        name = 'Czynności',
        label = 'Zachowanie - czynności',
        items = {
        	{label = "Telefon 1", type = "scenario", data = {anim = "world_human_tourist_mobile", car = 0, loop = 0, e = "telefon"}},
            {label = "Telefon 2", type = "scenario", data = {anim = "WORLD_HUMAN_MOBILE_FILM_SHOCKING", car = 0, loop = 0, e = "telefon2"}},
         	{label = "Telefon 3", type = "animprop12", data = {lib = "cellphone@", anim = "cellphone_text_to_call", car = 0, loop = 58, e = "telefon3"}},
         	{label = "Telefon 4", type = "animprop11", data = {lib = "amb@world_human_stand_mobile@male@text@base", anim = "base", car = 0, loop = 51, e = "telefon4"}},
            {label = "Fotka - wyimaginowany aparat", type = "anim", data = {lib = "anim@mp_player_intincarphotographylow@ds@", anim = "idle_a", car = 1, loop = 1, e = "fotka"}},
            {label = "Dokument z portfela", type = "animprop6", data = {lib = "random@atmrobberygen", anim = "a_atm_mugging", car = 0, loop = 0, e = "dokument"}},
			{label = "Aparat", type = "animprop5", data = {lib = "amb@world_human_paparazzi@male@idle_a", anim = "idle_c", car = 1, loop = 51, e = "aparat"}},
         	{label = "Kawa", type = "animprop15", data = {lib = "amb@world_human_drinking@coffee@male@idle_a", anim = "idle_c", car = 0, loop = 51, e = "kawa"}},
            {label = "Tłumaczenie", type = "anim", data = {lib = "misscarsteal4@actor", anim = "actor_berating_assistant", car = 1, loop = 56, e = "tlumaczenie"}},
            {label = "Przyglądanie się broni", type = "anim", data = {lib = "mp_corona@single_team", anim = "single_team_intro_one", car = 0, loop = 56, e = "bron"}},
            {label = "Zerkanie na zegarek", type = "anim", data = {lib = "oddjobs@taxi@", anim = "idle_a", car = 0, loop = 56, e = "zegarek"}},
            {label = "Czyszczenie 1 - mycie ścierką", type = "scenario", data = {anim = "world_human_maid_clean", car = 0, loop = 0, e = "mycie"}},
			{label = "Czyszczenie 2 - mycie maski auta", type = "anim", data = {lib = "switch@franklin@cleaning_car", anim = "001946_01_gc_fras_v2_ig_5_base", car = 0, loop = 1, e = "mycie2"}},
			{label = "Branie prysznica 1", type = "anim", data = {lib = "mp_safehouseshower@female@", anim = "shower_idle_a", car = 0, loop = 1, e = "prysznic"}},
			{label = "Branie prysznica 2", type = "anim", data = {lib = "mp_safehouseshower@male@", anim = "male_shower_idle_a", car = 0, loop = 1, e = "prysznic2"}},
			{label = "Branie prysznica 3", type = "anim", data = {lib = "mp_safehouseshower@male@", anim = "male_shower_idle_d", car = 0, loop = 1, e = "prysznic3"}},
			{label = "Sięganie do schowka w aucie [Pojazd]", type = "animschowek", data = {lib = "rcmme_amanda1", anim = "drive_mic", car = 2, loop = 56, e = "schowek"}},
		    {label = "Włamywanie do sejfu", type = "anim", data = {lib = "mini@safe_cracking", anim = "dial_turn_anti_normal", car = 0, loop = 0, e = "sejf"}},
            {label = "Przymierzanie ubrań", type = "anim", data = {lib = "mp_clothing@female@trousers", anim = "try_trousers_neutral_a", car = 0, loop = 1, e = "ubrania"}},
            {label = "Przymierzanie góry", type = "anim", data = {lib = "mp_clothing@female@shirt", anim = "try_shirt_positive_a", car = 0, loop = 1, e = "ubrani2"}},
            {label = "Przymierzanie butów", type = "anim", data = {lib = "mp_clothing@female@shoes", anim = "try_shoes_positive_a", car = 0, loop = 1, e = "ubrania3"}},
			{label = "Pakowanie do torby", type = "anim", data = {lib = "anim@heists@ornate_bank@grab_cash", anim = "grab", car = 0, loop = 1, e = "torba"}},
            {label = "Oddawaj pieniądze", type = "anim", data = {lib = "mini@prostitutespimp_demands_money", anim = "pimp_demands_money_pimp", car = 0, loop = 0, e = "oddawaj"}},
            {label = "Samobójstwo", type = "anim", data = {lib = "mp_suicide", anim = "pistol", car = 0, loop = 2, e = "samobojstwo"}},
            {label = "Salutowanie", type = "anim", data = {lib = "mp_player_int_uppersalute", anim = "mp_player_int_salute", car = 0, loop = 51, e = "salut"}},
            {label = "Kłótnia", type = "anim", data = {lib = "sdrm_mcs_2-0", anim = "csb_bride_dual-0", car = 0, loop = 56, e = "klotnia"}},
            {label = "Kucanie", type = "anim", data = {lib = "rcmextreme3", anim = "idle", car = 0, loop = 1, e = "kucanie"}},
            {label = "Kucanie 2", type = "anim", data = {lib = "amb@world_human_bum_wash@male@low@idle_a", anim = "idle_a", car = 0, loop = 1, e = "kucanie2"}},
            {label = "Gwizdanie", type = "anim", data = {lib = "rcmnigel1c", anim = "hailing_whistle_waive_a", car = 0, loop = 51, e = "gwizdanie"}},
            {label = "Celowanie", type = "anim", data = {lib = "random@countryside_gang_fight", anim = "biker_02_stickup_loop", car = 0, loop = 49, e = "celowanie"}},
            {label = "Celowanie 2", type = "anim", data = {lib = "random@atmrobberygen", anim = "b_atm_mugging", car = 0, loop = 49, e = "celowanie2"}},
            {label = "Medytacja", type = "anim", data = {lib = "rcmcollect_paperleadinout@", anim = "meditiate_idle", car = 0, loop = 1, e = "medytacja"}},
            {label = "Medytacja 2", type = "anim", data = {lib = "rcmepsilonism3", anim = "ep_3_rcm_marnie_meditating", car = 0, loop = 1, e = "medytacja2"}},
            {label = "Pukanie", type = "anim", data = {lib = "timetable@jimmy@doorknock@", anim = "knockdoor_idle", car = 0, loop = 51, e = "pukanie"}},
        }	
    },
	
    {
        name = 'Chamskie',
        label = 'Zachowanie - chamskie',
        items = {
			{label = "Mów do ręki", type = "anim", data = {lib = "mini@prostitutestalk", anim = "street_argue_f_a", car = 0, loop = 56, e = "mowdoreki"}},           
		    {label = "Środkowy palec 1", type = "anim", data = {lib = "anim@arena@celeb@podium@no_prop@", anim = "flip_off_a_1st", car = 0, loop = 56, e = "palec"}},
            {label = "Środkowy palec 2 - z kieszeni", type = "anim", data = {lib = "anim@arena@celeb@podium@no_prop@", anim = "flip_off_b_1st", car = 0, loop = 56, e = "palec2"}},
            {label = "Środkowy palec 3", type = "anim", data = {lib = "anim@mp_player_intselfiethe_bird", anim = "idle_a", car = 0, loop = 51, e = "palec3"}},
			{label = "Pokazywanie środkowych palców", type = "anim", data = {lib = "mp_player_int_upperfinger", anim = "mp_player_int_finger_01_enter", car = 0, loop = 58, e = "palec4"}},
			{label = "Sarkastyczne klaskanie 1", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@slow_clap", anim = "slow_clap", car = 0, loop = 56, e = "klaskanie"}},
            {label = "Sarkastyczne klaskanie 2", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@slow_clap", anim = "slow_clap", car = 0, loop = 56, e = "klaskanie2"}},
            {label = "Sarkastyczne klaskanie 3", type = "anim", data = {lib = "anim@mp_player_intupperslow_clap", anim = "idle_a", car = 0, loop = 57, e = "klaskanie3"}},
			{label = "Sarkastyczne klaskanie 4", type = "anim", data = {lib = "anim@arena@celeb@podium@no_prop@", anim = "regal_b_3rd", car = 0, loop = 0, e = "klaskanie4"}},          
		    {label = "Drapanie sie po kroczu", type = "anim", data = {lib = "mp_player_int_uppergrab_crotch", anim = "mp_player_int_grab_crotch", car = 0, loop = 57, e = "drapaniepokroczu"}},
            {label = "Dłubanie w nosie - strzał gilem", type = "anim", data = {lib = "anim@mp_player_intuppernose_pick", anim = "exit", car = 0, loop = 56, e = "dlubanie"}},
            {label = "Dłubanie w nosie 2 - oscentacyjne", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@nose_pick", anim = "nose_pick", car = 0, loop = 0, e = "dlubanie2"}},
            {label = "Ten z tyłu śmierdzi", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "taunt_c_player_b", car = 0, loop = 0, e = "smierdzi"}},
		    {label = "No dawaj!", type = "anim", data = {lib = "gestures@f@standing@casual", anim = "gesture_bring_it_on", car = 0, loop = 56, e = "dawaj"}},
			{label = "Gotowość na bójkę", type = "anim", data = {lib = "anim@mp_player_intupperknuckle_crunch", anim = "idle_a", car = 1, loop = 56, e = "bojka"}},
            {label = "Gotowość na bójkę 2", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@knuckle_crunch", anim = "knuckle_crunch", car = 1, loop = 56, e = "bojka2"}},
            {label = "Gotowość na bójkę 3", type = "anim", data = {lib = "anim@deathmatch_intros@unarmed", anim = "intro_male_unarmed_c", car = 1, loop = 1, e = "bojka3"}},           
            {label = "Gotowość na bójkę 4", type = "anim", data = {lib = "anim@deathmatch_intros@unarmed", anim = "intro_male_unarmed_e", car = 0, loop = 1, e = "bojka4"}},           
            {label = "Spoliczkowanie", type = "anim", data = {lib = "anim@arena@celeb@podium@no_prop@", anim = "air_slap_a_1st", car = 0, loop = 56, e = "policzek"}},
        }
    },
	
    {
        name = 'Sportowe',
        label = 'Interakcje - Sporty',
        items = {
            {label = "Jogging", type = "anim", data = {lib = "move_m@jogger", anim = "run", car = 0, loop = 33, e = "jogging"}},
            {label = "Jogging 2", type = "scenario", data = {anim = "WORLD_HUMAN_JOG_STANDING", car = 0, loop = 0, e = "jogging2"}},
            {label = "Trucht", type = "anim", data = {lib = "move_m@jog@", anim = "run", car = 0, loop = 33, e = "trucht"}},
            {label = "Powerwalk", type = "anim", data = {lib = "amb@world_human_power_walker@female@base", anim = "base", car = 0, loop = 33, e = "powerwalk"}},
            {label = "Napinanie mięśni", type = "anim", data = {lib = "amb@world_human_muscle_flex@arms_at_side@base", anim = "base", car = 0, loop = 1, e = "napinanie"}},
            {label = "Pompki", type = "anim", data = {lib = "amb@world_human_push_ups@male@base", anim = "base", car = 0, loop = 1, e = "pompki"}},
            {label = "Brzuszki", type = "animangle", data = {lib = "amb@world_human_sit_ups@male@base", anim = "base", car = 0, loop = 1, e = "brzuszki"}},
            {label = "Salto w tył", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "flip_a_player_a", car = 0, loop = 0, e = "salto"}},
            {label = "Capoeira", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "cap_a_player_a", car = 0, loop = 0, e = "capoeira"}},
            {label = "Yoga 1 - przygotowanie", type = "anim", data = {lib = "amb@world_human_yoga@male@base", anim = "base", car = 0, loop = 1, e = "yoga"}},
            {label = "Yoga 2 - rozciąganie się", type = "anim", data = {lib = "amb@world_human_yoga@female@base", anim = "base_b", car = 0, loop = 1, e = "yoga2"}},
            {label = "Yoga 3 - stanie na rękach", type = "anim", data = {lib = "amb@world_human_yoga@female@base", anim = "base_c", car = 0, loop = 1, e = "yoga3"}},
            {label = "Wślizg na kolanach", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "slide_a_player_a", car = 0, loop = 0, e = "wslizg"}},
            {label = "Skok przez kozła", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "jump_b_player_a", car = 0, loop = 0, e = "skok"}},
            {label = "Szpagat", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "jump_c_player_a", car = 0, loop = 0, e = "szpagat"}},
            {label = "Podskok", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "jump_d_player_a", car = 0, loop = 0, e = "podskok"}},
            {label = "Pajacyki", type = "anim", data = {lib = "timetable@reunited@ig_2", anim = "jimmy_masterbation", car = 0, loop = 1, e = "pajacyki"}},
            {label = "Rozciąganie się", type = "anim", data = {lib = "mini@triathlon", anim = "idle_e", car = 0, loop = 1, e = "rozciaganie"}},
            {label = "Rozciąganie się 2", type = "anim", data = {lib = "mini@triathlon", anim = "idle_f", car = 0, loop = 1, e = "rozciaganie2"}},
            {label = "Rozciąganie się 3", type = "anim", data = {lib = "mini@triathlon", anim = "idle_d", car = 0, loop = 1, e = "rozciaganie3"}},
            {label = "Rozciąganie się 4", type = "anim", data = {lib = "rcmfanatic1maryann_stretchidle_b", anim = "idle_e", car = 0, loop = 1, e = "rozciaganie4"}}, 
            {label = "Boks", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@shadow_boxing", anim = "shadow_boxing", car = 0, loop = 51, e = "boks"}},
            {label = "Boks 2", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@shadow_boxing", anim = "shadow_boxing", car = 0, loop = 51, e = "boks2"}},
            {label = "Karate", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@karate_chops", anim = "karate_chops", car = 0, loop = 1, e = "karate"}},
            {label = "Karate 2", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@karate_chops", anim = "karate_chops", car = 0, loop = 1, e = "karate2"}},      
        }
    },

    {
        name = 'Czynności Pracy',
        label = 'Interakcje - Praca',
        items = {
            {label = "Mechanik 1 - maska", type = "anim", data = {lib = "mini@repair", anim = "fixing_a_ped", car = 0, loop = 1, e = "mechanik"}},
            {label = "Mechanik 2 - maska", type = "anim", data = {lib = "mini@repair", anim = "fixing_a_player", car = 0, loop = 1, e = "mechanik2"}},
            {label = "Mechanik 3 - pod autem", type = "animangle", data = {lib = "amb@world_human_vehicle_mechanic@male@base", anim = "base", car = 0, loop = 1, e = "mechanik3"}},
            {label = "Mechanik 4 - wyjście spod auta", type = "anim", data = {lib = "amb@world_human_vehicle_mechanic@male@exit", anim = "exit", car = 0, loop = 0, e = "mechanik4"}},
		    {label = "Uderzanie młotkiem", type = "scenario", data = {anim = "WORLD_HUMAN_HAMMERING", car = 0, loop = 0, e = "mlotek"}},
			{label = "Spawanie", type = "scenario", data = {anim = "WORLD_HUMAN_WELDING", car = 0, loop = 1, e = "spawanie"}},
            {label = "Pisanie na komputerze", type = "anim", data = {lib = "anim@heists@prison_heistig1_p1_guard_checks_bus", anim = "loop", car = 0, loop = 1, e = "komputer"}},
            {label = "Ładowanie towaru", type = "anim", data = {lib = "mp_am_hold_up", anim = "purchase_beerbox_shopkeeper", car = 0, loop = 0, e = "towar"}},
            {label = "Kopanie w ziemi 1", type = "animprop3", data = {lib = "random@burial", car = 0, e = "kopanie"}},
			{label = "Kopanie w ziemi 2 - klękanie", type = "scenario", data = {anim = "world_human_gardener_plant", car = 0, loop = 0, e = "kopanie2"}},
			{label = "Patrzenie w notatki", type = "animprop8", data = {lib = "amb@world_human_clipboard@male@idle_a", anim = "idle_c", car = 0, loop = 51, e = "notatki"}},
        }
    },

    {
        name = 'Służbowe',
        label = 'Interakcje - Rany / Medyczne',
        items = {
            {label = "Sprawdzanie stanu 1 - klękanie", type = "scenario", data = {anim = "CODE_HUMAN_MEDIC_KNEEL", car = 0, loop = 0, e = "stan"}},
            {label = "Sprawdzanie stanu 2 - uciskanie", type = "anim", data = {lib = "anim@heists@narcotics@funding@gang_idle", anim = "gang_chatting_idle01", car = 0, loop = 1, e = "stan2"}},	
            {label = "Łykanie tabletki", type = "animtabletka", data = {lib = "mp_suicide", anim = "pill", car = 1, loop = 56, e = "tabletka"}},			
		    {label = "Ból w klatce piersiowej", type = "animangle", data = {lib = "anim@heists@prison_heistig_5_p1_rashkovsky_idle", anim = "idle", car = 0, loop = 1, e = "klatka"}},
            {label = "Ból nogi", type = "anim", data = {lib = "missfbi5ig_0", anim = "lyinginpain_loop_steve", car = 0, loop = 1, e = "noga"}},
            {label = "Ból brzucha", type = "anim", data = {lib = "combat@damage@writheidle_a", anim = "writhe_idle_a", car = 0, loop = 1, e = "brzuch"}},
            {label = "Ból głowy", type = "anim", data = {lib = "combat@damage@writheidle_b", anim = "writhe_idle_f", car = 0, loop = 1, e = "glowa"}},
            {label = "Ból głowy 2", type = "anim", data = {lib = "misscarsteal4@actor", anim = "dazed_idle", car = 0, loop = 51, e = "glowa2"}},
            {label = "Drgawki", type = "anim", data = {lib = "missheistfbi3b_ig8_2", anim = "cpr_loop_victim", car = 0, loop = 1, e = "drgawki"}},
         	{label = "Omdlenie 1 - prawy bok", type = "anim", data = {lib = "dam_ko@shot", anim = "ko_shot_head", car = 0, loop = 2, e = "omdlenie"}},
            {label = "Omdlenie 2 - na plecy", type = "anim", data = {lib = "anim@gangops@hostage@", anim = "perp_success", car = 0, loop = 2, e = "omdlenie2"}},
            {label = "Omdlenie 3 - leżąc", type = "anim", data = {lib = "mini@cpr@char_b@cpr_def", anim = "cpr_intro", car = 0, loop = 2, e = "omdlenie3"}},
			{label = "Ocknięcie 1 - ponowne omdlenie", type = "anim", data = {lib = "missfam5_blackout", anim = "pass_out", car = 0, loop = 2, e = "ockniecie"}},
			{label = "Ocknięcie 2 - wymiotowanie", type = "animockniecie", data = {lib = "missfam5_blackout", anim = "vomit", car = 0, loop = 0, e = "ockniecie2"}},
			{label = "Ocknięcie 3 - szybko", type = "anim", data = {lib = "safe@trevor@ig_8", anim = "ig_8_wake_up_front_player", car = 0, loop = 0, e = "ockniecie3"}},
			{label = "Ocknięcie 4 - powoli", type = "anim", data = {lib = "safe@trevor@ig_8", anim = "ig_8_wake_up_right_player", car = 0, loop = 0, e = "ockniecie4"}},
            {label = "Brak przytomności 1", type = "anim", data = {lib = "mini@cpr@char_b@cpr_def", anim = "cpr_pumpchest_idle", car = 0, loop = 1, e = "nieprzytomnosc"}},
			{label = "Brak przytomności 2", type = "anim", data = {lib = "missprologueig_6", anim = "lying_dead_brad", car = 0, loop = 1, e = "nieprzytomnosc2"}},
            {label = "Brak przytomności 3", type = "anim", data = {lib = "missprologueig_6", anim = "lying_dead_player0", car = 0, loop = 1, e = "nieprzytomnosc3"}},
			{label = "Brak przytomności 4 - na brzuchu", type = "animangle2", data = {lib = "missarmenian2", anim = "drunk_loop", car = 0, loop = 1, e = "nieprzytomnosc4"}},
            {label = "RKO 1 - uciskanie", type = "anim", data = {lib = "mini@cpr@char_a@cpr_str", anim = "cpr_pumpchest", car = 0, loop = 1, e = "rko"}},
            {label = "RKO 2 - wdechy", type = "anim", data = {lib = "mini@cpr@char_a@cpr_str", anim = "cpr_kol", car = 0, loop = 1, e = "rko2"}},
            {label = "Wzywanie SOS - rękoma", type = "anim", data = {lib = "random@gang_intimidation@", anim = "001445_01_gangintimidation_1_female_wave_loop", car = 0, loop = 51, e = "sos"}},
            {label = "Sprawdzanie dowodów", type = "anim", data = {lib = "amb@code_human_police_investigate@idle_b", anim = "idle_f", car = 0, loop = 0, e = "dowody"}},
            {label = "Sprawdzanie dowodów 2", type = "anim", data = {lib = "random@train_tracks", anim = "idle_e", car = 0, loop = 0, e = "dowody2"}},
			{label = "Kierowanie ruchem", type = "animprop", data = {lib = "amb@world_human_car_park_attendant@male@base", anim = "base", car = 0, loop = 1, e = "kierowanie"}},
			{label = "Notes", type = "animprop2", data = {lib = "amb@medic@standing@timeofdeath@base", anim = "base", car = 1, loop = 51, e = "notes"}},
        }
    },

    {
        name = 'Tańce',
        label = 'Tańce - Imprezowe',
        items = {
            {label = "Twerk", type = "anim", data = {lib = "switch@trevor@mocks_lapdance", anim = "001443_01_trvs_28_idle_stripper", car = 0, loop = 1, e = "twerk"}},   
            {label = "Taniec 1", type = "anim", data = {lib = "misschinese2_crystalmazemcs1_cs", anim = "dance_loop_tao", car = 0, loop = 1, e = "taniec"}},           
            {label = "Taniec 2", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_female^1", car = 0, loop = 1, e = "taniec2"}},
            {label = "Taniec 3", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_female^3", car = 0, loop = 1, e = "taniec3"}},
            {label = "Taniec 4", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v1_female^6", car = 0, loop = 1, e = "taniec4"}},
            {label = "Taniec 5", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@med_intensity", anim = "mi_dance_facedj_09_v1_female^1", car = 0, loop = 1, e = "taniec5"}},
            {label = "Taniec 6", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity", anim = "hi_dance_crowd_09_v1_female^1", car = 0, loop = 1, e = "taniec6"}},
            {label = "Taniec 7", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@hi_podium@", anim = "danceidle_hi_11_turnaround_laz", car = 0, loop = 1, e = "taniec7"}},
            {label = "Taniec 8", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@hi_podium@", anim = "danceidle_hi_17_smackthat_laz", car = 0, loop = 1, e = "taniec8"}},
            {label = "Taniec 9", type = "anim", data = {lib = "special_ped@mountain_dancer@monologue_3@monologue_3a", anim = "mnt_dnc_buttwag", car = 0, loop = 1, e = "taniec9"}},
            {label = "Taniec 10", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@hi_podium@", anim = "danceidle_hi_06_base_laz",car = 0, loop = 1, e = "taniec10"}},
            {label = "Taniec 11", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@uncle_disco", anim = "uncle_disco", car = 0, loop = 1, e = "taniec11"}},
            {label = "Taniec 12", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_groups_transitions@", anim = "trans_dance_crowd_hi_to_mi_09_v1_female^1", car = 0, loop = 1, e = "taniec12"}},
            {label = "Taniec 13", type = "anim", data = {lib = "rcmnigel1bnmt_1b", anim = "dance_loop_tyler", car = 0, loop = 1, e = "taniec13"}},
            {label = "Taniec 14", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", anim = "low_center", car = 0, loop = 1, e = "taniec14"}},
            {label = "Taniec 15", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@hi_podium@", anim = "danceidle_mi_15_robot_laz",  car = 0, loop = 1, e = "taniec15"}},
            {label = "Taniec 16", type = "anim", data = {lib = "anim@amb@nightclub@dancers@solomun_entourage@", anim = "mi_dance_facedj_17_v1_female^1",  car = 0, loop = 1, e = "taniec16"}},
            {label = "Taniec 17", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", anim = "high_center_up",  car = 0, loop = 1, e = "taniec17"}},
            {label = "Taniec 18", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", anim = "low_center",  car = 0, loop = 1, e = "taniec18"}},
            {label = "Taniec 19", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", anim = "med_center_up",  car = 0, loop = 1, e = "taniec19"}},
            {label = "Taniec 20", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v2_female^1",  car = 0, loop = 1, e = "taniec20"}},
            {label = "Taniec 21", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity", anim = "hi_dance_facedj_09_v2_female^3",  car = 0, loop = 1, e = "taniec21"}},
            {label = "Taniec 22", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_female^3",  car = 0, loop = 1, e = "taniec22"}},
            {label = "Taniec 23", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_groups_transitions@", anim = "trans_dance_crowd_hi_to_li_09_v1_female^3",  car = 0, loop = 1, e = "taniec23"}},
            {label = "Taniec 24", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@thumb_on_ears", anim = "thumb_on_ears",  car = 0, loop = 1, e = "taniec24"}},
            {label = "Taniec 25", type = "anim", data = {lib = "special_ped@mountain_dancer@monologue_2@monologue_2a", anim = "mnt_dnc_angel",  car = 0, loop = 1, e = "taniec25"}},
            {label = "Taniec 26", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", anim = "high_center",  car = 0, loop = 1, e = "taniec26"}},
            {label = "Taniec 27", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", anim = "high_center_up",  car = 0, loop = 1, e = "taniec27"}},
            {label = "Taniec 28", type = "anim", data = {lib = "anim@amb@casino@mini@dance@dance_solo@female@var_b@", anim = "high_center",  car = 0, loop = 1, e = "taniec28"}},
            {label = "Taniec 29", type = "anim", data = {lib = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@", anim = "low_center_down",  car = 0, loop = 1, e = "taniec29"}},
            {label = "Taniec 30", type = "anim", data = {lib = "timetable@tracy@ig_8@idle_b", anim = "idle_d",  car = 0, loop = 1, e = "taniec30"}},
            {label = "Taniec 31", type = "anim", data = {lib = "timetable@tracy@ig_5@idle_a", anim = "idle_a",  car = 0, loop = 1, e = "taniec31"}},
            {label = "Taniec 32", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@hi_podium@", anim = "danceidle_hi_11_buttwiggle_b_laz",  car = 0, loop = 1, e = "taniec32"}},
            {label = "Taniec 33", type = "anim", data = {lib = "move_clown@p_m_two_idles@", anim = "fidget_short_dance",  car = 0, loop = 1, e = "taniec33"}},
            {label = "Klubowy 1 (Dla kobiet)", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_female^1",  car = 0, loop = 1, e = "klubowy1"}},
            {label = "Klubowy 2 (Dla mężczyzn)", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_male^2",  car = 0, loop = 1, e = "klubowy2"}},
            {label = "Klubowy 3 (Dla kobiet)", type = "anim", data = {lib = "anim@amb@nightclub@dancers@crowddance_facedj_transitions@from_med_intensity", anim = "trans_dance_facedj_mi_to_hi_08_v1_female^3",  car = 0, loop = 1, e = "klubowy3"}},
            {label = "Klubowy 4", type = "anim", data = {lib = "anim@amb@nightclub@lazlow@hi_podium@", anim = "danceidle_mi_17_crotchgrab_laz",  car = 0, loop = 1, e = "klubowy4"}},
            {label = "Taniec z Patykami", type = "animprop38", data = {lib = "anim@amb@nightclub@lazlow@hi_railing@", anim = "ambclub_13_mi_hi_sexualgriding_laz",  car = 0, loop = 1, e = "taniecpatyki"}},
            {label = "T-Pose", type = "anim", data = {lib = "custom@suspect", anim = "suspect", car = 0, loop = 1, e = "tpose"}},
			{label = "Dab", type = "anim", data = {lib = "custom@dab", anim = "dab", car = 0, loop = 1, e = "dab"}},
			{label = "Że co", type = "anim", data = {lib = "custom@what_idk", anim = "what_idk", car = 0, loop = 1, e = "zeco"}},
			{label = "Salsa", type = "anim", data = {lib = "custom@salsa", anim = "salsa", car = 0, loop = 1, e = "salsa"}},
			{label = "Z Ziemi", type = "anim", data = {lib = "custom@pickfromground", anim = "pickfromground", car = 0, loop = 1, e = "zziemi"}},
			{label = "Maraschino", type = "anim", data = {lib = "custom@maraschino", anim = "maraschino", car = 0, loop = 1, e = "maraschino"}},
			{label = "Makarena", type = "anim", data = {lib = "custom@makarena", anim = "makarena", car = 0, loop = 1, e = "makarena"}},
			{label = "Gangnam Style", type = "anim", data = {lib = "custom@gangnamstyle", anim = "gangnamstyle", car = 0, loop = 1, e = "gangamstyle"}},
			{label = "Dig", type = "anim", data = {lib = "custom@dig", anim = "dig", car = 0, loop = 1, e = "dig"}},
			{label = "Crunch", type = "anim", data = {lib = "custom@circle_crunch", anim = "circle_crunch", car = 0, loop = 1, e = "crunch"}},
			{label = "Arm Wave", type = "anim", data = {lib = "custom@armwave", anim = "armwave", car = 0, loop = 1, e = "wave"}},
			{label = "Arm Swirl", type = "anim", data = {lib = "custom@armswirl", anim = "armswirl", car = 0, loop = 1, e = "swirl"}},
			{label = "Sheesh", type = "anim", data = {lib = "custom@sheeeeesh", anim = "sheeeeesh", car = 0, loop = 1, e = "sheesh"}},
			{label = "Billy Bounce", type = "anim", data = {lib = "custom@billybounce", anim = "billybounce", car = 0, loop = 1, e = "billybounce"}},
			{label = "Donward", type = "anim", data = {lib = "custom@downward_fortnite", anim = "downward_fortnite", car = 0, loop = 1, e = "donward"}},
			{label = "Pullup", type = "anim", data = {lib = "custom@pullup", anim = "pullup", car = 0, loop = 1, e = "pullup"}},
			{label = "Rollie", type = "anim", data = {lib = "custom@rollie", anim = "rollie", car = 0, loop = 1, e = "rollie"}},
			{label = "Wanna See Me?", type = "anim", data = {lib = "custom@wanna_see_me", anim = "wanna_see_me", car = 0, loop = 1, e = "wannaseeme"}},
        }

    }, 

    {
        name = 'Imprezowe',
        label = 'Zachowanie - Imprezowe',
        items = {
            {label = "DJ", type = "anim", data = {lib = "mini@strip_club@idles@dj@idle_02", anim = "idle_02", car = 0, loop = 1, e = "dj"}},
			{label = "Oglądanie występu", type = "anim", data = {lib = "amb@world_human_strip_watch_stand@male_a@base", anim = "base", car = 0, loop = 1, e = "ogladanie"}},
            {label = "Gest 1: Ręce w górze", type = "anim", data = {lib = "mp_player_int_uppergang_sign_a", anim = "mp_player_int_gang_sign_a", car = 1, loop = 57, e = "gest"}},
            {label = "Gest 2: Znak V", type = "anim", data = {lib = "mp_player_int_upperv_sign", anim = "mp_player_int_v_sign", car = 1, loop = 57, e = "gest2"}},     
			{label = "Bycie pijanym", type = "anim", data = {lib = "amb@world_human_bum_standing@drunk@idle_a", anim = "idle_a", car = 0, loop = 1, e = "pijany"}},
		    {label = "Udawanie gry na gitarze", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@air_guitar", anim = "air_guitar", car = 0, loop = 0, e = "udawaniegry"}},
			{label = "Rock'n roll 1", type = "anim", data = {lib = "mp_player_int_upperrock", anim = "mp_player_int_rock_enter", car = 0, loop = 56, e = "rock"}},
            {label = "Rock'n roll 2", type = "anim", data = {lib = "mp_player_introck", anim = "mp_player_int_rock", car = 0, loop = 56, e = "rock2"}},           
		    {label = "Rzucanie hajsem", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@props@", anim = "make_it_rain_b_player_b", car = 0, loop = 0, e = "hajs"}},
            {label = "Śmiech", type = "anim", data = {lib = "anim@arena@celeb@flat@solo@no_props@", anim = "taunt_e_player_b", car = 0, loop = 0, e = "smiech"}},
			{label = "Pozowanie - manekin", type = "scenario", data = {anim = "WORLD_HUMAN_HUMAN_STATUE", car = 0, loop = 1, e = "manekin"}},
            {label = "Wymiotowanie w aucie", type = "anim", data = {lib = "oddjobs@taxi@tie", anim = "vomit_outside", car = 2, loop = 0, e = "wymioty"}},
            {label = "Udawanie ptaka", type = "anim", data = {lib = "random@peyote@bird", anim = "wakeup", car = 0, loop = 51, e = "ptak"}},
            {label = "Udawanie kurczaka", type = "anim", data = {lib = "random@peyote@chicken", anim = "wakeup", car = 0, loop = 51, e = "kurczak"}},
            {label = "Udawanie królika", type = "anim", data = {lib = "random@peyote@rabbit", anim = "wakeup", car = 0, loop = 1, e = "krolik"}},
            {label = "Udawanie klauna 1", type = "anim", data = {lib = "rcm_barry2", anim = "clown_idle_0", car = 0, loop = 1, e = "klaun"}},           
		    {label = "Udawanie klauna 2", type = "anim", data = {lib = "rcm_barry2", anim = "clown_idle_1", car = 0, loop = 1, e = "klaun2"}},
            {label = "Udawanie klauna 3", type = "anim", data = {lib = "rcm_barry2", anim = "clown_idle_2", car = 0, loop = 1, e = "klaun3"}},
			{label = "Udawanie klauna 4", type = "anim", data = {lib = "rcm_barry2", anim = "clown_idle_3", car = 0, loop = 1, e = "klaun4"}},
            {label = "Udawanie klauna 5", type = "anim", data = {lib = "rcm_barry2", anim = "clown_idle_6", car = 0, loop = 1, e = "klaun5"}},
        }
    },

    {
        name = 'Miłosne',
        label = 'Zachowanie - Miłosne',
        items = {
            {label = "Przytul 1", type = "anim", data = {lib = "mp_ped_interaction", anim = "kisses_guy_a", car = 0, loop = 0, e = "przytul"}},
            {label = "Przytul 2", type = "anim", data = {lib = "mp_ped_interaction", anim = "kisses_guy_b", car = 0, loop = 0, e = "przytul2"}},        	
            {label = "Całus 1", type = "anim", data = {lib = "anim@mp_player_intselfieblow_kiss", anim = "exit", car = 1, loop = 56, e = "calus"}},
            {label = "Całus 2", type = "anim", data = {lib = "mini@hookers_sp", anim = "idle_a", car = 0, loop = 0, e = "calus2"}},
            {label = "Całus 3", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@blow_kiss", anim = "blow_kiss", car = 0, loop = 56, e = "calus3"}},
            {label = "Uroczo", type = "anim", data = {lib = "mini@hookers_spcokehead", anim = "idle_reject_loop_a", car = 1, loop = 58, e = "uroczo"}},
			{label = "Zawstydzenie", type = "anim", data = {lib = "anim@arena@celeb@podium@no_prop@", anim = "regal_a_3rd", car = 0, loop = 0, e = "Zawstydzenie"}},          
		    {label = "Uwodzenie", type = "anim", data = {lib = "mini@strip_club@idles@stripper", anim = "stripper_idle_02", car = 0, loop = 1, e = "uwodzenie"}},
        }
    },

    {
        name = 'Przedmioty',
        label = 'Interakcje - Obiekty',
        items = {
            {label = "Miś", type = "animprop16", data = {lib = "impexp_int-0", anim = "mp_m_waremech_01_dual-0", car = 0, loop = 57, e = "mis"}},
            {label = "Bukiet", type = "animprop33", data = {lib = "impexp_int-0", anim = "mp_m_waremech_01_dual-0", car = 0, loop = 57, e = "bukiet"}},
            {label = "Gitara", type = "animprop34", data = {lib = "amb@world_human_musician@guitar@male@idle_a", anim = "idle_b", car = 0, loop = 57, e = "gitara"}},
            {label = "Książka", type = "animprop35", data = {lib = "cellphone@", anim = "cellphone_text_read_base", car = 0, loop = 58, e = "ksiazka"}},
            {label = "Plecak", type = "animprop39", data = {lib = "move_p_m_zero_rucksack", anim = "idle", car = 0, loop = 58, e = "plecak"}}, 
            {label = "Szampan", type = "animprop36", data = {lib = "anim@heists@humane_labs@finale@keycards", anim = "idle", car = 0, loop = 58, e = "szampan"}},
            {label = "Wino", type = "animprop37", data = {lib = "anim@heists@humane_labs@finale@keycards", anim = "ped_a_enter_loop", car = 0, loop = 58, e = "wino"}},   
            {label = "Karton", type = "animprop17", data = {lib = "anim@heists@box_carry@", anim = "idle", car = 0, loop = 57, e = "karton"}},
            {label = "Wiertarka", type = "animprop22", data = {lib = "anim@heists@fleeca_bank@drilling", anim = "drill_straight_start", car = 0, loop = 57, e = "wiertarka"}},
            {label = "Skrzynka z narzędziami", type = "animprop23", data = {lib = "rcmepsilonism8", anim = "bag_handler_idle_a", car = 0, loop = 57, e = "skrzynka"}},
            {label = "Walizka 1", type = "animprop18", data = {lib = "rcmepsilonism8", anim = "bag_handler_idle_a", car = 0, loop = 57, e = "walizka"}}, 
            {label = "Walizka 2", type = "animprop19", data = {lib = "rcmepsilonism8", anim = "bag_handler_idle_a", car = 0, loop = 57, e = "walizka2"}}, 
            {label = "Walizka 3", type = "animprop20", data = {lib = "rcmepsilonism8", anim = "bag_handler_idle_a", car = 0, loop = 57, e = "walizka3"}}, 
            {label = "Walizka 4", type = "animprop21", data = {lib = "anim@heists@narcotics@trash", anim = "walk", car = 0, loop = 58, e = "walizka4"}},    
        }
    },

    {
        name = 'porn',
        label = 'Interakcje - PEGI 21',
        items = {
            {label = "Dokowanie", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@air_shagging", anim = "air_shagging", car = 0, loop = 0, e = "dokowanie"}},
            {label = "Posuwanie", type = "anim", data = {lib = "timetable@trevor@skull_loving_bear", anim = "skull_loving_bear", car = 0, loop = 1, e = "posuwanie"}},
            {label = "Gest walenia", type = "anim", data = {lib = "anim@mp_player_intupperdock", anim = "idle_a", car = 1, loop = 57, e = "walenie"}},
            {label = "Walenie konia 1 [Pojazd]", type = "anim", data = {lib = "anim@mp_player_intincarwanklow@ps@", anim = "idle_a", car = 1, loop = 1, e = "walenie2"}},
            {label = "Walenie konia 2 - na kogoś", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@wank", anim = "wank", car = 0, loop = 0, e = "walenie3"}},   
            {label = "Eksponowanie wdzięków - przód", type = "anim", data = {lib = "mini@hookers_sp", anim = "ilde_b", car = 0, loop = 1, e = "wdzieki"}},
            {label = "Eksponowanie wdzięków - tył", type = "anim", data = {lib = "mini@hookers_sp", anim = "ilde_c", car = 0, loop = 1, e = "wdzieki2"}},
            {label = "Taniec erotyczny 1", type = "anim", data = {lib = "mini@strip_club@lap_dance@ld_girl_a_song_a_p1", anim = "ld_girl_a_song_a_p1_f", car = 0, loop = 1, e = "erotyczny"}},
            {label = "Taniec erotyczny 2", type = "anim", data = {lib = "mini@strip_club@private_dance@part2", anim = "priv_dance_p2", car = 0, loop = 1, e = "erotyczny2"}},
            {label = "Taniec erotyczny 3", type = "anim", data = {lib = "mini@strip_club@private_dance@part3", anim = "priv_dance_p3", car = 0, loop = 1, e = "erotyczny3"}},
        }
    },
}

Config['Synced'] = {
    {
        ['Label'] = 'Przytul',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'kisses_guy_a', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'kisses_guy_b', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.05,
                ['yP'] = 1.15,
                ['zP'] = -0.05,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Piątka',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'highfive_guy_a', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'highfive_guy_b', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = -0.5,
                ['yP'] = 1.25,
                ['zP'] = 0.0,

                ['xR'] = 0.9,
                ['yR'] = 0.3,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Przytul po przyjacielsku',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'hugs_guy_a', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'hugs_guy_b', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = -0.025,
                ['yP'] = 1.15,
                ['zP'] = 0.0,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Żółwik',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationpaired@f_f_fist_bump', ['Anim'] = 'fist_bump_left', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationpaired@f_f_fist_bump', ['Anim'] = 'fist_bump_right', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = -0.6,
                ['yP'] = 0.9,
                ['zP'] = 0.0,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 270.0,
            }
        }
    },
    {
        ['Label'] = 'Podaj ręke (koleżeńskie)',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'handshake_guy_a', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'handshake_guy_b', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.0,
                ['yP'] = 1.2,
                ['zP'] = 0.0,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Podaj ręke (oficjalnie)',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_common', ['Anim'] = 'givetake1_a', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_common', ['Anim'] = 'givetake1_b', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.075,
                ['yP'] = 1.0,
                ['zP'] = 0.0,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Uderz',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'melee@unarmed@streamed_variations', ['Anim'] = 'plyr_takedown_rear_lefthook', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'melee@unarmed@streamed_variations', ['Anim'] = 'victim_takedown_front_cross_r', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.05,
                ['yP'] = 1.15,
                ['zP'] = -0.05,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Uderz z liścia',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'melee@unarmed@streamed_variations', ['Anim'] = 'plyr_takedown_front_slap', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'melee@unarmed@streamed_variations', ['Anim'] = 'victim_takedown_front_backslap', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.05,
                ['yP'] = 1.15,
                ['zP'] = -0.05,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Uderz z główki',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'melee@unarmed@streamed_variations', ['Anim'] = 'plyr_takedown_front_headbutt', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'melee@unarmed@streamed_variations', ['Anim'] = 'victim_takedown_front_headbutt', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.05,
                ['yP'] = 1.15,
                ['zP'] = -0.05,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Gra w baseballa',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@arena@celeb@flat@paired@no_props@', ['Anim'] = 'baseball_a_player_a', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@arena@celeb@flat@paired@no_props@', ['Anim'] = 'baseball_a_player_b', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = -0.5,
                ['yP'] = 1.25,
                ['zP'] = 0.0,

                ['xR'] = 0.9,
                ['yR'] = 0.3,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Wspólny taniec 1',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_a@', ['Anim'] = 'low_center', ['Flags'] = 1,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_a@', ['Anim'] = 'low_center', ['Flags'] = 1, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.05,
                ['yP'] = 1.15,
                ['zP'] = -0.05,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Wspólny taniec 2',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity', ['Anim'] = 'hi_dance_facedj_09_v1_female^1', ['Flags'] = 1,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity', ['Anim'] = 'hi_dance_facedj_09_v1_female^1', ['Flags'] = 1, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.05,
                ['yP'] = 1.15,
                ['zP'] = -0.05,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Wspólny taniec 3',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_b@', ['Anim'] = 'high_center', ['Flags'] = 1,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_b@', ['Anim'] = 'high_center', ['Flags'] = 1, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.05,
                ['yP'] = 1.15,
                ['zP'] = -0.05,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Wspólny taniec 4',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity', ['Anim'] = 'hi_dance_facedj_09_v2_female^1', ['Flags'] = 1,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity', ['Anim'] = 'hi_dance_facedj_09_v2_female^1', ['Flags'] = 1, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.05,
                ['yP'] = 1.15,
                ['zP'] = -0.05,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Wspólny taniec 5',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@solomun_entourage@', ['Anim'] = 'mi_dance_facedj_17_v1_female^1', ['Flags'] = 1,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@solomun_entourage@', ['Anim'] = 'mi_dance_facedj_17_v1_female^1', ['Flags'] = 1, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.05,
                ['yP'] = 1.15,
                ['zP'] = -0.05,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Wspólny taniec 6',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@lazlow@hi_podium@', ['Anim'] = 'danceidle_mi_17_crotchgrab_laz', ['Flags'] = 1,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@lazlow@hi_podium@', ['Anim'] = 'danceidle_mi_17_crotchgrab_laz', ['Flags'] = 1, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.05,
                ['yP'] = 1.15,
                ['zP'] = -0.05,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Wspólny taniec 7',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationmale@uncle_disco', ['Anim'] = 'uncle_disco', ['Flags'] = 1,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationmale@uncle_disco', ['Anim'] = 'uncle_disco', ['Flags'] = 1, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.05,
                ['yP'] = 1.15,
                ['zP'] = -0.05,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },

    {
        ['Label'] = 'Wspólny taniec 8',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@amb@casino@mini@dance@dance_solo@female@var_b@', ['Anim'] = 'high_center', ['Flags'] = 1,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@amb@casino@mini@dance@dance_solo@female@var_b@', ['Anim'] = 'high_center', ['Flags'] = 1, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.05,
                ['yP'] = 1.15,
                ['zP'] = -0.05,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },

    {
        ['Label'] = 'Pocałuj',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'hs3_ext-20', ['Anim'] = 'cs_lestercrest_3_dual-20', ['Flags'] = 1,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'hs3_ext-20', ['Anim'] = 'csb_georginacheng_dual-20', ['Flags'] = 1, ['Attach'] = {
                ['Bone'] = 0,
                ['xP'] = 0.0,
                ['yP'] = 0.53,
                ['zP'] = 0.0,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },

    {
        ['Label'] = 'Zrób loda (na stojąco)',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'misscarsteal2pimpsex', ['Anim'] = 'pimpsex_hooker', ['Flags'] = 1, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.0,
                ['yP'] = 0.65,
                ['zP'] = 0.0,

                ['xR'] = 120.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'misscarsteal2pimpsex', ['Anim'] = 'pimpsex_punter', ['Flags'] = 1,
        },
    },
    {
        ['Label'] = 'Sex (na stojąco)',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'misscarsteal2pimpsex', ['Anim'] = 'shagloop_hooker', ['Flags'] = 1, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.05,
                ['yP'] = 0.4,
                ['zP'] = 0.0,

                ['xR'] = 120.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'misscarsteal2pimpsex', ['Anim'] = 'shagloop_pimp', ['Flags'] = 1,
        },
    },
    {
        ['Label'] = 'Anal (na stojąco)', 
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'rcmpaparazzo_2', ['Anim'] = 'shag_loop_a', ['Flags'] = 1,
        }, 
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'rcmpaparazzo_2', ['Anim'] = 'shag_loop_poppy', ['Flags'] = 1, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.015,
                ['yP'] = 0.35,
                ['zP'] = 0.0,

                ['xR'] = 0.9,
                ['yR'] = 0.3,
                ['zR'] = 0.0,
            },
        },
    },
    {
        ['Label'] = "Uprawiaj sex (pojazd)", 
        ['Car'] = true,
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'oddjobs@assassinate@vice@sex', ['Anim'] = 'frontseat_carsex_loop_m', ['Flags'] = 1,
        }, 
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'oddjobs@assassinate@vice@sex', ['Anim'] = 'frontseat_carsex_loop_f', ['Flags'] = 1,
        },
    },
    {
        ['Label'] = "Uprawiaj sex 2 (pojazd)", 
        ['Car'] = true,
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'random@drunk_driver_2', ['Anim'] = 'cardrunksex_loop_f', ['Flags'] = 1,
        }, 
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'random@drunk_driver_2', ['Anim'] = 'cardrunksex_loop_m', ['Flags'] = 1,
        },
    },
    {
        ['Label'] = "Zrób loda (pojazd)", 
        ['Car'] = true,
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'oddjobs@towing', ['Anim'] = 'm_blow_job_loop', ['Flags'] = 1,
        }, 
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'oddjobs@towing', ['Anim'] = 'f_blow_job_loop', ['Flags'] = 1,
        },
    },
}

