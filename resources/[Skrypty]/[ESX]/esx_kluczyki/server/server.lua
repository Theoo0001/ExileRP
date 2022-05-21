ESX = nil
TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

owners = {}

MySQL.ready(function()
    MySQL.Async.fetchAll("SELECT plate, owner, digit FROM owned_vehicles", {
	
	}, function(data)
        for k,v in pairs(data) do
			if type(v.plate) == 'string' then
				plate = string.lower(v.plate:gsub("%s$", ""))
			end
			table.insert(owners, {owner = {identifier = v.owner, digit = v.digit}, plate = plate, locked = false})
        end
    end)	
end)

RegisterServerEvent('esx_kluczyki:giveKeysAction')
AddEventHandler('esx_kluczyki:giveKeysAction', function(player, plate)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local hasKey = false
	local locked = false
	
	

    for k,v in ipairs(owners) do
        if v.plate == string.lower(plate) and v.owner.identifier == xPlayer.identifier and v.owner.digit == xPlayer.digit then
            hasKey = true
			locked = v.locked
            break
        end
    end
	
	if hasKey then
		local xPlayer2 = ESX.GetPlayerFromId(player)
		if xPlayer2 ~= nil then
			if plate ~= nil and xPlayer ~= nil and xPlayer2 ~= nil then
				table.insert(owners, {owner = {identifier = xPlayer2.identifier, digit = xPlayer2.digit}, plate = string.lower(plate), locked = locked})
				TriggerClientEvent('ls:notify', xPlayer.source, 'Podarowałeś kluczyki do pojazdu', '~y~Nr rej.~s~: '..plate)
				TriggerClientEvent('ls:notify', xPlayer2.source, 'Otrzymałeś kluczyki do pojazdu', '~y~Nr rej.~s~: '..plate)
			end
		end
	else
		xPlayer.showNotification('~r~Nie posiadsz zapasowych kluczy')
	end
end)

ESX.RegisterServerCallback('ls:hasKey', function(source, cb, plate)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local hasKey = false
	
	 for k,v in ipairs(owners) do
		if v.plate == string.lower(plate) and v.owner.identifier == xPlayer.identifier and v.owner.digit == xPlayer.digit then
			hasKey = true
			break
		end
	 end
	 
	 cb(hasKey)
end)

ESX.RegisterServerCallback('ls:check', function(source, cb, plate)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local hasKey = false
	local locked = false
	local hasOwner = false
		
    for k,v in ipairs(owners) do
        if v.plate == string.lower(plate) then
			hasOwner = v.owner.identifier ~= false
			locked = v.locked
		
			if v.owner.identifier == xPlayer.identifier and v.owner.digit == xPlayer.digit then
				hasKey = true
				break
			end
		end
    end
	
	cb(hasKey, hasOwner, locked)
end)

ESX.RegisterServerCallback('csskrouble:getKeys', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer ~= nil then
		local z = {}
		for k,v in ipairs(owners) do
			if v.owner.identifier == xPlayer.getIdentifier() and v.owner.digit == xPlayer.getDigit() then
				table.insert(z, v)
			end
		end
		cb(z)
	else 
		cb({})
	end
end)

RegisterServerEvent("ls:addOwner")
AddEventHandler("ls:addOwner", function(platee, target)
	local src = nil
	
    if target == nil then
        src = source
    else
        src = target
    end
	
    local xPlayer = ESX.GetPlayerFromId(src)
	
    if platee ~= nil and xPlayer ~= nil then
        table.insert(owners, {owner = {identifier = xPlayer.identifier, digit = xPlayer.digit}, plate = string.lower(platee), locked = false})
    end
end)

RegisterServerEvent("ls:lockTheVehicle")
AddEventHandler("ls:lockTheVehicle", function(plate)
	local found = false
	for k,v in ipairs(owners) do
		if v.plate == string.lower(plate) then
			v.locked = true
			found = true
			break
		end
	end
	
	if not found then
		table.insert(owners, {owner = {identifier = false, digit = false}, plate = string.lower(plate:gsub("%s$", "")), locked = true})
	end
end)
