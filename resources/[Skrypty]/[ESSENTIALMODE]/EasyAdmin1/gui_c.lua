SlapAmount = {}
for i = 1, 10 do
	table.insert(SlapAmount, i)
end

function handleOrientation(orientation)
	if orientation == "right" then
		return 1320
	elseif orientation == "middle" then
		return 730
	elseif orientation == "left" then
		--
	end

	return 0
end

_menuPool = nil
mainMenu = nil
menuWidth = 0
menuOrientation = handleOrientation("right")
isVisible = false
drawTarget = 0
drawInfo = false
drawCoords = false
debugg = false
drawCustom = nil
fastRun = false
fastSwim = false
superJump = false
moveToBlip = false
noClip = false
noClipSpeed = 1
noClipLabel = nil
pedal = false

CreateThread(function()
	while not hasSpawned do
		Citizen.Wait(100)
	end

	Citizen.Wait(2000)
	if not GetResourceKvpString("ea_menuorientation") then
		SetResourceKvp("ea_menuorientation", "right")
		SetResourceKvpInt("ea_menuwidth", 0)
	else
		menuWidth, menuOrientation = GetResourceKvpInt("ea_menuwidth"), handleOrientation(GetResourceKvpString("ea_menuorientation"))
	end

	while true do
		Citizen.Wait(1)
		if _menuPool then
			if _menuPool:IsAnyMenuOpen() then
				_menuPool:ProcessMenus()
				isVisible = true
			elseif isVisible then
				GarbageCollector()
			end
		else
			Citizen.Wait(250)
		end
	end
end)

function genTxt() 
	txd = CreateRuntimeTxd("easyadmin")
	CreateRuntimeTextureFromImage(txd, 'logo', 'dependencies/img/exile2.png')
	CreateRuntimeTextureFromImage(txd, 'banner', 'dependencies/img/exile1.png')
end

RegisterCommand('eacos', function()
	if _menuPool and _menuPool:IsAnyMenuOpen() then
		GarbageCollector()
	elseif isAdmin then
		GenerateMenu(true)
		mainMenu:Visible(true)
		isVisible = true
	end
end)

RegisterKeyMapping('eacos', 'Włącz/wyłącz EasyAdmin', 'keyboard', 'F10')

function GarbageCollector()
	_menuPool:CloseAllMenus()
	_menuPool:Remove()
	_menuPool = nil

	mainMenu = nil
	collectgarbage()
	isVisible = false
end

function DrawPlayerInfo(target, custom)
	drawTarget = target

	local ply = GetPlayerFromServerId(drawTarget)
	if ply and ply ~= -1 then
		TriggerEvent('EasyAdmin:spectate', GetPlayerPed(ply))
	end

	drawInfo = true
	if custom then
		drawCustom = custom
	end
end

function StopDrawPlayerInfo(cb)
	if not drawInfo then
		return
	end

	drawInfo = false
	drawTarget = 0

	TriggerEvent('EasyAdmin:spectate', nil)
	if drawCustom then
		RequestCollisionAtCoord(drawCustom.coords.x, drawCustom.coords.y, drawCustom.coords.z)
		local ped = PlayerPedId()

		SetEntityCoords(ped, drawCustom.coords.x, drawCustom.coords.y, drawCustom.coords.z, 0, 0, GetEntityHeading(ped), false)
		CreateThread(function()
			FreezeEntityPosition(ped, false)
			if drawCustom.invisible then
				SetEntityVisible(ped, true)
			end

			if drawCustom.vehicle and drawCustom.vehicle ~= 0 then
				local id, timeout = nil, 30
				repeat
					Citizen.Wait(100)
					id = NetToVeh(drawCustom.vehicle)
					timeout = timeout - 1
				until DoesEntityExist(id) or timeout == 0

				if DoesEntityExist(id) and AreAnyVehicleSeatsFree(id) then
					local tick = 20
					repeat
						TaskWarpPedIntoVehicle(ped, id, -2)
						tick = tick - 1
						Citizen.Wait(50)
					until IsPedInAnyVehicle(ped, false) or tick == 0
				end

				ShowNotification({type = 'info', text = '~r~Przestałeś/aś spectować'})
				cb()
			else
				Citizen.Wait(1000)
				ShowNotification({type = 'info', text = '~r~Przestałeś/aś spectować'})
				cb()
			end

			drawCustom = nil
		end)
	else
		RequestCollisionAtCoord(table.unpack(GetEntityCoords(PlayerPedId(), false)))
		cb()
	end
end

function sortowanie(s)

	local t = {}
	for k,v in pairs(s) do
		table.insert(t, v)
	end
	
	table.sort(t, function(a, b)
		if a.id ~= b.id then
			return a.id < b.id
		end
	end)
	
	return t
end

local announcestring = false

RegisterNetEvent("csskrouble:rzadowyCalled", function(admin)
	announcestring = 'Administrator: ~b~'..admin..'~s~ zaprasza Cię na kanał pomocy'
	PlaySoundFrontend(-1, "DELETE", "HUD_DEATHMATCH_SOUNDSET", 1)
	Citizen.Wait(10000)
	announcestring = false
end)

function Initialize(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
	PushScaleformMovieFunctionParameterString("~r~Administrator Cię woła")
    PushScaleformMovieFunctionParameterString(announcestring)
    PopScaleformMovieFunctionVoid()
    return scaleform
end

CreateThread(function()
	while true do
		Citizen.Wait(2)
		if announcestring then
			scaleform = Initialize("mp_big_message_freemode")
			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
		else
			Citizen.Wait(500)
		end
	end
end)

function GenerateMenu(fresh)
	genTxt()
	if not fresh then
		GarbageCollector()
	end

	_menuPool = NativeUI.CreatePool()
	mainMenu = NativeUI.CreateMenu("", "~b~ExileRP", menuOrientation, 0, "easyadmin", "banner", "logo")
	_menuPool:Add(mainMenu)
	mainMenu:SetMenuWidthOffset(menuWidth)

	local myPid = PlayerId()
	local mySid = GetPlayerServerId(myPid)
	if permissions.kick or permissions.crash or permissions.ban or permissions.spectate or permissions.teleport or permissions.slap or permissions.freeze then
		local playermanagement = _menuPool:AddSubMenu(mainMenu, 'Zarządzanie graczami',"", true)
		playermanagement:SetMenuWidthOffset(menuWidth)

		playerMenus = {}
		local userSearch = NativeUI.CreateItem("Wyszukaj gracza", "Wyszukaj po ID")
		playermanagement:AddItem(userSearch)
		userSearch.Activated = function(ParentMenu, SelectedItem)
			DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 6)
	
			while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
				Citizen.Wait( 0 )
			end
	
			local result = GetOnscreenKeyboardResult()
	
			if result and result ~= "" then
				local found = false
				local foundbyid = playerMenus[result] or false
				local temp = {}
				if foundbyid then
					found = true
					table.insert(temp, {id = foundbyid.id, name = foundbyid.name, menu = foundbyid.menu})
				end
				for i,v in ipairs(playerMenus) do
					if string.find(v.name, result) then
						found = true
						table.insert(temp, {id = v.id, name = v.name, admin = v.admin, menu = v.menu})
					end
				end
	
				if found and (#temp > 1) then
					local searchsubtitle = "Znaleziono "..tostring(#temp).." wyników"
					local resultMenu = NativeUI.CreateMenu("Wyniki wyszukiwania", searchsubtitle, menuOrientation, 0)
					_menuPool:Add(resultMenu)
					_menuPool:ControlDisablingEnabled(false)
					_menuPool:MouseControlsEnabled(false)
	
					for i,thePlayer in ipairs(temp) do
						local thisItem = NativeUI.CreateItem("["..thePlayer.id.."] "..thePlayer.name, "")
						resultMenu:AddItem(thisItem)
						thisItem.Activated = function(ParentMenu, SelectedItem)
							_menuPool:CloseAllMenus()
							Citizen.Wait(300)
							local thisMenu = thePlayer.menu
							thisMenu:Visible(true)
						end
					end
					_menuPool:CloseAllMenus()
					Citizen.Wait(300)
					resultMenu:Visible(true)
					return
				end
				if found and (#temp == 1) then
					local thisMenu = temp[1].menu
					_menuPool:CloseAllMenus()
					Citizen.Wait(300)
					thisMenu:Visible(true)
					return
				end
				ShowNotification("~r~Nie znaleziono takiego gracza!")
			end
		end
		ESX.TriggerServerCallback('EasyAdmin:players', function(players)
			for _, data in ipairs(players) do
				thisPlayer = _menuPool:AddSubMenu(playermanagement, "["..data.id.."] "..data.name,"",true)
				thisPlayer:SetMenuWidthOffset(menuWidth)
				playerMenus[tostring(data.id)] = {menu = thisPlayer, name = data.name, id = data.id, admin = data.admin }
				
				if permissions.kick then
					local thisKickMenu = _menuPool:AddSubMenu(thisPlayer, "Wyrzuć Gracza","",true)
					thisKickMenu:SetMenuWidthOffset(menuWidth)
					
					local thisItem = NativeUI.CreateItem('Powód','Dodaj powód wyrzucenia')
					thisKickMenu:AddItem(thisItem)
					KickReason = 'Nie określono przyczyny'
					thisItem:RightLabel(KickReason)
					thisItem.Activated = function(ParentMenu,SelectedItem)				
						TriggerEvent('misiaczek:keyboard', function(value)
							if value then
								KickReason = value
								thisItem:RightLabel(value)
							else
								KickReason = 'Nie określono przyczyny'
							end
						end, {
							limit = 60,
							type = 'textarea',
							title = 'Wprowadź wiadomość (maks. 60 znaków)'
						})
					end
					
					local thisItem = NativeUI.CreateItem('Potwierdź wyrzucenie', '~r~~h~UWAGA:~h~~w~ Naciśnięcie potwierdź spowoduje kopnięcie tego Gracza z określonymi ustawieniami')
					thisKickMenu:AddItem(thisItem)
					thisItem.Activated = function(ParentMenu,SelectedItem)
						if KickReason == "" then
							KickReason = 'Nie określono przyczyny'
						end
						
						TriggerServerEvent("EasyAdmin:kickPlayer", data.id, KickReason)
						BanTime = 1
						BanReason = ""
						
						GenerateMenu(false)
						playermanagement:Visible(true)
					end	
				end
				
				if permissions.ban then
					local thisBanMenu = _menuPool:AddSubMenu(thisPlayer, 'Zablokuj Gracza',"",true)
					thisBanMenu:SetMenuWidthOffset(menuWidth)
					
					local thisItem = NativeUI.CreateItem('Powód', 'Dodaj powód blokady')
					thisBanMenu:AddItem(thisItem)
					BanReason = 'Nie określono przyczyny'
					thisItem:RightLabel(BanReason)
					thisItem.Activated = function(ParentMenu,SelectedItem)				
						TriggerEvent('misiaczek:keyboard', function(value)
							if value then
								BanReason = value
								thisItem:RightLabel(value)
							else
								BanReason = 'Nie określono przyczyny'
							end
						end, {
							limit = 60,
							type = 'textarea',
							title = 'Wprowadź wiadomość (maks. 60 znaków)'
						})
					end
					
					local thisItem = NativeUI.CreateItem('Długość bana', 'Do kiedy powinien zostać zbanowany Gracz?')
					thisBanMenu:AddItem(thisItem)
					local BanTime = '1'
					
					thisItem:RightLabel(BanTime)
					thisItem.Activated = function(ParentMenu,SelectedItem)				
						TriggerEvent('misiaczek:keyboard', function(value)
							if value then
								BanTime = value
								thisItem:RightLabel(value)
							else
								BanTime = '1'
							end
						end, {
							limit = 60,
							type = 'textarea',
							title = 'Wprowadź wiadomość (maks. 60 znaków)'
						})
					end
				
					local thisItem = NativeUI.CreateItem('Potwierdź bana', '~r~~h~UWAGA:~h~~w~ Naciśnięcie potwierdź spowoduje zablokowanie tego gracza z określonymi ustawieniami')
					thisBanMenu:AddItem(thisItem)
					thisItem.Activated = function(ParentMenu,SelectedItem)
						if BanReason == "" then
							BanReason = 'Nie określono przyczyny'
						end
						
						ExecuteCommand('banid '..data.id..' '..BanTime..' '..BanReason)
						
						BanTime = '1'
						BanReason = ""
						GenerateMenu(false)
						playermanagement:Visible(true)
					end	
					
				end
				
				if permissions.spectate then
					local thisItem = NativeUI.CreateItem('Obserwuj gracza', "")
					thisPlayer:AddItem(thisItem)
					thisItem.Activated = function(ParentMenu,SelectedItem)
						if drawInfo then
							NetworkSetInSpectatorMode(false, PlayerPedId())
							StopDrawPlayerInfo(function()
								TriggerServerEvent("EasyAdmin:RequestSpectate", data.id)
							end)
						else
							TriggerServerEvent("EasyAdmin:RequestSpectate", data.id)
						end
					end

					local thisItem = NativeUI.CreateItem('Wezwij gracza', "")
					thisPlayer:AddItem(thisItem)
					thisItem.Activated = function(ParentMenu,SelectedItem)
						TriggerServerEvent("csskrouble:callRzadowy", data.id)
					end
				end
				
				if permissions.teleport then
					local thisItem = NativeUI.CreateItem('Teleport do gracza',"")
					thisPlayer:AddItem(thisItem)
					thisItem.Activated = function(ParentMenu,SelectedItem)
						if drawInfo then
							NetworkSetInSpectatorMode(false, PlayerPedId())
							StopDrawPlayerInfo(function()
								TriggerServerEvent("EasyAdmin:TeleportPlayerToSource", data.id, mySid, true)
							end)
						else
							TriggerServerEvent("EasyAdmin:TeleportPlayerToSource", data.id, mySid, true)
						end
					end
				end
				
				if permissions.teleport then
					local thisItem = NativeUI.CreateItem('Teleportuj gracza do siebie',"")
					thisPlayer:AddItem(thisItem)
					thisItem.Activated = function(ParentMenu,SelectedItem)
						if drawInfo then
							NetworkSetInSpectatorMode(false, PlayerPedId())
							StopDrawPlayerInfo(function()
								TriggerServerEvent("EasyAdmin:TeleportPlayerToSource", mySid, data.id, false)
							end)						
						else
							TriggerServerEvent("EasyAdmin:TeleportPlayerToSource", mySid, data.id, false)
						end
					end
				end
				
				if permissions.slap then
					local thisItem = NativeUI.CreateSliderItem('Zabij gracza', SlapAmount, 5, false, false)
					thisPlayer:AddItem(thisItem)
					thisItem.OnSliderSelected = function(index)
						TriggerServerEvent("EasyAdmin:SlapPlayer", data.id, index*10)
					end
				end
				
				if permissions.freeze then
					local thisItem = NativeUI.CreateCheckboxItem('Unieruchom gracza', false, "")
					thisPlayer:AddItem(thisItem)
					thisItem.CheckboxEvent = function(sender, item, status)
						if item == thisItem then
							TriggerServerEvent("EasyAdmin:FreezePlayer", data.id, status)
						end
					end
				end
				
				_menuPool:RefreshIndex()
				_menuPool:ControlDisablingEnabled(false)
				_menuPool:MouseControlsEnabled(false)
			end
		end, true)
	end
		
	local myPed = PlayerPedId()
	if permissions.vehicles and IsPedInAnyVehicle(myPed, false) then
		local vehicle = GetVehiclePedIsIn(myPed, false)

		local vehiclemanagement = _menuPool:AddSubMenu(mainMenu, "Pojazd","",true)
		vehiclemanagement:SetMenuWidthOffset(menuWidth)

		local thisItem = NativeUI.CreateItem("Naprawa silnika", "")
		vehiclemanagement:AddItem(thisItem)
		thisItem.Activated = function(ParentMenu,SelectedItem)
			local first = true
			while first or not GetIsVehicleEngineRunning(vehicle) do
				SetVehicleEngineHealth(vehicle, 1000.0)
				SetVehicleUndriveable(vehicle, false)

				SetVehicleEngineOn(vehicle, true, true)
				first = false
				Citizen.Wait(0)
			end
			TriggerServerEvent('exile_logs:triggerLog', "Naprawił silnik przez F10", 'fixcar')
			--[[TriggerEvent('chat:addMessage', {
				templateId="print",
				args = { "EasyAdmin: Zrobione!" }
			})]]
			TriggerEvent('chat:addMessage1',"EASYADMIN", {255, 0, 0}, "Wykonano!", "fas fa-bell")
		end	
		
		thisItem = NativeUI.CreateItem("Naprawa karoseria", "")
		vehiclemanagement:AddItem(thisItem)
		thisItem.Activated = function(ParentMenu,SelectedItem)
			SetVehicleBodyHealth(vehicle, 1000.0)
			SetVehicleDeformationFixed(vehicle)
			SetVehicleFixed(vehicle)

			TriggerServerEvent('exile_logs:triggerLog', "Naprawił karoserie przez F10", 'fixcar2')
			--[[TriggerEvent('chat:addMessage', {
				templateId="print",
				args = { "EasyAdmin: Zrobione!" }
			})]]
			TriggerEvent('chat:addMessage1',"EASYADMIN", {255, 0, 0}, "Wykonano!", "fas fa-bell")
		end

		thisItem = NativeUI.CreateItem("Mycie", "")
		vehiclemanagement:AddItem(thisItem)
		thisItem.Activated = function(ParentMenu,SelectedItem)
			WashDecalsFromVehicle(vehicle, 1.0)
			SetVehicleDirtLevel(vehicle)

			--[[TriggerEvent('chat:addMessage', {
				templateId="print",
				args = { "EasyAdmin: Zrobione!" }
			})]]
			TriggerEvent('chat:addMessage1',"EASYADMIN", {255, 0, 0}, "Wykonano!", "fas fa-bell")
		end		

		thisItem = NativeUI.CreateItem("Tuning", "")
		vehiclemanagement:AddItem(thisItem)
		thisItem.Activated = function(ParentMenu,SelectedItem)
			_menuPool:CloseAllMenus()
			
			TriggerEvent('LSC:build', vehicle, true, "Tuning", "shopui_title_carmod", function(obj)
				TriggerEvent('LSC:open', 'categories')
				FreezeEntityPosition(vehicle, true)
			end, function()
				FreezeEntityPosition(vehicle, false)
				if isAdmin then
					GenerateMenu(true)
					mainMenu:Visible(true)
					isVisible = true
				end
			end)
			
			--[[TriggerEvent('chat:addMessage', {
				templateId="print",
				args = { "EasyAdmin: Zrobione!" }
			})]]
			TriggerEvent('chat:addMessage1',"EASYADMIN", {255, 0, 0}, "Wykonano!", "fas fa-bell")
		end		

		thisItem = NativeUI.CreateItem("Kluczyki", "")
		vehiclemanagement:AddItem(thisItem)
		thisItem.Activated = function(ParentMenu,SelectedItem)
			TriggerServerEvent('ls:addOwner', GetVehicleNumberPlateText(vehicle, true))
			--[[TriggerEvent("chat:addMessage", { args = { "EasyAdmin: Zrobione!" } })]]
			TriggerEvent('chat:addMessage1',"EASYADMIN", {255, 0, 0}, "Wykonano!", "fas fa-bell")
		end		
	end
	
	settingsMenu = _menuPool:AddSubMenu(mainMenu, 'Ustawienia',"",true)
	settingsMenu:SetMenuWidthOffset(menuWidth)	
	
	local thisItem = NativeUI.CreateCheckboxItem('Show Coords', drawCoords, "")
	settingsMenu:AddItem(thisItem)
	thisItem.CheckboxEvent = function(sender, item, status)
		if item == thisItem then
			drawCoords = status
		end
	end

	local thisItem = NativeUI.CreateCheckboxItem('Skopiuj kordy', false, "")
	settingsMenu:AddItem(thisItem)
	thisItem.CheckboxEvent = function(sender, item, status)
		if item == thisItem then
			local crds = GetEntityCoords(PlayerPedId())
			local str = "x = "..crds[1]..", y = "..crds[2]..", z = "..crds[3]
			SendNUIMessage({type="clipboard",data=str})
			TriggerEvent('chat:addMessage1',"EASYADMIN", {255, 0, 0}, "Wykonano!", "fas fa-bell")
		end
	end
	
	local thisItem = NativeUI.CreateCheckboxItem('Debug', debugg, "")
	settingsMenu:AddItem(thisItem)
	thisItem.CheckboxEvent = function(sender, item, status)
		if item == thisItem then
			debugg = status
		end
	end
	
	local thisi, sl = GetResourceKvpString("ea_menuorientation"), {'Lewa', 'Srodek', 'Prawa'}
	if thisi == "left" then
		thisi = 1
	elseif thisi == "middle" then
		thisi = 2
	elseif thisi == "right" then
		thisi = 3
	else
		thisi = 0
	end
	
	local thisItem = NativeUI.CreateListItem('Orientacja menu', sl, 1, 'Ustaw orientację menu ( Lewa, Prawa lub Środek ) \nWymaga restartu gry')
	settingsMenu:AddItem(thisItem)
	settingsMenu.OnListChange = function(sender, item, index)
		if item == thisItem then
			i = item:IndexToItem(index)
			if i == 'Lewa' then
				SetResourceKvp("ea_menuorientation", "left")
			elseif i == 'Srodek' then
				SetResourceKvp("ea_menuorientation", "middle")
			elseif i == 'Prawa' then
				SetResourceKvp("ea_menuorientation", "right")
			end
		end
	end
	
	sl = {}
	for i = 0, 150, 10 do
		table.insert(sl,i)
	end

	thisi = 0
	for i, a in ipairs(sl) do
		if menuWidth == a then
			thisi = i
		end
	end
	
	local thisItem = NativeUI.CreateSliderItem('Przesunięcie menu', sl, thisi, 'Ustaw Przesunięcie menu\nnWymaga Ponownego otwarcie menu', false)
	settingsMenu:AddItem(thisItem)
	thisItem.OnSliderSelected = function(index)
		i = thisItem:IndexToItem(index)
		SetResourceKvpInt("ea_menuwidth", i)
		menuWidth = i
	end
	thisi = nil
	sl = nil


	local thisItem = NativeUI.CreateItem('Resetuj przesunięcie menu', "")
	settingsMenu:AddItem(thisItem)
	thisItem.Activated = function(ParentMenu,SelectedItem)
		SetResourceKvpInt("ea_menuwidth", 0)
		menuWidth = 0
	end
	
	if permissions.noclip then
		local noclip = _menuPool:AddSubMenu(mainMenu, 'Noclip', "", true)
		noclip:SetMenuWidthOffset(menuWidth)

		noclip:AddInstructionButton({GetControlInstructionalButton(0, 21, 0), "Zmień prędkość"})
		noclip:AddInstructionButton({GetControlInstructionalButton(0, 31, 0), "Do przodu/tyłu"})
		noclip:AddInstructionButton({GetControlInstructionalButton(0, 30, 0), "W lewo/prawo"})
		noclip:AddInstructionButton({GetControlInstructionalButton(0, 44, 0), "Do góry"})
		noclip:AddInstructionButton({GetControlInstructionalButton(0, 38, 0), "W dół"})

		local thisItem = NativeUI.CreateCheckboxItem('NoClipStatus', noClip, "")
		noclip:AddItem(thisItem)
		thisItem.CheckboxEvent = function(sender, item, status)
			if item == thisItem then
				noClip = not noClip
			end
		end
		noClipLabel = NativeUI.CreateItem('Prędkość', "")
		noClipLabel:RightLabel(noClipSpeeds[noClipSpeed])
		noclip:AddItem(noClipLabel)
	end
	--[[if permissions.invincible then
		local thisItem = NativeUI.CreateCheckboxItem('GodMode', pedal, "")
		mainMenu:AddItem(thisItem)

		thisItem.CheckboxEvent = function(sender, item, status)
			if item == thisItem then
				local pid = PlayerPedId()
				pedal = not pedal
			end
		end
	end	]]
	if permissions.invisible then
		local thisItem = NativeUI.CreateCheckboxItem('Niewidzialność', not IsEntityVisible(PlayerPedId()), "")
		mainMenu:AddItem(thisItem)
		thisItem.CheckboxEvent = function(sender, item, status)
			if item == thisItem then
				local pid = PlayerPedId()
				
				SetEntityVisible(pid, not IsEntityVisible(pid))
				TriggerEvent('chat:addMessage1',"EASYADMIN", {255, 0, 0}, "Wykonano!", "fas fa-bell")
			end
		end	
		
		local thisItem = NativeUI.CreateCheckboxItem('Teleport to waypoint', moveToBlip, "")
		mainMenu:AddItem(thisItem)
		thisItem.CheckboxEvent = function(sender, item, status)
			if item == thisItem then
				moveToBlip = not moveToBlip
				TriggerEvent('chat:addMessage1',"EASYADMIN", {255, 0, 0}, "Wykonano!", "fas fa-bell")
				TriggerServerEvent('exile_logs:triggerLog', "Przeteleportował się do markera", 'tpm')
			end
		end	
	end	
	
	_menuPool:RefreshIndex() -- refresh indexes
	_menuPool:ControlDisablingEnabled(false)
	_menuPool:MouseControlsEnabled(false)
end

--[[CreateThread(function()
	while true do
		Citizen.Wait(1)

		if pedal then
			SetEntityInvincible(GetPlayerPed(-1), true)
			SetPlayerInvincible(PlayerId(), true)
			SetPedCanRagdoll(GetPlayerPed(-1), false)
			ClearPedBloodDamage(GetPlayerPed(-1))
			ResetPedVisibleDamage(GetPlayerPed(-1))
			ClearPedLastWeaponDamage(GetPlayerPed(-1))
			SetEntityProofs(GetPlayerPed(-1), true, true, true, true, true, true, true, true)
			SetEntityOnlyDamagedByPlayer(GetPlayerPed(-1), false)
			SetEntityCanBeDamaged(GetPlayerPed(-1), false)
		elseif not pedal then
			SetEntityInvincible(GetPlayerPed(-1), false)
			SetPlayerInvincible(PlayerId(), false)
			SetPedCanRagdoll(GetPlayerPed(-1), true)
			ClearPedLastWeaponDamage(GetPlayerPed(-1))
			SetEntityProofs(GetPlayerPed(-1), false, false, false, false, false, false, false, false)
			SetEntityOnlyDamagedByPlayer(GetPlayerPed(-1), true)
			SetEntityCanBeDamaged(GetPlayerPed(-1), true)
		end
	end
end)]]--


CreateThread(function()
	while true do
		if noClip then
			local noclipEntity = PlayerPedId()
			if IsPedInAnyVehicle(noclipEntity, false) then
				local vehicle = GetVehiclePedIsIn(noclipEntity, false)
				if GetPedInVehicleSeat(vehicle, -1) == noclipEntity then
					noclipEntity = vehicle
				else
					noclipEntity = nil
				end
			end

			FreezeEntityPosition(noclipEntity, true)
			SetEntityInvincible(noclipEntity, true)

			DisableControlAction(0, 31, true)
			DisableControlAction(0, 30, true)
			DisableControlAction(0, 44, true)
			DisableControlAction(0, 38, true)
			DisableControlAction(0, 32, true)
			DisableControlAction(0, 33, true)
			DisableControlAction(0, 34, true)
			DisableControlAction(0, 35, true)

			local yoff = 0.0
			local zoff = 0.0
			if IsControlJustPressed(0, 21) then
				noClipSpeed = noClipSpeed + 1
				if noClipSpeed > #noClipSpeeds then
					noClipSpeed = 1
				end

				if noClipLabel then
					noClipLabel:RightLabel(noClipSpeeds[noClipSpeed])
				end
			end

			if IsDisabledControlPressed(0, 32) then
				yoff = 0.25;
			end

			if IsDisabledControlPressed(0, 33) then
				yoff = -0.25;
			end

			if IsDisabledControlPressed(0, 34) then
				SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) + 2.0)
			end

			if IsDisabledControlPressed(0, 35) then
				SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) - 2.0)
			end

			if IsDisabledControlPressed(0, 44) then
				zoff = 0.1;
			end

			if IsDisabledControlPressed(0, 38) then
				zoff = -0.1;
			end

			local newPos = GetOffsetFromEntityInWorldCoords(noclipEntity, 0.0, yoff * (noClipSpeed + 0.3), zoff * (noClipSpeed + 0.3))

			local heading = GetEntityHeading(noclipEntity)
			SetEntityVelocity(noclipEntity, 0.0, 0.0, 0.0)
			SetEntityRotation(noclipEntity, 0.0, 0.0, 0.0, 0, false)
			SetEntityHeading(noclipEntity, heading)

			SetEntityCollision(noclipEntity, false, false)
			SetEntityCoordsNoOffset(noclipEntity, newPos.x, newPos.y, newPos.z, true, true, true)
			Citizen.Wait(0)

			FreezeEntityPosition(noclipEntity, false)
			SetEntityInvincible(noclipEntity, false)
			SetEntityCollision(noclipEntity, true, true)
		else
			Citizen.Wait(200)
		end
	end
end)

CreateThread(function()
	while true do
		if isAdmin then
			Citizen.Wait(0)

			local playerPed = PlayerPedId()
			local playerId = PlayerId()
			
			if superJump then
				SetSuperJumpThisFrame(playerId)
			end
			
			if moveToBlip then
				local blip = GetFirstBlipInfoId(8)
				if blip ~= 0 then
					if IsPedInAnyVehicle(playerPed, false) then
						local vehicle = GetVehiclePedIsIn(playerPed, false)
						if GetPedInVehicleSeat(vehicle, -1) == playerPed then
							playerPed = vehicle
						else
							playerPed = nil
						end
					end

					local coord = GetBlipCoords(blip)
					local unused, ground = GetGroundZFor_3dCoord(coord.x, coord.y, 99999.0, 0)
					
					if ground == 0 then
						SetEntityCoords(playerPed, coord.x, coord.y, 0)
						
						local tries = 0
						while ground == 0 and tries < 2000 do
							Citizen.Wait(100)
							unused, ground = GetGroundZFor_3dCoord(coord.x, coord.y, 99999.0, 0)
							tries = tries + 1
						end
						
						SetEntityCoordsNoOffset(playerPed, coord.x, coord.y, ground + 2.0, true, true, true)
						RemoveBlip(blip)
					else
						SetEntityCoordsNoOffset(playerPed, coord.x, coord.y, ground + 2.0, true, true, true)
						RemoveBlip(blip)
					end
				end
				
				moveToBlip = false
			end

			if drawInfo then
				-- cheat checks
				local ply = GetPlayerFromServerId(drawTarget)
				local targetPed = GetPlayerPed(ply)
				local targetCoords = GetEntityCoords(targetPed, false)

				local playerCoords = GetEntityCoords(playerPed, false)
				if #(targetCoords - playerCoords) > 250.0 then
					if not drawCustom then
						drawCustom = {
							coords = playerCoords,
							invisible = IsEntityVisible(playerPed)
						}

						drawCustom.coords = vec3(drawCustom.coords.x, drawCustom.coords.y, drawCustom.coords.z - 0.95)
						if IsPedInAnyVehicle(playerPed, false) then
							drawCustom.vehicle = VehToNet(GetVehiclePedIsIn(playerPed, false))
						end

						FreezeEntityPosition(playerPed, true)
						if drawCustom.invisible then
							SetEntityVisible(playerPed, false)
						end
					end

					SetEntityCoords(playerPed, targetCoords.x, targetCoords.y, targetCoords.z - 10.0, 0, 0, GetEntityHeading(playerPed), false)
				end

				local text = {
					string.format('Gracz: '..GetPlayerName(ply))
				}
				if GetPlayerInvincible(ply) then
					table.insert(text,'Godmode: ~y~Tak')
				else
					table.insert(text,'Godmode: ~r~Nie')
				end

				if not CanPedRagdoll(targetPed) and not IsPedInAnyVehicle(targetPed, false) and (GetPedParachuteState(targetPed) == -1 or GetPedParachuteState(targetPed) == 0) and not IsPedInParachuteFreeFall(targetPed) then
					table.insert(text,'Anty-Ragdol: ~y~Tak')
				end

				-- health info
				table.insert(text,"Health: "..GetEntityHealth(targetPed).."/"..GetEntityMaxHealth(targetPed))
				table.insert(text,"Armor: "..GetPedArmour(targetPed))

				table.insert(text,'Naciśnij E, aby wyjść z trybu obserwatora')
				table.insert(text,'Naciśnij M, aby zobaczyć informacje o nim')
				table.insert(text,'Naciśnij U, aby zrobić ss z jego perspektywy')
				for i,theText in pairs(text) do
					SetTextFont(0)
					SetTextProportional(1)
					SetTextScale(0.0, 0.30)
					SetTextDropshadow(0, 0, 0, 0, 255)
					SetTextEdge(1, 0, 0, 0, 255)
					SetTextDropShadow()
					SetTextOutline()
					SetTextEntry("STRING")
					AddTextComponentString(theText)
					EndTextCommandDisplayText(0.3, 0.7+(i/30))
				end
				
				if IsControlJustPressed(0,103) then
					NetworkSetInSpectatorMode(false, playerPed)
					StopDrawPlayerInfo(function()
						ShowNotification({type = 'info', text = '~r~Przestałeś/aś spectować'})
					end)
				elseif IsControlJustPressed(0,174) then
					local sid = GetPlayerServerId(PlayerId())
					ESX.TriggerServerCallback('EasyAdmin:players', function(players)
						local last = #players
						
						for i, player in ipairs(players) do
							if player.id == drawTarget then
								break
							end

							last = i
						end
						
						local t = players[last]
						if t and t.id == sid then
							last = last - 1
							if last == 0 then
								last = #players
							end

							t = players[last]
						end
						
						NetworkSetInSpectatorMode(false, playerPed)
						StopDrawPlayerInfo(function()
							if t then
								TriggerServerEvent("EasyAdmin:RequestSpectate", t.id)
							end
						end)
					end, false)
				elseif IsControlJustPressed(0,175) then
					local sid = GetPlayerServerId(PlayerId())
					ESX.TriggerServerCallback('EasyAdmin:players', function(players)						
						for i, player in ipairs(players) do
							last = i
							if player.id == drawTarget then
								break
							end
						end

						last = last + 1
						if last > #players then
							last = 1
						end

						local t = players[last]
						if t and t.id == sid then
							last = last + 1
							if last > #players then
								last = 1
							end

							t = players[last]
						end

						NetworkSetInSpectatorMode(false, playerPed)
						StopDrawPlayerInfo(function()
							if t then
								TriggerServerEvent("EasyAdmin:RequestSpectate", t.id)
							end
						end)
					end, false)
				elseif IsControlJustPressed(0, 244) then
					OpenAdminActionMenu(drawTarget)
				elseif IsControlJustPressed(0, 303) then
					ScreenShotPlayer(drawTarget)
				end	
			end

			if drawCoords then
				local playerPed = PlayerPedId()
				local x, y, z = table.unpack(GetEntityCoords(playerPed, true))

				local roundx = tonumber(string.format("%.4f", x))
				local roundy = tonumber(string.format("%.4f", y))
				local roundz = tonumber(string.format("%.4f", z - 0.95))

				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.70)
				SetTextDropshadow(1, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString("~r~X:~s~ "..roundx)
				DrawText(0.28, 0.00)

				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.70)
				SetTextDropshadow(1, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString("~r~Y:~s~ "..roundy)
				DrawText(0.44, 0.00)

				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.70)
				SetTextDropshadow(1, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString("~r~Z:~s~ "..roundz)
				DrawText(0.60, 0.00)

				local heading = GetEntityHeading(playerPed)
				local roundh = tonumber(string.format("%.2f", heading))

				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.70)
				SetTextDropshadow(1, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString("~r~Heading:~s~ "..roundh)
				DrawText(0.40, 0.05)

				local speed = GetEntitySpeed(playerPed)
				local rounds = tonumber(string.format("%.2f", speed))

				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.70)
				SetTextDropshadow(1, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString("~r~Speed: ~s~"..rounds)
				DrawText(0.40, 0.90)

				local health = GetEntityHealth(playerPed)

				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.70)
				SetTextDropshadow(1, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString("~r~Health: ~s~"..health)
				DrawText(0.40, 0.85)

				if IsPedInAnyVehicle(playerPed, 1) then
					local veh = GetVehiclePedIsUsing(playerPed)
					local veheng = GetVehicleEngineHealth(veh)
					local vehbody = GetVehicleBodyHealth(veh)

					local vehenground = tonumber(string.format("%.2f", veheng))
					local vehbodround = tonumber(string.format("%.2f", vehbody))

					SetTextFont(0)
					SetTextProportional(1)
					SetTextScale(0.0, 0.70)
					SetTextDropshadow(1, 0, 0, 0, 255)
					SetTextEdge(1, 0, 0, 0, 255)
					SetTextDropShadow()
					SetTextOutline()
					SetTextEntry("STRING")
					AddTextComponentString("~r~Engine Health: ~s~"..vehenground)
					DrawText(0.0, 0.73)

					SetTextFont(0)
					SetTextProportional(1)
					SetTextScale(0.0, 0.70)
					SetTextDropshadow(1, 0, 0, 0, 255)
					SetTextEdge(1, 0, 0, 0, 255)
					SetTextDropShadow()
					SetTextOutline()
					SetTextEntry("STRING")
					AddTextComponentString("~r~Body Health: ~s~"..vehbodround)
					DrawText(0.0, 0.69)
				end
			end
		else
			Citizen.Wait(200)
			if NetworkIsInSpectatorMode(true) then
				local playerPed = PlayerPedId()
				local targetx, targety, targetz = table.unpack(GetEntityCoords(playerPed, false))

				RequestCollisionAtCoord(targetx, targety, targetz)
				Citizen.InvokeNative(0x423DE3854BB50894, false, playerPed)

				TriggerEvent('EasyAdmin:CrashPlayer')
			end
		end
	end
end)



RegisterNetEvent("csskrouble_ea:zrubskrina")
AddEventHandler("csskrouble_ea:zrubskrina", function(name) 
	exports['screenshot-basic']:requestScreenshotUploadImgur(function(status)

	end, function(data)
		local response = json.decode(data)
		
		TriggerServerEvent('EasyAdmin:falszywyPedalJebany', response.data.link, name)
	end)
end)

function ScreenShotPlayer(player)
	TriggerServerEvent("EasyAdmin:jebacDisa", player, GetPlayerName(PlayerId()))
end	

function OpenAdminActionMenu(player)

    ESX.TriggerServerCallback('EasyAdmin:daneInnegoGracza', function(data)
		local elements = {}
		
		if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
			jobLabel = '['..data.job.label .. ' - ' .. data.job.grade_label..']'
		else
			jobLabel = data.job.label
		end

		table.insert(elements, {label = '[JOB] '..jobLabel..'', value = nil})

		if data.hiddenjob.grade_label ~= nil and  data.hiddenjob.grade_label ~= '' then
			hiddenjobLabel = '['..data.hiddenjob.label .. ' - ' .. data.hiddenjob.grade_label..']'
		else
			hiddenjobLabel = data.hiddenjob.label
		end
		
		table.insert(elements, {label = '[HIDDENJOB] '..hiddenjobLabel..'', value = nil})
		
		if data.name ~= nil and data.name ~= '' then
			table.insert(elements, {label = '['..data.name..']', value = nil})
		end
		
		if data.idd ~= nil then			
			table.insert(elements, {
				label = 'ID : ' .. data.idd,
				value = data.name
			})
		end
		
		if data.hex ~= nil then
			table.insert(elements, {label = '['..data.hex..']', value = nil})
		end
		
		table.insert(elements, {
			label      = '[Gotówka] '..data.money .. '$',
			value      = 'money',
		})
		
		table.insert(elements, {
			label      = '[Bank] '.. data.bank .. '$',
			value      = 'bank',
		})
		
		if data.inventory ~= nil then
			for i=1, #data.inventory, 1 do
				if data.inventory[i].count > 0 then
					table.insert(elements, {
						label    = data.inventory[i].label .. " x" .. data.inventory[i].count,
						value    = data.inventory[i].name
					})
				end
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
			title    = 'Informacje',
			align    = 'left',
			elements = elements,
        }, function(data, menu)

        end, function(data, menu)
			menu.close()
        end)

    end, player)
end

--Debug

local inFreeze = false
local lowGrav = false

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0.25, 0.25)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end


function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

function GetVehicle()
    local playerped = Citizen.InvokeNative(0x43A66C31C68491C0, -1)
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstVehicle()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = #(playerCoords - pos)
        if canPedBeUsed(ped) and distance < 30.0 and (distanceFrom == nil or distance < distanceFrom) then
            distanceFrom = distance
            rped = ped
           -- FreezeEntityPosition(ped, inFreeze)
	    	if IsEntityTouchingEntity(Citizen.InvokeNative(0x43A66C31C68491C0, -1), ped) then
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"]+1, "Veh: " .. ped .. " Model: " .. GetEntityModel(ped) .. " IN CONTACT" )
	    	else
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"]+1, "Veh: " .. ped .. " Model: " .. GetEntityModel(ped) .. "" )
	    	end
            if lowGrav then
            	SetEntityCoords(ped,pos["x"],pos["y"],pos["z"]+5.0)
            end
        end
        success, ped = FindNextVehicle(handle)
    until not success
    EndFindVehicle(handle)
    return rped
end

function GetObject()
    local playerped = Citizen.InvokeNative(0x43A66C31C68491C0, -1)
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstObject()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = #(playerCoords - pos)
        if distance < 10.0 then
            distanceFrom = distance
            rped = ped
            --FreezeEntityPosition(ped, inFreeze)
	    	if IsEntityTouchingEntity(Citizen.InvokeNative(0x43A66C31C68491C0, -1), ped) then
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"]+1, "Obj: " .. ped .. " Model: " .. GetEntityModel(ped) .. " IN CONTACT" )
	    	else
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"]+1, "Obj: " .. ped .. " Model: " .. GetEntityModel(ped) .. "" )
	    	end

            if lowGrav then
            	--ActivatePhysics(ped)
            	SetEntityCoords(ped,pos["x"],pos["y"],pos["z"]+0.1)
            	FreezeEntityPosition(ped, false)
            end
        end

        success, ped = FindNextObject(handle)
    until not success
    EndFindObject(handle)
    return rped
end




function getNPC()
    local playerped = Citizen.InvokeNative(0x43A66C31C68491C0, -1)
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = #(playerCoords - pos)
        if canPedBeUsed(ped) and distance < 30.0 and (distanceFrom == nil or distance < distanceFrom) then
            distanceFrom = distance
            rped = ped

	    	if IsEntityTouchingEntity(Citizen.InvokeNative(0x43A66C31C68491C0, -1), ped) then
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"], "Ped: " .. ped .. " Model: " .. GetEntityModel(ped) .. " Relationship HASH: " .. GetPedRelationshipGroupHash(ped) .. " IN CONTACT" )
	    	else
	    		DrawText3Ds(pos["x"],pos["y"],pos["z"], "Ped: " .. ped .. " Model: " .. GetEntityModel(ped) .. " Relationship HASH: " .. GetPedRelationshipGroupHash(ped) )
	    	end

            FreezeEntityPosition(ped, inFreeze)
            if lowGrav then
            	SetPedToRagdoll(ped, 511, 511, 0, 0, 0, 0)
            	SetEntityCoords(ped,pos["x"],pos["y"],pos["z"]+0.1)
            end
        end
        success, ped = FindNextPed(handle)
    until not success
    EndFindPed(handle)
    return rped
end

function canPedBeUsed(ped)
    if ped == nil then
        return false
    end
    if ped == Citizen.InvokeNative(0x43A66C31C68491C0, -1) then
        return false
    end
    if not DoesEntityExist(ped) then
        return false
    end
    return true
end

CreateThread( function()

    while true do 
        
        Citizen.Wait(1)
        
        if debugg then
            local pos = GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, -1))

            local forPos = GetOffsetFromEntityInWorldCoords(Citizen.InvokeNative(0x43A66C31C68491C0, -1), 0, 1.0, 0.0)
            local backPos = GetOffsetFromEntityInWorldCoords(Citizen.InvokeNative(0x43A66C31C68491C0, -1), 0, -1.0, 0.0)
            local LPos = GetOffsetFromEntityInWorldCoords(Citizen.InvokeNative(0x43A66C31C68491C0, -1), 1.0, 0.0, 0.0)
            local RPos = GetOffsetFromEntityInWorldCoords(Citizen.InvokeNative(0x43A66C31C68491C0, -1), -1.0, 0.0, 0.0) 

            local forPos2 = GetOffsetFromEntityInWorldCoords(Citizen.InvokeNative(0x43A66C31C68491C0, -1), 0, 2.0, 0.0)
            local backPos2 = GetOffsetFromEntityInWorldCoords(Citizen.InvokeNative(0x43A66C31C68491C0, -1), 0, -2.0, 0.0)
            local LPos2 = GetOffsetFromEntityInWorldCoords(Citizen.InvokeNative(0x43A66C31C68491C0, -1), 2.0, 0.0, 0.0)
            local RPos2 = GetOffsetFromEntityInWorldCoords(Citizen.InvokeNative(0x43A66C31C68491C0, -1), -2.0, 0.0, 0.0)    

            local x, y, z = table.unpack(GetEntityCoords(Citizen.InvokeNative(0x43A66C31C68491C0, -1), true))
            local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
            currentStreetName = GetStreetNameFromHashKey(currentStreetHash)

            drawTxt(0.8, 0.50, 0.4,0.4,0.30, "Heading: " .. GetEntityHeading(Citizen.InvokeNative(0x43A66C31C68491C0, -1)), 55, 155, 55, 255)
            drawTxt(0.8, 0.52, 0.4,0.4,0.30, "Coords: " .. pos, 55, 155, 55, 255)
            drawTxt(0.8, 0.54, 0.4,0.4,0.30, "Attached Ent: " .. GetEntityAttachedTo(Citizen.InvokeNative(0x43A66C31C68491C0, -1)), 55, 155, 55, 255)
            drawTxt(0.8, 0.56, 0.4,0.4,0.30, "Health: " .. GetEntityHealth(Citizen.InvokeNative(0x43A66C31C68491C0, -1)), 55, 155, 55, 255)
            drawTxt(0.8, 0.58, 0.4,0.4,0.30, "H a G: " .. GetEntityHeightAboveGround(Citizen.InvokeNative(0x43A66C31C68491C0, -1)), 55, 155, 55, 255)
            drawTxt(0.8, 0.60, 0.4,0.4,0.30, "Model: " .. GetEntityModel(Citizen.InvokeNative(0x43A66C31C68491C0, -1)), 55, 155, 55, 255)
            drawTxt(0.8, 0.62, 0.4,0.4,0.30, "Speed: " .. GetEntitySpeed(Citizen.InvokeNative(0x43A66C31C68491C0, -1)), 55, 155, 55, 255)
            drawTxt(0.8, 0.64, 0.4,0.4,0.30, "Frame Time: " .. GetFrameTime(), 55, 155, 55, 255)
            drawTxt(0.8, 0.66, 0.4,0.4,0.30, "Street: " .. currentStreetName, 55, 155, 55, 255)
            
            
            DrawLine(pos,forPos, 255,0,0,115)
            DrawLine(pos,backPos, 255,0,0,115)

            DrawLine(pos,LPos, 255,255,0,115)
            DrawLine(pos,RPos, 255,255,0,115)           

            DrawLine(forPos,forPos2, 255,0,255,115)
            DrawLine(backPos,backPos2, 255,0,255,115)

            DrawLine(LPos,LPos2, 255,255,255,115)
            DrawLine(RPos,RPos2, 255,255,255,115)     

            local nearped = getNPC()

            local veh = GetVehicle()

            local nearobj = GetObject()

            if IsControlJustReleased(0, 38) then
                if inFreeze then
                    inFreeze = false
                    TriggerEvent("DoShortHudText",'Freeze Disabled',3)          
                else
                    inFreeze = true             
                    TriggerEvent("DoShortHudText",'Freeze Enabled',3)               
                end
            end

            if IsControlJustReleased(0, 47) then
                if lowGrav then
                    lowGrav = false
                    TriggerEvent("DoShortHudText",'Low Grav Disabled',3)            
                else
                    lowGrav = true              
                    TriggerEvent("DoShortHudText",'Low Grav Enabled',3)                 
                end
            end

        else
            Citizen.Wait(5000)
        end
    end
end)