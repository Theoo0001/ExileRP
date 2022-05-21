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

local isPaused, isDead, currentweapon = false, false, {}

CreateThread(function()
	while true do
		Citizen.Wait(0)

		if Citizen.InvokeNative(0xB8DFD30D6973E135, PlayerId()) then
			TriggerServerEvent('esx:onPlayerJoined')
			break
		end
	end
end)

ESX.UI.HUD.DisplayTicket = function(position)

end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	ESX.PlayerLoaded = true
	ESX.PlayerData = playerData
	local loadingPosition = (ESX.PlayerData.coords or {x = -539.0761, y = -215.14, z = 36.8})

	--PVP
	SetCanAttackFriendly(playerPed, true, false)
	NetworkSetFriendlyFireOption(true)
	
	--Wanted LVL
	ClearPlayerWantedLevel(PlayerId())
	SetMaxWantedLevel(0)
	TriggerServerEvent('esx:ambulancejob:deathspawn')
	TriggerServerEvent('esx:onPlayerSpawn')
	TriggerEvent('esx:onPlayerSpawn')
	TriggerEvent('playerSpawned')
	
	DecorRegister('isSpawned', 2)
	
	Citizen.Wait(3000)
	
	for k,v in pairs(ESX.PlayerData.slots) do
		local found = false
		
		for k2,v2 in pairs(ESX.PlayerData.inventory) do	
			if v2.count > 0 then
				if k == v2.name then
				
					found = true
					if v2.type == 'weapon' then
						SendNUIMessage({
							action = 'updateSlot',
							slot = v,
							name = v2.data.name
						})			
					elseif v2.type == 'sim' then
						SendNUIMessage({
							action = 'updateSlot',
							slot = v,
							name = 'sim'
						})			
					elseif v2.type == 'item' then
						SendNUIMessage({
							action = 'updateSlot',
							slot = v,
							name = v2.name
						})			
					end		
				end
			end
		end
		
		if not found then
			ESX.SetSlot(k, nil, true)
		end

	end
	
	SetWeaponsNoAutoswap(false)
	StartServerSyncLoops()
	
--[[	for k,v in pairs(ESX.PlayerData.skill) do
		if Skills[k] then
			Skills[k]['Current'] = v
		end
	end]]
	
	Citizen.Wait(500)
	--RefreshSkills()
end)

--[[RegisterNetEvent('esx:setSkills')
AddEventHandler('esx:setSkills', function(values)
	ESX.PlayerData.skill = values
	
	for k,v in pairs(values) do
		if Skills[k] then
			Skills[k]['Current'] = v
		end
	end
end)

Skills = {
    ["stamina"] = {
        ["Current"] = 0,
        ["Stat"] = "MP0_STAMINA"
    },
    ["sila"] = {
        ["Current"] = 0,
        ["Stat"] = "MP0_STRENGTH"
    },
    ["nurek"] = {
        ["Current"] = 0,
        ["Stat"] = "MP0_LUNG_CAPACITY"
    },
    ["kierowca"] = {
        ["Current"] = 0,
        ["Stat"] = "MP0_DRIVING_ABILITY"
    },
}]]

--[[CreateThread(function()
	while true do
		Citizen.Wait(60000)
		local ped = PlayerPedId()
		local vehicle = GetVehiclePedIsUsing(ped)

		if IsPedRunning(ped) then
			UpdateSkill("stamina", 3)
		elseif IsPedInMeleeCombat(ped) then
			UpdateSkill("sila", 5)
		elseif IsPedSwimmingUnderWater(ped) then
			UpdateSkill("nurek", 5)
		elseif DoesEntityExist(vehicle) and GetPedInVehicleSeat(vehicle, -1) == ped then
			local speed = GetEntitySpeed(vehicle) * 3.6
			if speed >= 80 then
				UpdateSkill("kierowca", 3)
			elseif IsPedInFlyingVehicle(ped) then
				UpdateSkill("kierowca", 5)
			end
		end
	end
end)]]

--[[UpdateSkill = function(skill, amount)
    local SkillAmount = Skills[skill]["Current"]

    if SkillAmount + tonumber(amount) < 0 then
        Skills[skill]["Current"] = 0
    elseif SkillAmount + tonumber(amount) > 10000 then
        Skills[skill]["Current"] = 10000
    else
        Skills[skill]["Current"] = SkillAmount + tonumber(amount)
    end
    
    RefreshSkills()

	if tonumber(amount) > 0 then
		ESX.ShowAdvancedNotification('ExileRP','~b~Umiejętności','Zdobywasz punkty doświadczenia: ~g~+'..amount..'~b~ '..skill)
	end
	TriggerServerEvent("exile_skills:update", skill, tonumber(amount))
end


function round(num) 
    return (num / 10000)
end

RefreshSkills = function()
    for type, value in pairs(Skills) do
        if value["Stat"] then
            StatSetInt(value["Stat"], round(value["Current"]), true)
        end
    end
end]]

AddEventHandler('esx:onPlayerSpawn', function() 
	isDead = false 
end)

AddEventHandler('esx:onPlayerDeath', function() 
	isDead = true 
end)

AddEventHandler('skinchanger:modelLoaded', function()
	while not ESX.PlayerLoaded do
		Citizen.Wait(100)
	end
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	for k,v in ipairs(ESX.PlayerData.accounts) do
		if v.name == account.name then
			ESX.PlayerData.accounts[k] = account
			break
		end
	end
end)

RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function(item, count, showNotification)
	local found = false
	for k,v in ipairs(ESX.PlayerData.inventory) do
		if v.name == item.name then
			found = true
			ESX.UI.ShowInventoryItemNotification(true, v.label, count - v.count)
			ESX.PlayerData.inventory[k].count = count
			break
		end
	end
	
	if not found then
		ESX.TriggerServerCallback('esx:isValidItem', function(status)
			if status then
				table.insert(ESX.PlayerData.inventory, item)

				ESX.UI.ShowInventoryItemNotification(true, item.label, count)
				if ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
					ESX.ShowInventory()
				end
			end
		end, item.name)	
	else
		if showNotification then
			ESX.UI.ShowInventoryItemNotification(true, item.label, count)
		end

		if ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
			ESX.ShowInventory()
		end
	end

end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count, showNotification)
	local found = false
	
	for k,v in ipairs(ESX.PlayerData.inventory) do
		if v.name == item.name then
			found = true
			
			ESX.UI.ShowInventoryItemNotification(false, v.label, v.count - count)
			ESX.PlayerData.inventory[k].count = count
			
			if item.count <= 0 then				
				if ESX.PlayerData.slots[item.name] then							
					ESX.SetSlot(item.name, nil, true)
				end
				
				if v.type == 'weapon' then
					RemoveWeaponFromPed(PlayerPedId(), GetHashKey(v.data.name))
				end
			
			end	
			
			break
		end
	end

	if not found then
		ESX.TriggerServerCallback('esx:isValidItem', function(status)
			if status then
				table.insert(ESX.PlayerData.inventory, item)
				
				if item.count <= 0 then
					if ESX.PlayerData.slots[item.name] then					
						ESX.SetSlot(item.name, nil, true)
					end
				end	

				ESX.UI.ShowInventoryItemNotification(true, item.label, count)
				if ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
					ESX.ShowInventory()
				end
			end
		end, item.name)	
	else
		if showNotification then
			ESX.UI.ShowInventoryItemNotification(true, item.label, count)
		end

		if ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
			ESX.ShowInventory()
		end
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:removeWeaponComponent')
AddEventHandler('esx:removeWeaponComponent', function(weaponName, weaponComponent)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash

	RemoveWeaponComponentFromPed(playerPed, weaponHash, componentHash)
end)

RegisterNetEvent('esx:teleport')
AddEventHandler('esx:teleport', function(coords)
	local playerPed = PlayerPedId()

	-- ensure decmial number
	coords.x = coords.x + 0.0
	coords.y = coords.y + 0.0
	coords.z = coords.z + 0.0

	ESX.Game.Teleport(playerPed, coords)
end)

RegisterNetEvent('esx:setHiddenJob')
AddEventHandler('esx:setHiddenJob', function(hiddenjob)
	ESX.PlayerData.hiddenjob = hiddenjob
end)

RegisterNetEvent('esx:spawnVehicle')
AddEventHandler('esx:spawnVehicle', function(vehicleName)
	local model = (type(vehicleName) == 'number' and vehicleName or GetHashKey(vehicleName))

	if IsModelInCdimage(model) then
		local playerPed = PlayerPedId()
		local playerCoords, playerHeading = GetEntityCoords(playerPed), GetEntityHeading(playerPed)

		ESX.Game.SpawnVehicle(model, playerCoords, playerHeading, function(vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		end)
	else
		TriggerEvent('chat:addMessage', {args = {'^1SYSTEM', 'Invalid vehicle model.'}})
	end
end)

RegisterNetEvent('esx:spawnObject')
AddEventHandler('esx:spawnObject', function(model, coords)
	ESX.Game.SpawnObject(model, coords)
end)

RegisterNetEvent('esx:registerSuggestions')
AddEventHandler('esx:registerSuggestions', function(registeredCommands)
	for name,command in pairs(registeredCommands) do
		if command.suggestion then
			TriggerEvent('chat:addSuggestion', ('/%s'):format(name), command.suggestion.help, command.suggestion.arguments)
		end
	end
end)

RegisterNetEvent('esx:deleteVehicle')
AddEventHandler('esx:deleteVehicle', function(radius)
	local playerPed = PlayerPedId()

	if radius and tonumber(radius) then
		radius = tonumber(radius) + 0.01
		local vehicles = ESX.Game.GetVehiclesInArea(GetEntityCoords(playerPed), radius)

		for k,entity in ipairs(vehicles) do
			local attempt = 0

			while not NetworkHasControlOfEntity(entity) and attempt < 100 and DoesEntityExist(entity) do
				Citizen.Wait(100)
				NetworkRequestControlOfEntity(entity)
				attempt = attempt + 1
			end

			if DoesEntityExist(entity) and NetworkHasControlOfEntity(entity) then
				ESX.Game.DeleteVehicle(entity)
			end
		end
	else
		local vehicle, attempt = ESX.Game.GetVehicleInDirection(), 0

		if IsPedInAnyVehicle(playerPed, true) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		end

		while not NetworkHasControlOfEntity(vehicle) and attempt < 100 and DoesEntityExist(vehicle) do
			Citizen.Wait(100)
			NetworkRequestControlOfEntity(vehicle)
			attempt = attempt + 1
		end

		if DoesEntityExist(vehicle) and NetworkHasControlOfEntity(vehicle) then
			ESX.Game.DeleteVehicle(vehicle)
		end
	end
end)

local WeaponsUpdate = {}

-- Keep track of ammo usage
function StartServerSyncLoops()

	CreateThread(function()
		while true do
			Citizen.Wait(1000)
			
			if currentweapon.name ~= nil then
				local playerPed = PlayerPedId() 
				local status, weaponHash = GetCurrentPedWeapon(playerPed, true)
				
				if status == 1 then
					local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
					
					for k,v in ipairs(ESX.PlayerData.inventory) do
						if v.type == 'weapon' then
							if v.name == currentweapon.name and GetHashKey(currentweapon.weapon) == weaponHash then
								if v.data.ammo ~= ammo then
									v.data.ammo = ammo
									
									WeaponsUpdate[v.name] = ammo
								end
							end
						end
					end					
				end
			else
				Citizen.Wait(1000)
			end
		end
	end)
	
	CreateThread(function()
		while true do
			Citizen.Wait(5 * 1000)
			
			local playerPed = PlayerPedId()
			if DoesEntityExist(playerPed) then	
				if json.encode(WeaponsUpdate) ~= '[]' then
					TriggerServerEvent('esx:updateItemMultiple', WeaponsUpdate)
					
					WeaponsUpdate = {}
				end
			end
		end
	end)

	CreateThread(function()
		local previousCoords = vector3(ESX.PlayerData.coords.x, ESX.PlayerData.coords.y, ESX.PlayerData.coords.z)

		while true do
			Citizen.Wait(5000)
			local playerPed = PlayerPedId()

			if DoesEntityExist(playerPed) then
				local playerCoords = GetEntityCoords(playerPed)
				local distance = #(playerCoords - previousCoords)

				if distance > 5 then
					previousCoords = playerCoords
					local playerHeading = ESX.Math.Round(GetEntityHeading(playerPed), 1)
					local formattedCoords = {x = ESX.Math.Round(playerCoords.x, 1), y = ESX.Math.Round(playerCoords.y, 1), z = ESX.Math.Round(playerCoords.z, 1), heading = playerHeading}
					TriggerServerEvent('esx:updateCoords', formattedCoords)
				end
			end
		end
	end)
end

RegisterCommand('showinv', function()
	if not exports['esx_ambulancejob']:isDead() and not exports['esx_policejob']:IsCuffed() and not ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
		ESX.ShowInventory()
	end
end)

RegisterKeyMapping('showinv', 'Włącz/wyłącz ekwipunek', 'keyboard', 'F2')


CreateThread(function()
	while true do
		Citizen.Wait(0)
		if ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
			if IsControlPressed(0, Keys['LEFTALT']) then
				local bind = nil
				for i, key in ipairs({157, 158, 160, 164, 165}) do
					DisableControlAction(0, key, true)
						if IsDisabledControlJustPressed(0, key) then
							bind = i
						break
					end
				end

				if bind then
					local menu = ESX.UI.Menu.GetOpened('default', 'es_extended', 'inventory')
					local elements = menu.data.elements
					
					for i=1, #elements, 1 do
						if elements[i].selected then
							if elements[i].usable or elements[i].type == 'item_weapon' then
								ESX.ShowNotification('Ustawiono ~y~'..elements[i].label..'~s~ na pozycję ~o~'..bind)
								ESX.SetSlot(elements[i].value, bind, true)				

								ESX.ShowInventory()
							else
								ESX.ShowNotification('Nie możesz ustawić ~y~'..elements[i].label)
							end
						end
					end
				end
			end	
		else
			Citizen.Wait(250)	
		end
	end
end)


--New weapon system misiaczek


RegisterNetEvent('esx_weashop:clipcli')
AddEventHandler('esx_weashop:clipcli', function(extended)
	local playerPed = PlayerPedId()

	if DoesEntityExist(playerPed) then
		local status, weaponHash = GetCurrentPedWeapon(playerPed, true)
		local weapon = ESX.GetWeaponFromHash(weaponHash)
		
		if status == 1 and weapon and currentweapon.name ~= nil then
			local canput = false
			for k,v in ipairs(ESX.PlayerData.inventory) do
				if v.type == 'weapon' then
					if v.name == currentweapon.name and GetHashKey(currentweapon.weapon) == weaponHash then
						for k2,v2 in ipairs(Config.Weapons) do
							if v.data.name == v2.name then 
								if v2.take_ammo ~= nil then
									if v2.take_ammo == extended then
										canput = true
										
										local _ammo = v.data.ammo + 32
										if _ammo >= 250 then
											_ammo = 250									
										end
										
										v.data.ammo = _ammo
										
										Citizen.InvokeNative(0x14E56BC5B5DB6A19, playerPed, weaponHash, _ammo)
										
										TriggerServerEvent('esx:updateItem', v.name, 'ammo', v.data.ammo)
										break											
									end	
								end
							end					
						end
					end
				end
			end
			
			if canput then
				TriggerServerEvent('esx_weashop:remove', extended)
			else
				ESX.ShowNotification('~r~Nieodpowiedni typ magazynku')
			end	
			
		else
			ESX.ShowNotification("Nie posiadasz broni w ręce")
		end
		
	end		
end)

RegisterNetEvent('es_extended:setComponent')
AddEventHandler('es_extended:setComponent', function(state, weaponComponent)
	local playerPed = PlayerPedId()
	local status, weaponHash = GetCurrentPedWeapon(playerPed, true)
	local weapon = ESX.GetWeaponFromHash(weaponHash)
		
	local found = false
	for k,v in ipairs(ESX.PlayerData.inventory) do
		if v.type == 'weapon' then
			if v.name == currentweapon.name and GetHashKey(currentweapon.weapon) == weaponHash then
				found = true
				if state then			
					local componentHash = ESX.GetWeaponComponent(v.data.name, weaponComponent)
					
					if componentHash then
						local Equiped = false
						for k2,v2 in ipairs(v.data.components) do
							if v2 == weaponComponent then
								Equiped = true
								break
							end
						end		
						
						if Equiped then
							ESX.ShowNotification('Posiadasz już zamontowany '..componentHash.label)
						else						
							table.insert(v.data.components, weaponComponent)
							GiveWeaponComponentToPed(playerPed, GetHashKey(v.data.name), componentHash.hash)
							ESX.ShowNotification('Udało ci się zamontować '..componentHash.label)
							
							TriggerServerEvent('es_extended:componentMenu', true, weaponComponent)
							
							PlaySoundFrontend(-1, "WEAPON_ATTACHMENT_UNEQUIP", "HUD_AMMO_SHOP_SOUNDSET", 1)
							
							TriggerServerEvent('esx:updateItem', v.name, 'components', v.data.components)
						end
					else
						ESX.ShowNotification('Nie możesz zamontować dodatku')
					end
				else
					local componentHash = ESX.GetWeaponComponent(v.data.name, weaponComponent)
					
					if componentHash then
						local Equiped = false
						for k2,v2 in ipairs(v.data.components) do
							if v2 == weaponComponent then
								Equiped = true
								
								table.remove(v.data.components, k2)
								break
							end
						end		
						
						if Equiped then												
							RemoveWeaponComponentFromPed(playerPed, GetHashKey(v.data.name), componentHash.hash)
							ESX.ShowNotification('Udało ci się zdemontować '..componentHash.label)
							
							TriggerServerEvent('es_extended:componentMenu', false, weaponComponent)
							TriggerServerEvent('esx:updateItem', v.name, 'components', v.data.components)
							
							PlaySoundFrontend(-1, "WEAPON_ATTACHMENT_UNEQUIP", "HUD_AMMO_SHOP_SOUNDSET", 1)
						else
							ESX.ShowNotification('Broń nie posiada zamontowanego '..componentHash.label)
						end
					else
						ESX.ShowNotification('Nie możesz zdemontować dodatku')
					end			
				end
				
				break
			end
		end
	end
	
	if not found then
		ESX.ShowNotification("Ta broń nie posiada tego dodatku")
	end
end)

RegisterNetEvent('es_extended:useSlot')
AddEventHandler('es_extended:useSlot', function(name)
	local found = false
	
	local playerPed = PlayerPedId() 
	local weapon = GetSelectedPedWeapon(playerPed)
	
	for k,v in ipairs(ESX.PlayerData.inventory) do
		if v.name == name then
			found = true
			
			if v.type == 'weapon' then
				if not exports['esx_ambulancejob']:IsBlockWeapon() then
					if currentweapon.name == name and GetHashKey(currentweapon.weapon) == weapon then
						ESX.ShowNotification('Schowałeś/aś ~r~'..v.label..' '..(v.data.serial_number and '['..v.data.serial_number..']' or ''))
						currentweapon = {}
						SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)					
					else
						currentweapon = {name = name, weapon = v.data.name}
						ESX.ShowNotification('Wyciągnąłeś/aś ~g~'..v.label..' '..(v.data.serial_number and '['..v.data.serial_number..']' or ''))
						
						local hash = GetHashKey(v.data.name)	
						if not HasPedGotWeapon(playerPed, hash, false) then
							Citizen.InvokeNative(0xBF0FD6E56C964FCB, playerPed, hash, 0, false, true)
						end			

						if v.data.components ~= nil then				
							for k2,v2 in ipairs(Config.Weapons) do
								if v2.name == v.data.name then						
									
									for k3,v3 in ipairs(v2.components) do
										local hash2 = v3.hash
										local foundcomp = false
										
										for k4,v4 in ipairs(v.data.components) do
											local componentHash = ESX.GetWeaponComponent(v.data.name, v4)
											
											if componentHash ~= nil then
												if hash2 == componentHash.hash then
													foundcomp = true
													break
												end
											end
										end
										
										if not foundcomp then
											RemoveWeaponComponentFromPed(playerPed, hash, hash2)
										else
											GiveWeaponComponentToPed(playerPed, hash, hash2)	
										end
									end
								end
							end
						end
						
						SetCurrentPedWeapon(playerPed, hash, true)
						
						if v.data.tintIndex ~= nil then
							SetPedWeaponTintIndex(playerPed, hash, v.data.tintIndex)
						else
							SetPedWeaponTintIndex(playerPed, hash, 0)
						end
						
						if v.data.ammo then
							Citizen.InvokeNative(0x14E56BC5B5DB6A19, playerPed, hash, v.data.ammo)
							
							print('[ExileRP]: Set Weapon Ammo '..v.data.ammo)
						end					
					end
				else
					ESX.ShowNotification('~r~Jesteś zbyt bardzo osłabiony żeby wyciągnąć broń')
				end
			elseif v.type == 'item' or v.type == 'sim' then
				TriggerServerEvent('esx:useItem', v.name)
			end
		end
	end
		
		
	if not found then			
		ESX.SetSlot(name, nil, true)
	end
end)

RegisterKeyMapping('+-slot1', 'Slot 1', 'keyboard', '1')
RegisterKeyMapping('+-slot2', 'Slot 2', 'keyboard', '2')
RegisterKeyMapping('+-slot3', 'Slot 3', 'keyboard', '3')
RegisterKeyMapping('+-slot4', 'Slot 4', 'keyboard', '4')
RegisterKeyMapping('+-slot5', 'Slot 5', 'keyboard', '5')

RegisterCommand('+-slot1', function()	
	local ped = PlayerPedId()
	if exports["esx_ambulancejob"]:isDead() then return end
	if not IsControlPressed(0, Keys['LEFTALT']) and (not IsControlPressed(0, Keys['LEFTSHIFT']) or (IsPedSprinting(ped) or IsPedRunning(ped))) then
		Select(1, ped)
	end
end)

RegisterCommand('+-slot2', function()
	local ped = PlayerPedId()
	if exports["esx_ambulancejob"]:isDead() then return end
	if not IsControlPressed(0, Keys['LEFTALT']) and (not IsControlPressed(0, Keys['LEFTSHIFT']) or (IsPedSprinting(ped) or IsPedRunning(ped))) then
		Select(2, ped)
	end
end)

RegisterCommand('+-slot3', function()
	local ped = PlayerPedId()
	if exports["esx_ambulancejob"]:isDead() then return end
	if not IsControlPressed(0, Keys['LEFTALT']) and (not IsControlPressed(0, Keys['LEFTSHIFT']) or (IsPedSprinting(ped) or IsPedRunning(ped))) then
		Select(3, ped)
	end
end)

RegisterCommand('+-slot4', function()
	local ped = PlayerPedId()
	if exports["esx_ambulancejob"]:isDead() then return end
	if not IsControlPressed(0, Keys['LEFTALT']) and (not IsControlPressed(0, Keys['LEFTSHIFT']) or (IsPedSprinting(ped) or IsPedRunning(ped))) then
		Select(4, ped)
	end
end)

RegisterCommand('+-slot5', function()
	local ped = PlayerPedId()
	if exports["esx_ambulancejob"]:isDead() then return end
	if not IsControlPressed(0, Keys['LEFTALT']) and (not IsControlPressed(0, Keys['LEFTSHIFT']) or (IsPedSprinting(ped) or IsPedRunning(ped))) then
		Select(5, ped)
	end
end)

function Select(number, ped)
	if not exports['esx_policejob']:IsCuffed() and exports['exile_animacje']:PedStatus() and not IsPedInAnyPoliceVehicle(ped) then
		local slot = ESX.GetMisiaczekSlots()
		
		local item = nil
		for k,v in pairs(slot) do
			if v == number then
				item = k
			end
		end
		
		
		if item ~= nil then
			TriggerEvent('es_extended:useSlot', item)
		end
	end
end

RegisterNetEvent('esx:updateDecor')
AddEventHandler('esx:updateDecor', function(what, entity, key, value)
	entity = NetworkGetEntityFromNetworkId(entity)
	if not entity or entity < 1 then
	  --nil
	elseif what == 'DEL' then
		DecorRemove(entity, key)
	elseif what == 'BOOL' then
		DecorSetBool(entity, key, value == true)
	else
		value = tonumber(value)
		if value then
			DecorSetInt(entity, key, value)
		end
	end 
end)
