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

RegisterNetEvent("exile_cafe:getrequest")
TriggerServerEvent("exile_cafe:request")
AddEventHandler("exile_cafe:getrequest", function(a, b, c, d)
	_G.donttry = a
	_G.exile_ca = b
	_G.exile_ca2 = c
	_G.exile_ca3 = d
	local donttouchme = _G.donttry
	local exile_cafe = _G.exile_ca
	local exile_cafe2 = _G.exile_ca2
	local exile_cafe3 = _G.exile_ca3
local ESX, PlayerData, inProgress, pCoords, CafeBlips, CanWork = nil, {}, false, nil, {}, false
local HasAlreadyEnteredMarker	= false
local LastZone					= nil
local CurrentAction				= nil
local CurrentActionMsg			= ''
local CurrentActionData			= {}
local alreadyOut, inAction = false
local cooldown = false

local kochacpieski = true

local Cfg = {
	CollectSeeds = {
		{
			coords = vector3(835.4193, -1987.7938, 28.35),
		},
	},
	TransferingSeeds = {
		{
			coords = vector3(-627.78, 223.69, 80.93),
		},
	},
	SellCoffee = {
		{
			coords = vector3(-620.2585, 208.7775, 73.2615),
		},
	},
	Garage = {
		{
			coords = vector3(-620.0739, 198.6621, 69.8853)
		},
		{
			coords = vector3(846.5831, -1992.2937, 28.3514)
		},
	},
	BossActions = {
		{
			coords = vector3(-634.7961, 227.7527, 80.9316)
		},
	},
	Cloakroom = {
		{
			coords = vector3(-634.5056, 208.9357, 73.2446)
		},
		{
			coords = vector3(849.5215, -1995.2681, 29.0308)
		},
	},
	Clothes = {
		Male = {
			['tshirt_1'] = 15, ['tshirt_2'] = 0,--TSHIRT
			['torso_1'] = 420, ['torso_2'] = 1, --TUŁÓW
			['arms'] = 52, --RAMIONA
			['pants_1'] = 169, ['pants_2'] = 9, --SPODNIE
			['shoes_1'] = 76, ['shoes_2'] = 3, --BUTY
			['helmet_1'] = 10, ['helmet_2'] = 0, --CZAPKATUTAJ-1_OZNACZA_BRAK_CZAPKI
			['chain_1'] = 186, ['chain_2'] = 0, --ŁAŃCUCH
			['mask_1'] = 0, ['mask_2'] = 0, --MASKA
			['bags_1'] = 23, ['bags_2'] = 8 --TORBA
	   },
	   Female = {
		['tshirt_1'] = 14, ['tshirt_2'] = 0,
		['torso_1'] = 440, ['torso_2'] = 1,
		['decals_1'] = 0, ['decals_2'] = 0,
		['arms'] = 57,
		['pants_1'] = 125, ['pants_2'] = 5,
		['shoes_1'] = 107, ['shoes_2'] = 11,
		['helmet_1'] = -1, ['helmet_2'] = 0,
		['chain_1'] = 155, ['chain_2'] = 0,
		['ears_1'] = -1, ['ears_2'] = 0,
		['bproof_1'] = 0, ['bproof_2'] = 0,
		['mask_1'] = 0, ['mask_2'] = 0,
		['bags_1'] = 23, ['bags_2'] = 3
	},
	},
}

local Blips = {
	{title="#1 Szatnia", colour=0, id=112, see = true, coords = vector3(-634.5056, 208.9357, 73.2446)},
	{title="#2 Pakowanie X-Gamera", colour=0, id=112, see = true, coords = vector3(835.4193, -1987.7938, 28.3514)},
	{title="#3 Wypakowanie X-Gamera", colour=0, id=112, see = true, coords = vector3(-627.78, 223.69, 80.93)},
	{title="#4 Punkt dostawy X-Gamer Energy", colour=0, id=112, see = false, coords = vector3(-620.066, 208.6527, 73.2592)}
},

CreateThread(function()
	while ESX == nil do
		TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) 
			ESX = obj 
		end)
		
		Citizen.Wait(250)
	end
	
	Citizen.Wait(5000)
	PlayerData = ESX.GetPlayerData()
	refreshBlips()
end)

CreateThread(function()
	while PlayerData.job == nil do
		Citizen.Wait(100)
	end
	while true do
		if PlayerData.job.name == 'kawiarnia' then
			local playerPed = PlayerPedId()
			pCoords = GetEntityCoords(playerPed)
		else
			local playerPed = PlayerPedId()
			tCoords = GetEntityCoords(playerPed)
		end
		Citizen.Wait(500)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	refreshBlips()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	CanWork = false
	deleteBlip()
	refreshBlips()
end)

refreshBlips = function()
	if PlayerData.job ~= nil and PlayerData.job.name == 'kawiarnia' then
		for i=1, #Blips, 1 do
			if Blips[i].see then
				local blip = AddBlipForCoord(Blips[i].coords)
				SetBlipSprite(blip, Blips[i].id)
				SetBlipDisplay(blip, 4)
				SetBlipScale(blip, 0.9)
				SetBlipColour(blip, Blips[i].colour)
				SetBlipAsShortRange(blip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(Blips[i].title)
				EndTextCommandSetBlipName(blip)

				table.insert(CafeBlips, blip)
			else
				if PlayerData.job.grade >= 7 then
					local blipSell = AddBlipForCoord(Blips[4].coords)
					SetBlipSprite(blipSell, Blips[4].id)
					SetBlipDisplay(blipSell, 4)
					SetBlipScale(blipSell, 0.9)
					SetBlipColour(blipSell, Blips[4].colour)
					SetBlipAsShortRange(blipSell, true)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(Blips[i].title)
					EndTextCommandSetBlipName(blipSell)

					table.insert(CafeBlips, blipSell)
				end
			end
		end
	end
end

deleteBlip = function()
	if CafeBlips[1] ~= nil then
		for i=1, #CafeBlips, 1 do
			RemoveBlip(CafeBlips[i])
			CafeBlips[i] = nil
		end
	end
end
CreateThread(function()
	while PlayerData.job == nil do
		Citizen.Wait(1000)
	end
	while true do
		Citizen.Wait(5)
		if PlayerData.job ~= nil and PlayerData.job.name == 'kawiarnia' then
			local found = false
			local isInMarker	= false
			local currentZone	= nil
			local zoneNumber 	= nil
			for k,v in pairs(Cfg) do
				for i=1, #v, 1 do
					if CanWork or (k == 'Cloakroom' or k == 'BossActions' and PlayerData.job.grade >= 7 or k == 'SellCoffee' and PlayerData.job.grade >= 7) then
						if k == 'CollectSeeds' then
							if #(pCoords - v[i].coords) < 10.0 then
								found = true
								ESX.DrawBigMarker(vec3(v[i].coords.x, v[i].coords.y, v[i].coords.z))
							end
						elseif k == 'TransferingSeeds' or k == 'SellCoffee' or k ~= 'Garage' then
							if #(pCoords - v[i].coords) < 10.0 then
								found = true
								ESX.DrawMarker(vec3(v[i].coords.x, v[i].coords.y, v[i].coords.z))
							end
						else
							if #(pCoords - v[i].coords) < 10.0 then
								found = true
								ESX.DrawBigMarker(vec3(v[i].coords.x, v[i].coords.y, v[i].coords.z))
							end
						end


						if k == 'Cloakroom' or k == 'BossActions' then
							if #(pCoords - v[i].coords) < 1.5 then
								isInMarker	= true
								currentZone = k
								zoneNumber = i
							end
						elseif k == 'CollectSeeds' then
							if #(pCoords - v[i].coords) < 5.0 then
								isInMarker	= true
								currentZone = k
								zoneNumber = i
							end
						else
							if #(pCoords - v[i].coords) < 2.0 then
								isInMarker	= true
								currentZone = k
								zoneNumber = i
							end
						end
						
					end
				end
			end

			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				lastZone				= currentZone
				TriggerEvent('exile_cafe:hasEnteredMarker', currentZone, zoneNumber)
			end
	
			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('exile_cafe:hasExitedMarker', lastZone)
			end

		--	if isInMarker and inAction then
			--	TriggerEvent('exile_cafe:hasEnteredMarker', 'exitMarker')
			--end

			if not found then
				Citizen.Wait(2000)
			end
		else
			Citizen.Wait(2000)
		end
	end
end)
local inProgress = false
--msg
CreateThread(function()
	while true do

		Citizen.Wait(10)
		if PlayerData.job and PlayerData.job.name == 'kawiarnia' then

			if CurrentAction ~= nil and not cooldown then

				ESX.ShowHelpNotification(CurrentActionMsg)

				if IsControlJustReleased(0, 38) then
					if CurrentAction == 'collect' then
						if not inProgress then
							StartCollect()
							inAction = true
						end
					elseif CurrentAction == 'transfering' then
						TransferingSeeds()
					elseif CurrentAction == 'sell' then
						SellCoffee()
					elseif CurrentAction == 'boss_actions' then
						OpenBossMenu()
					elseif CurrentAction == 'garage' then
						CarOut()
					elseif CurrentAction == 'cloakroom' then
						OpenCloakroom()
					elseif CurrentAction == 'exit' then
						inAction = false
						FreezeEntityPosition(PlayerPedId(), false)
						ClearPedTasks(PlayerPedId())
					else
						inAction = false
					end
					CurrentAction = nil
				end
			end
			if IsControlJustReleased(0, 167) and IsInputDisabled(0) and PlayerData.job.grade >= 7 then
				OpenMobileCafeActionsMenu()
			end
		else
			Citizen.Wait(2000)
		end
	end
end)
local tekst = 0
local showTimer = false
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

function Timer(time)
	TriggerEvent('exile_cofe:DrawPercent')
	CreateThread(function()
		tekst = 0
		repeat
			tekst = tekst + 1
			Citizen.Wait(time)
		until tekst == 100
		showTimer = false
		StopCollect()
	end)
end


StopCollect = function()
	TriggerServerEvent(exile_cafe3, 'ziarna', donttouchme)
	inProgress = false
	FreezeEntityPosition(PlayerPedId(), false)
	ClearPedTasks(PlayerPedId())
	CurrentAction		= 'collect'
	CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby zebrać ~b~proszek X-Gamer"
	CurrentActionData	= {}
end


RegisterNetEvent('exile_cofe:DrawPercent')
AddEventHandler('exile_cofe:DrawPercent', function()
	showTimer = true

	while (showTimer) do
		Wait(0)
		DisableControlAction(0, 73, true) -- X
		DrawText3D(pCoords.x, pCoords.y, pCoords.z + 0.1, tekst .. '~g~%', 0.4)
    end
end)

StartCollect = function()
	local playerPed = PlayerPedId()

	ESX.TriggerServerCallback('gcphone:getItemAmount', function(count)
		if count < 100 then
			ClearPedTasks(playerPed)
			FreezeEntityPosition(playerPed, true)
			TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_GARDENER_PLANT", 0, true)
			inProgress = true
			Timer(1800)
		else
			inProgress = false
			ESX.ShowNotification('~y~Nie uniesiesz więcej proszku')
		end
	end, 'ziarna')
end

TransferingSeeds = function()
	ESX.UI.Menu.CloseAll()
	local inventory = ESX.GetPlayerData().inventory
	local count = 0
	for i=1, #inventory, 1 do
		if inventory[i].name == 'ziarna' then
			count = inventory[i].count
		end
	end
	if kochacpieski == true then
		if count >= 100 then
			DisableControlAction(0, 289, true)
			FreezeEntityPosition(PlayerPedId(), true)
			local lib, anim = 'mini@drinking', 'shots_barman_b'
			kawa = CreateObject(`prop_fib_coffee`, 0, 0, 0, true, true, false)
			AttachEntityToEntity(kawa, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.09, 0.02, 0.0, 0, 0, 0, true, true, false, true, 1, true)
			ESX.Streaming.RequestAnimDict(lib, function()
				TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
				exports["exile_taskbar"]:taskBar(40000, "Trwa przygotowywanie X-Gamer", false, true)
				Citizen.InvokeNative(0xAAA34F8A7CB32098, PlayerPedId())
				TriggerServerEvent(exile_cafe2, count, donttouchme)
				FreezeEntityPosition(PlayerPedId(), false)
				DeleteEntity(kawa)
				DisableControlAction(0, 289, false)
				kochacpieski = false
				TriggerEvent('kawiarzxD')
			end)
		else
			ESX.ShowNotification('~r~Potrzebujesz 100x proszek aby rozpocząć przerabianie!')
		end
	else
		ESX.ShowNotification('~r~Musisz odczekać aby ponownie przerabiać!')
	end
end
RegisterNetEvent('kawiarzxD')
AddEventHandler('kawiarzxD', function()
	Citizen.Wait(300000)
	kochacpieski = true
end)
local blokuj = false
SellCoffee = function()
	ESX.UI.Menu.CloseAll()
	local inventory = ESX.GetPlayerData().inventory
	local count = 0
	for i=1, #inventory, 1 do
		if inventory[i].name == 'kawa' then
			count = inventory[i].count
		end
	end
	if count > 0 then
		blokuj = true
		FreezeEntityPosition(PlayerPedId(), true)
		local lib, anim = 'gestures@m@standing@casual', 'gesture_easy_now'
		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
			exports["exile_taskbar"]:taskBar(12000, "Sprzedawanie X-Gamer", false, true)
			Citizen.InvokeNative(0xAAA34F8A7CB32098, PlayerPedId())
			TriggerServerEvent(exile_cafe, count, donttouchme)
			FreezeEntityPosition(PlayerPedId(), false)
			blokuj = false
		end)
	else
		ESX.ShowNotification('~r~Nie posiadasz przy sobie X-Gamer!')
	end
end

CreateThread(function()
	while true do
		Citizen.Wait(0)
		if blokuj then
			DisableControlAction(0, Keys['F2'], true)
		else
			Citizen.Wait(1000)
		end
	end
end)

CarOut = function()
	local player = PlayerPedId()
	if IsPedInAnyVehicle(player, false) then
		local carCafe = GetVehiclePedIsIn(player, false)
		if IsVehicleModel(carCafe, `gmcat4`) then
			ESX.Game.DeleteVehicle(carCafe)
			alreadyOut = false
		else
			ESX.ShowNotifcation('~r~Możesz zwrócić tylko auto firmowe!')
		end
	else
		if ESX.Game.IsSpawnPointClear(GetEntityCoords(PlayerPedId()), 7) then
			ESX.Game.SpawnVehicle('gmcat4', GetEntityCoords(PlayerPedId()), 86.53, function(vehicle)
				platenum = math.random(10, 99)
				SetVehicleNumberPlateText(vehicle, "XGAM"..platenum)
				TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
				TriggerServerEvent('exile_cafe:insertPlayer', GetVehicleNumberPlateText(vehicle))
			end)
			alreadyOut = true
		else
			ESX.ShowNotification('~r~Miejsce parkingowe jest już zajęte przez inny pojazd!')
		end
	end
end

function OpenCloakroom()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
	{
		title    = 'Przebieralnia',
		align = 'center',
		elements = {
			{label = 'Ubrania robocze',     value = 'job_wear'},
			{label = 'Ubrania prywatne', value = 'citizen_wear'}
		}
	}, function(data, menu)
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
			if data.current.value == 'citizen_wear' then
				CanWork = false
				TriggerEvent('skinchanger:loadSkin', skin)
			elseif data.current.value == 'job_wear' then
				CanWork = true
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, Cfg.Clothes.Male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, Cfg.Clothes.Female)
				end
			end
		end)

		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

function OpenBossMenu()
	local elements = {
		{label = "Akcje szefa", value = '1'},
    }
    if PlayerData.job.grade >= 7 then
		--table.insert(elements, {label = "Lista kursów", value = '2'})
		table.insert(elements, {label = "Zarządzanie frakcją", value = '4'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cafe_boss', {
		title    = "Kawiarnia",
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)

		if data.current.value == '1' then
			if PlayerData.job.grade == 7 then
				TriggerEvent('esx_society:openBossMenu', 'kawiarnia', function(data, menu)
					menu.close()
				end, { showmoney = false, withdraw = false, deposit = true, wash = false, employees = true})
			elseif PlayerData.job.grade >= 8 then
				TriggerEvent('esx_society:openBossMenu', 'kawiarnia', function(data, menu)
					menu.close()
				end, { showmoney = true, withdraw = true, deposit = true, wash = false, employees = true})
			else
				TriggerEvent('esx_society:openBossMenu', 'kawiarnia', function(data, menu)
					menu.close()
				end, { showmoney = false, withdraw = false, deposit = true, wash = false, employees = false})
            end
        elseif data.current.value == '2' then
			menu.close()
			ESX.TriggerServerCallback('ExileRP:getCourses', function(kursy)
				if kursy then
					local elements = {
						head = {'Imię i nazwisko', 'Liczba kursów', 'Stopień'},
						rows = {}
					}
					for i=1, #kursy, 1 do
						if kursy[i].job_grade == 0 then
							grade = 'Stażysta'
						elseif kursy[i].job_grade == 1 then
							grade = 'Młodszy pracownik'
						elseif kursy[i].job_grade == 2 then
							grade = 'Pracownik'
						elseif kursy[i].job_grade == 3 then
							grade = 'Fachowiec'
						elseif kursy[i].job_grade == 4 then
							grade = 'Zawodowiec'
						elseif kursy[i].job_grade == 5 then
							grade = 'Specjalista'
						elseif kursy[i].job_grade == 6 then
							grade = 'Koordynator'
						elseif kursy[i].job_grade == 7 then
							grade = 'Manager'
						elseif kursy[i].job_grade == 8 then
							grade = 'Prezes'
						elseif kursy[i].job_grade == 9 then
							grade = 'Szef'
						end
						local name = kursy[i].firstname .. ' ' ..kursy[i].lastname
						table.insert(elements.rows, {
							data = kursy[i],
							cols = {
								name, 
								kursy[i].courses_count, 
								grade
							}
						})
						ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'cafe_courses', elements, function(data, menu)
						end, function(data, menu)
							menu.close()
						end)
                    end
                else
                    ESX.ShowNotification("~r~Lista kursów jest pusta!")
				end
			end, 'kawiarnia')
		elseif data.current.value == '4' then
			menu.close()
			exports['exile_legaljobs']:OpenLicensesMenu(PlayerData.job.name)
		end

	end, function(data, menu)
		menu.close()

		CurrentAction     = 'boss_actions'
		CurrentActionMsg  = "Naciśnij ~INPUT_CONTEXT~, aby wejść do menu"
		CurrentActionData = {}
	end)
end

RegisterNetEvent('exile_cafe:Cancel')
AddEventHandler('exile_cafe:Cancel', function()
	local playerPed = PlayerPedId()
	FreezeEntityPosition(playerPed, false)
	ClearPedTasks(playerPed)
end)

AddEventHandler('exile_cafe:hasEnteredMarker', function(zone, number)

	if zone == 'exitMarker' then
		CurrentAction     = 'exit'
		CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~ aby przerwać ~b~czynność~s~'
		CurrentActionData = {}
	end

	if zone == 'CollectSeeds' then
		CurrentAction		= 'collect'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby zebrać ~b~proszek X-Gamer"
		CurrentActionData	= {}
	end

	if zone == 'Cloakroom' then
		CurrentAction		= 'cloakroom'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby otworzyć ~b~szatnię"
		CurrentActionData	= {}
	end

	if zone == 'TransferingSeeds' then
		CurrentAction		= 'transfering'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby przerobić ~b~proszek X-Gamer"
		CurrentActionData	= {}
	end

	if zone == 'SellCoffee' then
		CurrentAction		= 'sell'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby sprzedać ~b~X-Gamer Energy"
		CurrentActionData	= {}
	end

	if zone == 'Garage' then
		if IsPedInAnyVehicle(PlayerPedId(), false) then
			msg = "Naciśnij ~INPUT_CONTEXT~, aby schować ~y~pojazd"
		else
			msg = "Naciśnij ~INPUT_CONTEXT~, aby wyciągnąć ~y~pojazd"
		end
		CurrentAction		= 'garage'
		CurrentActionMsg	= msg
		CurrentActionData	= {}
	end

	
	if zone == 'BossActions' then
		CurrentAction		= 'boss_actions'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~ aby otworzyć ~y~menu zarządzania"
		CurrentActionData	= {}
	end
end)

AddEventHandler('exile_cafe:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	TriggerServerEvent('exile_cafe:stopPickup', zone)

	CurrentAction = nil

	cooldown = true
	if zone == 'CollectSeeds' then
		Citizen.Wait(4000)
		cooldown = false
	else
		Citizen.Wait(300)
		cooldown = false
	end
end)

OpenMobileCafeActionsMenu = function()
	while PlayerData == nil do
		Wait(200)
	end
	ESX.UI.Menu.CloseAll()
	local elements = {}
	local playerPed = PlayerPedId()
	local vehicle   = GetVehiclePedIsIn(playerPed, false)
	if IsVehicleModel(vehicle, `gmcat4`) then
		if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
			ESX.TriggerServerCallback('exile_cafe:checkSiedzacy', function(siedzi)
				if siedzi then
					local plate =  GetVehicleNumberPlateText(vehicle)
					for i=1, #siedzi, 1 do
						if siedzi[i].plate == plate then
							table.insert(elements, {label = siedzi[i].label, value = siedzi[i].plate})	
						end
					end
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lastdriver_'..PlayerData.job.name, {
						title    = "Lista kierowców ["..plate..']',
						align    = 'bottom-right',
						elements = elements
					}, function(data, menu)
					end, function(data, menu)
						menu.close()
					end)
				end
			end)
		else
			ESX.ShowNotification("~r~Musisz znajdować się w pojeździe jako kierowca!")
		end
	end
end

end)

local ExileBlips = {
    {
        coords = {-75.96, 6256.21, 31.09},
        sprite = 178,
        display = 4,
        scale = 0.7,
        color = 70,
        shortrange = true,
        name = "Catch Chickens",
        exileBlip = false,
        exileBlipId = ""
    },
    {
        coords = {54.19, -1574.98, 29.46},
        sprite = 442,
        display = 4,
        scale = 0.7,
        color = 4,
        shortrange = true,
        name = "Milkman",
        exileBlip = true,
        exileBlipId = "exilerp_mleczarz"
    },
	{
        coords = {-1202.41, -895.03, 13.99},
        sprite = 126,
        display = 4,
        scale = 0.7,
        color = 5,
        shortrange = true,
        name = "Burgershot",
        exileBlip = true,
        exileBlipId = "exilerp_burgerownia"
    },

	{
        coords = {796.1, -749.96, 31.26},
        sprite = 488,
        display = 4,
        scale = 0.7,
        color = 0,
        shortrange = true,
        name = "Pizza This",
        exileBlip = true,
        exileBlipId = "exilerp_pizzathis"
    },
	{
        coords = {-332.15, -2792.74, 4.1},
        sprite = 471,
        display = 4,
        scale = 0.7,
        color = 3,
        shortrange = true,
        name = "Sklep z łodziami",
        exileBlip = true,
        exileBlipId = "boat4"
    },
	{
        coords = {-718.77, -1326.51, 0.7},
        sprite = 404,
        display = 4,
        scale = 0.7,
        color = 6,
        shortrange = true,
        name = "Port SAMS",
        exileBlip = true,
        exileBlipId = "boat4"
    },
	{
        coords = {1736.29, 3976.24, 31.08},
        sprite = 404,
        display = 4,
        scale = 0.7,
        color = 6,
        shortrange = true,
        name = "Port SAMS",
        exileBlip = true,
        exileBlipId = "boat4"
    },
	{
        coords = {-285.01, 6627.6, 6.24},
        sprite = 404,
        display = 4,
        scale = 0.7,
        color = 6,
        shortrange = true,
        name = "Port SAMS",
        exileBlip = true,
        exileBlipId = "boat4"
    },
	{
        coords = {-3420.4172, 955.6319, 7.396},
        sprite = 404,
        display = 4,
        scale = 0.7,
        color = 6,
        shortrange = true,
        name = "Port SAMS",
        exileBlip = true,
        exileBlipId = "boat4"
    },
	{
        coords = {2836.5044, -732.4112, 0.3822},
        sprite = 404,
        display = 4,
        scale = 0.7,
        color = 6,
        shortrange = true,
        name = "Port SAMS",
        exileBlip = true,
        exileBlipId = "boat4"
    },
	{
        coords = {3373.8213, 5183.4863, 0.5161},
        sprite = 404,
        display = 4,
        scale = 0.7,
        color = 6,
        shortrange = true,
        name = "Port SAMS",
        exileBlip = true,
        exileBlipId = "boat4"
    },
	{
        coords = {-941.13, -2954.42, 13.05},
        sprite = 584,
        display = 4,
        scale = 0.7,
        color = 30,
        shortrange = true,
        name = "Sklep z samolotami",
        exileBlip = true,
        exileBlipId = "airport2"
    },
	{
        coords = {-804.27, -1368.97, 4.32},
        sprite = 481,
        display = 4,
        scale = 0.7,
        color = 38,
        shortrange = true,
        name = "Extreme Sports",
        exileBlip = true,
        exileBlipId = "exilerp_extremesports"
    },
	{
        coords = {-1389.71, -590.0513, 29.36},
        sprite = 279,
        display = 4,
        scale = 0.7,
        color = 8,
        shortrange = true,
        name = "Bahama Mamas",
        exileBlip = true,
        exileBlipId = "exilerp_bahamamamas"
    },
	{
        coords = {-1013.67, -481.0, 39.32},
        sprite = 133,
        display = 4,
        scale = 0.7,
        color = 7,
        shortrange = true,
        name = "Psycholog",
        exileBlip = true,
        exileBlipId = "exilerp_psycholog"
    },
	{
        coords = {-550.9989, -912.3848, 28.8366},
        sprite = 184,
        display = 4,
        scale = 0.7,
        color = 37,
        shortrange = true,
        name = "Weazel News",
        exileBlip = true,
        exileBlipId = "exilerp_weazelnews"
    },
	{
        coords = {-627.85 , 222.70, 94.60},
        sprite = 112,
        display = 4,
        scale = 0.7,
        color = 0,
        shortrange = true,
        name = "X-Gamer",
        exileBlip = true,
        exileBlipId = "exilerp_xgamer"
    },
	{
        coords = {-2068.93 , -486.59, 12.98},
        sprite = 621,
        display = 4,
        scale = 0.7,
        color = 57,
        shortrange = true,
        name = "Molo Miłości",
        exileBlip = true,
        exileBlipId = "exilerp_molom"
    },
	{
        coords = {-1045.8291, -2751.5154, 20.41348},
        sprite = 307,
        display = 4,
        scale = 0.7,
        color = 76,
        shortrange = true,
        name = "Lotnisko",
        exileBlip = true,
        exileBlipId = "airport"
    },
	{
        coords = {-1684.17 , -278.34, 74.7},
        sprite = 305,
        display = 4,
        scale = 0.7,
        color = 0,
        shortrange = true,
        name = "Kościół",
        exileBlip = true,
        exileBlipId = "church"
    },
	{
        coords = {932.25, 41.13, 80.29},
        sprite = 679,
        display = 4,
        scale = 0.7,
        color = 5,
        shortrange = true,
        name = "Casino Royale",
        exileBlip = true,
        exileBlipId = "casino"
    },
	{
        coords = {-1651.14, -904.38, 8.59},
        sprite = 135,
        display = 4,
        scale = 0.7,
        color = 7,
        shortrange = true,
        name = "Kino Samochodowe",
        exileBlip = true,
        exileBlipId = "cinemacar"
    },
	{
        coords = {237.45, -406.68, 47.92},
        sprite = 498,
        display = 4,
        scale = 0.7,
        color = 15,
        shortrange = true,
        name = "Urząd Miasta",
        exileBlip = true,
        exileBlipId = "cityhall"
    },
	{
        coords = {-265.95, -962.42, 31.22},
        sprite = 498,
        display = 4,
        scale = 0.7,
        color = 46,
        shortrange = true,
        name = "Urząd Pracy",
        exileBlip = true,
        exileBlipId = "cityhall"
    },
	{
        coords = {232.23, -3312.73, 4.89},
        sprite = 440,
        display = 4,
        scale = 0.7,
        color = 49,
        shortrange = true,
        name = "Pralnia Pieniędzy",
        exileBlip = true,
        exileBlipId = "exilerp_pralnia"
    },
	{
        coords = {100.5097, -1506.061, 28.3058},
        sprite = 523,
        display = 4,
        scale = 0.7,
        color = 46,
        shortrange = true,
        name = "Luxury Motosports",
        exileBlip = true,
        exileBlipId = "cardealer"
    },
	{
        coords = {-414.8303, -2796.4055, 5.0504},
        sprite = 363,
        display = 4,
        scale = 0.7,
        color = 30,
        shortrange = true,
        name = "PostOP",
        exileBlip = true,
        exileBlipId = "exilerp_kurier"
    },
	{
        coords = {715.05798339844, -971.34069824219, 36.854461669922},
        sprite = 366,
        display = 4,
        scale = 0.7,
        color = 2,
        shortrange = true,
        name = "Fly Beliodas",
        exileBlip = true,
        exileBlipId = "exilerp_krawiec"
    },
	{
        coords = {-1927.351, 2063.881, 139.7437},
        sprite = 479,
        display = 4,
        scale = 0.7,
        color = 27,
        shortrange = true,
        name = "Winiarz",
        exileBlip = true,
        exileBlipId = "exilerp_winiarz"
    },
	{
        coords = {892.95, -162.61, 76.89},
        sprite = 205,
        display = 4,
        scale = 0.7,
        color = 60,
        shortrange = true,
        name = "Downtown Cab. Co.",
        exileBlip = true,
        exileBlipId = "taxi"
    },
	{
        coords = {-555.53161621094, -618.80426025391, 34.676345825195},
        sprite = 525,
        display = 4,
        scale = 0.7,
        color = 24,
        shortrange = true,
        name = "Muzeum",
        exileBlip = true,
        exileBlipId = "taxi"
    },
}

CreateThread(function()
	for i,v in ipairs(ExileBlips) do
		local blip = AddBlipForCoord(v.coords[1], v.coords[2], v.coords[3])

		SetBlipSprite (blip, v.sprite)
		SetBlipDisplay(blip, v.display)
		SetBlipScale  (blip, v.scale)
		SetBlipColour (blip, v.color)
		SetBlipAsShortRange(blip, v.shortrange)
	
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(v.name)
		EndTextCommandSetBlipName(blip)
	end	
end)