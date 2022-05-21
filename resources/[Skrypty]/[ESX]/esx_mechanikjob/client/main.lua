Keys = {
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

local HasAlreadyEnteredMarker, LastZone = false, nil
local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local CurrentlyTowedVehicle, Blips, NPCOnJob, NPCTargetTowable, NPCTargetTowableZone = nil, {}, false, nil, nil
local NPCHasSpawnedTowable, NPCLastCancel, NPCHasBeenNextToTowable, NPCTargetDeleterZone, NPCTargetDistance = false, GetGameTimer() - 5 * 60000, false, false, 0
local isDead, isBusy, pDistance = false, false, 0
local PlayerData = {}
local CurrentTask = {}

ESX = nil

CreateThread(function()
	while ESX == nil do
		TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) 
			ESX = obj 
		end)
		
		Citizen.Wait(250)
	end

	Citizen.Wait(5000)
	TriggerServerEvent('esx_mechanicjobdrugi:checkIsDuty')
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

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

function SelectRandomTowable()
	local index = GetRandomIntInRange(1,  #Config.Towables)

	for k,v in pairs(Config.TowZones) do
		if v.Pos.x == Config.Towables[index].x and v.Pos.y == Config.Towables[index].y and v.Pos.z == Config.Towables[index].z then
			return k
		end
	end
end

function StartNPCJob(currZone)
	ESX.TriggerServerCallback('esx_mechanicjobdrugi:getPoint', function(cb)
		if cb then
			NPCOnJob = true

			NPCTargetTowableZone = SelectRandomTowable()
			local zone       = Config.TowZones[NPCTargetTowableZone]

			NPCTargetDistance = (#(vec3(currZone.VehicleDelivery.Pos.x,  currZone.VehicleDelivery.Pos.y,  currZone.VehicleDelivery.Pos.z) - vec3(zone.Pos.x,  zone.Pos.y,  zone.Pos.z)) * 2)

			Blips['NPCTargetTowableZone'] = AddBlipForCoord(zone.Pos.x,  zone.Pos.y,  zone.Pos.z)
			SetBlipRoute(Blips['NPCTargetTowableZone'], true)

			ESX.ShowNotification(_U('drive_to_indicated'))
		end
	end)
end

function StopNPCJob(cancel, currZone)
	if Blips['NPCTargetTowableZone'] then
		RemoveBlip(Blips['NPCTargetTowableZone'])
		Blips['NPCTargetTowableZone'] = nil
	end

	if Blips['NPCDelivery'] then
		RemoveBlip(Blips['NPCDelivery'])
		Blips['NPCDelivery'] = nil
	end

	currZone.VehicleDelivery.Type = -1

	if cancel then
		ESX.ShowNotification(_U('mission_canceled'))
	else
		TriggerServerEvent('esx_mechanicjobdrugi:onNPCJobMissionCompleted', NPCTargetDistance, PlayerData.job.name, PlayerData.job.grade)
	end
	
	NPCOnJob                = false
	NPCTargetTowable        = nil
	NPCTargetTowableZone    = nil
	NPCTargetDistance       = 0
	NPCHasSpawnedTowable    = false
	NPCHasBeenNextToTowable = false
	NPCTargetDeleterZone    = false
end

function SetVehicleMaxMods(vehicle)
	local t = {
		modEngine       = 3,
		modBrakes       = 2,
		modTransmission = 2,
		modSuspension   = 3,
		modArmor        = 4,
		modXenon        = true,
		modTurbo        = true,
		dirtLevel       = 0
	}

	ESX.Game.SetVehicleProperties(vehicle, t)
end

function OpenMechanicBossMenu(currJob, currGrade)
	if currGrade >= 6 then
		TriggerEvent('esx_society:openBossMenu', currJob, function(data, menu)
			menu.close()
			CurrentAction     = 'mechanic_boss_menu'
			CurrentActionMsg  = "Naciśnij ~INPUT_CONTEXT~, aby otworzyć menu zarządzania"
			CurrentActionData = {}
		end, { showmoney = true, withdraw = true, deposit = true, wash = false, employees = true })
	else
		TriggerEvent('esx_society:openBossMenu', currJob, function(data, menu)
			menu.close()
			CurrentAction     = 'mechanic_boss_menu'
			CurrentActionMsg  = "Naciśnij ~INPUT_CONTEXT~, aby otworzyć menu zarządzania"
			CurrentActionData = {}
		end, { showmoney = false, withdraw = false, deposit = true, wash = false, employees = false })
	end
end

function OpenMechanicVehicleSpawner(currZone)
	local elements = {
		{label = "Laweta", value = 'lsc_flatbed'},
		{label = "Widlak", value = 'forklift'},
		{label = 'Ford 150', value = 'lsc_ford150'},
		{label = 'Rat Loader', value = 'ratloader2'},
		{label = 'Winky', value = 'winky'},
		{label = 'Odholownik', value = 'towtruck'},
		{label = 'Transpoter', value = 'vetir'},
		{label = 'Ciężarówka', value = 'mule4'},
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_vehicle', {
		title    = _U('service_vehicle'),
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		local vehicleProps = data.current.value
		ESX.Game.SpawnVehicle(data.current.value, currZone.VehicleSpawnPoint.Pos, currZone.VehicleSpawnPoint.Heading, function(vehicle)
			local playerPed = PlayerPedId()
			ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
			SetVehicleMaxMods(vehicle)
			local plate = "MECH " .. math.random(100,999)
			SetVehicleNumberPlateText(vehicle, plate)
			local localVehPlate = string.lower(GetVehicleNumberPlateText(vehicle))
			TriggerEvent('ls:dodajklucze2', localVehPlate)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		end)

		menu.close()
	end, function(data, menu)
		menu.close()
		CurrentAction     = 'mechanic_vehicle_spawner'
		CurrentActionMsg  = "Naciśnij ~INPUT_CONTEXT~, aby wyciągnąć pojazd"
		CurrentActionData = {}
	end)
end

function OpenPrivateStockMenu()
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garderoba', {
		title    = "Szafka prywatna",
		align    = 'bottom-right',
		elements = {
			{label = "Ubrania prywatne", value = 'player_dressing'},
		}
	}, function(data, menu)
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
						title    = "Garderoba prywatna",
						align    = 'bottom-right',
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
	end, function(data, menu)
		menu.close()
		CurrentAction	  = 'mechanic_private_menu'
		CurrentActionMsg  =  "Naciśnij ~INPUT_CONTEXT~, aby otworzyć prywatną szafkę"
		CurrentActionData = {}
	end)
end

--[[function OpenMechanicActionsMenu(currZone, currJob, currGrade)
	local elements = {
		{label = _U('work_wear'),      value = 'cloakroom'},
		{label = _U('civ_wear'),       value = 'cloakroom2'},
		{label = _U('deposit_stock'),  value = 'put_stock'},
		{label = _U('withdraw_stock'), value = 'get_stock'},
		{label = 'Wyciągnij GPS', value = 'gps'}
	}

	if PlayerData.job.grade >= 7 then
		table.insert(elements, {
			label = ('<span style="color:yellowgreen;">Dodaj ubranie</span>'),
			value = 'zapisz_ubranie' 
		})
	end
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mechanic_actions', {
		title    = "Mechanik",
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'cloakroom' then
			ESX.UI.Menu.CloseAll()
			if PlayerData.job.name == 'off' .. currJob then
				TriggerServerEvent('exile:setJob', currJob, true)
				ESX.ShowNotification('~b~Wchodzisz na służbę')
			end
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
			end)
		elseif data.current.value == 'cloakroom2' then
			ESX.UI.Menu.CloseAll()
			if PlayerData.job.name == currJob then
				ESX.ShowNotification('~b~Schodzisz ze służby')
				TriggerServerEvent('exile:setJob', currJob, false)
			end
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		elseif data.current.value == 'przegladaj_ubrania' then
			ESX.TriggerServerCallback('mechanik:getPlayerDressing', function(dressing)
				elements = nil
				local elements = {}
				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'wszystkie_ubrania', {
					title    = ('Ubrania'),
					align    = 'top',
					elements = elements
				}, function(data2, menu2)
				
					local elements2 = {
						{ label = ('Ubierz ubranie'), value = 'ubierz_sie' },
					}
					if PlayerData.hiddenjob.grade >= 7 then
						table.insert(elements2, {
							label = ('<span style="color:red;"><b>Usuń ubranie</b></span>'),
							value = 'usun_ubranie' 
						})
					end
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'edycja_ubran', {
					title    = ('Ubrania'),
					align    = 'top',
					elements = elements2
				}, function(data3, menu3)
						if data3.current.value == 'ubierz_sie' then
							menu3.close()
							TriggerEvent('skinchanger:getSkin', function(skin)
								ESX.TriggerServerCallback('mechanik:getPlayerOutfit', function(clothes)
									TriggerEvent('skinchanger:loadClothes', skin, clothes)
									TriggerEvent('esx_skin:setLastSkin', skin)
									ESX.ShowNotification('~g~Pomyślnie zmieniłeś swój ubiór!')
									ClearPedBloodDamage(playerPed)
									ResetPedVisibleDamage(playerPed)
									ClearPedLastWeaponDamage(playerPed)
									ResetPedMovementClipset(playerPed, 0)
									TriggerEvent('skinchanger:getSkin', function(skin)
										TriggerServerEvent('esx_skin:save', skin)
									end)
								end, data2.current.value, currJob)
							end)
						end
						if data3.current.value == 'usun_ubranie' then
							menu3.close()
							menu2.close()
							TriggerServerEvent('mechanik:removeOutfit', data2.current.value, currJob)
							ESX.ShowNotification('~r~Pomyślnie usunąłeś ubiór o nazwie: ~y~' .. data2.current.label)
						end
					end, function(data3, menu3)
						menu3.close()
					end)
					
				end, function(data2, menu2)
					menu2.close()
				end)
			end, currJob)
		elseif data.current.value == 'put_stock' then
			TriggerEvent('exile:putInventoryItem', 'society_' .. currJob)
		elseif data.current.value == 'get_stock' then
			TriggerEvent('exile:getInventoryItem', 'society_' .. currJob)
		elseif data.current.value == 'gps' then
			TriggerServerEvent('esx_mechanicjobdrugi:giveitem', 'gps', 1)
			ESX.ShowNotification("~g~Wyciągnięto GPS")
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'mechanic_actions_menu'
		CurrentActionMsg  = _U('open_actions')
		CurrentActionData = {}
	end)
end]]

function OpenMechanicActionsMenu(currZone, currJob, currGrade)
	local elements = {
		{label = ('Wejdź na służbe'),      value = 'duty_on'},
		{label = ('Zejdź ze służby'),       value = 'duty_off'},
		{label =   ('Szatnia'), 			 value = 'szatnia_menu'	},
		{label = _U('deposit_stock'),  value = 'put_stock'},
		{label = _U('withdraw_stock'), value = 'get_stock'},
		{label = 'Wyciągnij GPS', value = 'gps'},
		{label = 'Wyciągnij BODYCAM', value = 'bodycam'}
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mechanic_actions', {
		title    = "Mechanik",
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'duty_on' then
			ESX.UI.Menu.CloseAll()
			if PlayerData.job.name == 'off' .. currJob then
				TriggerServerEvent('exile:setJob', currJob, true)
				ESX.ShowNotification('~b~Wchodzisz na służbę')
			end
		elseif data.current.value == 'duty_off' then
			ESX.UI.Menu.CloseAll()
			if PlayerData.job.name == currJob then
				ESX.ShowNotification('~b~Schodzisz ze służby')
				TriggerServerEvent('exile:setJob', currJob, false)
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
			end
		elseif data.current.value == 'szatnia_menu' then
			OpenCloakroomMenu()
		elseif data.current.value == 'przegladaj_ubrania' then
			ESX.TriggerServerCallback('mechanik:getPlayerDressing', function(dressing)
				elements = nil
				local elements = {}
				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'wszystkie_ubrania', {
					title    = ('Ubrania'),
					align    = 'top',
					elements = elements
				}, function(data2, menu2)
				
					local elements2 = {
						{ label = ('Ubierz ubranie'), value = 'ubierz_sie' },
					}
					if PlayerData.hiddenjob.grade >= 7 then
						table.insert(elements2, {
							label = ('<span style="color:red;"><b>Usuń ubranie</b></span>'),
							value = 'usun_ubranie' 
						})
					end
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'edycja_ubran', {
					title    = ('Ubrania'),
					align    = 'top',
					elements = elements2
				}, function(data3, menu3)
						if data3.current.value == 'ubierz_sie' then
							menu3.close()
							TriggerEvent('skinchanger:getSkin', function(skin)
								ESX.TriggerServerCallback('mechanik:getPlayerOutfit', function(clothes)
									TriggerEvent('skinchanger:loadClothes', skin, clothes)
									TriggerEvent('esx_skin:setLastSkin', skin)
									ESX.ShowNotification('~g~Pomyślnie zmieniłeś swój ubiór!')
									ClearPedBloodDamage(playerPed)
									ResetPedVisibleDamage(playerPed)
									ClearPedLastWeaponDamage(playerPed)
									ResetPedMovementClipset(playerPed, 0)
									TriggerEvent('skinchanger:getSkin', function(skin)
										TriggerServerEvent('esx_skin:save', skin)
									end)
								end, data2.current.value, currJob)
							end)
						end
						if data3.current.value == 'usun_ubranie' then
							menu3.close()
							menu2.close()
							TriggerServerEvent('mechanik:removeOutfit', data2.current.value, currJob)
							ESX.ShowNotification('~r~Pomyślnie usunąłeś ubiór o nazwie: ~y~' .. data2.current.label)
						end
					end, function(data3, menu3)
						menu3.close()
					end)
					
				end, function(data2, menu2)
					menu2.close()
				end)
			end, currJob)
		elseif data.current.value == 'put_stock' then
			TriggerEvent('exile:putInventoryItem', 'society_' .. currJob)
		elseif data.current.value == 'get_stock' then
			TriggerEvent('exile:getInventoryItem', 'society_' .. currJob)
		elseif data.current.value == 'gps' then
			TriggerServerEvent('esx_mechanicjobdrugi:giveitem', 'gps', 1)
			ESX.ShowNotification("~g~Wyciągnięto GPS")
		elseif data.current.value == 'bodycam' then
			TriggerServerEvent('esx_mechanicjobdrugi:giveitem', 'bodycam', 1)
			ESX.ShowNotification("~g~Wyciągnięto BODYCAM")
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'mechanic_actions_menu'
		CurrentActionMsg  = _U('open_actions')
		CurrentActionData = {}
	end)
end

function OpenMechanicCraftMenu()
	local elements = {
		{label = ('Mechaniczny zestaw naprawczy'), value = 'fixkit', type = 'item'},	
		{label = ('Mechaniczny zestaw blacharski'), value = 'carokit', type = 'item'},
		{label = ('Wytrych'), value = 'blowpipe', type = 'item'},
	}
	
	if PlayerData.job and PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = ('Klucz Francuski'),  value = 'WEAPON_WRENCH', type = 'weapon'})
		table.insert(elements, {label = ('Łom'), value = 'WEAPON_CROWBAR', type = 'weapon'})
		table.insert(elements,{label = ('Młotek'), value = 'WEAPON_HAMMER', type = 'weapon'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mechanic_craft', {
		title    = 'Menu narzędzi',
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		-- menu.close()

		if data.current.type == 'weapon' then
			TriggerServerEvent('esx_mechanicjobdrugi:giveweapon', data.current.value)
		elseif data.current.type == 'item' then
			TriggerServerEvent('esx_mechanicjobdrugi:giveitem', data.current.value, 1)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'mechanic_craft_menu'
		CurrentActionMsg  = _U('craft_menu')
		CurrentActionData = {}
	end)
end


RegisterNetEvent('esx_mechanicjobdrugi:onCarokit')
AddEventHandler('esx_mechanicjobdrugi:onCarokit', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		if DoesEntityExist(vehicle) then
			TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_HAMMERING', 0, true)
			CreateThread(function()
				Citizen.Wait(10000)
				SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				Citizen.InvokeNative(0xAAA34F8A7CB32098, playerPed)
				ESX.ShowNotification(_U('body_repaired'))
			end)
		end
	end
end)

RegisterNetEvent('esx_mechanicjobdrugi:onFixKit')
AddEventHandler('esx_mechanicjobdrugi:onFixKit', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle

		ESX.TriggerServerCallback('esx_mechanicjobdrugi:getczesci', function (czesci)
			if czesci >= 3 then
				if IsPedInAnyVehicle(playerPed, false) then
					vehicle = GetVehiclePedIsIn(playerPed, false)
				else
					vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
				end

				if DoesEntityExist(vehicle) then
					TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
					CreateThread(function()
						exports["exile_taskbar"]:taskBar(20000, "", false, true)
						local first = true
						while first or not GetIsVehicleEngineRunning(vehicle) do
							SetVehicleEngineHealth(vehicle, 1000.0)

							SetVehicleUndriveable(vehicle, false)
							SetVehicleEngineOn(vehicle, true, true)
							first = false
							Citizen.Wait(0)
						end
						ESX.ShowNotification(_U('veh_repaired'))
						TriggerServerEvent('esx_mechanicjobdrugi:wezczesci')
					end)
				end
			else
				ESX.ShowNotification('Nie posiadasz części zamiennych (5 sztuk)')
			end
		end)
	end
end)

RegisterNetEvent('esx_mechanicjobdrugi:onFixKitFree')
AddEventHandler('esx_mechanicjobdrugi:onFixKitFree', function()
	local playerPed = PlayerPedId()
	local vehicle   = ESX.Game.GetVehicleInDirection()
	local coords    = GetEntityCoords(playerPed)

	if IsPedSittingInAnyVehicle(playerPed) then
		ESX.ShowNotification('Nie możesz tego wykonać w środku pojazdu!')
		return
	end

	if DoesEntityExist(vehicle) then
		IsBusy = true
		TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
		CreateThread(function()
			FreezeEntityPosition(vehicle, true)
			FreezeEntityPosition(playerPed, true)
			exports["exile_taskbar"]:taskBar(20000, "Naprawianie pojazdu", false, true)
			FreezeEntityPosition(playerPed, false)
			FreezeEntityPosition(vehicle, false)
			SetVehicleEngineHealth(vehicle, 1000.0)
			SetVehicleUndriveable(vehicle, false)
			SetVehicleEngineOn(vehicle, true, true)
			ClearPedTasksImmediately(playerPed)

			ESX.ShowNotification('Pojazd naprawiony!')
			IsBusy = false
		end)
	else
		ESX.ShowNotification('W pobliżu nie ma żadnego pojazdu!')
	end
end)

function canUse(coords)
	local areas = {
		vec3(139.73, -3027.25, 6.43),
	}
	
	for k,v in pairs(areas) do
		if #(v - coords) < 75.0 then 
			return true
		end	
	end
	return false
end

function OpenMobileMechanicActionsMenu(currZone, currJob, currGrade)
	ESX.UI.Menu.CloseAll()
	local elements = {}

	if not IsPedInAnyVehicle(PlayerPedId(), false) then
		table.insert(elements, {label = _U('hijack'), value = 'hijack_vehicle'})
		table.insert(elements, {label = _U('repair'), value = 'fix_vehicle'})
		table.insert(elements, {label = ('Umyj pojazd'), value = 'clean_vehicle'})
		table.insert(elements, {label = ('Odholuj pojazd'), value = 'impound_vehicle'})
		table.insert(elements, {label ="Połóż obiekt", value = 'object_spawner'})
		table.insert(elements, {label = ('Tablet'), value = 'tablet'})
	end
  
	
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		
		table.insert(elements, {label = _U('flat_bed'), value = 'dep_vehicle'})
		
		if currGrade > 0 then
			local coords = GetEntityCoords(PlayerPedId())
			if canUse(coords) then
				table.insert(elements, {label = ('Tuning'), value = 'Tuning'})
			end
		end
		
	end	
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_mechanic_actions', {
		title    = "Interakcje",
		align    = 'bottom-right',
		elements = elements
		}, function(data, menu)
	  if data.current.value == 'Tuning' then
        menu.close()

        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
          local vehicle = GetVehiclePedIsIn(ped, false)
          TriggerEvent('LSC:build', vehicle, true, "Tuning", "shopui_title_carmod", function(obj)
            TriggerEvent('LSC:open', 'categories')
            FreezeEntityPosition(vehicle, true)
          end, function()
            FreezeEntityPosition(vehicle, false)
          end)
        else
          ESX.ShowNotification('Musisz być w pojeździe!')
        end	  
	  elseif data.current.value == 'tablet' then
		menu.close()
		TriggerEvent('billingmech')
      elseif data.current.value == 'hijack_vehicle' then
        local playerPed = PlayerPedId()
        local coords    = GetEntityCoords(playerPed)

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
				exports["exile_taskbar"]:taskBar(10000, "Trwa Odblokowywanie", false, true)
				
				while GetVehicleDoorsLockedForPlayer(vehicle, PlayerId()) ~= false do
					SetVehicleDoorsLocked(vehicle, 1)
					SetVehicleDoorsLockedForAllPlayers(vehicle, false)
					Citizen.Wait(0)
				end

				Citizen.InvokeNative(0xAAA34F8A7CB32098, playerPed)
				ESX.ShowNotification(_U('vehicle_unlocked'))
				TriggerServerEvent('exile:pay', 500)
              end)
			end
          end
        end
      elseif data.current.value == 'fix_vehicle' then
        local playerPed = PlayerPedId()
        local coords    = GetEntityCoords(playerPed)

        if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
          local vehicle = nil
          if IsPedInAnyVehicle(playerPed, false) then
            vehicle = GetVehiclePedIsIn(playerPed, false)
          else
            vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
          end

          if DoesEntityExist(vehicle) then
			TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
            CreateThread(function()
              Citizen.Wait(15000)

			  local first = true
			  while first or not GetIsVehicleEngineRunning(vehicle) do
				SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				SetVehicleUndriveable(vehicle)
				SetVehicleEngineOn(vehicle, true, true)
				
				first = false
				Citizen.Wait(0)
			  end

              Citizen.InvokeNative(0xAAA34F8A7CB32098, playerPed)
			  ESX.ShowNotification(_U('vehicle_repaired'))
            end)
          end
        end
      elseif data.current.value == 'clean_vehicle' then
        local playerPed = PlayerPedId()
        local coords    = GetEntityCoords(playerPed)

        if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
          local vehicle = nil
          if IsPedInAnyVehicle(playerPed, false) then
            vehicle = GetVehiclePedIsIn(playerPed, false)
          else
            vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
          end

          if DoesEntityExist(vehicle) then
            TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_MAID_CLEAN", 0, true)
            CreateThread(function()
              Citizen.Wait(5000)
			  WashDecalsFromVehicle(vehicle, 1.0)
              SetVehicleDirtLevel(vehicle)

              Citizen.InvokeNative(0xAAA34F8A7CB32098, playerPed)
              ESX.ShowNotification(_U('vehicle_cleaned'))
            end)
          end
        end
	  elseif data.current.value == 'impound_vehicle' then
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)	 
		if CurrentTask.Busy then
			return
		end

		ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~ żeby unieważnić ~y~zajęcie~s~')
		TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)

		CurrentTask.Busy = true
		CurrentTask.Task = ESX.SetTimeout(10000, function()
			ClearPedTasks(playerPed)
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
			ESX.Game.DeleteVehicle(vehicle)

			CurrentTask.Busy = false
			Citizen.Wait(100)
		end)

		-- keep track of that vehicle!
		CreateThread(function()
			while CurrentTask.Busy do
				Citizen.Wait(1000)

				vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
				if not DoesEntityExist(vehicle) and CurrentTask.Busy then
					ESX.ShowNotification(_U(action .. '_canceled_moved'))
					ESX.ClearTimeout(CurrentTask.Task)

					ClearPedTasks(playerPed)
					CurrentTask.Busy = false
					break
				end
			end
		end)
      elseif data.current.value == 'dep_vehicle' then
		OnFlatbedUse('lsc_flatbed', currZone)
      elseif data.current.value == 'object_spawner' then
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_mecano_actions_spawn', {
            title    = "Obiekty",
            align    = 'center',
            elements = {
			  {label = ('Słupek'),     value = 'prop_roadcone02a'},
			  {label = ('Barierka'), value = 'prop_barrier_work06a'},
			  {label = ('Przybornik'), value = 'prop_toolchest_01'},
            },
        }, function(data2, menu2)
			local model   = data2.current.value
			local playerPed = PlayerPedId()
			local coords  = GetEntityCoords(playerPed)
			local forward = GetEntityForwardVector(playerPed)
			local x, y, z = table.unpack(coords + forward * 1.0)

			if model == 'prop_roadcone02a' or model == 'prop_toolchest_01' or model == 'prop_barrier_work06a' then
				z = z - 1.0
			end

			ESX.Game.SpawnObject(model, {x = x, y = y, z = z}, function(obj)
				SetEntityHeading(obj, GetEntityHeading(playerPed))
				PlaceObjectOnGroundProperly(obj)
			end)
        end, function(data2, menu2)
            menu2.close()
        end)
      end
	end, function(data, menu)
		menu.close()
	end)
end

function OnFlatbedUse(model, currZone)
	local playerPed = PlayerPedId()
	
	local vehicle = GetVehiclePedIsIn(playerPed, false)
	if IsVehicleModel(vehicle, model) then
	  if CurrentlyTowedVehicle == nil then
		local targetVehicle = nil
		local coords = GetEntityCoords(vehicle)
		if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 10.0) then
          targetVehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 10.0, 0, 71)
		  if targetVehicle == vehicle or targetVehicle == 0 or targetVehicle == nil then
			targetVehicle = nil
		  end
		end

		if targetVehicle then
			if vehicle ~= targetVehicle then
			  local offset = {
				['lsc_flatbed'] = {x = 0.0, y = -3.0, z = 1.2},
				['ambflatbed'] = {x = 0.0, y = -2.5, z = 0.65},
				['mechflatbed'] = {x = 0.0, y = -2.5, z = 1.0}
			  }

			  AttachEntityToEntity(targetVehicle, vehicle, GetEntityBoneIndexByName(vehicle, 'bodyshell'), offset[model].x, offset[model].y, offset[model].z, 0, 0, 0, 1, 1, 0, 1, 0, 1)
			  CurrentlyTowedVehicle = targetVehicle
			  ESX.ShowNotification(_U('vehicle_success_attached'))

			  if NPCOnJob then
				if NPCTargetTowable == targetVehicle then
				  ESX.ShowNotification(_U('please_drop_off'))

				  currZone.VehicleDelivery.Type = 1
				  if Blips['NPCTargetTowableZone'] ~= nil then
					RemoveBlip(Blips['NPCTargetTowableZone'])
					Blips['NPCTargetTowableZone'] = nil
				  end

				  Blips['NPCDelivery'] = AddBlipForCoord(currZone.VehicleDelivery.Pos.x,  currZone.VehicleDelivery.Pos.y,  currZone.VehicleDelivery.Pos.z)
				  SetBlipRoute(Blips['NPCDelivery'], true)
				end
			  end
			else
			  ESX.ShowNotification(_U('cant_attach_own_tt'))
			end
		else
		  ESX.ShowNotification(_U('no_veh_att'))
		end
	  else
		DetachEntity(CurrentlyTowedVehicle, true, true)
		local vehiclesCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -12.0, 0.0)
		SetEntityCoords(CurrentlyTowedVehicle, vehiclesCoords["x"], vehiclesCoords["y"], vehiclesCoords["z"], 1, 0, 0, 1)

		SetVehicleOnGroundProperly(CurrentlyTowedVehicle)
		if NPCOnJob then
		  if CurrentlyTowedVehicle == NPCTargetTowable then
			if NPCTargetDeleterZone then
			  SetVehicleHasBeenOwnedByPlayer(NPCTargetTowable, false)
			  ESX.Game.DeleteVehicle(NPCTargetTowable)
			  StopNPCJob(false, currZone)
			else
			  ESX.ShowNotification("~r~Ten pojazd musi zostać odstawiony w prawidłowym miejscu")
			end
		  elseif NPCTargetDeleterZone then
			ESX.ShowNotification(_U('not_right_veh'))
		  end
		end

		CurrentlyTowedVehicle = nil
		ESX.ShowNotification(_U('veh_det_succ'))
	  end
	else
	  ESX.ShowNotification(_U('lsc_flatbed'))
	end
end

RegisterNetEvent('esx_mechanicjobdrugi:onHijack')
AddEventHandler('esx_mechanicjobdrugi:onHijack', function()
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
		if IsVehicleAlarmSet(vehicle) and GetRandomIntInRange(1, 100) <= 33 then
			local id = NetworkGetNetworkIdFromEntity(vehicle)
			SetNetworkIdCanMigrate(id, false)

			local tries = 0
			while not NetworkHasControlOfNetworkId(id) and tries < 10 do
				tries = tries + 1
				NetworkRequestControlOfNetworkId(id)
				Citizen.Wait(100)
			end

			StartVehicleAlarm(vehicle)
			TriggerEvent('outlawalert:processThief', playerPed, vehicle, false)
			SetNetworkIdCanMigrate(id, true)
		end

		TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
		CreateThread(function()			
			exports["exile_taskbar"]:taskBar(15000, "Trwa Odblokowywanie", false, true)

			ClearPedSecondaryTask(playerPed)
			if GetRandomIntInRange(1, 100) <= 66 then
				local id = NetworkGetNetworkIdFromEntity(vehicle)
				SetNetworkIdCanMigrate(id, false)

				local tries = 0
				while not NetworkHasControlOfNetworkId(id) and tries < 10 do
					tries = tries + 1
					NetworkRequestControlOfNetworkId(id)
					Citizen.Wait(100)
				end

				SetVehicleDoorsLocked(vehicle, 1)
				SetVehicleDoorsLockedForAllPlayers(vehicle, false)
				Citizen.Wait(0)

				SetNetworkIdCanMigrate(id, true)
				ESX.ShowNotification(_U('veh_unlocked'))
				ClearPedTasks(playerPed)
				ClearPedSecondaryTask(playerPed)
			else
				ESX.ShowNotification(_U('hijack_failed'))
				ClearPedTasks(playerPed)
				ClearPedSecondaryTask(playerPed)
			end
		end)
    end
end)

RegisterNetEvent('esx_mechanicjobdrugi:onCarokit')
AddEventHandler('esx_mechanicjobdrugi:onCarokit', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		if DoesEntityExist(vehicle) then
			TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_HAMMERING', 0, true)
			CreateThread(function()
				local lastHealth = GetVehicleEngineHealth(vehicle)
				Citizen.Wait(14900)
				SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				Citizen.Wait(100)
				SetVehicleEngineHealth(vehicle, lastHealth)
				Citizen.InvokeNative(0xAAA34F8A7CB32098, playerPed)
				ESX.ShowNotification(_U('body_repaired'))
			end)
		end
	end
end)

RegisterNetEvent('esx_mechanicjobdrugi:onFixkit')
AddEventHandler('esx_mechanicjobdrugi:onFixkit', function(value, wait)
	local playerPed = PlayerPedId()
	local vehicle   = ESX.Game.GetVehicleInDirection()
	local coords    = GetEntityCoords(playerPed)

	if IsPedSittingInAnyVehicle(playerPed) then
		ESX.ShowNotification('Nie możesz tego wykonać w środku pojazdu!')
		return
	end

	if DoesEntityExist(vehicle) then
		IsBusy = true
		TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
		CreateThread(function()
			FreezeEntityPosition(vehicle, true)
			FreezeEntityPosition(playerPed, true)
			exports["exile_taskbar"]:taskBar(20000, "Naprawianie pojazdu", false, true)
			FreezeEntityPosition(playerPed, false)
			FreezeEntityPosition(vehicle, false)
			SetVehicleFixed(vehicle)
			SetVehicleDeformationFixed(vehicle)
			SetVehicleUndriveable(vehicle, false)
			SetVehicleEngineOn(vehicle, true, true)
			ClearPedTasksImmediately(playerPed)

			ESX.ShowNotification('Pojazd naprawiony!')
			IsBusy = false
		end)
	else
		ESX.ShowNotification('W pobliżu nie ma żadnego pojazdu!')
	end
end)

AddEventHandler('esx_mechanicjobdrugi:hasEnteredMarker', function(zone)
	if zone == 'NPCJobTargetTowable' then

	elseif zone =='VehicleDelivery' then
		NPCTargetDeleterZone = true
	elseif zone == 'DutyList' then
		CurrentAction     = 'duty_list'
		CurrentActionMsg  = "Naciśnij ~INPUT_CONTEXT~, aby sprawdzić listę dostępnych mechaników"
		CurrentActionData = {}
	elseif zone == 'MechanicActions' then
		CurrentAction     = 'mechanic_actions_menu'
		CurrentActionMsg  = _U('open_actions')
		CurrentActionData = {}
	elseif zone == 'Craft' then
		CurrentAction     = 'mechanic_craft_menu'
		CurrentActionMsg  = _U('craft_menu')
		CurrentActionData = {}
	elseif zone == 'BossMenu' then
		CurrentAction	  = 'mechanic_boss_menu'
		CurrentActionMsg  =  "Naciśnij ~INPUT_CONTEXT~, aby otworzyć menu zarządzania"
		CurrentActionData = {}
	elseif zone == 'PrivateStock' then
		CurrentAction	  = 'mechanic_private_menu'
		CurrentActionMsg  =  "Naciśnij ~INPUT_CONTEXT~, aby otworzyć prywatną szafkę"
		CurrentActionData = {}
	elseif zone == 'VehicleSpawner' then
		CurrentAction	  = 'mechanic_vehicle_spawner'
		CurrentActionMsg  =  "Naciśnij ~INPUT_CONTEXT~, aby wyciągnąć pojazd"
		CurrentActionData = {}
	elseif zone == 'VehicleDeleter' then
		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed,  false)

			CurrentAction     = 'delete_vehicle'
			CurrentActionMsg  = _U('veh_stored')
			CurrentActionData = {vehicle = vehicle}
		end
	end
end)

AddEventHandler('esx_mechanicjobdrugi:hasExitedMarker', function(zone)
	if zone =='VehicleDelivery' then
		NPCTargetDeleterZone = false
	elseif zone == 'Craft' then
		TriggerServerEvent('esx_mechanicjobdrugi:stopCraft')
		TriggerServerEvent('esx_mechanicjobdrugi:stopCraft2')
		TriggerServerEvent('esx_mechanicjobdrugi:stopCraft3')
	end

	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

-- Pop NPC mission vehicle when inside area

CreateThread(function()
	while PlayerData.job == nil do
		Citizen.Wait(100)
	  end
	while true do
		Citizen.Wait(3)
		if PlayerData.job.name == "mechanik" then
			if NPCTargetTowableZone ~= nil and not NPCHasSpawnedTowable then
				local coords = GetEntityCoords(PlayerPedId())
				local zone   = Config.TowZones[NPCTargetTowableZone]
				if #(coords - vec3(zone.Pos.x, zone.Pos.y, zone.Pos.z)) < Config.NPCSpawnDistance then
					local model = Config.Vehicles[GetRandomIntInRange(1,  #Config.Vehicles)]
					ESX.Game.SpawnVehicle(model, zone.Pos, 0, function(vehicle)
						SetVehicleHasBeenOwnedByPlayer(vehicle, true)
						NPCTargetTowable = vehicle
					end)

					NPCHasSpawnedTowable = true
				end
			end

			if NPCTargetTowableZone ~= nil and NPCHasSpawnedTowable and not NPCHasBeenNextToTowable then
				local coords = GetEntityCoords(PlayerPedId())
				local zone   = Config.TowZones[NPCTargetTowableZone]
				if(#(coords - vec3(zone.Pos.x, zone.Pos.y, zone.Pos.z)) < Config.NPCNextToDistance) then
					ESX.ShowNotification(_U('please_tow'))
					NPCHasBeenNextToTowable = true
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

-- Create Blips
CreateThread(function()
	for k,v in pairs(Config.Blips) do
		local blip = AddBlipForCoord(v.Pos)

		SetBlipSprite (blip, v.Sprite)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 1.1)
		SetBlipColour (blip, v.Color)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(v.Label)
		EndTextCommandSetBlipName(blip)
	end
end)
local inTunning = false
-- Display markers
CreateThread(function()
	while true do
		Citizen.Wait(6)
		if PlayerData.job ~= nil then
		
			if Config.Zones[PlayerData.job.name] or Config.Zones[string.sub(PlayerData.job.name, 4)]  then
				local coords, letSleep = GetEntityCoords(PlayerPedId()), true
				local configTable
				if Config.Zones[PlayerData.job.name] ~= nil then
					configTable = Config.Zones[PlayerData.job.name]
				elseif Config.Zones[string.sub(PlayerData.job.name, 4)] ~= nil then
					configTable = Config.Zones[string.sub(PlayerData.job.name, 4)]
				end

				for k,v in pairs(configTable) do
					if k == 'DutyList' and PlayerData.job.grade >= 6 then
						if v.Type ~= -1 and #(coords - vec3(v.Pos.x, v.Pos.y, v.Pos.z)) < Config.DrawDistance then
							ESX.DrawMarker(vec3(v.Pos.x, v.Pos.y, v.Pos.z))
							letSleep = false
						end
					end
					if k ~= 'DutyList' then
						if v.Type ~= -1 and #(coords - vec3(v.Pos.x, v.Pos.y, v.Pos.z)) < Config.DrawDistance then
							ESX.DrawMarker(vec3(v.Pos.x, v.Pos.y, v.Pos.z))
							letSleep = false
						end
					end
				end

				if letSleep then
					Citizen.Wait(1000)
				end
			end
		
		else
			Citizen.Wait(5000)
		end
	end
end)

-- Enter / Exit marker events
CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if PlayerData.job ~= nil then
			if Config.Zones[PlayerData.job.name] or Config.Zones[string.sub(PlayerData.job.name, 4)] then
				local coords      = GetEntityCoords(PlayerPedId())
				local isInMarker  = false
				local currentZone = nil
				local configTable
				if Config.Zones[PlayerData.job.name] ~= nil then
					configTable = Config.Zones[PlayerData.job.name]
				elseif Config.Zones[string.sub(PlayerData.job.name, 4)] ~= nil then
					configTable = Config.Zones[string.sub(PlayerData.job.name, 4)]
				end

				for k,v in pairs(configTable) do
					if k == 'DutyList' and PlayerData.job.grade >= 6 then
						if #(coords - vec3(v.Pos.x, v.Pos.y, v.Pos.z)) < v.Size.x then
							isInMarker  = true
							currentZone = k
						end
					end
					if k ~= 'DutyList' then
						if #(coords - vec3(v.Pos.x, v.Pos.y, v.Pos.z)) < v.Size.x then
							isInMarker  = true
							currentZone = k
						end
					end
				end

				if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
					HasAlreadyEnteredMarker = true
					LastZone                = currentZone
					TriggerEvent('esx_mechanicjobdrugi:hasEnteredMarker', currentZone)
				end

				if not isInMarker and HasAlreadyEnteredMarker then
					HasAlreadyEnteredMarker = false
					TriggerEvent('esx_mechanicjobdrugi:hasExitedMarker', LastZone)
				end
			else
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
    if PlayerData.job ~= nil and Config.Zones[PlayerData.job.name] or Config.Zones[string.sub(PlayerData.job.name, 4)] then
      local playerPed = PlayerPedId()
	  if not IsPedInAnyVehicle(playerPed, false) then
        local coords = GetEntityCoords(playerPed)

        local found = false
	    for _, prop in ipairs({
			'prop_roadcone02a',
			'prop_toolchest_01',
			'prop_barrier_work06a'
        }) do
          local object = GetClosestObjectOfType(coords.x,  coords.y,  coords.z,  2.0,  GetHashKey(prop), false, false, false)
          if DoesEntityExist(object) then
            CurrentAction     = 'remove_entity'
            CurrentActionMsg  = ('Naciśnij ~INPUT_CONTEXT~ aby usunąć ten obiekt')
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

-- Key Controls
CreateThread(function()
	while PlayerData.job == nil do
		Citizen.Wait(100)
	end
	while true do
		Citizen.Wait(3)
		if PlayerData.job.name == "mechanik" or PlayerData.job.name == "offmechanik" then
			if CurrentAction then
				ESX.ShowHelpNotification(CurrentActionMsg)

				if IsControlJustReleased(0, 38) and PlayerData.job then
					if Config.Zones[PlayerData.job.name] then
						local currZone = Config.Zones[PlayerData.job.name]
						local currJob = PlayerData.job.name
						local currGrade = PlayerData.job.grade
						if CurrentAction == 'duty_list' then
							OpenDutyList()
						elseif CurrentAction == 'mechanic_actions_menu' then
							OpenMechanicActionsMenu(currZone, currJob, currGrade)
						elseif CurrentAction == 'mechanic_boss_menu' then
							OpenMechanicBossMenu(currJob, currGrade)
						elseif CurrentAction == 'mechanic_vehicle_spawner' then
							OpenMechanicVehicleSpawner(currZone)
						elseif CurrentAction == 'mechanic_private_menu' then
							OpenPrivateStockMenu()
						elseif CurrentAction == 'mechanic_craft_menu' then
							OpenMechanicCraftMenu()
						elseif CurrentAction == 'delete_vehicle' then
							ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
						elseif CurrentAction == 'remove_entity' then
							DeleteEntity(CurrentActionData.entity)
						end

						CurrentAction = nil
					elseif Config.Zones[string.sub(PlayerData.job.name, 4)] then
						if CurrentAction == 'mechanic_actions_menu' then
							OpenMechanicActionsMenu(Config.Zones[string.sub(PlayerData.job.name, 4)], string.sub(PlayerData.job.name, 4), PlayerData.job.grade)
						end
					end
				end
			end

			if IsControlJustReleased(0, 167) and not isDead and PlayerData.job and Config.Zones[PlayerData.job.name] then
				local currZone = Config.Zones[PlayerData.job.name]
				local currJob = PlayerData.job.name
				local currGrade = PlayerData.job.grade
				OpenMobileMechanicActionsMenu(currZone, currJob, currGrade)
			end

			if IsControlJustReleased(0, 38) and CurrentTask.busy then
				ESX.ShowNotification('Unieważniasz zajęcie')
				ESX.ClearTimeout(CurrentTask.task)
				ClearPedTasks(PlayerPedId())

				CurrentTask.busy = false
			end	
			
			if IsControlJustReleased(0, 56) and not isDead and PlayerData.job and Config.Zones[PlayerData.job.name] then
				local currZone = Config.Zones[PlayerData.job.name]
				if NPCOnJob then
					if GetGameTimer() - NPCLastCancel > 5 * 60000 then
						StopNPCJob(true, currZone)
						NPCLastCancel = GetGameTimer()
					else
						ESX.ShowNotification(_U('wait_five'))
					end
				else
					local playerPed = PlayerPedId()

					if IsPedInAnyVehicle(playerPed, false) and IsVehicleModel(GetVehiclePedIsIn(playerPed, false), `lsc_flatbed`) then
						StartNPCJob(currZone)
					else
						ESX.ShowNotification(_U('must_in_flatbed'))
					end
				end
			end
		else
			Citizen.Wait(2000)
		end

	end
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
	hasAlreadyJoined = true
end)


isAttached = false
attachedEntity = nil

CreateThread(function()
	while PlayerData.job == nil do
		Citizen.Wait(200)
	end
    while true do
        Wait(10)
		if PlayerData.job.name == "mechanik" or PlayerData.job.name == "offmechanik" then
        	-- f10 to attach/detach
			if IsControlJustPressed(0, 47) then
				-- if already attached detach
				if isAttached then
					DetachEntity(attachedEntity, true, true)
					
					attachedEntity = nil
					isAttached = false
				else	
					-- get vehicle infront
					local pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, 0.0)
					local veh = GetClosestVehicle(pos, 2.0, 0, 70)
					
					-- if vehicle is found
					if veh ~= 0 and IsPedInAnyVehicle(PlayerPedId(), false) then
						local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
						
						-- check if player is in forklift
						if GetEntityModel(currentVehicle) == `forklift` then 
							isAttached = true
							attachedEntity = veh
							
							-- attach vehicle to forklift, you can change some values
							AttachEntityToEntity(veh, currentVehicle, 3, 0.0, 1.3, -0.09, 0.0, 0, 90.0, false, false, false, false, 2, true)
						end
					end
				end
			end    
		else
			Citizen.Wait(2000) 
		end   
    end
end)

OpenDutyList = function()
	ESX.TriggerServerCallback('esx_mechanicjobdrugi:getDutyList', function(list)
		local elements = {}
		for i, data in pairs(list) do
			table.insert(elements, { label = data.label, value = i })
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'duty_list', {
            title    = "Lista pracowników na służbie",
            align    = 'center',
            elements = elements
        }, function(data2, menu2)
			menu2.close()
        end, function(data2, menu2)
            menu2.close()
        end)
	end)
end

function OpenCloakroomMenu()

	ESX.UI.Menu.CloseAll()
	local playerPed = PlayerPedId()
	local grade = PlayerData.job.grade_name

	local elements = {
	}

	if PlayerData.job.name == 'mechanik' then
		table.insert(elements, {label = 'Ubrania Służbowe', value = 'uniforms'})
	end



	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
	{
		title    = ('Szatnia - LST'),
		align    = 'right',
		elements = elements
	}, function(data, menu)

		cleanPlayer(playerPed)

		if data.current.value == 'citizen_wear' then
			ESX.UI.Menu.CloseAll()
			if PlayerData.job.name == 'mechanik' then
				ESX.ShowNotification('~b~Schodzisz ze służby')
				TriggerServerEvent('exile:setJob', 'mechanik', false)
			end
		end

		if data.current.value == 'uniforms' then
			local elements2 = {
				{label = "Recruit", value = 'recruit_wear'},
				{label = "Novice", value = 'novice_wear'},
				{label = "Master", value = 'master_wear'},
				{label = "Expert", value = 'expert_wear'},
				{label = "Professionalist", value = 'professionalist_wear'},
				{label = "Specialist", value = 'specialist_wear'},
				{label = "Coordinator of LST", value = 'coordinator_wear'},
				{label = "Deputy Chief of LST", value = 'deputychief_wear'},
				{label = "Chief of LST", value = 'chief_wear'},
				{label = "Committee of LST", value = 'chief_wear'},
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'uniforms', {
				title    = "Szatnia - LST",
				align    = 'right',
				elements = elements2
			}, function(data2, menu2)
				setUniform(data2.current.value, playerPed)
			end, function(data2, menu2)
				menu2.close()
			end)
		end

	if
		data.current.value == 'recruit_wear' or
		data.current.value == 'novice_wear' or
		data.current.value == 'master_wear' or
		data.current.value == 'expert_wear' or
		data.current.value == 'professionalist_wear' or
		data.current.value == 'specialist_wear' or
		data.current.value == 'coordinator_wear' or
		data.current.value == 'deputychief_wear' or
		data.current.value == 'chief_wear'
	then
		setUniform(data.current.value, playerPed)
	end

	end, function(data, menu)
		menu.close()
	end)
end