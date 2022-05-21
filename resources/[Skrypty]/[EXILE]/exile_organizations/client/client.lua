ESX = nil
PlayerData = {}
OrganizationBlip = {}
local HasAlreadyEnteredMarker, LastZone = false, nil
local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local isUsing = false
local zoneName = nil
local HaveBagOnHead = false

CreateThread(function()
	while ESX == nil do
		TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj)
			ESX = obj
		end)
		Citizen.Wait(250)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
	PlayerData = ESX.GetPlayerData()
	refreshBlip()
end)

local jestwjakiesorg = false

CreateThread(function()
	while true do
		if PlayerData.hiddenjob and string.find(PlayerData.hiddenjob.name, "org") then
			jestwjakiesorg = true
		else
			jestwjakiesorg = false
		end
		Wait(1000)
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	deleteBlip()
	refreshBlip()
end)

RegisterNetEvent('esx:setHiddenJob')
AddEventHandler('esx:setHiddenJob', function(hiddenjob)
	PlayerData.hiddenjob = hiddenjob
	deleteBlip()
	refreshBlip()
end)


function refreshBlip()
	if PlayerData.hiddenjob ~= nil and Config.Blips[PlayerData.hiddenjob.name] then
		local blip = AddBlipForCoord(Config.Blips[PlayerData.hiddenjob.name])
		SetBlipSprite (blip, 310)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.8)
		SetBlipColour (blip, 6)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Dom organizacji")
		EndTextCommandSetBlipName(blip)
		table.insert(OrganizationBlip, blip)
	end
end

function deleteBlip()
	if OrganizationBlip[1] ~= nil then
		for i=1, #OrganizationBlip, 1 do
			RemoveBlip(OrganizationBlip[i])
			table.remove(OrganizationBlip, i)
		end
	end
end

AddEventHandler('exile_organizations:hasEnteredMarker', function(zone)
	if zone == 'Cloakroom' then
		CurrentAction = 'cloakroom'
		CurrentActionMsg  = _U('cloakroom_menu', PlayerData.hiddenjob.label)
		CurrentActionData = {}
	elseif zone =='Inventory' then
		CurrentAction = 'inventory'
		CurrentActionMsg  = _U('inventory_menu', PlayerData.hiddenjob.label)
		CurrentActionData = {}
	elseif zone == 'Licenses' then
		CurrentAction = 'licenses'
		CurrentActionMsg  = _U('licenses_menu', PlayerData.hiddenjob.label)
		CurrentActionData = {}
	elseif zone == 'BossMenu' then
		CurrentAction = 'boss_menu'
		CurrentActionMsg  = _U('boss_menu', PlayerData.hiddenjob.label)
		CurrentActionData = {}
	elseif zone == 'OpiumMenu' then
		CurrentAction = 'opium_menu'
		CurrentActionMsg = "Naciśnij ~INPUT_CONTEXT~, aby przekazać klucze do przeróbki opium"
		CurrentActionData = {}
	elseif zone == 'ExctasyMenu' then
		CurrentAction = 'exctasy_menu'
		CurrentActionMsg = "Naciśnij ~INPUT_CONTEXT~, aby przekazać klucze do przeróbki ekstazy"
		CurrentActionData = {}
	elseif zone == 'Barabasz' then
		CurrentAction = 'barabasz_kurwa'
		CurrentActionMsg = "Naciśnij ~INPUT_CONTEXT~, aby uleczyć się u medyka"
		CurrentActionData = {}
	elseif zone == 'FixMenu' then
		CurrentAction = 'FixMenu_ast'
		CurrentActionMsg = "Naciśnij ~INPUT_CONTEXT~, aby skorzystać z mechanika"
		CurrentActionData = {}
	elseif zone == 'Blachy' then
		CurrentAction = 'Blachy'
		CurrentActionMsg = "Naciśnij ~INPUT_CONTEXT~, aby wybić blachy w pojeździe"
		CurrentActionData = {}
	elseif zone == 'MainMenu' then
		CurrentAction = 'MainMenu'
		CurrentActionMsg = "Naciśnij ~INPUT_CONTEXT~, aby otworzyć główne menu organizacji"
		CurrentActionData = {}
	end
end)

AddEventHandler('exile_organizations:hasExitedMarker', function(zone)
	if isUsing then
		isUsing = false
		TriggerServerEvent('exile:setUsed', zoneName, 'society_'..PlayerData.hiddenjob.name, false)
	end
	zoneName = nil
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

CreateThread(function()
	while true do
		Citizen.Wait(0)
		if PlayerData.hiddenjob ~= nil then
			local coords, letSleep = GetEntityCoords(PlayerPedId()), true
			if jestwjakiesorg then
				if Config.Zones[PlayerData.hiddenjob.name] then
					for k,v in pairs(Config.Zones[PlayerData.hiddenjob.name]) do
						if v.coords and #(coords - v.coords) < Config.DrawDistance then
							letSleep = false
							if k then
								ESX.DrawMarker(v.coords)
							end
						end
					end
				end
				for k,v in pairs(Config.InstanceOrgs) do
					if v.coords and #(coords - v.coords) < Config.DrawDistance then
						letSleep = false
						if k then
							ESX.DrawMarker(v.coords)
						end
					end
				end
				if letSleep then
					Citizen.Wait(1000)
				end
			else
				Wait(5000)
			end
		else
			Citizen.Wait(5000)
		end
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(2000)

		if PlayerData.hiddenjob ~= nil then
			if jestwjakiesorg then
				local coords      = GetEntityCoords(PlayerPedId())
				local isInMarker  = false
				local currentZone = nil
				if Config.Zones[PlayerData.hiddenjob.name] then
					for k,v in pairs(Config.Zones[PlayerData.hiddenjob.name]) do
						if k ~= "Barabasz" then
							if v.coords and (#(coords - v.coords) < 1.5) then
								isInMarker  = true
								currentZone = k
							end
						end
					end
				end

				for k,v in pairs(Config.InstanceOrgs) do
					if k ~= "Barabasz" then
						if v.coords and (#(coords - v.coords) < 1.5) then
							isInMarker  = true
							currentZone = k
						end
					end
				end
				if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
					HasAlreadyEnteredMarker = true
					LastZone                = currentZone
					TriggerEvent('exile_organizations:hasEnteredMarker', currentZone)
				end

				if not isInMarker and HasAlreadyEnteredMarker then
					HasAlreadyEnteredMarker = false
					TriggerEvent('exile_organizations:hasExitedMarker', LastZone)
				end
			else
				Citizen.Wait(5000)
			end
		else
			Citizen.Wait(5000)
		end
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(3)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustPressed(0, 38) or IsDisabledControlJustPressed(0, 38) and PlayerData.hiddenjob and Config.Zones[PlayerData.hiddenjob.name] then

				if CurrentAction == 'cloakroom' then
					OpenCloakroomMenu('society_' .. PlayerData.hiddenjob.name)
				elseif CurrentAction == 'MainMenu' then
					OpenJakJaKurwaNieNawidzeJebanegoFalsiakaMenu(PlayerData.hiddenjob.name)
				elseif CurrentAction == 'opium_menu' then
					OpenOpiumMenu()
				elseif CurrentAction == 'exctasy_menu' then
					OpenExctasyMenu()
				elseif CurrentAction == 'barabasz_kurwa' then
					BarabaszHeal()
				elseif CurrentAction == 'FixMenu_ast' then
					FixMenu()
				elseif CurrentAction == 'Blachy' then
					exports['ExileRP']:WybijBlachyMenu()
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
		if PlayerData.hiddenjob then
			if not IsPedInAnyVehicle(PlayerPedId()) then
				if IsControlJustReleased(0, 168) and not exports['esx_policejob']:IsCuffed() and not exports['esx_ambulancejob']:isDead() then
					ESX.TriggerServerCallback('exile_organizations:getLicenses', function(licenses)
						if licenses.menuf7 == 1 then
							OpenActionsMenu()
						else
							ESX.ShowNotification('~r~Twoja organizacja nie ma wykupionego dostępu do menu interakcji!')
						end
					end, 'society_' .. PlayerData.hiddenjob.name)
				end
			else
				Wait(250)
			end
		else
			Wait(500)
		end
	end
end)

function FixMenu()
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mechanik_org_git',
		{
			title    = "Mechanik",
			align    = 'center',
			elements = {
				{label = "Naprawa mechaniczna", value = 1},
				{label = "Naprawa karoseri", value = 2},
			},
		}, function(data, menu)
			local r = data.current.value
			if IsPedInAnyVehicle(PlayerPedId(), false) then
				if r == 1 then
					local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
					if GetVehicleEngineHealth(vehicle) < 1000 then
						menu.close()
						TriggerServerEvent('__orgs:mechanik')
						for i=10,0,-1 do
							ESX.ShowHelpNotification('~y~Trwa naprawa...~s~ ' .. i .. '~b~ sekund')
							Citizen.Wait(1000)
						end
						FixMenu()
						SetVehicleEngineHealth(vehicle, 1000)
						SetVehicleEngineOn(vehicle, true, true )
						ESX.ShowNotification('~g~Naprawiono pojazd')
					else
						ESX.ShowNotification('~r~Pojazd nie wymaga naprawy')
					end
				elseif r == 2 then
					menu.close()
					local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
					local health = GetVehicleEngineHealth(vehicle)
					TriggerServerEvent('__orgs:mechanik')
					for i=10,0,-1 do
						ESX.ShowHelpNotification('~y~Trwa naprawa...~s~ ' .. i .. '~b~ sekund')
						Citizen.Wait(1000)
					end
					SetVehicleFixed(vehicle)
					Citizen.Wait(300)
					SetVehicleEngineHealth(vehicle, health)
					SetVehicleEngineOn(vehicle, true, true )
					FixMenu()
					ESX.ShowNotification('~g~Naprawiono pojazd')
				end
			else
				menu.close()
			end
			
		end, function(data, menu)
			menu.close()
		end)
	else
		ESX.ShowNotification('~r~Musisz być w pojeździe')
	end
end

function BarabaszHeal()
	if not IsPedInAnyVehicle(PlayerPedId(), false) and exports["esx_ambulancejob"]:isDead() then
		if PlayerData.hiddenjob ~= nil then
			TriggerEvent('hypex_ambulancejob:hypexreviveblack', nil)
			ESX.ShowNotification('~g~Uleczono')
		end
	else
		ESX.ShowNotification('~r~Aby skorzystać z pomocy medycznej musisz być ranny.')
	end
end

function OpenOpiumMenu()
	local playerCoords = GetEntityCoords(PlayerPedId())
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'opium_menu',
	{
		title    = "Przeróbka kokainy - zarządzanie",
		align    = 'center',
		elements = {
			{label = "Rozdane klucze", value = 'used'},
			{label = "Przekaż klucz", value = 'give_key'},
		}
	}, function(data, menu)
		menu.close()
		if data.current.value == 'used' then
			ESX.TriggerServerCallback('exile_organizations:getOpiumPermissions', function(cb)
				if cb[1] ~= nil then
					local elements2 = {
						head = {'Imię', 'Nazwisko', 'Do kiedy', 'Akcje'},
						rows = {}
					}
					for i=1, #cb, 1 do
						table.insert(elements2.rows, {
							data = cb[i].owner,
							cols = {
								cb[i].firstname,
								cb[i].lastname,
								cb[i].endTime,
								'{{' .. "Odbierz dostęp" .. '|hire}}'
							}
						})
					end
					ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'opium_list', elements2, function(data2, menu2)
						if data2.value == 'hire' then
							menu2.close()
							TriggerServerEvent('exile_organizations:removeOpiumPermission', data2.data)
							Citizen.Wait(300)
							OpenOpiumMenu()
						end
					end, function(data2, menu2)
						menu2.close()
						OpenOpiumMenu()
					end)
				else
					ESX.ShowNotification("~b~Brak rozdanych kluczy do przeróbki")
				end
			end)
		elseif data.current.value == 'give_key' then
			local playersInArea = ESX.Game.GetPlayersInArea(playerCoords, 5.0)
			local elements      = {}
			for i=1, #playersInArea, 1 do
				if playersInArea[i] ~= PlayerId() then
					table.insert(elements, {label = GetPlayerServerId(playersInArea[i]), value = GetPlayerServerId(playersInArea[i])})
				end
			end
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'give_key',
			{
				title    = "Osoby w pobliżu",
				align    = 'center',
				elements = elements,
			}, function(data2, menu2)
				menu2.close()
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'give_key',
				{
					title    = "Czas",
					align    = 'center',
					elements = {
						{label = "1 dzień", value = 1},
						{label = "3 dni", value = 3},
						{label = "7 dni", value = 7}
					},
				}, function(data3, menu3)
					menu3.close()
					TriggerServerEvent('exile_organizations:opiumPermission', data2.current.value, data3.current.value)
				end, function(data3, menu3)
					menu3.close()
					OpenOpiumMenu()
				end)
			end, function(data2, menu2)
				menu2.close()
				OpenOpiumMenu()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenExctasyMenu()
	local playerCoords = GetEntityCoords(PlayerPedId())
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'exctasy_menu',
	{
		title    = "Przeróbka ekstazy - zarządzanie",
		align    = 'center',
		elements = {
			{label = "Rozdane klucze", value = 'used'},
			{label = "Przekaż klucz", value = 'give_key'},
		}
	}, function(data, menu)
		menu.close()
		if data.current.value == 'used' then
			ESX.TriggerServerCallback('exile_organizations:getExctasyPermissions', function(cb)
				if cb[1] ~= nil then
					local elements2 = {
						head = {'Imię', 'Nazwisko', 'Do kiedy', 'Akcje'},
						rows = {}
					}
					for i=1, #cb, 1 do
						table.insert(elements2.rows, {
							data = cb[i].owner,
							cols = {
								cb[i].firstname,
								cb[i].lastname,
								cb[i].endTime,
								'{{' .. "Odbierz dostęp" .. '|hire}}'
							}
						})
					end
					ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'exctasy_list', elements2, function(data2, menu2)
						if data2.value == 'hire' then
							menu2.close()
							TriggerServerEvent('exile_organizations:removeExctasyPermission', data2.data)	
							Citizen.Wait(300)	
							OpenExctasyMenu()
						end
					end, function(data2, menu2)
						menu2.close()
						OpenExctasyMenu()
					end)
				else
					ESX.ShowNotification("~b~Brak rozdanych kluczy do przeróbki")
				end
			end)
		elseif data.current.value == 'give_key' then
			local playersInArea = ESX.Game.GetPlayersInArea(playerCoords, 5.0)
			local elements      = {}
			for i=1, #playersInArea, 1 do
				if playersInArea[i] ~= PlayerId() then
					table.insert(elements, {label = GetPlayerServerId(playersInArea[i]), value = GetPlayerServerId(playersInArea[i])})
				end
			end
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'give_key',
			{
				title    = "Osoby w pobliżu",
				align    = 'center',
				elements = elements,
			}, function(data2, menu2)
				menu2.close()
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'give_key',
				{
					title    = "Czas",
					align    = 'center',
					elements = {
						{label = "1 dzień", value = 1},
						{label = "3 dni", value = 3},
						{label = "7 dni", value = 7}
					},
				}, function(data3, menu3)
					menu3.close()
					TriggerServerEvent('exile_organizations:ExctasyPermission', data2.current.value, data3.current.value)
				end, function(data3, menu3)
					menu3.close()
					OpenExctasyMenu()
				end)
			end, function(data2, menu2)
				menu2.close()
				OpenExctasyMenu()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

local bagonhead = false
local enabled = false
local bag = nil
local isdead = false

function OpenActionsMenu()
	ESX.UI.Menu.CloseAll()
	local ped = PlayerPedId()
	local elements = {
		{label = "Kajdanki", value = 'handcuffs'},
		{label = "Napraw pojazd", value = 'repair'},
		{label = "Użyj wytrychu", value = 'wytrych'},
		{label = "Worek", value = 'worek'}
	}
	if PlayerData.hiddenjob.name == 'org27' then
		elements = {
		{label = "Kajdanki", value = 'handcuffs'},
		{label = "Napraw pojazd", value = 'repair'},
		{label = "Użyj wytrychu", value = 'wytrych'},
		{label = "Worek", value = 'worek'},
		{label = "Abonament Opium", value = 'opiummafia'},
		{label = "Abonament Ekstazy", value = 'ekstazymafia'},
		}
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'actions_menu',
	{
		title    = 'Organizacja Przestępcza',
		align    = 'center',
		elements = elements
	}, function(data, menu)			
		if (data.current.value == 'handcuffs') then
			menu.close()
			TriggerEvent('Kajdanki')
		elseif (data.current.value == 'opiummafia') then
			menu.close()
			OpenOpiumMenu()
		elseif (data.current.value == 'ekstazymafia') then
			menu.close()
			OpenExctasyMenu()
		elseif (data.current.value == 'repair') then
			menu.close()
			TriggerServerEvent('exile:pay', 1000)
			TriggerEvent('esx_mechanicjobdrugi:onFixkitFree')
		elseif (data.current.value == 'wytrych') then
			TriggerServerEvent('exile:pay', 1500)
			menu.close()
			TriggerEvent('esx_mechanicjobdrugi:onHijack')
		elseif (data.current.value == 'worek') then
			menu.close()
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'actions_menu',
			{
				title    = PlayerData.hiddenjob.label,
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
		end
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('atlantisHeadbag:setbag')
AddEventHandler('atlantisHeadbag:setbag', function(idkurwy, corobi)
	local _idkurwy = idkurwy
	if bagonhead and corobi == 'putoff' then
		bagonhead = false
		TriggerEvent('atlantisHeadbag:display', false)
		TriggerServerEvent('atlantisHeadbag:itemhuj', _idkurwy, 'give')
		TriggerServerEvent('atlantisHeadbag:woreknaleb', _idkurwy, 0)
	elseif not bagonhead and corobi == 'puton' then
		bagonhead = true
		TriggerEvent('atlantisHeadbag:display', true)
		TriggerServerEvent('atlantisHeadbag:itemhuj', _idkurwy, 'remove')
		TriggerServerEvent('atlantisHeadbag:woreknaleb', _idkurwy, 1)
	end
end)

RegisterNetEvent('atlantisHeadbag:kurwodajitem')
AddEventHandler('atlantisHeadbag:kurwodajitem', function(gowno)
	local co = gowno
		if co == 'give' then
			TriggerServerEvent('atlantisHeadbag:item', 'give')
		elseif co == 'remove' then
			TriggerServerEvent('atlantisHeadbag:item', 'remove')
		end
end)

RegisterNetEvent('atlantisHeadbag:display')
AddEventHandler('atlantisHeadbag:display', function(value)
	local ped = PlayerPedId()
	if value == true then
		SetPedComponentVariation(ped, 1, 69, 1, 1)
		enabled = true
	elseif value == false then
		bagonhead = false
		SetPedComponentVariation(ped, 1, 0, 0, 0)
		enabled = false
	end
  SendNUIMessage({
    display = enabled
  })
end)

function IsWorek()
	return bagonhead
end

CreateThread(function()
	while true do
		Citizen.Wait(1500)
		if bagonhead then
			if IsPedSprinting(PlayerPedId()) and not IsPedRagdoll(PlayerPedId()) then
				local ForwardVector = GetEntityForwardVector(PlayerPedId())
				SetPedToRagdollWithFall(PlayerPedId(), 3000, 3000, 0, ForwardVector, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
			end
			if IsPedJumping(PlayerPedId()) and not IsPedRagdoll(PlayerPedId()) then
				local ForwardVector = GetEntityForwardVector(PlayerPedId())
				SetPedToRagdollWithFall(PlayerPedId(), 3000, 3000, 0, ForwardVector, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
			end
			if IsPedInMeleeCombat(PlayerPedId()) and not IsPedRagdoll(PlayerPedId()) then
				local ForwardVector = GetEntityForwardVector(PlayerPedId())
				SetPedToRagdollWithFall(PlayerPedId(), 3000, 3000, 0, ForwardVector, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
			end
			if IsPedHurt(PlayerPedId()) and not IsPedRagdoll(PlayerPedId()) then
				local ForwardVector = GetEntityForwardVector(PlayerPedId())
				SetPedToRagdollWithFall(PlayerPedId(), 3000, 3000, 0, ForwardVector, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
			end
		end
	end
end)

AddEventHandler('playerSpawned', function()
	bagonhead = false
	isdead = false
	DeleteEntity(bag)
	SetEntityAsNoLongerNeeded(bag)
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isdead = true
	local ped = PlayerPedId()
	SetPedComponentVariation(ped, 1, 0, 0, 0)
	  SendNUIMessage({
    display = false
  })
end)

function OpenJakJaKurwaNieNawidzeJebanegoFalsiakaMenu(organization)
	local elements = {
		{label = "Magazyn", value = 'storage'},
		{label = "Zarządzenie", value = 'managment'},
		{label = "Zestawy", value = 'kits'},
	}
	if (Config.Zones[PlayerData.hiddenjob.name] and PlayerData.hiddenjob.grade >= Config.Zones[PlayerData.hiddenjob.name].Licenses.from) or Config.InstanceOrgs.Licenses.from then
		table.insert(elements, {label = "Abonamenty", value = 'licenses'})
	end
	table.insert(elements, {label = "Włóż wszystko", value = 'depositall'})
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mejn',
	{
		title    = organization,
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'storage' then
			OpenInventoryMenu('society_' .. PlayerData.hiddenjob.name)
		elseif data.current.value == 'managment' then
			OpenBossMenu(PlayerData.hiddenjob.name, (Config.Zones[PlayerData.hiddenjob.name] and Config.Zones[PlayerData.hiddenjob.name].MainMenu.from) or Config.InstanceOrgs.MainMenu.from)
		elseif data.current.value == "licenses" then
			OpenLicensesMenu('society_' .. PlayerData.hiddenjob.name)
		elseif data.current.value == 'depositall' then
			TriggerEvent('exile:putInventoryItems', 'society_' .. PlayerData.hiddenjob.name)
		elseif data.current.value == 'kits' then
			if PlayerData.hiddenjob.name ~= nil and PlayerData.hiddenjob.grade > 0 then
				OpenKitsMenu(PlayerData.hiddenjob.name)
			else
				ESX.ShowNotification('~r~Nie posiadasz dostępu do zestawów')
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenInventoryMenu(organization)
	local elements = {
		{label = "Włóż", value = 'deposit'},
		{label = "Włóż wszystko", value = 'depositall'}
	}
	if (Config.Zones[PlayerData.hiddenjob.name] and PlayerData.hiddenjob.grade >= Config.Zones[PlayerData.hiddenjob.name].Inventory.from) or PlayerData.hiddenjob.grade >= Config.InstanceOrgs.Inventory.from then
		table.insert(elements, {label = "Wyciągnij", value = 'withdraw'})
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'inventory',
	{
		title    = 'Magazyn',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'withdraw' then
			TriggerEvent('exile:getInventoryItem', organization)
		elseif data.current.value == 'depositall' then
			TriggerEvent('exile:putInventoryItems', organization)
		else
			TriggerEvent('exile:putInventoryItem', organization)
		end
	end, function(data, menu)
		menu.close()
		if isUsing then
			isUsing = false
			TriggerServerEvent('exile:setUsed', 'Inventories', 'society_'..PlayerData.hiddenjob.name, false)
		end
	end)
end

function OpenWeaponsMenu(organization)
	local elements = {
		{ label = 'Włóż broń', value = 'deposit' },
	}
	if (Config.Zones[PlayerData.hiddenjob.name] and PlayerData.hiddenjob.grade >= Config.Zones[PlayerData.hiddenjob.name].Weapons.from) or Config.InstanceOrgs.Inventory.from then
		table.insert(elements, { label = 'Wyciągnij broń', value = 'withdraw' })
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'inventory',
	{
		title    = 'Zbrojownia',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'withdraw' then
			TriggerEvent('exile:getInventoryItem', organization)
		else
			TriggerEvent('exile:putInventoryItem', organization)
		end
	end, function(data, menu)
		menu.close()
		if isUsing then
			isUsing = false
			TriggerServerEvent('exile:setUsed', 'Weapons', 'society_'..PlayerData.hiddenjob.name, false)
		end
	end)
end

function OpenLicensesMenu(society)
	ESX.UI.Menu.CloseAll()
	ESX.TriggerServerCallback('exile_organizations:getLicenses', function(licenses)
		local elements = {
			head = {'Poziom', 'Szafka', 'Szatnia Premium', 'Sejf', 'Interakcje', 'Akcje'},
			rows = {}
		}
		local level = tostring(licenses.level)
		local available = {}
		local items = nil
		if licenses.items == 0 then
			items = '❌'
			table.insert(available, {label = "Szafka", value = 'items', price = 500000})
		elseif licenses.items == 1 then
			items = '✔️ <br>'
		end
		local addoncloakroom = nil
		if licenses.addoncloakroom == 0 then
			addoncloakroom = '❌'
			table.insert(available, {label = "Szatnia Premium", value = 'addoncloakroom', price = 250000})
		elseif licenses.addoncloakroom == 1 then
			addoncloakroom = '✔️ <br>'
		end
		local safe = nil
		if licenses.safe == 0 then
			safe = '❌'
			table.insert(available, {label = "Sejf", value = 'safe', price = 500000})
		elseif licenses.safe == 1 then
			safe = '✔️ <br>'
		end
		local menuf7 = nil
		if licenses.menuf7 == 0 then
			menuf7 = '❌'
			table.insert(available, {label = "Menu interakcji", value = 'menuf7', price = 1000000})
		elseif licenses.menuf7 == 1 then
			menuf7 = '✔️ <br>'
		end
		table.insert(elements.rows, {
			data = tonumber(level),
			cols = {
				level .. " <br>" .. tonumber(level) * 5 .. " osób",
				items,
				addoncloakroom,
				safe,
				menuf7,
				'{{' .. "Podnieś poziom" .. '|upgrade}} {{' .. "Wykup dostęp" .. '|buy}}'
			}
		})
		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'organizations', elements, function(data, menu)
			if data.value == 'upgrade' then
				if data.data >= 20 then
					ESX.ShowNotification('~r~Osiągnąłeś już maksymalny poziom organizacji')
				else
					menu.close()
					local nextLevel = data.data + 1
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'nextlevel', {
						title    = 'Czy na pewno? ',
						align    = 'center',
						elements = {
							{label = 'Nie',  value = 'no'},
							{label = 'Tak (<span style="color:yellowgreen;">500 000$</span>)',  value = 'yes'},
						}
					}, function(data2, menu2)
						if data2.current.value == 'yes' then
							menu2.close()
							TriggerServerEvent('exile_organizations:upgradeOrganization', 'level', nextLevel, society, 500000)
						else
							menu2.close()
						end
					end, function(data2, menu2)
						menu2.close()
						OpenLicensesMenu(society)
					end)
				end
			elseif data.value == 'buy' then
				menu.close()
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'upgrade', {
					title    = 'Co chcesz wykupić?',
					align    = 'center',
					elements = available
				}, function(data2, menu2)
					menu2.close()
					local price = ESX.Math.GroupDigits(data2.current.price)
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'yesorno', {
						title = "Czy na pewno?",
						align = 'center',
						elements = {
							{label = 'Nie',  value = 'no'},
							{label = 'Tak (<span style="color:yellowgreen;">'..price..'$</span>)',  value = 'yes'},
						}
					}, function(data3, menu3)
						if data3.current.value == 'yes' then
							menu3.close()
							TriggerServerEvent('exile_organizations:upgradeOrganization', data2.current.value, 1, society, data2.current.price)
						else
							menu3.close()
						end
					end, function(data3, menu3)
						menu3.close()
						OpenLicensesMenu(society)
					end)
				end, function(data2, menu2)
					menu2.close()
					OpenLicensesMenu(society)
				end)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, society)
end

function OpenCloakroomMenu(organization)
	ESX.UI.Menu.CloseAll()
	ESX.TriggerServerCallback('exile_organizations:getLicenses', function(licenses)
		local elements = {
			{ label = 'Ubrania prywatne', value = 'skin_menu'},
			{ label = 'Koszulka organizacji', value = 'Koszulka'},
			{ label = 'Kamizelka organizacji', value = 'kamza'}
		}
		if licenses.addoncloakroom == 1 then
			table.insert(elements, { label = 'Przeglądaj ubrania organizacji', value = 'przegladaj_ubrania' })
			if PlayerData.hiddenjob.grade >= 3 then
				table.insert(elements, {
					label = ('<span style="color:yellowgreen;">Dodaj ubranie</span>'),
					value = 'zapisz_ubranie'
				})
			end
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'inventory',
		{
			title    = 'Garderoba',
			align    = 'center',
			elements = elements
		}, function(data, menu)
			if data.current.value == 'przegladaj_ubrania' then
				ESX.TriggerServerCallback('exile_organizacje:getPlayerDressing', function(dressing)
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
						if PlayerData.hiddenjob.grade >= 3 then
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
									ESX.TriggerServerCallback('exile_organizacje:getPlayerOutfit', function(clothes)
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
									end, data2.current.value, organization)
								end)
							end
							if data3.current.value == 'usun_ubranie' then
								menu3.close()
								menu2.close()
								TriggerServerEvent('exile_organizacje:removeOutfit', data2.current.value, organization)
								ESX.ShowNotification('~r~Pomyślnie usunąłeś ubiór o nazwie: ~y~' .. data2.current.label)
							end
						end, function(data3, menu3)
							menu3.close()
						end)

					end, function(data2, menu2)
						menu2.close()
					end)
				end, organization)
			end
			if data.current.value == 'player_dressing' then
				ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
					local elements2 = {}
					for k,v in pairs(dressing) do
						table.insert(elements2, {label = v, value = k})
					end

					menu.close()

					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'dress_menu',{
						title    = 'Garderoba',
						align    = 'left',
						elements = elements2
					}, function(data2, menu2)
						menu2.close()
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing_opts', {
							title = 'Wybierz ubranie - ' .. data2.current.label,
							align = 'center',
							elements = {
								{label = 'Ubierz', value = 'wear'},
								{label = 'Zmień nazwę', value = 'rename'},
								{label = 'Usuń ubranie', value = 'remove'}
							}
						}, function(data3, menu3)
							menu3.close()
							if data3.current.value == 'wear' then
								TriggerEvent('skinchanger:getSkin', function(skin)
									ESX.TriggerServerCallback('esx_property:getPlayerOutfit', function(clothes)
										TriggerEvent('skinchanger:loadClothes', skin, clothes)
										TriggerEvent('esx_skin:setLastSkin', skin)

										TriggerEvent('skinchanger:getSkin', function(skin)
											TriggerServerEvent('esx_skin:save', skin)
										end)
									end, data2.current.value)
								end)

								menu2.open()
							elseif data3.current.value == 'rename' then
								ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'player_dressing_rename', {
									title = 'Zmień nazwę - ' .. data2.current.label
								}, function(data4, menu4)
									menu4.close()
									menu.open()
									TriggerServerEvent('esx_property:renameOutfit', data2.current.value, data4.value)
									ESX.ShowNotification('Zmieniono nazwę ubrania!')
								end, function(data4, menu4)
									menu4.close()
									menu3.open()
								end)
							elseif data3.current.value == 'remove' then
								TriggerServerEvent('esx_property:removeOutfit', data2.current.value)
								ESX.ShowNotification('Ubranie usunięte z Twojej garderoby: ' .. data2.current.label)
								menu.open()
							end
						end, function(data3, menu3)
							menu3.close()
							menu2.open()
						end)
					end, function(data2, menu2)
						menu2.close()
						menu.open()
					end)
				end)
			end
			if data.current.value == 'Koszulka' then
				for k, v in pairs(Config.Organizacje) do
					if PlayerData and (PlayerData.hiddenjob and PlayerData.hiddenjob.name == v.praca) then
						if v.Tshirt or v.Tshirtdrugi then
							local tshirt = {}
							if PlayerData and (PlayerData.hiddenjob and PlayerData.hiddenjob.name == 'org22') then
								TriggerEvent('skinchanger:getSkin', function(skin)
									if skin.sex == 0 then
										tshirt = {
											['torso_1'] = Config.MaleTshirtdrugi,
											['torso_2'] = v.Tshirt,
											['arms'] = 0,
										}
									else
										tshirt = {
											['torso_1'] = Config.FemaleTshirt,
											['torso_2'] = v.Tshirt,
											['arms'] = 0,
										}
									end
									TriggerEvent('skinchanger:loadClothes', skin, tshirt)
									TriggerEvent('skinchanger:getSkin', function(skin)
										TriggerServerEvent('esx_skin:save', skin)
									end)
								end)
							else
								TriggerEvent('skinchanger:getSkin', function(skin)
									if skin.sex == 0 then
										tshirt = {
											['torso_1'] = Config.MaleTshirt,
											['torso_2'] = v.Tshirt,
											['arms'] = 0,
										}
									else
										tshirt = {
											['torso_1'] = Config.FemaleTshirt,
											['torso_2'] = v.Tshirt,
											['arms'] = 0,
										}
									end
									TriggerEvent('skinchanger:loadClothes', skin, tshirt)
									TriggerEvent('skinchanger:getSkin', function(skin)
										TriggerServerEvent('esx_skin:save', skin)
									end)
								end)
							end
						else
							ESX.ShowNotification('~r~Twoja organizacja nie posiada koszulki organizacji')
						end
					end
				end
			end
			if data.current.value == 'kamza' then
				for k, v in pairs(Config.Organizacje) do
					if PlayerData and (PlayerData.hiddenjob and PlayerData.hiddenjob.name == v.praca) then
						if v.Vest then
							local vest = {}
							TriggerEvent('skinchanger:getSkin', function(skin)
								if skin.sex == 0 then
									vest = {
										['tshirt_1'] = Config.MaleVest,
										['tshirt_2'] = v.Vest,
										['arms'] = 0,
									}
								else
									vest = {
										['tshirt_1'] = Config.FemaleVest,
										['tshirt_2'] = v.Vest,
										['arms'] = 0,
									}
								end
								TriggerEvent('skinchanger:loadClothes', skin, vest)
								TriggerEvent('skinchanger:getSkin', function(skin)
									TriggerServerEvent('esx_skin:save', skin)
								end)
							end)
						else
							ESX.ShowNotification('~r~Twoja organizacja nie posiada kamizelki organizacji')
						end
					end
				end
			end
			if data.current.value == 'skin_menu' then
				TriggerEvent('exile_organizations:openSkinMenu')
			end
			if data.current.value == 'zapisz_ubranie' then
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'nazwa_ubioru', {
					title = ('Nazwa ubioru')
				}, function(data2, menu2)
					ESX.UI.Menu.CloseAll()

					TriggerEvent('skinchanger:getSkin', function(skin)
						TriggerServerEvent('exile_organizacje:saveOutfit', data2.value, skin, organization)
						ESX.ShowNotification('~g~Pomyślnie zapisano ubiór o nazwie: ~y~' .. data2.value)
					end)

				end, function(data2, menu2)
					menu2.close()

				end)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, organization)
end

function OpenBossMenu(organization, grade)
	ESX.TriggerServerCallback('exile_organizations:getLicenses', function(licenses)
		if licenses.safe == 1 then
			if PlayerData.hiddenjob.grade >= grade then
				TriggerEvent('esx_society:openHiddenBossMenu', organization, licenses.level, function(data, menu)
					menu.close()
				end, { showmoney = true, withdraw = true, deposit = true, wash = false, employees = true })
			else
				TriggerEvent('esx_society:openHiddenBossMenu', organization, licenses.level, function(data, menu)
					menu.close()
				end, { showmoney = false, withdraw = false, deposit = true, wash = false, employees = false })
			end
		else
			ESX.ShowNotification('~y~Aby wpłacać lub wypłacać pieniądze z sejfu, pierw musisz go wykupić!')
			if PlayerData.hiddenjob.grade >= grade then
				TriggerEvent('esx_society:openHiddenBossMenu', organization, licenses.level, function(data, menu)
					menu.close()
				end, { showmoney = false, withdraw = false, deposit = false, wash = false, employees = true })
			else
				TriggerEvent('esx_society:openHiddenBossMenu', organization, licenses.level, function(data, menu)
					menu.close()
				end, { showmoney = false, withdraw = false, deposit = false, wash = false, employees = false })
			end
		end
	end, 'society_' .. organization)
end

CreateThread(function()
	while PlayerData.hiddenjob == nil do
		Citizen.Wait(500)
	end
	while true do
		Citizen.Wait(3)

		local playerPed = PlayerPedId()
		local pid = PlayerId()
		local car = GetVehiclePedIsIn(playerPed, false)
		if car then
			if PlayerData ~= nil and Config.DriveByList[PlayerData.hiddenjob.name] and GetEntitySpeed(car) * 3.6 < 75 then
				SetPlayerCanDoDriveBy(pid, true)
			else
				local AktualnaBron = GetSelectedPedWeapon(playerPed)
				if AktualnaBron == `WEAPON_STUNGUN_MP` and GetEntitySpeed(car) * 3.6 < 30 or AktualnaBron == `WEAPON_UNARMED` then
					SetPlayerCanDoDriveBy(pid, true)
				else
					SetPlayerCanDoDriveBy(pid, false)
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

local currentSkin 			  = nil
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
			cleanPlayer()
		end)

	end, function(data, menu)
		menu.close()
		cleanPlayer()
		
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
		'bags_2'
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

function cleanPlayer()
	TriggerEvent('skinchanger:loadSkin', currentSkin)
	currentSkin = nil
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

RegisterNetEvent("exile_organizations:openSkinMenu")
AddEventHandler("exile_organizations:openSkinMenu", function()
	local xPlayer = GetPlayerServerId(source)
	if xPlayer then
		OpenShopMenu()
	end
end)

local coords = {
	vector3(2711.60, 2779.27, 36.92),
	vector3(1029.71, 2459.74, 45.06),
	vector3(1873.23, 338.97, 44.54),
	vector3(1871.8977050781, 3339.8115234375, 42.5526664733887),
	vector3(-465.76, -2280.88, 8.51),
}

function CheckCoords()
	local pcoords = GetEntityCoords(PlayerPedId())
	for k, v in pairs(coords) do
		if #(v - pcoords) < 2 then
			return true
		end
	end
	return false
end

CreateThread(function()
	Citizen.Wait(2000)
	while true do
		Citizen.Wait(5)
		if CheckCoords() then
			if PlayerData.hiddenjob ~= nil then
				ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~ aby skorzystać z pomocy medyka')	
				if IsControlJustPressed(0, 51) or IsDisabledControlJustPressed(0, 51) then
					BarabaszHeal()
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

CreateThread(function()
	local model = GetHashKey("s_m_m_doctor_01")
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(1)
	end
	npc = CreatePed(5, model, 2711.60, 2779.27, 36.92, 0.0, false, true)
	npc2 = CreatePed(5, model, 1029.71, 2459.74, 45.06, 0.0, false, true)
	npc3 = CreatePed(5, model, 1873.23, 338.97, 44.54-0.95, 0.0, false, true)
	npc4 = CreatePed(5, model, 1871.8977050781, 3339.8115234375, 42.5526664733887, 37.00, 0.0, false, true)
	npc5 = CreatePed(5, model, -465.76, -2280.88, 8.51-0.95, 0.0, 0.0, false, true)


	SetEntityHeading(npc, 30.0)
	SetEntityHeading(npc2, 157.0)
	SetEntityHeading(npc3, 264.0)
	SetEntityHeading(npc4, 295.0)
	SetEntityHeading(npc5, 359.0)

	FreezeEntityPosition(npc, true)
	FreezeEntityPosition(npc2, true)
	FreezeEntityPosition(npc3, true)
	FreezeEntityPosition(npc4, true)
	FreezeEntityPosition(npc5, true)

	SetEntityInvincible(npc, true)
	SetEntityInvincible(npc2, true)
	SetEntityInvincible(npc3, true)
	SetEntityInvincible(npc4, true)
	SetEntityInvincible(npc5, true)

	SetBlockingOfNonTemporaryEvents(npc, true)
	SetBlockingOfNonTemporaryEvents(npc2, true)
	SetBlockingOfNonTemporaryEvents(npc3, true)
	SetBlockingOfNonTemporaryEvents(npc4, true)
	SetBlockingOfNonTemporaryEvents(npc5, true)

	TaskPlayAnim(npc, "mini@strip_club@idles@bouncer@base", "base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
	TaskPlayAnim(npc2, "mini@strip_club@idles@bouncer@base", "base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
	TaskPlayAnim(npc3, "mini@strip_club@idles@bouncer@base", "base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
	TaskPlayAnim(npc4, "mini@strip_club@idles@bouncer@base", "base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
	TaskPlayAnim(npc5, "mini@strip_club@idles@bouncer@base", "base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
end)

function OpenKitsMenu()
	local elements = {}
	if PlayerData.hiddenjob.name ~= nil and (PlayerData.hiddenjob.grade_name == "szef" or PlayerData.hiddenjob.grade >= 5) then
		table.insert(elements, {label = 'Stwórz zestaw (twój ekwipunek)', value = 'createkit'})
	end
	table.insert(elements, {label = 'Zestawy', value = 'kits'})
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'organisations_kits', {
		title    = 'Zestawy',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		menu.close()
		if data.current.value == 'createkit' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'organisations_kits_name', {
				title = 'Nazwa zestawu'
			}, function(data2, menu2)
				ESX.UI.Menu.CloseAll()
				TriggerServerEvent('csskroubleKits:createkit', data2.value)
				OpenKitsMenu(PlayerData.hiddenjob.name)
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'kits' then
			TriggerServerEvent('csskroubleKits:requestkits')
		end
	end, function(data, menu)
		menu.close()
		OpenJakJaKurwaNieNawidzeJebanegoFalsiakaMenu(PlayerData.hiddenjob.name)
	end)
end

RegisterNetEvent('csskroubleKits:sendrequestedkits', function(organization, result)
	local elements = {}
	for k, v in pairs(result) do
		table.insert(elements, {label = v.name, value = v.id})
	end
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'organisations_saved_kits', {
		title    = 'Zestawy',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		local options = {
			{label = 'Wybierz zestaw', value = 'choose'},
			{label = 'Daj zestaw', value = 'give'},
		}
		if PlayerData.hiddenjob.name ~= nil and (PlayerData.hiddenjob.grade_name == "szef" or PlayerData.hiddenjob.grade >= 5) then
			table.insert(options, {label = '<span style="color:red;"><b>Usuń zestaw</b></span>', value = 'delete'})
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'organisations_saved_kits2', {
			title    = 'Zestaw: '..data.current.label,
			align    = 'center',
			elements = options
		}, function(data2, menu2)
			menu2.close()
			if data2.current.value == 'choose' then
				TriggerServerEvent('csskroubleKits:equipkit', data.current.value, data.current.label)
			elseif data2.current.value == 'delete' then
				TriggerServerEvent('csskroubleKits:deletekit', data.current.value, data.current.label)
				OpenKitsMenu(PlayerData.hiddenjob.name)
			elseif data2.current.value == 'give' then
				local players = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 10.0)
				local serverIds = {}
				for i = 1, #players, 1 do
					if players[i] ~= PlayerId() then
						table.insert(serverIds, {label = 'ID: '..GetPlayerServerId(players[i]), value = GetPlayerServerId(players[i])})
					end
				end
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'organisations_givekit', {
					title    = 'Wybierz gracza',
					align    = 'center',
					elements = serverIds
				}, function(data3, menu3)
					TriggerServerEvent('csskroubleKits:givekit', data3.current.value, data.current.value, data.current.label)
					OpenKitsMenu(PlayerData.hiddenjob.name)
				end, function(data3, menu3)
					menu3.close()
				end)
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		menu.close()
		OpenJakJaKurwaNieNawidzeJebanegoFalsiakaMenu(PlayerData.hiddenjob.name)
	end)
end)