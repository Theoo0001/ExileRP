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

ESX                  = nil
local FirstSpawn     = true
local LastSkin       = nil
local PlayerLoaded   = false
local cam            = nil
local isCameraActive = false
local zoomOffset     = 0.0
local camOffset      = 0.0
local heading        = 90.0
local offset 		 = 0.0

CreateThread(function()
	while ESX == nil do
		TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) 
			ESX = obj 
		end)
		
		Citizen.Wait(250)
	end
end)

function OpenMenu(submitCb, cancelCb, restrict)
	local playerPed = PlayerPedId()

	TriggerEvent('skinchanger:getSkin', function(skin)
		LastSkin = skin

		TriggerEvent('skinchanger:getData', function(components, maxVals)
			local elements    = {}
			local _components = {}

			-- Restrict menu
			if restrict == nil then
				for i=1, #components, 1 do
					_components[i] = components[i]
				end
			else
				for i=1, #components, 1 do
					local found = false

					for j=1, #restrict, 1 do
						if components[i].name == restrict[j] then
							found = true
						end
					end

					if found then
						table.insert(_components, components[i])
					end
				end
			end

			-- Insert elements
			for i=1, #_components, 1 do
				local value       = _components[i].value
				
				local componentId = _components[i].componentId
				if componentId == 0 then
					value = GetPedPropIndex(playerPed, _components[i].componentId)
				end

				local data = {
					label     = _components[i].label,
					name      = _components[i].name,
					value     = value,
					min       = _components[i].min,
					restrict  = skin.sex == 0 and _components[i].restrictMale or _components[i].restrictFemale,
					textureof = _components[i].textureof,
					zoomOffset= _components[i].zoomOffset,
					camOffset = _components[i].camOffset,
					type      = 'slider'
				}

				for k,v in pairs(maxVals) do
					if k == _components[i].name then
						data.max = v
					end
				end

				table.insert(elements, data)
			end

			CreateSkinCam()
			zoomOffset = _components[1].zoomOffset
			camOffset = _components[1].camOffset

		  ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'skin',
			{
			  title = _U('skin_menu'),
			  align = 'bottom-right',
			  elements = elements
			},
			function(data, menu)
				menu.close()
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'skin_confirm', {
					title    = 'Czy na pewno chcesz zapisać zmiany?',
					align    = 'center',
					elements = {
						{ label = 'Tak', value = true },
						{ label = 'Nie', value = false }
					},
				}, function(data2, menu2)
					menu2.close()
					if data2.current.value then
						TriggerEvent('skinchanger:getSkin', function(skin)
							LastSkin = skin
						end)
						TriggerEvent("csskrouble:save")
						DeleteSkinCam()
						if submitCb ~= nil then
							submitCb(data, menu)
						end
					else
						CreateSkinCam()
						menu.open()
					end
				end, function(data2, menu2)
					menu2.close()
					CreateSkinCam()
					menu.open()
				end)
			end,
			function(data, menu)
				menu.close()
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'skin_confirm', {
					title    = 'Czy na pewno chcesz wyjść bez zapisywania zmian?',
					align    = 'center',
					elements = {
						{ label = 'Tak', value = true },
						{ label = 'Nie', value = false }
					},
				}, function(data2, menu2)
					menu2.close()
					if data2.current.value then
						TriggerEvent('skinchanger:loadSkin', LastSkin)

						DeleteSkinCam()
						if cancelCb ~= nil then
							cancelCb(data, menu)
						end
					else
						CreateSkinCam()
						menu.open()
					end
				end, function(data2, menu2)
					menu2.close()
					CreateSkinCam()
					menu.open()
				end)
			end, function(data, menu)
			  TriggerEvent('skinchanger:getSkin', function(skin)
				zoomOffset = data.current.zoomOffset
				camOffset = data.current.camOffset
				if skin[data.current.name] ~= data.current.value then
				  -- Change skin element
				  TriggerEvent('skinchanger:change', data.current.name, data.current.value)

				  -- Update max values
				  TriggerEvent('skinchanger:getData', function(components, maxVals)
					for i=1, #elements, 1 do
					  local newData = {}

					  newData.max = maxVals[elements[i].name]
					  if elements[i].textureof ~= nil and data.current.name == elements[i].textureof then
						newData.value = 0
					  end

					  menu.update({name = elements[i].name}, newData)
					end

					menu.refresh()
				  end)
				end
			  end)
			end,
			function()
				DeleteSkinCam()
			end)
		end)
	end)
end

function OpenMenuCreate(submitCb, cancelCb, restrict)
	local playerPed = PlayerPedId()

	TriggerEvent('skinchanger:getSkin', function(skin)
		LastSkin = skin

		TriggerEvent('skinchanger:getData', function(components, maxVals)
			local elements    = {}
			local _components = {}

			-- Restrict menu
			if restrict == nil then
				for i=1, #components, 1 do
					_components[i] = components[i]
				end
			else
				for i=1, #components, 1 do
					local found = false

					for j=1, #restrict, 1 do
						if components[i].name == restrict[j] then
							found = true
						end
					end

					if found then
						table.insert(_components, components[i])
					end
				end
			end

			-- Insert elements
			for i=1, #_components, 1 do
				local value       = _components[i].value
				local componentId = _components[i].componentId

				if componentId == 0 then
					value = GetPedPropIndex(playerPed, _components[i].componentId)
				end

				local data = {
					label     = _components[i].label,
					name      = _components[i].name,
					value     = value,
					min       = _components[i].min,
					restrict  = (skin.sex == 0 and _components[i].restrictMale or _components[i].restrictFemale),
					textureof = _components[i].textureof,
					zoomOffset= _components[i].zoomOffset,
					camOffset = _components[i].camOffset,
					type      = 'slider'
				}

				for k,v in pairs(maxVals) do
					if k == _components[i].name then
						data.max = v
						break
					end
				end

				table.insert(elements, data)
			end

			CreateSkinCam()
			zoomOffset = _components[1].zoomOffset
			camOffset = _components[1].camOffset

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'skin', {
				title = _U('skin_menu'),
				align = 'bottom-right',
				elements = elements
			}, function(data, menu)
				menu.close()
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'skin_confirm', {
					title    = 'Czy na pewno chcesz zapisać zmiany?',
					align    = 'center',
					elements = {
						{ label = 'Tak', value = true },
						{ label = 'Nie', value = false }
					},
				}, function(data2, menu2)
					menu2.close()
					if data2.current.value then
						TriggerEvent('skinchanger:getSkin', function(skin)
							LastSkin = skin
						end)

						DeleteSkinCam()
						
						local ped = PlayerPedId()
						DoScreenFadeOut(500)

						TriggerEvent("csskrouble:save")
						
						ESX.Game.Teleport(ped, {
							x = -1042.28,
							y = -2745.42,
							z = 20.40,
							heading = 152.91
						}, true, function()
							Citizen.InvokeNative(0x239528EACDC3E7DE, ped, false)
							Citizen.InvokeNative(0xEA1C610A04DB6BBB, ped, true)
							DoScreenFadeIn(1000)
						end)
						
						if submitCb ~= nil then
							submitCb(data, menu)
						end
					else
						CreateSkinCam()
						menu.open()
					end
				end, function(data2, menu2)
					menu2.close()
					CreateSkinCam()
					menu.open()
				end)
			end, function(data, menu)
				menu.close()
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'skin_confirm', {
					title    = 'Czy na pewno chcesz wyjść bez zapisywania zmian?',
					align    = 'center',
					elements = {
						{ label = 'Tak', value = true },
						{ label = 'Nie', value = false }
					},
				}, function(data2, menu2)
					menu2.close()
					if data2.current.value then
						TriggerEvent('skinchanger:loadSkin', LastSkin)

						DeleteSkinCam()
						
						local ped = PlayerPedId()
						DoScreenFadeOut(500)
						
						ESX.Game.Teleport(ped, {
							x = -1042.28,
							y = -2745.42,
							z = 20.40,
							heading = 152.91
						}, true, function()
							Citizen.InvokeNative(0x239528EACDC3E7DE, ped, false)
							Citizen.InvokeNative(0xEA1C610A04DB6BBB, ped, true)
							DoScreenFadeIn(1000)
						end)
						
						if cancelCb ~= nil then
							cancelCb(data, menu)
						end
					else
						CreateSkinCam()
						menu.open()
					end
				end, function(data2, menu2)
					menu2.close()
					CreateSkinCam()
					menu.open()
				end)
			end, function(data, menu)
			  TriggerEvent('skinchanger:getSkin', function(skin)
				zoomOffset = data.current.zoomOffset
				camOffset = data.current.camOffset
				if skin[data.current.name] ~= data.current.value then
				  -- Change skin element
				  TriggerEvent('skinchanger:change', data.current.name, data.current.value)

				  -- Update max values
				  TriggerEvent('skinchanger:getData', function(components, maxVals)
					for i=1, #elements, 1 do
					  local newData = {}

					  newData.max = maxVals[elements[i].name]
					  if elements[i].textureof ~= nil and data.current.name == elements[i].textureof then
						newData.value = 0
					  end

					  menu.update({name = elements[i].name}, newData)
					end

					menu.refresh()
				  end)
				end
			  end)
			end, function()
				DeleteSkinCam()
			end)
		end)
	end)
end

function OpenMenuCreatePed(submitCb, cancelCb, restrict)
	local playerPed = PlayerPedId()

	TriggerEvent('skinchanger:getSkin', function(skin)
		LastSkin = skin

		TriggerEvent('skinchanger:getData2', function(components, maxVals)
			local elements    = {}
			local _components = {}

			-- Restrict menu
			if restrict == nil then
				for i=1, #components, 1 do
					_components[i] = components[i]
				end
			else
				for i=1, #components, 1 do
					local found = false

					for j=1, #restrict, 1 do
						if components[i].name == restrict[j] then
							found = true
						end
					end

					if found then
						table.insert(_components, components[i])
					end
				end
			end

			-- Insert elements
			for i=1, #_components, 1 do
				local value       = _components[i].value
				local componentId = _components[i].componentId

				if componentId == 0 then
					value = GetPedPropIndex(playerPed, _components[i].componentId)
				end

				local data = {
					label     = _components[i].label,
					name      = _components[i].name,
					value     = value,
					min       = _components[i].min,
					restrict  = (skin.sex == 0 and _components[i].restrictMale or _components[i].restrictFemale),
					textureof = _components[i].textureof,
					zoomOffset= _components[i].zoomOffset,
					camOffset = _components[i].camOffset,
					type      = 'slider'
				}

				for k,v in pairs(maxVals) do
					if k == _components[i].name then
						data.max = v
						break
					end
				end

				table.insert(elements, data)
			end

			CreateSkinCam()
			zoomOffset = _components[1].zoomOffset
			camOffset = _components[1].camOffset

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'skin', {
				title = _U('skin_menu'),
				align = 'bottom-right',
				elements = elements
			}, function(data, menu)
				menu.close()
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'skin_confirm', {
					title    = 'Czy na pewno chcesz zapisać zmiany?',
					align    = 'center',
					elements = {
						{ label = 'Tak', value = true },
						{ label = 'Nie', value = false }
					},
				}, function(data2, menu2)
					menu2.close()
					if data2.current.value then
						TriggerEvent('skinchanger:getSkin', function(skin)
							LastSkin = skin
						end)
						TriggerEvent("csskrouble:save")
						DeleteSkinCam()
						if submitCb ~= nil then
							submitCb(data, menu)
						end
					else
						CreateSkinCam()
						menu.open()
					end
				end, function(data2, menu2)
					menu2.close()
					CreateSkinCam()
					menu.open()
				end)
			end,
			function(data, menu)
				menu.close()
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'skin_confirm', {
					title    = 'Czy na pewno chcesz wyjść bez zapisywania zmian?',
					align    = 'center',
					elements = {
						{ label = 'Tak', value = true },
						{ label = 'Nie', value = false }
					},
				}, function(data2, menu2)
					menu2.close()
					if data2.current.value then
						TriggerEvent('skinchanger:loadSkin', LastSkin)

						DeleteSkinCam()
						if cancelCb ~= nil then
							cancelCb(data, menu)
						end
					else
						CreateSkinCam()
						menu.open()
					end
				end, function(data2, menu2)
					menu2.close()
					CreateSkinCam()
					menu.open()
				end)
			end,
			function(data, menu)
			  TriggerEvent('skinchanger:getSkin', function(skin)
				zoomOffset = data.current.zoomOffset
				camOffset = data.current.camOffset
				if skin[data.current.name] ~= data.current.value then
				  -- Change skin element
				  TriggerEvent('skinchanger:change', data.current.name, data.current.value)

				  -- Update max values
				  TriggerEvent('skinchanger:getData2', function(components, maxVals)
					for i=1, #elements, 1 do
					  local newData = {}

					  newData.max = maxVals[elements[i].name]
					  if elements[i].textureof ~= nil and data.current.name == elements[i].textureof then
						newData.value = 0
					  end

					  menu.update({name = elements[i].name}, newData)
					end

					menu.refresh()
				  end)
				end
			  end)
			end, function()
				DeleteSkinCam()
			end)
		end)
	end)
end

function CreateSkinCam()
	if not DoesCamExist(cam) then
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	end

	SetCamActive(cam, true)
	RenderScriptCams(true, true, 500, true, true)

	isCameraActive = true
	SetCamRot(cam, 0.0, 0.0, 270.0, true)
	SetEntityHeading(playerPed, 90.0)
end

function DeleteSkinCam()
	isCameraActive = false
	SetCamActive(cam, false)
	RenderScriptCams(false, true, 500, true, true)
	cam = nil
end

CreateThread(function()
	while true do
		Citizen.Wait(0)

		if isCameraActive then
			DisableControlAction(2, 30, true)
			DisableControlAction(2, 31, true)
			DisableControlAction(2, 32, true)
			DisableControlAction(2, 33, true)
			DisableControlAction(2, 34, true)
			DisableControlAction(2, 35, true)
			DisableControlAction(0, 25, true) -- Input Aim
			DisableControlAction(0, 24, true) -- Input Attack

			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)

			local angle = heading * math.pi / 180.0
			
			local theta = {
				x = math.cos(angle),
				y = math.sin(angle)
			}

			local pos = {
				x = coords.x + ((zoomOffset + offset) * theta.x),
				y = coords.y + ((zoomOffset + offset) * theta.y)
			}

			local angleToLook = heading - 140.0
			if angleToLook > 360 then
				angleToLook = angleToLook - 360
			elseif angleToLook < 0 then
				angleToLook = angleToLook + 360
			end

			angleToLook = angleToLook * math.pi / 180.0
			local thetaToLook = {
				x = math.cos(angleToLook),
				y = math.sin(angleToLook)
			}

			local posToLook = {
				x = coords.x + ((zoomOffset + offset) * thetaToLook.x),
				y = coords.y + ((zoomOffset + offset) * thetaToLook.y)
			}			

			SetCamCoord(cam, pos.x, pos.y, coords.z + camOffset)
			PointCamAtCoord(cam, posToLook.x, posToLook.y, coords.z + camOffset)

			ESX.ShowHelpNotification(_U('use_rotate_view'))
		else
			Citizen.Wait(500)
		end
	end
end)

CreateThread(function()
	local angle = 90
	local offsett = 0.0
	
	while true do
		Citizen.Wait(0)

		if isCameraActive then
			if IsDisabledControlPressed(0, 34) then
				angle = angle - 2
			elseif IsDisabledControlPressed(0, 35) then
				angle = angle + 2
			end
			
			if IsDisabledControlPressed(0, 32) then
				offsett = offsett + 0.05
			elseif IsDisabledControlPressed(0, 33) then
				offsett = offsett - 0.05
			end

			if angle > 360 then
				angle = angle - 360
			elseif angle < 0 then
				angle = angle + 360
			end
			
			if offsett > 1.5 then
				offsett = 1.5
			elseif offsett < 0 then
				offsett = 0
			end
			
			heading = angle + 0.0
			offset = offsett + 0.0
		else
			Citizen.Wait(500)
		end
	end
end)

function OpenSaveableMenu(submitCb, cancelCb, restrict)
	TriggerEvent('skinchanger:getSkin', function(skin)
		LastSkin = skin
	end)

	OpenMenu(function(data, menu)
		menu.close()
		DeleteSkinCam()

		TriggerEvent('skinchanger:getSkin', function(skin)
			TriggerServerEvent('esx_skin:save', skin)
			TriggerEvent('esx_ciuchy:wear')
			if submitCb ~= nil then
				submitCb(data, menu)
			end
		end)

	end, cancelCb, restrict)
end

function OpenSaveableMenuCreate(submitCb, cancelCb, restrict)
	TriggerEvent('skinchanger:getSkin', function(skin)
		LastSkin = skin
	end)

	OpenMenuCreate(function(data, menu)
		menu.close()
		DeleteSkinCam()

		TriggerEvent('skinchanger:getSkin', function(skin)
			TriggerServerEvent('esx_skin:save', skin)
			TriggerEvent('esx_ciuchy:wear')
			if submitCb ~= nil then
				submitCb(data, menu)
			end
		end)

	end, cancelCb, restrict)
end

function OpenSaveableMenuCreatePed(submitCb, cancelCb, restrict)
	TriggerEvent('skinchanger:getSkin', function(skin)
		LastSkin = skin
	end)

	OpenMenuCreatePed(function(data, menu)
		menu.close()
		DeleteSkinCam()

		TriggerEvent('skinchanger:getSkin', function(skin)
			TriggerServerEvent('esx_skin:save', skin)
			TriggerEvent('esx_ciuchy:wear')
			if submitCb ~= nil then
				submitCb(data, menu)
			end
		end)

	end, cancelCb, restrict)
end

AddEventHandler('skinchanger:save', function(cbs)
    TriggerEvent('skinchanger:getSkin', function(skin)
		TriggerServerEvent('esx_skin:save', skin)
		TriggerEvent('esx_ciuchy:wear')
		if cbs ~= nil then
			cbs()
		end
    end)
end)

AddEventHandler('esx:onPlayerSpawn', function()
	CreateThread(function()
		while not PlayerLoaded do
			Citizen.Wait(100)
		end
	
		if FirstSpawn then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin == nil then
					TriggerEvent('misiaczek:newplayer')
				elseif skin == 'null' then
					CreateThread(function()
						local status = 0
						while true do
							if status == 0 then
								status = 1
								TriggerEvent('misiaczek:load', function(result)
									if result == 3 then
										status = 2
									else
										status = 0
									end
								end)
							end

							Citizen.Wait(200)
							if status == 2 then
								break
							end
						end

						Citizen.Wait(2000)
						TriggerEvent('esx_skin:openSaveableRestrictedMenuCreate', FinishRegister, FinishRegister, {
						'sex',
						'skin',
						'skin_2',
						'blend_skin',
						'face',
						'face_2',
						'blend_face',
						'skin_3',
						'face_3',
						'blend',
						'eye_color',
						'nose_1',
						'nose_2',
						'nose_3',
						'nose_4',
						'nose_5',
						'nose_6',
						'eyebrow_1',
						'eyebrow_2',
						'cheeks_1',
						'cheeks_2',
						'cheeks_3',
						'lips',
						'jaw_1',
						'jaw_2',
						'chimp_1',
						'chimp_2',
						'chimp_3',
						'chimp_4',
						'neck',
						'age_1',
						'age_2',
						'sun_1',
						'sun_2',
						'moles_1',
						'moles_2',
						'complexion_1',
						'complexion_2',
						'blemishes_1',
						'blemishes_2',
						'hair_1',
						'hair_2',
						'hair_3',
						'hair_color_1',
						'hair_color_2',
						'eyebrows_1',
						'eyebrows_2',
						'eyebrows_3',
						'eyebrows_4',
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
						'beard_1',
						'beard_2',
						'beard_3',
						'beard_4',
						'chest_1',
						'chest_2',
						'chest_3',
						'bodyb_1',
						'bodyb_2',
						'tshirt_1',
						'tshirt_2',
						'torso_1',
						'torso_2',
						'decals_1',
						'decals_2',
						'arms',
						'arms_2',
						'pants_1',
						'pants_2',
						'shoes_1',
						'shoes_2',
						'chain_1',
						'chain_2',
						'glasses_1',
						'glasses_2',
						'helmet_1',
						'helmet_2',
						'bags_1',
						'bags_2'
						})				
					end)					
				else
					TriggerEvent('skinchanger:loadSkin', skin)
					TriggerEvent('esx_ciuchy:wear')
				end
			end)
			
			FirstSpawn = false
		end
	end)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerLoaded = true
end)

AddEventHandler('esx_skin:getLastSkin', function(cb)
	cb(LastSkin)
end)

AddEventHandler('esx_skin:setLastSkin', function(skin)
	LastSkin = skin
end)

RegisterNetEvent('esx_skin:openMenu')
AddEventHandler('esx_skin:openMenu', function(submitCb, cancelCb)
	OpenMenu(submitCb, cancelCb, nil)
end)

RegisterNetEvent('esx_skin:openRestrictedMenu')
AddEventHandler('esx_skin:openRestrictedMenu', function(submitCb, cancelCb, restrict)
	OpenMenu(submitCb, cancelCb, restrict)
end)

RegisterNetEvent('esx_skin:openSaveableMenu')
AddEventHandler('esx_skin:openSaveableMenu', function(submitCb, cancelCb)
	OpenSaveableMenu(submitCb, cancelCb, nil)
end)

RegisterNetEvent('esx_skin:openSaveableMenuPed')
AddEventHandler('esx_skin:openSaveableMenuPed', function(submitCb, cancelCb)
	OpenSaveableMenuCreatePed(submitCb, cancelCb, {'sex'})
end)

RegisterNetEvent('esx_skin:openSaveableRestrictedMenu')
AddEventHandler('esx_skin:openSaveableRestrictedMenu', function(submitCb, cancelCb, restrict)
	OpenSaveableMenu(submitCb, cancelCb, restrict)
end)

RegisterNetEvent('esx_skin:openSaveableRestrictedMenuCreate')
AddEventHandler('esx_skin:openSaveableRestrictedMenuCreate', function(submitCb, cancelCb, restrict)
	OpenSaveableMenuCreate(submitCb, cancelCb, restrict)
end)

RegisterNetEvent('esx_skin:makeup')
AddEventHandler('esx_skin:makeup', function()

end)

RegisterNetEvent('esx_skin:requestSaveSkin')
AddEventHandler('esx_skin:requestSaveSkin', function()
	TriggerEvent('skinchanger:getSkin', function(skin)
		TriggerServerEvent('esx_skin:responseSatestveSkin', skin)
	end)
end)
