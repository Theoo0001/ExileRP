local potrzebniPolicjanci = 0 		--<< potrzebni policjanci do aktywacji misji
local CenaNadajnika = 2500

-----------------------------------
ESX = nil
Events = {}

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj)
	ESX = obj
end)

RegisterServerEvent('tostauto:przerobilSkasujitem')
AddEventHandler('tostauto:przerobilSkasujitem', function(rodzaj)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if rodzaj == 'farba' then
		xPlayer.removeInventoryItem('carfarba', 1)
	elseif rodzaj == 'nadajnik' then
		xPlayer.removeInventoryItem('carnadajnik', 1)
	elseif rodzaj == 'tablica' then
		xPlayer.removeInventoryItem('carrej', 1)
	elseif rodzaj == 'dok' then
		xPlayer.removeInventoryItem('cardok', 1)
	end


end)


RegisterServerEvent('tostauto:zawiadompsy')
AddEventHandler('tostauto:zawiadompsy', function(x, y, z) 
    TriggerClientEvent('tostauto:kradziezLspd', -1, x, y, z)
end)

RegisterServerEvent('tostauto:zawiadompsy2')
AddEventHandler('tostauto:zawiadompsy2', function(x, y, z, plate, klasa, car) 
    TriggerClientEvent('tostauto:kradziezLspd2', -1, x, y, z, plate, klasa, car)
end)

RegisterServerEvent('tostauto:zawiadompsy3')
AddEventHandler('tostauto:zawiadompsy3', function(x, y, z) 
    TriggerClientEvent('tostauto:kradziezLspd3', -1, x, y, z)
end)

RegisterServerEvent('tostauto:sprawdzLspdNaKoniec')
AddEventHandler('tostauto:sprawdzLspdNaKoniec', function()
	local cops = exports['esx_scoreboard']:CounterPlayers('police')
	if cops >= potrzebniPolicjanci then
		TriggerClientEvent('tostauto:pozwolWykonacKradziezKoncowa', source)
	else
		TriggerClientEvent('esx:showNotification', source, '~r~Potrzeba przynajmniej ~g~'..potrzebniPolicjanci.. '~r~ SASP aby aktywować misję.')
	end
end)

RegisterServerEvent('tostukrad:ukonczonoetap')
AddEventHandler('tostukrad:ukonczonoetap', function(etap)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local blackMoney = xPlayer.getAccount('black_money').money
	
	if etap == 'etap1' then
		xPlayer.addInventoryItem('carrej', 1)
		xPlayer.addInventoryItem('cardok', 1)
		Wait(500)
	elseif etap == 'etap2' then
		xPlayer.addInventoryItem('carfarba', 1)
		TriggerClientEvent('esx:showNotification', source, '~g~Ukradłeś farbę.')
		TriggerClientEvent("tostauto:doneEtap2", _source)
		Wait(500)
	elseif etap == 'etap21' then
		if blackMoney < CenaNadajnika then
			TriggerClientEvent('esx:showNotification', source, '~y~Potrzebujesz '..CenaNadajnika..'$ brudnej gotówki aby zakupić nadajnik.')
		else
			xPlayer.removeAccountMoney('black_money', CenaNadajnika)
			xPlayer.addInventoryItem('carnadajnik', 1)
			TriggerClientEvent('esx:showNotification', source, '~g~Zakupiłeś nowy nadajnik.')
			TriggerClientEvent("tostauto:udanyZakupNadajnika", _source)
			if Events[xPlayer.source] == nil then
				Events[xPlayer.source] = true
			end
		end
	end
end)

RegisterServerEvent('exile_carholdup:sellVehicle')
AddEventHandler('exile_carholdup:sellVehicle', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local reward = math.random(200000, 230000)

	if Events[xPlayer.source] ~= nil then
		xPlayer.addMoney(reward)
		xPlayer.showNotification('Pomyślnie sprzedano pojazd za ~g~'..reward..'$')
		exports['exile_logs']:SendLog(_source, "NAPAD AUTO: Za sprzedaz auta zarobił: "..reward, 'holdup')
		Events[xPlayer.source] = nil
	else
		TriggerEvent("csskrouble:banPlr", "nigger", source,  "Tried to add money (exile_carholdup)")
		--exports['exile_logs']:SendLog(_source, "NAPAD AUTO: Wykryto próbe dodania pieniędzy bez zrobienia misji", 'anticheat')
	end
end)



