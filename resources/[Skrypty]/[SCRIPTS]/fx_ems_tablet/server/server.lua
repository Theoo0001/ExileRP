ESX = nil
TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

-- Get history
ESX.RegisterServerCallback('emstablet:getHistory', function(source, cb)
	MySQL.Async.fetchAll('SELECT * FROM emstablet_history', {}, function(result)
		if result then
			cb(result)
		else
			cb(false)
		end
	end)	
end)

-- Parse doctor
ESX.RegisterServerCallback('emstablet:parseDoctor', function(source, cb, data)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll("SELECT firstname,lastname FROM `characters` WHERE `identifier` = @identifier AND `digit` = @digit", {
		['@identifier'] = data.identifier,
		['@digit'] = xPlayer.getDigit()
	}, function(result)
		if result[1]['firstname'] ~= nil then
			cb(result[1]['firstname'] .. ' ' .. result[1]['lastname'])
		else
			cb('-')
		end
	end)
end)

-- Parse name
ESX.RegisterServerCallback('emstablet:parseName', function(source, cb, id)
	local xPlayer = ESX.GetPlayerFromId(id)
	MySQL.Async.fetchAll("SELECT firstname,lastname FROM `characters` WHERE `identifier` = @identifier AND `digit` = @digit", {
		['@identifier'] = xPlayer.identifier,
		['@digit'] = xPlayer.getDigit()
	}, function(result)
		if result[1]['firstname'] ~= nil then
			local data = {
				firstname = result[1]['firstname'],
				lastname = result[1]['lastname']
			}
			cb(data)
		else
			local data = {
				firstname = '',
				lastname = ''
			}
			cb(data)
		end
	end)
end)

-- Get assistance (for individual check)
ESX.RegisterServerCallback('emstablet:getUserAssistance', function(source, cb, data)
	local name = split(data.name, " ")
	if name[1] ~= nil and name[2] ~= nil then
		MySQL.Async.fetchAll("SELECT firstname,lastname,identifier,digit FROM `users` WHERE `firstname` LIKE @firstname AND `lastname` LIKE @lastname", {['@firstname'] = name[1] .. '%', ['@lastname'] = name[2] .. '%'}, function(result)
			if result then
				cb(result)
			else
				cb(false)
			end
		end)
	else
		cb(false)
	end
end)

function split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end

-- Get assistance (for history)
ESX.RegisterServerCallback('emstablet:getAssistance', function(source, cb, data)	
	MySQL.Async.fetchAll('SELECT time as timestamp FROM user_licenses WHERE owner = @owner AND digit = @digit AND type = @type', { 
			['@owner'] = data.identifier,
			['@digit'] = data.digit,
			['@type'] = 'ems_insurance',
	}, function(result)
		if result[1] ~= nil then
			local tr = tostring(result[1].timestamp)
			local fromUnix = os.date('%Y-%m-%d %H:%M:%S', tr)
			cb(fromUnix)
		else
			cb('Brak')
		end
	end)
end)

-- Add invoice to history
--[[ESX.RegisterServerCallback('emstablet:addHistory', function(source, cb, data)
	local xPlayer = ESX.GetPlayerFromId(source)
	local _data = data.data
	local _target = ESX.GetPlayerFromId(data.target)
	
	if xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'offambulance' then 
		--[[TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ambulance', function(account)
			_target.removeAccountMoney('bank', tonumber(_data.price))
			account.addAccountMoney(5000)
			xPlayer.addAccountMoney('bank', 1500)
		end)
		if tonumber(_data.price) < 120001 then
			_target.removeAccountMoney('bank', tonumber(_data.price))
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ambulance', function(account)
				account.addAccountMoney(15000)
				xPlayer.addMoney(math.floor(tonumber(_data.price) / 100 * 20))
			end)
			
			exports['exile_logs']:SendLog(xPlayer.source, "SAMS TABLET: Wystawiono fakturę dla [" .. _target.source .. "] " .. GetPlayerName(_target.source) .. ":\nPowód: " .. _data.treatment .. "\nKwota: " .. _data.price, 'fines', '3447003')
				
			MySQL.Async.execute('INSERT INTO emstablet_history (owner, digit, name, surname, treatment, price, date, doctor) VALUES (@owner, @digit, @name, @surname, @treatment, @price, @date, @doctor)', {
				['@owner'] = _target.identifier,
				['@digit'] = _target.getDigit(),
				['@name'] = _data.name,
				['@surname'] = _data.surname,
				['@treatment'] = _data.treatment,
				['@price'] = _data.price,
				['@date'] = _data.date,
				['@doctor'] = xPlayer.identifier
			})
			cb(true)
		else
			xPlayer.showNotification("~r~Faktura nie może wynosić więcej niż ~g~120000$~r~!")
			cb(false)
		end	
	else
		exports['exile_logs']:SendLog(xPlayer.source, 'Chcial wjebac komus fakture przez tablet SAMS', 'anticheat', '3447003')
	end
end)]]

ESX.RegisterServerCallback('emstablet:addHistory', function(source, cb, data)
	local xPlayer = ESX.GetPlayerFromId(source)
	local _data = data.data
	local _target = ESX.GetPlayerFromId(data.target)
	
	if xPlayer.job.name == 'ambulance' then
		if tonumber(_data.price) < 120001 then
		_target.removeAccountMoney('bank', tonumber(_data.price))
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_sams2', function(account)
			local oblicz = math.floor(tonumber(_data.price) / 100 * 60)
			account.addAccountMoney(oblicz)
		end)
		xPlayer.addMoney(math.floor(tonumber(_data.price) / 100 * 25))
		exports['exile_logs']:SendLog(xPlayer.source, "SAMS TABLET: Wystawiono fakturę dla [" .. _target.source .. "] " .. GetPlayerName(_target.source) .. ":\nPowód: " .. _data.treatment .. "\nKwota: " .. _data.price, 'fines', '15844367')
		
		MySQL.Async.execute('INSERT INTO emstablet_history (owner, digit, name, surname, treatment, price, date, doctor) VALUES (@owner, @digit, @name, @surname, @treatment, @price, @date, @doctor)', {
			['@owner'] = _target.identifier,
			['@digit'] = _target.getDigit(),
			['@name'] = _data.name,
			['@surname'] = _data.surname,
			['@treatment'] = _data.treatment,
			['@price'] = _data.price,
			['@date'] = _data.date,
			['@doctor'] = xPlayer.identifier
		})
		cb(true)
		else
			xPlayer.showNotification("~r~Faktura nie może wynosić więcej niż ~g~120000$~r~!")
			cb(false)
		end	
	else
		TriggerEvent("csskrouble:banPlr", "nigger", xPlayer.source, "Tried to invoice (fx_ems_tablet)")
		--exports['exile_logs']:SendLog(xPlayer.source, 'Chcial wjebac komus fakture przez tablet SAMS', 'anticheat', '3447003')
	end
end)

-- Get default data
ESX.RegisterServerCallback('emstablet:getDefaultData', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	-- Getting firstname and lastname
	MySQL.Async.fetchAll("SELECT firstname, lastname FROM `characters` WHERE `identifier` = @identifier AND `digit` = @digit", {
		['@identifier'] = xPlayer.identifier,
		['@digit'] = xPlayer.getDigit()
	}, function(result)
		if result[1]['firstname'] ~= nil then
			_firstname = result[1]['firstname']
			_lastname = result[1]['lastname']
		else
			_firstname = ''
			_lastname = ''
		end
		-- Getting invoices count
		MySQL.Async.fetchAll("SELECT COUNT(*) as count FROM `emstablet_history` WHERE `doctor` = @identifier", {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			if result[1]['count'] ~= nil then
				_invoices = result[1]['count']
			else
				_invoices = 0
			end

			local data = {
				firstname = _firstname,
				lastname = _lastname,
				invoices = _invoices,
				ambulance = exports['esx_scoreboard']:CounterPlayers('ambulance')
			}
			cb(data)
		end)
	end)
end)