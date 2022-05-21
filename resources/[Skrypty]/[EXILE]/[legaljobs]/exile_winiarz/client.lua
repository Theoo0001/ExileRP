RegisterNetEvent("exile_winiarz:getrequest")
TriggerServerEvent("exile_winiarz:request")
AddEventHandler("exile_winiarz:getrequest", function(a, b, c, d)
	_G.donttry = a
	_G.exile_ca = b
	_G.exile_ca2 = c
	_G.exile_ca3 = d
	local donttouchme = _G.donttry
	local exile_winiarz = _G.exile_ca
	local exile_winiarz2 = _G.exile_ca2
	local exile_winiarz3 = _G.exile_ca3
local ESX, PlayerData, inProgress, pCoords, WiniarzBlips, CanWork = nil, {}, false, nil, {}, false
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
			coords = vector3(-1686.4, 2348.52, 54.05),--
		},
	},
	TransferingSeeds = {
		{
			coords = vector3(-1933.763, 2038.848, 139.8388),--
		},
	},
	SellCoffee = {
		{
			coords = vector3(-1928.727, 1779.218, 172.15),--
		},
	},
	Garage = {
		{
			coords = vector3(-1922.122, 2040.434, 139.7447)--
		},
		{
			coords = vector3(-1679.422, 2356.699, 50.62415)--
		},
	},
	BossActions = {
		{
			coords = vector3(-1928.708, 2060.148, 139.8467)--
		},
	},
	Cloakroom = {
		{
			coords = vector3(-1937.036, 2051.218, 139.8416)--
		},
		{
			coords = vector3(-1674.851, 2354.505, 50.88343)--
		},
	},
	Clothes = {
		Male = {
			['tshirt_1'] = 15, ['tshirt_2'] = 0,--TSHIRT
			['torso_1'] = 241,   ['torso_2'] = 5,
            ['decals_1'] = 19,   ['decals_2'] = 0,
            ['arms'] = 41,
            ['pants_1'] = 90,   ['pants_2'] = 0,
            ['shoes_1'] = 51,   ['shoes_2'] = 0,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['chain_1'] = 0,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0,
            ['mask_1'] = 0,   ['mask_2'] = 0,
            ['bags_1'] =  173,  ['bags_2'] = 0
		},
		Female = {
			['tshirt_1'] = 6, ['tshirt_2'] = 0,--TSHIRT
			['torso_1'] = 358, ['torso_2'] = 3, --TUŁÓW
			['arms'] = 4, --RAMIONA
			['pants_1'] = 93, ['pants_2'] = 0, --SPODNIE
			['shoes_1'] = 27, ['shoes_2'] = 0, --BUTY
			['helmet_1'] = -1, ['helmet_2'] = 0, --CZAPKA_TUTAJ_-1_OZNACZA_BRAK_CZAPKI
			['chain_1'] = 0, ['chain_2'] = 0, --ŁAŃCUCH
			['mask_1'] = 0, ['mask_2'] = 0, --MASKA
			['bags_1'] = 0, ['bags_2'] = 0 --TORBA
        },
	},
}

local Blips = {
	{title="#1 Szatnia", colour=27, id=479, see = true, coords = vector3(-1937.036, 2051.218, 139.8416)},
	{title="#2 Zbieranie miejscowych winogron", colour=27, id=479, see = true, coords = vector3(-1674.851, 2354.505, 50.88343)},
	{title="#3 Czyszczenie zebranych winogron", colour=27, id=479, see = true, coords = vector3(-1933.763, 2038.848, 139.8388)},
	{title="#4 Punkt dostawy oczyszczonych winogron", colour=27, id=479, see = false, coords = vector3(-1928.727, 1779.218, 172.15)}
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
		if PlayerData.job.name == 'winiarz' then
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
	if PlayerData.job ~= nil and PlayerData.job.name == 'winiarz' then
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

				table.insert(WiniarzBlips, blip)
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

					table.insert(WiniarzBlips, blipSell)
				end
			end
		end
	end
end

deleteBlip = function()
	if WiniarzBlips[1] ~= nil then
		for i=1, #WiniarzBlips, 1 do
			RemoveBlip(WiniarzBlips[i])
			WiniarzBlips[i] = nil
		end
	end
end
CreateThread(function()
	while PlayerData.job == nil do
		Citizen.Wait(1000)
	end
	while true do
		Citizen.Wait(5)
		if PlayerData.job ~= nil and PlayerData.job.name == 'winiarz' then
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
				TriggerEvent('exile_winiarz:hasEnteredMarker', currentZone, zoneNumber)
			end
	
			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('exile_winiarz:hasExitedMarker', lastZone)
			end

		--	if isInMarker and inAction then
			--	TriggerEvent('exile_winiarz:hasEnteredMarker', 'exitMarker')
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
		if PlayerData.job and PlayerData.job.name == 'winiarz' then

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
				OpenMobileWiniarzActionsMenu()
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
	TriggerEvent('exile_winiarz:DrawPercent')
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
	TriggerServerEvent(exile_winiarz3, 'pear', donttouchme)
	inProgress = false
	FreezeEntityPosition(PlayerPedId(), false)
	ClearPedTasks(PlayerPedId())
	CurrentAction		= 'collect'
	CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby zebrać ~b~miejscowe winogrona"
	CurrentActionData	= {}
end


RegisterNetEvent('exile_winiarz:DrawPercent')
AddEventHandler('exile_winiarz:DrawPercent', function()
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
			ESX.ShowNotification('~y~Nie uniesiesz więcej miejscowych winogron')
		end
	end, 'pear')
end

TransferingSeeds = function()
	ESX.UI.Menu.CloseAll()
	local inventory = ESX.GetPlayerData().inventory
	local count = 0
	for i=1, #inventory, 1 do
		if inventory[i].name == 'pear' then
			count = inventory[i].count
		end
	end
	if kochacpieski == true then
		if count >= 100 then
			DisableControlAction(0, 289, true) -- F2
			FreezeEntityPosition(PlayerPedId(), true)
			local lib, anim = 'mini@drinking', 'shots_barman_b'
			ESX.Streaming.RequestAnimDict(lib, function()
				TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
				Citizen.InvokeNative(0xAAA34F8A7CB32098, PlayerPedId())
				exports["exile_taskbar"]:taskBar(30000, "Trwa oczyszczanie winogron", false, true)
				Citizen.Wait(100)
				exports["exile_taskbar"]:taskBar(8000, "Trwa odkładanie winogron", false, true)
				TriggerServerEvent(exile_winiarz2, count, donttouchme)
				FreezeEntityPosition(PlayerPedId(), false)
				DisableControlAction(0, 289, false) -- F2
				kochacpieski = false
				TriggerEvent('winiarzxD')
			--	end)
			end)
		else
			ESX.ShowNotification('~r~Potrzebujesz 100x winogrono aby rozpocząć oczyszczanie!')
		end
	else
		ESX.ShowNotification('~r~Musisz odczekać aby ponownie oczyszczać!')
	end
end
RegisterNetEvent('winiarzxD')
AddEventHandler('winiarzxD', function()
	Citizen.Wait(300000)
	kochacpieski = true
end)
local blokuj = false
SellCoffee = function()
	ESX.UI.Menu.CloseAll()
	local inventory = ESX.GetPlayerData().inventory
	local count = 0
	for i=1, #inventory, 1 do
		if inventory[i].name == 'winogrono2' then
			count = inventory[i].count
		end
	end
	if count > 0 then
		blokuj = true
		FreezeEntityPosition(PlayerPedId(), true)
		local lib, anim = 'gestures@m@standing@casual', 'gesture_easy_now'
		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
			exports["exile_taskbar"]:taskBar(12000, "Sprzedawanie winogron", false, true)
			Citizen.InvokeNative(0xAAA34F8A7CB32098, PlayerPedId())
			TriggerServerEvent(exile_winiarz, count, donttouchme)
			FreezeEntityPosition(PlayerPedId(), false)
			blokuj = false
		end)
	else
		ESX.ShowNotification('~r~Nie posiadasz przy sobie winogron!')
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
		local carWiniarz = GetVehiclePedIsIn(player, false)
		if IsVehicleModel(carWiniarz, `kalahari`) then
			ESX.Game.DeleteVehicle(carWiniarz)
			alreadyOut = false
		else
			ESX.ShowNotifcation('~r~Możesz zwrócić tylko auto firmowe!')
		end
	else
		if ESX.Game.IsSpawnPointClear(GetEntityCoords(PlayerPedId()), 7) then
			ESX.Game.SpawnVehicle('kalahari', GetEntityCoords(PlayerPedId()), 86.53, function(vehicle)
				platenum = math.random(10, 99)
				SetVehicleNumberPlateText(vehicle, "VINE"..platenum)
				TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
				TriggerServerEvent('exile_winiarz:insertPlayer', GetVehicleNumberPlateText(vehicle))
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

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'winiarz_boss', {
		title    = "Winiarz",
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)

		if data.current.value == '1' then
			if PlayerData.job.grade == 7 then
				TriggerEvent('esx_society:openBossMenu', 'winiarz', function(data, menu)
					menu.close()
				end, { showmoney = false, withdraw = false, deposit = true, wash = false, employees = true})
			elseif PlayerData.job.grade >= 8 then
				TriggerEvent('esx_society:openBossMenu', 'winiarz', function(data, menu)
					menu.close()
				end, { showmoney = true, withdraw = true, deposit = true, wash = false, employees = true})
			else
				TriggerEvent('esx_society:openBossMenu', 'winiarz', function(data, menu)
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
						ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'winiarz_courses', elements, function(data, menu)
						end, function(data, menu)
							menu.close()
						end)
                    end
                else
                    ESX.ShowNotification("~r~Lista kursów jest pusta!")
				end
			end, 'winiarz')
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

RegisterNetEvent('exile_winiarz:Cancel')
AddEventHandler('exile_winiarz:Cancel', function()
	local playerPed = PlayerPedId()
	FreezeEntityPosition(playerPed, false)
	ClearPedTasks(playerPed)
end)

AddEventHandler('exile_winiarz:hasEnteredMarker', function(zone, number)

	if zone == 'exitMarker' then
		CurrentAction     = 'exit'
		CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~ aby przerwać ~b~czynność~s~'
		CurrentActionData = {}
	end

	if zone == 'CollectSeeds' then
		CurrentAction		= 'collect'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby zebrać ~b~miejscowe winogrona"
		CurrentActionData	= {}
	end

	if zone == 'Cloakroom' then
		CurrentAction		= 'cloakroom'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby otworzyć ~b~szatnię"
		CurrentActionData	= {}
	end

	if zone == 'TransferingSeeds' then
		CurrentAction		= 'transfering'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby oczyścić ~b~zebrane winogrona"
		CurrentActionData	= {}
	end

	if zone == 'SellCoffee' then
		CurrentAction		= 'sell'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby sprzedać ~b~oczyszczone winogrona"
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

AddEventHandler('exile_winiarz:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	TriggerServerEvent('exile_winiarz:stopPickup', zone)

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

OpenMobileWiniarzActionsMenu = function()
	while PlayerData == nil do
		Wait(200)
	end
	ESX.UI.Menu.CloseAll()
	local elements = {}
	local playerPed = PlayerPedId()
	local vehicle   = GetVehiclePedIsIn(playerPed, false)
	if IsVehicleModel(vehicle, `gmcat4`) then
		if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
			ESX.TriggerServerCallback('exile_winiarz:checkSiedzacy', function(siedzi)
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