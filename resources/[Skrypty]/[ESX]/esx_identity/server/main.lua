ESX = nil

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

function getIdentity(source, callback)
	local identifier = ESX.GetPlayerFromId(source).identifier
	
	MySQL.Async.fetchAll('SELECT identifier, firstname, lastname, dateofbirth, sex, height FROM `users` WHERE `identifier` = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result[1].firstname ~= nil then
			local data = {
				identifier	= result[1].identifier,
				firstname	= result[1].firstname,
				lastname	= result[1].lastname,
				dateofbirth	= result[1].dateofbirth,
				sex			= result[1].sex,
				height		= result[1].height
			}

			callback(data)
		else
			local data = {
				identifier	= '',
				firstname	= '',
				lastname	= '',
				dateofbirth	= '',
				sex			= '',
				height		= ''
			}

			callback(data)
		end
	end)
end

function getCharacters(source, callback)
	local identifier = ESX.GetPlayerFromId(source).identifier
	MySQL.Async.fetchAll('SELECT * FROM `characters` WHERE `identifier` = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result[1] and result[2] and result[3] then

			local data = {
				identifier		= result[1].identifier,
				firstname1		= result[1].firstname,
				lastname1		= result[1].lastname,
				dateofbirth1	= result[1].dateofbirth,
				sex1			= result[1].sex,
				height1			= result[1].height,
				firstname2		= result[2].firstname,
				lastname2		= result[2].lastname,
				dateofbirth2	= result[2].dateofbirth,
				sex2			= result[2].sex,
				height2			= result[2].height,
				firstname3		= result[3].firstname,
				lastname3		= result[3].lastname,
				dateofbirth3	= result[3].dateofbirth,
				sex3			= result[3].sex,
				height3			= result[3].height
			}

			callback(data)

		elseif result[1] and result[2] and not result[3] then

			local data = {
				identifier		= result[1].identifier,
				firstname1		= result[1].firstname,
				lastname1		= result[1].lastname,
				dateofbirth1	= result[1].dateofbirth,
				sex1			= result[1].sex,
				height1			= result[1].height,
				firstname2		= result[2].firstname,
				lastname2		= result[2].lastname,
				dateofbirth2	= result[2].dateofbirth,
				sex2			= result[2].sex,
				height2			= result[2].height,
				firstname3		= '',
				lastname3		= '',
				dateofbirth3	= '',
				sex3			= '',
				height3			= ''
			}

			callback(data)

		elseif result[1] and not result[2] and not result[3] then

			local data = {
				identifier		= result[1].identifier,
				firstname1		= result[1].firstname,
				lastname1		= result[1].lastname,
				dateofbirth1	= result[1].dateofbirth,
				sex1			= result[1].sex,
				height1			= result[1].height,
				firstname2		= '',
				lastname2		= '',
				dateofbirth2	= '',
				sex2			= '',
				height2			= '',
				firstname3		= '',
				lastname3		= '',
				dateofbirth3	= '',
				sex3			= '',
				height3			= ''
			}

			callback(data)

		else

			local data = {
				identifier		= '',
				firstname1		= '',
				lastname1		= '',
				dateofbirth1	= '',
				sex1			= '',
				height1			= '',
				firstname2		= '',
				lastname2		= '',
				dateofbirth2	= '',
				sex2			= '',
				height2			= '',
				firstname3		= '',
				lastname3		= '',
				dateofbirth3	= '',
				sex3			= '',
				height3			= ''
			}

			callback(data)

		end
	end)
end

function changeIdentity(identifier, data, source, callback)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local userResult = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier
	})
end

function setIdentity(identifier, data, source, callback)
	-- CHANGE CORE
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local userResult = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier
	})
	MySQL.Async.fetchAll('SELECT * FROM characters WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		local digitNumber = nil
		if #result == 0 then
			digitNumber = 1
		elseif #result == 1 then
			if result[1].digit == 1 then
				digitNumber = 2
			elseif result[1].digit == 2 then
				digitNumber = 1
			end
		else
			xPlayer.showNotification("~r~Nie możesz tworzyć więcej postaci! Napisz ticket, aby otrzymać pomoc")
			return
		end
		-- OLD CHAR
		
		if #result == 1 then
			MySQL.Async.execute('UPDATE characters SET accounts = @accounts, skin = @skin, job = @job, job_grade = @job_grade, job_level = @job_level, job_id = @job_id, hiddenjob = @hiddenjob, hiddenjob_grade = @hiddenjob_grade, inventory = @inventory, firstname = @firstname, lastname = @lastname, dateofbirth = @dateofbirth, sex = @sex, height = @height, status = @status, isDead = @isDead, phone_number = @phone_number, account_number = @account_number, tattoos = @tattoos, position = @position WHERE identifier = @identifier and digit = @digit', {
				['@identifier']		= identifier,
				['@digit'] 			= userResult[1].digit,
				['@accounts']		= json.encode(xPlayer.getAccounts(true)),
				['@skin'] 			= userResult[1].skin,
				['@job']			= xPlayer.getJob().name,
				['@job_grade']		= xPlayer.getJob().grade,
				['@job_level']		= userResult[1].job_level,
				['@job_id']			= userResult[1].job_id,
				['@hiddenjob']		= xPlayer.getHiddenJob().name,
				['@hiddenjob_grade'] = xPlayer.getHiddenJob().grade,
				['@inventory']		= json.encode(xPlayer.getInventory(true)),
				['@firstname']		= userResult[1].firstname,
				['@lastname']		= userResult[1].lastname,
				['@dateofbirth']	= userResult[1].dateofbirth,
				['@sex']			= userResult[1].sex,
				['@height']			= userResult[1].height,
				['@status']			= userResult[1].status,
				['@isDead']			= userResult[1].isDead,
				['@phone_number']	= userResult[1].phone_number,
				['@account_number'] = userResult[1].account_number,
				['@tattoos']		= userResult[1].tattoos,
				['@position']		= json.encode(xPlayer.getCoords())
			}, function(rowsChanged)

				local currInv = xPlayer.getInventory(true)
				for k,v in pairs(currInv) do
					xPlayer.removeInventoryItem(k, v)
				end
				
				local job_level = {
					level = 0,
					points = 0,
				}

				local job_id = {
					name = "nojob",
					id = 0
				}
				xPlayer.setJob('unemployed', 0)
				xPlayer.setHiddenJob('unemployed', 0)
				xPlayer.setAccountMoney('money', 800)
				xPlayer.setAccountMoney('bank', 5000)
				xPlayer.setAccountMoney('black_money', 0)
				Citizen.Wait(2000)
				MySQL.Async.execute('UPDATE `users` SET `digit` = @digit, `firstname` = @firstname, `lastname` = @lastname, `job` = @job, `job_grade` = @job_grade, `job_level` = @job_level, `job_id` = @job_id, `hiddenjob` = @hiddenjob, `hiddenjob_grade` = @hiddenjob_grade, `dateofbirth` = @dateofbirth, `sex` = @sex, `height` = @height, `status` = @status, `isDead` = @isDead, `tattoos` = @tattoos, `phone_number` = @phone_number, `position` = @position, account_number = @account_number WHERE identifier = @identifier', {
					['@identifier']		= identifier,
					['@digit']			= digitNumber,
					['@firstname']		= data.firstname,
					['@lastname']		= data.lastname,
					['@job']			= 'unemployed',
					['@job_grade']		= 0,
					['@job_level']		= json.encode(job_level),
					['@job_id']			= json.encode(job_id),
					['@hiddenjob']		= 'unemployed',
					['@hiddenjob_grade'] = 0,
					['@dateofbirth']	= data.dateofbirth,
					['@sex']			= data.sex,
					['@height']			= data.height,
					['@status']			= json.encode('{}'),
					['@isDead']			= 0,
					['@tattoos']		= json.encode('{}'),
					['@phone_number']	= '',
					['@position']		= json.encode(xPlayer.getCoords()),
					['@account_number'] = '0'
				}, function(rowsChanged2)
					if callback then
						xPlayer.setDigit(digitNumber)
						TriggerClientEvent('esx_tattooshop:setTattoos', _source, {})
						TriggerClientEvent('gcPhone:getNewNumber', _source)
						TriggerClientEvent('esx_property:reloadProperties', _source)
						TriggerClientEvent('flux_charselect:finish', _source)
						
						--Update var
						xPlayer.setCharacter('firstname', data.firstname)
						xPlayer.setCharacter('lastname', data.lastname)
						xPlayer.setCharacter('dateofbirth', data.dateofbirth)
						xPlayer.setCharacter('sex', data.sex)
						xPlayer.setCharacter('height', data.height)
						xPlayer.setCharacter('status', {})
						xPlayer.setCharacter('phone_number', '')
						xPlayer.setCharacter('account_number', 0)
						xPlayer.setCharacter('job_id', job_id)
						callback(true)
					end
				end)
			end)
			
			-- NEW CHAR
			MySQL.Async.execute('INSERT INTO characters (identifier, digit, firstname, lastname, dateofbirth, sex, height, account_number) VALUES (@identifier, @digit, @firstname, @lastname, @dateofbirth, @sex, @height, @account_number)', {
				['@identifier']		= identifier,
				['@digit']			= digitNumber,
				['@firstname']		= data.firstname,
				['@lastname']		= data.lastname,
				['@dateofbirth']	= data.dateofbirth,
				['@sex']			= data.sex,
				['@height']			= data.height,
				['@account_number'] = '0'
			})
		elseif #result == 0 then
			MySQL.Async.execute('UPDATE `users` SET `digit` = @digit, `firstname` = @firstname, `lastname` = @lastname, `dateofbirth` = @dateofbirth, `sex` = @sex, `height` = @height WHERE identifier = @identifier', {
				['@identifier']		= identifier,
				['@digit']			= digitNumber,
				['@firstname']		= data.firstname,
				['@lastname']		= data.lastname,
				['@dateofbirth']	= data.dateofbirth,
				['@sex']			= data.sex,
				['@height']			= data.height
			}, function(rowsChanged2)
				if callback then
					xPlayer.setDigit(digitNumber)
					callback(true)
				end
			end)
			-- NEW CHAR
			MySQL.Async.execute('INSERT INTO characters (identifier, digit, firstname, lastname, dateofbirth, sex, height) VALUES (@identifier, @digit, @firstname, @lastname, @dateofbirth, @sex, @height)', {
				['@identifier']		= identifier,
				['@digit']			= digitNumber,
				['@firstname']		= data.firstname,
				['@lastname']		= data.lastname,
				['@dateofbirth']	= data.dateofbirth,
				['@sex']			= data.sex,
				['@height']			= data.height
			})
		end
	end)
end

function updateIdentity(identifier, data, callback)
	MySQL.Async.execute('UPDATE `users` SET `firstname` = @firstname, `lastname` = @lastname, `dateofbirth` = @dateofbirth, `sex` = @sex, `height` = @height WHERE identifier = @identifier', {
		['@identifier']		= identifier,
		['@firstname']		= data.firstname,
		['@lastname']		= data.lastname,
		['@dateofbirth']	= data.dateofbirth,
		['@sex']			= data.sex,
		['@height']			= data.height
	}, function(rowsChanged)
		if callback then
			callback(true)
		end
	end)
end

function deleteIdentity(identifier, data, callback)
	MySQL.Async.execute('DELETE FROM `characters` WHERE identifier = @identifier AND firstname = @firstname AND lastname = @lastname AND dateofbirth = @dateofbirth AND sex = @sex AND height = @height', {
		['@identifier']		= identifier,
		['@firstname']		= data.firstname,
		['@lastname']		= data.lastname,
		['@dateofbirth']	= data.dateofbirth,
		['@sex']			= data.sex,
		['@height']			= data.height
	}, function(rowsChanged)
		if callback then
			callback(true)
		end
	end)
end

RegisterServerEvent('esx_identity:setIdentity')
AddEventHandler('esx_identity:setIdentity', function(data, myIdentifiers)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	setIdentity(xPlayer.identifier, data, source, function(callback)
		if callback then
			TriggerClientEvent('esx_identity:identityCheck', xPlayer.source, true)
		end
	end)
end)

AddEventHandler('esx:playerLoaded', function(source)
	local myID = {
		steamid = ESX.GetPlayerFromId(source).identifier,
		playerid = source
	}

	TriggerClientEvent('esx_identity:saveID', source, myID)
	getIdentity(source, function(data)
		if data.firstname == '' then
			TriggerClientEvent('esx_identity:identityCheck', source, false)
			TriggerClientEvent('esx_identity:showRegisterIdentity', source)
		else
			TriggerClientEvent('esx_identity:identityCheck', source, true)
		end
	end)
end)

RegisterCommand('register', function(source, args, rawcommand)
	if source == 0 then
		TriggerClientEvent('esx_identity:showRegisterIdentity', args[1], true)
	else
		local xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'best' then
			TriggerClientEvent('esx_identity:showRegisterIdentity', args[1], true)
			exports['exile_logs']:SendLog(xPlayer.source, "Użyto komendy /register " .. args.playerId.source, "postac")
		else
			xPlayer.showNotification('~r~Nie posiadasz permsij')
		end
	end
end, true)

--flux code

RegisterCommand('updatename', function(source, args, rawcommand)
	if source == 0 then
		MySQL.Async.execute('UPDATE users SET firstname = @firstname, lastname = @lastname WHERE identifier = @identifier AND digit = @digit',
		{
			['@firstname'] = args[3],
			['@lastname'] = args[4],
			['@identifier'] = args[1],
			['@digit'] = args[2]
		})
		MySQL.Async.execute('UPDATE characters SET firstname = @firstname, lastname = @lastname WHERE identifier = @identifier AND digit = @digit',
		{
			['@firstname'] = args[3],
			['@lastname'] = args[4],
			['@identifier'] = args[1],
			['@digit'] = args[2]
		})
		
		local xPlayer = ESX.GetPlayerFromId(args[1])
		
		if xPlayer ~= nil then
			if xPlayer.digit == args[2] then
				xPlayer.setCharacter('firstname', args[3])
				xPlayer.setCharacter('lastname', args[4])
			end
		end
	else
		local xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer.getGroup() == 'superadmin' then
			MySQL.Async.execute('UPDATE users SET firstname = @firstname, lastname = @lastname WHERE identifier = @identifier AND digit = @digit',
			{
				['@firstname'] = args[3],
				['@lastname'] = args[4],
				['@identifier'] = args[1],
				['@digit'] = args[2]
			})
			MySQL.Async.execute('UPDATE characters SET firstname = @firstname, lastname = @lastname WHERE identifier = @identifier AND digit = @digit',
			{
				['@firstname'] = args[3],
				['@lastname'] = args[4],
				['@identifier'] = args[1],
				['@digit'] = args[2]
			})	

			local xPlayer = ESX.GetPlayerFromId(args[1])
			
			if xPlayer ~= nil then
				if xPlayer.digit == args[2] then
					xPlayer.setCharacter('firstname', args[3])
					xPlayer.setCharacter('lastname', args[4])
				end
			end			
		else
			xPlayer.showNotification('~r~Nie posiadasz permsij')
		end
	end
end, true)

function getCharacters(source, callback)
	local identifier = ESX.GetPlayerFromId(source).identifier
	local data = {}
	MySQL.Async.fetchAll("SELECT firstname, lastname, digit FROM `characters` WHERE `identifier` = @identifier",
	{
		['@identifier'] = identifier
	}, function(result)
		for i=1, #result, 1 do
			table.insert(data, {firstname = result[i].firstname, lastname = result[i].lastname, digit = result[i].digit})
		end
		callback(data)
	end)
end

ESX.RegisterServerCallback('flux_charselect:ListaPostaci', function(source, cb)

	local xPlayer = ESX.GetPlayerFromId(source)
	local dataTable = {}
	getCharacters(source, function(data)
		for i=1, #data, 1 do
			local isUsed = false
			if xPlayer.getDigit() == data[i].digit then
				isUsed = true
			end
			table.insert(dataTable, {label = data[i].firstname .. " " .. data[i].lastname, value = data[i].digit, bool = isUsed})
		end
		cb(dataTable)
	end)

end)



RegisterServerEvent('flux_charselect:charSelect')
AddEventHandler('flux_charselect:charSelect', function(charnum)
	-- CHANGE CORE
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	local userResult = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	})
	if userResult[1].digit == charnum then
		xPlayer.showNotification("~r~Nie możesz zmienić postaci na tę samą!")
		return
	end
	
	-- OLD CHAR
	MySQL.Async.execute('UPDATE characters SET accounts = @accounts, skin = @skin, job = @job, job_grade = @job_grade, job_level = @job_level, job_id = @job_id, hiddenjob = @hiddenjob, hiddenjob_grade = @hiddenjob_grade, inventory = @inventory, firstname = @firstname, lastname = @lastname, dateofbirth = @dateofbirth, sex = @sex, height = @height, status = @status, isDead = @isDead, phone_number = @phone_number, account_number = @account_number, tattoos = @tattoos, position = @position WHERE identifier = @identifier and digit = @digit', {
		['@identifier']		= xPlayer.identifier,
		['@digit'] 			= userResult[1].digit,
		['@accounts']		= json.encode(xPlayer.getAccounts(true)),
		['@skin'] 			= userResult[1].skin,
		['@job']			= xPlayer.getJob().name,
		['@job_level']		= userResult[1].job_level,
		['@job_grade']		= xPlayer.getJob().grade,
		['@job_id']			= userResult[1].job_id,
		['@hiddenjob']		= xPlayer.getHiddenJob().name,
		['@hiddenjob_grade'] = xPlayer.getHiddenJob().grade,
		['@inventory']		= json.encode(xPlayer.getInventory(true)),
		['@firstname']		= userResult[1].firstname,
		['@lastname']		= userResult[1].lastname,
		['@dateofbirth']	= userResult[1].dateofbirth,
		['@sex']			= userResult[1].sex,
		['@height']			= userResult[1].height,
		['@status']			= userResult[1].status,
		['@isDead']		    = userResult[1].isDead,
		['@phone_number']	= userResult[1].phone_number,
		['@account_number'] = userResult[1].account_number,
		['@tattoos']		= userResult[1].tattoos,
		['@position'] 		= json.encode(xPlayer.getCoords())
	}, function(rowsChanged)
		if rowsChanged then
			MySQL.Async.fetchAll('SELECT * FROM characters WHERE identifier = @identifier and digit = @digit', {
				['@identifier'] = xPlayer.identifier,
				['@digit']		= charnum
			}, function(characterResult)
				if characterResult then
					TriggerClientEvent("csskrouble:switchChars", _source, json.decode(characterResult[1].position))
					local mySkin = json.decode(characterResult[1].skin)
					local lastSkin = json.decode(userResult[1].skin)
					TriggerClientEvent('skinchanger:loadSkin', _source, mySkin)
					if mySkin.sex ~= lastSkin.sex then
						Citizen.Wait(500)
					end

					local currInv = xPlayer.getInventory(true)
					for k,v in pairs(currInv) do
						xPlayer.removeInventoryItem(k, v)
					end

					xPlayer.setJob(characterResult[1].job, characterResult[1].job_grade)
					xPlayer.setHiddenJob(characterResult[1].hiddenjob, characterResult[1].hiddenjob_grade)
					
					local data = json.decode(characterResult[1].accounts)
					
					xPlayer.setAccountMoney('money', data.money)
					xPlayer.setAccountMoney('bank', data.bank)
					xPlayer.setAccountMoney('black_money', data.black_money)
	

					local inv = json.decode(characterResult[1].inventory)
					for k,v in pairs(inv) do
						xPlayer.addInventoryItem(k, v)
					end

					MySQL.Async.execute('UPDATE `users` SET `digit` = @digit, accounts = @accounts, job_level = @job_level, job_id = @job_id, skin = @skin, `firstname` = @firstname, `lastname` = @lastname, `dateofbirth` = @dateofbirth, `sex` = @sex, `height` = @height, status = @status, phone_number = @phone_number, account_number = @account_number, tattoos = @tattoos WHERE identifier = @identifier', {
						['@identifier']		= xPlayer.identifier,
						['@digit']			= charnum,
						['@accounts']		= json.encode(data),
						['@job_level']		= characterResult[1].job_level,
						['@job_id']			= characterResult[1].job_id,
						['@skin']			= characterResult[1].skin,
						['@firstname']		= characterResult[1].firstname,
						['@lastname']		= characterResult[1].lastname,
						['@dateofbirth']	= characterResult[1].dateofbirth,
						['@sex']			= characterResult[1].sex,
						['@height']			= characterResult[1].height,
						['@status']			= characterResult[1].status,
						['@phone_number']	= characterResult[1].phone_number,
						['@account_number'] = characterResult[1].account_number,
						['@tattoos']		= characterResult[1].tattoos
					}, function(rowsChanged2)
						if rowsChanged2 then
							xPlayer.setDigit(charnum)
							
							if characterResult[1].firstname ~= nil and characterResult[1].lastname then
								xPlayer.setCharacter('firstname', characterResult[1].firstname)
								xPlayer.setCharacter('lastname', characterResult[1].lastname)
								xPlayer.setCharacter('dateofbirth', characterResult[1].dateofbirth)
								xPlayer.setCharacter('sex', characterResult[1].sex)
								xPlayer.setCharacter('height', characterResult[1].height)
							end
							
							if characterResult[1].status ~= nil and characterResult[1].status ~= '' then
								xPlayer.setCharacter('status', json.decode(characterResult[1].status))
							else
								xPlayer.setCharacter('status', {})
							end
							
							if characterResult[1].phone_number ~= nil and characterResult[1].phone_number ~= '' then
								xPlayer.setCharacter('phone_number', characterResult[1].phone_number)
							else
								xPlayer.setCharacter('phone_number', '')
							end
							
							if characterResult[1].account_number ~= nil and characterResult[1].account_number ~= '' then
								xPlayer.setCharacter('account_number', characterResult[1].account_number)
							else
								xPlayer.setCharacter('account_number', 0)
							end							
						
							if characterResult[1].job_id ~= nil and characterResult[1].job_id ~= '' then
								xPlayer.setCharacter('job_id', characterResult[1].job_id)
							else
								xPlayer.setCharacter('job_id', {})
							end
							
							if characterResult[1].tattoos ~= nil and characterResult[1].tattoos ~= '' then
								TriggerClientEvent('esx_tattooshop:setTattoos', _source, characterResult[1].tattoos)
							else
								TriggerClientEvent('esx_tattooshop:setTattoos', _source, {})
							end
							
							TriggerClientEvent('gcphone:myPhoneNumber', _source, characterResult[1].phone_number)
							TriggerClientEvent('esx_property:reloadProperties', _source)
							TriggerClientEvent('flux_charselect:finish', _source)
							TriggerEvent("skrabel:lickiRefresh", _source)
							TriggerClientEvent('esx:showNotification', _source, "Twoja postać to teraz ~g~" .. characterResult[1].firstname .. " " .. characterResult[1].lastname)
						end
					end)
				end
			end)
		end
	end)
end)