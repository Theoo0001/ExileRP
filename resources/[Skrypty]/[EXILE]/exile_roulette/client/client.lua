ESX = nil
CreateThread(function()
	while ESX == nil do
		TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj)
			ESX = obj 
		end)
		
		Citizen.Wait(250)
	end
end)
local blipX = -1400.94
local blipY = -605.00
local blipZ = 29.50
local pic = 'CHAR_SOCIAL_CLUB'
local game_during = false
local elements = {}

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterNetEvent('exile_casino:rouletteStart')
AddEventHandler('exile_casino:rouletteStart', function()
	ESX.TriggerServerCallback(GetCurrentResourceName() .. ':checkMoney', function(quantity)
		if quantity >= 200 then
			SendNUIMessage({
				type = "show_table",
				zetony = quantity
			})
			SetNuiFocus(true, true)
		else
			ESX.ShowNotification('~r~Potrzebujesz minimum 200$, aby zagrać')
			SendNUIMessage({
				type = "reset_bet"
			})
		end
	end)
end)

CreateThread(function()
	SetNuiFocus(false, false)
end)

RegisterNUICallback('exit', function(data, cb)
	cb('ok')
	SetNuiFocus(false, false)
end)

RegisterNUICallback('betup', function(data, cb)
	cb('ok')
	TriggerServerEvent('InteractSound_SV:PlayOnSource', 'betup', 1.0)
end)

RegisterNUICallback('roll', function(data, cb)
	cb('ok')
	TriggerEvent(GetCurrentResourceName() .. ':startGame', data.kolor, data.kwota)
end)

RegisterNetEvent(GetCurrentResourceName() .. ':startGame')
AddEventHandler(GetCurrentResourceName() .. ':startGame', function(action, amount)
	local amount = amount
	if game_during == false then
		TriggerServerEvent(GetCurrentResourceName() .. ':removeMoney', amount)
		local kolorBetu = action
		ESX.ShowNotification("Postawiłeś " .. amount .. " na " .. kolorBetu)
		game_during = true
		local casinoMoney = exports['exile_slots']:GetCasinoMoney()
		local red = {32,19,21,25,34,27,36,30,23,5,16,1,14,9,18,7,12,3};
		local black = {15,4,2,17,6,13,11,8,10,24,33,20,31,22,29,28,35,26};
		local chance = math.random(1,8)
		local randomNumber = nil
		if tonumber(amount) > tonumber(casinoMoney) then
			if action == 'red' then
				local randomValue = math.random(1, #black)
				randomNumber = tonumber(black[randomValue])
			elseif action == 'black' then
				local randomValue = math.random(1, #red)
				randomNumber = tonumber(red[randomValue])
			elseif action == 'green' then
				randomNumber = math.random(1, 35)
			end
		elseif (amount < 300000 and (chance == 2 or chance == 5)) or (amount >= 300000 and chance == 4) then
			if action == 'red' then
				local randomValue = math.random(1, #red)
				randomNumber = tonumber(red[randomValue])
			elseif action == 'black' then
				local randomValue = math.random(1, #black)
				randomNumber = tonumber(black[randomValue])
			elseif action == 'green' then
				randomNumber = math.random(0, 35)
			end		
		else
			if action == 'red' then
				local randomValue = math.random(1, #black)
				randomNumber = tonumber(black[randomValue])
			elseif action == 'black' then
				local randomValue = math.random(1, #red)
				randomNumber = tonumber(red[randomValue])
			elseif action == 'green' then
				randomNumber = math.random(1, 35)
			end
		end
		SendNUIMessage({
			type = "show_roulette",
			hwButton = randomNumber
		})
		TriggerServerEvent('InteractSound_SV:PlayOnSource', 'ruletka', 1.0)
		Citizen.Wait(10000)		
		local function has_value (tab, val)
			for index, value in ipairs(tab) do
				if value == val then
					return true
				end
			end
			return false
		end
		if action == 'black' then
			if has_value(black, randomNumber) then
				local win = amount * 2
				ESX.ShowNotification('Wygrałeś ' .. win .. '$')
				TriggerServerEvent(GetCurrentResourceName() .. ':giveMoney', action, amount)
			else
				ESX.ShowNotification('Nie udało się. Spróbuj jeszcze raz.')
			end
		elseif action == 'red' then
			local win = amount * 2
			if has_value(red, randomNumber) then
				ESX.ShowNotification('Wygrałeś ' .. win .. '$')
				TriggerServerEvent(GetCurrentResourceName() .. ':giveMoney', action, amount)
			else
				ESX.ShowNotification('Nie udało się. Spróbuj jeszcze raz.')
			end
		elseif action == 'green' then
			local win = amount * 14
			if randomNumber == 0 then
				ESX.ShowNotification('Wygrałeś ' .. win .. '$')
				TriggerServerEvent(GetCurrentResourceName() .. ':giveMoney', action, amount)
			else
				ESX.ShowNotification('Nie udało się. Spróbuj jeszcze raz.')
			end
		end
		SendNUIMessage({type = 'hide_roulette'})
		SetNuiFocus(false, false)
		game_during = false
		TriggerEvent('exile_casino:rouletteStart')
	end
end)