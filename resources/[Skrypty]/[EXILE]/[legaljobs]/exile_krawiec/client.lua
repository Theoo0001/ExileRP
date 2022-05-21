RegisterNetEvent("exile_krawiec:getrequest")
TriggerServerEvent("exile_krawiec:request")
AddEventHandler("exile_krawiec:getrequest", function(a, b, c)
	_G.donttouch = a
	_G.exile_krawic = b
	_G.exile_krawi2 = c

	local donttouchme = _G.donttouch
	local exile_krawiec = _G.exile_krawic
	local exile_krawiec2 = _G.exile_krawi2

local ESX, PlayerData, inProgress, pCoords, CafeBlips, CanWork = nil, {}, false, nil, {}, false
local HasAlreadyEnteredMarker	= false
local LastZone					= nil
local CurrentAction				= nil
local CurrentActionMsg			= ''
local CurrentActionData			= {}
local alreadyOut, inAction = false
local cooldown = false

local Cfg = {
	CollectSeeds = {
		{
			coords = vector3(190.9591, -1454.438, 28.1917),
		},
	},
	TransferingSeeds = {
		{
			coords = vector3(743.9279, -969.6373, 23.6324),
		},
	},
	SellCoffee = {
		{
			coords = vector3(429.6236, -809.1897, 28.5412),
		},
	},
	Garage = {
		{
			coords = vector3(711.1369, -979.6774, 23.1605)
		},
	},
	BossActions = {
		{
			coords = vector3(707.104, -966.7446, 29.4628)
		},
	},
	Cloakroom = {
		{
			coords = vector3(708.7081, -959.5554, 29.4453)
		},
	},
	Clothes = {
		Male = {
            ['tshirt_1'] = 15, ['tshirt_2'] = 0,
            ['torso_1'] = 234, ['torso_2'] = 11,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 26,
            ['pants_1'] = 160, ['pants_2'] = 2,
            ['shoes_1'] = 105, ['shoes_2'] = 5,
            ['helmet_1'] = -1, ['helmet_2'] = 0,
            ['chain_1'] = 1, ['chain_2'] = 0,
            ['ears_1'] = -1, ['ears_2'] = 0,
            ['bproof_1'] = 0, ['bproof_2'] = 0,
            ['mask_1'] = 0, ['mask_2'] = 0,
            ['bags_1'] = 107, ['bags_2'] = 1
        },
		Female = {
            ['tshirt_1'] = 15, ['tshirt_2'] = 0,
            ['torso_1'] = 234, ['torso_2'] = 11,
            ['decals_1'] = 0, ['decals_2'] = 0,
            ['arms'] = 26,
            ['pants_1'] = 160, ['pants_2'] = 2,
            ['shoes_1'] = 105, ['shoes_2'] = 5,
            ['helmet_1'] = -1, ['helmet_2'] = 0,
            ['chain_1'] = 1, ['chain_2'] = 0,
            ['ears_1'] = -1, ['ears_2'] = 0,
            ['bproof_1'] = 0, ['bproof_2'] = 0,
            ['mask_1'] = 0, ['mask_2'] = 0,
            ['bags_1'] = 107, ['bags_2'] = 1
        },
	},
}

local Blips = {
	{title="#1 Szatnia", colour=2, id=366, see = true, coords = vector3(708.7081, -959.5554, 29.4453)},
	{title="#2 Zbieranie materiału", colour=2, id=366, see = true, coords = vector3(190.9591, -1454.438, 28.1917)},
	{title="#3 Przeróbka materiału", colour=2, id=366, see = true, coords = vector3(740.9933, -969.8665, 23.5263)},
	{title="#4 Punkt dostawy ubrań", colour=2, id=366, see = true, coords = vector3(429.6236, -809.1897, 28.5412)}
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
		if PlayerData.job.name == 'krawiec' then
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
	if PlayerData.job ~= nil and PlayerData.job.name == 'krawiec' then
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
		Citizen.Wait(1)
		if PlayerData.job ~= nil and PlayerData.job.name == 'krawiec' then
			local found = false
			local isInMarker	= false
			local currentZone	= nil
			local zoneNumber 	= nil
			for k,v in pairs(Cfg) do
				for i=1, #v, 1 do
					if CanWork or (k == 'Cloakroom' or k == 'BossActions' and PlayerData.job.grade >= 7 or k == 'SellCoffee' and PlayerData.job.grade >= 7) then
						if k == 'SellCoffee' then
							if #(pCoords - v[i].coords) < 15.0 then
								found = true
								ESX.DrawMarker(vec3(v[i].coords.x, v[i].coords.y, v[i].coords.z))
							end
						elseif k == 'CollectSeeds' or k == 'Garage' or k == 'TransferingSeeds' then
							if #(pCoords - v[i].coords) < 15.0 then
								found = true
								ESX.DrawBigMarker(vec3(v[i].coords.x, v[i].coords.y, v[i].coords.z))
							end
						else
							if #(pCoords - v[i].coords) < 15.0 then
								found = true
								ESX.DrawMarker(vec3(v[i].coords.x, v[i].coords.y, v[i].coords.z))
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
				TriggerEvent('exile_krawiec:hasEnteredMarker', currentZone, zoneNumber)
			end
	
			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('exile_krawiec:hasExitedMarker', lastZone)
			end

			if isInMarker and inAction then
				TriggerEvent('exile_krawiec:hasEnteredMarker', 'exitMarker')
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
		if PlayerData.job and PlayerData.job.name == 'krawiec' then

			if CurrentAction ~= nil and not cooldown then

				ESX.ShowHelpNotification(CurrentActionMsg)

				if IsControlJustReleased(0, 38) then
					if CurrentAction == 'collect' then
						StartCollect()
						inAction = true
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
				OpenMobileKrawiecActionsMenu()
			end
		else
			Citizen.Wait(2000)
		end
	end
end)





StartCollect = function()
	local playerPed = PlayerPedId()
	TriggerServerEvent('exile_krawiec:collect', 'material_krawiec')
	ClearPedTasks(playerPed)
	FreezeEntityPosition(playerPed, true)
	--TaskStartScenarioInPlace(playerPed, "machinic_loop_mechandplayer", 0, true)
	TaskPlayAnim(playerPed, 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 8.0, -8.0, -1, 1, 0, false, false, false)
end

TransferingSeeds = function()
	ESX.UI.Menu.CloseAll()
	local inventory = ESX.GetPlayerData().inventory
	local count = 0
	for i=1, #inventory, 1 do
		if inventory[i].name == 'material_krawiec' then
			count = inventory[i].count
		end
	end

	if count >= 100 then
		ESX.ShowNotification('~y~Trwa przygotowywanie ubrań...')
		DisableControlAction(0, 289, true) -- F2
		FreezeEntityPosition(PlayerPedId(), true)
		--TaskPlayAnim(playerPed, 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 8.0, -8.0, -1, 51, 0, false, false, false)
			exports['ExileRP']:DrawProcent(600, function()
				Citizen.InvokeNative(0xAAA34F8A7CB32098, PlayerPedId())
				TriggerServerEvent(exile_krawiec2, count, donttouchme)
				FreezeEntityPosition(PlayerPedId(), false)
				DisableControlAction(0, 289, false) -- F2
				ClearPedTasks(PlayerPedId())
		end)
	else
		ESX.ShowNotification('~r~Potrzebujesz 100 materiału aby rozpocząć przerabianie!')
	end
end

SellCoffee = function()
	ESX.UI.Menu.CloseAll()
	local inventory = ESX.GetPlayerData().inventory
	local count = 0
	for i=1, #inventory, 1 do
		if inventory[i].name == 'ubrania_krawiec' then
			count = inventory[i].count
		end
	end
	if count > 0 then
		ESX.ShowNotification('~y~Trwa sprzedaż ubrań...')
		FreezeEntityPosition(PlayerPedId(), true)
		--TaskPlayAnim(playerPed, 'mini@repair', 'fixing_a_ped', 8.0, -8.0, -1, 1, 0, false, false, false)
			exports['ExileRP']:DrawProcent(1200, function()
				Citizen.InvokeNative(0xAAA34F8A7CB32098, PlayerPedId())
				TriggerServerEvent(exile_krawiec, count, donttouchme)
				FreezeEntityPosition(PlayerPedId(), false)
			end)
	else
		ESX.ShowNotification('~r~Nie posiadasz przy sobie ubrań!')
	end
end

CarOut = function()
	local player = PlayerPedId()
	if IsPedInAnyVehicle(player, false) then
		local carCafe = GetVehiclePedIsIn(player, false)
		if IsVehicleModel(carCafe, `flybeliodas`) then
			ESX.Game.DeleteVehicle(carCafe)
			alreadyOut = false
		else
			ESX.ShowNotifcation('~r~Możesz zwrócić tylko auto firmowe!')
		end
	else
		if ESX.Game.IsSpawnPointClear(Cfg.Garage[1].coords, 7) then
			ESX.Game.SpawnVehicle('flybeliodas', Cfg.Garage[1].coords, 227.04, function(vehicle)
				platenum = math.random(10, 99)
				SetVehicleNumberPlateText(vehicle, "KRAW"..platenum)
				TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
				TriggerServerEvent('exile_krawiec:insertPlayer', GetVehicleNumberPlateText(vehicle))
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

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'krawiec_boss', {
		title    = "Fly Beliodas",
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)

		if data.current.value == '1' then
			if PlayerData.job.grade == 7 then
				TriggerEvent('esx_society:openBossMenu', 'krawiec', function(data, menu)
					menu.close()
				end, { showmoney = false, withdraw = false, deposit = true, wash = false, employees = true})
			elseif PlayerData.job.grade >= 8 then
				TriggerEvent('esx_society:openBossMenu', 'krawiec', function(data, menu)
					menu.close()
				end, { showmoney = true, withdraw = true, deposit = true, wash = false, employees = true})
			else
				TriggerEvent('esx_society:openBossMenu', 'krawiec', function(data, menu)
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
							grade = 'Okres Próbny'
						elseif kursy[i].job_grade == 1 then
							grade = 'Rekrut'
						elseif kursy[i].job_grade == 2 then
							grade = 'Pracownik'
						elseif kursy[i].job_grade == 3 then
							grade = 'Stażysta'
						elseif kursy[i].job_grade == 4 then
							grade = 'Zawodowiec'
						elseif kursy[i].job_grade == 5 then
							grade = 'Specjalista'
						elseif kursy[i].job_grade == 6 then
							grade = 'Koordynator'
						elseif kursy[i].job_grade == 7 then
							grade = 'Manager'
						elseif kursy[i].job_grade == 8 then
							grade = 'Zastępca'
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
						ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'krawiec_courses', elements, function(data, menu)
						end, function(data, menu)
							menu.close()
						end)
                    end
                else
                    ESX.ShowNotification("~r~Lista kursów jest pusta!")
				end
			end, 'krawiec')
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

RegisterNetEvent('exile_krawiec:Cancel')
AddEventHandler('exile_krawiec:Cancel', function()
	local playerPed = PlayerPedId()
	FreezeEntityPosition(playerPed, false)
	ClearPedTasks(playerPed)
end)

AddEventHandler('exile_krawiec:hasEnteredMarker', function(zone, number)

	if zone == 'exitMarker' then
		CurrentAction     = 'exit'
		CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~ aby przerwać ~g~czynność~s~'
		CurrentActionData = {}
	end

	if zone == 'CollectSeeds' then
		CurrentAction		= 'collect'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby zebrać ~g~materiał"
		CurrentActionData	= {}
	end

	if zone == 'Cloakroom' then
		CurrentAction		= 'cloakroom'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby otworzyć ~g~szatnię"
		CurrentActionData	= {}
	end

	if zone == 'TransferingSeeds' then
		CurrentAction		= 'transfering'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby przerobić ~g~materiał"
		CurrentActionData	= {}
	end

	if zone == 'SellCoffee' then
		CurrentAction		= 'sell'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby sprzedać ~g~ubrania"
		CurrentActionData	= {}
	end

	if zone == 'Garage' then
		if IsPedInAnyVehicle(PlayerPedId(), false) then
			msg = "Naciśnij ~INPUT_CONTEXT~, aby schować ~g~pojazd"
		else
			msg = "Naciśnij ~INPUT_CONTEXT~, aby wyciągnąć ~g~pojazd"
		end
		CurrentAction		= 'garage'
		CurrentActionMsg	= msg
		CurrentActionData	= {}
	end

	
	if zone == 'BossActions' then
		CurrentAction		= 'boss_actions'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~ aby otworzyć ~g~menu zarządzania"
		CurrentActionData	= {}
	end
end)

AddEventHandler('exile_krawiec:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	TriggerServerEvent('exile_krawiec:stopPickup', zone)

	CurrentAction = nil

	cooldown = true
	if zone == 'CollectSeeds' then
		Citizen.Wait(90000)
		cooldown = false
	else
		Citizen.Wait(2000)
		cooldown = false
	end
end)

OpenMobileKrawiecActionsMenu = function()
	while PlayerData == nil do
		Wait(200)
	end
	ESX.UI.Menu.CloseAll()
	local elements = {}
	local playerPed = PlayerPedId()
	local vehicle   = GetVehiclePedIsIn(playerPed, false)
	if IsVehicleModel(vehicle, `flybeliodas`) then
		if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
			ESX.TriggerServerCallback('exile_krawiec:checkSiedzacy', function(siedzi)
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