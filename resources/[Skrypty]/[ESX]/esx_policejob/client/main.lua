local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
  
PlayerData = {}
local HasAlreadyEnteredMarker = false
local LastStation             = nil
local LastPartNum             = nil
local zakuciesprawdz = false
local CurrentAction = nil
local CurrentActionMsg  = ''
local CurrentActionData = {}
local DragStatus 					= {}
local IsDragged 					= false
local IsHandcuffed = false
local HandcuffTimer = nil
local isDead = false
local CopPlayer 					= nil
local Dragging 						= nil
local CurrentTask = {}
ESX                           = nil

CreateThread(function()
	while ESX == nil do
		TriggerEvent("hypex:getTwojStarySharedTwojaStaraObject", function(library)
			ESX = library
		end)
	  
		Citizen.Wait(250)
	end

	Citizen.Wait(5000)
	PlayerData = ESX.GetPlayerData()
	
    while not HasAnimDictLoaded("random@mugging3") do
        RequestAnimDict("random@mugging3")
        Citizen.Wait(0)
    end
end)

CreateThread(function()
	while PlayerData == nil do
		Citizen.Wait(500)
	end
	
	while true do
		Citizen.Wait(10000)
		local playerPed = PlayerPedId()
		
		if not PlayerData.job.name == 'police' and not PlayerData.job.name == 'offpolice' then
			local armour = Citizen.InvokeNative(0x9483AF821605B1D8, playerPed)
			
			if armour > 75 then
				TriggerServerEvent('exile_logs:triggerLog', 'Has a vest over 75% without a SASP job (esx_policejob)', 'anticheat')
				Citizen.Wait(30000)			
			end
		end
	end
end)

function IsCuffed()
	return IsHandcuffed
end
  
function SetVehicleMaxMods(vehicle, livery, offroad, wheelsxd, color, extrason, extrasoff, bulletproof, tint, wheel, tuning, plate)
	local t = {
		modArmor        = 4,
		modTurbo        = true,
		modXenon        = true,
		windowTint      = 0,
		dirtLevel       = 0,
		color1			= 0,
		color2			= 0
	}
	
	if tuning then
		t.modEngine = 3
		t.modBrakes = 2
		t.modTransmission = 2
		t.modSuspension = 3
	end

	if offroad then
		t.wheelColor = 5
		t.wheels = 4
		t.modFrontWheels = 17
	end

	if wheelsxd then
		t.wheels = 1
		t.modFrontWheels = 5
	end

	if bulletproof then
		t.bulletProofTyre = true
	end

	if color then
		t.color1 = color
	end

	if tint then
		t.windowTint = tint
	end

	if wheel then
		t.wheelColor = wheel.color
		t.wheels = wheel.group
		t.modFrontWheels = wheel.type
	end
	
	ESX.Game.SetVehicleProperties(vehicle, t)

	if #extrason > 0 then
		for i=1, #extrason do
			SetVehicleExtra(vehicle, extrason[i], false)
		end
	end
	
	if #extrasoff > 0 then
		for i=1, #extrasoff do
			SetVehicleExtra(vehicle, extrasoff[i], true)
		end
	end
	  
	if livery then
		SetVehicleLivery(vehicle, livery)
	end
end
  
function cleanPlayer(playerPed)
	Citizen.InvokeNative(0xCEA04D83135264CC, playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end
  
function setUniform(job, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if Config.Uniforms[job].male ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end
		else
			if Config.Uniforms[job].female ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end
		end
	end)
end
  
function setLastUniform(clothes, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		TriggerEvent('skinchanger:loadClothes', skin, clothes)
	end)
end
  
function setArmour(value, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin['bproof_1'] ~= 0 and skin['bproof_1'] ~= 10 then
			Citizen.InvokeNative(0xCEA04D83135264CC, playerPed, value)
		else
			ESX.ShowNotification("~r~Nie masz kamizelki, która ma możliwość zaaplikowania wkładów")
		end
	end)
end
  
function OpenCloakroomMenu()
	ESX.UI.Menu.CloseAll()
	local playerPed = PlayerPedId()
	local grade = PlayerData.job.grade_name
	local hasSertLicense = false

	local elements = {
		{ label = ('Civilian Uniforms'), value = 'citizen_wear' },		
	}
  
	if PlayerData.job.name == 'police' then
		table.insert(elements, {label = 'Private Uniforms', value = 'player_dressing' })
		if PlayerData.hiddenjob.name == 'sheriff' then
			table.insert(elements, {label = "Sheriff Uniforms", value = 'sheriffuniforms'})
			table.insert(elements, {label = "Combat Sheriff Uniforms", value = 'combatsheriff'})
			table.insert(elements, {label = "Sheriff Event Uniforms", value = 'addonssheriff'})
		end
		
		ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
			if hasWeaponLicense then 
				table.insert(elements, {label = "U.S. Marshal Uniforms", value = 'usmsuniforms'})
			end
		end, GetPlayerServerId(PlayerId()), 'usms')

		ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
			if hasWeaponLicense then 
				table.insert(elements, {label = "H.P. Uniforms", value = 'hpuniforms'})
			end
		end, GetPlayerServerId(PlayerId()), 'hp')

		ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
			if hasWeaponLicense then 
				table.insert(elements, {label = "D.T.U. Marshal Uniforms", value = 'dtuuniforms'})
			end
		end, GetPlayerServerId(PlayerId()), 'dtu')

		ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
			if hasWeaponLicense then 
				table.insert(elements, {label = "T.D. Uniforms", value = 'tduniforms'})
			end
		end, GetPlayerServerId(PlayerId()), 'td')
		
		ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
			if hasWeaponLicense then
				table.insert(elements, {label = "A.I.A.D. Uniforms", value = 'aiaduniforms'})
			end
		end, GetPlayerServerId(PlayerId()), 'aiad')
		
		ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
			if hasWeaponLicense then
				hasSertLicense = true
				table.insert(elements, {label = "S.W.A.T. Uniforms", value = 'swatuniforms'})
			end
		end, GetPlayerServerId(PlayerId()), 'swat')

		ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
			if hasWeaponLicense then
				hasSertLicense = true
				table.insert(elements, {label = "S.E.R.T. Uniforms", value = 'sertuniforms'})
			end
		end, GetPlayerServerId(PlayerId()), 'sert')

		Citizen.Wait(100)
	   
		table.insert(elements, {label = "Offical Patrol Uniforms", value = 'mundury1'})
		table.insert(elements, {label = "Combat Patrol Uniforms", value = 'mundury2'})
		table.insert(elements, {label = "Event Uniforms", value = 'mundury3'})
		table.insert(elements, {label = "Accessories", value = 'dodatki'})
	end
  
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
		title    = _U('cloakroom'),
		align    = 'right',
		elements = elements
	}, function(data, menu)
		cleanPlayer(playerPed)
		
		if data.current.value == 'job_wear' then
			menu.close()
		end

		if data.current.value == 'mundury1' then
			local elements2 = {
				{label = "Cadet Uniform", value = 'recruit_wear'},
				{label = "Probie Trooper Uniform", value = 'officer_wear'},
				{label = "Trooper Uniform", value = 'officer_wear2'},
				{label = "Senior Trooper Uniform", value = 'officer_wear3'},
				{label = "Sergeant Uniform", value = 'sergeant_wear'},
				{label = "Senior Sergeant Uniform", value = 'sergeant_wear2'},
				{label = "Staff Sergeant Uniform", value = 'sergeant_wear3'},
				{label = "Lieutenant Uniform", value = 'lieutenant_wear'},
				{label = "Staff Lieutenant Uniform", value = 'lieutenant_wear2'},
				{label = "Captain Uniform", value = 'captain_wear'},
				{label = "Staff Captain Uniform", value = 'captain_wear2'},
			}
			
			if PlayerData.job.grade_name == 'boss' then
				table.insert(elements, {label = "I Mundur ACOP/DCOP", value = 'chef_wear'})
				table.insert(elements, {label = "I Mundur COP", value = 'boss_wear'})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mundury1', {
				title    = "S.A.S.P. Uniforms",
				align    = 'right',
				elements = elements2
			}, function(data2, menu2)
				setUniform(data2.current.value, playerPed)
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	  
		if data.current.value == 'sheriffuniforms' then
			local elements2 = {
				{label="Cadet Uniform", value= "recruit2_wear"},
				{label = "Probie Deputy Uniform", value = 'deputy_wear'},
			}
			
			if (PlayerData.hiddenjob.grade >= 0 and PlayerData.hiddenjob.grade < 5) or PlayerData.hiddenjob.grade >= 10 then
				table.insert(elements2, {label = "Deputy Uniform", value = 'deputy_wear2'})
				table.insert(elements2, {label = "Senior Deputy Uniform", value = 'deputy_wear3'})
			end
			
			if (PlayerData.hiddenjob.grade >= 0 and PlayerData.hiddenjob.grade < 7) or PlayerData.hiddenjob.grade >= 10 then
				table.insert(elements2, {label = "Corporal Uniform", value = 'sergeantsh_wear'})
				table.insert(elements2, {label = "Sergeant Uniform", value = 'sergeantsh_wear2'})
				table.insert(elements2, {label = "Master Sergeant Uniform", value = 'sergeantsh_wear3'})
			end
			
			if (PlayerData.hiddenjob.grade >= 0 and PlayerData.hiddenjob.grade < 9) or PlayerData.hiddenjob.grade >= 10 then
				table.insert(elements2, {label = "Lieutenant Uniform", value = 'lieutenantsh_wear'})
				table.insert(elements2, {label = "Senior Lieutenant Uniform", value = 'lieutenantsh_wear2'})
			end
			
			if (PlayerData.hiddenjob.grade >= 0 and PlayerData.hiddenjob.grade < 11) or PlayerData.hiddenjob.grade >= 10 then
				table.insert(elements2, {label = "Captain Uniform", value = 'captainsh_wear'})
				table.insert(elements2, {label = "Senior Captain Uniform", value = 'captainsh_wear2'})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mundury1', {
				title    = "S.A.S.D. Uniforms",
				align    = 'right',
				elements = elements2
			}, function(data2, menu2)
				setUniform(data2.current.value, playerPed)
			end, function(data2, menu2)
				menu2.close()
			end)
		end

		if data.current.value == 'usmsuniforms' then
			local elements2 = {
				{label = "High Command Uniform David Feingold", value = 'usmshc_uniform'},
				{label = "High Command Uniform Andrew Boyowka", value = 'usmshc2_uniform'},
				{label = "High Command Uniform Liam Miller", value = 'usmshc3_uniform'},
				{label = "U.S. Marshal Patrol Uniform", value = 'usmspatrol_uniform'},
				{label = "U.S. Marshal Hoodie Uniform", value = 'usmsbluza_uniform'},
				{label = "U.S. Marshal Combat Uniform", value = 'usmscombat_uniform'},
				{label = "U.S. Marshal Sport Jacket Uniform", value = 'usmskurtka_uniform'},
				{label = "U.S. Marshal Winter Jacket Uniform", value = 'usmskurtka2_uniform'},
				{label = "U.S. Marshal Long Shirt Uniform", value = 'longsleeve_uniform'},
				{label = "U.S. Marshal Official Uniform", value = 'usmsofficial_uniform'},
				{label = "U.S. Marshal Normal Vest", value = 'usmsbullet_wear'},
				{label = "U.S. Marshal Kevlar", value = 'armour'},
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mundury1', {
				title    = "U.S. Marshal Uniforms",
				align    = 'right',
				elements = elements2
			}, function(data2, menu2)
				if data2.current.value == 'armour' then
					setArmour(75, playerPed)
				else
					setUniform(data2.current.value, playerPed)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end

		if data.current.value == 'hpuniforms' then
			local elements2 = {
				{label = "H.P. Probie Uniform", value = 'probiehp'},
				{label = "H.P. Officer Uniform", value = 'officerhp'},
				{label = "H.P. Sergeant Uniform", value = 'sergeanthp'},
				{label = "H.P. Lieutenant Uniform", value = 'lieutenanthp'},
				{label = "H.P. Captain Uniform", value = 'captainhp'},
				{label = "H.P. Kevlar", value = 'armour'},
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mundury1', {
				title    = "H.P. Uniforms",
				align    = 'right',
				elements = elements2
			}, function(data2, menu2)
				if data2.current.value == 'armour' then
					setArmour(75, playerPed)
				else
					setUniform(data2.current.value, playerPed)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end

		if data.current.value == 'dtuuniforms' then
			local elements2 = {
				{label = "D.T.U Interview Uniform", value = 'dtu'},
				{label = "D.T.U Investigation Uniform 1", value = 'dtu1'},
				{label = "D.T.U Investigation Uniform 2", value = 'dtu2'},
				{label = "D.T.U Investigation Uniform 3", value = 'dtu3'},
				{label = "D.T.U Investigation Uniform 4", value = 'dtu4'},
				{label = "D.T.U Combat Uniform 1", value = 'dtu6'},
				{label = "D.T.U Combat Uniform 2", value = 'dtu7'},
				{label = "D.T.U Kevlar", value = 'armour'},
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mundury1', {
				title    = "D.T.U. Uniforms",
				align    = 'right',
				elements = elements2
			}, function(data2, menu2)
				if data2.current.value == 'armour' then
					setArmour(75, playerPed)
				else
					setUniform(data2.current.value, playerPed)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end

		if data.current.value == 'tduniforms' then
			local elements2 = {
				{label = "T.D. Academy Command Uniform", value = 'tdacademy2_uniform'},
				{label = "T.D. Academy Uniform", value = 'tdacademy_uniform'},
				{label = "T.D. Normal Vest", value = 'tdbullet_wear'},
				{label = "T.D. Kevlar", value = 'armour'},
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mundury1', {
				title    = "T.D. Uniforms",
				align    = 'right',
				elements = elements2
			}, function(data2, menu2)
				if data2.current.value == 'armour' then
					setArmour(75, playerPed)
				else
					setUniform(data2.current.value, playerPed)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end
		
		if data.current.value == 'aiaduniforms' then
			local elements2 = {
				{label = "AIAD Patrol Uniform", value = 'aiadpatrol_uniform'},
				{label = "AIAD Combat Uniform", value = 'aiadcombat_uniform'},
				{label = 'A.I.A.D. Bulletproof - Johny Pokielbaszony', value = 'kamza_aiad901'},
				{label = 'A.I.A.D. Bulletproof - Leon Garson', value = 'kamza_aiad902'},
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mundury5', {
				title    = "A.I.A.D. Uniforms",
				align    = 'right',
				elements = elements2
			}, function(data2, menu2)
				setUniform(data2.current.value, playerPed)
			end, function(data2, menu2)
				menu2.close()
			end)
		end

		if data.current.value == 'swatuniforms' then
			local elements2 = {
				{label = "S.W.A.T. Special Alfa Uniform", value = 'swat_david1'},
				{label = "S.W.A.T. Special Bravo Uniform", value = 'swat_david2'},
				{label = "S.W.A.T. Special Charlie Uniform", value = 'swat_david3'},
				{label = "S.W.A.T. Special Delta Uniform", value = 'swat_david4'},
				{label = "S.W.A.T. Light Alfa Uniform", value = 'swat_koszulka1'},
				{label = "S.W.A.T. Light Bravo Uniform", value = 'swat_koszulka2'},
				{label = "S.W.A.T. Light Charlie Uniform", value = 'swat_koszulka3'},
				{label = "S.W.A.T. Light Delta Uniform", value = 'swat_koszulka4'},
				{label = "S.W.A.T. Normal Heavy Uniform", value = 'swat_wear4'},
				{label = "S.W.A.T. Long Light Uniform", value = 'swat_wear2'},
				{label = "S.W.A.T. Combat Uniform", value = 'swat_wear3'},
				{label = "S.W.A.T. Heavy Kevlar", value = 'armor_sert'},
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mundury7', {
				title    = "S.W.A.T. Uniforms",
				align    = 'right',
				elements = elements2
			}, function(data2, menu2)
				if data2.current.value ~= 'armor_sert' then
					setUniform(data2.current.value, playerPed)
				end
				if data2.current.value == 'armor_sert' then
					setArmour(100, playerPed)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end
		
		if data.current.value == 'sertuniforms' then
			local elements2 = {
				{label = "S.E.R.T. Special Alfa Uniform", value = 'sert_david1'},
				{label = "S.E.R.T. Special Bravo Uniform", value = 'sert_david2'},
				{label = "S.E.R.T. Special Charlie Uniform", value = 'sert_david3'},
				{label = "S.E.R.T. Special Delta Uniform", value = 'sert_david4'},
				{label = "S.E.R.T. Light Alfa Uniform", value = 'sert_koszulka1'},
				{label = "S.E.R.T. Light Bravo Uniform", value = 'sert_koszulka2'},
				{label = "S.E.R.T. Light Charlie Uniform", value = 'sert_koszulka3'},
				{label = "S.E.R.T. Light Delta Uniform", value = 'sert_koszulka4'},
				{label = "S.E.R.T. Long Light Uniform", value = 'sert_wear2'},
				{label = "S.E.R.T. Combat Uniform", value = 'sert_wear3'},
				{label = "S.E.R.T. Heavy Uniform", value = 'sert_wear4'},
				{label = "S.E.R.T. Heavy Kevlar", value = 'armor_sert'},
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mundury6', {
				title    = "S.E.R.T. Uniforms",
				align    = 'right',
				elements = elements2
			}, function(data2, menu2)
				if data2.current.value ~= 'armor_sert' then
					setUniform(data2.current.value, playerPed)
				end
				if data2.current.value == 'armor_sert' then
					setArmour(100, playerPed)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	  
		if data.current.value == 'combatsheriff' then
			local elements2 = {}
			
			if PlayerData.hiddenjob.grade >= 4 then
				table.insert(elements2, {label = "Sheriff Combat Uniform Sergeant", value = 'sheriff_patrol2'})
			end
			
			if PlayerData.hiddenjob.grade >= 7 then
				table.insert(elements2, {label = "Sheriff Combat Uniform Lieutenant", value = 'sheriff_patrol3'})
			end
			
			if PlayerData.hiddenjob.grade >= 9 then
				table.insert(elements2, {label = "Sheriff Combat Uniform Capitan", value = 'sheriff_patrol4'})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mundury2', {
				title    = "Combat S.A.S.D. Uniforms",
				align    = 'right',
				elements = elements2
			}, function(data2, menu2)
				setUniform(data2.current.value, playerPed)
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	  
		if data.current.value == 'mundury2' then
			local elements2 = {
				{label = "Combat Uniform Sergeant", value = 'police_patrol2'},
				{label = "Combat Uniform Lieutenant", value = 'police_patrol3'},
				{label = "Combat Uniform Capitan", value = 'police_patrol4'},
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mundury2', {
				title    = "Combat S.A.S.P. Uniforms",
				align    = 'right',
				elements = elements2
			}, function(data2, menu2)
				setUniform(data2.current.value, playerPed)
			end, function(data2, menu2)
				menu2.close()
			end)
		end

		if data.current.value == 'mundury3' then
  
			local elements2 = {
				{label = "Official Uniform", value = 'oficjalny_wear'},
				{label = "Motorcycle Uniform", value = 'motocykl_wear'},
				{label = "K-9 Uniform", value = 'k9_wear'},
			}

			ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
				if hasWeaponLicense then
					table.insert(elements2, {label = "Diver Uniform", value = 'nurek_wear'})
				end
				
				if PlayerData.hiddenjob.name == 'sheriff' then
					table.insert(elements2, {label = "Sheriff Official Uniform", value = 'sheriff_official'})
					table.insert(elements2, {label = "Sheriff Motorcycle Uniform", value = 'motocyklsheriff_wear'})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mundury3', {
					title    = "Event Uniforms",
					align    = 'right',
					elements = elements2
				}, function(data2, menu2)
					setUniform(data2.current.value, playerPed)
				end, function(data2, menu2)
					menu2.close()
				end)		
			end, GetPlayerServerId(PlayerId()), 'nurek')
		end

	  if data.current.value == 'addonssheriff' then
			local elements2 = {
				{label = "VEST - SASD", value = 's_vest'},				
				{label = "Armor", value = 'armour'}
			}
		  
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'dodatki', {
				title    = "Addons Uniforms",
				align    = 'right',
				elements = elements2
			}, function(data2, menu2)
				if data2.current.value == 'armour' then
					setArmour(75, playerPed)
				else
					setUniform(data2.current.value, playerPed)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end

		if data.current.value == 'dodatki' then
			local elements2 = {
				{label = "Bulletproof Vest", value = 'bullet_wear'},
				{label = "Reflective Vest", value = 'gilet_wear'},
				{label = "Heavy Bag", value = 'torba_wear'},
				{label = "Medium Kevlar", value = 'armour'}
			}
		  
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'dodatki', {
				title    = "Addons Uniforms",
				align    = 'right',
				elements = elements2
			}, function(data2, menu2)
				if data2.current.value == 'armour' then
					setArmour(75, playerPed)
				else
					setUniform(data2.current.value, playerPed)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end

		if data.current.value == 'player_dressing' then
			ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
				local elements = {}

				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
					title    = "Private Uniforms",
					align    = 'right',
					elements = elements
				}, function(data2, menu2)
					TriggerEvent('skinchanger:getSkin', function(skin)
						ESX.TriggerServerCallback('esx_property:getPlayerOutfit', function(clothes)
							TriggerEvent('skinchanger:loadClothes', skin, clothes)
							TriggerEvent('esx_skin:setLastSkin', skin)

							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
							end)
						end, data2.current.value)
					end)
				end, function(data2, menu2)
					menu2.close()
				end)
			end)
		end
	  
		if data.current.value == 'citizen_wear' then
			menu.close()
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		end

		if
			data.current.value == 'recruit_wear' or
			data.current.value == 'recruitszeryf_wear' or
			data.current.value == 'officer_wear' or
			data.current.value == 'officer_wear2' or
			data.current.value == 'officerszeryf_wear' or
			data.current.value == 'sergeant_wear' or
			data.current.value == 'sergeant_wear2' or
			data.current.value == 'sergeantszeryf_wear' or
			data.current.value == 'intendent_wear' or
			data.current.value == 'intendent_wear2' or
			data.current.value == 'intendentszeryf_wear' or
			data.current.value == 'lieutenant_wear' or
			data.current.value == 'lieutenant_wear2' or
			data.current.value == 'lieutenantszeryf_wear' or
			data.current.value == 'captain_wear' or
			data.current.value == 'captain_wear2' or
			data.current.value == 'chef_wear' or
			data.current.value == 'chefszeryf_wear' or
			data.current.value == 'boss_wear' or
			data.current.value == 'bossszeryf_wear' or
			data.current.value == 'sert_wear' or
			data.current.value == 'k9_wear' or
			data.current.value == 'police_patrol2' or
			data.current.value == 'police_patrol3' or
			data.current.value == 'oficjalny_wear' or
			data.current.value == 'motocykl_wear' or
			data.current.value == 'motocyklsheriff_wear' or
			data.current.value == 'nurek_wear' or
			data.current.value == 'sert2_wear' or
			data.current.value == 'bullet_wear' or
			data.current.value == 'bullet2_wear' or
			data.current.value == 'torba_wear' or
			data.current.value == 'gilet_wear' or
			data.current.value == 'gilet2_wear'
		then
			setUniform(data.current.value, playerPed)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	end)
end
  
function OpenVehicleSpawnerMenu(partNum)
	local vehicles = Config.PoliceStations.Vehicles
	
	ESX.UI.Menu.CloseAll()
	local elements = {}
	local found = true
	for i, group in ipairs(Config.VehicleGroups) do
		local elements2 = {}
		
		for _, vehicle in ipairs(Config.AuthorizedVehicles) do
			local let = false
			for _, group in ipairs(vehicle.groups) do
				if group == i then
					let = true
					break
				end
			end

			if let then
				if vehicle.grade then
					if vehicle.hidden == true then
						if i ~= 5 then
							if not CanPlayerUseHidden(vehicle.grade) then
								let = false
							end
						else
							if not CanPlayerUseHidden(vehicle.grade) and not CanPlayerUse(vehicle.grade) then
								let = false
							end
						end
					else
						if not CanPlayerUse(vehicle.grade) then
							let = false
						end
					end
				elseif vehicle.grades and #vehicle.grades > 0 then
					let = false
					for _, grade in ipairs(vehicle.grades) do
						if ((vehicle.swat and IsSWAT) or grade == PlayerData.job.grade) and (not vehicle.label:find('SEU') or IsSEU) then
							let = true
							break
						end
					end
				end

				if let or (PlayerData.job.name == 'police' and PlayerData.job.grade >= 10) or (PlayerData.hiddenjob.name == 'sheriff' and PlayerData.hiddenjob.grade >= 11) then
					table.insert(elements2, { label = vehicle.label, model = vehicle.model, livery = vehicle.livery, extrason = vehicle.extrason, extrasoff = vehicle.extrasoff, offroad = vehicle.offroad, wheelsxd = vehicle.wheelsxd, color = vehicle.color, plate = vehicle.plate, tint = vehicle.tint, bulletproof = vehicle.bulletproof, wheel = vehicle.wheel, tuning = vehicle.tuning })
				end
			end
		end
			
		if (PlayerData.job.name == 'police' and PlayerData.job.grade >= 10) or (PlayerData.hiddenjob.name == 'sheriff' and PlayerData.hiddenjob.grade >= 11) then
			if #elements2 > 0 then
				table.insert(elements, {label = group, value = elements2, group = i})				
			end
		else
			if i == 5 then
				found = false
				ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
					if hasWeaponLicense then
						table.insert(elements, { label = group, value = elements2, group = i })
					end
					
					found = true
				end, GetPlayerServerId(PlayerId()), 'seu')
			elseif i == 6 then
				found = false
				ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
					if hasWeaponLicense then
						table.insert(elements, { label = group, value = elements2, group = i })
					end
					
					found = true
				end, GetPlayerServerId(PlayerId()), 'dtu')
			elseif i == 7 then
				found = false
				ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
					if hasWeaponLicense then
						table.insert(elements, { label = group, value = elements2, group = i })
					end
					
					found = true
				end, GetPlayerServerId(PlayerId()), 'sert')
			elseif i == 8 then
				if PlayerData.hiddenjob.name == 'sheriff' then
					table.insert(elements, { label = group, value = elements2, group = i })
				end
			elseif i == 9 then
				found = false
				ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
					if hasWeaponLicense then
						table.insert(elements, { label = group, value = elements2, group = i })
					end
					
					found = true
				end, GetPlayerServerId(PlayerId()), 'usms')
			elseif i == 10 then
				found = false
				ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
					if hasWeaponLicense then
						table.insert(elements, { label = group, value = elements2, group = i })
					end
					found = true
				end, GetPlayerServerId(PlayerId()), 'hp')
			elseif i == 11 then
				found = false
				ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
					if hasWeaponLicense then
						table.insert(elements, { label = group, value = elements2, group = i })
					end
					found = true
				end, GetPlayerServerId(PlayerId()), 'hp')
			elseif i == 12 then
				found = false
				ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
					if hasWeaponLicense then
						table.insert(elements, { label = group, value = elements2, group = i })
					end
					
					found = true
				end, GetPlayerServerId(PlayerId()), 'aiad')
			elseif i == 13 then
				found = false
				ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
					if hasWeaponLicense then
						table.insert(elements, { label = group, value = elements2, group = i })
					end
					
					found = true
				end, GetPlayerServerId(PlayerId()), 'swat')
			else
				table.insert(elements, { label = group, value = elements2, group = i })
			end
		end
	end
	
	while not found do
		Citizen.Wait(100)
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
	  title    = _U('vehicle_menu'),
	  align    = 'right',
	  elements = elements
	}, function(data, menu)
		menu.close()
		if type(data.current.value) == 'table' and #data.current.value > 0 then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner_' .. data.current.group, {
				title    = data.current.label,
				align    = 'right',
				elements = data.current.value
			}, function(data2, menu2)
				local livery = data2.current.livery
				local extrason = data2.current.extrason
				local extrasoff = data2.current.extrasoff
				local offroad = data2.current.offroad
				local wheelsxd = data2.current.wheelsxd
				local color = data2.current.color
				local bulletproof = data2.current.bulletproof or false
				local tint = data2.current.tint
				local wheel = data2.current.wheel
				local tuning = data2.current.tuning

				local setPlate = true
				if data2.current.plate ~= nil and not data2.current.plate then
					setPlate = false
				end

				local vehicle = GetClosestVehicle(vehicles[partNum].spawnPoint.x,  vehicles[partNum].spawnPoint.y,  vehicles[partNum].spawnPoint.z, 3.0, 0, 71)
				if not DoesEntityExist(vehicle) then
					local playerPed = PlayerPedId()
					if Config.MaxInService == -1 then
						ESX.Game.SpawnVehicle(data2.current.model, {
							x = vehicles[partNum].spawnPoint.x,
							y = vehicles[partNum].spawnPoint.y,
							z = vehicles[partNum].spawnPoint.z
						}, vehicles[partNum].heading, function(vehicle)
							SetVehicleMaxMods(vehicle, livery, offroad, wheelsxd, color, data2.current.extrason, data2.current.extrasoff, bulletproof, tint, wheel, tuning)
							
							if setPlate then
								local plate = ""
								if data.current.label == 'UNMARKED' then
									plate = math.random(100, 999) .. "UM" .. math.random(100, 999)
								elseif data.current.label == 'HP UNMARKED' then
									plate = math.random(100, 999) .. "UM" .. math.random(100, 999)
								elseif PlayerData.hiddenjob.name == 'sheriff' then
									plate = "SASD " .. math.random(100,999)
								elseif PlayerData.hiddenjob.name == 'hwp' then
									plate = "SAHP " .. math.random(100,999)
								else
									plate = "SASP " .. math.random(100,999)
								end
								
								SetVehicleNumberPlateText(vehicle, plate)
								local localVehPlate = string.lower(GetVehicleNumberPlateText(vehicle))
								TriggerEvent('ls:dodajklucze2', localVehPlate)
							else
								local localVehPlate = string.lower(GetVehicleNumberPlateText(vehicle))
								TriggerEvent('ls:dodajklucze2', localVehPlate)
							end

							TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
						end)
					else
						ESX.Game.SpawnVehicle(data2.current.model, {
							x = vehicles[partNum].spawnPoint.x,
							y = vehicles[partNum].spawnPoint.y,
							z = vehicles[partNum].spawnPoint.z
						}, vehicles[partNum].heading, function(vehicle)
							SetVehicleMaxMods(vehicle, livery, offroad, wheelsxd, color, data2.current.extrason, data2.current.extrasoff, bulletproof, tint, wheel, tuning)
						 
							if setPlate then
								local plate = ""
								
								if data.current.label == 'UNMARKED' then
									plate = math.random(100, 999) .. "UM" .. math.random(100, 999)
								elseif PlayerData.hiddenjob.name == 'sheriff' then
									plate = "SASD " .. math.random(100,999)
								else
									plate = "SASP " .. math.random(100,999)
								end
								
								SetVehicleNumberPlateText(vehicle, plate)
								local localVehPlate = string.lower(GetVehicleNumberPlateText(vehicle))
								TriggerEvent('ls:dodajklucze2', localVehPlate)
							else
								local localVehPlate = string.lower(GetVehicleNumberPlateText(vehicle))
								TriggerEvent('ls:dodajklucze2', localVehPlate)
							end

							TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
						end)
					end
				else
					ESX.ShowNotification('Pojazd znaduje się w miejscu wyciągnięcia następnego')
				end
			end, function(data2, menu2)
				menu.close()
				OpenVehicleSpawnerMenu(partNum)
			end)
		else
			ESX.ShowNotification("~r~Brak pojazdów w tej kategorii")
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_vehicle_spawner'
		CurrentActionMsg  = _U('vehicle_spawner')
		CurrentActionData = {station = station, partNum = partNum}
	end)
end
  
  
function OpenLodzieSpawnerMenu(partNum)
	local lodzie = Config.PoliceStations.Lodzie
	ESX.UI.Menu.CloseAll()
	
	local elements = {}
	for i, group in ipairs(Config.LodzieGroups) do
		if (i ~= 10 and i ~= 6) or (i == 10 and IsSheriff) or (i == 6 and IsSEU) then
			local elements2 = {}
			for _, lodz in ipairs(Config.AuthorizedLodzie) do
				local let = false
				for _, group in ipairs(lodz.groups) do
					if group == i then
						let = true
						break
					end
				end

				if let then
					if lodz.grade then
						if not CanPlayerUse(lodz.grade) or (lodz.label:find('SEU') and not IsSEU) then
							let = false
						end
					elseif lodz.grades and #lodz.grades > 0 then
						let = false
						for _, grade in ipairs(lodz.grades) do
							if ((lodz.swat and IsSWAT) or grade == PlayerData.job.grade) and (not lodz.label:find('SEU') or IsSEU) then
								let = true
								break
							end
						end
					end

					if let or (PlayerData.job.name == 'police' and PlayerData.job.grade >= 10) or (PlayerData.hiddenjob.name == 'sheriff' and PlayerData.hiddenjob.grade >= 11) then
						table.insert(elements2, { label = lodz.label, model = lodz.model, livery = lodz.livery, offroad = lodz.offroad, wheelsxd = lodz.wheelsxd, color = lodz.color, extrason = lodz.extrason, extrasoff = lodz.extrasoff, plate = lodz.plate, tint = lodz.tint, bulletproof = lodz.bulletproof, wheel = lodz.wheel, tuning = lodz.tuning })
					end
				end
			end

			if #elements2 > 0 then
				table.insert(elements, { label = group, value = elements2, group = i })
			end
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lodzie_spawner', {
		title    = _U('lodzie_menu'),
		align    = 'right',
		elements = elements
	}, function(data, menu)
		menu.close()
		if type(data.current.value) == 'table' and #data.current.value > 0 then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lodzie_spawner_' .. data.current.group, {
				title    = data.current.label,
				align    = 'right',
				elements = data.current.value
			}, function(data2, menu2)
					local livery = data2.current.livery
					local offroad = data2.current.offroad
					local wheelsxd = data2.current.wheelsxd
					local color = data2.current.color
					local extrason = data2.current.extrason
					local extrasoff = data2.current.extrasoff
					local bulletproof = data2.current.bulletproof or false
					local tint = data2.current.tint
					local wheel = data2.current.wheel
					local tuning = data2.current.tuning

					local setPlate = true
					if data2.current.plate ~= nil and not data2.current.plate then
						setPlate = false
					end

					local lodz = GetClosestVehicle(lodzie[partNum].spawnPoint.x,  lodzie[partNum].spawnPoint.y,  lodzie[partNum].spawnPoint.z, 3.0, 0, 71)
					if not DoesEntityExist(lodz) then
						local playerPed = PlayerPedId()

						ESX.Game.SpawnVehicle(data2.current.model, {
							x = lodzie[partNum].spawnPoint.x,
							y = lodzie[partNum].spawnPoint.y,
							z = lodzie[partNum].spawnPoint.z
						}, lodzie[partNum].heading, function(lodz)
							SetVehicleMaxMods(lodz, livery, offroad, wheelsxd, color, extrason, extrasoff, bulletproof, tint, wheel, tuning)
							
							if setPlate then
								if data.current.label == 'UNMARKED' then
									plate = math.random(100, 999) .. "UM" .. math.random(100, 999)
								elseif PlayerData.hiddenjob.name == 'sheriff' then
									plate = "SASD " .. math.random(100,999)
								else
									plate = "SASP " .. math.random(100,999)
								end
								
								SetVehicleNumberPlateText(lodz, plate)
								local localVehPlate = string.lower(GetVehicleNumberPlateText(lodz))
								TriggerEvent('ls:dodajklucze2', localVehPlate)
							else
								local localVehPlate = string.lower(GetVehicleNumberPlateText(lodz))
								TriggerEvent('ls:dodajklucze2', localVehPlate)
							end

							TaskWarpPedIntoVehicle(playerPed,  lodz,  -1)
						end)
					else
						ESX.ShowNotification('Pojazd znaduje się w miejscu wyciągnięcia następnego')
					end
			end, function(data2, menu2)
				menu.close()
				OpenLodzieSpawnerMenu(partNum)
			end)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_lodzie_spawner'
		CurrentActionMsg  = _U('lodzie_spawner')
		CurrentActionData = {station = station, partNum = partNum}
	end)
end

function LokalnyOutOfCar(ped) 
	if IsPedSittingInAnyVehicle(ped) then
		local vehicle = GetVehiclePedIsIn(ped, false)
		TaskLeaveVehicle(ped, vehicle, 16)
		RequestAnimDict('mp_arresting')
		while not HasAnimDictLoaded('mp_arresting') do
			Citizen.Wait(0)
		end

		TaskPlayAnim(ped, 'mp_arresting', 'idle', 8.0, 1.0, -1, 49, 0.0, 0, 0, 0)
		CreateThread(function() 
			Citizen.Wait(300)
			ClearPedTasksImmediately(ped)
			FreezeEntityPosition(ped, true)
		end)
	end
end

function PutLokalnyInCar(ped) 
	local vehicle = nil
	if IsPedInAnyVehicle(ped, false) then
		vehicle = GetVehiclePedIsIn(ped, false)
	else
		vehicle = ESX.Game.GetVehicleInDirection()
		if not vehicle then
			local coords = GetEntityCoords(ped, false)
			if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
				vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
			end
		end
	end

	if vehicle and vehicle ~= 0 then
		local maxSeats =  GetVehicleMaxNumberOfPassengers(vehicle)
		if maxSeats >= 0 then
			local freeSeat
			for i = (maxSeats - 1), 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat ~= nil then		
				ClearPedTasksImmediately(ped)			
				local tick = 20
				repeat
					TaskWarpPedIntoVehicle(ped, vehicle, freeSeat)
					tick = tick - 1
					Citizen.Wait(50)
				until IsPedInAnyVehicle(ped, false) or tick == 0
			end
		end
	end
end

function CuffLokalny(ped) 
	RequestAnimDict('mp_arresting')
	while not HasAnimDictLoaded('mp_arresting') do
		Citizen.Wait(0)
	end

	if not IsEntityPlayingAnim(ped, 'mp_arresting', 'idle', 3) then
		TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "Cuff", 0.5)
		TaskPlayAnim(ped, 'mp_arresting', 'idle', 8.0, 1.0, -1, 49, 0.0, 0, 0, 0)
		SetEnableHandcuffs(ped, true)
		TaskSetBlockingOfNonTemporaryEvents(ped, true)
		TaskStandStill(ped, 500 * 1000)
		CreateThread(function() 
			while IsPedCuffed(ped) do
				if not IsEntityPlayingAnim(ped, 'mp_arresting', 'idle', 3) then
					TaskPlayAnim(ped, 'mp_arresting', 'idle', 8.0, 1.0, -1, 49, 0.0, 0, 0, 0)
				end
				Citizen.Wait(200)
			end
		end)
	else
		TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "Uncuff", 0.5)
		UnCuffLokalny(ped)
	end
end
function UnCuffLokalny(ped) 
	SetEnableHandcuffs(ped, false)
	Citizen.Wait(100)
	ClearPedTasksImmediately(ped)
	FreezeEntityPosition(ped, false)
	DetachEntity(ped, true, false)
	TaskSetBlockingOfNonTemporaryEvents(ped, false)
	TaskReactAndFleePed(ped, PlayerPedId())
	Dragging = nil
	DraggingLokal = false
end

local DraggingLokal = false

function DragLokalny(ped) 
	local playerPed = PlayerPedId()
	if DraggingLokal and DoesEntityExist(DraggingLokal) then
		ESX.ShowNotification("~r~Puszczono lokalnego")
		DetachEntity(DraggingLokal, true, false)
		FreezeEntityPosition(ped, false)
		TaskSetBlockingOfNonTemporaryEvents(DraggingLokal, true)
		TaskStandStill(DraggingLokal, 500 * 1000)
		Dragging = nil
		DraggingLokal = false
		return
	end
	if not Dragging then
		DraggingLokal = ped
		Dragging = ped
		FreezeEntityPosition(ped, true)
		AttachEntityToEntity(ped, playerPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
		ESX.ShowNotification("~r~Chwycono lokalnego")
		TaskSetBlockingOfNonTemporaryEvents(ped, true)
		TaskStandStill(ped, 500 * 1000)
		CreateThread(function() 
			while DoesEntityExist(ped) do
				Citizen.Wait(1000)
				if IsEntityPlayingAnim(ped, 'mp_arresting', 'idle', 3) or DraggingLokal then
					TaskSetBlockingOfNonTemporaryEvents(ped, true)
					TaskStandStill(ped, 500 * 1000)
				end
			end
			Dragging = nil
			DraggingLokal = false
			DetachEntity(ped, true, false)
			FreezeEntityPosition(ped, true)
		end)
	end
end


function HandcuffMenu()
	ESX.UI.Menu.CloseAll()
	  
	local elements = {}
	if PlayerData.job.name == 'police' then
		table.insert(elements, {label = "Zakuj/Rozkuj",      value = 'handcuff'})		
	else
		table.insert(elements, {label = "Zakuj/Rozkuj",      value = 'handcuff'})
	end
	
	table.insert(elements, {label = "Przenieś",      value = 'drag'})
	table.insert(elements, {label = "Przeszukaj",    value = 'body_search'})
	table.insert(elements, {label = "Ściągnij/Załóż ubrania",	value = 'clothes'})
	table.insert(elements, {label = "Włóż do pojazdu",  value = 'put_in_vehicle'})
	table.insert(elements, {label = "Wyciągnij z pojazdu", value = 'out_the_vehicle'})
	table.insert(elements, {label = "Włóż do bagażnika",	value = 'bagol1'})
	table.insert(elements, {label = "Wyciągnij z bagażnika",	value = 'bagol2'})
	table.insert(elements, {label = "Zabierz i ubierz ubranie",	value = 'przebieranko'})
	
	if PlayerData.job.name == 'police' then
		table.insert(elements, {label = _U('licencja'), value = 'license1'})
		table.insert(elements, {label = _U('GSR-test'), value = 'gsr'})
		table.insert(elements, {label = _U('license_check'), value = 'license' })
		table.insert(elements, {label = "Sprawdź dokumenty",      value = 'identity_card'})
	end

	if PlayerData.job.name == 'ambulance' then
		table.insert(elements, {label = "Sprawdź dokumenty",      value = 'identity_card'})
	end
	
	ESX.UI.Menu.Open( 'default', GetCurrentResourceName(), 'citizen_interaction', {
		title    = "Kajdanki",
		align    = 'center',
		elements = elements
	}, function(data, menu)
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		local closestPed, closestDistancee = ESX.Game.GetClosestPed()
		if (closestPlayer ~= -1 and closestDistance <= 3.0) or (closestPed ~= -1 and closestDistancee <= 3.0) then
			local action = data.current.value
			local targetPed = nil
			local isPlayer = false
			if closestPlayer ~= -1 and closestDistance <= 3.0 then
				targetPed = Citizen.InvokeNative(0x43A66C31C68491C0, closestPlayer)
				isPlayer = true
			elseif closestPed ~= -1 and closestDistancee <= 3.0 then
				targetPed = closestPed
			else
				return
			end
			local hasAnim1 = IsEntityPlayingAnim(targetPed, "missminuteman_1ig_2", "handsup_enter", 3)
			local hasAnim2 = IsEntityPlayingAnim(targetPed, "random@arrests@busted", "enter", 3)
			local hasAnimrece = IsEntityPlayingAnim(targetPed, "random@mugging3", "handsup_standing_base", 3)

			if action == 'handcuff' then
				if not exports['esx_property']:isProperty() then
					if not IsPedCuffed(targetPed) then
						if not CanCuff(targetPed) then
							ESX.ShowNotification("~r~Osoba którą próbujesz zakuć/odkuć nie ma rąk w górze")
							return
						end
					end	
					Citizen.InvokeNative(0xBC045625, targetPed)
					animacjazakuciarozkuciaxd()
					Citizen.Wait(650)
					if isPlayer then
						TriggerServerEvent('xlem0n_policejob:handcuffhype', GetPlayerServerId(closestPlayer))
						ESX.ShowNotification('~o~Zakułeś/Odkułeś ~g~[' .. GetPlayerServerId(closestPlayer) ..']')
					end
					if not isPlayer then
						CuffLokalny(targetPed)
						ESX.ShowNotification('~o~Zakuto/rozkuto lokalnego')
					end	
				end
			elseif action == 'identity_card' then
				OpenIdentityCardMenu(closestPlayer)
			elseif action == 'body_search' then
				if not exports['exile_bank']:TargetInBank() and IsPedCuffed(targetPed) then
					if IsPedCuffed(targetPed) or hasAnim1 or hasAnim2 and not IsPlayerDead(closestPlayer) then
						if isPlayer then
							SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)
							Citizen.Wait(1)
							TriggerServerEvent('xlem0n_policejob:message', GetPlayerServerId(closestPlayer), _U('being_searched'))
							TriggerServerEvent('exile_logs:triggerLog', "Przeszukiwanie gracza " .. GetPlayerServerId(closestPlayer), 'handcuffs', '3066993')
							OpenBodySearchMenu(closestPlayer)
						else
							ESX.ShowNotification('~r~Nie możesz przeszukać lokalnego!')
						end	
					end
				end
			elseif action == 'drag' then
					if IsPedCuffed(targetPed) then
						if isPlayer then
							TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
						else
							DragLokalny(targetPed)
						end
					end
			elseif action == 'put_in_vehicle' then
				if IsPedCuffed(targetPed) then
					if isPlayer then
						if Dragging then
							TriggerServerEvent('esx_policejob:drag', Dragging)
						end	
						TriggerServerEvent('xlem0n_policejob:putInVehicle', GetPlayerServerId(closestPlayer))
					else
						if DraggingLokal then
						DragLokalny(targetPed)
						end	
						PutLokalnyInCar(targetPed)
					end	
				end
			elseif action == 'przebieranko' then
				if IsPedCuffed(targetPed) then
					if isPlayer then
						local SelectedPlayer = closestPlayer
						przebieranko(SelectedPlayer)
					else
						ESX.ShowNotification('~r~Nie możesz przebrać się za lokalnego')
					end
				end
			elseif action == 'out_the_vehicle' then
				if IsPedCuffed(targetPed) then
					if isPlayer then
						TriggerServerEvent('xlem0n_policejob:OutVehicle', GetPlayerServerId(closestPlayer))
					else
						LokalnyOutOfCar(targetPed)
					end	
				end
			elseif action == 'bagol1' then
				if IsPedCuffed(targetPed) then
					if isPlayer then 
						if Dragging then
							TriggerServerEvent('esx_policejob:drag', Dragging)
						end			
						TriggerServerEvent('exile:putTargetInTrunk', GetPlayerServerId(closestPlayer))
					else
						ESX.ShowNotification('~r~Nie możesz wsadzić lokalnego do bagażnika')
					end
				end
			elseif action == 'bagol2' then
				if IsPedCuffed(targetPed) then
					if isPlayer then
						TriggerServerEvent('exile:outTargetFromTrunk', GetPlayerServerId(closestPlayer))
					else
						ESX.ShowNotification('~r~Nie możesz wyciągnąć lokalnego z bagażnika')
					end	
				end
			elseif action == 'clothes' then
			
				if IsPedCuffed(targetPed) then
					if not isPlayer then 
						ESX.ShowNotification('~r~Nie możesz rozebrać lokalnego')
					else
						menu.close()
					
						local elements2 = {
							{label = 'Maska', value = 'mask'},
							{label = 'Czapka / Hełm', value = 'hat'},
							{label = 'Okulary', value = 'glasses'},
							{label = 'Łańcuch / Krawat / Plakietka', value = 'chain'},
							{label = 'Lewa ręka / Zegarek', value = 'zegarek'},
							{label = 'Prawa ręka', value = 'branzoleta'},
							{label = 'Tułów', value = 'coat'},
							{label = 'Nogi', value = 'legs'},
							{label = 'Stopy', value = 'shoes'},
							{label = 'Torba / Plecak', value = 'bag'},
							{label = 'Kamizelka', value = 'kamizelka'},
						}

						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_clothes', {
							title    = 'Kajdanki - Ubrania',
							align    = 'center',
							elements = elements2
						}, function(data2, menu2)
							if data2.current.value ~= nil then
								TriggerServerEvent('esx_ciuchy:takeoff', data2.current.value, GetPlayerServerId(closestPlayer))
							end
						end, function(data2, menu2)
							menu2.close()
							menu.open()
						end)
					end
				end
			elseif action == 'license' then
				if IsPedCuffed(targetPed) then
					if isPlayer then
						ShowPlayerLicense(closestPlayer)
					else
						ESX.ShowNotification('~r~Nie możesz zobaczyć licencji lokalnego')
					end	
				end
			elseif action == 'unpaid_bills' then
				if IsPedCuffed(targetPed) then
					if isPlayer then 
						OpenUnpaidBillsMenu(closestPlayer)
					else
						ESX.ShowNotification('~r~Nie możesz sprawdzić rachunków lokalnego')
					end
				end
			elseif action == 'license1' then
				if IsPedCuffed(targetPed) then
					if isPlayer then
						TriggerServerEvent('xlem0n_policejob:DajLicencje', GetPlayerServerId(closestPlayer))
						TriggerServerEvent('xlem0n_policejob:message', GetPlayerServerId(closestPlayer), _U('otrzymano_licka'))
						ESX.ShowNotification(_U('nadano_licka'))
					else
						ESX.ShowNotification('~r~Nie możesz nadać licencji na broń lokalnemu')
					end
				end
			elseif action == 'gsr' then
				if isPlayer then
					TriggerServerEvent('xlem0n_policejob:message', GetPlayerServerId(closestPlayer), "~y~Funkcjonariusz~w~ sprawdza ~b~proch~w~ na twoich dłoniach")
					ESX.ShowNotification("Sprawdzanie dłoni pod kątem prochu...")
					TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_MEDIC_KNEEL", 0, true)
					if DecorExistOn(Citizen.InvokeNative(0x43A66C31C68491C0, closestPlayer), 'Gunpowder') then
						ESX.ShowNotification("~r~Wykryto proch na dłoniach!")
					else
						ESX.ShowNotification("~g~Nie wykryto prochu na dłoniach.")
					end
				else
					ESX.ShowNotification('~r~Nie możesz sprawdzić prochu lokalnemu')
				end
			end
		else
			local action = data.current.value
			if action == "body_search" then
				BodySearchOffline()
			else	
				ESX.ShowNotification(_U('no_players_nearby'))
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenIdentityCardMenu(player)
  
	ESX.TriggerServerCallback('xlem0n_policejob:getOtherPlayerData', function(data)

		local elements    = {}
		local nameLabel   = _U('name', data.name)
		local jobLabel    = nil
		local sexLabel    = nil
		local dobLabel    = nil
		local heightLabel = nil
		local idLabel     = nil
	
		if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
			jobLabel = _U('job', data.job.label .. ' - ' .. data.job.grade_label)
		else
			jobLabel = _U('job', data.job.label)
		end
	
		if Config.EnableESXIdentity then
	
			nameLabel = _U('name', data.firstname .. ' ' .. data.lastname)
	
			if data.sex ~= nil then
				if string.lower(data.sex) == 'm' then
					sexLabel = _U('sex', _U('male'))
				else
					sexLabel = _U('sex', _U('female'))
				end
			else
				sexLabel = _U('sex', _U('unknown'))
			end
	
			if data.dob ~= nil then
				dobLabel = _U('dob', data.dob)
			else
				dobLabel = _U('dob', _U('unknown'))
			end
	
			if data.height ~= nil then
				heightLabel = _U('height', data.height)
			else
				heightLabel = _U('height', _U('unknown'))
			end
	
			if data.name ~= nil then
				idLabel = _U('id', data.name)
			else
				idLabel = _U('id', _U('unknown'))
			end
	
		end
	
		local elements = {
			{label = nameLabel, value = nil},
			{label = jobLabel,  value = nil},
		}
	
		if Config.EnableESXIdentity then
			table.insert(elements, {label = sexLabel, value = nil})
			table.insert(elements, {label = dobLabel, value = nil})
			table.insert(elements, {label = heightLabel, value = nil})
			table.insert(elements, {label = idLabel, value = nil})
		end
	
		if data.drunk ~= nil then
			table.insert(elements, {label = _U('bac', data.drunk), value = nil})
		end
	
		if data.licenses ~= nil then
	
			table.insert(elements, {label = _U('license_label'), value = nil})
	
			for i=1, #data.licenses, 1 do
				table.insert(elements, {label = data.licenses[i].label, value = nil})
			end
	
		end
	
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction',
		{
			title    = _U('citizen_interaction'),
			align    = 'right',
			elements = elements,
		}, function(data, menu)
	
		end, function(data, menu)
			menu.close()
		end)
	
	end, GetPlayerServerId(player))

end

function przebieranko(target)
	local ped = GetPlayerPed(target)
	local id = GetPlayerServerId(target)
	ESX.TriggerServerCallback("skinchanger:getSkin", function(cb) 
		TriggerEvent('skinchanger:getSkin', function(skin)
			TriggerEvent('skinchanger:loadClothes', skin, cb)
		end)
	end, id)
end

function CanPlayerUseHidden(grade)
	return not grade or PlayerData.hiddenjob.grade >= grade
end

function CanPlayerUse(grade)
	return not grade or PlayerData.job.grade >= grade
end

local hasOdblask = false
local skinOdblask = {}
local hasRekawiczki = false
local skinRekawiczki = {}

  
RegisterNetEvent('esx_policejob:getarrested')
AddEventHandler('esx_policejob:getarrested', function(playerheading, playercoords, playerlocation)	
	IsHandcuffed    = not IsHandcuffed
	local playerPed = PlayerPedId()
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(PlayerPedId(), x, y, z)
	SetEntityHeading(PlayerPedId(), playerheading)
	Citizen.Wait(250)
	loadanimdict('mp_arrest_paired')
	TaskPlayAnim(PlayerPedId(), 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
	Citizen.Wait(3760)
	TriggerEvent('esx_policejob:handcuff')
	loadanimdict('mp_arresting')
	TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
	
	CreateThread(function()
		if IsHandcuffed then
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if not exports['exile_trunk']:checkInTrunk() then
				RequestAnimDict('mp_arresting')
				while not HasAnimDictLoaded('mp_arresting') do
					Citizen.Wait(0)
				end

				if not IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) then
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, 1.0, -1, 49, 0.0, 0, 0, 0)
				end
			end
			
			ESX.UI.Menu.CloseAll()
			TriggerEvent('radar:setHidden', true)
			TriggerEvent('carhud:display', false)
			SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
			DisablePlayerFiring(playerPed, true)
			SetEnableHandcuffs(playerPed, true)
			SetPedCanPlayGestureAnims(playerPed, false)
			TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "Cuff", 0.5)	
			StartHandcuffTimer()
		else
			TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "Uncuff", 0.5)
				Citizen.InvokeNative(0xAAA34F8A7CB32098, playerPed)
			if Config.EnableHandcuffTimer and HandcuffTimer then
				ESX.ClearTimeout(HandcuffTimer)
			end
			SetEnableHandcuffs(playerPed, false)
			DisablePlayerFiring(playerPed, false)
			SetPedCanPlayGestureAnims(playerPed, true)
			 TriggerEvent('radar:setHidden', false)
			TriggerEvent('carhud:display', true)
			FreezeEntityPosition(playerPed, false)
			if exports['exile_trunk']:checkInTrunk() then
				TaskPlayAnim(playerPed, "fin_ext_p1-7", "cs_devin_dual-7", 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
			end
		end
	end)
end)

RegisterNetEvent('esx_policejob:doarrested')
AddEventHandler('esx_policejob:doarrested', function()
	Citizen.Wait(250)
	loadanimdict('mp_arrest_paired')
	TaskPlayAnim(PlayerPedId(), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)
	Citizen.Wait(3000)
end) 

RegisterNetEvent('esx_policejob:douncuffing')
AddEventHandler('esx_policejob:douncuffing', function()
	Citizen.Wait(250)
	loadanimdict('mp_arresting')
	TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	ClearPedTasks(PlayerPedId())
end)

RegisterNetEvent('esx_policejob:getuncuffed')
AddEventHandler('esx_policejob:getuncuffed', function(playerheading, playercoords, playerlocation)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(PlayerPedId(), x, y, z)
	SetEntityHeading(PlayerPedId(), playerheading)
	Citizen.Wait(250)
	loadanimdict('mp_arresting')
	TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Citizen.Wait(5500)
	IsHandcuffed = false
	TriggerEvent('esx_policejob:handcuff')
	ClearPedTasks(PlayerPedId())
end)

function OpenPoliceActionsMenu()
	ESX.UI.Menu.CloseAll()
	local playerPed = PlayerPedId()
	
	local elements = {
		{label = "Interakcje z obywatelem",	value = 'citizen_interaction'},
		{label = "Interakcje z pojazdem", value = 'vehicle_interaction'},
	}
	
	if PlayerData.job.name == 'police' then
		table.insert(elements, {label = "Interakcje z obiektami", value = 'object_spawner'})
		table.insert(elements, {label = 'Wyciągnij lornetkę', value = 'lorneta'})
		table.insert(elements, {label = 'Załóż/zdejmij kamizelkę odblaskową', value = 'odblask'})
		table.insert(elements, {label = 'Załóż/zdejmij rękawiczki lateksowe', value = 'rekawiczki'})
		table.insert(elements, {label = 'Załóż/zdejmij worek na głowe', value = 'worek'})
		table.insert(elements, {label = ('Wyszukiwanie w bazie danych karta sim'), value = 'search_database2'})
		table.insert(elements, {label = ('Wyszukiwanie w bazie danych numer seryjny'), value = 'search_database3'})
	end
  
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'police_actions', {
		title    = 'San Andreas State Police',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'radiolist' then
			exports["rp-radio"]:RadioList()
		elseif data.current.value == 'odblask' then
			if hasOdblask then
				setLastUniform(skinOdblask, playerPed)
				ExecuteCommand('e otrzepanie')
				hasOdblask = false
			else
				TriggerEvent('skinchanger:getSkin', function(skin)
					skinOdblask = skin
					setUniform('odblask_wear', playerPed)
					ExecuteCommand('e otrzepanie')
					hasOdblask = true
				end)
			end
		elseif data.current.value == 'rekawiczki' then
			if hasRekawiczki then
				setLastUniform(skinRekawiczki, playerPed)
				ExecuteCommand('e otrzepanie2')
				hasRekawiczki = false
			else
				TriggerEvent('skinchanger:getSkin', function(skin)
					ExecuteCommand('e otrzepanie2')
					if skin['torso_1'] == 362 or skin['torso_1'] == 363 or skin['torso_1'] == 364 or skin['torso_1'] == 366 
					or skin['torso_1'] == 367 or skin['torso_1'] == 368 or skin['torso_1'] == 370 or skin['torso_1'] == 371 
					or skin['torso_1'] == 372 or skin['torso_1'] == 374 or skin['torso_1'] == 376 
					or skin['torso_1'] == 377 or skin['torso_1'] == 378 then
						skinRekawiczki = skin
						setUniform('rekawiczki1_wear', playerPed)
						hasRekawiczki = true
					elseif skin['torso_1'] == 365 then
						skinRekawiczki = skin
						setUniform('rekawiczki2_wear', playerPed)
						hasRekawiczki = true
					elseif skin['torso_1'] == 369 then
						skinRekawiczki = skin
						setUniform('rekawiczki3_wear', playerPed)
						hasRekawiczki = true
					elseif skin['torso_1'] == 375 then
						skinRekawiczki = skin
						setUniform('rekawiczki4_wear', playerPed)
						hasRekawiczki = true
					else
						ESX.ShowNotification("~r~Nie masz przy sobie rękawiczek do tego stroju")
					end
				end)
			end
		elseif data.current.value == 'worek' then
			menu.close()
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'actions_menu',
			{
				title    = 'San Andreas State Police',
				align    = 'center',
				elements = {
					{label = "Załóż", value = 'puton'},
					{label = "Zdejmij", value = 'putoff'},
				}
			}, function(data2, menu2)
				if data2.current.value == 'puton' then
					ESX.TriggerServerCallback('org:getItemAmount', function(qtty)
						if qtty > 0 then
							local player, distance = ESX.Game.GetClosestPlayer()
							local idkurwy = GetPlayerServerId(GetPlayerIndex())
							if distance ~= -1 and distance <= 1.0 then
								if not IsPedSprinting(PlayerPedId()) and not IsPedRagdoll(PlayerPedId()) and not IsPedRunning(PlayerPedId()) then
									TriggerServerEvent('atlantisHeadbag:setbagon', GetPlayerServerId(player), idkurwy, 'puton')
								end
							else
								ESX.ShowNotification('Brak graczy w pobliżu.')
							end
						else
							ESX.ShowNotification('~r~Nie posiadasz przy sobie worka!')
						end
					end, 'worek')
				elseif data2.current.value == 'putoff' then
					local player, distance = ESX.Game.GetClosestPlayer()
					local idkurwy = GetPlayerServerId(GetPlayerIndex())
					if distance ~= -1 and distance <= 1.0 then
						if not IsPedSprinting(PlayerPedId()) and not IsPedRagdoll(PlayerPedId()) and not IsPedRunning(PlayerPedId()) then
							TriggerServerEvent('atlantisHeadbag:setbagon', GetPlayerServerId(player), idkurwy, 'putoff')
						end
					else
						ESX.ShowNotification('Brak graczy w pobliżu.')
					end
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'search_database2' then
			SearchSIM()
		elseif data.current.value == 'search_database3' then
			SearchSERIAL()
		elseif data.current.value == 'lorneta' then
			TriggerEvent('exile_lorneta:lornetaon')
			menu.close()
		elseif data.current.value == 'citizen_interaction' then
			HandcuffMenu()
		elseif data.current.value == 'vehicle_interaction' then
			local elements2  = {}
			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)
	
			if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
				if not IsPedInAnyVehicle(playerPed, false) then
					table.insert(elements2, {label = _U('pick_lock'),	value = 'hijack_vehicle'})
					table.insert(elements2, {label = "Napraw pojazd", value = 'fix_vehicle'})
				  
					if PlayerData.job.name == 'police' then
						table.insert(elements2, {label = "Odholuj pojazd",			value = 'impound'})
						table.insert(elements2, {label = "Zajmij pojazd na parking policyjny",		value = 'impoundpd'})						
					end
				end
			end
		  
			table.insert(elements2, {label = ('Wyszukiwanie w bazie danych rejestracji'), value = 'search_database'})
		  
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_interaction', {
				title    = 'Interakcje z pojazdem',
				align    = 'center',
				elements = elements2
			}, function(data2, menu2)
				local action    = data2.current.value
				if action == 'search_database' or IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
					local vehicle = ESX.Game.GetVehicleInDirection()
					if IsPedSittingInAnyVehicle(playerPed) then
						ESX.ShowNotification('Nie możesz tego w aucie zrobić!')
						return
					end
					if action == 'search_database' then
						LookupVehicle()
					elseif DoesEntityExist(vehicle) then
						if action == 'hijack_vehicle' then
							if(not IsPedInAnyVehicle(playerPed)) then
								TriggerServerEvent('exile:pay', 1500)
								menu.close()
								TriggerEvent('esx_mechanicjobdrugi:onHijack')
							end
						elseif action == 'fix_vehicle' then
							if(not IsPedInAnyVehicle(playerPed)) then
								TriggerEvent('esx_mechanicjobdrugi:onFixkitFree')
								TriggerServerEvent('exile:pay', 500)
							end
						elseif action == 'impound' then
							if CurrentTask.Busy then
								return
							end

							SetTextComponentFormat('STRING')
							AddTextComponentString('Naciśnij ~INPUT_CONTEXT~ żeby unieważnić ~y~zajęcie~s~')
							DisplayHelpTextFromStringLabel(0, 0, 1, -1)
							TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
							CurrentTask.Busy = true
							CurrentTask.Task = ESX.SetTimeout(10000, function()
								ClearPedTasks(playerPed)
								TriggerEvent("esx_impound", 'cos')
								CurrentTask.Busy = false
								Citizen.Wait(100)
							end)

							CreateThread(function()
								while CurrentTask.Busy do
									Citizen.Wait(1000)
									vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
									if not DoesEntityExist(vehicle) and CurrentTask.Busy then
										ESX.ShowNotification('~r~Zajęcie zostało anulowane, ponieważ pojazd przemieścił się')
										ESX.ClearTimeout(CurrentTask.Task)

										ClearPedTasks(playerPed)
										CurrentTask.Busy = false
										break
									end
								end
							end)
						elseif action == 'impoundpd' then
							if CurrentTask.Busy then
								return
							end
							SetTextComponentFormat('STRING')
							AddTextComponentString('Naciśnij ~INPUT_CONTEXT~ żeby unieważnić ~y~zajęcie na parking policyjny~s~')
							DisplayHelpTextFromStringLabel(0, 0, 1, -1)
							TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
							CurrentTask.Busy = true
							CurrentTask.Task = ESX.SetTimeout(10000, function()
								ClearPedTasks(playerPed)
								TriggerEvent("esx_impound", 'cos', 'cos')

								CurrentTask.Busy = false
								Citizen.Wait(100)
							end)

							CreateThread(function()
								while CurrentTask.Busy do
									Citizen.Wait(1000)

									vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
									if not DoesEntityExist(vehicle) and CurrentTask.Busy then
										ESX.ShowNotification('~r~Zajęcie zostało anulowane, ponieważ pojazd przemieścił się')
										ESX.ClearTimeout(CurrentTask.Task)

										ClearPedTasks(playerPed)
										CurrentTask.Busy = false
										break
									end
								end
							end)							
						end
					end
				end
		  end, function(data2, menu2)
			  menu2.close()
		  end)
		elseif data.current.value == 'object_spawner' then
			if not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
					title    = _U('traffic_interaction'),
					align    = 'center',
					elements = {
						{label = _U('cone'),		value = 'prop_roadcone02a'},
						{label = _U('barrier'),		value = 'prop_barrier_work05'},
						{label = _U('spikestrips'),	value = 'p_ld_stinger_s'},
						{label = _U('cash'),		value = 'hei_prop_cash_crate_half_full'}
					}
				}, function(data2, menu2)
					local playerPed = PlayerPedId()
					local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
					local objectCoords = (coords + forward * 1.0)
					
					ESX.Game.SpawnObject(data2.current.value, objectCoords, function(obj)					
						SetEntityHeading(obj, tonumber(GetEntityHeading(playerPed)))
						PlaceObjectOnGroundProperly(obj)
						
						if data2.current.value == 'prop_barrier_work05' then
							FreezeEntityPosition(obj, true)
							SetEntityCollision(obj, true)
						end
					end)
				end, function(data2, menu2)
					menu2.close()
				end)
			else
				ESX.ShowNotification("~r~Nie możesz używać tego w pojeździe!")
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end

CreateThread(function()
	local object
	while true do
		Citizen.Wait(200)
		local coords = GetEntityCoords(PlayerPedId())

		local pass = false
		if not object or object == 0 then
			pass = true
		elseif not DoesEntityExist(object) or #(coords - GetEntityCoords(object)) > 50.0 then
			pass = true
		end

		if pass then
			object = GetClosestObjectOfType(coords.x, coords.y, coords.z, 50.0, `p_ld_stinger_s`, false, false, false)
		end

		if object and object ~= 0 then
			for _, vehicle in ipairs(ESX.Game.GetVehicles()) do
				local position = GetEntityCoords(vehicle)
				if #(position - coords) <= 30.0 then
					local closest = GetClosestObjectOfType(position.x, position.y, position.z, 1.5, `p_ld_stinger_s`, false, false, false)
					if closest and closest ~= 0 then
						for i = 0, 7 do
							if not IsVehicleTyreBurst(vehicle, i, true) then
								SetVehicleTyreBurst(vehicle, i, true, 1000)
							end
						end
					end
				end
			end
		end
	end
end)
  
function DrawText3D(x, y, z, text, scale)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 255)
	SetTextOutline()

	AddTextComponentString(text)
	DrawText(_x, _y)

	local factor = (string.len(text)) / 270
	DrawRect(_x, _y + 0.015, 0.005 + factor, 0.03, 31, 31, 31, 155)
end
  
local timeLeft = nil
CreateThread(function()
	while true do
		Citizen.Wait(2)
		if timeLeft ~= nil then
			local coords = GetEntityCoords(PlayerPedId())
			DrawText3D(coords.x, coords.y, coords.z + 0.1, timeLeft .. '~g~%', 0.4)
		else
			Citizen.Wait(500)
		end
	end
end)
  
RegisterNetEvent('esx_jobpolice:playAnim')
AddEventHandler('esx_jobpolice:playAnim', function(dict, anim)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(0)
	end
	TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, -8.0, -1, 49, 0, false, false, false)
end)

function OpenBodySearchMenu(target)
	local serverId = GetPlayerServerId(target)
	
	ESX.TriggerServerCallback('esx_policejob:checkSearch', function(status)
		if status then
			ESX.ShowNotification("~r~Ta osoba jest już przeszukiwana przez kogoś!") 
		else
			TriggerEvent('esx_jobpolice:playAnim', 'anim@gangops@facility@servers@bodysearch@', 'player_search')
			ESX.TriggerServerCallback('xlem0n_policejob:getOtherPlayerData', function(data)
				local elements = {}			
				if data.money > 0 then
					table.insert(elements, {
						label      = data.money .. '$ [gotówka]',
						value      = 'money',
						type   = 'item_money',
						amount     = data.money,
					})
				end
				
				for i=1, #data.accounts, 1 do
					if data.accounts[i].money > 0 then
						if data.accounts[i].name == 'black_money' then
							table.insert(elements, {
								label    = data.accounts[i].money .. '$ [nieopodatkowana gotówka]',
								value    = 'black_money',
								type     = 'item_account',
								amount   = data.accounts[i].money
							})
							break
						end
					end
				end

				for i=1, #data.inventory, 1 do
					if data.inventory[i].count > 0 then
						if data.inventory[i].label ~= nil then
							table.insert(elements, {
								label    = data.inventory[i].label .. " x" .. data.inventory[i].count,
								value    = data.inventory[i].name,
								type     = 'item_standard',
								amount   = data.inventory[i].count
							})
						end
					end
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
					title    = _U('search'),
					align    = 'right',
					elements = elements
				}, function(data, menu)
					local itemType = data.current.type
					local itemName = data.current.value
					local amount   = data.current.amount
					local playerCoords = GetEntityCoords(PlayerPedId())
					local targetCoords = GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, target))
		
					if data.current.value ~= nil then
						ESX.TriggerServerCallback('esx_policejob:checkSearch2', function(cb)
							if cb == true then
								ClearPedTasksImmediately(PlayerPedId())
								ESX.UI.Menu.CloseAll()
								if #(playerCoords - targetCoords) <= 3.0 then
									TriggerServerEvent('xlem0n_policejob:confiscatePlayerItem', serverId, itemType, itemName, amount)
									OpenBodySearchMenu(target)
								end
							else
							end
						end, serverId)
					end
				end, function(data, menu)
					ClearPedTasksImmediately(PlayerPedId())
					menu.close()
				end, nil, function()
					ClearPedTasksImmediately(PlayerPedId())
					TriggerServerEvent('esx_policejob:cancelSearch', serverId)
				end)
			end, serverId)
		end
	end, serverId)
end

local CombatLogi = {}

RegisterNetEvent("csskrouble:offlineLoot", function(license, coords) 
	if #(GetEntityCoords(PlayerPedId()) - vector3(coords.x, coords.y, coords.z)) < 85.0 then 
		table.insert(CombatLogi, {a=license, b=coords})
		CreateThread(function() 
			Citizen.Wait(25000)
			for i,v in ipairs(CombatLogi) do
				if v.a == license then
					ESX.UI.Menu.CloseAll()
					table.remove(CombatLogi, i)
				end	
			end	
		end)
	end
end)
function BodySearchOffline() 
	local c = nil
	local d = nil
	for i,v in ipairs(CombatLogi) do
		if #(GetEntityCoords(PlayerPedId()) - vector3(v.b.x, v.b.y, v.b.z)) < 5.0 then
			c = v.a
			d = vector3(v.b.x, v.b.y, v.b.z)
			break
		end	
	end	
	if c == nil then return end
	local serverId = c
	ESX.TriggerServerCallback('esx_policejob:checkSearch1', function(status)
		if status then
			ESX.ShowNotification("~r~Ta osoba jest już przeszukiwana przez kogoś!") 
		else
			ESX.TriggerServerCallback('xlem0n_policejob:getOtherPlayerData1', function(data)
				if not data then return end
				local elements = {}			
				if data.money > 0 then
					table.insert(elements, {
						label      = data.money .. '$ [gotówka]',
						value      = 'money',
						type   = 'item_money',
						amount     = data.money,
					})
				end
				
				for i=1, #data.accounts, 1 do
					if data.accounts[i].money > 0 then
						if data.accounts[i].name == 'black_money' then
							table.insert(elements, {
								label    = data.accounts[i].money .. '$ [nieopodatkowana gotówka]',
								value    = 'black_money',
								type     = 'item_account',
								amount   = data.accounts[i].money
							})
							break
						end
					end
				end

				for i=1, #data.inventory, 1 do
					if data.inventory[i].count > 0 then
						if data.inventory[i].label ~= nil then
							table.insert(elements, {
								label    = data.inventory[i].label .. " x" .. data.inventory[i].count,
								value    = data.inventory[i].name,
								type     = 'item_standard',
								amount   = data.inventory[i].count
							})
						end
					end
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
					title    = _U('search'),
					align    = 'right',
					elements = elements
				}, function(data, menu)
					local itemType = data.current.type
					local itemName = data.current.value
					local amount   = data.current.amount
					local playerCoords = GetEntityCoords(PlayerPedId())
					local targetCoords = d
		
					if data.current.value ~= nil then
						ESX.TriggerServerCallback('esx_policejob:checkSearch3', function(cb)
							if cb == true then
								ESX.UI.Menu.CloseAll()
								if #(playerCoords - targetCoords) <= 10.0 then
									TriggerServerEvent('xlem0n_policejob:confiscatePlayerItem1', serverId, itemType, itemName, amount)
									BodySearchOffline()
								end
							else
							end
						end, serverId)
					end
				end, function(data, menu)
					menu.close()
				end, nil, function()
					TriggerServerEvent('esx_policejob:cancelSearch1', serverId)
				end)
			end, serverId)
		end
	end, serverId)
end

function LookupVehicle()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'lookup_vehicle', {
		title ='Wyszukaj w bazie danych policyjnej',
	}, function(data, menu)
		local length = string.len(data.value)
		if data.value == nil or length < 2 or length > 13 then
			ESX.ShowNotification(_U('search_database_error_invalid'))
		else
			ESX.TriggerServerCallback('xlem0n_policejob:getVehicleFromPlate', function(owner, found)
				ESX.ShowNotification('~r~Sprawdzanie rejestracji')
				Citizen.Wait(4000)
				if found then
					ESX.ShowNotification(_U('search_database_found', owner))
				else
					ESX.ShowNotification('Ten ~y~numer rejestracyjny~s~  ~r~nie zostal~s~ zarejestrowany lub ~y~samochod jest ~r~kradziony!')
				end
			end, data.value)
			
			menu.close()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function SearchSIM()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'lookup_vehicle', {
		title = 'Wyszukaj w bazie danych policyjnej',
	}, function(data, menu)
		local length = string.len(data.value)
		if data.value == nil or length < 6 or length > 6 then
			ESX.ShowNotification(_U('search_database_error_invalid'))
		else
			ESX.TriggerServerCallback('xlem0n_policejob:getSIM', function(identifier, found)
				ESX.ShowNotification('~r~Sprawdzanie numeru ~g~SIM')
				Citizen.Wait(4000)
				if found then
					ESX.ShowNotification(_U('search_database_found', identifier))
				else
					ESX.ShowNotification('Ten ~y~numer SIM~s~ ~r~nie został~s~ zarejestrowany!')
				end
			end, data.value)
			
			menu.close()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function SearchSERIAL()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'lookup_vehicle', {
		title = 'Wyszukaj w bazie danych policyjnej',
	}, function(data, menu)
		local length = string.len(data.value)
		if data.value == nil or length < 10 or length > 10 then
			ESX.ShowNotification(_U('search_database_error_invalid'))
		else
			ESX.TriggerServerCallback('xlem0n_policejob:getSERIAL', function(serial_number, found)
				ESX.ShowNotification('~r~Sprawdzanie numeru ~g~seryjnego bronii')
				Citizen.Wait(4000)
				if found then
					ESX.ShowNotification(_U('search_database_found', serial_number))
				else
					ESX.ShowNotification('Ten ~y~numer seryjny~s~ ~r~nie został~s~ zarejestrowany!')
				end
			end, data.value)
			menu.close()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function ShowPlayerLicense(player)
	local elements = {}
	local targetName
	ESX.TriggerServerCallback('xlem0n_policejob:getOtherPlayerData', function(data)
		if data.licenses ~= nil then
			for i=1, #data.licenses, 1 do
				if data.licenses[i].label ~= nil and data.licenses[i].type ~= nil then
					table.insert(elements, {label = data.licenses[i].label, value = data.licenses[i].type})
				end
			end
		end
	  
		if Config.EnableESXIdentity then
			targetName = data.firstname .. ' ' .. data.lastname
		else
			targetName = data.name
		end
	  
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_license', {
			title    = _U('license_revoke'),
			align    = 'right',
			elements = elements,
		}, function(data, menu)
			ESX.ShowNotification(_U('licence_you_revoked', data.current.label, targetName))
			TriggerServerEvent('xlem0n_policejob:message', GetPlayerServerId(player), _U('license_revoked', data.current.label))
			TriggerServerEvent('esx_license:removeLicense', GetPlayerServerId(player), data.current.value)
		  
			ESX.SetTimeout(300, function()
				ShowPlayerLicense(player)
			end)
		end, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end
  
  
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job, response)
	PlayerData.job = job
end)
  
RegisterNetEvent('esx:setHiddenJob')
AddEventHandler('esx:setHiddenJob', function(hiddenjob)
	PlayerData.hiddenjob = hiddenjob
end)
  
AddEventHandler('xlem0n_policejob:hasEnteredMarker', function(station, partNum)
	if station == 'Cloakrooms' then
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	elseif station == 'Pharmacy' then
		CurrentAction		= 'menu_pharmacy'
		CurrentActionMsg	= _U('open_pharmacy')
		CurrentActionData	= {}	
	elseif station == 'SERTArmory' then
		CurrentAction = 'menu_sert_armory'
		CurrentActionMsg = "Naciśnij ~INPUT_CONTEXT~, aby otworzyć zbrojownię SERT"
		CurrentActionData = {}
	elseif station == 'SWATArmory' then
		CurrentAction = 'menu_swat_armory'
		CurrentActionMsg = "Naciśnij ~INPUT_CONTEXT~, aby otworzyć zbrojownię SWAT"
		CurrentActionData = {}
	elseif station == 'HCArmory' then
		CurrentAction = 'menu_hc_armory'
		CurrentActionMsg = "Naciśnij ~INPUT_CONTEXT~, aby otworzyć zbrojownię High Command"
		CurrentActionData = {}
	elseif station == 'Vehicles' then
		CurrentAction     = 'menu_vehicle_spawner'
		CurrentActionMsg  = _U('vehicle_spawner')
		CurrentActionData = {partNum = partNum}
	elseif station == 'Lodzie' then
		CurrentAction     = 'menu_lodzie_spawner'
		CurrentActionMsg  = _U('lodzie_spawner')
		CurrentActionData = {partNum = partNum}
	elseif station == 'Helicopters' then
		CurrentAction = 'menu_helicopter_spawner'
		CurrentActionMsg = "Naciśnij ~INPUT_CONTEXT~, aby wyciągnąć helikopter"
		CurrentActionData = {partNum = partNum}
	elseif station == 'VehicleDodatki' then
		CurrentAction = 'menu_dodatki'
		CurrentActionMsg = "Naciśnij ~INPUT_CONTEXT~, aby otworzyć menu dodatków do pojazdu"
		CurrentActionData = {}
	elseif station == 'VehicleDeleters' then
	  local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed,  false) then
			local vehicle = GetVehiclePedIsIn(playerPed, false)

			if DoesEntityExist(vehicle) then
				CurrentAction     = 'delete_vehicle'
				CurrentActionMsg  = _U('store_vehicle')
				CurrentActionData = {vehicle = vehicle}
			end
		end
	elseif station == 'BossActions' then
		CurrentAction     = 'menu_boss_actions'
		CurrentActionMsg  = _U('open_bossmenu')
		CurrentActionData = {}
	elseif station == 'SkinMenu' then
		CurrentAction = 'menu_skin'
		CurrentActionMsg = "Naciśnij ~INPUT_CONTEXT~ aby się przebrać"
		CurrentActionData = {}
	elseif station == 'ChangeJob' then
		CurrentAction = 'change_job'
		CurrentActionMsg = "Naciśnij ~INPUT_CONTEXT~ pobrać drugą odznakę"
		CurrentActionData = {}
	end
end)
  
AddEventHandler('xlem0n_policejob:hasExitedMarker', function(station, partNum)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

RegisterNetEvent('xlem0n_policejob:handcuffhype')
AddEventHandler('xlem0n_policejob:handcuffhype', function()
	local closestPlayer = ESX.Game.GetClosestPlayer()
	IsHandcuffed    = not IsHandcuffed
	local playerPed = PlayerPedId()
	
	ESX.ShowNotification('~o~Zostałeś zakuty/rozkuty przez ~g~[' .. GetPlayerServerId(closestPlayer) ..']')

	local playerPed = PlayerPedId()
	
	CreateThread(function()
		if IsHandcuffed then
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if not exports['exile_trunk']:checkInTrunk() then
				RequestAnimDict('mp_arresting')
				while not HasAnimDictLoaded('mp_arresting') do
					Citizen.Wait(0)
				end

				if not IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) then
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, 1.0, -1, 49, 0.0, 0, 0, 0)
				end
			end
			
			ESX.UI.Menu.CloseAll()
			TriggerEvent('radar:setHidden', true)
			TriggerEvent('carhud:display', false)
			SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
			DisablePlayerFiring(playerPed, true)
			SetEnableHandcuffs(playerPed, true)
			SetPedCanPlayGestureAnims(playerPed, false)
			TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "Cuff", 0.5)
			StartHandcuffTimer()
		else
			TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "Uncuff", 0.5)
				Citizen.InvokeNative(0xAAA34F8A7CB32098, playerPed)
			if Config.EnableHandcuffTimer and HandcuffTimer then
				ESX.ClearTimeout(HandcuffTimer)
			end
			SetEnableHandcuffs(playerPed, false)
			DisablePlayerFiring(playerPed, false)
			SetPedCanPlayGestureAnims(playerPed, true)
			TriggerEvent('radar:setHidden', false)
			TriggerEvent('carhud:display', true)
			FreezeEntityPosition(playerPed, false)
			
			if exports['exile_trunk']:checkInTrunk() then
				TaskPlayAnim(playerPed, "fin_ext_p1-7", "cs_devin_dual-7", 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)
			end
		end
	end)

end)
	
RegisterNetEvent('xlem0n_policejob:unrestrain')
AddEventHandler('xlem0n_policejob:unrestrain', function()
	if IsHandcuffed then
		IsHandcuffed = false
		TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 4.5, 'odkuj', 0.2)
		local playerPed = PlayerPedId()
			Citizen.InvokeNative(0xAAA34F8A7CB32098, playerPed)
		if Config.EnableHandcuffTimer and HandcuffTimer then
			ESX.ClearTimeout(HandcuffTimer)
		end

		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
		TriggerEvent('radar:setHidden', false)
		TriggerEvent('carhud:display', true)
		FreezeEntityPosition(playerPed, false)
	end
end)

  
RegisterNetEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(cop)
	if IsHandcuffed or IsPlayerDead(PlayerId()) then
		IsDragged = not IsDragged
		CopPlayer = tonumber(cop)
	end
end)

RegisterNetEvent('esx_policejob:dragging')
AddEventHandler('esx_policejob:dragging', function(target, dropped)
	DraggingLokal = false
	if not dropped then
		Dragging = target
	elseif Dragging == target then
		Dragging = nil
	end
end)

CreateThread(function()
	local attached = false
	while true do
		if Dragging then
			local ped = PlayerPedId()			
			SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
			Citizen.Wait(100)
		elseif IsHandcuffed or IsPlayerDead(PlayerId()) or isDead then
			local playerPed = PlayerPedId()
			if IsDragged then
				if not attached then
					attached = true
					FreezeEntityPosition(playerPed, true)
					AttachEntityToEntity(playerPed, Citizen.InvokeNative(0x43A66C31C68491C0, GetPlayerFromServerId(CopPlayer)), 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
					TriggerServerEvent('esx_policejob:dragging', CopPlayer, GetPlayerServerId(PlayerId()))
				end
			elseif CopPlayer then
				DetachEntity(playerPed, true, false)
				FreezeEntityPosition(playerPed, false)

				TriggerServerEvent('esx_policejob:dragging', CopPlayer)
				attached = false
				CopPlayer = nil
			end
			Citizen.Wait(10)
		else
			if IsDragged then
				local playerPed = PlayerPedId()
				DetachEntity(playerPed, true, false)
				TriggerServerEvent('esx_policejob:dragging', CopPlayer)

				local coords = GetEntityCoords(playerPed, true)
				RequestCollisionAtCoord(coords.x, coords.y, coords.z)

				attached = false
				CopPlayer = nil
				IsDragged = false
			end
			Citizen.Wait(500)
		end	
	end
end)

RegisterNetEvent('esx_policejob:putInTrunk')
AddEventHandler('esx_policejob:putInTrunk', function(cop)
	if IsHandcuffed then				
		TriggerEvent('exile:forceInTrunk', cop)
	end
end)

RegisterNetEvent('esx_policejob:OutTrunk')
AddEventHandler('esx_policejob:OutTrunk', function(cop)
	if IsHandcuffed then
		RequestAnimDict('mp_arresting')
		while not HasAnimDictLoaded('mp_arresting') do
			Citizen.Wait(1)
		end
		TriggerEvent('exile:forceOutTrunk', cop)
		TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
	else
		TriggerEvent('exile:forceOutTrunk', cop)
	end
end)

RegisterNetEvent('xlem0n_policejob:putInVehicle')
AddEventHandler('xlem0n_policejob:putInVehicle', function()
	if IsHandcuffed or isDead then
		local playerPed = PlayerPedId()

		local vehicle = nil
		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = ESX.Game.GetVehicleInDirection()
			if not vehicle then
				local coords = GetEntityCoords(playerPed, false)
				if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
					vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
				end
			end
		end
		if vehicle and vehicle ~= 0 then
			local maxSeats =  GetVehicleMaxNumberOfPassengers(vehicle)
			if maxSeats >= 0 then
				local freeSeat
				for i = (maxSeats - 1), 0, -1 do
					if IsVehicleSeatFree(vehicle, i) then
						freeSeat = i
						break
					end
				end
				if freeSeat ~= nil then		
					ClearPedTasksImmediately(playerPed)			
					local tick = 20
					repeat
						TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
						tick = tick - 1
						Citizen.Wait(50)
					until IsPedInAnyVehicle(playerPed, false) or tick == 0
					TriggerEvent('exile_blackout:belt', true)
				end
			end
		end
	end
end)
  
RegisterNetEvent('xlem0n_policejob:OutVehicle')
AddEventHandler('xlem0n_policejob:OutVehicle', function()
	if IsHandcuffed or isDead then
		local playerPed = PlayerPedId()
		if IsPedSittingInAnyVehicle(playerPed) then
			local vehicle = GetVehiclePedIsIn(playerPed, false)
			TaskLeaveVehicle(playerPed, vehicle, 16)
			if not exports['exile_trunk']:checkInTrunk() then
				RequestAnimDict('mp_arresting')
				while not HasAnimDictLoaded('mp_arresting') do
					Citizen.Wait(0)
				end

				TriggerEvent('misiaczek:belt', false)
				TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, 1.0, -1, 49, 0.0, 0, 0, 0)
			end
			CreateThread(function() 
				Citizen.Wait(300)
				ClearPedTasksImmediately(playerPed)
			end)
		end
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(10)
		
		if IsHandcuffed then
			if IsFirstHandcuffTick then
				IsFirstHandcuffTick = false
				ESX.UI.Menu.CloseAll()
			end

			DisableControlAction(2, 24, true)
			DisableControlAction(2, 257, true) 
			DisableControlAction(2, 25, true)
			DisableControlAction(2, 263, true)
			DisableControlAction(2, Keys['R'], true)
			DisableControlAction(2, Keys['TOP'], true) 
			DisableControlAction(2, Keys['SPACE'], true) 
			DisableControlAction(2, Keys['Q'], true) 
			DisableControlAction(2, Keys['~'], true) 
			DisableControlAction(2, Keys['Y'], true) 
			DisableControlAction(2, Keys['B'], true)
			DisableControlAction(2, Keys['TAB'], true) 
			DisableControlAction(2, Keys['F1'], true)
			DisableControlAction(2, Keys['F2'], true) 
			DisableControlAction(2, Keys['F3'], true) 
			DisableControlAction(2, Keys['F6'], true)
			DisableControlAction(2, Keys['LEFTSHIFT'], true)
			DisableControlAction(2, Keys['V'], true) 
			DisableControlAction(2, Keys['P'], true) 
			DisableControlAction(2, 59, true) 
			DisableControlAction(2, Keys['LEFTCTRL'], true) 
			DisableControlAction(0, 47, true) 
			DisableControlAction(0, 264, true) 
			DisableControlAction(0, 257, true) 
			DisableControlAction(0, 140, true) 
			DisableControlAction(0, 141, true) 
			DisableControlAction(0, 142, true) 
			DisableControlAction(0, 143, true)
			DisableControlAction(0, 56, true)

			local playerPed = PlayerPedId()
			if not IsPedCuffed(playerPed) then
				SetEnableHandcuffs(playerPed, true)
			end
			if IsPedInAnyPoliceVehicle(playerPed) then
				DisableControlAction(0, 75, true) 
				DisableControlAction(27, 75, true)
			end
			RequestAnimDict('mp_arresting')
            while not HasAnimDictLoaded('mp_arresting') do
                Citizen.Wait(0)
            end
            if not IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) and not exports['exile_trunk']:checkInTrunk() then
				TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, 1.0, -1, 49, 1.0, 0, 0, 0)
            end
		else
			SetEnableHandcuffs(playerPed, false)
			IsFirstHandcuffTick = true
			Citizen.Wait(500)
		end
	end
end)
  

CreateThread(function()
	while PlayerData.job == nil do
		Citizen.Wait(500)
	end
	
	for i=1, #Config.Blips, 1 do
		local blip = AddBlipForCoord(Config.Blips[i].Pos)

		SetBlipSprite (blip, Config.Blips[i].Sprite)
		SetBlipDisplay(blip, Config.Blips[i].Display)
		SetBlipScale  (blip, Config.Blips[i].Scale)
		SetBlipColour (blip, Config.Blips[i].Colour)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.Blips[i].Label)
		EndTextCommandSetBlipName(blip)
	end
	
	if PlayerData.job.name == 'police' or PlayerData.job.name == 'offpolice' then
		for i=1, #Config.PoliceStations.Lodzie, 1 do
			local blip = AddBlipForCoord(Config.PoliceStations.Lodzie[i].coords)

			SetBlipSprite (blip, 404)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 0.7)
			SetBlipColour (blip, 38)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Port SASP")
			EndTextCommandSetBlipName(blip)
		end
	end
end)

CreateThread(function()
	while PlayerData.job == nil do
		Citizen.Wait(100)
	end
	while true do
		Citizen.Wait(3)
		local found = false
		if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed)
			
			for k,v in pairs(Config.PoliceStations) do
				for i=1, #v, 1 do
					if k == "VehicleDeleters" or k == 'VehicleDodatki' then
						if #(coords - v[i].coords) < Config.DrawDistance then
							found = true
							ESX.DrawBigMarker(vec3(v[i].coords))
						end
					end
					if k ~= "VehicleDeleters" and k ~= 'VehicleDodatki' then
						if #(coords - v[i].coords) < Config.DrawDistance then
							found = true
							ESX.DrawMarker(v[i].coords)
						end
					end
				end
			end
			if not found then
				Citizen.Wait(2000)
			end
		else
			Citizen.Wait(2000)
		end
	end
end)

CreateThread(function()
	while PlayerData.job == nil do
		Citizen.Wait(100)
	end
	while true do
		Citizen.Wait(3)
		local found = false
		if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
			local playerPed      = PlayerPedId()
			local isInMarker     = false
			local currentStation = nil
			local currentPartNum = nil
			local coords = GetEntityCoords(playerPed)

			for k,v in pairs(Config.PoliceStations) do
				for i=1, #v, 1 do
					if k == "VehicleDeleters" or k == 'VehicleDodatki' then
						if #(coords - v[i].coords) < 3.0 then
							found = true
							isInMarker     = true
							currentStation = k
							currentPartNum = i
						end
					end
					
					if k ~= "VehicleDeleters" and k ~= 'VehicleDodatki' then
						if #(coords - v[i].coords) < Config.MarkerSize.x then
							found = true
							isInMarker     = true
							currentStation = k
							currentPartNum = i
						end
					end
				end
			end

			local hasExited = false

			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPartNum ~= currentPartNum)) then

				if (LastStation ~= nil and LastPartNum ~= nil) and (LastStation ~= currentStation or LastPartNum ~= currentPartNum) then
					TriggerEvent('xlem0n_policejob:hasExitedMarker', LastStation, LastPartNum)
					hasExited = true
				end

				HasAlreadyEnteredMarker = true
				LastStation             = currentStation
				LastPartNum             = currentPartNum
	
				TriggerEvent('xlem0n_policejob:hasEnteredMarker', currentStation, currentPartNum)
			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('xlem0n_policejob:hasExitedMarker', LastStation, LastPartNum)
			end
		  
			if not found then
				Citizen.Wait(1000)
			end
		else
			Citizen.Wait(2000)
		end
	end
end)
  
  
RegisterNetEvent('xlem0n_policejob:dodatkiGaraz')
AddEventHandler('xlem0n_policejob:dodatkiGaraz', function()
	local Gracz = PlayerPedId()
	if IsPedInAnyVehicle(Gracz, false) then
		local vehicle = GetVehiclePedIsIn(Gracz, false)
		OpenDodatkiGarazMenu()
	end
end)

function DodatkiGarazCommand()
	if PlayerData.job ~= nil and PlayerData.job.name == 'police' and PlayerData.job.grade >= 10 then
		local Gracz = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(Gracz, false)
		if IsPedInAnyVehicle(Gracz, false) then
			OpenDodatkiGarazMenu()
		end
	else
		ESX.ShowNotification('~r~Nie masz odpowiedniej rangi aby tego uzyc')
	end
end
  
RegisterCommand('dodatkisasp', function()
	DodatkiGarazCommand()
end, false)
  
function OpenDodatkiGarazMenu()
	local elements1 = {}
	local Gracz = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(Gracz, false)

	for ExtraID=0, 20 do
		if DoesExtraExist(vehicle, ExtraID) then
			if IsVehicleExtraTurnedOn(vehicle, ExtraID) == 1 then
				local tekstlabel = 'Dodatek '..tostring(ExtraID)..' - Zdemontuj'
				table.insert(elements1, {label = tekstlabel, posiada = true, value = ExtraID})
			elseif IsVehicleExtraTurnedOn(vehicle, ExtraID) == false then
				local tekstlabel = 'Dodatek '..tostring(ExtraID)..' - Podgląd'
				table.insert(elements1, {label = tekstlabel, posiada = false, value = ExtraID})
			end
		end
	end

	if #elements1 == 0 then
		table.insert(elements1, {label = 'Ten pojazd nie posiada dodatków!', posiada = nil, value = nil})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'sklep_dodatki_policja', {
		title    = 'Dodatki - Sklep',
		align    = 'left',
		elements = elements1
	}, function(data, menu)
		local dodatek2 = data.current.value
		if dodatek2 ~= nil then
			local dodatekTekst = 'extra'..dodatek2
			local posiada = data.current.posiada
			if posiada then
				menu.close()

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'sklep_dodatki_policja_usun', {
					title    = 'Zdemontować dodatek?',
					align    = 'left',
					elements = {
						{label = "Tak", value = "tak"},
						{label = "Nie", value = "nie"},
					}
				}, function(data2, menu2)
					local akcja = data2.current.value
					local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
					local tablica = vehicleProps.plate
					if akcja == 'tak' then
						SetVehicleExtra(vehicle, dodatek2, 1)
						TriggerServerEvent('xlem0n_policejob:DodatkiKup', tablica, dodatekTekst, false)
					elseif akcja == 'nie' then
						SetVehicleExtra(vehicle, dodatek2, 0)
					end
					menu2.close()
					Citizen.Wait(200)
					OpenDodatkiGarazMenu()
				end, function(data2, menu2)
					menu2.close()
				end)
				
			elseif posiada == false then
				SetVehicleExtra(vehicle, dodatek2, 0)
				menu.close()

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'sklep_dodatki_policja_kup', {
					title = 'Potwierdzić montaż?',
					align = 'left',
					elements = {
						{label = "Tak - Zamontuj", value = "tak"},
						{label = "Nie - Anuluj", value = "nie"},
					}
				}, function(data3, menu3)
					local akcja = data3.current.value
					local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
					local tablica = vehicleProps.plate
					if akcja == 'tak' then
						TriggerServerEvent('xlem0n_policejob:DodatkiKup', tablica, dodatekTekst, true)
					elseif akcja == 'nie' then
						SetVehicleExtra(vehicle, dodatek2, 1)
					end
					
					menu3.close()
					Citizen.Wait(200)
					OpenDodatkiGarazMenu()
				end, function(data3, menu3)
					menu3.close()
				end)
			end
		end
	end, function(data, menu)
		menu.close()
		CurrentAction = 'menu_dodatki'
		CurrentActionMsg = ""
		CurrentActionData = {}
	end)
end
	
function SpawnHelicopter(partNum)
	local helicopters = Config.PoliceStations.Helicopters

	if not IsAnyVehicleNearPoint(helicopters[partNum].spawnPoint.x, helicopters[partNum].spawnPoint.y, helicopters[partNum].spawnPoint.z,  3.0) then
		ESX.Game.SpawnVehicle('pd_heli', helicopters[partNum].spawnPoint, helicopters[partNum].heading, function(vehicle)
		  SetVehicleLivery(vehicle, 0)
		  local localVehPlate = string.lower(GetVehicleNumberPlateText(vehicle))
		  TriggerEvent('ls:dodajklucze2', localVehPlate)
	  end)
	end
end

CreateThread(function()
	while true do
		if PlayerData.job ~= nil and PlayerData.job.name == 'police'  then
			local playerPed = PlayerPedId()
			if not IsPedInAnyVehicle(playerPed, false) then
				local coords = GetEntityCoords(playerPed)

				local found = false
				for _, prop in ipairs({
					`prop_roadcone02a`,
					`prop_barrier_work06a`,
					`p_ld_stinger_s`,
					`prop_barrier_work05`
				}) do
					local object = GetClosestObjectOfType(coords.x,  coords.y,  coords.z,  2.0,  prop, false, false, false)
					if DoesEntityExist(object) then
						CurrentAction     = 'remove_entity'
						CurrentActionMsg  = _U('remove_prop')
						CurrentActionData = {entity = object}
						found = true
						break
					end
				end

				if not found and CurrentAction == 'remove_entity' then
					CurrentAction = nil
				end

				Citizen.Wait(100)
			else
				Citizen.Wait(1000)
			end
		else
			Citizen.Wait(1000)
		end
	end
end)
local animation = { lib = 'random@mugging3' , base = 'handsup_standing_base', enter = 'handsup_standing_enter', exit = 'handsup_standing_exit', fade = 1 }

function CanCuff(src,l) 
	local playerPed = src
	if l then
		playerPed = GetPlayerPed(src)
	end
	if not playerPed then return end
	local can = false
	if IsEntityPlayingAnim(playerPed, 'dead', 'dead_a', 3) or IsEntityPlayingAnim(playerPed, animation.lib, animation.base, 3) or IsEntityPlayingAnim(playerPed, animation.lib, animation.enter, 3) or IsEntityPlayingAnim(playerPed, animation.lib, animation.exit, 3) or IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) or IsEntityPlayingAnim(playerPed, 'random@mugging3', 'handsup_standing_enter', 3) or IsEntityPlayingAnim(playerPed, 'random@mugging3', 'handsup_standing_exit', 3) or IsEntityPlayingAnim(playerPed, 'mini@cpr@char_b@cpr_def', 'cpr_pumpchest_idle', 3) or IsEntityDead(playerPed) or IsPedBeingStunned(playerPed) or IsPedSwimming(playerPed) or IsPedSwimmingUnderWater(playerPed) or IsEntityPlayingAnim(playerPed, "missminuteman_1ig_2", "handsup_enter", 3) or IsEntityPlayingAnim(playerPed, "random@arrests@busted", "enter", 3) or IsEntityPlayingAnim(playerPed, "random@mugging3", "handsup_standing_base", 3) then
	can = true
	end
	if not l and IsEntityDead(playerPed) then
		can = false
	end
	return can
end

function RestrictedMenu()
	ESX.UI.Menu.CloseAll()
	
	TriggerEvent('skinchanger:getSkin', function(skin)
		currentSkin = skin
	end)
	
	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)
		menu.close()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
			title = _U('valid_this_purchase'),
			align = 'right',
			elements = {
				{label = _U('no'), value = 'no'},
				{label = _U('yes'), value = 'yes'}
			}
		}, function(data, menu)
			menu.close()

			local t = true
			if data.current.value == 'yes' then
				ESX.TriggerServerCallback('esx_clotheshop:buyClothes', function(bought)
					if bought then
						
						TriggerEvent('skinchanger:getSkin', function(skin)
							TriggerServerEvent('esx_skin:save', skin)
							currentSkin = skin
						end)

						ESX.TriggerServerCallback('esx_clotheshop:checkPropertyDataStore', function(foundStore)
							if foundStore then
								ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'save_dressing',
								{
									title = _U('save_in_dressing'),
									align = 'right',
									elements = {
										{label = _U('no'),  value = 'no'},
										{label = _U('yes'), value = 'yes'}
									}
								}, function(data2, menu2)
									menu2.close()

									if data2.current.value == 'yes' then
										ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'outfit_name', {
											title = _U('name_outfit')
										}, function(data3, menu3)
											menu3.close()

											TriggerEvent('skinchanger:getSkin', function(skin)
												TriggerServerEvent('esx_clotheshop:saveOutfit', data3.value, skin)
												ESX.ShowNotification('~g~Ubranie zostalo zapisane w domu\n~b~Nazwą zapisanego ubrania: ~g~'..data3.value)
												t = true												
											end)
										end, function(data3, menu3)
											menu3.close()
										end)
									end
								end)
							end
						end)

					else
						t = false
						ESX.ShowNotification(_U('not_enough_money'))
						cleanPlayer()
					end
				end)
			elseif data.current.value == 'no' then
				OpenShopMenu()
				t = false
			end
			
			if t then
				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_menu')
				CurrentActionData = {}
			end
		end, function(data, menu)
			menu.close()
			cleanPlayerskin()
		end)

	end, function(data, menu)
		menu.close()
		cleanPlayerskin()
		
		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('press_menu')
		CurrentActionData = {}
	end, {
		'tshirt_1',
		'tshirt_2',
		'torso_1',
		'torso_2',
		'decals_1',
		'decals_2',
		'arms',
		'pants_1',
		'pants_2',
		'shoes_1',
		'shoes_2',
		'chain_1',
		'chain_2',
		'watches_1',
		'watches_2',
		'helmet_1',
		'helmet_2',
		'mask_1',
		'mask_2',
		'glasses_1',
		'glasses_2',
		'bags_1',
		'bags_2',
		'bproof_1',
		'bproof_2'
	})
end

function OpenShopMenu()
	local elements = {
		{label = _U('shop_clothes'),  value = 'shop_clothes'},
		{label = ('Własne ubrania'), value = 'player_dressing'}
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_main', {
		title    = _U('shop_main_menu'),
		align    = 'left',
		elements = elements,
    }, function(data, menu)
		menu.close()
		if data.current.value == 'shop_clothes' then
			RestrictedMenu()
		end

		if data.current.value == 'player_dressing' then
			OpenClothes()
		end
    end, function(data, menu)
		menu.close()
		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('press_menu')
		CurrentActionData = {}
    end)
end

function OpenClothes()
	ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
		local elements = {}
		for k,v in pairs(dressing) do
			table.insert(elements, {label = v, value = k})
		end
		
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'dress_menu',{
			title    = 'Garderoba',
			align    = 'left',
			elements = elements
		}, function(data, menu)		
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing_opts', {
				title = 'Wybierz ubranie - ' .. data.current.label,
				align = 'center',
				elements = {
					{label = 'Ubierz', value = 'wear'},
					{label = 'Zmień nazwę', value = 'rename'},
					{label = 'Usuń ubranie', value = 'remove'}
				}
			}, function(data2, menu2)
				menu2.close()
				if data2.current.value == 'wear' then
					TriggerEvent('skinchanger:getSkin', function(skin)
						ESX.TriggerServerCallback('esx_property:getPlayerOutfit', function(clothes)
							TriggerEvent('skinchanger:loadClothes', skin, clothes)
							TriggerEvent('esx_skin:setLastSkin', skin)

							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
							end)
						end, data.current.value)
					end)
				elseif data2.current.value == 'rename' then
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'player_dressing_rename', {
						title = 'Zmień nazwę - ' .. data.current.label
					}, function(data3, menu3)
						menu3.close()
						TriggerServerEvent('esx_property:renameOutfit', data.current.value, data3.value)
						ESX.ShowNotification('Zmieniono nazwę ubrania!')
						OpenClothes()
					end, function(data3, menu3)
						menu3.close()
						menu2.open()
					end)
				elseif data2.current.value == 'remove' then
					TriggerServerEvent('esx_property:removeOutfit', data.current.value)
					ESX.ShowNotification('Ubranie usunięte z Twojej garderoby: ' .. data.current.label)
					OpenClothes()
				end
			end, function(data2, menu2)
				menu2.close()
				menu.open()
			end)		
		end, function(data, menu)
			menu.close()
			CurrentAction     = 'shop_menu'
			CurrentActionMsg  = _U('press_menu')
			CurrentActionData = {}
		end)
	end)
end

function cleanPlayerskin()
	TriggerEvent('skinchanger:loadSkin', currentSkin)
	currentSkin = nil
end

  
CreateThread(function()
	while true do
		Citizen.Wait(5)
		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'police' then
				if CurrentAction == 'menu_cloakroom' then
					OpenCloakroomMenu()
				elseif CurrentAction == 'menu_pharmacy' then
					OpenPharmacyMenu()
				elseif CurrentAction == 'menu_sert_armory' then
					OpenSERTArmoryMenu()
				elseif CurrentAction == 'menu_swat_armory' then
					OpenSWATArmoryMenu()
				elseif CurrentAction == 'menu_hc_armory' then
					OpenHCArmoryMenu()
				elseif CurrentAction == 'menu_vehicle_spawner' then
					OpenVehicleSpawnerMenu(CurrentActionData.partNum)
				elseif CurrentAction == 'delete_vehicle' then
					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
				elseif CurrentAction == 'menu_lodzie_spawner' then
					OpenLodzieSpawnerMenu(CurrentActionData.partNum)
				elseif CurrentAction == 'menu_helicopter_spawner' then
					ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
						if hasWeaponLicense then
							SpawnHelicopter(CurrentActionData.partNum)
						else
							ESX.ShowNotification("~r~Nie posiadasz odpowiedniej licencji")
						end
					end, GetPlayerServerId(PlayerId()), 'heli')
				elseif CurrentAction == 'menu_dodatki' then
					OpenDodatkiGarazMenu()
				elseif CurrentAction == 'menu_boss_actions' then
					ESX.UI.Menu.CloseAll()
					if (PlayerData.job.name == 'police' and PlayerData.job.grade >= 10) or (PlayerData.hiddenjob.name == 'sheriff' and PlayerData.hiddenjob.grade >= 11) then
						TriggerEvent('esx_society:openBossMenu', 'police', function(data, menu)
							menu.close()
							CurrentAction     = 'menu_boss_actions'
							CurrentActionMsg  = _U('open_bossmenu')
							CurrentActionData = {}
						end, { showmoney = true, withdraw = true, deposit = true, wash = true, employees = true, badges = true, licenses = true})
					else
						TriggerEvent('esx_society:openBossMenu', 'police', function(data, menu)
							menu.close()
							CurrentAction     = 'menu_boss_actions'
							CurrentActionMsg  = _U('open_bossmenu')
							CurrentActionData = {}
						end, { showmoney = false, withdraw = false, deposit = true, wash = true, employees = false, badges = false, licenses = false})
					end
				elseif CurrentAction == 'remove_entity' then
					DeleteEntity(CurrentActionData.entity)
				elseif CurrentAction == 'menu_skin' then
					OpenShopMenu()
				elseif CurrentAction == 'change_job' then
					OpenChangeJobMenu()
				end
			  
				CurrentAction = nil
			end
		else
			Wait(500)
		end
	end
end)
CreateThread(function()
	while true do
		Wait(0)
		if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
			if IsControlJustReleased(0, Keys['F6']) and not isDead and PlayerData.job ~= nil and PlayerData.job.name == 'police' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'police_actions') then
				OpenPoliceActionsMenu()
			end

			if IsControlPressed(0, Keys['LEFTSHIFT']) then
				DisableControlAction(0, Keys['Q'], true)
				if IsDisabledControlJustPressed(0, Keys['Q']) and not IsPedInAnyVehicle(PlayerPedId()) and not isDead and not IsHandcuffed and PlayerData.job ~= nil and PlayerData.job.name == 'police' then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer ~= -1 and closestDistance <= 3.0 and not IsPedInAnyVehicle(Citizen.InvokeNative(0x43A66C31C68491C0, closestPlayer)) then
						if CanCuff(closestPlayer, true) then
							animacjazakuciarozkuciaxd()
							Citizen.Wait(700)
							TriggerServerEvent('xlem0n_policejob:handcuffhype', GetPlayerServerId(closestPlayer))
							ESX.ShowNotification('~o~Zakułeś/Odkułeś ~g~[' .. GetPlayerServerId(closestPlayer) ..']')
						else
							ESX.ShowNotification("~r~Osoba którą próbujesz zakuć nie ma rąk w górze")
						end	
					else
						ESX.ShowNotification("~r~Brak osób w pobliżu")
					end
				end
				
				if IsControlJustPressed(0, Keys['E']) and not IsPedInAnyVehicle(PlayerPedId()) and not isDead and not IsHandcuffed and PlayerData.job ~= nil and PlayerData.job.name == 'police' then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer ~= -1 and closestDistance <= 3.0 then
						TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
					else
						ESX.ShowNotification("~r~Brak osób w pobliżu")
					end
				end
			end

			
			if IsControlJustReleased(0, Keys['E']) and CurrentTask.Busy then
				ESX.ShowNotification(_U('impound_canceled'))
				ESX.ClearTimeout(CurrentTask.Task)
				ClearPedTasks(PlayerPedId())
				
				CurrentTask.Busy = false
			end 
		else
			Wait(500)
		end
	end
end)
  
RegisterNetEvent('esx_policejob:removedGPS')
AddEventHandler('esx_policejob:removedGPS', function(data)
	ESX.ShowNotification("~r~Utracono połączenie z nadajnikiem ~w~\n" .. data.name)
	local alpha = 250
	local gpsBlip = AddBlipForCoord(data.coords)
	SetBlipSprite(gpsBlip, 280)
	SetBlipColour(gpsBlip, 3)
	SetBlipAlpha(gpsBlip, alpha)
	SetBlipScale(gpsBlip, 1.2)
	SetBlipAsShortRange(gpsBlip, false)
	SetBlipCategory(gpsBlip, 15)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("# OSTATNIA LOKALIZACJA " .. data.name)
	EndTextCommandSetBlipName(gpsBlip)
	
	for i=1, 25, 1 do
		PlaySound(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset", 0, 0, 1)
		Wait(300)
		PlaySound(-1, "OOB_Cancel", "GTAO_FM_Events_Soundset", 0, 0, 1)
		Wait(300)
	end
	
	while alpha ~= 0 do
		Citizen.Wait(180 * 4)
		alpha = alpha - 1
		SetBlipAlpha(gpsBlip, alpha)
		if alpha == 0 then
			RemoveBlip(gpsBlip)
			return
		end
	end
end)
  
AddEventHandler('playerSpawned', function(spawn)
	isDead = false
	TriggerEvent('xlem0n_policejob:unrestrain')
end)
  
AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)
  
AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('xlem0n_policejob:unrestrain')

		if Config.EnableHandcuffTimer and HandcuffTimer then
			ESX.ClearTimeout(HandcuffTimer)
		end
	end
end)
  

function StartHandcuffTimer()
	if Config.EnableHandcuffTimer and HandcuffTimer then
		ESX.ClearTimeout(HandcuffTimer)
	end
	
	HandcuffTimer = ESX.SetTimeout(Config.HandcuffTimer, function()
		ESX.ShowNotification("~y~Czujesz jak Twoje kajdanki luzują się...")
		TriggerEvent('xlem0n_policejob:unrestrain')
		TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 3, "Uncuff", 0.4)
	end)
end
  
function ImpoundVehicle(vehicle)
	ESX.Game.DeleteVehicle(vehicle) 
	ESX.ShowNotification(_U('impound_successful'))
	CurrentTask.Busy = false
end
  
RegisterNetEvent('Kajdanki')
AddEventHandler('Kajdanki', function()
	local ped = PlayerPedId()
	if not IsPedInAnyVehicle(ped, false) then
		HandcuffMenu()
	end
end)

function MenuBroni()
	local elements = {}
	
	for _,value in ipairs(Config.WeaponShop) do		
		if value.grade <= PlayerData.job.grade or value.job_name == PlayerData.job.grade_name then	
			if value.type == 'weapon' then
				table.insert(elements, {
					label = ESX.GetWeaponLabel(value.name) .. (value.price == 0 and ' [<span style="color:green;">DARMOWE</span>]' or ' [<span style="color:green;">'..value.price..'$</span>]'),
					value = value.name,
					price = value.price
				})
			else
				table.insert(elements, {
					label = value.label .. (value.price == 0 and ' [<span style="color:green;">DARMOWE</span>]' or ' [<span style="color:green;">'..value.price..'$</span>]'),
					value = value.name,
					price = value.price
				})
			end
		end
	end
	
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menubroni', {
		title    = 'Zbrojownia',
		align    = 'right',
		elements = elements
	}, function(data, menu)		
		TriggerServerEvent('xlem0n_policejob:giveWeapon', data.current.value, 250, data.current.price)
	end, function(data, menu)
		menu.close()
		
		OpenPharmacyMenu()
	end)
end
  
OpenSERTArmoryMenu = function()
	local elements = {
		{label = _U('put_weapon'),     value = 'put_weapon'}, 	
	}

	ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
		if hasWeaponLicense or (PlayerData.job and PlayerData.job.name == 'police' and PlayerData.job.grade >= 10) or (PlayerData.hiddenjob and PlayerData.hiddenjob.name == 'sheriff' and PlayerData.hiddenjob.grade >= 11) then
			table.insert(elements, {label = _U('get_weapon'),     value = 'get_weapon'})
		end
	end, GetPlayerServerId(PlayerId()), 'sert')
	
	Wait(100)
  
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'sert_armory', {
		title		= "Zbrojownia SERT",
		align		= 'right',			
		elements = elements
	}, function(data, menu)
		if data.current.value == 'put_weapon' then
			TriggerEvent('exile:putInventoryItem', 'society_sert')
		elseif data.current.value == 'get_weapon' then
			TriggerEvent('exile:getInventoryItem', 'society_sert')
		end
	end, function(data, menu)
		menu.close()

		CurrentAction		= 'menu_sert_armory'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby otworzyć zbrojownię SERT"
		CurrentActionData	= {}
	end)
end

OpenSWATArmoryMenu = function()
	local elements = {
			{label = _U('put_weapon'),     value = 'put_weapon'}, 	
}

ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
	if hasWeaponLicense or (PlayerData.job and PlayerData.job.name == 'police' and PlayerData.job.grade >= 10) or (PlayerData.hiddenjob and PlayerData.hiddenjob.name == 'sheriff' and PlayerData.hiddenjob.grade >= 11) then
		table.insert(elements, {label = _U('get_weapon'),     value = 'get_weapon'})
	end
end, GetPlayerServerId(PlayerId()), 'swat')

Wait(100)

ESX.UI.Menu.CloseAll()

ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'swat_armory', {
	title		= "Zbrojownia SWAT",
	align		= 'right',			
	elements = elements
}, function(data, menu)
	if data.current.value == 'put_weapon' then
		TriggerEvent('exile:putInventoryItem', 'society_swat')
	elseif data.current.value == 'get_weapon' then
		TriggerEvent('exile:getInventoryItem', 'society_swat')
	end
end, function(data, menu)
	menu.close()

	CurrentAction		= 'menu_swat_armory'
	CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby otworzyć zbrojownię SWAT"
	CurrentActionData	= {}
end)
end

OpenHCArmoryMenu = function()
	local elements = {
			{label = _U('put_weapon'),     value = 'put_weapon'}, 	
}

ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
	if hasWeaponLicense or (PlayerData.job and PlayerData.job.name == 'police' and PlayerData.job.grade >= 10) or (PlayerData.hiddenjob and PlayerData.hiddenjob.name == 'sheriff' and PlayerData.hiddenjob.grade >= 11) then
		table.insert(elements, {label = _U('get_weapon'),     value = 'get_weapon'})
	end
end, GetPlayerServerId(PlayerId()), 'hc')

Wait(100)

ESX.UI.Menu.CloseAll()

ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'hc_armory', {
	title		= "Zbrojownia High Command",
	align		= 'right',			
	elements = elements
}, function(data, menu)
	if data.current.value == 'put_weapon' then
		TriggerEvent('exile:putInventoryItem', 'society_highcommand')
	elseif data.current.value == 'get_weapon' then
		TriggerEvent('exile:getInventoryItem', 'society_highcommand')
	end
end, function(data, menu)
	menu.close()

	CurrentAction		= 'menu_hc_armory'
	CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby otworzyć zbrojownię High Command"
	CurrentActionData	= {}
end)
end
  
function OpenPharmacyMenu()
  
	local elements = {
		{label = 'Weź wyposażenie SASP / SASD', value = 'get_wypo'},
		{label = 'Weź wyposażenie SWAT / SERT / HC', value = 'get_wypo2'},
		{label = 'Weź broń SASP / SASD',     value = 'get_weapon'}, 	
		{label = _U('remove_object'),  value = 'get_stock'}, 		
		{label = _U('deposit_object'), value = 'put_stock'}, 
	}
  
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pharmacy', {
		title		= _U('pharmacy_menu_title'),
		align		= 'right',			
		elements = elements
	}, function(data, menu)
		if data.current.value == 'put_stock' then
			TriggerEvent('exile:putInventoryItem', 'society_police')
		elseif data.current.value == 'put_weapon' then
			TriggerEvent('exile:putInventoryItem', 'society_sert')
		elseif data.current.value == 'get_wypo' then
			OpenGetWypoMenu()
		elseif data.current.value == 'get_wypo2' then
			if PlayerData.job.grade >= 10 then
			OpenGetWypo2Menu()
			else
				ESX.ShowNotification('~r~Nie posiadasz dostępu do tego elementu!')
			end
		elseif data.current.value == 'get_weapon' then
			MenuBroni()
		elseif data.current.value == 'get_stock' then
			TriggerEvent('exile:getInventoryItem', 'society_police')
		end
	end, function(data, menu)
		menu.close()

		CurrentAction		= 'menu_pharmacy'
		CurrentActionMsg	= _U('open_pharmacy')
		CurrentActionData	= {}
	end)
end
  
function OpenGetWypoMenu()
	local elements = {
		{label = _U('pharmacy_takeflashlight', _U('flashlight')), value = 'flashlight', count = 1},
		{label = _U('pharmacy_takeclip', "Magazynek do pistoletu"), value = 'clip', count = 1},
		{label = _U('pharmacy_takeradio', "Gps"), value = 'gps', count = 1},
		{label = _U('pharmacy_takeradio', "BodyCam"), value = 'bodycam', count = 1},
		{label = _U('pharmacy_takeradio', "Panic Button"), value = 'panic', count = 1},
		{label = _U('pharmacy_takeradio', "Radio"), value = 'radio', count = 1},
	}
  
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_take_wposazenie', {
		title    = 'Wyposażenie',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		TriggerServerEvent('xlem0n_policejob:giveItem', data.current.value, data.current.count)
	end, function(data, menu)
		menu.close()
		
		OpenPharmacyMenu()
	end)
end

function OpenGetWypo2Menu()
	local elements = {
		{label = _U('pharmacy_takeflashlight', _U('flashlight')), value = 'flashlight', count = 1},
		{label = _U('pharmacy_takeopaska', "Opaska Lokalizacyjna"), value = 'opaska', count = 1},
		{label = _U('pharmacy_takeclip', "Magazynek do pistoletu"), value = 'clip', count = 1},
		{label = _U('pharmacy_takeradio', "Magazynek do broni długiej"), value = 'extendedclip', count = 1},
		{label = _U('pharmacy_takeradio', "IronSights"), value = 'ironsights', count = 1},
		{label = _U('pharmacy_takeradio', "Uchwyt"), value = 'grip', count = 1},
		{label = _U('pharmacy_takeradio', "Celownik"), value = 'scope', count = 1},
		{label = _U('pharmacy_takeradio', "Powiększony Magazynek"), value = 'clip_extended', count = 1},
		{label = _U('pharmacy_takeradio', "Tłumik"), value = 'suppressor', count = 1},
	}
  
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_take_wposazenie2', {
		title    = 'Wyposażenie',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		TriggerServerEvent('xlem0n_policejob:giveItem', data.current.value, data.current.count)
		TriggerServerEvent('exile_logs:triggerLog', "Gracz wyjął z Wyposażenia SWAT / SERT / HC item: " ..data.current.value.." w ilości: "..data.current.count, 'wyposazenieswatsert')
	end, function(data, menu)
		menu.close()
		
		OpenPharmacyMenu()
	end)
end
  
function loadanimdict(dictname)
	if not HasAnimDictLoaded(dictname) then
		RequestAnimDict(dictname) 
		while not HasAnimDictLoaded(dictname) do 
			Citizen.Wait(1)
		end
	end
end

  
function animacjazakuciarozkuciaxd()
	local ad = "mp_arresting"
	local anim = "a_uncuff"
	local player = PlayerPedId()

	if ( DoesEntityExist(player) and not IsEntityDead(player) and not isDead) then
		loadAnimDict(ad)
		if (IsEntityPlayingAnim(player, ad, anim, 8)) then
			TaskPlayAnim(player, ad, "exit", 8.0, 3.0, 2000, 26, 1, 0, 0, 0)
			ClearPedSecondaryTask(player)
		else
			TaskPlayAnim(player, ad, anim, 8.0, 3.0, 2000, 26, 1, 0, 0, 0)
		end
	end
end
  
RegisterNetEvent('xlem0n_naprawka')
AddEventHandler('xlem0n_naprawka', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	
	local vehicle = nil
	if IsPedInAnyVehicle(playerPed, false) then
		vehicle = GetVehiclePedIsIn(playerPed, false)
	else
		vehicle = ESX.Game.GetVehicleInDirection()
		if not vehicle then
			if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
				vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
			end
		end
	end

	if vehicle and vehicle ~= 0 then
		CreateThread(function()
			while not HasAnimDictLoaded("mp_fm_intro_cut") do
				RequestAnimDict("mp_fm_intro_cut")
				Citizen.Wait(0)
			end

			TaskPlayAnim(playerPed, "mp_fm_intro_cut", "fixing_a_ped", 3.0, 1.0, -1, 1, 0, 0, 0, 0)
			Citizen.Wait(20000)
	
			local id = NetworkGetNetworkIdFromEntity(vehicle)
			SetNetworkIdCanMigrate(id, false)

			local tries = 0
			while not NetworkHasControlOfNetworkId(id) and tries < 10 do
				tries = tries + 1
				NetworkRequestControlOfNetworkId(id)
				Citizen.Wait(100)
			end

			local first = true
			while first or not GetIsVehicleEngineRunning(vehicle) do
				SetVehicleEngineHealth(vehicle, 1000.0)
				SetVehicleUndriveable(vehicle, false)

				SetVehicleEngineOn(vehicle, true, true)
				first = false
				Citizen.Wait(0)
			end

			SetNetworkIdCanMigrate(id, true)
			Citizen.InvokeNative(0xAAA34F8A7CB32098, playerPed)
			ESX.ShowNotification('~g~Silnik został naprawiony!')
		end)
	end
end)
  
  
  
RegisterNetEvent('xlem0n_policejob:onHijack')
AddEventHandler('xlem0n_policejob:onHijack', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	
	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle
		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		if DoesEntityExist(vehicle) then
			local model = GetEntityModel(vehicle)
			if not IsThisModelAHeli(model) and not IsThisModelAPlane(model) and not IsThisModelABoat(model) then
				TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
				CreateThread(function()
					FreezeEntityPosition(playerPed, true)
					exports["exile_taskbar"]:taskBar(15000, "Trwa Odblokowywanie", false, true)
					
					while GetVehicleDoorsLockedForPlayer(vehicle, PlayerId()) ~= false do
						SetVehicleDoorsLocked(vehicle, 1)
						SetVehicleDoorsLockedForAllPlayers(vehicle, false)
						Citizen.Wait(0)
					end
						Citizen.InvokeNative(0xAAA34F8A7CB32098, playerPed)
					ESX.ShowNotification(_U('vehicle_unlocked'))
					FreezeEntityPosition(playerPed, false)
				end)
			end
		end
	else
		ESX.ShowNotification('~r~Brak pojazdu w pobliżu')
	end
end)

local fov_max = 150.0
local fov_min = 7.0 
local zoomspeed = 10.0 
local speed_lr = 8.0
local speed_ud = 8.0
local toggle_helicam = 51
local toggle_rappel = 154
local toggle_spotlight = 183 
local toggle_lock_on = 22 

local helicam = false
local pd_heli_hash = `pcj`
local fov = (fov_max+fov_min)*0.5
local vision_state = 0 
  
CreateThread(function()
	while true do
		Wait(3)
		local lPed = PlayerPedId()
		local heli = GetVehiclePedIsIn(lPed)
		
		if helicam then
			if not ( IsPedSittingInAnyVehicle( lPed ) ) then
				CreateThread(function()
					TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_BINOCULARS", 0, 1)
					PlayAmbientSpeech1(PlayerPedId(), "GENERIC_CURSE_MED", "SPEECH_PARAMS_FORCE")
				end)
			end	
			
			Wait(2000)
			SetTimecycleModifier("heliGunCam")
			SetTimecycleModifierStrength(0.3)
			local scaleform = RequestScaleformMovie("HELI_CAM")
			while not HasScaleformMovieLoaded(scaleform) do
				Wait(3)
			end

			local lPed = PlayerPedId()
			local heli = GetVehiclePedIsIn(lPed)
			local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)

			AttachCamToEntity(cam, lPed, 0.0,0.0,1.0, true)
			SetCamRot(cam, 0.0,0.0,GetEntityHeading(lPed))
			SetCamFov(cam, fov)
			RenderScriptCams(true, false, 0, 1, 0)
			PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
			PushScaleformMovieFunctionParameterInt(1)
			PopScaleformMovieFunctionVoid()

			local locked_on_vehicle = nil

			while helicam and not IsEntityDead(lPed) and not isDead and (GetVehiclePedIsIn(lPed) == heli) and true do

				if IsControlJustPressed(0, 177) then
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					ClearPedTasks(PlayerPedId())
					helicam = false
				end

				if not locked_on_vehicle then
					local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
					CheckInputRotation(cam, zoomvalue)
					local vehicle_detected = GetVehicleInView(cam)
				end

				HandleZoom(cam)
				HideHUDThisFrame()

				DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
				Wait(3)

			end

			helicam = false

			ClearTimecycleModifier()

			fov = (fov_max+fov_min)*0.5

			RenderScriptCams(false, false, 0, 1, 0)

			SetScaleformMovieAsNoLongerNeeded(scaleform)

			DestroyCam(cam, false)
			SetNightvision(false)
			SetSeethrough(false)
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('exile_lorneta:lornetaon')
AddEventHandler('exile_lorneta:lornetaon', function()
	helicam = not helicam
	ESX.UI.Menu.CloseAll()
end)
  
function IsPlayerInPolmav()
	local lPed = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(lPed)
	return IsVehicleModel(vehicle, polmav_hash)
end
  
function ChangeVision()
	if vision_state == 0 then
		SetNightvision(true)
		vision_state = 1
	elseif vision_state == 1 then
		SetNightvision(false)
		SetSeethrough(true)
		vision_state = 2
	else
		SetSeethrough(false)
		vision_state = 0
	end
end
  
function HideHUDThisFrame()
	HideHelpTextThisFrame()
	HideHudComponentThisFrame(19) 
	HideHudComponentThisFrame(1) 
	HideHudComponentThisFrame(2) 
	HideHudComponentThisFrame(3)
	HideHudComponentThisFrame(4)
	HideHudComponentThisFrame(13)
	HideHudComponentThisFrame(11) 
	HideHudComponentThisFrame(12) 
	HideHudComponentThisFrame(15) 
	HideHudComponentThisFrame(18)
end
  
function CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end
  
function HandleZoom(cam)
	local lPed = PlayerPedId()
	if not ( IsPedSittingInAnyVehicle( lPed ) ) then
		if IsControlJustPressed(0,32) then 
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsControlJustPressed(0,8) then
			fov = math.min(fov + zoomspeed, fov_max)	
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then 
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05) 
	else
		if IsControlJustPressed(0,241) then 
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsControlJustPressed(0,242) then
			fov = math.min(fov + zoomspeed, fov_max)
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
	end
end

function GetVehicleInView(cam)
	local coords = GetCamCoord(cam)
	local forward_vector = RotAnglesToVec(GetCamRot(cam, 2))
	local rayhandle = CastRayPointToPoint(coords, coords+(forward_vector*200.0), 10, GetVehiclePedIsIn(PlayerPedId()), 0)
	local _, _, _, _, entityHit = GetRaycastResult(rayhandle)
	if entityHit>0 and IsEntityAVehicle(entityHit) then
		return entityHit
	else
		return nil
	end
end

AddEventHandler('esx:onPlayerDeath', function(reason)
	TriggerServerEvent("csskrouble:CLdeath")
end)
AddEventHandler('playerSpawned', function() 
	TriggerServerEvent("csskrouble:CLrev")
end)

function RotAnglesToVec(rot)
	local z = math.rad(rot.z)
	local x = math.rad(rot.x)
	local num = math.abs(math.cos(x))
	return vector3(-math.sin(z)*num, math.cos(z)*num, math.sin(x))
end

RegisterCommand("ulecz",function(source, cmd)
	if PlayerData.job.name == 'ambulance' then
		ESX.TriggerServerCallback("esx_scoreboard:getConnectedCops", function(MisiaczekPlayers)
			if MisiaczekPlayers then
				if PlayerData.job.grade >= 2 then 
					TriggerServerEvent('esx_policejob:es', cmd)
				elseif PlayerData.job.grade <= 1 and MisiaczekPlayers['ambulance'] <= 1 then
					TriggerServerEvent('esx_policejob:es', cmd)
				else
					ESX.ShowNotification('Nie możesz używać uleczki')
				end
			end
		end)
	else
		if PlayerData.job.name == 'police' then
			if PlayerData.job.grade > 4 and PlayerData.job.grade <= 10 then
				ESX.TriggerServerCallback("esx_scoreboard:getConnectedCops", function(MisiaczekPlayers)
					if MisiaczekPlayers then
						if MisiaczekPlayers['ambulance'] == 0 then
							TriggerServerEvent('esx_policejob:es', cmd)
						else
							ESX.ShowNotification('~r~Aby pomóc wezwij EMS')
						end
					end
				end)
			elseif PlayerData.job.grade > 10 then
				TriggerServerEvent('esx_policejob:es', cmd)
			elseif PlayerData.job.grade <= 2 then
				ESX.ShowNotification('~r~Nie masz odpowiedniego wyszkolenia do pomocy obywatelom')
			end
		end
	end
end)