ESX                             = nil
local PlayerData                = {}
local open 						= false
local societyMoney, isOpened 	= 0, false

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

local function drawHint(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterNUICallback('wygrana', function(data)
	ESX.ShowNotification("Wygrałeś ~g~" .. data.win .. "$!")
end)

function KeyboardInput(textEntry, inputText, maxLength)
    AddTextEntry('FMMC_KEY_TIP1', textEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", inputText, "", "", "", maxLength)

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        return result
    else
        Citizen.Wait(500)
        return nil
    end
end

function GetCasinoMoney()
	return societyMoney
end

RegisterNetEvent(GetCurrentResourceName() .. ':updateSociety')
AddEventHandler(GetCurrentResourceName() .. ':updateSociety', function(value)
	societyMoney = value
end)

RegisterNetEvent(GetCurrentResourceName() .. ':updateSlots')
AddEventHandler(GetCurrentResourceName() .. ':updateSlots', function(lei)
	SetNuiFocus(true, true)
	open = true
	SendNUIMessage({
		showPacanele = "open",
		coinAmount = tonumber(lei)
	})
end)

RegisterNUICallback("zajebkase", function(ile) 
	TriggerServerEvent(GetCurrentResourceName() .. ':takeMoney', math.floor(ile.ile))
end)

RegisterNUICallback('exitWith', function(data, cb)
	cb('ok')
	SetNuiFocus(false, false)
	open = false
	TriggerServerEvent(GetCurrentResourceName() .. ':reward', math.floor(data.coinAmount))
end)

CreateThread(function ()
	while true do
		Citizen.Wait(1)
		if open then
			DisableControlAction(0, 1, true) -- LookLeftRight
			DisableControlAction(0, 2, true) -- LookUpDown
			DisableControlAction(0, 24, true) -- Attack
			DisablePlayerFiring(PlayerPedId(), true) -- Disable weapon firing
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
		else
			Citizen.Wait(500)
		end
	end
end)

CreateThread(function()
	Citizen.Wait(5000)
	while true do
		Citizen.Wait(3)
		ESX.TriggerServerCallback(GetCurrentResourceName() .. ':checkSociety', function(cb)
			societyMoney = cb.money
			isOpened = cb.opened
		end)
		Citizen.Wait(120000)
	end
end)

CreateThread(function()
	while PlayerData.job == nil do
		Citizen.Wait(100)
	end
	while true do
		Citizen.Wait(1)
		local found = false
		local coords = GetEntityCoords(PlayerPedId())
		if PlayerData.job.name == 'casino' and PlayerData.job.grade >= 5 then
			local dis = #(coords - vec3(Config.Casino.x, Config.Casino.y, Config.Casino.z))
			if dis <= 2.0 then
				ESX.ShowHelpNotification('Naciśnij ~INPUT_PICKUP~, aby otworzyć lub zamknąć kasyno')
				ESX.DrawMarker(vec3(Config.Casino.x, Config.Casino.y, Config.Casino.z))
				found = true
				if IsControlJustReleased(1, 38) then
					ESX.TriggerServerCallback(GetCurrentResourceName() .. ':casinoState', function(cb)
						ESX.ShowNotification('Za chwilę ~y~kasyno ~w~zostanie ' .. cb)
						ESX.UI.Menu.Open(
							'default', GetCurrentResourceName(), 'yesorno',
							{
								title = "Czy chcesz wysłać powiadomienie na wiadomościach?",
								align = 'center',
								elements = {
									{label = "Nie", value = 'no'},
									{label = "Tak", value = 'yes'}
								}
							},function(data, menu)
								if data.current.value == 'yes' then
									if cb == '~g~otwarte' then
										TriggerServerEvent(GetCurrentResourceName() .. ':sendNews', 'Casino Royale', 'Ruletka w grze! Zapraszamy do Casino Royale!')
									else
										TriggerServerEvent(GetCurrentResourceName() .. ':sendNews', 'Casino Royale', 'Kasyno niedługo zostanie zamknięte. Zapraszamy ponownie!')
									end
									menu.close()
								elseif data.current.value == 'no' then
									menu.close()
								end
							end,
							function(data, menu)
								menu.close()
							end
						)
					end)
				end
			elseif dis <= 20.0 then
				found = true
				ESX.DrawMarker(vec3(Config.Casino.x, Config.Casino.y, Config.Casino.z))
			end
		end
		if isOpened then
			for i=1, #Config.Sloty do
				local dis = #(coords - vec3(Config.Sloty[i].x, Config.Sloty[i].y, Config.Sloty[i].z))
				if dis <= 1.0 then
					ESX.ShowHelpNotification('Naciśnij ~INPUT_PICKUP~, aby spróbować szczęścia na slotach!')
					ESX.DrawMarker(vec3(Config.Ruletka[i].x, Config.Ruletka[i].y, Config.Ruletka[i].z - 0.8))
					found = true
					if IsControlJustReleased(1, 38) then
						TriggerServerEvent(GetCurrentResourceName() .. ':bet')
					end
				elseif dis <= 10.0 then
					found = true
					ESX.DrawMarker(vec3(Config.Ruletka[i].x, Config.Ruletka[i].y, Config.Ruletka[i].z - 0.8))
				end
			end
			for i=1, #Config.Ruletka do
				local dis = #(coords - vec3(Config.Ruletka[i].x, Config.Ruletka[i].y, Config.Ruletka[i].z))
				if dis <= 2.0 then
					ESX.ShowHelpNotification('Naciśnij ~INPUT_PICKUP~, aby obstawić ruletkę!')
					ESX.DrawMarker(vec3(Config.Ruletka[i].x, Config.Ruletka[i].y, Config.Ruletka[i].z - 0.8))
					found = true
					if IsControlJustReleased(1, 38) then
						TriggerEvent('exile_casino:rouletteStart')
					end
				elseif dis <= 10.0 then
					found = true
					ESX.DrawMarker(vec3(Config.Ruletka[i].x, Config.Ruletka[i].y, Config.Ruletka[i].z - 0.8))
				end
			end
			for i=1, #Config.Blackjack do
				local dis = #(coords - vec3(Config.Blackjack[i].x, Config.Blackjack[i].y, Config.Blackjack[i].z))
				if dis <= 2.0 then
					ESX.ShowHelpNotification('Naciśnij ~INPUT_PICKUP~, aby zagrać w BlackJacka')
					ESX.DrawMarker(vec3(Config.Ruletka[i].x, Config.Ruletka[i].y, Config.Ruletka[i].z - 0.8))
					found = true
					if IsControlJustReleased(1, 38) then
						TriggerEvent('exile_casino:blackjackStart')
					end
				elseif dis <= 10.0 then
					ESX.DrawMarker(vec3(Config.Ruletka[i].x, Config.Ruletka[i].y, Config.Ruletka[i].z - 0.8))
					found = true
				end
			end
		end
		if found == false then
			Citizen.Wait(2000)
		end
	end
end)

local heading = 148.63
local vehicle = nil

CreateThread(function()
	while true do
		Citizen.Wait(10)
		local sleep = true
		if #(GetEntityCoords(PlayerPedId()) - vec3(935.23, 42.28, 71.57)) < 40 then
			sleep = false
			if DoesEntityExist(vehicle) == false then
				RequestModel(`issi3`)
				while not HasModelLoaded(`issi3`) do
					Wait(1)
				end
				vehicle = Citizen.InvokeNative(0xAF35D0D2583051B0, `issi3`, 935.23, 42.28, 71.57, heading, false, false)
				FreezeEntityPosition(vehicle, true)
				SetEntityInvincible(vehicle, true)
				SetEntityCoords(vehicle, 953.77, 70.03, 75.83, false, false, false, true)
				local props = ESX.Game.GetVehicleProperties(vehicle)
				props['wheelColor'] = 147
				props['plate'] = "ZLODZIEJ"
				ESX.Game.SetVehicleProperties(vehicle, props)
			else
				SetEntityHeading(vehicle, heading)
				heading = heading+0.1
			end
		end
		if sleep then
			Citizen.Wait(500)
		end
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(10000)
		if vehicle ~= nil and #(GetEntityCoords(PlayerPedId()) - vec3(935.23, 42.28, 71.57)) < 40 then
			SetEntityCoords(vehicle, 935.23, 42.28, 71.57, false, false, false, true)
		end
	end
end)