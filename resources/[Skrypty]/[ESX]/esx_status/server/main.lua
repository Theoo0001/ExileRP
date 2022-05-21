ESX                    = nil

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  	return
	end
	
	for _, xPlayer in pairs(ESX.Players) do
		local status = xPlayer.get('status')
		if status then
			ESX.Players[xPlayer.source] = status
		else
			MySQL.Async.fetchAll('SELECT status FROM users WHERE identifier = @identifier', {
				['@identifier'] = xPlayer.identifier
			}, function(result)
				local data = {}
		
				if result[1].status then
					data = json.decode(result[1].status)
				end
			
				xPlayer.set('status', data)	-- save to xPlayer for compatibility
				ESX.Players[xPlayer.source] = data -- save locally for performance
			end)
		end
		TriggerClientEvent('esx_status:load', xPlayer.source, data)
	end
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	MySQL.Async.fetchAll('SELECT status FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local data = {}

		if result[1].status then
			data = json.decode(result[1].status)
		end

		xPlayer.set('status', data)
		ESX.Players[xPlayer.source] = data
		TriggerClientEvent('esx_status:load', playerId, data)
	end)
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local status = ESX.Players[xPlayer.source]

	MySQL.Async.execute('UPDATE users SET status = @status WHERE identifier = @identifier', {
		['@status']     = json.encode(status),
		['@identifier'] = xPlayer.identifier
	}, function(result)
		ESX.Players[xPlayer.source] = nil
	end)
end)

AddEventHandler('esx_status:getStatus', function(playerId, statusName, cb)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	if xPlayer ~= nil then
		local status  = xPlayer.character.status
		
		for _, status in ipairs(status) do
			if status.name == statusName then
				cb(status)
				break
			end
		end
	end
end)

RegisterServerEvent('esx_status:update')
AddEventHandler('esx_status:update', function(status)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		xPlayer.set('status', status)	-- save to xPlayer for compatibility
		ESX.Players[xPlayer.source] = status	-- save locally for performance
	end
end)

CreateThread(function()
	while(true) do
		Citizen.Wait(10 * 60 * 1000)
		SaveData()
	end
end)

function SaveData()
	local updateStatement = 'UPDATE users SET status = (case %s end) where identifier in (%s)'
	local whenList = ''
	local whereList = ''
	local firstItem = true
	local playerCount = 0

	local xPlayers = ESX.GetExtendedPlayers()
	
	for _, xPlayer in pairs(xPlayers) do
		local status = ESX.Players[xPlayer.source]
		if status then
			whenList = whenList .. string.format('when identifier = \'%s\' then \'%s\' ', xPlayer.identifier, json.encode(status))

			if firstItem == false then
				whereList = whereList .. ', '
			end
			whereList = whereList .. string.format('\'%s\'', xPlayer.identifier)

			firstItem = false
			playerCount = playerCount + 1
		end
		Citizen.Wait(1000)
	end

	if playerCount > 0 then
		local sql = string.format(updateStatement, whenList, whereList)
		MySQL.Async.execute(sql)

	end

end














ESX.RegisterUsableItem('gopro', function(source)
    local _source = source

    TriggerClientEvent('ls_gopro:goproMenu', _source)
end)

RegisterServerEvent('ls_gopro:destroyItem')
AddEventHandler('ls_gopro:destroyItem', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    xPlayer.removeInventoryItem('gopro', 1)
end)