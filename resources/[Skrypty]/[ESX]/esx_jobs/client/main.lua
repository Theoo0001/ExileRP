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

local PlayerData = {}
local menuIsShowed = false
local hintIsShowed = false
local isWorking = false
local hasAlreadyEnteredMarker = false
local Blips = {}
local JobBlips = {}
local isInMarker = false
local isInPublicMarker = false
local lastZone = nil
local currentLib = nil
local currentAnim = nil
local playingAnim = false

local hintToDisplay = "no hint to display"
local onDuty = true
local spawner = 0
local myPlate = {}

local vehicleObjInCaseofDrop = nil
local vehicleInCaseofDrop = nil

local vehicleMaxHealth = nil

local clientPoints = 0

ESX = nil

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
	TriggerServerEvent('flux:getLevel')
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	refreshBlips()
end)

RegisterNetEvent('flux:localPoint')
AddEventHandler('flux:localPoint', function()
	clientPoints = clientPoints + 1
end)

RegisterNetEvent('flux:checkPoints')
AddEventHandler('flux:checkPoints', function(zonePoints)
	if clientPoints >= zonePoints then
		TriggerServerEvent('flux:addLevelPoint')
		TriggerServerEvent('exile_jobs:DawajFaktureKurwo')
	end
	clientPoints = 0
end)

function OpenMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
	{
		title    = _U('cloakroom'),
		align = 'center',
		elements = {
			{label = _U('job_wear'),     value = 'job_wear'},
			{label = _U('citizen_wear'), value = 'citizen_wear'}
		}
	}, function(data, menu)
		if data.current.value == 'citizen_wear' then
			onDuty = false
			RemoveBlip(Blips['delivery'])
			Blips['delivery'] = nil
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		elseif data.current.value == 'job_wear' then
			onDuty = true
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
			end)
		end

		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('esx_jobs:stopAnim')
AddEventHandler('esx_jobs:stopAnim', function()
	ClearPedTasks(Citizen.InvokeNative(0x43A66C31C68491C0, -1))
	currentAnim = nil
	currentLib = nil
	playingAnim = false
	TriggerServerEvent('Flux:stopSzmato')
	hintToDisplay = "no hint to display"
	hintIsShowed = false
	isInMarker = false
	menuIsShowed = false
end)

AddEventHandler('Flux:dzialajKurwo', function(job, zone, currentZone)
	menuIsShowed = true
	if zone.Type == 'work' or zone.Type == 'delivery' then
		isWorking = true
	end
	if zone.Type == "cloakroom" then
		OpenMenu()
	elseif zone.Type == "work" then
		hintToDisplay = ''
		hintIsShowed = false
		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, false) then
			ESX.ShowNotification(_U('foot_work'))
		else
			if zone.JobName ~= nil then
				if PlayerData.job.name == zone.JobName and PlayerData.job.grade >= zone.JobGrade then
					if zone.AnimType == 1 then
						TaskStartScenarioInPlace(Citizen.InvokeNative(0x43A66C31C68491C0, -1), zone.Anim, 0, true)
					elseif zone.AnimType == 2 then
						currentLib = zone.Lib
						currentAnim = zone.Anim
						playingAnim = true
						ESX.Streaming.RequestAnimDict(zone.Lib, function()
							TaskPlayAnim(PlayerPedId(), zone.Lib, zone.Anim, 8.0, -8.0, -1, 1, 0, false, false, false)
						end)
					end
					TriggerServerEvent('flux:TriggerujSzmato', zone.Item, currentZone)
				end
			else
				if zone.AnimType == 1 then
					TaskStartScenarioInPlace(Citizen.InvokeNative(0x43A66C31C68491C0, -1), zone.Anim, 0, true)
				elseif zone.AnimType == 2 then
					currentLib = zone.Lib
					currentAnim = zone.Anim
					playingAnim = true
					ESX.Streaming.RequestAnimDict(zone.Lib, function()
						TaskPlayAnim(PlayerPedId(), zone.Lib, zone.Anim, 8.0, -8.0, -1, 1, 0, false, false, false)
					end)
				end
				TriggerServerEvent('flux:TriggerujSzmato', zone.Item, currentZone)
			end
		end
	elseif zone.Type == "vehspawner" then
		local spawnPoint = nil
		local vehicle = nil

		for k,v in pairs(Config.Jobs) do
			if PlayerData.job.name == k then
				for l,w in pairs(v.Zones) do
					if w.Type == "vehspawnpt" and w.Spawner == zone.Spawner then
						spawnPoint = w
						spawner = w.Spawner
					end
				end

				for m,x in pairs(v.Vehicles) do
					if x.Spawner == zone.Spawner then
						vehicle = x
					end
				end
			end
		end
		
		if GetVehiclePedIsIn(Citizen.InvokeNative(0x43A66C31C68491C0, -1), 0) == 0 then
			if ESX.Game.IsSpawnPointClear(spawnPoint.Pos, 5.0) then
				spawnVehicle(spawnPoint, vehicle)
			else
				ESX.ShowNotification(_U('spawn_blocked'))
			end
		else
			ESX.ShowNotification(_U('leave_vehicle'))
		end

	elseif zone.Type == "vehdelete" then
		local looping = true

		for k,v in pairs(Config.Jobs) do
			if PlayerData.job.name == k then
				for l,w in pairs(v.Zones) do
					if w.Type == "vehdelete" and w.Spawner == zone.Spawner then
						local playerPed = PlayerPedId()
						if IsPedInAnyVehicle(playerPed, false) then
							local vehicle = GetVehiclePedIsIn(playerPed, false)
							local plate = GetVehicleNumberPlateText(vehicle)
							plate = string.gsub(plate, " ", "")
							local driverPed = GetPedInVehicleSeat(vehicle, -1)

							if playerPed == driverPed then

								for i=1, #myPlate, 1 do
									if myPlate[i] == plate then
										DeleteVehicle(GetVehiclePedIsIn(playerPed, false))
										if w.Teleport ~= 0 then
											ESX.Game.Teleport(playerPed, w.Teleport)
										end
										table.remove(myPlate, i)
										break
									end
								end

							else
								ESX.ShowNotification(_U('not_your_vehicle'))
							end

						end

						looping = false
						break
					end

					if looping == false then
						break
					end
				end
			end
			if looping == false then
				break
			end
		end
	elseif zone.Type == "delivery" then
		if Blips['delivery'] ~= nil then
			RemoveBlip(Blips['delivery'])
			Blips['delivery'] = nil
		end

		hintToDisplay = "no hint to display"
		hintIsShowed = false
		TriggerServerEvent('flux:TriggerujSzmato', zone.Item, currentZone)
	end
	--nextStep(zone.GPS)
end)

function nextStep(gps)
	if gps ~= 0 then
		if Blips['delivery'] ~= nil then
			RemoveBlip(Blips['delivery'])
			Blips['delivery'] = nil
		end

		Blips['delivery'] = AddBlipForCoord(gps.x, gps.y, gps.z)
		SetBlipRoute(Blips['delivery'], true)
		ESX.ShowNotification(_U('next_point'))
	end
end

AddEventHandler('Flux:wyszedles', function(zone)
	TriggerEvent('esx_jobs:stopAnim')
	TriggerServerEvent('Flux:stopSzmato')
	hintToDisplay = "no hint to display"
	hintIsShowed = false
	isInMarker = false
	menuIsShowed = false
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	onDuty = false
	myPlate = {} -- loosing vehicle caution in case player changes job.
	spawner = 0
	deleteBlips()
	refreshBlips()
	RemoveBlip(Blips['delivery'])
	Blips['delivery'] = nil
end)

function deleteBlips()
	if JobBlips[1] ~= nil then
		for i=1, #JobBlips, 1 do
			RemoveBlip(JobBlips[i])
			JobBlips[i] = nil
		end
	end
end

function refreshBlips()
	local zones = {}
	local blipInfo = {}

	if PlayerData.job ~= nil then
		for jobKey,jobValues in pairs(Config.Jobs) do

			if jobKey == PlayerData.job.name then
				for zoneKey,zoneValues in pairs(jobValues.Zones) do

					if zoneValues.Blip then
						local bScale = 1.0
						if jobValues.BlipInfos.Scale then
							bScale = jobValues.BlipInfos.Scale
						end
						local blip = AddBlipForCoord(zoneValues.Pos.x, zoneValues.Pos.y, zoneValues.Pos.z)
						SetBlipSprite  (blip, jobValues.BlipInfos.Sprite)
						SetBlipDisplay (blip, 4)
						SetBlipScale   (blip, bScale)
						SetBlipCategory(blip, 3)
						SetBlipColour  (blip, jobValues.BlipInfos.Color)
						SetBlipAsShortRange(blip, true)

						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString(zoneValues.Name)
						EndTextCommandSetBlipName(blip)
						table.insert(JobBlips, blip)
					end
				end
			end
		end
	end
end

function spawnVehicle(spawnPoint, vehicle)
	hintToDisplay = 'no hint to display'
	hintIsShowed = false
	TriggerServerEvent('flux:DawajAuto', 'take_car', spawnPoint, vehicle)
end

RegisterNetEvent('Flux:ustawiajFure')
AddEventHandler('Flux:ustawiajFure', function(spawnPoint, vehicle)
	local playerPed = PlayerPedId()

	ESX.Game.SpawnVehicle(vehicle.Hash, spawnPoint.Pos, spawnPoint.Heading, function(spawnedVehicle)

		if vehicle.Trailer ~= "none" then
			ESX.Game.SpawnVehicle(vehicle.Trailer, spawnPoint.Pos, spawnPoint.Heading, function(trailer)
				AttachVehicleToTrailer(spawnedVehicle, trailer, 1.1)
			end)
		end

		-- save & set plate
		local plate = 'WORK ' .. math.random(100, 900)
		local localVehPlate = string.lower(GetVehicleNumberPlateText(spawnedVehicle))
		SetVehicleNumberPlateText(spawnedVehicle, plate)
		plate = string.gsub(plate, " ", "")
		table.insert(myPlate, plate)
		TaskWarpPedIntoVehicle(playerPed, spawnedVehicle, -1)
		local localVehPlate = string.lower(GetVehicleNumberPlateText(spawnedVehicle))
		TriggerEvent('ls:dodajklucze2', localVehPlate)
	end)
end)

-- Show top left hint
CreateThread(function()
	while true do
		Citizen.Wait(3)

		if hintIsShowed then
			ESX.ShowHelpNotification(hintToDisplay)
		else
			Citizen.Wait(500)
		end
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(3)
		if playingAnim == true then
			if IsEntityPlayingAnim(PlayerPedId(), currentLib, currentAnim, 3) ~= 1 then
				ESX.Streaming.RequestAnimDict(currentLib, function()
					TaskPlayAnim(PlayerPedId(), currentLib, currentAnim, 8.0, -8.0, -1, 1, 0, false, false, false)
				end)
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

-- Display markers (only if on duty and the player's job ones)
CreateThread(function()
	while true do
		Citizen.Wait(1)
		local zones = {}

		if PlayerData.job ~= nil then
			local found = false
			for k,v in pairs(Config.Jobs) do
				if PlayerData.job.name == k then
					zones = v.Zones
				end
			end

			local coords = GetEntityCoords(PlayerPedId())
			for k,v in pairs(zones) do
				if onDuty or v.Type == "cloakroom" or PlayerData.job.name == "reporter" then
					if(v.Marker ~= -1 and #(coords - vec3(v.Pos.x, v.Pos.y, v.Pos.z)) < Config.DrawDistance) then
						found = true
						ESX.DrawMarker(vec3(v.Pos.x, v.Pos.y, v.Pos.z))
					end					
				end
			end
			if not found then
				Citizen.Wait(1000)
			end
		end
	end
end)

-- Activate menu when player is inside marker
CreateThread(function()
	while true do

		Citizen.Wait(1)

		if PlayerData.job ~= nil and PlayerData.job.name ~= 'unemployed' then
			local zones = nil
			local job = nil

			for k,v in pairs(Config.Jobs) do
				if PlayerData.job.name == k then
					job = v
					zones = v.Zones
				end
			end

			if zones ~= nil then
				local coords      = GetEntityCoords(PlayerPedId())
				local currentZone = nil
				local zone        = nil

				for k,v in pairs(zones) do
					if #(coords - vec3(v.Pos.x, v.Pos.y, v.Pos.z)) < v.Size.x then
						isInMarker  = true
						currentZone = k
						zone        = v
						break
					else
						isInMarker  = false
					end
				end

				if IsControlJustReleased(0, Keys['E']) and not menuIsShowed and isInMarker then
					if zone.Type == 'cloakroom' then
						TriggerEvent('Flux:dzialajKurwo', job, zone, currentZone)
					else
						if onDuty then
							if zone.Type == 'work' or zone.Type == 'delivery' then
								if not isWorking then
									TriggerEvent('Flux:dzialajKurwo', job, zone, currentZone)
								end
							else
								TriggerEvent('Flux:dzialajKurwo', job, zone, currentZone)
							end
						end
					end
				end

				if IsControlJustReleased(0, Keys['X']) and menuIsShowed and isInMarker then
					if onDuty then
						TriggerEvent('Flux:wyszedles', zone)
						if zone.Type == 'work' or zone.Type == 'delivery' then
							Citizen.Wait(10000)
							isWorking = false
						end
					end
				end

				-- hide or show top left zone hints
				if isInMarker and not menuIsShowed then
					hintIsShowed = true
					if (onDuty or zone.Type == "cloakroom" or PlayerData.job.name == "reporter") and zone.Type ~= "vehdelete" then
						hintToDisplay = zone.Hint
						hintIsShowed = true
					elseif zone.Type == "vehdelete" and (onDuty or PlayerData.job.name == "reporter") then
						local playerPed = PlayerPedId()

						if IsPedInAnyVehicle(playerPed, false) then
							local vehicle = GetVehiclePedIsIn(playerPed, false)
							local driverPed = GetPedInVehicleSeat(vehicle, -1)
							local plate = GetVehicleNumberPlateText(vehicle)
							plate = string.gsub(plate, " ", "")

							if playerPed == driverPed then

								for i=1, #myPlate, 1 do
									if myPlate[i] == plate then
										hintToDisplay = zone.Hint
										break
									end
								end

							else
								hintToDisplay = _U('not_your_vehicle')
							end
						else
							hintToDisplay = _U('in_vehicle')
						end
						hintIsShowed = true
					elseif onDuty and zone.Spawner ~= spawner then
						hintToDisplay = _U('wrong_point')
						hintIsShowed = true
					else
						if not isInPublicMarker then
							hintToDisplay = "no hint to display"
							hintIsShowed = false
						end
					end
				end

				if isInMarker and not hasAlreadyEnteredMarker then
					hasAlreadyEnteredMarker = true
					lastZone = zone
				end

				if not isInMarker and hasAlreadyEnteredMarker then
					hasAlreadyEnteredMarker = false
					TriggerEvent('Flux:wyszedles', zone)
					if lastZone.Type == 'work' or lastZone.Type == 'delivery' then
						Citizen.Wait(10000)
						isWorking = false
					end
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

--[[CreateThread(function()
    RequestModel(GetHashKey("a_c_cow"))
    while not HasModelLoaded(GetHashKey("a_c_cow")) do
      Wait(155)
    end

      local ped =  Citizen.InvokeNative(0xD49F9B0955C367DE, 4, GetHashKey("a_c_cow"), 1223.16, 1908.63, 76.76, 52.38, false, true)
      FreezeEntityPosition(ped, true)
      SetEntityInvincible(ped, true)
      SetBlockingOfNonTemporaryEvents(ped, true)
end)

CreateThread(function()
  
	RequestModel(GetHashKey("a_c_cow"))
	while not HasModelLoaded(GetHashKey("a_c_cow")) do 
		Wait(155)
	end
		local ped =  Citizen.InvokeNative(0xD49F9B0955C367DE, 4, GetHashKey("a_c_cow"), 1220.0, 1912.52, 76.25, 210.02, false, true)
		FreezeEntityPosition(ped, true)
		SetEntityInvincible(ped, true)
		SetBlockingOfNonTemporaryEvents(ped, true)
end)]]

CreateThread(function()
	-- Slaughterer
	RemoveIpl("CS1_02_cf_offmission")
	RequestIpl("CS1_02_cf_onmission1")
	RequestIpl("CS1_02_cf_onmission2")
	RequestIpl("CS1_02_cf_onmission3")
	RequestIpl("CS1_02_cf_onmission4")

	-- Tailor
	RequestIpl("id2_14_during_door")
	RequestIpl("id2_14_during1")
end)
