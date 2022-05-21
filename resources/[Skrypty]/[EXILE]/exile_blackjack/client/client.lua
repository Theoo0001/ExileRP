ESX = nil
CreateThread(function()
	while ESX == nil do
		TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj)
			ESX = obj 
		end)
		
		Citizen.Wait(250)
	end
end)

RegisterNetEvent('exile_casino:blackjackStart')
AddEventHandler('exile_casino:blackjackStart', function()
	ESX.TriggerServerCallback(GetCurrentResourceName() .. ':checkMoney', function(quantity)
		if quantity >= 500 then
			SendNUIMessage({
				type = "enableui",
				enable = true,
				coins = quantity
			})
			SetNuiFocus(true, true)
		else
			ESX.ShowNotification('Potrzebujesz minimum 500$, aby zagrać')
		end
	end)
end)

RegisterNUICallback('escape', function(data, cb)
	cb('ok')
	SetNuiFocus(false, false)
	SendNUIMessage({
		type = "enableui",
		enable = false
	})
end)

RegisterNUICallback('card', function(data, cb)
	cb('ok')
	TriggerServerEvent('InteractSound_SV:PlayOnSource', 'PlayCard', 1.0)
end)

RegisterNUICallback('bet', function(data, cb)
	cb('ok')
	TriggerServerEvent('InteractSound_SV:PlayOnSource', 'betup', 1.0)
end)

RegisterNUICallback('escape2', function(data, cb)
	cb('ok')
	SetNuiFocus(false, false)
	SendNUIMessage({
		type = "enableui",
		enable = false
	})
	ESX.ShowNotification('~r~Kasyno zawsze wygrywa!')
end)

RegisterNUICallback('WinBet', function(data, cb)
	cb('ok')
	local count = data.bets
	TriggerServerEvent(GetCurrentResourceName() .. ':giveMoney', count, 2)
end)

RegisterNUICallback('TieBet', function(data, cb)
	cb('ok')
	local count = data.bets
	TriggerServerEvent(GetCurrentResourceName() .. ':giveMoney', count, 1)
end)

RegisterNUICallback('LostBet', function(data, cb)
	cb('ok')
	local count = data.bets
	ESX.ShowNotification('Przegrałeś ' .. count .. '$')
end)

RegisterNUICallback('Status', function(data, cb)
	cb('ok')
	ESX.ShowNotification(data.tekst)
end)

RegisterNUICallback('StartPartia', function(data, cb)
	cb('ok')
	local count = data.bets
	TriggerServerEvent(GetCurrentResourceName() .. ':removeMoney', count)
end)