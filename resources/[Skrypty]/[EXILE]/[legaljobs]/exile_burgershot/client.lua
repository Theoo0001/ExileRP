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

RegisterNetEvent("exile_burgershot:getrequest")
TriggerServerEvent("exile_burgershot:request")
AddEventHandler("exile_burgershot:getrequest", function(a, b, c, d)
	_G.donttry = a
	_G.exile_ca = b
	_G.exile_ca2 = c
	_G.exile_ca3 = d
	local donttouchme = _G.donttry
	local exile_burgershot = _G.exile_ca
	local exile_burgershot2 = _G.exile_ca2
	local exile_burgershot3 = _G.exile_ca3
local ESX, PlayerData, inProgress, pCoords, burgershotBlips, CanWork = nil, {}, false, nil, {}, false
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
			coords = vector3(-2959.37, 371.74, 14.77-0.95),
		},
	},
	TransferingSeeds = {
		{
			coords = vector3(-1193.15, -904.28, 13.99-0.95),
		},
	},
	SellCoffee = {
		{
			coords = vector3(-1196.59, -892.95, 13.99-0.95),
		},
	},
	Garage = {
		{
			coords = vector3(-2976.34, 359.39, 14.78-0.95)
		},
		{
			coords = vector3(-1179.09, -878.07, 13.94-0.95)
		},
	},
	BossActions = {
		{
			coords = vector3(-1194.14, -895.74, 13.99-0.95)
		},
	},
	Cloakroom = {
		{
			coords = vector3(-2961.6, 376.83, 15.0-0.95)
		},
		{
			coords = vector3(-1177.65, -891.11, 13.78-0.95)
		},
	},
	Clothes = {
		Male = {
			['tshirt_1'] = 15, ['tshirt_2'] = 0,
			['torso_1'] = 420, ['torso_2'] = 6,
			['decals_1'] = 0, ['decals_2'] = 0,
			['arms'] = 56,
			['pants_1'] = 37, ['pants_2'] = 0,
			['shoes_1'] = 43, ['shoes_2'] = 0,
			['helmet_1'] = -1, ['helmet_2'] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
			['ears_1'] = -1, ['ears_2'] = 0,
			['bproof_1'] = 0, ['bproof_2'] = 0,
			['mask_1'] = 0, ['mask_2'] = 0,
			['bags_1'] = 0, ['bags_2'] = 0
	},
	Female = {
		['tshirt_1'] = 14, ['tshirt_2'] = 0,
		['torso_1'] = 440, ['torso_2'] = 6,
		['decals_1'] = 0, ['decals_2'] = 0,
		['arms'] = 14,
		['pants_1'] = 173, ['pants_2'] = 21,
		['shoes_1'] = 11, ['shoes_2'] = 0,
		['helmet_1'] = 0, ['helmet_2'] = 0,
		['chain_1'] = 0, ['chain_2'] = 0,
		['ears_1'] = -1, ['ears_2'] = 0,
		['bproof_1'] = 0, ['bproof_2'] = 0,
		['mask_1'] = 0, ['mask_2'] = 0,
		['bags_1'] = 0, ['bags_2'] = 0
	},
	},
}

local Blips = {
	{title="#1 Szatnia", colour=5, id=126, see = true, coords = vector3(-1177.65, -891.11, 13.78)},
	{title="#2 Zbieranie składników", colour=5, id=126, see = true, coords = vector3(-2964.41, 372.22, 14.78)},
	{title="#3 Przeróbka składników", colour=5, id=126, see = true, coords = vector3(-1193.15, -904.28, 13.993)},
	{title="#4 Punkt dostawy Burgerów", colour=5, id=126, see = false, coords = vector3(-1196.59, -892.95, 13.99)}
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
		if PlayerData.job.name == 'burgershot' then
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
	if PlayerData.job ~= nil and PlayerData.job.name == 'burgershot' then
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

				table.insert(burgershotBlips, blip)
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

					table.insert(burgershotBlips, blipSell)
				end
			end
		end
	end
end

deleteBlip = function()
	if burgershotBlips[1] ~= nil then
		for i=1, #burgershotBlips, 1 do
			RemoveBlip(burgershotBlips[i])
			burgershotBlips[i] = nil
		end
	end
end
CreateThread(function()
	while PlayerData.job == nil do
		Citizen.Wait(1000)
	end
	while true do
		Citizen.Wait(5)
		if PlayerData.job ~= nil and PlayerData.job.name == 'burgershot' then
			local found = false
			local isInMarker	= false
			local currentZone	= nil
			local zoneNumber 	= nil
			for k,v in pairs(Cfg) do
				for i=1, #v, 1 do
					if CanWork or (k == 'Cloakroom' or k == 'BossActions' and PlayerData.job.grade >= 7 or k == 'SellCoffee' and PlayerData.job.grade >= 7) then
						if k == 'CollectSeeds' or k == 'TransferingSeeds' then
							if #(pCoords - v[i].coords) < 10.0 then
								found = true
								ESX.DrawBigMarker(vec3(v[i].coords.x, v[i].coords.y, v[i].coords.z))
							end
						elseif k == 'SellCoffee' or k ~= 'Garage' then
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
				TriggerEvent('exile_burgershot:hasEnteredMarker', currentZone, zoneNumber)
			end
	
			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('exile_burgershot:hasExitedMarker', lastZone)
			end

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
		if PlayerData.job and PlayerData.job.name == 'burgershot' then

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
				OpenMobileburgershotActionsMenu()
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
	TriggerServerEvent(exile_burgershot3, 'skladniki', donttouchme)
	inProgress = false
	FreezeEntityPosition(PlayerPedId(), false)
	ClearPedTasks(PlayerPedId())
	CurrentAction		= 'collect'
	CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby zebrać ~b~składniki"
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
			Timer(1500)
		else
			inProgress = false
			ESX.ShowNotification('~y~Nie uniesiesz więcej składników')
		end
	end, 'skladniki')
end

TransferingSeeds = function()
	ESX.UI.Menu.CloseAll()
	local inventory = ESX.GetPlayerData().inventory
	local count = 0
	for i=1, #inventory, 1 do
		if inventory[i].name == 'skladniki' then
			count = inventory[i].count
		end
	end
	if kochacpieski == true then
		if count >= 100 then
			DisableControlAction(0, 289, true)
			FreezeEntityPosition(PlayerPedId(), true)
			local lib, anim = 'mini@drinking', 'shots_barman_b'
			ESX.Streaming.RequestAnimDict(lib, function()
				TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
				exports["exile_taskbar"]:taskBar(40000, "Trwa przygotowywanie Burgerów", false, true)
				Citizen.InvokeNative(0xAAA34F8A7CB32098, PlayerPedId())
				TriggerServerEvent(exile_burgershot2, count, donttouchme)
				FreezeEntityPosition(PlayerPedId(), false)
				DisableControlAction(0, 289, false)
				kochacpieski = false
				TriggerEvent('kawiarzxD')
			end)
		else
			ESX.ShowNotification('~r~Potrzebujesz 100x składniki aby rozpocząć przerabianie!')
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
		if inventory[i].name == 'burger' then
			count = inventory[i].count
		end
	end
	if count > 0 then
		blokuj = true
		FreezeEntityPosition(PlayerPedId(), true)
		local lib, anim = 'gestures@m@standing@casual', 'gesture_easy_now'
		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
			exports["exile_taskbar"]:taskBar(12000, "Sprzedawanie Burgerów", false, true)
			Citizen.InvokeNative(0xAAA34F8A7CB32098, PlayerPedId())
			TriggerServerEvent(exile_burgershot, count, donttouchme)
			FreezeEntityPosition(PlayerPedId(), false)
			blokuj = false
		end)
	else
		ESX.ShowNotification('~r~Nie posiadasz przy sobie Burgerów!')
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
		local carburgershot = GetVehiclePedIsIn(player, false)
		if IsVehicleModel(carburgershot, `velaBG`) then
			ESX.Game.DeleteVehicle(carburgershot)
			alreadyOut = false
		else
			ESX.ShowNotifcation('~r~Możesz zwrócić tylko auto firmowe!')
		end
	else
		if ESX.Game.IsSpawnPointClear(GetEntityCoords(PlayerPedId()), 7) then
			ESX.Game.SpawnVehicle('velaBG', GetEntityCoords(PlayerPedId()), 86.53, function(vehicle)
				platenum = math.random(10, 99)
				SetVehicleNumberPlateText(vehicle, "BURG"..platenum)
				TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
				TriggerServerEvent('exile_burgershot:insertPlayer', GetVehicleNumberPlateText(vehicle))
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
		table.insert(elements, {label = "Zarządzanie frakcją", value = '4'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'burgershot_boss', {
		title    = "burgershot",
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)

		if data.current.value == '1' then
			if PlayerData.job.grade == 7 then
				TriggerEvent('esx_society:openBossMenu', 'burgershot', function(data, menu)
					menu.close()
				end, { showmoney = false, withdraw = false, deposit = true, wash = false, employees = true})
			elseif PlayerData.job.grade >= 8 then
				TriggerEvent('esx_society:openBossMenu', 'burgershot', function(data, menu)
					menu.close()
				end, { showmoney = true, withdraw = true, deposit = true, wash = false, employees = true})
			else
				TriggerEvent('esx_society:openBossMenu', 'burgershot', function(data, menu)
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
						ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'burgershot_courses', elements, function(data, menu)
						end, function(data, menu)
							menu.close()
						end)
                    end
                else
                    ESX.ShowNotification("~r~Lista kursów jest pusta!")
				end
			end, 'burgershot')
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

RegisterNetEvent('exile_burgershot:Cancel')
AddEventHandler('exile_burgershot:Cancel', function()
	local playerPed = PlayerPedId()
	FreezeEntityPosition(playerPed, false)
	ClearPedTasks(playerPed)
end)

AddEventHandler('exile_burgershot:hasEnteredMarker', function(zone, number)

	if zone == 'exitMarker' then
		CurrentAction     = 'exit'
		CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~ aby przerwać ~b~czynność~s~'
		CurrentActionData = {}
	end

	if zone == 'CollectSeeds' then
		CurrentAction		= 'collect'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby zebrać ~b~Składniki"
		CurrentActionData	= {}
	end

	if zone == 'Cloakroom' then
		CurrentAction		= 'cloakroom'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby otworzyć ~b~szatnię"
		CurrentActionData	= {}
	end

	if zone == 'TransferingSeeds' then
		CurrentAction		= 'transfering'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby przerobić ~b~Składniki"
		CurrentActionData	= {}
	end

	if zone == 'SellCoffee' then
		CurrentAction		= 'sell'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby sprzedać ~b~Burgery"
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

AddEventHandler('exile_burgershot:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	TriggerServerEvent('exile_burgershot:stopPickup', zone)

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

OpenMobileburgershotActionsMenu = function()
	while PlayerData == nil do
		Wait(200)
	end
	ESX.UI.Menu.CloseAll()
	local elements = {}
	local playerPed = PlayerPedId()
	local vehicle   = GetVehiclePedIsIn(playerPed, false)
	if IsVehicleModel(vehicle, `velaBG`) then
		if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
			ESX.TriggerServerCallback('exile_burgershot:checkSiedzacy', function(siedzi)
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