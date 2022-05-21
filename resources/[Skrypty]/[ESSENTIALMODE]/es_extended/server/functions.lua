ESX.Trace = function(msg)
	if Config.EnableDebug then

	end
end

ESX.SetTimeout = function(msec, cb)
	local id = ESX.TimeoutCount + 1

	SetTimeout(msec, function()
		if ESX.CancelledTimeouts[id] then
			ESX.CancelledTimeouts[id] = nil
		else
			cb()
		end
	end)

	ESX.TimeoutCount = id

	return id
end

ESX.ItemsToUpdate = {}

ESX.RegisterCommand = function(name, group, cb, allowConsole, suggestion)
	if type(name) == 'table' then
		for k,v in ipairs(name) do
			ESX.RegisterCommand(v, group, cb, allowConsole, suggestion)
		end

		return
	end

	if ESX.RegisteredCommands[name] then

		if ESX.RegisteredCommands[name].suggestion then
			TriggerClientEvent('chat:removeSuggestion', -1, ('/%s'):format(name))
		end
	end

	if suggestion then
		if not suggestion.arguments then suggestion.arguments = {} end
		if not suggestion.help then suggestion.help = '' end

		TriggerClientEvent('chat:addSuggestion', -1, ('/%s'):format(name), suggestion.help, suggestion.arguments)
	end

	ESX.RegisteredCommands[name] = {group = group, cb = cb, allowConsole = allowConsole, suggestion = suggestion}

	RegisterCommand(name, function(playerId, args, rawCommand)
		local command = ESX.RegisteredCommands[name]

		if not command.allowConsole and playerId == 0 then
		
		else
			local xPlayer, error = ESX.GetPlayerFromId(playerId), nil

			if command.suggestion then
				if command.suggestion.validate then
					if #args ~= #command.suggestion.arguments then
						error = _U('commanderror_argumentmismatch', #args, #command.suggestion.arguments)
					end
				end

				if not error and command.suggestion.arguments then
					local newArgs = {}

					for k,v in ipairs(command.suggestion.arguments) do
						if v.type then
							if v.type == 'number' then
								local newArg = tonumber(args[k])

								if newArg then
									newArgs[v.name] = newArg
								else
									error = _U('commanderror_argumentmismatch_number', k)
								end
							elseif v.type == 'player' or v.type == 'playerId' then
								local targetPlayer = tonumber(args[k])

								if args[k] == 'me' then targetPlayer = playerId end

								if targetPlayer then
									local xTargetPlayer = ESX.GetPlayerFromId(targetPlayer)

									if xTargetPlayer then
										if v.type == 'player' then
											newArgs[v.name] = xTargetPlayer
										else
											newArgs[v.name] = targetPlayer
										end
									else
										error = _U('commanderror_invalidplayerid')
									end
								else
									error = _U('commanderror_argumentmismatch_number', k)
								end
							elseif v.type == 'string' then
								newArgs[v.name] = args[k]
							elseif v.type == 'item' then
								if ESX.Items[args[k]] then
									newArgs[v.name] = args[k]
								else
									error = _U('commanderror_invaliditem')
								end
							elseif v.type == 'weapon' then
								if ESX.GetWeapon(args[k]) then
									newArgs[v.name] = string.upper(args[k])
								else
									error = _U('commanderror_invalidweapon')
								end
							elseif v.type == 'any' then
								newArgs[v.name] = args[k]
							end
						end

						if error then break end
					end

					args = newArgs
				end
			end

			if error then
				if playerId == 0 then
				else
					xPlayer.triggerEvent('chat:addMessage', {args = {'^1SYSTEM', error}})
				end
			else
				cb(xPlayer or false, args, function(msg)
					if playerId == 0 then
					else
						xPlayer.triggerEvent('chat:addMessage', {args = {'^1SYSTEM', msg}})
					end
				end)
			end
		end
	end, true)

	if type(group) == 'table' then
		for k,v in ipairs(group) do
			ExecuteCommand(('add_ace group.%s command.%s allow'):format(v, name))
		end
	else
		ExecuteCommand(('add_ace group.%s command.%s allow'):format(group, name))
	end
end

ESX.ClearTimeout = function(id)
	ESX.CancelledTimeouts[id] = true
end

ESX.RegisterServerCallback = function(name, cb)
	ESX.ServerCallbacks[name] = cb
end

ESX.TriggerServerCallback = function(name, requestId, source, cb, ...)
	if ESX.ServerCallbacks[name] then
		ESX.ServerCallbacks[name](source, cb, ...)
	end
end

ESX.SavePlayer = function(xPlayer, cb)
	local asyncTasks = {}

	if xPlayer ~= nil then
		table.insert(asyncTasks, function(cb2)
			MySQL.Async.execute('UPDATE users SET accounts = @accounts, job = @job, job_grade = @job_grade, hiddenjob = @hiddenjob, slot = @slot, hiddenjob_grade = @hiddenjob_grade, dealerLevel = @dealerLevel, `group` = @group, position = @position, inventory = @inventory WHERE identifier = @identifier', {
				['@accounts'] = json.encode(xPlayer.getAccounts(true)),
				['@job'] = xPlayer.job.name,
				['@job_grade'] = xPlayer.job.grade,
				['@hiddenjob'] = xPlayer.hiddenjob.name,
				['@slot'] = json.encode(xPlayer.getSlots()),
				['@hiddenjob_grade'] = xPlayer.hiddenjob.grade,
				['@dealerLevel'] = json.encode(xPlayer.getDealerLevel()),
				['@group'] = xPlayer.getGroup(),
				['@position'] = json.encode(xPlayer.getCoords()),
				['@identifier'] = xPlayer.getIdentifier(),
				['@inventory'] = json.encode(xPlayer.getInventory(true)),
			}, function(rowsChanged)
				cb2()
			end)
		end)

		Async.parallel(asyncTasks, function(results)

			if cb then
				cb()
			end
		end)
	end
end

ESX.SavePlayers = function(cb)
	local xPlayers, asyncTasks = ESX.GetExtendedPlayers(), {}

	for i=1, #xPlayers, 1 do
		table.insert(asyncTasks, function(cb2)
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			ESX.SavePlayer(xPlayer, cb2)
		end)
	end

	Async.parallelLimit(asyncTasks, 8, function(results)
		if cb then
			cb()
		end
	end)
end

ESX.StartDBSync = function()
	function saveData()
		ESX.SavePlayers()
		ESX.SaveItems()
		SetTimeout(15 * 60 * 1000, saveData)
	end
	SetTimeout(15 * 60 * 1000, saveData)
end

--[[ESX.GetPlayers = function()
	local sources = {}

	for k,v in pairs(ESX.Players) do
		table.insert(sources, k)
	end

	return sources
end]]

--[[ESX.GetExtendedPlayers = function()
	local sources = {}

	for k,v in pairs(ESX.Players) do
		table.insert(sources, k)
	end

	return sources
end]]

--[[ESX.GetExtendedPlayers = function(key, val)
	local xPlayers = {}
	for k, v in pairs(ESX.Players) do
		if key then
			if (key == 'job' and v.job.name == val) or v[key] == val then
				table.insert(xPlayers, v)
			end
		else
			table.insert(xPlayers, v)
		end
	end
	return xPlayers
end]]

function ESX.GetPlayers()
	local sources = {}

	for k,v in pairs(ESX.Players) do
		sources[#sources + 1] = k
	end

	return sources
end	

ESX.GetExtendedPlayers = function(key, val)
	local xPlayers = {}
	for k, v in pairs(ESX.Players) do
		if key then
			if (key == 'job' and v.job.name == val) or v[key] == val then
				xPlayers[#xPlayers + 1] = v
			end
		else
			xPlayers[#xPlayers + 1] = v
		end
	end
	return xPlayers
end

ESX.GetPlayerFromId = function(source)
	return ESX.Players[tonumber(source)]
end

ESX.GetPlayerFromIdentifier = function(identifier)
	for k,v in pairs(ESX.Players) do
		if v.identifier == identifier then
			return v
		end
	end
end

ESX.RegisterUsableItem = function(item, cb)
	ESX.UsableItemsCallbacks[item] = cb
end

ESX.UseItem = function(source, item)
	ESX.UsableItemsCallbacks[item](source)
end

ESX.GetItemLabel = function(item)
	if ESX.Items[item] then
		return ESX.Items[item].label
	end
end

ESX.DoesJobExist = function(job, grade)
	grade = tostring(grade)

	if job and grade then
		if ESX.Jobs[job] and ESX.Jobs[job].grades[grade] then
			return true
		end
	end

	return false
end

function GenerateId()
	math.randomseed(math.random(1111111111, 9999999999))
	local id = tostring(math.random(1111111111, 9999999999))
	
	local function Generate(id)
		if ESX.Items[id] then
			return Generate(tostring(math.random(1111111111, 9999999999)))
		end
	end
	
	Generate(id)
	
	return id
end

function GenerateSerialNumber()
	math.randomseed(math.random(1111111111, 9999999999))
	local id = tostring(math.random(1111111111, 9999999999))
	
	return id
end

function GeneratePhoneNumber()
	math.randomseed(math.random(1111111111, 9999999999))
	local id = tostring(math.random(111111, 999999))
	
	local function Generate(id)
		if ESX.Items[id] then
			return Generate(tostring(math.random(111111, 999999)))
		end
	end
	
	Generate(id)
	
	return id
end

ESX.DeleteDynamicItem = function(item)
	if ESX.Items[item] then
	    MySQL.Async.execute('DELETE FROM items WHERE `name` = @name', {
        ['@name']  = item
		}, function()
			ESX.Items[item] = nil
			
			TriggerEvent('esx_addoninventory:DynamicItem', false, {name = item})
		end)		
	end
end

ESX.CreateDynamicItem = function(data, cb)
	if data ~= nil then
		if data.type == 'weapon' then
			local SpecialID = GenerateId()
			
			ESX.Items[SpecialID] = {
				label = data.label,
				limit  = 1,
				rare = 0,
				canRemove = 1,
				type = 'weapon',
				data = {
					name = data.name,
					serial_number = (data.serial == true and GenerateSerialNumber() or false),
					components = {},
					tintIndex = 0,
					ammo = data.ammo
				}
			}
			
			if cb then
				cb(SpecialID)
			end
			
			TriggerEvent('esx_addoninventory:DynamicItem', true, {name = SpecialID, label = data.label, type = 'weapon'})
			
			SaveItemToDb(ESX.Items[SpecialID], SpecialID)
			
		elseif data.type == 'sim' then
			local SpecialID, PhoneNumber = GenerateId(), GeneratePhoneNumber()
			
			ESX.Items[SpecialID] = {
				label = 'Karta SIM #'..(data.number == nil and PhoneNumber or data.number),
				limit  = 1,
				rare = 0,
				canRemove = 1,
				type = 'sim',
				data = {	
					name = SpecialID,
					number = (data.number == nil and PhoneNumber or data.number),
					owner = data.owner,
					ownerdigit = data.ownerdigit,
					blocked = data.blocked,
					admin1 = data.admin1,
					admindigit1 = data.admindigit1,			

					admin2 = data.admin2,
					admindigit2 = data.admindigit2,
					mainsim = (data.number == nil and true or false)
				}
			}
			
			if cb then
				cb(SpecialID, PhoneNumber)
			end
			
			TriggerEvent('esx_addoninventory:DynamicItem', true, {name = SpecialID, label = 'Karta SIM #'..(data.number == nil and PhoneNumber or data.number)})
			
			SaveItemToDb(ESX.Items[SpecialID], SpecialID)		
		end
	end
end

function SaveItemToDb(data, name)
	if data then
		MySQL.Async.execute("INSERT INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`, `data`, `type`) VALUES (@name, @label, @limit, @rare, @can_remove, @data, @type)",  {
			['@name'] = name,
			['@label'] = data.label,
			['@limit'] = data.limit,
			['@rare'] = data.rare,
			['@can_remove'] = data.canRemove,
			['@data'] = json.encode(data.data),
			['@type'] = data.type,
		})
	end
end

RegisterNetEvent('esx:updateItem')
AddEventHandler('esx:updateItem', function(item, key, value)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer ~= nil then
		for k,v in pairs(xPlayer.getInventory(false)) do
			if v.name == item then
				v.data[key] = value
			end
		end		
		
		if ESX.Items[item] then
			ESX.Items[item].data[key] = value
			
			ESX.ItemsToUpdate[item] = true
		end
		
	end
end)

ESX.GetItems = function()
	return ESX.Items
end

ESX.SetItemsData = function(item, key, value)
	if ESX.Items[item] then
		ESX.Items[item].data[key] = value
		
		ESX.ItemsToUpdate[item] = true
	end
end

RegisterNetEvent('esx:updateItemMultiple')
AddEventHandler('esx:updateItemMultiple', function(data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer ~= nil then
		for k,v in pairs(data) do			
			for k2,v2 in pairs(xPlayer.getInventory(false)) do
				if k == v2.name then
					v2.data.ammo = v
					
					ESX.ItemsToUpdate[v2.name] = true
				end
			end		
		end
	end
end)

ESX.SaveItems = function()
	local asyncTasks = {}
	
	for name, value in pairs(ESX.ItemsToUpdate) do
		if value then
			table.insert(asyncTasks, function(cb2)
				ESX.SaveItem(name, cb2)
			end)
		end
	end

	Async.parallelLimit(asyncTasks, 8, function(results)
		ESX.ItemsToUpdate = {}
		
		if cb then
			cb()
		end
	end)	
end

ESX.SaveItem = function(name, cb)
	local asyncTasks = {}

	if name ~= nil then
		table.insert(asyncTasks, function(cb2)
			local data = ESX.Items[name]
			
			if data ~= nil then
				MySQL.Async.execute('UPDATE items SET data = @data WHERE `name` = @name', {
					['@name'] = name,
					['@data'] = json.encode(data.data)
				}, function(rowsChanged)				
					cb2()
				end)
			else
				cb2()
			end
		end)

		Async.parallel(asyncTasks, function(results)

			if cb then
				cb()
			end
		end)
	end
end

RegisterNetEvent('es_extended:DoUpdateItems')
AddEventHandler('es_extended:DoUpdateItems', function()
	ESX.SaveItems()
end)