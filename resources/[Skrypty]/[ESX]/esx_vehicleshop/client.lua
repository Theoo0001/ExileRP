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

local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local IsInShopMenu            = false
local PlayerData			  = {}
local Categories, Vehicles, BCategories, Boats, PCategories, Planes = {}, {}, {}, {}, {}, {}
local LastVehicles            = {}
local CurrentVehicleData      = nil
local LastVehicleProps		  = nil
local cenaJazdy 			  = 5000
ESX                           = nil

local timer = 180
local timerMax = timer
local isTesting = false
local testingVehicle = nil
local IsDead = false

CreateThread(function()
	while ESX == nil do
		TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) 
			ESX = obj 
		end)
		
		Citizen.Wait(500)
	end

	Citizen.Wait(5000)
	PlayerData = ESX.GetPlayerData()

	ESX.TriggerServerCallback('esx_vehicleshop:getCategories', function (categories)
		Categories = categories.Vehicles
		BCategories = categories.Boats
		PCategories = categories.Planes
	end)

	ESX.TriggerServerCallback('esx_vehicleshop:getVehicles', function (vehicles)
		Vehicles = vehicles.Vehicles
		Boats = vehicles.Boats
		Planes = vehicles.Planes
	end)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx_vehicleshop:sendCategories')
AddEventHandler('esx_vehicleshop:sendCategories', function (categories, bcategories, pcategories)
	Categories = categories
	BCategories = bcategories
	PCategories = pcategories
end)

RegisterNetEvent('esx_vehicleshop:sendVehicles')
AddEventHandler('esx_vehicleshop:sendVehicles', function (vehicles, boats, planes)
	Vehicles = vehicles
	Boats = boats
	Planes = planes
end)

CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if timer < timerMax then
			timer = timer + 1
		end
	end
end)
local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GeneratePlate()
	local generatedPlate
	local doBreak = false

	while true do
		Citizen.Wait(2)
		math.randomseed(GetGameTimer())
		if Config.PlateUseSpace then
			generatedPlate = string.upper(GetRandomLetter(Config.PlateLetters) .. ' ' .. GetRandomNumber(Config.PlateNumbers))
		else
			generatedPlate = string.upper(GetRandomLetter(Config.PlateLetters) .. GetRandomNumber(Config.PlateNumbers))
		end

		ESX.TriggerServerCallback('esx_vehicleshop:isPlateTaken', function (isPlateTaken)
			if not isPlateTaken then
				doBreak = true
			end
		end, generatedPlate)

		if doBreak then
			break
		end
	end

	return generatedPlate
end

-- mixing async with sync tasks
function IsPlateTaken(plate)
	local callback = 'waiting'

	ESX.TriggerServerCallback('esx_vehicleshop:isPlateTaken', function(isPlateTaken)
		callback = isPlateTaken
	end, plate)

	while type(callback) == 'string' do
		Citizen.Wait(0)
	end

	return callback
end

function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

function TestCar(vehicleData)
	timer = 0
	isTesting = true

	playerPed = PlayerPedId()
	ESX.Game.SpawnVehicle(vehicleData.model, {
		x = Config.Zones.ShopOutside.Pos.x,
		y = Config.Zones.ShopOutside.Pos.y,
		z = Config.Zones.ShopOutside.Pos.z
	}, Config.Zones.ShopOutside.Heading, function (vehicle)
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		ESX.ShowNotification('Masz trzy minuty na przetestowanie pojazdu')
		ESX.ShowNotification('Nie opuszczaj go!')

		testingVehicle = vehicle
		SetVehicleDoorsLocked(vehicle, 4)
		FreezeEntityPosition(playerPed, false)		
		Citizen.InvokeNative(0xEA1C610A04DB6BBB, playerPed, true)

		SetVehicleNumberPlateText(vehicle, 'TEST CAR')
		CreateThread(function()
			while true do 
				Citizen.Wait(1000)
				if timer ~= timerMax then
					SetTextComponentFormat('STRING')
					AddTextComponentString('Pozostało Ci ~b~' .. (timerMax - timer) .. '~w~/~b~' .. timerMax .. '~w~ sekund.')
					DisplayHelpTextFromStringLabel(0, 0, 1, -1)
					EndTextCommandDisplayHelp(0, 0, true, 1000)

					VehEngineHP = GetVehicleEngineHealth(vehicle) 
					if not IsPedSittingInAnyVehicle(PlayerPedId()) then
						ESX.ShowNotification('Opuściłeś pojazd!')
						isTesting = false
						timer = timerMax
						ESX.Game.DeleteVehicle(vehicle)						
						SetEntityCoords(playerPed, Config.Zones.ShopEntering.Pos.x, Config.Zones.ShopEntering.Pos.y, Config.Zones.ShopEntering.Pos.z)
					elseif IsDead then
						ESX.ShowNotification('Obezwładniony!')
						isTesting = false
						timer = timerMax
						ESX.Game.DeleteVehicle(vehicle)
					elseif timer  == timerMax - 1 then
						ESX.ShowNotification('Skończył Ci się czas wypożyczenia!')
						isTesting = false
						timer = timerMax
						ESX.Game.DeleteVehicle(vehicle)
						SetEntityCoords(playerPed, Config.Zones.ShopEntering.Pos.x, Config.Zones.ShopEntering.Pos.y, Config.Zones.ShopEntering.Pos.z)
					elseif (VehEngineHP > 0) and (VehEngineHP < 980) then 
						ESX.ShowNotification('Uszkodziłeś pojazd')
						isTesting = false
						timer = timerMax
						ESX.Game.DeleteVehicle(vehicle)
						SetEntityCoords(playerPed, Config.Zones.ShopEntering.Pos.x, Config.Zones.ShopEntering.Pos.y, Config.Zones.ShopEntering.Pos.z)
					end
				end
			end
		end)
    end)
end

CreateThread(function()
	while true do 
		Citizen.Wait(1000)
		if IsPedInAnyVehicle(PlayerPedId()) then
			local vehicle = GetVehiclePedIsIn(PlayerPedId())
			if string.upper(tostring(GetVehicleNumberPlateText(vehicle))) == 'TEST CAR' and not isTesting then
				ESX.Game.DeleteVehicle(vehicle)
				ESX.ShowNotification('To pojazd testowy!')
			end
		end
	end
end)

function DeleteShopInsideVehicles()
	while #LastVehicles > 0 do
		local vehicle = LastVehicles[1]
		SetEntityAsMissionEntity(vehicle, true, true)
		DeleteVehicle(vehicle)
		table.remove(LastVehicles, 1)
	end
end

AddEventHandler('esx_vehicleshop:getVehicles', function (cb)
    cb(Vehicles)
end)

function getVehicles()
	return Vehicles
end

CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsInShopMenu then
			DisableControlAction(2, Keys['F3'], true) -- Animations
			DisableControlAction(2, Keys['F6'], true) -- Fraction actions
		else
			Citizen.Wait(500)
		end
	end
end)

function WaitForVehicleToLoad(modelHash)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))
	if not HasModelLoaded(modelHash) then
		Citizen.InvokeNative(0xABA17D7CE615ADBF, "FMMC_PLYLOAD")
		Citizen.InvokeNative(0xBD12F8228410D9B4, 4)

		RequestModel(modelHash)
		while not HasModelLoaded(modelHash) do
			Citizen.Wait(0)
			DisableAllControlActions(0)
		end

		Citizen.InvokeNative(0x10D373323E5B9C0D)
	end
end

function OpenShopMenu()
	IsInShopMenu = true
	ESX.UI.Menu.CloseAll()
	local playerPed = PlayerPedId()
	
	FreezeEntityPosition(playerPed, true)
	Citizen.InvokeNative(0xEA1C610A04DB6BBB, playerPed, false)
	SetEntityCoords(playerPed, Config.Zones.ShopInside.Pos.x, Config.Zones.ShopInside.Pos.y, Config.Zones.ShopInside.Pos.z)
	
	local vehiclesByCategory = {}

	for k,v in ipairs(Categories) do
		vehiclesByCategory[v.name] = {}
	end
	
	for k,v in ipairs(Vehicles) do
		if IsModelInCdimage(GetHashKey(v.model)) then
			table.insert(vehiclesByCategory[v.category], v)
		end		
	end
		
	local elements           = {}
	local firstVehicleData   = nil
		
	for k,v in ipairs(Categories) do
		local categoryVehicles = vehiclesByCategory[v.name]
		
		local options = {}
		for j,d in ipairs(categoryVehicles) do
			if k == 1 and j == 1 then
				firstVehicleData = d
			end
			
			if not firstVehicleData then
				firstVehicleData = d
			end
			
			table.insert(options, d.name..(d.blocked == 1 and '<span style="color: red;"> Tylko podgląd</span>' or (PlayerData.job.name == 'cardealer' and '<span style="color: #7cfc00;"> $'..math.floor(d.price * 92 / 100)..'</span>' or '<span style="color: #7cfc00;"> $'..d.price..'</span>')))
		end
		
		table.insert(elements, {
			name    = v.name,
			label   = v.label,
			value   = 0,
			type    = 'slider',
			max     = #v,
			blocked = v.blocked,
			options = options
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop',
	{
		title    = 'Sprzedawca aut',
		align    = 'top-left',
		elements = elements
	}, function (data, menu)
		local vehicleData = vehiclesByCategory[data.current.name][data.current.value + 1]
		
		if (vehicleData.blocked == 0) then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
				title = (vehicleData.blocked == 0 and ('Czy chcesz kupić '.. vehicleData.name .. ' za '.. PlayerData.job.name == 'cardealer' and ESX.Math.GroupDigits(math.floor(vehicleData.price * 85 / 100)) or ESX.Math.GroupDigits(vehicleData.price)) or 'Nie możesz kupić tego pojazdu'),
				align = 'top-left',
				elements = (vehicleData.blocked == 0 and {
					{label = 'Tak', value = 'yes'},
					{label = ('Jazda Testowa <font color=red>'..cenaJazdy..'</font>$'), value = 'test'},
					{label = ('Wróć'),  value = 'no'}
				} or {
					{label = ('Samochód jest wystawiony tylko na licytację'),  value = 'no'}
				}),
			}, function(data2, menu2)
				if data2.current.value == 'test' then
					if not isTesting then
						menu2.close()
						ESX.TriggerServerCallback('esx_vehiclekatalog:payTest', function (status)
							if status then
								menu.close()
								Citizen.Wait(500)
								IsInShopMenu = false
								DeleteShopInsideVehicles()
								
								TestCar(vehicleData)
							else
								ESX.ShowNotification('Nie masz odpowiedniej ilości gotówki!')
							end
						end)
					end				
				elseif data2.current.value == 'yes' then
					ESX.TriggerServerCallback("esx_scoreboard:getConnectedCops", function(MisiaczekPlayers)
						if MisiaczekPlayers then
							if PlayerData.job.name == 'cardealer' or MisiaczekPlayers['cardealer'] == 0 then
								ESX.TriggerServerCallback('esx_vehicleshop:buyVehicle', function(hasEnoughMoney)
									if hasEnoughMoney then
										IsInShopMenu = false

										menu2.close()
										menu.close()

										DeleteShopInsideVehicles()

										ESX.Game.SpawnVehicle(vehicleData.model, Config.Zones.ShopOutside.Pos, Config.Zones.ShopOutside.Heading, function (vehicle)
											ESX.Game.SetVehicleProperties(vehicle, LastVehicleProps)
											TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

											local newPlate     = GeneratePlate()
											local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
											vehicleProps.plate = newPlate
											SetVehicleNumberPlateText(vehicle, newPlate)
											TriggerServerEvent('exile_vehicles:setOwned', vehicleProps, vehicleData.name, PlayerData.job.name == 'cardealer' and ESX.Math.GroupDigits(math.floor(vehicleData.price * 92 / 100)) or ESX.Math.GroupDigits(vehicleData.price), 'car')		
										end)

										FreezeEntityPosition(playerPed, false)
										Citizen.InvokeNative(0xEA1C610A04DB6BBB, playerPed, true)
									else
										ESX.ShowNotification('~r~Nie posiadasz pieniedzy')
									end

								end, vehicleData.model)
							else
								ESX.ShowNotification('Udaj się do ~b~brokera ~w~będącego na służbie, aby zakupić ten pojazd!')
							end
						end
					end)
				elseif data2.current.value == 'no' then
					menu2.close()
				end
			end, function (data2, menu2)
				menu2.close()
			end)
		end
	end, function (data, menu)
		menu.close()
		DeleteShopInsideVehicles()
		local playerPed = PlayerPedId()

		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~ aby wejść do menu'
		CurrentActionData = {}

		FreezeEntityPosition(playerPed, false)
		Citizen.InvokeNative(0xEA1C610A04DB6BBB, playerPed, true)
		SetEntityCoords(playerPed, Config.Zones.ShopEntering.Pos.x, Config.Zones.ShopEntering.Pos.y, Config.Zones.ShopEntering.Pos.z)

		IsInShopMenu = false
		LastVehicleProps = nil
	end, function (data, menu)
		local vehicleData = vehiclesByCategory[data.current.name][data.current.value + 1]
		local playerPed   = PlayerPedId()

		DeleteShopInsideVehicles()
		WaitForVehicleToLoad(vehicleData.model)

		ESX.Game.SpawnLocalVehicle(vehicleData.model, Config.Zones.ShopInside.Pos, Config.Zones.ShopInside.Heading, function (vehicle)
			table.insert(LastVehicles, vehicle)
			LastVehicleProps = ESX.Game.GetVehicleProperties(vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			FreezeEntityPosition(vehicle, true)
		end)
	end)

	DeleteShopInsideVehicles()
	WaitForVehicleToLoad(firstVehicleData.model)

	ESX.Game.SpawnLocalVehicle(firstVehicleData.model, Config.Zones.ShopInside.Pos, Config.Zones.ShopInside.Heading, function (vehicle)
		table.insert(LastVehicles, vehicle)
		LastVehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		FreezeEntityPosition(vehicle, true)
	end)

end

function OpenBoatShopMenu()
	IsInShopMenu = true
	ESX.UI.Menu.CloseAll()
	local playerPed = PlayerPedId()
	
	FreezeEntityPosition(playerPed, true)
	Citizen.InvokeNative(0xEA1C610A04DB6BBB, playerPed, false)
	SetEntityCoords(playerPed, Config.Zones.BoatInside.Pos.x, Config.Zones.BoatInside.Pos.y, Config.Zones.BoatInside.Pos.z)
	
	local vehiclesByCategory = {}

	for k,v in ipairs(BCategories) do
		vehiclesByCategory[v.name] = {}
	end
	
	for k,v in ipairs(Boats) do
		if IsModelInCdimage(GetHashKey(v.model)) then
			table.insert(vehiclesByCategory[v.category], v)
		end		
	end
		
	local elements           = {}
	local firstVehicleData   = nil
		
	for k,v in ipairs(BCategories) do
		local categoryVehicles = vehiclesByCategory[v.name]
		
		local options = {}
		for j,d in ipairs(categoryVehicles) do
			if k == 1 and j == 1 then
				firstVehicleData = d
			end
			
			if not firstVehicleData then
				firstVehicleData = d
			end
			
			table.insert(options, d.name.. '<span style="color: #7cfc00;"> $'..d.price..'</span>')
		end
		
		table.insert(elements, {
			name    = v.name,
			label   = v.label,
			value   = 0,
			type    = 'slider',
			max     = #v,
			license = v.license,
			options = options
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop',
	{
		title    = 'Sprzedawca',
		align    = 'top-left',
		elements = elements
	}, function (data, menu)
		local vehicleData = vehiclesByCategory[data.current.name][data.current.value + 1]

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
				title = 'Czy chcesz kupić '.. vehicleData.name .. ' za '.. ESX.Math.GroupDigits(vehicleData.price),
				align = 'top-left',
				elements = {
					{label = 'Tak', value = 'yes'},
					{label = ('Wróć'),  value = 'no'}
				},
			}, function(data2, menu2)
				if data2.current.value == 'yes' then
					ESX.TriggerServerCallback('esx_vehicleshop:buyBoat', function(hasEnoughMoney)
						if hasEnoughMoney then
							IsInShopMenu = false

							menu2.close()
							menu.close()

							DeleteShopInsideVehicles()

							ESX.Game.SpawnVehicle(vehicleData.model, Config.Zones.BoatOutside.Pos, Config.Zones.BoatOutside.Heading, function (vehicle)
								ESX.Game.SetVehicleProperties(vehicle, LastVehicleProps)
								TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

								local newPlate     = GeneratePlate()
								local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
								vehicleProps.plate = newPlate
								SetVehicleNumberPlateText(vehicle, newPlate)
								TriggerServerEvent('exile_vehicles:setOwned', vehicleProps, vehicleData.name, ESX.Math.GroupDigits(vehicleData.price), 'boat')		
							end)

							FreezeEntityPosition(playerPed, false)
							Citizen.InvokeNative(0xEA1C610A04DB6BBB, playerPed, true)
						else
							ESX.ShowNotification('~r~Nie posiadasz wystarczająco pieniędzy')
						end

					end, vehicleData.model)
				elseif data2.current.value == 'no' then
					menu2.close()
				end
			end, function (data2, menu2)
				menu2.close()
			end)
	end, function (data, menu)
		menu.close()
		DeleteShopInsideVehicles()
		local playerPed = PlayerPedId()

		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~ aby wejść do menu'
		CurrentActionData = {}

		FreezeEntityPosition(playerPed, false)
		Citizen.InvokeNative(0xEA1C610A04DB6BBB, playerPed, true)
		SetEntityCoords(playerPed, Config.Zones.BoatEntering.Pos.x, Config.Zones.BoatEntering.Pos.y, Config.Zones.BoatEntering.Pos.z)

		IsInShopMenu = false
		LastVehicleProps = nil
	end, function (data, menu)
		local vehicleData = vehiclesByCategory[data.current.name][data.current.value + 1]
		local playerPed   = PlayerPedId()

		DeleteShopInsideVehicles()
		WaitForVehicleToLoad(vehicleData.model)

		ESX.Game.SpawnLocalVehicle(vehicleData.model, Config.Zones.BoatInside.Pos, Config.Zones.BoatInside.Heading, function (vehicle)
			table.insert(LastVehicles, vehicle)
			LastVehicleProps = ESX.Game.GetVehicleProperties(vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			FreezeEntityPosition(vehicle, true)
		end)
	end)

	DeleteShopInsideVehicles()
	WaitForVehicleToLoad(firstVehicleData.model)

	ESX.Game.SpawnLocalVehicle(firstVehicleData.model, Config.Zones.BoatInside.Pos, Config.Zones.BoatInside.Heading, function (vehicle)
		table.insert(LastVehicles, vehicle)
		LastVehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		FreezeEntityPosition(vehicle, true)
	end)

end

function OpenPlaneShopMenu()
	IsInShopMenu = true
	ESX.UI.Menu.CloseAll()
	local playerPed = PlayerPedId()
	
	FreezeEntityPosition(playerPed, true)
	Citizen.InvokeNative(0xEA1C610A04DB6BBB, playerPed, false)
	SetEntityCoords(playerPed, Config.Zones.PlaneInside.Pos.x, Config.Zones.PlaneInside.Pos.y, Config.Zones.PlaneInside.Pos.z)
	
	local vehiclesByCategory = {}

	for k,v in ipairs(PCategories) do
		vehiclesByCategory[v.name] = {}
	end
	
	for k,v in ipairs(Planes) do
		if IsModelInCdimage(GetHashKey(v.model)) then
			table.insert(vehiclesByCategory[v.category], v)
		end		
	end
		
	local elements           = {}
	local firstVehicleData   = nil
		
	for k,v in ipairs(PCategories) do
		local categoryVehicles = vehiclesByCategory[v.name]
		
		local options = {}
		for j,d in ipairs(categoryVehicles) do
			if k == 1 and j == 1 then
				firstVehicleData = d
			end
			
			if not firstVehicleData then
				firstVehicleData = d
			end
			
			table.insert(options, d.name.. '<span style="color: #7cfc00;"> $'..d.price..'</span>')
		end
		
		table.insert(elements, {
			name    = v.name,
			label   = v.label,
			value   = 0,
			type    = 'slider',
			max     = #v,
			license = v.license,
			options = options
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_shop',
	{
		title    = 'Sprzedawca',
		align    = 'top-left',
		elements = elements
	}, function (data, menu)
		local vehicleData = vehiclesByCategory[data.current.name][data.current.value + 1]
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
			title = 'Czy chcesz kupić '.. vehicleData.name .. ' za ' .. ESX.Math.GroupDigits(vehicleData.price),
			align = 'top-left',
			elements = {
				{label = 'Tak', value = 'yes'},
				{label = ('Wróć'),  value = 'no'}
			},
		}, function(data2, menu2)
			if data2.current.value == 'yes' then
				ESX.TriggerServerCallback('esx_vehicleshop:buyPlane', function(hasEnoughMoney)
					if hasEnoughMoney then
						IsInShopMenu = false

						menu2.close()
						menu.close()

						DeleteShopInsideVehicles()

						ESX.Game.SpawnVehicle(vehicleData.model, Config.Zones.PlaneOutside.Pos, Config.Zones.PlaneOutside.Heading, function (vehicle)
							ESX.Game.SetVehicleProperties(vehicle, LastVehicleProps)
							TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

							local newPlate     = GeneratePlate()
							local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
							vehicleProps.plate = newPlate
							SetVehicleNumberPlateText(vehicle, newPlate)
							TriggerServerEvent('exile_vehicles:setOwned', vehicleProps, vehicleData.name, ESX.Math.GroupDigits(vehicleData.price), 'plane')		
						end)

						FreezeEntityPosition(playerPed, false)
						Citizen.InvokeNative(0xEA1C610A04DB6BBB, playerPed, true)
					else
						ESX.ShowNotification('~r~Nie posiadasz wystarczająco pieniędzy')
					end

				end, vehicleData.model)
			elseif data2.current.value == 'no' then
				menu2.close()
			end
		end, function (data2, menu2)
			menu2.close()
		end)
	end, function (data, menu)
		menu.close()
		DeleteShopInsideVehicles()
		local playerPed = PlayerPedId()

		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~ aby wejść do menu'
		CurrentActionData = {}

		FreezeEntityPosition(playerPed, false)
		Citizen.InvokeNative(0xEA1C610A04DB6BBB, playerPed, true)
		SetEntityCoords(playerPed, Config.Zones.PlaneEntering.Pos.x, Config.Zones.PlaneEntering.Pos.y, Config.Zones.PlaneEntering.Pos.z)

		IsInShopMenu = false
		LastVehicleProps = nil
	end, function (data, menu)
		local vehicleData = vehiclesByCategory[data.current.name][data.current.value + 1]
		local playerPed   = PlayerPedId()

		DeleteShopInsideVehicles()
		WaitForVehicleToLoad(vehicleData.model)

		ESX.Game.SpawnLocalVehicle(vehicleData.model, Config.Zones.PlaneInside.Pos, Config.Zones.PlaneInside.Heading, function (vehicle)
			table.insert(LastVehicles, vehicle)
			LastVehicleProps = ESX.Game.GetVehicleProperties(vehicle)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
			FreezeEntityPosition(vehicle, true)
		end)
	end)

	DeleteShopInsideVehicles()
	WaitForVehicleToLoad(firstVehicleData.model)

	ESX.Game.SpawnLocalVehicle(firstVehicleData.model, Config.Zones.PlaneInside.Pos, Config.Zones.PlaneInside.Heading, function (vehicle)
		table.insert(LastVehicles, vehicle)
		LastVehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		FreezeEntityPosition(vehicle, true)
	end)

end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function (job)
	PlayerData.job = job
end)

AddEventHandler('esx_vehicleshop:hasEnteredMarker', function (zone)
	if zone == 'ShopEntering' then

		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~ aby wejść do menu'
		CurrentActionData = {}

	elseif zone == 'BoatEntering' then

		CurrentAction     = 'boat_menu'
		CurrentActionMsg  = "Naciśnij ~INPUT_CONTEXT~ aby zakupić łódź"
		CurrentActionData = {}
	
	elseif zone == 'PlaneEntering' then

		CurrentAction     = 'plane_menu'
		CurrentActionMsg  = "Naciśnij ~INPUT_CONTEXT~ aby zakupić samolot lub helikopter"
		CurrentActionData = {}

	elseif zone == 'ResellVehicle' then

		local playerPed = PlayerPedId()

		if IsPedSittingInAnyVehicle(playerPed) and PlayerData.job.name == 'cardealer' and PlayerData.job.grade >= Config.RequiredResselJobGrade then

			local vehicle     = GetVehiclePedIsIn(playerPed, false)
			local vehicleData, model, resellPrice, plate

			if GetPedInVehicleSeat(vehicle, -1) == playerPed then
				for i=1, #Vehicles, 1 do
					if GetHashKey(Vehicles[i].model) == GetEntityModel(vehicle) then
						vehicleData = Vehicles[i]
						break
					end
				end
	
				resellPrice = ESX.Math.Round(vehicleData.price / 100 * Config.ResellPercentage)
				model = GetEntityModel(vehicle)
				plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
	
				CurrentAction     = 'resell_vehicle'
				CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~ aby sprzedać ~b~'.. vehicleData.name .. '~s~ za ~g~'.. ESX.Math.GroupDigits(resellPrice) .. '$'
	
				CurrentActionData = {
					vehicle = vehicle,
					label = vehicleData.name,
					price = resellPrice,
					model = model,
					plate = plate
				}
			end

		end
	end
end)

AddEventHandler('esx_vehicleshop:hasExitedMarker', function (zone)
	if not IsInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if IsInShopMenu then
			ESX.UI.Menu.CloseAll()

			DeleteShopInsideVehicles()

			local playerPed = PlayerPedId()

			FreezeEntityPosition(playerPed, false)
			Citizen.InvokeNative(0xEA1C610A04DB6BBB, playerPed, true)
			SetEntityCoords(playerPed, Config.Zones.ShopEntering.Pos.x, Config.Zones.ShopEntering.Pos.y, Config.Zones.ShopEntering.Pos.z)
		end
	end
end)

-- Create Blips
CreateThread(function ()

	for i=1, #Config.Blips, 1 do
		local currentBlip = Config.Blips[i]
		local blip = AddBlipForCoord(currentBlip.Coords)

		SetBlipSprite (blip, currentBlip.Sprite)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, currentBlip.Scale)
		SetBlipColour(blip, currentBlip.Color)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(currentBlip.Label)
		EndTextCommandSetBlipName(blip)
	end
end)

-- Display markers
CreateThread(function ()
	while true do
		Citizen.Wait(0)

		local coords, sleep = GetEntityCoords(PlayerPedId()), true

		for k,v in pairs(Config.Zones) do
			if(v.Type ~= -1 and #(coords - vec3(v.Pos.x, v.Pos.y, v.Pos.z)) < Config.DrawDistance) then
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
CreateThread(function ()
	while true do
		Citizen.Wait(0)

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
			TriggerEvent('esx_vehicleshop:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_vehicleshop:hasExitedMarker', LastZone)
		end
		if sleep then
			Citizen.Wait(500)
		end
	end
end)

-- Key controls
CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction == nil then
			Citizen.Wait(500)
		else

			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, Keys['E']) then
				if CurrentAction == 'shop_menu' then
					OpenShopMenu()
				elseif CurrentAction == 'boat_menu' then
					OpenBoatShopMenu()
				elseif CurrentAction == 'plane_menu' then
					OpenPlaneShopMenu()
				elseif CurrentAction == 'resell_vehicle' then
					ESX.TriggerServerCallback('esx_vehicleshop:resellVehicle', function(vehicleSold)
						if vehicleSold then
							ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
						else
							ESX.ShowNotification('~r~Ten pojazd nie należy do Ciebie')
						end
					end, CurrentActionData.plate, CurrentActionData.model, GetDisplayNameFromVehicleModel(CurrentActionData.model))
				end

				CurrentAction = nil
			end
		end
	end
end)

CreateThread(function()
	RequestIpl('shr_int') -- Load walls and floor

	local interiorID = 7170
	LoadInterior(interiorID)
	EnableInteriorProp(interiorID, 'csr_beforeMission') -- Load large window
	RefreshInterior(interiorID)
end)

function drawLoadingText(text, red, green, blue, alpha)
	SetTextFont(4)
	SetTextProportional(0)
	SetTextScale(0.0, 0.5)
	SetTextColour(red, green, blue, alpha)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)

	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.5, 0.5)
end