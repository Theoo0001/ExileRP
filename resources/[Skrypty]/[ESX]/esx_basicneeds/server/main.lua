ESX = nil
local onSamarka = {}

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('bread', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('bread', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 400000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('esx:showNotification', source, 'Zjadłeś/aś ~y~Chleb')
end)

ESX.RegisterUsableItem('tost', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('tost', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 440000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('esx:showNotification', source, 'Zjadłeś/aś ~y~Tosta')
end)

ESX.RegisterUsableItem('capricciosa', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('capricciosa', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 500000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('esx:showNotification', source, 'Zjadłeś/aś ~y~Capricciose')
end)

ESX.RegisterUsableItem('chipsy', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('chipsy', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 400000)
	TriggerClientEvent('esx_basicneeds:crisps', source)
	TriggerClientEvent('esx:showNotification', source, 'Zjadłeś/aś ~y~Chipsy')
end)

ESX.RegisterUsableItem('cupcake', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('cupcake', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 400000)
	TriggerClientEvent('esx_basicneeds:onEatCupCake', source)
	TriggerClientEvent('esx:showNotification', source, 'Zjadłeś/aś ~y~Babeczkę')
end)

ESX.RegisterUsableItem('hamburger', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('hamburger', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 450000)
	TriggerClientEvent('esx_basicneeds:hamburger', source)
	TriggerClientEvent('esx:showNotification', source, 'Zjadłeś/aś ~y~Hamburgera')
end)

ESX.RegisterUsableItem('chocolate', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('chocolate', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 400000)
	TriggerClientEvent('esx_basicneeds:onEatChocolate', source)
	TriggerClientEvent('esx:showNotification', source, 'Zjadłeś/aś ~y~Czekoladę')
end)

ESX.RegisterUsableItem('water', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('water', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 400000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, 'Wypiłeś/aś ~b~Wodę')
end)

ESX.RegisterUsableItem('gofry', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('gofry', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 400000)
	TriggerClientEvent('esx_basicneeds:onEatBaton', source)
	TriggerClientEvent('esx:showNotification', source, 'Zjadłeś/aś ~b~Gofry z cukrem pudrem')
end)

ESX.RegisterUsableItem('gofry2', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('gofry2', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 600000)
	TriggerClientEvent('esx_basicneeds:onEatBaton', source)
	TriggerClientEvent('esx:showNotification', source, 'Zjadłeś/aś ~b~Gofry z owocami')
end)

ESX.RegisterUsableItem('gofry3', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('gofry3', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 500000)
	TriggerClientEvent('esx_basicneeds:onEatBaton', source)
	TriggerClientEvent('esx:showNotification', source, 'Zjadłeś/aś ~b~Gofry z bitą śmietaną')
end)


ESX.RegisterUsableItem('roza', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerClientEvent('itemki-roza', source)
	xPlayer.removeInventoryItem('roza', 1)
	TriggerClientEvent('esx:showNotification', source, "Wyciągnięto ~r~roże")
end)

ESX.RegisterUsableItem('kocyk', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerClientEvent('itemki-kocyk', source)
	xPlayer.removeInventoryItem('kocyk', 1)
	TriggerClientEvent('esx:showNotification', source, "Rozłożono ~g~piknik")
end)

ESX.RegisterUsableItem('cola', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('cola', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 400000)
	TriggerClientEvent('esx_basicneeds:onCola', source)
	TriggerClientEvent('esx:showNotification', source, 'Wypiłeś/aś ~b~Coca-Cole')
end)

ESX.RegisterUsableItem('icetea', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('icetea', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 400000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, 'Wypiłeś/aś ~b~Ice Tea')
end)

ESX.RegisterUsableItem('milk', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('milk', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 400000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:showNotification', source, 'Wypiłeś/aś ~b~Mleko')
end)

ESX.RegisterUsableItem('kawa', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('kawa', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 400000)
	TriggerClientEvent('esx_basicneeds:onDrinkKawa', source)
end)

ESX.RegisterUsableItem('lekemeryt', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('lekemeryt', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 150000)
	TriggerClientEvent('esx_status:add', source, 'hunger', 150000)
	--TriggerClientEvent('esx_basicneeds:onDrinkKawa', source)
	TriggerClientEvent('esx:showNotification', source, 'Zażyłeś/aś ~b~Lek dla seniora 65+')
end)

ESX.RegisterUsableItem('orange', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('orange', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 150000)
	TriggerClientEvent('esx_status:add', source, 'hunger', 150000)
	TriggerClientEvent('esx_basicneeds:onEatFruit', source)
	TriggerClientEvent('esx:showNotification', source, 'Zjadłeś/aś ~b~Pomarańcze')
end)

ESX.RegisterUsableItem('samarka', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	onSamarka[source] = true

	xPlayer.removeInventoryItem('samarka', 1)

	TriggerClientEvent('esx_basicneeds:onSamarka', source)
	TriggerClientEvent('esx:showNotification', source, "Użyłeś/aś ~b~samarki")
end)

ESX.RegisterUsableItem('jablko', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('jablko', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 100000)
	TriggerClientEvent('esx_status:add', source, 'thirst', 100000)
	TriggerClientEvent('esx_basicneeds:onEatFruit', source)
	TriggerClientEvent('esx:showNotification', source, 'Zjadłeś/aś ~y~Jabłko ~w~czujesz słodko kwaśny posmak')
end)

ESX.RegisterUsableItem('cytryna', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('cytryna', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 180000)
	TriggerClientEvent('esx_status:add', source, 'thirst', 180000)
	TriggerClientEvent('esx_basicneeds:onEatFruit', source)
	TriggerClientEvent('esx:showNotification', source, 'Zjadłeś/aś ~y~Cytryne ~w~czujesz jej kwaśny posmak')
end)

ESX.RegisterUsableItem('winogrono', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('winogrono', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 300000)
	TriggerClientEvent('esx_status:add', source, 'thirst', 300000)
	TriggerClientEvent('esx_basicneeds:onEatFruit', source)
	TriggerClientEvent('esx:showNotification', source, 'Zjadłeś/aś ~y~Winogrono ~w~czujesz jego przyjemnny zapach')
end)

ESX.RegisterUsableItem('pomarancza', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('pomarancza', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 200000)
	TriggerClientEvent('esx_status:add', source, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:onEatFruit', source)
	TriggerClientEvent('esx:showNotification', source, 'Zjadłeś/aś ~y~Pomarańcze ~w~czujesz jej kwaśny posmak')
end)

ESX.RegisterUsableItem('mandarynka', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('mandarynka', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 150000)
	TriggerClientEvent('esx_status:add', source, 'thirst', 150000)
	TriggerClientEvent('esx_basicneeds:onEatFruit', source)
	TriggerClientEvent('esx:showNotification', source, 'Zjadłeś/aś ~y~Mandarynke ~w~czujesz jej świeży zapach')
end)

ESX.RegisterUsableItem('brzoskwinia', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('brzoskwinia', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 250000)
	TriggerClientEvent('esx_status:add', source, 'thirst', 250000)
	TriggerClientEvent('esx_basicneeds:onEatFruit', source)
	TriggerClientEvent('esx:showNotification', source, 'Zjadłeś/aś ~y~Brzoskwinie ~w~czujesz jej słodki posmak')
end)

RegisterServerEvent('esx_basicneeds:offSamarka')
AddEventHandler('esx_basicneeds:offSamarka', function()
	onSamarka[source] = false
end)

RegisterCommand('heal', function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		if xPlayer.group == 'best' or xPlayer.group == 'superadmin' or xPlayer.group == 'admin' or xPlayer.group == 'mod' or xPlayer.group == 'support' or xPlayer.group == 'trialsupport' then
			if args[1] then
				local target = tonumber(args[1])

				if target ~= nil then

					if GetPlayerName(target) then
						TriggerClientEvent('esx_basicneeds:healPlayer', target)
						local xPlayer2 = ESX.GetPlayerFromId(target)
						xPlayer2.showNotification('~g~Zostałeś/aś uleczony/a!')
						--exports['exile_logs']:SendLog(source, "Użyto komendy /heal " .. target, "revive")
					else
						xPlayer.showNotification('~r~Nie odnaleziono gracza')
					end
				else
					xPlayer.showNotification('~r~Nieprawidłowe ID')
				end
			else
				exports['exile_logs']:SendLog(source, "Użyto komendy /heal ", "revive")
				TriggerClientEvent('esx_basicneeds:healPlayer', source)
				xPlayer.showNotification('~g~Zostałeś/aś uleczony/a!')
			end
		else
			xPlayer.showNotification('~r~Nie posiadasz permisji')
		end
	end
end, false)

samarkaStatus = function(_source)
	return onSamarka[_source]
end