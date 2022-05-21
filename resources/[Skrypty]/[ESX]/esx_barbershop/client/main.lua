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
local currentSkin             = nil

CreateThread(function()
	while ESX == nil do
		TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) 
			ESX = obj 
		end)
		
		Citizen.Wait(250)
	end
end)

function OpenShopMenu()
	TriggerEvent('skinchanger:getSkin', function(skin)
		currentSkin = skin
	end)
	
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			TriggerEvent('skinchanger:loadSkin', {
				helmet_1 = -1,
				helmet_2 = 0,
				mask_1   = 0,
				mask_2   = 0,
			})
		else
			TriggerEvent('skinchanger:loadSkin', {
				helmet_1 = -1,
				helmet_2 = 0,
				mask_1   = 0,
				mask_2   = 0,
			})
		end
	end)

	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)
		menu.close()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
			title = _U('valid_purchase'),
			align = 'center',
			elements = {
				{label = _U('yes'), value = 'yes'},
				{label = _U('no'), value = 'no'},
			}
		}, function(data, menu)
			menu.close()
			if data.current.value == 'yes' then
				ESX.TriggerServerCallback('esx_barbershop:checkMoney', function(hasEnoughMoney)
					if hasEnoughMoney then
						TriggerServerEvent('esx_barbershop:pay')
						TriggerEvent('skinchanger:getSkin', function(skin)
							skin['helmet_1'] = currentSkin['helmet_1']
							skin['helmet_2'] = currentSkin['helmet_2']
							skin['mask_1'] = currentSkin['mask_1']
							skin['mask_2'] = currentSkin['mask_2']
							
							TriggerServerEvent('esx_skin:save', skin)
							
							currentSkin = skin
						end)
					else
						ESX.ShowNotification(_U('not_enough_money'))
						cleanPlayer()
					end
				end)
			elseif data.current.value == 'no' then
				cleanPlayer()
			end

			CurrentAction     = 'shop_menu'
			CurrentActionMsg  = _U('press_access')
			CurrentActionData = zone
		end, function(data, menu)
			menu.close()
			cleanPlayer()

			CurrentAction     = 'shop_menu'
			CurrentActionMsg  = _U('press_access')
			CurrentActionData = zone
		end)
	end, function(data, menu)
		menu.close()
		
		cleanPlayer()
		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('press_access')
		CurrentActionData = zone
	end, {
		'hair_1',
		'hair_2',
		'hair_3',
		'hair_color_1',
		'hair_color_2',
		'makeup_1',
		'makeup_2',
		'makeup_3',
		'makeup_4',
		'blush_1',
		'blush_2',
		'blush_3',
		'lipstick_1',
		'lipstick_2',
		'lipstick_3',
		'lipstick_4',
		'eyebrows_1',
		'eyebrows_2',
		'eyebrows_3',
		'eyebrows_4',
		'beard_1',
		'beard_2',
		'beard_3',
		'beard_4',
		'chest_1',
		'chest_2',
		'chest_3',
	})

end

AddEventHandler('esx_barbershop:hasEnteredMarker', function(zone)
	CurrentAction     = 'shop_menu'
	CurrentActionMsg  = _U('press_access')
	CurrentActionData = {}
end)

AddEventHandler('esx_barbershop:hasExitedMarker', function(zone)
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

		SetBlipSprite (blip, 71)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.8)
		SetBlipColour (blip, 41)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('barber_blip'))
		EndTextCommandSetBlipName(blip)
	end
end)

-- Display markers
CreateThread(function()
	while true do
		Citizen.Wait(2)

		local coords = GetEntityCoords(PlayerPedId())
		local sleep = true

		for k,v in pairs(Config.Zones) do
			if #(coords - vec3(v.Pos.x, v.Pos.y, v.Pos.z)) < 10 then
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
		Citizen.Wait(120)

		local coords, sleep      = GetEntityCoords(PlayerPedId()), true
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			if #(coords - vec3(v.Pos.x, v.Pos.y, v.Pos.z)) < v.Size.x then
				sleep = false
				isInMarker  = true
				currentZone = k
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('esx_barbershop:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_barbershop:hasExitedMarker', LastZone)
		end
		if sleep then
			Citizen.Wait(500)
		end
	end
end)

-- Key controls
CreateThread(function()
	while true do
		Citizen.Wait(10)
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