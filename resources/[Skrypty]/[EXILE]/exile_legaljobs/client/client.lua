ESX = nil
PlayerData = {}
local HasAlreadyEnteredMarker, LastZone = false, nil
local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local isUsing, zoneName = false, nil

local Limits = {120, 140, 160, 180, 200, 220, 240, 260, 280, 300}
local levelPrices = {1000000, 1000000, 1000000, 1000000, 1000000, 1000000, 1000000, 1000000, 1000000, 1000000}

CreateThread(function()
	while ESX == nil do
		TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) 
			ESX = obj 
		end)
		
		Citizen.Wait(250)
	end

	Citizen.Wait(5000)

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx:setHiddenJob')
AddEventHandler('esx:setHiddenJob', function(hiddenjob)
	PlayerData.hiddenjob = hiddenjob
end)

CreateThread(function()
	Citizen.Wait(1000)
	for i=1, #Config.Blips, 1 do
		local blip = AddBlipForCoord(Config.Blips[i].coords)
		
		SetBlipSprite (blip, Config.Blips[i].sprite)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, Config.Blips[i].scale)
		SetBlipColour (blip, Config.Blips[i].color)
		SetBlipAsShortRange(blip, true)
		
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.Blips[i].label)
		EndTextCommandSetBlipName(blip)
	end
end)

RegisterNetEvent('exile_legaljobs:putOnClothes')
AddEventHandler('exile_legaljobs:putOnClothes', function(job)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if Config.ItemsUniforms[job].male ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config.ItemsUniforms[job].male)
			else
				ESX.ShowNotification("Brak ubrania")
			end
		else
			if Config.ItemsUniforms[job].female ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config.ItemsUniforms[job].female)
			else
				ESX.ShowNotification("Brak ubrania")
			end
		end
	end)
end)

function PutOnClothes(value)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if value.male ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, value.male)
			else
				ESX.ShowNotification("Brak ubrania")
			end
		else
			if value.female ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, value.female)
			else
				ESX.ShowNotification("Brak ubrania")
			end
		end
	end)
end

AddEventHandler('exile_legaljobs:hasEnteredMarker', function(zone, currentLabel)
	if zone == 'Cloakroom' then
		CurrentAction = 'cloakroom'
		CurrentActionMsg  = _U('cloakroom_menu', currentLabel)
		CurrentActionData = {}
	elseif zone =='Inventory' then
		CurrentAction = 'inventory'
		CurrentActionMsg  = _U('inventory_menu', currentLabel)
		CurrentActionData = {}
	elseif zone =='Inventory2' then
		CurrentAction = 'inventory'
		CurrentActionMsg  = _U('inventory_menu', currentLabel)
		CurrentActionData = {}
	elseif zone == 'Vehicles' then
		CurrentAction = 'vehicles'
		CurrentActionMsg = _U('vehicles_menu', currentLabel)
		CurrentActionData = {}
	elseif zone == 'Planes' then
		CurrentAction = 'planes'
		CurrentActionMsg = _U('planes_menu', currentLabel)
		CurrentActionData = {}
	elseif zone == 'Boats' then
		CurrentAction = 'boats'
		CurrentActionMsg = _U('boats_menu', currentLabel)
		CurrentActionData = {}
	elseif zone == 'DeleteBoats' then
		CurrentAction = 'deleteBoats'
		CurrentActionMsg = _U('delete_menu', currentLabel)
		CurrentActionData = {}
	elseif zone == 'DeleteVehicles' then
		CurrentAction = 'deleteVeh'
		CurrentActionMsg = _U('delete_menu', currentLabel)
		CurrentActionData = {}
	elseif zone == 'Shops' then
		CurrentAction = 'shop'
		CurrentActionMsg = _U('shop_menu', currentLabel)
		CurrentActionData = {}
	elseif zone == 'BossMenu' then
		CurrentAction = 'boss_menu'
		CurrentActionMsg  = _U('boss_menu', currentLabel)
		CurrentActionData = {}
	end
end)

AddEventHandler(GetCurrentResourceName() .. ':exitedMarker', function(zone)
	if isUsing then
		isUsing = false
		if Config.Zones[PlayerData.job.name] then
			TriggerServerEvent('exile:setUsed', zoneName, 'society_'..PlayerData.job.name, false)
		elseif Config.Zones[PlayerData.hiddenjob.name] then
			TriggerServerEvent('exile:setUsed', zoneName, 'society_'..PlayerData.hiddenjob.name, false)
		end
		
	end
	zoneName = nil
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

--[[CreateThread(function()
	while true do
		Citizen.Wait(1)
		local playerPos = GetEntityCoords(PlayerPedId(), true)
		for k,v in pairs(Config.MarkeryPrac) do
			local TabliczkaPos = v.coords
			local Dystans = #(playerPos - vec3(TabliczkaPos.x, TabliczkaPos.y, TabliczkaPos.z))
			if Dystans <= 5.0 then
				ESX.ShowFloatingHelpNotification(v.nazwa, vec3(TabliczkaPos.x, TabliczkaPos.y, TabliczkaPos.z))
				print(v.nazwa)
			end
		end
	end
end)]]

-- Display markers
CreateThread(function()
	while true do
		Citizen.Wait(3)

		if PlayerData.job ~= nil then
			if Config.Zones[PlayerData.job.name] or Config.Zones[PlayerData.hiddenjob.name] then
				local coords, letSleep = GetEntityCoords(PlayerPedId()), true
				local currentJob = ""
				if Config.Zones[PlayerData.job.name] then
					currentJob = PlayerData.job.name
				elseif Config.Zones[PlayerData.hiddenjob.name] then
					currentJob = PlayerData.hiddenjob.name
				end
				for k,v in pairs(Config.Zones[currentJob]) do
					if k ~= 'Hiddenjob' then
						if k == 'DeleteVehicles' or k == 'DeleteBoats' then
							if #(coords - v.coords) < 20.0 then
								letSleep = false
								ESX.DrawMarker(v.coords)
							end
						else
							if #(coords - v.coords) < Config.DrawDistance then
								letSleep = false
								ESX.DrawMarker(v.coords)
							end
						end
					end
				end

				if letSleep then
					Citizen.Wait(1000)
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
	local trackedEntities = {
		'prop_roadcone02a',
		'prop_barrier_work05',
		'prop_tyre_spike_01',
		'prop_boxpile_07d',
		'hei_prop_cash_crate_half_full',
		'p_ld_stinger_s'
	}

	while pCoords == nil do
		Citizen.Wait(100)
	end
	while true do
		Citizen.Wait(500)
		for i=1, #trackedEntities, 1 do
			local object = GetClosestObjectOfType(pCoords.x, pCoords.y, pCoords.z, 3.0, GetHashKey(trackedEntities[i]), false, false, false)

			if DoesEntityExist(object) then
				local objCoords = GetEntityCoords(object)
				local distance  = #(pCoords - objCoords)

				if closestDistance == -1 or closestDistance > distance then
					closestDistance = distance
					closestEntity   = object
				end
			end
		end
	end
end)

-- Enter / Exit marker events
CreateThread(function()

	while true do
		Citizen.Wait(2000)



		if PlayerData.job ~= nil then
			if Config.Zones[PlayerData.job.name] or Config.Zones[PlayerData.hiddenjob.name] then
				local coords      = GetEntityCoords(PlayerPedId())
				local isInMarker  = false
				local currentZone = nil
				local currentJob  = ""
				local currentLabel = ""
				if Config.Zones[PlayerData.job.name] then
					currentJob = PlayerData.job.name
					currentLabel = PlayerData.job.label
				elseif Config.Zones[PlayerData.hiddenjob.name] then
					currentJob = PlayerData.hiddenjob.name
					currentLabel = PlayerData.hiddenjob.label
				end
				for k,v in pairs(Config.Zones[currentJob]) do
					if k ~= 'Hiddenjob' then
						if k == 'DeleteVehicles' or k == 'DeleteBoats' then
							if #(coords - v.coords) < 4.5 then
								isInMarker  = true
								currentZone = k
							end
						else
							if #(coords - v.coords) < 1.5 then
								isInMarker  = true
								currentZone = k
							end
						end
					end
				end

				if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
					HasAlreadyEnteredMarker = true
					LastZone                = currentZone
					TriggerEvent('exile_legaljobs:hasEnteredMarker', currentZone, currentLabel)
				end

				if not isInMarker and HasAlreadyEnteredMarker then
					HasAlreadyEnteredMarker = false
					TriggerEvent(GetCurrentResourceName() .. ':exitedMarker', LastZone)
				end
			else
				Citizen.Wait(5000)
			end
		else
			Citizen.Wait(5000)
		end
	end
end)

-- Key Controls
CreateThread(function()
	while true do
		Citizen.Wait(3)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) and PlayerData.job then
				if Config.Zones[PlayerData.job.name] or Config.Zones[PlayerData.hiddenjob.name] then
					DisableControlAction(0, 289, true) -- F2
					local currentJob = ""
					local currentGrade = 0
					if Config.Zones[PlayerData.job.name] then
						currentJob = PlayerData.job.name
						currentGrade = PlayerData.job.grade
					elseif Config.Zones[PlayerData.hiddenjob.name] then
						currentJob = PlayerData.hiddenjob.name
						currentGrade = PlayerData.hiddenjob.grade
					end
					if CurrentAction == 'cloakroom' then
						OpenCloakroomMenu(currentJob, currentGrade)
					elseif CurrentAction == 'inventory' then
						ESX.TriggerServerCallback('exile:isUsed', function(isUsed)
							if not isUsed then
								isUsing = true
								TriggerServerEvent('exile:setUsed', 'Inventories', 'society_'..currentJob, true)
								zoneName = 'Inventories'
								OpenInventoryMenu(currentJob, currentGrade)
							else
								ESX.ShowNotification("~r~Ktoś właśnie używa tej szafki")
							end
						end, 'Inventories', 'society_' .. currentJob)
					elseif CurrentAction == 'inventory2' then
						ESX.TriggerServerCallback('exile:isUsed', function(isUsed)
							if not isUsed then
								isUsing = true
								TriggerServerEvent('exile:setUsed', 'Inventories', 'society_'..currentJob, true)
								zoneName = 'Inventories'
								OpenInventoryMenu(currentJob, currentGrade)
							else
								ESX.ShowNotification("~r~Ktoś właśnie używa tej szafki")
							end
						end, 'Inventories', 'society_' .. currentJob)
					elseif CurrentAction == 'vehicles' then
						if currentGrade >= Config.Zones[currentJob].Vehicles.from then
							OpenVehiclesMenu(currentJob, currentGrade)
						else
							ESX.ShowNotification("~r~Nie posiadasz wystarczających uprawnień do korzystania z tego garażu")
						end
					elseif CurrentAction == 'planes' then
						if currentGrade >= Config.Zones[currentJob].Planes.from then
							OpenPlanesMenu(currentJob, currentGrade)
						else
							ESX.ShowNotification("~r~Nie posiadasz wystarczających uprawnień do korzystania z tego garażu")
						end
					elseif CurrentAction == 'boats' then
						if currentGrade >= Config.Zones[currentJob].Boats.from then
							OpenBoatsMenu(currentJob, currentGrade)
						else
							ESX.ShowNotification("~r~Nie posiadasz wystarczających uprawnień do korzystania z tego garażu")
						end
					elseif CurrentAction == 'deleteBoats' then
						if IsPedSittingInAnyVehicle(PlayerPedId()) then
							local veh = GetVehiclePedIsIn(PlayerPedId(), false)
							ESX.Game.Teleport(PlayerPedId(), Config.Zones[currentJob].Boats.coords)
							ESX.Game.DeleteVehicle(veh)
						end
					elseif CurrentAction == 'deleteVeh' then
						if IsPedSittingInAnyVehicle(PlayerPedId()) then
							ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
						end
					elseif CurrentAction == 'shop' then
						OpenShopMenu(currentJob, currentGrade)
					elseif CurrentAction == 'boss_menu' then
						OpenBossMenu(currentJob, currentGrade)
					end

					CurrentAction = nil
				end
			end
		else
			Wait(500)
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if not IsPedInAnyVehicle(PlayerPedId()) and PlayerData.job and (Config.Interactions[PlayerData.job.name] or Config.Interactions[PlayerData.hiddenjob.name]) then
			local Control = 0
			if Config.Interactions[PlayerData.job.name] then
				Control = 167
			elseif Config.Interactions[PlayerData.hiddenjob.name] then
				Control = 168
			end
			if IsControlJustReleased(0, Control) and GetEntityHealth(PlayerPedId()) > 100 then
				if Config.Interactions[PlayerData.job.name] then
					OpenActionsMenu(PlayerData.job.name, PlayerData.job.grade)
				elseif Config.Interactions[PlayerData.hiddenjob.name] then
					OpenActionsMenu(PlayerData.hiddenjob.name, PlayerData.hiddenjob.grade)
				end
			end
		else
			Wait(500)
		end
	end
end)

function dowodAnim()
	RequestAnimDict("random@atmrobberygen")
	while not HasAnimDictLoaded("random@atmrobberygen") do 
		Citizen.Wait(0)
	end
	TaskPlayAnim(PlayerPedId(), "random@atmrobberygen", "a_atm_mugging", 8.0, 3.0, 2000, 56, 1, false, false, false)
	wallet = Citizen.InvokeNative(0x509D5878EB39E842, `prop_ld_wallet_01`, GetEntityCoords(PlayerPedId()), true)
	AttachEntityToEntity(wallet, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0x49D9), 0.17, 0.0, 0.019, -120.0, 0.0, 0.0, 1, 0, 0, 0, 0, 1)
	Citizen.Wait(500)
	id = Citizen.InvokeNative(0x509D5878EB39E842, `prop_michael_sec_id`, GetEntityCoords(PlayerPedId()), true)
	AttachEntityToEntity(id, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0xDEAD), 0.150, 0.045, -0.015, 0.0, 0.0, 180.0, 1, 0, 0, 0, 0, 1)
	Citizen.Wait(1300)
	DeleteEntity(wallet)
	DeleteEntity(id)
end

function faceNotification(title, subject, msg, playerID)
	local mugshot, mugshotStr = ESX.Game.GetPedMugshot(Citizen.InvokeNative(0x43A66C31C68491C0, GetPlayerFromServerId(playerID)))
	ESX.ShowAdvancedNotification(title, subject, msg, mugshotStr, 4, 140)
	UnregisterPedheadshot(mugshot)
end

RegisterNetEvent(GetCurrentResourceName() .. ':sendProx')
AddEventHandler(GetCurrentResourceName() .. ':sendProx', function(id, name, job, job_grade, phonenumber)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  local title = job
  local subject = name
  local mess = "Stanowisko: ~g~" .. job_grade .. "\n~w~Numer telefonu: ~g~" .. tostring(phonenumber)
  local chatMess = " podaje swój identyfikator: " .. name .. " - " .. job

  if (pid ~= -1) then
	if pid == myId then
		faceNotification(title, subject, mess, id)
		dowodAnim()
		TriggerEvent('chatMessage',"^*Obywatel [" .. id .. "] ".. chatMess, {204, 153, 255})
	elseif #(GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, myId)) - GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, pid))) < 2.5 then
		faceNotification(title, subject, mess, id)
		TriggerEvent('chatMessage',"^*Obywatel [" .. id .. "] ".. chatMess, {204, 153, 255})
	end
  end
end)

function OpenActionsMenu(job, grade)
	ESX.UI.Menu.CloseAll()
	local elements = {}
		
--	table.insert(elements, {label = "Identyfikator", value = 'identify'})
	if Config.Interactions[job].Handcuff then
		if grade >= Config.Interactions[job].Handcuff then
			table.insert(elements, {label = "Kajdanki", value = 'handcuff'})
		end
	end
	if Config.Interactions[job].Repair then
		if grade >= Config.Interactions[job].Repair then
			table.insert(elements, {label = "Napraw pojazd", value = 'repair'})
		end
	end
	if Config.Interactions[job].CostamxD then
		if grade >= Config.Interactions[job].CostamxD then
			table.insert(elements, {label = "Obiekty", value = 'object_spawner'})
		end
	end
	if Config.Interactions[job].kontrakt then
		if grade >= Config.Interactions[job].kontrakt then
			table.insert(elements, {label = "Kontrakt", value = 'kontrakt'})
		end
	end
	if Config.Interactions[job].License then
		if grade >= Config.Interactions[job].License then
			table.insert(elements, {label = "Wystaw licencję - Helikopter", value = 'license'})
		end
	end
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'actions_menu',
	{
		title    = "Menu interakcji",
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)			
		if (data.current.value == 'identify') then
			TriggerServerEvent(GetCurrentResourceName() .. ':showIdentify', job)
		elseif (data.current.value == 'license') then
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if closestPlayer ~= -1 and closestDistance <= 3.0 then
				menu.close()
				TriggerServerEvent('esx_license:addLicense', GetPlayerServerId(closestPlayer), 'air')
			else
				ESX.ShowNotification("~r~Brak osób w pobliżu")
			end
		elseif (data.current.value == 'handcuff') then
			menu.close()
			exports['esx_policejob']:HandcuffMenu()
		elseif (data.current.value == 'repair') then
			menu.close()
			TriggerEvent('esx_mechanicjobdrugi:onFixKitFree')
		elseif (data.current.value == 'kontrakt') then
			menu.close()
			TriggerServerEvent('exile:kontrakt')
		elseif data.current.value == 'object_spawner' then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interactionxd',
			{
				title    = 'Obiekty',
				align    = 'top-left',
				elements = {
					{label = 'Pachołek',		value = 'prop_roadcone02a'},
					{label = 'Barierka',		value = 'prop_barrier_work05'},
				}
			}, function(data2, menu2)
				local playerPed = PlayerPedId()
				local coords, forward = GetEntityCoords(playerPed), GetEntityForwardVector(playerPed)
				local objectCoords = (coords + forward * 1.0)
				
				ESX.Game.SpawnObject(data2.current.value, objectCoords, function(obj)
					SetEntityHeading(obj, tonumber(GetEntityHeading(playerPed)))
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

RegisterNetEvent('exile:getInventoryItem')
AddEventHandler('exile:getInventoryItem',function(society)
	--ESX.UI.Menu.CloseAll()

	ESX.TriggerServerCallback('exile:getStockItems', function(inventory)
		local elements = {}

		if inventory.blackMoney > 0 then
			table.insert(elements, {
				label = 'Brudne pieniądze: <span style="color: red;"> ' .. ESX.Math.GroupDigits(inventory.blackMoney) .. '$</span>',
				type = 'item_account',
				value = 'black_money'
			})
		end

		local weapons = {}
		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				if type(item.label) == 'table' and item.label.label then
					item.label = item.label.label
					item.type = 'weapon'
				end

				if item.type == 'weapon' then
					if not weapons[item.label] then
						weapons[item.label] = {
							label = item.label,
							list = {}
						}
					end

					table.insert(weapons[item.label].list, item.name)
				else
					table.insert(elements, {
						label = (item.count > 1 and 'x' .. item.count .. ' ' or '') .. item.label,
						type = 'item_standard',
						value = item.name
					})
				end
			end
		end

		for weaponLabel, weaponData in pairs(weapons) do
			if #weaponData.list > 0 then
				if #weaponData.list > 1 then
					if not IsSubMenuInElements(elements, weaponLabel) then
						table.insert(elements, {
							label = ('>> %s x%i <<'):format(weaponLabel, #weaponData.list),
							type = 'sub',

							value = weaponData
						})
					end
				else
					table.insert(elements, {
						label = weaponLabel,
						type = 'item_standard',
						value = weaponData.list[1]
					})
				end
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = "Magazyn",
			align    = 'bottom-right',
			elements = elements
		}, function(data, menu)
			if data.current.type == 'sub' then
				OpenSubGetInventoryItem(data.current.value, society)
			else
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
					title = "Ilość",
				}, function(data2, menu2)
					local count = tonumber(data2.value)
	
					if count == nil then
						ESX.ShowNotification("~r~Nieprawidłowa wartość!")
					else
						menu2.close()
						menu.close()
	
						TriggerServerEvent('exile:getStockItem', data.current.type, data.current.value, count, society)
						ESX.SetTimeout(300, function()
							TriggerEvent('exile:getInventoryItem', society)
						end)
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, society)
end)

function OpenSubGetInventoryItem(data, society)
	local elements = {}

	for i=1, #data.list do
		table.insert(elements, {
			label = data.label,
			type = 'item_standard',
			value = data.list[i]
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu_sub', {
		title    = ("Magazyn (%s)"):format(data.label),
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_sub_get_item_count', {
			title = "Ilość",
		}, function(data2, menu2)
			local count = tonumber(data2.value)

			if count == nil then
				ESX.ShowNotification("~r~Nieprawidłowa wartość!")
			else
				menu2.close()
				menu.close()

				TriggerServerEvent('exile:getStockItem', data.current.type, data.current.value, count, society)
				ESX.SetTimeout(300, function()
					TriggerEvent('exile:getInventoryItem', society)
				end)
			end
		end, function(data2, menu2)
			menu2.close()
		end)
	end, function(data, menu)
		menu.close()
	end)
end

function IsSubMenuInElements(elements, name)
	for i=1, #elements do
		if elements[i].type == 'sub' and elements[i].value == name then
			return true
		end
	end

	return false
end

-- RegisterNetEvent('exile:putInventoryWeapon')
-- AddEventHandler('exile:putInventoryWeapon', function(society)
-- 	ESX.UI.Menu.CloseAll()
-- 	local elements2 = {}
-- 	local playerPed  = PlayerPedId()
-- 	local weaponList = ESX.GetWeaponList()
-- 	for i=1, #weaponList, 1 do
-- 		local weaponHash = GetHashKey(weaponList[i].name)
-- 		if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
-- 			local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
-- 			table.insert(elements2, {
-- 				label = weaponList[i].label .. " [" .. ammo .. "]", 
-- 				type = 'item_weapon',
-- 				value = weaponList[i].name, 
-- 				ammo = ammo
-- 			})
-- 		end
-- 	end
-- 	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu',
-- 	{
-- 	title    = "Ekwipunek",
-- 	align    = 'bottom-right',
-- 	elements = elements2
-- 	},
-- 	function(data, menu)
-- 		local itemName = data.current.value
-- 		local itemType = data.current.type
-- 		if data.current.ammo < 1 then
-- 			menu.close()
-- 			TriggerServerEvent('exile:putItemInStock', itemType, itemName, data.current.ammo, society)
-- 			ESX.SetTimeout(500, function()
-- 				TriggerEvent('exile:putInventoryWeapon', society)
-- 			end)
-- 		else
-- 			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_weapon_count',
-- 			{
-- 			title = "Ilość amunicji"
-- 			},
-- 			function(data2, menu2)
-- 				local count = tonumber(data2.value)
-- 				if count == nil then
-- 					ESX.ShowNotification("~r~Nieprawidłowa wartość!")
-- 				else
-- 					if count > data.current.ammo then
-- 						ESX.ShowNotification("~r~Nie posiadasz tyle amunicji w broni!")
-- 					else
-- 						menu2.close()
-- 						menu.close()
-- 						TriggerServerEvent('exile:putItemInStock', itemType, itemName, count, society)
-- 						ESX.SetTimeout(500, function()
-- 							TriggerEvent('exile:putInventoryWeapon', society)
-- 						end)
-- 					end
-- 				end
-- 			end,
-- 			function(data2, menu2)
-- 				menu2.close()
-- 			end)
-- 		end
-- 	end,
-- 	function(data, menu)
-- 		menu.close()
-- 	end)
-- end)
RegisterNetEvent('exile:putInventoryItems')
AddEventHandler('exile:putInventoryItems', function(society)
	--ESX.UI.Menu.CloseAll()

	ESX.TriggerServerCallback('exile:getPlayerInventory', function(inventory)
		if inventory.blackMoney > 0 then
			local type = "item_money"
			local name = "black_money"
			local count = inventory.blackMoney
			TriggerServerEvent('exile:putItemInStock', type, name, count, society)
		end

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]
			if item.count > 0 then
				if not (item.type == 'sim') then
					local type = "item_standard"
					local name = item.name
					local count = item.count
					TriggerServerEvent('exile:putItemInStock', type, name, count, society)
				end
			end
		end
	end)
end)

RegisterNetEvent('exile:putInventoryItem')
AddEventHandler('exile:putInventoryItem', function(society)
	--ESX.UI.Menu.CloseAll()

	ESX.TriggerServerCallback('exile:getPlayerInventory', function(inventory)
		local elements = {}

		if inventory.blackMoney > 0 then
			table.insert(elements, {
				label = 'Brudne pieniądze: <span style="color: red;"> ' .. ESX.Math.GroupDigits(inventory.blackMoney) .. '$</span>',
				type  = 'item_account',
				value = 'black_money'
			})
		end

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = (item.count > 1 and 'x' .. item.count .. ' ' or '') .. item.label,
					type = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = "Ekwipunek",
			align    = 'bottom-right',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value
			local itemType = data.current.type

			if itemType == 'item_sim' then
				TriggerServerEvent('gcphone:putSimInStock', data.current.number, society)

				ESX.SetTimeout(300, function()
					TriggerEvent('exile:putInventoryItem', society)
				end)
			else
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
					title = "Ilość"
				}, function(data2, menu2)
					local count = tonumber(data2.value)

					if count == nil then
						ESX.ShowNotification("~r~Nieprawidłowa wartość!")
					else
						menu2.close()
						menu.close()

						TriggerServerEvent('exile:putItemInStock', itemType, itemName, count, society)
						ESX.SetTimeout(300, function()
							TriggerEvent('exile:putInventoryItem', society)
						end)
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end
		end, function(data, menu)
			menu.close()
		end)
	end)
end)

function OpenInventoryMenu(job, grade)
    local elements = {
        {label = "Włóż", value = 'deposit'}
    }

    if grade >= Config.Zones[job].Inventory.from then
        table.insert(elements, {label = "Wyciągnij", value = 'withdraw'})
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'inventory', {
        title    = 'Magazyn',
        align    = 'bottom-right',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'withdraw' then
            TriggerEvent('exile:getInventoryItem', 'society_' .. job)
        else
            TriggerEvent('exile:putInventoryItem', 'society_' .. job)
        end
    end, function(data, menu)
        menu.close()
    end, nil, function()
        if isUsing then
            isUsing = false
            TriggerServerEvent('exile:setUsed', 'Inventories', 'society_' .. job, false)
        end    
    end)
end

function OpenCloakroomMenu(job, grade)
	ESX.UI.Menu.CloseAll()
	local elements = {}
	table.insert(elements, {label = "Ubrania prywatne", value = 'player_dressing'})
	if Config.Zones[job].Cloakroom.jobCloakroom then
		table.insert(elements, {label = "Ubrania pracownicze", value = 'job_dressing'})
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'inventory',
	{
		title    = 'Garderoba',
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
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
		elseif data.current.value == 'job_dressing' then
			local elements2 = {}
			for i=1, #Config.Uniforms[job], 1 do
				local tempConfig = Config.Uniforms[job][i]
				for j=1, #Config.Uniforms[job][i].ranks, 1 do
					if grade == Config.Uniforms[job][i].ranks[j] then
						table.insert(elements2, {
							label = tempConfig.label,
							value = tempConfig.values
						})
					end
				end
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom2',
				{
					title    = "Ubrania pracownicze",
					align    = 'bottom-right',
					elements = elements2
				}, function(data2, menu2)
					PutOnClothes(data2.current.value)
					menu2.close()
				end, function(data2, menu2)
					menu2.close()
				end)
			end
	end, function(data, menu)
		menu.close()
	end)
end

function SetVehicleMaxMods(vehicle, name)
	local props = {
		modEngine       = 3,
		modBrakes       = 2,
		modTransmission = 2,
		modSuspension   = 3,
		modArmor		= 4,
		modXenon		= true,
		modTurbo        = true,
		dirtLevel		= 0.0,
		color1			= 131,
		color2			= 131
	}
	ESX.Game.SetVehicleProperties(vehicle, props)
end

function OpenVehiclesMenu(legaljob, grade)
	ESX.UI.Menu.CloseAll()
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false))
	else
		local elements = {}
		for i=1, #Config.Vehicles[legaljob], 1 do
			local tempConfig = Config.Vehicles[legaljob][i]
			if grade >= tempConfig.from then
				table.insert(elements, {label  = tempConfig.label, value = tempConfig.name})
			end
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle',
		{
			title    = 'Pojazdy',
			align    = 'bottom-right',
			elements = elements
		}, function(data, menu)
			local plate = nil
			if legaljob == 'extreme' then
				plate = 'EXT ' .. math.random(100,900)
			elseif legaljob == 'casino' then
				plate = 'CAS ' .. math.random(100,900)
			elseif legaljob == 'cardealer' then
				plate = 'CAR ' .. math.random(100,900)
			elseif legaljob == 'galaxy' then
				plate = 'GLY ' .. math.random(100,900)
			end
			ESX.Game.SpawnVehicle(data.current.value, Config.Zones[legaljob].Vehicles.coords, Config.Zones[legaljob].Vehicles.heading, function(vehicle)
				TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
				SetVehicleNumberPlateText(vehicle, plate)
				plate = string.gsub(plate, " ", "")
				TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
				SetVehicleMaxMods(vehicle, legaljob)
				local localVehPlate = string.lower(GetVehicleNumberPlateText(vehicle))
				TriggerEvent('ls:dodajklucze2', localVehPlate)
			end)
			menu.close()
		end, function(data, menu)
			menu.close()
		end)
	end	
end

function OpenPlanesMenu(legaljob, grade)
	ESX.UI.Menu.CloseAll()
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false))
	else
		local elements = {}
		for i=1, #Config.Planes[legaljob], 1 do
			local tempConfig = Config.Planes[legaljob][i]
			if grade >= tempConfig.from then
				table.insert(elements, {label  = tempConfig.label, value = tempConfig.name})
			end
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle',
		{
			title    = 'Pojazdy',
			align    = 'bottom-right',
			elements = elements
		}, function(data, menu)
			local plate = nil
			if legaljob == 'extreme' then
				plate = 'EXT ' .. math.random(100,900)
			end
			ESX.Game.SpawnVehicle(data.current.value, Config.Zones[legaljob].Planes.spawn, Config.Zones[legaljob].Planes.heading, function(vehicle)
				TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
				SetVehicleNumberPlateText(vehicle, plate)
				plate = string.gsub(plate, " ", "")
				TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
				SetVehicleMaxMods(vehicle, legaljob)
				local localVehPlate = string.lower(GetVehicleNumberPlateText(vehicle))
				TriggerEvent('ls:dodajklucze2', localVehPlate)
			end)
			menu.close()
		end, function(data, menu)
			menu.close()
		end)
	end	
end

function OpenBoatsMenu(legaljob, grade)
	ESX.UI.Menu.CloseAll()
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false))
	else
		local elements = {}
		for i=1, #Config.Boats[legaljob], 1 do
			local tempConfig = Config.Boats[legaljob][i]
			if grade >= tempConfig.from then
				table.insert(elements, {label  = tempConfig.label, value = tempConfig.name})
			end
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle',
		{
			title    = 'Pojazdy',
			align    = 'bottom-right',
			elements = elements
		}, function(data, menu)
			local plate = nil
			if legaljob == 'extreme' then
				plate = 'EXT ' .. math.random(100,900)
			end
			ESX.Game.SpawnVehicle(data.current.value, Config.Zones[legaljob].Boats.spawn, Config.Zones[legaljob].Boats.heading, function(vehicle)
				TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
				SetVehicleNumberPlateText(vehicle, plate)
				plate = string.gsub(plate, " ", "")
				TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
				SetVehicleMaxMods(vehicle, legaljob)
				local localVehPlate = string.lower(GetVehicleNumberPlateText(vehicle))
				TriggerEvent('ls:dodajklucze2', localVehPlate)
			end)
			menu.close()
		end, function(data, menu)
			menu.close()
		end)
	end	
end

function OpenShopMenu(legaljob, grade)
	ESX.UI.Menu.CloseAll()
	local elements = {}
	for i=1, #Config.Shops[legaljob], 1 do
		local tempConfig = Config.Shops[legaljob][i]
		if grade >= tempConfig.from then
			table.insert(elements, {
				label  = tempConfig.label, 
				name = tempConfig.value, 
				item = tempConfig.type, 
				quantity = tempConfig.quantity,
				value      = 1,
				type       = 'slider',
				min        = 1,
				max        = tempConfig.quantity
			})
		end
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shopmenu',
	{
		title    = 'Sklep',
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		if data.current.item == 'weapon' then
			TriggerServerEvent(GetCurrentResourceName() .. ':giveWeapon', data.current.name, data.current.quantity)
		elseif data.current.item == 'item' then
			TriggerServerEvent(GetCurrentResourceName() .. ':giveItem', data.current.name, data.current.value)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenBossMenu(job, grade)
	if Config.Zones[job].Hiddenjob == true then
		if job == 'sheriff' then
			if grade >= Config.Zones[job].BossMenu.from then 
				TriggerEvent('esx_society:openHiddenBossMenu', job, 10, function(data, menu)
					menu.close()
				end, { showmoney = false, withdraw = false, deposit = false, wash = false, employees = true, grades = false })
			else
				ESX.ShowNotification("~r~Nie masz dostępu do zarządzania tą frakcją")
			end
		else
			if grade >= Config.Zones[job].BossMenu.from then 
				TriggerEvent('esx_society:openHiddenBossMenu', job, 10, function(data, menu)
					menu.close()
				end, { showmoney = true, withdraw = true, deposit = true, wash = false, employees = true, grades = false })
			else
				TriggerEvent('esx_society:openHiddenBossMenu', job, 10, function(data, menu)
					menu.close()
				end, { showmoney = false, withdraw = false, deposit = true, wash = false, employees = false, grades = false })
			end
		end
	else
		if job == 'kawiarnia' then
			if grade >= Config.Zones[job].BossMenu.from then
				if grade == 6 then 
					TriggerEvent('esx_society:openBossMenu', job, function(data, menu)
						menu.close()
					end, { showmoney = true, withdraw = false, deposit = true, wash = false, employees = true, grades = false })
				else
					TriggerEvent('esx_society:openBossMenu', job, function(data, menu)
						menu.close()
					end, { showmoney = true, withdraw = true, deposit = true, wash = false, employees = true, grades = false })
				end
			else
				TriggerEvent('esx_society:openBossMenu', job, function(data, menu)
					menu.close()
				end, { showmoney = false, withdraw = false, deposit = true, wash = false, employees = false, grades = false })
			end
		else
			if grade >= Config.Zones[job].BossMenu.from then 
				TriggerEvent('esx_society:openBossMenu', job, function(data, menu)
					menu.close()
				end, { showmoney = true, withdraw = true, deposit = true, wash = false, employees = true, grades = false })
			else
				TriggerEvent('esx_society:openBossMenu', job, function(data, menu)
					menu.close()
				end, { showmoney = false, withdraw = false, deposit = true, wash = false, employees = false, grades = false })
			end
		end
	end
end

function OpenLicensesMenu(job)
	ESX.UI.Menu.CloseAll()
	ESX.TriggerServerCallback('exile_legaljobs:getLicenses', function(licenses)
		local elements = {
			head = {'Poziom', 'Akcje'},
			rows = {}
		}
		local level = tostring(licenses.level)
		table.insert(elements.rows, {
			data = tonumber(level),
			cols = {
				level .. " <br>" .. Limits[licenses.level] .. " osób",
				'{{' .. "Podnieś poziom" .. '|upgrade}}'
			}
		})
		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'legaljobs', elements, function(data, menu)
			if data.value == 'upgrade' then
				if data.data >= 10 then
					ESX.ShowNotification('~r~Osiągnąłeś już maksymalny poziom firmy!')
				else
					menu.close()
					local nextLevel = data.data + 1
					local price = levelPrices[tonumber(nextLevel)]
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'nextlevelsociety', {
						title    = 'Czy na pewno? ',
						align    = 'bottom-right',
						elements = {
							{label = 'Nie',  value = 'no'},
							{label = 'Tak (<span style="color:yellowgreen;"> ' .. price .. '$</span> )',  value = 'yes'},
						}
					}, function(data2, menu2)
						if data2.current.value == 'yes' then
							menu2.close()
							TriggerServerEvent('exile_legaljobs:upgradeSociety', 'level', nextLevel, job, price)
						else
							menu2.close()
						end
					end, function(data2, menu2)
						menu2.close()
						OpenLicensesMenu(job)
					end)
				end
			end
		end, function(data, menu)
			menu.close()
		end)
	end, job)
end

function GetLimits(level)
	return Limits[level]
end

function LevelPrices(level)
	return levelPrices[level]
end


Config.Coords = vector3(-265.95, -962.42, 31.22-0.95)

CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())
		sleep = true
		if GetDistanceBetweenCoords(Config.Coords, playerCoords, true) < 5.0 then
			sleep = false
			ESX.DrawMarker(Config.Coords)
			if GetDistanceBetweenCoords(Config.Coords, playerCoords, true) < 1.0 then
				ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~ aby, zatrudnić się w nowej pracy.')
				if IsControlJustPressed(0, 51) then		
					OpenMenu()
			
				end
			end
		end
		if sleep then
			Wait(500)
		end
	end
end)

function OpenMenu()
	ESX.TriggerServerCallback('xfsd-listing:getJob', function(jobs)
		local elements = {}

		for i=1, #jobs, 1 do
			table.insert(elements, {label = jobs[i].label, value = jobs[i].value})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'test', {
			title    = 'Urząd Pracy',
			align    = 'center',
			elements = elements
		}, function(data, menu)
			TriggerServerEvent('xfsd-listing:getnewjob', data.current.value)			
			menu.close()
		end, function(data, menu)
			menu.close()
		end)
	end)
end