RegisterNetEvent("milkman:getrequest")
TriggerServerEvent("milkman:request")
AddEventHandler("milkman:getrequest", function(a, b)
	_G.donttouch = a
	_G.exile_milkma = b
	local donttouchme = _G.donttouch
	local exile_milkmans = _G.exile_milkma
	
local ESX, PlayerData, inProgress, model, bagspawned, haveItem, pCoords, MilkmanBlips, CanWork = nil, {}, false, "prop_bucket_02a", nil, false, nil, {}, false
local HasAlreadyEnteredMarker	= false
local LastZone					= nil
local CurrentAction				= nil
local CurrentActionMsg			= ''
local CurrentActionData			= {}
local tekst = 0
local showTimer = false
local alreadyOut = false

local Cfg = {
	Cows = {
		{
			coords = vector3(954.6544, -2210.7759, 29.6589),
			heading = 267.02
		},
		{
			coords = vector3(955.4708, -2203.4343, 29.64),
			heading = 271.6
		},
		{
			coords = vector3(954.363, -2216.6067, 29.6479),
			heading = 266.2
		},
		{
			coords = vector3(954.1063, -2223.8076, 29.646),
			heading = 263.76
		},
	},
	Wlewanie = {
		{
			coords = vector3(83.2208, -1616.1841, 28.6474),
		},
	},
	Cloakroom = {
		{
			coords = vector3(59.8708, -1579.448, 28.6494),
		},
		{
			coords = vector3(947.3486, -2197.9683, 29.6016),
		},
	},
	Garage = {
		{
			coords = vector3(46.2849, -1575.6256, 28.6556)
		},
		{
			coords = vector3(954.0428, -2197.0891, 29.6016)
		},
	},
	BossActions = {
		{
			coords = vector3(68.0153, -1569.4983, 28.6478)
		},
	},
	Clothes = {
		Male = {
			['tshirt_1'] = 15, ['tshirt_2'] = 0,--TSHIRT
			['torso_1'] = 222, ['torso_2'] = 08, --TUŁÓW
			['arms'] = 20, --RAMIONA
			['pants_1'] = 11, ['pants_2'] = 0, --SPODNIE
			['shoes_1'] = 14, ['shoes_2'] = 1, --BUTY
			['helmet_1'] = -1, ['helmet_2'] = -1, --CZAPKA_TUTAJ_-1_OZNACZA_BRAK_CZAPKI
			['chain_1'] = 0, ['chain_2'] = 0, --ŁAŃCUCH
			['mask_1'] = 0, ['mask_2'] = 0, --MASKA
			['bags_1'] = 0, ['bags_2'] = 0 --TORBA
		},
		Female = {
			['tshirt_1'] = 6, ['tshirt_2'] = 0,--TSHIRT
			['torso_1'] = 232, ['torso_2'] = 8, --TUŁÓW
			['arms'] = 3, --RAMIONA
			['pants_1'] = 15, ['pants_2'] = 0, --SPODNIE
			['shoes_1'] = 27, ['shoes_2'] = 0, --BUTY
			['helmet_1'] = -1, ['helmet_2'] = -1, --CZAPKA_TUTAJ_-1_OZNACZA_BRAK_CZAPKI
			['chain_1'] = 0, ['chain_2'] = 0, --ŁAŃCUCH
			['mask_1'] = 0, ['mask_2'] = 0, --MASKA
			['bags_1'] = 0, ['bags_2'] = 0 --TORBA
		},
	},
}

local blips = {
	{title="#1 Siedziba", colour=4, id=442, coords = vector3(68.625, -1569.7737, 28.6455)},
	{title="#2 Dojenie krów", colour=4, id=442, coords = vector3(955.4286, -2209.3115, 29.655)},
	{title="# Punk dostawy mleka", colour=4, id=442, coords = vector3(83.2208, -1616.1841, 28.6474)}
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
		if PlayerData.job.name == 'milkman' then
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
	if PlayerData.job ~= nil and PlayerData.job.name == 'milkman' then
		for i=1, #blips, 1 do
		--for _, info in pairs(blips) do
			local blip = AddBlipForCoord(blips[i].coords)
			SetBlipSprite(blip, blips[i].id)
			SetBlipDisplay(blip, 4)
			SetBlipScale(blip, 0.9)
			SetBlipColour(blip, blips[i].colour)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(blips[i].title)
			EndTextCommandSetBlipName(blip)

			table.insert(MilkmanBlips, blip)
		end
	end
end

deleteBlip = function()
	if MilkmanBlips[1] ~= nil then
		for i=1, #MilkmanBlips, 1 do
			RemoveBlip(MilkmanBlips[i])
			MilkmanBlips[i] = nil
		end
	end
end
CreateThread(function()
	while PlayerData.job == nil do
		Citizen.Wait(1000)
	end
	while true do
		Citizen.Wait(3)
		if PlayerData.job ~= nil and PlayerData.job.name == 'milkman' then
			local found = false
			local isInMarker	= false
			local currentZone	= nil
			local zoneNumber 	= nil
			for k,v in pairs(Cfg) do
				for i=1, #v, 1 do
					if CanWork or (k == 'Cloakroom' or k == 'BossActions' and PlayerData.job.grade >= 4) then
						if k == 'Wlewanie' or k == 'Garage' or k == 'Cows' then
							if #(pCoords - v[i].coords) < 12.0 then
								found = true
								ESX.DrawBigMarker(vec3(v[i].coords.x, v[i].coords.y, v[i].coords.z))
							end
						else
							if #(pCoords - v[i].coords) < 12.0 then
								found = true
								ESX.DrawMarker(vec3(v[i].coords.x, v[i].coords.y, v[i].coords.z))
							end
						end

						if #(pCoords - v[i].coords) < 3.0 then
							isInMarker	= true
							currentZone = k
							zoneNumber = i
						end
						
					end
				end
			end

			if isInMarker and not hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = true
				lastZone				= currentZone
				TriggerEvent('milkman:hasEnteredMarker', currentZone, zoneNumber)
			end
	
			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('milkman:hasExitedMarker', lastZone)
			end

			if not found then
				Citizen.Wait(2000)
			end
		else
			Citizen.Wait(2000)
		end
	end
end)

--msg
CreateThread(function()
	while true do

		Citizen.Wait(10)
		if PlayerData.job and PlayerData.job.name == 'milkman' then

			if CurrentAction ~= nil then

				ESX.ShowHelpNotification(CurrentActionMsg)

				if IsControlJustReleased(0, 38) then
					if CurrentAction == 'collect' then
						if not inProgress then
							StartCollect()
						end
					elseif CurrentAction == 'wlewanie' then
						Sell()
					elseif CurrentAction == 'cloakroom' then
						OpenCloakroom()
					elseif CurrentAction == 'garage' then
						CarOut()
					elseif CurrentAction == 'boss_actions' then
						OpenBossMenu()
					end
					CurrentAction = nil
				end
			end

			if IsControlJustReleased(0, 167) and IsInputDisabled(0) and PlayerData.job.grade >= 6 then
				OpenMobileMilkmanActionsMenu()
			end
		else
			Citizen.Wait(2000)
		end
	end
end)

StartCollect = function()
	ESX.TriggerServerCallback('gcphone:getItemAmount', function(count)
		if count < 100 then
			inProgress = true
			playerPed = PlayerPedId()
			ClearPedTasks(PlayerPedId())
			FreezeEntityPosition(playerPed, true)
			Wiadro()
			TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
			Timer(1500)

		else
			ESX.ShowNotification('~y~Nie uniesiesz więcej butelek z mlekiem!')
		end
	end, 'milk_in_pail')
end

Wiadro = function()
	local playerPed = PlayerPedId()
	local forward   = GetEntityForwardVector(playerPed)
	local x, y, z   = table.unpack(pCoords + forward * 1.0)
	if haveItem == false then
		ESX.Game.SpawnObject(model, {
			x = x,
			y = y,
			z = z
		}, function(obj)
			SetEntityHeading(obj, GetEntityHeading(playerPed))
			PlaceObjectOnGroundProperly(obj)
			Citizen.Wait(10000)
			DeleteObject(obj)
		end)
	end
end

CarOut = function()
	local player = PlayerPedId()
	if IsPedInAnyVehicle(player, false) then
		local carMilk = GetVehiclePedIsIn(player, false)
		if IsVehicleModel(carMilk, `milkman`) then
			ESX.Game.DeleteVehicle(carMilk)
			alreadyOut = false
		else
			ESX.ShowNotifcation('~r~Możesz zwrócić tylko auto firmowe!')
		end
	else
		if ESX.Game.IsSpawnPointClear(pCoords, 7) then
			ESX.Game.SpawnVehicle('milkman', pCoords, 139.13, function(vehicle)
				platenum = math.random(10, 99)
				SetVehicleNumberPlateText(vehicle, "MILKMAN"..platenum)
				TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
				TriggerServerEvent('exile_milkman:insertPlayer', GetVehicleNumberPlateText(vehicle))
			end)
			alreadyOut = true
		else
			ESX.ShowNotification('~r~Miejsce parkingowe jest już zajęte przez inny pojazd!')
		end
	end
end

CreateThread(function()
	RequestModel(`a_c_cow`)
	while not HasModelLoaded(`a_c_cow`) do
		Wait(155)
	end
	for k, v in pairs(Cfg) do
		if k == 'Cows' then
			for i=1, #v, 1 do
				local ped =  Citizen.InvokeNative(0xD49F9B0955C367DE, 4, `a_c_cow`, v[i].coords.x, v[i].coords.y, v[i].coords.z, v[i].heading, false, true)
				FreezeEntityPosition(ped, true)
				SetEntityInvincible(ped, true)
				SetBlockingOfNonTemporaryEvents(ped, true)
			end
		end
	end
end)

function OpenBossMenu()
	local elements = {
		{label = "Akcje szefa", value = '1'},
    }
    if PlayerData.job.grade >= 6 then
		table.insert(elements, {label = "Lista kursów", value = '2'})
		table.insert(elements, {label = "Zarządzanie frakcją", value = '4'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'milkman_boss', {
		title    = "Mleczarz",
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)

		if data.current.value == '1' then
			if PlayerData.job.grade >= 7 then
				TriggerEvent('esx_society:openBossMenu', 'milkman', function(data, menu)
					menu.close()
				end, { showmoney = true, withdraw = true, deposit = true, wash = false, employees = true})
			elseif PlayerData.job.grade == 6 then
				TriggerEvent('esx_society:openBossMenu', 'milkman', function(data, menu)
					menu.close()
				end, { showmoney = false, withdraw = false, deposit = true, wash = false, employees = true})
			else
				TriggerEvent('esx_society:openBossMenu', 'milkman', function(data, menu)
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
						ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'milkman', elements, function(data, menu)
						end, function(data, menu)
							menu.close()
						end)
                    end
                else
                    ESX.ShowNotification("~r~Lista kursów jest pusta!")
				end
			end, 'milkman')
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

function OpenCloakroom()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
	{
		title    = 'Przebieralnia',
		align = 'center',
		elements = {
			{label = 'Ubrania robocze',     value = 'job_wear'},
			{label = 'Ubrania prywane', value = 'citizen_wear'}
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

AttachProp = function()
	loadModel(model)
	Citizen.Wait(10000)
end

Sell = function()
	if not IsPedSittingInAnyVehicle(PlayerPedId()) then
		ESX.TriggerServerCallback('gcphone:getItemAmount', function(count)
			if count > 0 then
				local playerPed = PlayerPedId()
				local lib, anim = 'gestures@m@standing@casual', 'gesture_easy_now'
				loadAnimDict('gestures@m@standing@casual')
				FreezeEntityPosition(playerPed, true)
				DetachEntity(bagspawned, 1, 1)
				ClearPedSecondaryTask(playerPed)
				TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
				exports["exile_taskbar"]:taskBar(60000, "Sprzedawanie mleka", false, true)	
				TriggerServerEvent(exile_milkmans, donttouchme)
				DeleteObject(bagspawned)
				haveItem = false
				FreezeEntityPosition(playerPed, false)
				inProgress = false
			else
				ESX.ShowNotification("~r~Nie posiadasz przy sobie mleka!")
			end
		end, 'milk_in_pail')
	else
		ESX.ShowNotification("~r~Nie możesz sprzedawać mleka będąc w aucie!")
	end
end


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
	TriggerEvent('milkman:DrawPercent')
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

RegisterNetEvent('milkman:DrawPercent')
AddEventHandler('milkman:DrawPercent', function()
	showTimer = true
	while (showTimer) do
		Wait(0)
		DisableControlAction(0, 73, true) -- X
		DrawText3D(pCoords.x, pCoords.y, pCoords.z + 0.1, tekst .. '~g~%', 0.4)
    end
end)

StopCollect = function()
	TriggerServerEvent('milkman:CollectMilk', donttouchme)
	inProgress = false
	FreezeEntityPosition(playerPed, false)
	ClearPedTasks(PlayerPedId())
	AttachProp()
	haveItem = true
end

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

function loadModel(model)
	while not HasModelLoaded(model) do
		RequestModel(model)
		Citizen.Wait(5)
	end
end


AddEventHandler('milkman:hasEnteredMarker', function(zone, number)

	if zone == 'Cows' then
		CurrentAction		= 'collect'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby zebrać ~y~mleko"
		CurrentActionData	= {}
	end

	if zone == 'Wlewanie' then
		CurrentAction		= 'wlewanie'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby sprzedać ~y~mleko"
		CurrentActionData	= {}
	end

	if zone == 'Cloakroom' then
		CurrentAction		= 'cloakroom'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby się ~y~przebrać"
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

AddEventHandler('milkman:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()

	CurrentAction = nil
end)

OpenMobileMilkmanActionsMenu = function()
	while PlayerData == nil do
		Wait(200)
	end
	ESX.UI.Menu.CloseAll()
	local elements = {}
	local playerPed = PlayerPedId()
	local vehicle   = GetVehiclePedIsIn(playerPed, false)
	if IsVehicleModel(vehicle, `milkman`) then
		if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
			ESX.TriggerServerCallback('exile_milkman:checkSiedzacy', function(siedzi)
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