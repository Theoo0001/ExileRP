ESX = nil

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('xk3ly-bodycam:getPlayerName', function(source, cb)
	local data = {
		name = GetCharacterName(source),
	}
	cb(data)
end)

function GetCharacterName(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	local badge = json.decode(xPlayer.character.job_id)
	local odznaka = ''
	if xPlayer ~= nil then
		if badge.id == 0 then
			odznaka = '[Empty]'
		else
			odznaka = '['..badge.id..']'
		end
		return ('%s %s %s'):format(xPlayer.character.firstname, xPlayer.character.lastname, odznaka)
	else
		return ('%s %s %s'):format('Brak', 'Brak', '[Empty]')
	end
end

RegisterServerEvent('bodycam:save')
AddEventHandler('bodycam:save', function(time)	
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer ~= nil then
		MySQL.Async.fetchAll('SELECT time FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(timee)
			if timee[1] ~= nil then
				MySQL.Async.execute('UPDATE users SET time = @time WHERE identifier = @identifier', {
					['@identifier']   = xPlayer.identifier,
					['@time'] = timee[1].time + time
				})	
			end
		end)	
	end
end)