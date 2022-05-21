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

local PlayerData                = {}
local GUI                       = {}
local HasAlreadyEnteredMarker   = false
local LastStation               = nil
local LastPart                  = nil
local LastPartNum               = nil
local LastEntity                = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local nurek = false
local drive = false
local fto = false
local pilot = false
local hazmat = false
local IsBusy = false
local CurrentTask = {}
local onService = true
local statusWezwan = '<font color=green>aktywne</font>'
local FirePoint = {}
local onFire = false
ESX                             = nil
GUI.Time                        = 0

CreateThread(function()
  while ESX == nil do
    TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) 
		ESX = obj 
	end)
	
    Citizen.Wait(250)
  end
  
  ESX.TriggerServerCallback('esx_license:checkLicense', function(lickajest)
    if lickajest then
      nurek = true
    else
      nurek = false
    end
  end, GetPlayerServerId(PlayerId()), 'safd_nurek')	
  
  ESX.TriggerServerCallback('esx_license:checkLicense', function(lickajest)
    if lickajest then
      drive = true
    else
      drive = false
    end
  end, GetPlayerServerId(PlayerId()), 'safd_drive')	
  
  ESX.TriggerServerCallback('esx_license:checkLicense', function(lickajest)
    if lickajest then
      fto = true
    else
      fto = false
    end
  end, GetPlayerServerId(PlayerId()), 'safd_fto')
  
  ESX.TriggerServerCallback('esx_license:checkLicense', function(lickajest)
    if lickajest then
      pilot = true
    else
      pilot = false
    end
  end, GetPlayerServerId(PlayerId()), 'safd_pilot')	
  
  ESX.TriggerServerCallback('esx_license:checkLicense', function(lickajest)
    if lickajest then
      hazmat = true
    else
      hazmat = false
    end
  end, GetPlayerServerId(PlayerId()), 'safd_hazmat')	
  
end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

function SetVehicleMaxMods(vehicle)

  local props = {
    modEngine       = 2,
    modBrakes       = 3,
    modTransmission = 2,
    modSuspension   = 2,
    modTurbo        = true,
  }

  ESX.Game.SetVehicleProperties(vehicle, props)

end

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
				Wait(300)
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
			else
				ESX.ShowNotification('Nie działa, zepsute')
			end
		else
			if Config.Uniforms[job].female ~= nil then
				Wait(300)
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
			else
				ESX.ShowNotification('Nie działa, zepsute')
			end
		end
	end)
end


function OpenCloakroomMenu()

	local elements = {
		{label = 'Ubranie Służbowe', value = 'cloakroom'},
		{label = 'Ubrania Prywatne', value = 'player_dressing' },
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'ambulance_actions',
		{
			title		= 'Szatnia SAFD',
			align		= 'center',
			elements	= elements
		},
		function(data, menu)

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
			elseif data.current.value == 'cloakroom' then
				OpenCloakroomMenuDuty()
			end

		end,
	function(data, menu)
		menu.close()

		CurrentAction		= 'menu_cloakroom'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby się przebrać"
		CurrentActionData	= {}
	end)
end


function OpenCloakroomMenuDuty()

	ESX.UI.Menu.CloseAll()
	local playerPed = PlayerPedId()

	local elements = {
		{label = "Zejdź ze służby", value = 'citizen_wear'},
		{label = "Wejdź na służbę", value = 'fire_duty'},
	}

	if PlayerData.job.name == 'fire' then
		table.insert(elements, {label = 'Ubrania Służbowe', value = 'alluniforms'})
	end



	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
	{
		title    = 'Szatnia - SAFD',
		align    = 'center',
		elements = elements
	}, function(data, menu)

		cleanPlayer(playerPed)

		if data.current.value == 'fire_duty' then
			menu.close()
			setUniform('so1', playerPed)
			if PlayerData.job.name == 'offfire' then
				TriggerServerEvent('exile:setJob', 'fire', true)
				ESX.ShowNotification('~b~Wchodzisz na służbę')
			end
		end
		
		if data.current.value == 'citizen_wear' then
			menu.close()
			if PlayerData.job.name == 'fire' then
				ESX.ShowNotification('~b~Schodzisz ze służby')
				TriggerServerEvent('exile:setJob', 'fire', false)
			end
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		end

    if data.current.value == 'alluniforms' then
      local elements2 = {}
if PlayerData.job.grade_name == 'stazysta' then
  table.insert(elements2, {label = 'Stażysta', value = 'koszarowka1'})
elseif PlayerData.job.grade_name == 'starazak' then
  table.insert(elements2, {label = 'Strażak', value = 'koszarowka1'})
elseif PlayerData.job.grade_name == 'seniorstrazak' then
  table.insert(elements2, {label = 'Starszy Strażak', value = 'koszarowka1'})
elseif PlayerData.job.grade_name == 'sekc' then
  table.insert(elements2, {label = 'Sekcyjny', value = 'koszarowka3'})
elseif PlayerData.job.grade_name == 'seniorsekc' then
  table.insert(elements2, {label = 'Starszy Sekcyjny', value = 'koszarowka3'})
elseif PlayerData.job.grade_name == 'ognio' then
  table.insert(elements2, {label = 'Ogniomistrz', value = 'koszarowka3'})
elseif PlayerData.job.grade_name == 'seniorognio' then
  table.insert(elements2, {label = 'Starszy Ogniomistrz', value = 'koszarowka3'})
elseif PlayerData.job.grade_name == 'aspirant' then
  table.insert(elements2, {label = 'Aspirant', value = 'koszarowka3'})
elseif PlayerData.job.grade_name == 'senioraspirant' then
  table.insert(elements2, {label = 'Starszy Aspirant', value = 'koszarowka3'})
elseif PlayerData.job.grade_name == 'kapitan' then
  table.insert(elements2, {label = 'Kapitan', value = 'koszarowka3'})
elseif PlayerData.job.grade_name == 'seniorkapitan' then
  table.insert(elements2, {label = 'Starszy Kapitan', value = 'koszarowka3'})
elseif PlayerData.job.grade_name == 'brygadier' then
  table.insert(elements2, {label = 'Brygadier ', value = 'koszarowka2'})
elseif PlayerData.job.grade_name == 'zastepca' then
  table.insert(elements2, {label = 'Zastępca Dowódcy ', value = 'koszarowka2'})
elseif PlayerData.job.grade_name == 'podboss'then
  table.insert(elements2, {label = 'Asystent Dowódcy ', value = 'koszarowka2'})
elseif PlayerData.job.grade_name == 'boss' then
  table.insert(elements2, {label = 'Dowódca ', value = 'koszarowka2'})
end
table.insert(elements2, {label = 'Nomex', value = 'nomex1'})
table.insert(elements2, {label = 'Nomex z Butlą', value = 'nomexzbutla'})
table.insert(elements2, {label = 'Galowy', value = 'galowy'})

if PlayerData.job.grade >= 1 then
  table.insert(elements2, {label = 'WysokościoweM0nstrum', value = 'wysokosciowy'})
  table.insert(elements2, {label = 'Płetwonurek', value = 'nurek'})
  table.insert(elements2, {label = 'Ratownictwo Wodne', value = 'rwoddne'})
end

ESX.TriggerServerCallback('esx_license:checkLicense', function(lickajest)
  if lickajest then
    table.insert(elements2, {label = 'Stroj Pilot', value = 'pilot'})
  end
end, GetPlayerServerId(PlayerId()), 'safd_pilot')	
ESX.TriggerServerCallback('esx_license:checkLicense', function(lickajest)
  if lickajest then
    table.insert(elements2, {label = 'Stroj Hazmatu', value = 'hazmat'})
  end
end, GetPlayerServerId(PlayerId()), 'safd_hazmat')	
      ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'alluniforms', {
          title    = "Szatnia - SAFD",
          align    = 'right',
          elements = elements2
      }, function(data2, menu2)
          setUniform(data2.current.value, playerPed)
      end, function(data2, menu2)
          menu2.close()
      end)
  end


end, function(data, menu)
  menu.close()
  
  CurrentAction        = 'fire_actions_menu'
  CurrentActionMsg    = "Naciśnij ~INPUT_CONTEXT~, aby się przebrać"
  CurrentActionData    = {}

end)
end


  
function OpenArmoryMenu(station)

    local elements = {
      {label = 'Zabierz przedmiot',  value = 'get_stock'},
      {label = 'Odłóż przedmiot',  value = 'put_stock'},
      {label = 'Pobierz Siekiere', value = 'WEAPON_HATCHET'},
      {label = 'Pobierz Gaśnice', value = 'WEAPON_FIREEXTINGUISHER'},
      {label = 'Pobierz Łom', value = 'WEAPON_CROWBAR'},
      {label = 'Pobierz Apteczke', value = 'medikit'},
      {label = 'Pobierz Bandaże', value = 'bandage'},
      {label = 'Pobierz GPS', value = 'gps'},
      {label = 'Pobierz BodyCam', value = 'bodycam'},
      {label = 'Pobierz Radio', value = 'radio'},
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory',
      {
        title    = 'Schowek - SAFD',
        align    = 'center',
        elements = elements,
      },
      function(data, menu)

    
     
        if data.current.value == 'put_stock' then
          OpenPutStocksMenu()
        
        elseif data.current.value == 'get_stock' then
          OpenGetStocksMenu()
        elseif data.current.value == 'WEAPON_HATCHET' or data.current.value == 'WEAPON_FIREEXTINGUISHER' or data.current.value == 'WEAPON_CROWBAR' then
          TriggerServerEvent(GetCurrentResourceName()..':giveWeapon', data.current.value, 1, GetCurrentResourceName())
        else
          TriggerServerEvent(GetCurrentResourceName()..':giveItem', data.current.value, 20, GetCurrentResourceName())
        end

      end,
      function(data, menu)

        menu.close()

        CurrentAction     = 'menu_armory'
        CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~, aby otworzyć~y~ schowek'
        CurrentActionData = {}
    end)

end

function OpenVehicleSpawnerMenu(station, partNum)


  ESX.UI.Menu.CloseAll()

    local elements = {}

    for i=1, #Config.FireStations[station].AuthorizedVehicles, 1 do
      local vehicle = Config.FireStations[station].AuthorizedVehicles[i]
      if PlayerData.job.grade >= vehicle.grade then
          table.insert(elements, {label = vehicle.label, value = vehicle.name})
      end
    end

    for i=1, #Config.FireStations[station].SpecialVehicles, 1 do
      local vehicle = Config.FireStations[station].SpecialVehicles[i]
      if nurek then
        if vehicle.special == 'nurek' then
         table.insert(elements, {label = vehicle.label, value = vehicle.name, special = vehicle.special})
        end
      end
      if drive then
        if vehicle.special == 'drive' then
          table.insert(elements, {label = vehicle.label, value = vehicle.name, special = vehicle.special})
         end
        end
      if fto then
        if vehicle.special == 'fto' then
          table.insert(elements, {label = vehicle.label, value = vehicle.name, special = vehicle.special})
         end
        end
      if pilot then
        if vehicle.special == 'pilot' then
          table.insert(elements, {label = vehicle.label, value = vehicle.name, special = vehicle.special})
         end
        end
      if hazmat then
        if vehicle.special == 'hazmat' then
          table.insert(elements, {label = vehicle.label, value = vehicle.name, special = vehicle.special})
         end
        end
      
    end


    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'vehicle_spawner',
      {
        title    = 'Garaż - SAFD',
        align    = 'center',
        elements = elements,
      },
      function(data, menu)

        menu.close()
        local vehicles = Config.FireStations[station].Vehicles
        local model = data.current.value
        local vehicle = GetClosestVehicle(vehicles[partNum].SpawnPoint.x,  vehicles[partNum].SpawnPoint.y,  vehicles[partNum].SpawnPoint.z,  3.0,  0,  71)
        if not DoesEntityExist(vehicle) then
          local playerPed = PlayerPedId()
            ESX.Game.SpawnVehicle(model, {
              x = vehicles[partNum].SpawnPoint.x,
              y = vehicles[partNum].SpawnPoint.y,
              z = vehicles[partNum].SpawnPoint.z
            }, vehicles[partNum].Heading, function(vehicle)
              TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
              SetVehicleMaxMods(vehicle)
            end)
        else
          ESX.ShowNotification('Nie znany pojazd')
        end

      end,
      function(data, menu)
        menu.close()
        CurrentAction     = 'menu_vehicle_spawner'
        CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~, aby otworzyć~y~ garaż'
        CurrentActionData = {station = station, partNum = partNum}
      end)
end

function OpenFireActionsMenu()
  if onService then
    statusWezwan = '<font color=green>aktywne</font>'
  else
    statusWezwan = '<font color=red>dezaktywne</font>'
  end
  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'fire_actions',
    {
      title    = 'SAFD',
      align    = 'center',
      elements = {
        {label = 'Interakcje z obywatelem', value = 'citizen_interaction'},
        {label = 'Interakcje z pojazdem', value = 'vehicle_interaction'},
        {label = 'Przyjmowanie wezwań: '..statusWezwan,      value = 'wezwania'},
      },
    },
    function(data, menu)

		if data.current.value == 'citizen_interaction' then
			ESX.TriggerServerCallback("esx_scoreboard:getConnectedCops", function(MisiaczekPlayers)
				if MisiaczekPlayers then
    
					local elements2 = {
						{label = ('Wsadz do pojazdu'), value = 'put_in_vehicle'},
						{label = ('Wyciągnij z pojazdu'), value = 'out_vehicle'},
					}
					
					if MisiaczekPlayers['ambulance'] <= 2 then
						table.insert(elements2, {label = 'Ożyw obywatela', value = 'revive'})
						table.insert(elements2, {label = ('Ulecz obywatela'), value = 'heal'})
					end
					
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
						title    = 'Interakcje z obywatelem',
						align    = 'center',
						elements = elements2
					}, function(data2, menu2)
            if IsBusy then 
              return 
            end
            local player, distance = ESX.Game.GetClosestPlayer()

            if distance ~= -1 and distance <= 3.0 then

          

              if data2.current.value == 'heal' then
                ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
                  if quantity > 0 then
                    local closestPlayerPed = Citizen.InvokeNative(0x43A66C31C68491C0, closestPlayer)
                    local health = GetEntityHealth(closestPlayerPed)
    
                    if health > 0 then
                      local playerPed = PlayerPedId()
    
                      IsBusy = true
                      ESX.ShowNotification('Pomagasz~y~...~s~')
                      TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                      Citizen.Wait(10000)
                      ClearPedTasks(playerPed)
    
                      TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
                      TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'small')
                      ESX.ShowNotification('~g~Uzdrowiono~s~ ', GetPlayerName(closestPlayer))
                      IsBusy = false
                    else
                      ESX.ShowNotification('Obywatel jest nieprzytomny')
                    end
                  else
                    ESX.ShowNotification('Nie posiadasz bandaży')
                  end
                end, 'bandage')
			  end
	
              if data2.current.value == 'revive' then
           
                ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
                  if quantity > 0 then
                    local closestPlayerPed = Citizen.InvokeNative(0x43A66C31C68491C0, closestPlayer)
    
                    if IsPedDeadOrDying(closestPlayerPed, 1) then
                      local playerPed = PlayerPedId()
    
                      IsBusy = true
                      ESX.ShowNotification('Trwa uzdrawianie...')
    
                      local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'
    
                      for i=1, 15, 1 do
                        Citizen.Wait(900)
                    
                        ESX.Streaming.RequestAnimDict(lib, function()
                          TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
                        end)
                      end
    
                      TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
                      TriggerServerEvent('hypex_ambulancejob:hypexrevive', GetPlayerServerId(closestPlayer))
                      IsBusy = false
    
                        ESX.ShowNotification('Uzdrowiono ~y~', GetPlayerName(closestPlayer))

                    else
                      ESX.ShowNotification('Obywatel jest')
                    end
                  else
                    ESX.ShowNotification('Nie posiadasz apteczki')
                  end
                end, 'medikit')
                end
              if data.current.value == 'put_in_vehicle' then
                TriggerServerEvent('xlem0n_policejob:putInVehicle', GetPlayerServerId(closestPlayer))
              end
              if data.current.value == 'out_vehicle' then
                TriggerServerEvent('xlem0n_policejob:OutVehicle', GetPlayerServerId(closestPlayer))
              end
            else
              ESX.ShowNotification('Brak obywateli ~r~w pobliżu~s~')
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )
		
			end
			end)

      end  
      if data.current.value == 'wezwania' then
        if onService then
          onService = false
          menu.close()
          Wait(100)
          OpenFireActionsMenu()
        else
          menu.close()
          onService = true
          Wait(100)
          OpenFireActionsMenu()
        end
      end
      if data.current.value == 'vehicle_interaction' then

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_interaction',
			{
				title		= 'Interakcja z pojazdami',
				align		= 'center',
				elements	= {
					{label = ('Napraw pojazd'), value = 'repair'},
					{label = ('Odblokuj pojazd'), value = 'hijack'},
					{label = ('Odholuj pojazd'), value = 'impound'},
					
				}
			}, function(data, menu)
				local vehicle = nil

        local playerPed = PlayerPedId()
        local coords    = GetEntityCoords(playerPed)
				if IsPedInAnyVehicle(playerPed, false) then
					vehicle = GetVehiclePedIsIn(playerPed, false)
				else
					vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
				end
					
				if not IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
					ESX.ShowNotification('~r~Brak pojazdu w pobliżu')
				else

					if data.current.value == 'repair' then
						if(not IsPedInAnyVehicle(playerPed)) then
							TriggerEvent('esx_mechanicjobdrugi:onFixkitFree')
						end
					elseif data.current.value == 'hijack' then
						if(not IsPedInAnyVehicle(playerPed)) then
              TriggerServerEvent('exile:pay', 1500)
              menu.close()
              TriggerEvent('esx_mechanicjobdrugi:onHijack')
						end
					elseif data.current.value == 'impound' then
            if(not IsPedInAnyVehicle(playerPed)) then
							if CurrentTask.Busy then
								return
							end

							ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~ żeby unieważnić ~y~zajęcie~s~')
							TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)

							CurrentTask.Busy = true
							CurrentTask.Task = ESX.SetTimeout(10000, function()
								ClearPedTasks(playerPed)
								TriggerEvent("esx_impound", 'cos')

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
						end
					end
        end      
          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end

    end,
    function(data, menu)

      menu.close()

    end
  )

end


function OpenGetStocksMenu()

  ESX.TriggerServerCallback('exile_safd:getStockItems', function(items)


    local elements = {}

    for i=1, #items, 1 do
      table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = 'Wyciągnij przedmiot',
        align = 'center',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
          {
            title = 'Ilość'
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification('~r~Niepoprawna ~s~ilość')
            else
              menu2.close()
              menu.close()
            

              TriggerServerEvent('exile_safd:getStockItem', itemName, count, GetCurrentResourceName())
              Wait(100)
              OpenGetStocksMenu()
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenPutStocksMenu()

  ESX.TriggerServerCallback('exile_safd:getPlayerInventory', function(inventory)

    local elements = {}

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

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'stocks_menu',
      {
        title    = 'Ekwpipunek',
        align = 'center',
        elements = elements
      },
      function(data, menu)

        local itemName = data.current.value

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
          {
            title = 'Ilość'
          },
          function(data2, menu2)

            local count = tonumber(data2.value)

            if count == nil then
              ESX.ShowNotification('~r~Niepoprawna~s~ ilość')
            else
              menu2.close()
              menu.close()
              
           

              TriggerServerEvent('exile_safd:putStockItems', itemName, count, GetCurrentResourceName())
               Wait(100)
              OpenPutStocksMenu()
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenHeliMenu(zoneNumber)
	ESX.UI.Menu.CloseAll()
  local elements = {
    {label = 'Helikopter', value = 'polmav'}
  }
	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'heli_spawner',
	{
		title		= "Helikoptery",
		align		= 'center',
		elements	= elements
	}, function(data, menu)
		menu.close()
		ESX.Game.SpawnVehicle(data.current.value, Config.Heli.spawn ,Config.Heli.heading, function(vehicle)
			local playerPed = PlayerPedId()
			local plate = "SAFD " .. math.random(100,999)
			SetVehicleNumberPlateText(vehicle, plate)
			local localVehPlate = GetVehicleNumberPlateText(vehicle)
			TriggerEvent('ls:dodajklucze2', localVehPlate)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		end)
	end, function(data, menu)
		menu.close()
		CurrentAction		= 'helipad'
		CurrentActionMsg	= 'Naciśnij ~INPUT_CONTEXT~ aby wyciągnąć helikopter.'
		CurrentActionData	= {zoneNumber = zoneNumber}
	end
	)
end
AddEventHandler('exile_safd:hasEnteredMarker', function(station, part, partNum)

  if part == 'Cloakroom' then
    CurrentAction     = 'menu_cloakroom'
    CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~, aby się przebrać'
    CurrentActionData = {}
  end

  if part == 'Armory' then
    CurrentAction     = 'menu_armory'
    CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~, aby otworzyć~y~ schowek'
    CurrentActionData = {}
  end

  if part == 'VehicleSpawner' then
    CurrentAction     = 'menu_vehicle_spawner'
    CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~, aby otworzyć~y~ garaż'
    CurrentActionData = {station = station, partNum = partNum}
  end

  if part == 'HelicopterSpawner' then
      CurrentAction		= 'helipad'
      CurrentActionMsg	= 'Naciśnij ~INPUT_CONTEXT~ aby wyciągnąć ~y~helikopter'
      CurrentActionData	= {zoneNumber = zoneNumber}
  end

  if part == 'VehicleDeleter' then

    if IsPedInAnyVehicle(PlayerPedId(),  false) then

      local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

      if DoesEntityExist(vehicle) then
        CurrentAction     = 'delete_vehicle'
        CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~, aby ~r~schować pojazd'
        CurrentActionData = {vehicle = vehicle}
      end

    end

  end

  if part == 'BossActions' then
    CurrentAction     = 'menu_boss_actions'
    CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~, aby ~g~zarządzać frakcją'
    CurrentActionData = {}
  end

end)

AddEventHandler('exile_safd:hasExitedMarker', function(station, part, partNum)
  ESX.UI.Menu.CloseAll()
  CurrentAction = nil
end)

AddEventHandler('exile_safd:hasEnteredEntityZone', function(entity)



  if PlayerData.job ~= nil and PlayerData.job.name == 'fire' then
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
    CurrentAction     = 'remove_entity'
    CurrentActionMsg  = 'remove_object'
    CurrentActionData = {entity = entity}
    end
  end

end)

AddEventHandler('exile_safd:hasExitedEntityZone', function(entity)

  if CurrentAction == 'remove_entity' then
    CurrentAction = nil
  end

end)




CreateThread(function()
  if not HasNamedPtfxAssetLoaded("scr_agencyheistb") then
    RequestNamedPtfxAsset("scr_agencyheistb")
    while not HasNamedPtfxAssetLoaded("scr_agencyheistb") do
      Wait(1)
    end
  end

  if not HasNamedPtfxAssetLoaded("scr_trevor3") then
      RequestNamedPtfxAsset("scr_trevor3")
      while not HasNamedPtfxAssetLoaded("scr_trevor3") do
          Wait(1)
      end
  end
  for k,v in pairs(Config.Blips) do
    local blip = AddBlipForCoord(v.Pos.x, v.Pos.y, v.Pos.z)
    SetBlipSprite (blip, v.Sprite)
    SetBlipDisplay(blip, v.Display)
    SetBlipScale  (blip, v.Scale)
    SetBlipColour (blip, v.Colour)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Komenda SAFD')
    EndTextCommandSetBlipName(blip)
   end
end)


CreateThread(function()
  while true do

    Wait(6)

    if PlayerData.job ~= nil and PlayerData.job.name == 'fire' then

      
      for k,v in pairs(Config.FireStations) do
        local playerPed = PlayerPedId()
        local coords    = GetEntityCoords(playerPed)
        for i=1, #v.Cloakrooms, 1 do
          if #(coords - vec3(v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z)) < Config.DrawDistance then
          ESX.DrawMarker(vec3(v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z))
          end
        end
        for i=1, #v.Armories, 1 do
          if #(coords - vec3(v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z)) < Config.DrawDistance then
          ESX.DrawMarker(vec3(v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z))
          end
        end
      if pilot then
        for i=1, #v.Helicopters, 1 do
          if #(coords - vec3(v.Helicopters[i].Spawner.x,  v.Helicopters[i].Spawner.y,  v.Helicopters[i].Spawner.z)) < Config.DrawDistance then
          ESX.DrawMarker(vec3(v.Helicopters[i].Spawner.x,  v.Helicopters[i].Spawner.y,  v.Helicopters[i].Spawner.z))
          end
        end
      end

        for i=1, #v.Vehicles, 1 do
          if not IsPedInAnyVehicle(playerPed,  false) then
            if #(coords - vec3(v.Vehicles[i].Spawner.x,  v.Vehicles[i].Spawner.y,  v.Vehicles[i].Spawner.z)) < Config.DrawDistance then
             ESX.DrawMarker(vec3(v.Vehicles[i].Spawner.x,  v.Vehicles[i].Spawner.y,  v.Vehicles[i].Spawner.z))
            end
          end
        end

        for i=1, #v.VehicleDeleters, 1 do
          if IsPedInAnyVehicle(playerPed,  false) then
            if #(coords - vec3(v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z)) < Config.DrawDistance then
              ESX.DrawMarker(vec3(v.VehicleDeleters[i].x,v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z))
          end
         end
        end

        if PlayerData.job ~= nil and PlayerData.job.name == 'fire' and PlayerData.job.grade >= 12 then

          for i=1, #v.BossActions, 1 do
            if not v.BossActions[i].disabled and #(coords - vec3(v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z)) < Config.DrawDistance then
              ESX.DrawMarker(vec3(v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z))
            end
          end

        end

      end

    end
   

  end
end)

-- Enter / Exit marker events
CreateThread(function()

  while true do

    Wait(5)

    if PlayerData.job ~= nil and PlayerData.job.name == 'fire' then

      local isInMarker     = false
      local currentStation = nil
      local currentPart    = nil
      local currentPartNum = nil

      for k,v in pairs(Config.FireStations) do
        local playerPed      = PlayerPedId()
        local coords         = GetEntityCoords(playerPed)
        for i=1, #v.Cloakrooms, 1 do
          if #(coords - vec3(v.Cloakrooms[i].x,  v.Cloakrooms[i].y,  v.Cloakrooms[i].z)) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'Cloakroom'
            currentPartNum = i
          end
        end

        for i=1, #v.Armories, 1 do
          if #(coords - vec3(v.Armories[i].x,  v.Armories[i].y,  v.Armories[i].z)) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'Armory'
            currentPartNum = i
          end
        end

        for i=1, #v.Vehicles, 1 do

          if #(coords - vec3(v.Vehicles[i].Spawner.x,  v.Vehicles[i].Spawner.y,  v.Vehicles[i].Spawner.z)) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'VehicleSpawner'
            currentPartNum = i
          end

        end
      if pilot then
        for i=1, #v.Helicopters, 1 do
          if #(coords - vec3(v.Helicopters[i].Spawner.x,  v.Helicopters[i].Spawner.y,  v.Helicopters[i].Spawner.z)) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'HelicopterSpawner'
            currentPartNum = i
          end
        end
      end

        for i=1, #v.VehicleDeleters, 1 do
          if #(coords - vec3(v.VehicleDeleters[i].x,  v.VehicleDeleters[i].y,  v.VehicleDeleters[i].z)) < Config.MarkerSize.x then
            isInMarker     = true
            currentStation = k
            currentPart    = 'VehicleDeleter'
            currentPartNum = i
          end
        end

        if PlayerData.job ~= nil and PlayerData.job.name == 'fire' and PlayerData.job.grade >= 12 then

          for i=1, #v.BossActions, 1 do
            if #(coords - vec3(v.BossActions[i].x,  v.BossActions[i].y,  v.BossActions[i].z)) < Config.MarkerSize.x then
              isInMarker     = true
              currentStation = k
              currentPart    = 'BossActions'
              currentPartNum = i
            end
          end

        end

      end

      local hasExited = false

      if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) ) then

        if
          (LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
          (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
        then
          TriggerEvent('exile_safd:hasExitedMarker', LastStation, LastPart, LastPartNum)
          hasExited = true
        end

        HasAlreadyEnteredMarker = true
        LastStation             = currentStation
        LastPart                = currentPart
        LastPartNum             = currentPartNum

        TriggerEvent('exile_safd:hasEnteredMarker', currentStation, currentPart, currentPartNum)
      end

      if not hasExited and not isInMarker and HasAlreadyEnteredMarker then

        HasAlreadyEnteredMarker = false

        TriggerEvent('exile_safd:hasExitedMarker', LastStation, LastPart, LastPartNum)
      end

    end

  end
end)


CreateThread(function()
  while true do

    Citizen.Wait(10)

    local closestDistance = -1
    local closestEntity   = nil

    if closestDistance ~= -1 and closestDistance <= 3.0 then

      if LastEntity ~= closestEntity then
        TriggerEvent('exile_safd:hasEnteredEntityZone', closestEntity)
        LastEntity = closestEntity
      end

    else

      if LastEntity ~= nil then
        TriggerEvent('exile_safd:hasExitedEntityZone', LastEntity)
        LastEntity = nil
      end

    end

  end
end)

CreateThread(function()
  while true do

    Citizen.Wait(10)

    if CurrentAction ~= nil then

      SetTextComponentFormat('STRING')
      AddTextComponentString(CurrentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)

      if IsControlPressed(0,  Keys['E']) and PlayerData.job ~= nil and PlayerData.job.name == 'fire' and (GetGameTimer() - GUI.Time) > 150 then

        if CurrentAction == 'menu_cloakroom' then
          OpenCloakroomMenu()
        end

        if CurrentAction == 'menu_armory' then
          OpenArmoryMenu(CurrentActionData.station)
        end

        if CurrentAction == 'menu_vehicle_spawner' then
          OpenVehicleSpawnerMenu(CurrentActionData.station, CurrentActionData.partNum)
        end
        if CurrentAction == 'helipad' then
          OpenHeliMenu(CurrentActionData.zoneNumber)
        end
        if CurrentAction == 'delete_vehicle' then
          ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
        end

        if CurrentAction == 'menu_boss_actions' then
          
          local elements = {
            {label = 'Zarządzanie Frakcją', value = 'safd_manage'},
            {label = 'Zarządzanie Licencjami', value = 'safd_licenses' },
          }
        
          ESX.UI.Menu.CloseAll()
        
          ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'safd_bossmenu',
            {
              title		= 'Zarządzanie - SAFD',
              align		= 'center',
              elements	= elements
            },
            function(data, menu)
        
              if data.current.value == 'safd_manage' then
                TriggerEvent('esx_society:openBossMenu', 'fire', function(data, menu)
                  menu.close()
                end, { showmoney = true, withdraw = true, deposit = true, wash = false, employees = true, badges = true})
              elseif data.current.value == 'safd_licenses' then
                LicenseFire('fire')
              end
        
            end,
          function(data, menu)
            menu.close()
            CurrentAction     = 'menu_boss_actions'
            CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~, aby ~g~zarządzać frakcją'
            CurrentActionData = {}
          end)
        end
        if CurrentAction == 'remove_entity' then
          DeleteEntity(CurrentActionData.entity)
        end

        CurrentAction = nil
        GUI.Time      = GetGameTimer()

      end

    end

    if IsControlPressed(0,  Keys['F6']) and PlayerData.job ~= nil and PlayerData.job.name == 'fire' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'fire_actions') and (GetGameTimer() - GUI.Time) > 150 then
      OpenFireActionsMenu()
      GUI.Time = GetGameTimer()
    end

  end
end)

function LicenseFire(society)
	ESX.TriggerServerCallback('esx_society:getEmployeeslic', function(employees)
		local elements = nil
		local identifier = ''

			elements = {
				head = {"Pracownik", "NUREK", "Drive", "FTO", "Pilot", "hazmat",  "Akcje"},
				rows = {}
			}

		

			for i=1, #employees, 1 do
				local licki = {}
				if employees[i].licensess.nurek == true then
					licki[1] = '✔️'
				else
					licki[1] = "❌"
				end
				if employees[i].licensess.drive == true then
					licki[2] = '✔️'
				else
					licki[2] = "❌"
				end
				if employees[i].licensess.fto == true then
					licki[3] = '✔️'
				else
					licki[3] = "❌"
				end
				if employees[i].licensess.pilot == true then
					licki[4] = '✔️'
				else
					licki[4] = "❌"
				end
				if employees[i].licensess.hazmat == true then
					licki[5] = '✔️'
				else
					licki[5] = "❌"
				end

				table.insert(elements.rows, {
					data = employees[i],
					cols = {
						employees[i].name,
						licki[1],
						licki[2],
						licki[3],
						licki[4],
						licki[5],
						'{{' .. "Nadaj Licencję" .. '|give}} {{' .. "Odbierz Licencję" .. '|take}}'
					}
				})
			end


		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_' .. society, elements, function(data, menu)
			local employee = data.data

			if data.value == 'give' then
		
          local elements = {
            {label = 'NUREK', value = 'safd_nurek'},
            {label = 'Drive', value = 'safd_drive' },
            {label = 'FTO', value = 'safd_fto'},
            {label = 'Pilot', value = 'safd_pilot' },
            {label = 'hazmat', value = 'safd_hazmat'},
          }
        
          ESX.UI.Menu.CloseAll()
        
          ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'safd_licenses_give',
            {
              title		= 'Licencje SAFD - Nadaj',
              align		= 'center',
              elements	= elements
            },
            function(data3, menu3)
              TriggerServerEvent('exile_safd:addlicense', employee.identifier, data3.current.value)
              ESX.ShowNotification('~g~Nadano~s~ licencje~y~ '..data3.current.label)
              return
            end,
          function(data3, menu3)
            menu3.close()
            CurrentAction     = 'menu_boss_actions'
            CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~, aby ~g~zarządzać frakcją'
            CurrentActionData = {}
          end)
			elseif data.value == 'take' then
								
                  local elements = {
                    {label = 'NUREK', value = 'safd_nurek'},
                    {label = 'Drive', value = 'safd_drive' },
                    {label = 'FTO', value = 'safd_fto'},
                    {label = 'Pilot', value = 'safd_pilot' },
                    {label = 'hazmat', value = 'safd_hazmat'},
                  }
                
                  ESX.UI.Menu.CloseAll()
                
                  ESX.UI.Menu.Open(
                    'default', GetCurrentResourceName(), 'safd_licenses_take',
                    {
                      title		= 'Licencje SAFD - Odbierz',
                      align		= 'center',
                      elements	= elements
                    },
                    function(data4, menu4)
                      TriggerServerEvent('exile_safd:removelicense', employee.identifier, data4.current.value)
                     
                      ESX.ShowNotification('~r~Odebrano~s~ licencje~y~ '..data4.current.label)
                      return
                    end,
                  function(data4, menu4)
                    menu4.close()
                    CurrentAction     = 'menu_boss_actions'
                    CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~, aby ~g~zarządzać frakcją'
                    CurrentActionData = {}
                  end)
			end
		end, function(data, menu)
			menu.close()
      CurrentAction     = 'menu_boss_actions'
            CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~, aby ~g~zarządzać frakcją'
            CurrentActionData = {}
		end)

	end, 'fire', society)
end
RegisterNetEvent('exile_safd:dLic')
AddEventHandler('exile_safd:dLic', function()
  if PlayerData.job ~= nil and PlayerData.job.name == 'fire' then
    ESX.TriggerServerCallback('esx_license:checkLicense', function(lickajest)
      if lickajest then
        nurek = true
      else
        nurek = false
      end
    end, GetPlayerServerId(PlayerId()), 'safd_nurek')	
    ESX.TriggerServerCallback('esx_license:checkLicense', function(lickajest)
      if lickajest then
        drive = true
      else
        drive = false
      end
    end, GetPlayerServerId(PlayerId()), 'safd_drive')	
    ESX.TriggerServerCallback('esx_license:checkLicense', function(lickajest)
      if lickajest then
        fto = true
      else
        fto = false
      end
    end, GetPlayerServerId(PlayerId()), 'safd_fto')	
    ESX.TriggerServerCallback('esx_license:checkLicense', function(lickajest)
      if lickajest then
        pilot = true
      else
        pilot = false
      end
    end, GetPlayerServerId(PlayerId()), 'safd_pilot')	
    ESX.TriggerServerCallback('esx_license:checkLicense', function(lickajest)
      if lickajest then
        hazmat = true
      else
        hazmat = false
      end
    end, GetPlayerServerId(PlayerId()), 'safd_hazmat')		

  end
end)


RegisterNetEvent('exile_safd:paliSieKurwa')
AddEventHandler('exile_safd:paliSieKurwa', function(where)
  onFire = true
  if onService then
    if PlayerData.job ~= nil and PlayerData.job.name == 'fire' then
      ESX.ShowNotification('Aktywowano alarm na ~y~'..where)
      CreateThread(function()
        local Blip = AddBlipForCoord(FirePoint.x, FirePoint.y, FirePoint.z)
          SetBlipSprite(Blip, 648)
          SetBlipColour(Blip, 1)
          SetBlipScale(Blip, 1.0)
          SetBlipAsShortRange(Blip, true)
          SetBlipDisplay(blip, 4)
          SetBlipAlpha(Blip, 200)
          BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Pożar")
        EndTextCommandSetBlipName(blip)
        Citizen.Wait(0)
          Citizen.Wait(30000)
          RemoveBlip(Blip)
          Blip = nil
        end)
    end
  end
  if where == 'Vanilla' then
    FirePoint = {x=128.03, y= -1296.7, z= 29.27}
    Fire = StartScriptFire(1953.06,  4897.91, 44.8, 0, false)
    Fire2 = StartScriptFire(1950.08,  4898.92, 44.8, 0, false)
    Fire3 = StartScriptFire(1951.44,  4897.02, 44.8, 0, false)
    Fire4 = StartScriptFire(1949.03,  4900.5, 44.8, 0, false)
    Fire5 = StartScriptFire(1947.64,  4901.8, 44.8, 0, false)
    SetPtfxAssetNextCall("scr_agencyheistb")
                
      Smoke = StartParticleFxLoopedAtCoord(
        "scr_env_agency3b_smoke",
        1953.06,  4897.91, 45.17,
        0.0,
        0.0,
        0.0,
        1.0,
        false,
        false,
        false,
        false
      )             
      SetPtfxAssetNextCall("scr_trevor3")              
      FireParticles = StartParticleFxLoopedAtCoord(
        "scr_trev3_trailer_plume",
        1953.06,  4897.91, 45.17,
        0.0,
        0.0,
        0.0,
        2.0,
        false,
        false,
        false,
        false
      )
      FireParticles2 = StartParticleFxLoopedAtCoord(
        "scr_trev3_trailer_plume",
        1950.08,  4898.92, 44.8,
        0.0,
        0.0,
        0.0,
        2.0,
        false,
        false,
        false,
        false
      )
  elseif where == 'Grapeseed' then
    FirePoint = {x=1950.08, y= 4898.92, z=44.8}
    Fire = StartScriptFire(1953.06,  4897.91, 44.8, 0, false)
    Fire2 = StartScriptFire(1950.08,  4898.92, 44.8, 0, false)
    Fire3 = StartScriptFire(1951.44,  4897.02, 44.8, 0, false)
    Fire4 = StartScriptFire(1949.03,  4900.5, 44.8, 0, false)
    Fire5 = StartScriptFire(1947.64,  4901.8, 44.8, 0, false)
    SetPtfxAssetNextCall("scr_agencyheistb")
                
      Smoke = StartParticleFxLoopedAtCoord(
        "scr_env_agency3b_smoke",
        1953.06,  4897.91, 45.17,
        0.0,
        0.0,
        0.0,
        1.0,
        false,
        false,
        false,
        false
      )             
      SetPtfxAssetNextCall("scr_trevor3")              
      FireParticles = StartParticleFxLoopedAtCoord(
        "scr_trev3_trailer_plume",
        1953.06,  4897.91, 45.17,
        0.0,
        0.0,
        0.0,
        2.0,
        false,
        false,
        false,
        false
      )
      FireParticles2 = StartParticleFxLoopedAtCoord(
        "scr_trev3_trailer_plume",
        1950.08,  4898.92, 44.8,
        0.0,
        0.0,
        0.0,
        2.0,
        false,
        false,
        false,
        false
      )
  end
  CreateThread(function()
    while true do
    Citizen.Wait(0)
    if onFire then
    if PlayerData.job ~= nil and PlayerData.job.name == 'fire' then
      if #(GetEntityCoords(PlayerPedId()) - vec3(FirePoint.x, FirePoint.y, FirePoint.z)) < 7 then
        ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~ aby włączyć ~b~nawadnianie')
        if IsControlJustPressed(0, 38) then
          ESX.ShowHelpNotification('~g~Aktywowanie~s~...')
          Wait(5000)
          StopParticleFxLooped(FireParticles, false)
          StopParticleFxLooped(FireParticles2, false)
          StopParticleFxLooped(Smoke, false)
          ESX.ShowNotification('Użyj gaśnicy aby ugasić reszte~y~ płomieni')
          Wait(15000)
          onFire = false
          ESX.TriggerServerCallback('exile_safd:pp', function(amount) end)
        end
      end
     end
    end
   end
  end)
  TriggerEvent('exile_safd:fires',FireParticles, FireParticles2, Smoke, Fire, Fire2,Fire3,Fire4,Fire5)
end)


RegisterNetEvent('exile_safd:fires')
AddEventHandler('exile_safd:fires', function(FireParticles, FireParticles2, Smoke, Fire, Fire2,Fire3,Fire4,Fire5)
  Wait(60000 * 10)
  if onFire then
    StopParticleFxLooped(FireParticles, false)
    StopParticleFxLooped(FireParticles2, false)
    StopParticleFxLooped(Smoke, false)
    StopScriptFire(Fire)
    StopScriptFire(Fire2)
    StopScriptFire(Fire3)
    StopScriptFire(Fire4)
    StopScriptFire(Fire5)
  end
end)


