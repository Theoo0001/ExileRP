RegisterNetEvent("fisherman:getrequest")
TriggerServerEvent("fisherman:request")
AddEventHandler("fisherman:getrequest", function(a, b, c)
	_G.donttouch = a
	_G.exile_fishermanit = b
	_G.exile_fis = c

	local donttouchme = _G.donttouch
	local exile_fishermanitem = _G.exile_fishermanit
	local exile_fish = _G.exile_fis



local ESX, PlayerData, pCoords, FishermanBlips, CanWork = nil, {}, nil, {}, false, nil, nil, nil
local HasAlreadyEnteredMarker	= false
local LastZone					= nil
local CurrentAction				= nil
local CurrentActionMsg			= ''
local CurrentActionData			= {}
local alreadyOut, Fishing, cd, bait = false
local time, tekst = 0
local timeToCatch = 5
local tekst = 0
local showTimer = false

local inAction = false
local Cfg = {
	Center = {
		{
			coords = vector3(-786.7534, -1349.0989, 4.2623),
		},
	},
	FishingPlace = {
		{
			coords = vector3(-1859.2025, -1241.748, 7.6661),
		},
		{
			coords = vector3(-1850.7021, -1248.3145, 7.6661),
		},
		{
			coords = vector3(-1842.5516, -1255.2446, 7.6661),
		},
	},
	BossActions = {
		{
			coords = vector3(-799.393, -1351.8732, 4.2674)
		},
	},
	Garage = {
		{
			coords = vector3(-778.5615, -1333.7191, 4.0504)
		},
	},
	SellFishes = {
		{
			coords = vector3(1127.8434, -990.743, 45.0089)
		},
	},
}

local Clothes = {
	Male = {
        ['tshirt_1'] = 15, ['tshirt_2'] = 0,--TSHIRT
        ['torso_1'] = 420, ['torso_2'] = 3, --TUŁÓW
        ['arms'] = 41, --RAMIONA
        ['pants_1'] = 15, ['pants_2'] = 3, --SPODNIE
        ['shoes_1'] = 14, ['shoes_2'] = 0, --BUTY
        ['helmet_1'] = -1, ['helmet_2'] = 0, --CZAPKA_TUTAJ_-1_OZNACZA_BRAK_CZAPKI
        ['chain_1'] = 0, ['chain_2'] = 0, --ŁAŃCUCH
        ['mask_1'] = 0, ['mask_2'] = 0, --MASKA
        ['bags_1'] = 0, ['bags_2'] = 0 --TORBA
    },
    Female = {
        ['tshirt_1'] = 6, ['tshirt_2'] = 0,--TSHIRT
        ['torso_1'] = 440, ['torso_2'] = 1, --TUŁÓW
        ['arms'] = 14, --RAMIONA
        ['pants_1'] = 31, ['pants_2'] = 2, --SPODNIE
        ['shoes_1'] = 27, ['shoes_2'] = 0, --BUTY
        ['helmet_1'] = -1, ['helmet_2'] = 0, --CZAPKA_TUTAJ_-1_OZNACZA_BRAK_CZAPKI
        ['chain_1'] = 0, ['chain_2'] = 0, --ŁAŃCUCH
        ['mask_1'] = 0, ['mask_2'] = 0, --MASKA
        ['bags_1'] = 0, ['bags_2'] = 0 --TORBA
	},
}

local blips = {
	{title="#1 Siedziba", colour=3, id=68, coords = Cfg.Center[1].coords},
	{title="#2 Łowisko", colour=3, id=68, coords = Cfg.FishingPlace[1].coords},
	{title="# Punkt dostawy ryb", colour=3, id=68, coords = Cfg.SellFishes[1].coords}
}

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
		if PlayerData.job.name == 'fisherman' then
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

CreateThread(function()
	while PlayerData.job == nil do
		Citizen.Wait(1000)
	end
	while true do
		Citizen.Wait(3)
		if PlayerData.job ~= nil and PlayerData.job.name == 'fisherman' then
			local found = false
			local isInMarker	= false
			local currentZone	= nil
			local zoneNumber 	= nil
			for k,v in pairs(Cfg) do
				for i=1, #v, 1 do
					if CanWork or k == 'Center' or (k == 'BossActions' and PlayerData.job.grade >= 4) then
						if k == 'Center' or k == 'BossActions' then
							if #(pCoords - v[i].coords) < 12.0 then
								found = true
								ESX.DrawMarker(vec3(v[i].coords.x, v[i].coords.y, v[i].coords.z))
							end
						elseif k == 'Garage' or k == 'SellFishes' then
							if #(pCoords - v[i].coords) < 30.0 then
								found = true
								ESX.DrawBigMarker(vec3(v[i].coords.x, v[i].coords.y, v[i].coords.z))
							end
						end

						if k == 'Center' or k == 'BossActions' then
							if #(pCoords - v[i].coords) < 1.0 then
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
				TriggerEvent('fisherman:hasEnteredMarker', currentZone, zoneNumber)
			end
	
			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('fisherman:hasExitedMarker', lastZone)
			end

			if not found then
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

--msg
CreateThread(function()
	while true do
		Citizen.Wait(10)
		if PlayerData.job ~= nil and PlayerData.job.name == 'fisherman' then
			if CurrentAction ~= nil then
				ESX.ShowHelpNotification(CurrentActionMsg)
				if IsControlJustReleased(0, 38) then
					if CurrentAction == 'center' then
						OpenFishermanMenu()
					elseif CurrentAction == 'boss_actions' then
						OpenBossMenu()
					elseif CurrentAction == 'garage' then
						CarOut()
					elseif CurrentAction == 'sell' then
						SellFishes()
					end
					CurrentAction = nil
				end
			end

			if IsControlJustReleased(0, 167) and IsInputDisabled(0) and PlayerData.job.grade >= 6 then
				OpenMobileFishermanActionsMenu()
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

RegisterNetEvent('fisherman:startFishing')
AddEventHandler('fisherman:startFishing', function()
	if PlayerData.job ~= nil and PlayerData.job.name == 'fisherman' then
		if CanWork then
			if canUse(pCoords) then
				if not IsPedInAnyVehicle(PlayerPedId(), false) then
					if not IsPedSwimming(PlayerPedId()) then
						
						if ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
							ESX.UI.Menu.Close('default', 'es_extended', 'inventory')
						elseif ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory_item') then
							ESX.UI.Menu.Close('default', 'es_extended', 'inventory_item')
						end
						if not inAction then
							ESX.TriggerServerCallback('gcphone:getItemAmount', function(count)
								if count < 100 then
									ESX.ShowNotification('~b~Rozpoczęto łowienie')
									TriggerServerEvent('fisherman:removeItem', 'fishingfood', 1)
									Fishing = true
								else
									ESX.ShowNotification('~r~Posiadasz~s~ limit ryb')
								end
							end, 'fish')
						else
							ESX.ShowNotification('~r~Poczekaj do zakończenia obecnej pracy')
						end
					else
						ESX.ShowNotification("~r~Nie możesz łowić będąc w wodzie!")
					end
				else
					ESX.ShowNotification('~r~Nie możesz łowić będąc w aucie!')
				end
			else
				ESX.ShowNotification("~r~W tym miejscu nie można łowić, udaj się na koniec molo!")
			end
		else
			ESX.ShowNotification("Aby rozpocząć pracę musisz się przebrać w ~b~strój roboczy!")
		end
	end
end)

AddEventHandler('fisherman:hasEnteredMarker', function(zone, number)

	if zone == 'Center' then
		CurrentAction		= 'center'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby otworzyć ~b~menu"
		CurrentActionData	= {}
	end

	if zone == 'SellFishes' then
		CurrentAction		= 'sell'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby sprzedać ~b~ryby"
		CurrentActionData	= {}
	end
	
	if zone == 'BossActions' then
		CurrentAction		= 'boss_actions'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~ aby otworzyć ~y~menu zarządzania"
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
end)

AddEventHandler('fisherman:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()

	CurrentAction = nil
end)



CreateThread(function()
	while true do
		Wait(0)
	if PlayerData.job ~= nil and PlayerData.job.name == 'fisherman' then
			if Fishing then
				if not IsPedActiveInScenario(PlayerPedId()) then
					TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_STAND_FISHING", 0, false)
					SetEntityHeading(PlayerPedId(), 138.25)
				end
				if not inAction then
					inAction = true
					Timer(900)
				end			
			end
		else
		Wait(500)
		end
	end
end)

function Timer(time)
	TriggerEvent('exile_fisherman:DrawPercent')
	CreateThread(function()
		tekst = 0
		repeat
			tekst = tekst + 1
			Citizen.Wait(time)
		until tekst == 100
		showTimer = false
		inAction = false
		Fishing = false
		TriggerServerEvent(exile_fishermanitem, 'fish', 20, donttouchme)
		ESX.ShowNotification('Złowiono ~g~20 ryb')
		Citizen.InvokeNative(0xAAA34F8A7CB32098, PlayerPedId())
		local fishingRod = GetClosestObjectOfType(pCoords, 2.0, `prop_fishing_rod_01`, false, false, false)
		if fishingRod ~= 0 and fishingRod ~= nil then
			SetEntityAsMissionEntity(fishingRod, true, true)
			DeleteEntity(fishingRod)
		end
	end)
end


RegisterNetEvent('exile_fisherman:DrawPercent')
AddEventHandler('exile_fisherman:DrawPercent', function()
	showTimer = true

	while (showTimer) do
		Wait(0)
		DisableControlAction(0, 73, true) -- X
		DrawText3D(pCoords.x, pCoords.y, pCoords.z + 0.1, tekst .. '~g~%', 0.4)
    end
end)

refreshBlips = function()
	if PlayerData.job ~= nil and PlayerData.job.name == 'fisherman' then
		for i=1, #blips, 1 do
			local blip = AddBlipForCoord(blips[i].coords)
			SetBlipSprite(blip, blips[i].id)
			SetBlipDisplay(blip, 4)
			SetBlipScale(blip, 0.9)
			SetBlipColour(blip, blips[i].colour)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(blips[i].title)
			EndTextCommandSetBlipName(blip)

			table.insert(FishermanBlips, blip)
		end
	end
end

OpenBossMenu = function()
	local elements = {
		{label = "Akcje szefa", value = '1'},
    }
    if PlayerData.job.grade >= 6 then
		table.insert(elements, {label = "Lista kursów", value = '2'})
		table.insert(elements, {label = "Zarządzanie frakcją", value = '3'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fisherman_boss', {
		title    =  PlayerData.job.label,
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)

		if data.current.value == '1' then
			if PlayerData.job.grade == 6 then
				TriggerEvent('esx_society:openBossMenu', 'fisherman', function(data, menu)
					menu.close()
				end, { showmoney = false, withdraw = false, deposit = true, wash = false, employees = true})
			elseif PlayerData.job.grade >= 7 then
				TriggerEvent('esx_society:openBossMenu', 'fisherman', function(data, menu)
					menu.close()
				end, { showmoney = true, withdraw = true, deposit = true, wash = false, employees = true})
			else
				TriggerEvent('esx_society:openBossMenu', 'fisherman', function(data, menu)
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
							grade = 'Rekrut'
						elseif kursy[i].job_grade == 1 then
							grade = 'Nowicjusz'
						elseif kursy[i].job_grade == 2 then
							grade = 'Pracownik'
						elseif kursy[i].job_grade == 3 then
							grade = 'Fachowiec'
						elseif kursy[i].job_grade == 4 then
							grade = 'Zawodowiec'
						elseif kursy[i].job_grade == 5 then
							grade = 'Specjalista'
						elseif kursy[i].job_grade == 6 then
							grade = 'Manager'
						elseif kursy[i].job_grade == 7 then
							grade = 'Zastępca szefa'
						elseif kursy[i].job_grade == 8 then
							grade = 'Właściciel'
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
						ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'fisherman', elements, function(data, menu)
						end, function(data, menu)
							menu.close()
						end)
                    end
                else
                    ESX.ShowNotification("~r~Lista kursów jest pusta!")
				end
			end, 'fisherman')
		elseif data.current.value == '3' then
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

SellFishes = function()
	local inventory = ESX.GetPlayerData().inventory
	local count = 0
	for i=1, #inventory, 1 do
		if inventory[i].name == 'fish' then
			count = inventory[i].count
		end
	end

	if count > 0 then
		local playerPed = PlayerPedId()
		local lib, anim = 'gestures@m@standing@casual', 'gesture_easy_now'
		loadAnimDict('gestures@m@standing@casual')
		FreezeEntityPosition(playerPed, true)
		ClearPedSecondaryTask(playerPed)
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
		ESX.ShowNotification('~y~Trwa sprzedawanie ryb...')
		Citizen.Wait(math.random(30000, 40000))
		TriggerServerEvent(exile_fish, donttouchme)
		FreezeEntityPosition(playerPed, false)
	else
		ESX.ShowNotification("~r~Nie posiadasz przy sobie ryb!")
	end
end

loadAnimDict = function(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

deleteBlip = function()
	if FishermanBlips[1] ~= nil then
		for i=1, #FishermanBlips, 1 do
			RemoveBlip(FishermanBlips[i])
			FishermanBlips[i] = nil
		end
	end
end

canUse = function(coords)
	for k,v in pairs(Cfg.FishingPlace) do
		if #(v.coords - coords) < 10.0 then
			return true
		end	
	end
	return false
end

OpenFishermanMenu = function()
	local elements = {
		{label = "<span style='color: #33ccff;'>Strój roboczy</span>", value = 'worksuit'},
		{label = "Strój prywatny", value = 'privatesuit'},
		{label = "===============", value = 'nil'},
		{label = "Odbierz wędkę", value = 'fishingrod'},
		{label = "Odbierz przynętę", value = 'fishingfood'},
    }

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'milkman_boss', {
		title    = PlayerData.job.label,
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
			if data.current.value == 'worksuit' then
				CanWork = true
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, Clothes.Male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, Clothes.Female)
				end
				ESX.ShowNotification('Wyciągnij ~b~pojazd ~w~z garażu, a następnie udaj się na ~b~łowisko')
			elseif data.current.value == 'privatesuit' then
				CanWork = false
				TriggerEvent('skinchanger:loadSkin', skin)
			elseif data.current.value == 'fishingrod' then
				TriggerServerEvent(exile_fishermanitem, 'fishingrod', 1, donttouchme)

			elseif data.current.value == 'fishingfood' then
				TriggerServerEvent(exile_fishermanitem, 'fishingfood', 100, donttouchme)
			else
				return
			end
		end)
		menu.close()
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'center'
		CurrentActionMsg  = "Naciśnij ~INPUT_CONTEXT~, aby otworzyc ~b~menu"
		CurrentActionData = {}
	end)
end

CarOut = function()
	local player = PlayerPedId()
	if IsPedInAnyVehicle(player, false) then
		local carMilk = GetVehiclePedIsIn(player, false)
		if IsVehicleModel(carMilk, `autorybak`) then
			ESX.Game.DeleteVehicle(carMilk)
			alreadyOut = false
		else
			TriggerEvent('esx:showNotification', '~r~Możesz zwrócić tylko auto firmowe!')
		end
	else
		if ESX.Game.IsSpawnPointClear(Cfg.Garage[1].coords, 7) then
			ESX.Game.SpawnVehicle('autorybak', Cfg.Garage[1].coords, 86.51, function(vehicle)
				platenum = math.random(10, 99)
				SetVehicleNumberPlateText(vehicle, "SLEDZ"..platenum)
				TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
				TriggerServerEvent('exile_fisherman:insertPlayer', GetVehicleNumberPlateText(vehicle))
			end)
			alreadyOut = true
		else
			ESX.ShowNotification('~r~Miejsce parkingowe jest już zajęte przez inny pojazd!')
		end
	end
end

DrawText3D = function(x, y, z, text, scale)
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
	DrawRect(_x, _y + 0.015, 0.001 + factor, 0.03, 31, 31, 31, 155)
end

OpenMobileFishermanActionsMenu = function()
	while PlayerData == nil do
		Wait(200)
	end
	ESX.UI.Menu.CloseAll()
	local elements = {}
	local playerPed = PlayerPedId()
	local vehicle   = GetVehiclePedIsIn(playerPed, false)
	if IsVehicleModel(vehicle, `autorybak`) then
		if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
			ESX.TriggerServerCallback('exile_fisherman:checkSiedzacy', function(siedzi)
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
			ESX.ShowNotification("~r~Musisz znajdować się w pojeździe jako kierwoca!")
		end
	end
end

end)