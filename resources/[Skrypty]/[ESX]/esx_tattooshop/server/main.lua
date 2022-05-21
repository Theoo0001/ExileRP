ESX = nil

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

AddEventHandler('esx:playerLoaded',function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer ~= nil then
		MySQL.Async.fetchAll('SELECT tattoos FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier,
		}, function(status)
			if status[1] ~= nil then
				if status[1].tattoos ~= nil and status[1].tattoos ~= '' then
					TriggerClientEvent('esx_tattooshop:setTattoos', _source, json.decode(status[1].tattoos))
				else
					TriggerClientEvent('esx_tattooshop:setTattoos', _source, {})
				end			
			else
				TriggerClientEvent('esx_tattooshop:setTattoos', _source, {})
			end
		end)		
	end
end)

ESX.RegisterServerCallback('esx_tattooshop:getTattoos', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer ~= nil then
		MySQL.Async.fetchAll('SELECT tattoos FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			if result[1].tattoos ~= nil and result[1].tattoos ~= '' then
				cb(json.decode(result[1].tattoos))
			else
				cb({})
			end
		end)	
	end
end)

ESX.RegisterServerCallback('esx_tattooshop:requestPlayerTattoos', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		MySQL.Async.fetchAll('SELECT tattoos FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			if result[1].tattoos ~= nil and result[1].tattoos ~= '' then
				cb(json.decode(result[1].tattoos))		
			else
				cb({})
			end
		end)
	else
		cb({})
	end
end)

ESX.RegisterServerCallback('esx_tattooshop:purchaseTattoo', function(source, cb, tattooList, price, tattoo)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= price then
		xPlayer.removeMoney(price)

		table.insert(tattooList, tattoo)

		MySQL.Async.execute('UPDATE users SET tattoos = @tattoos WHERE identifier = @identifier', {
			['@tattoos'] = json.encode(tattooList),
			['@identifier'] = xPlayer.identifier
		}, function()
			xPlayer.setCharacter('tattoos', json.encode(tattoosList))
			TriggerClientEvent('esx:showNotification', source, _U('bought_tattoo', ESX.Math.GroupDigits(price)))
			cb(true)		
		end)
	else
		local missingMoney = price - xPlayer.getMoney()
		TriggerClientEvent('esx:showNotification', source, _U('not_enough_money', ESX.Math.GroupDigits(missingMoney)))
		cb(false)
	end
end)