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

ESX                           = nil
local GUI                     = {}
GUI.Time                      = 0
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local currentSkin 			  = nil

CreateThread(function()
	while ESX == nil do
		TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) 
			ESX = obj 
		end)
		
		Citizen.Wait(250)
	end
end)

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

AddEventHandler('esx_clotheshop:hasEnteredMarker', function(zone)
	CurrentAction     = 'shop_menu'
	CurrentActionMsg  = ('Naciśnij ~INPUT_CONTEXT~ aby się przebrać')
	CurrentActionData = {}
end)

AddEventHandler('esx_clotheshop:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
	cleanPlayer()
end)

function cleanPlayer()
	TriggerEvent('skinchanger:loadSkin', currentSkin)
	currentSkin = nil
end

-- Create Blips
CreateThread(function()
	for i=1, #Config.Shops, 1 do
		local blip = AddBlipForCoord(Config.Shops[i].x, Config.Shops[i].y, Config.Shops[i].z)

		SetBlipSprite (blip, 73)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.7)
		SetBlipColour (blip, 43)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('clothes'))
		EndTextCommandSetBlipName(blip)
	end
end)

-- Display markers
CreateThread(function()
	while true do
		Citizen.Wait(5)

		local coords, sleep = GetEntityCoords(PlayerPedId()), true

		for k,v in pairs(Config.Zones) do
			if #(coords - vec3(v.Pos.x, v.Pos.y, v.Pos.z)) < Config.DrawDistance then
				sleep = false
				ESX.DrawMarker(vec3(v.Pos.x, v.Pos.y, v.Pos.z))
			end
		end
		
		if sleep then
			Citizen.Wait(500)
		end
	end
end)

-- Enter / Exit marker events
CreateThread(function()
	while true do
		Citizen.Wait(100)

		local coords, sleep = GetEntityCoords(PlayerPedId()), true
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			if (#(coords - vec3(v.Pos.x, v.Pos.y, v.Pos.z)) < v.Size.x) then
				sleep = false
				isInMarker  = true
				currentZone = k
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('esx_clotheshop:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_clotheshop:hasExitedMarker', LastZone)
		end
		if sleep then
			Citizen.Wait(500)
		end
	end
end)

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

-- Key controls
CreateThread(function()
	while true do
		Citizen.Wait(3)

		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, Keys['E']) and (GetGameTimer() - GUI.Time) > 300 then
				if CurrentAction == 'shop_menu' then
					OpenShopMenu()
				end

				CurrentAction = nil
				GUI.Time      = GetGameTimer()
			end
		else
			Citizen.Wait(500)
		end
	end
end)
