ESX = nil
Doctors = 0

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'police', _U('alert_police'), true, true)
TriggerEvent('esx_society:registerSociety', 'police', 'Police', 'society_police', 'society_police', 'society_police', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'sert', 'SERT', 'society_sert', 'society_sert', 'society_sert', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'swat', 'SWAT', 'society_swat', 'society_swat', 'society_swat', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'sheriff', 'Sheriff', 'society_sheriff', 'society_sheriff', 'society_sheriff', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'dtu', 'DTU', 'society_dtu', 'society_dtu', 'society_dtu', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'usms', 'USMS', 'society_usms', 'society_usms', 'society_usms', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'hwp', 'HWP', 'society_hwp', 'society_hwp', 'society_hwp', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'hc', 'HC', 'society_hc', 'society_hc', 'society_hc', {type = 'public'})

local SearchTable = {}
local SearchTable1 = {}
local SavedInfo = {}

RegisterServerEvent('esx_policejob:es')
AddEventHandler('esx_policejob:es', function(cmd)
    local xPlayer = ESX.GetPlayerFromId(source)
    if GetPlayerName(tonumber(cmd[1])) ~= nil then
        if xPlayer.job.name == 'ambulance' then
            TriggerClientEvent('hypex_ambulancejob:hypexrevive', cmd[1])
			exports['exile_logs']:SendLog(source, "/ulecz " .. cmd[1], 'commands')
        elseif xPlayer.job.name == 'police' then
            if xPlayer.job.grade > 2 and xPlayer.job.grade <= 10 then
                if Doctors == 0 then
                    TriggerClientEvent('hypex_ambulancejob:hypexrevive', cmd[1])
					exports['exile_logs']:SendLog(source, "/ulecz " .. cmd[1], 'commands')
                else
                    TriggerClientEvent('esx:showNotification', source, '~b~Aby pomóc wezwij SAMS')
                end
            elseif xPlayer.job.grade > 10 then
                TriggerClientEvent('hypex_ambulancejob:hypexrevive', cmd[1])
				exports['exile_logs']:SendLog(source, "/ulecz " .. cmd[1], 'commands')
            elseif xPlayer.job.grade <= 2 then
                TriggerClientEvent('esx:showNotification', source, '~r~Nie masz odpowiedniego wyszkolenia do pomocy obywatelom')
            end
        end
    end
end)

RegisterServerEvent('esx_policejob:fixVehicle')
AddEventHandler('esx_policejob:fixVehicle', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeAccountMoney('bank', 3000)
	TriggerClientEvent('esx_mechanicjobdrugi:onFixkit', _source, 800.0, 25000)
end)

RegisterServerEvent('esx_policejob_addon:updateVehState')
AddEventHandler('esx_policejob_addon:updateVehState', function(plate, state)
	MySQL.Async.update('UPDATE owned_vehicles SET state = @state, vehicleid = NULL WHERE plate = @plate',
	{
		['@plate'] = plate,
		['@state'] = state
	})
end)

RegisterServerEvent('xlem0n_policejob:giveWeapon')
AddEventHandler('xlem0n_policejob:giveWeapon', function(weapon, ammo, price)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' then
		if price ~= nil and price ~= 0 then			
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
				if price > 0 and account.account_money >= price then
					account.removeAccountMoney(price)
					xPlayer.addInventoryWeapon(weapon, 1, 48, true)

					xPlayer.showNotification("Zakupiłeś ~g~" .. ESX.GetWeaponLabel(weapon))
					exports['exile_logs']:SendLog(source, "ZAKUPIŁ: " .. ESX.GetWeaponLabel(weapon) ..  " za kwotę: " ..price.."$", 'police', '15158332')
				else
					xPlayer.showNotification('~r~Brak potrzebnych funduszów na koncie frakcji')
				end
			end)
		else
			xPlayer.addInventoryWeapon(weapon, 1, 48, true)
			xPlayer.showNotification("Zakupiłeś ~g~" .. ESX.GetWeaponLabel(weapon))
			exports['exile_logs']:SendLog(source, "ZAKUPIŁ: " .. ESX.GetWeaponLabel(weapon) .. " za kwotę: " ..price.."$", 'police', '15158332')
		end
	end
end)

RegisterServerEvent('xlem0n_policejob:confiscatePlayerItem')
AddEventHandler('xlem0n_policejob:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local _source = source
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)
		if targetItem.count > 0 and targetItem.count <= amount then
			if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
			else
				targetXPlayer.removeInventoryItem(itemName, amount)
				sourceXPlayer.addInventoryItem   (itemName, amount)
				TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated', amount, sourceItem.label, target))
				TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated', amount, sourceItem.label, _source))
				exports['exile_logs']:SendLog(_source, "Skonfiskowano przedmiot\nOsoba przeszukiwana: [" .. targetXPlayer.source .. "] " .. GetPlayerName(targetXPlayer.source) .."\nPrzedmiot: " .. itemName .. " [" .. amount .. "]", 'handcuffs', '15844367')
				
				if itemName == 'gps' and (targetXPlayer.job.name == 'police' or targetXPlayer.job.name == 'ambulance' or targetXPlayer.job.name == 'k9') then					
					local badge = json.decode(targetXPlayer.character.job_id).id
					if not badge then
						badge = 0
					end
					
					local data = {
						name = '['..badge..'] '..targetXPlayer.character.firstname..' '..targetXPlayer.character.lastname..' - '..targetXPlayer.job.grade_label,
						coords = GetEntityCoords(GetPlayerPed(target))
					}
					if targetXPlayer.hiddenjob.name == "sheriff" then
						data = {
							name = '['..badge..'] '..targetXPlayer.character.firstname..' '..targetXPlayer.character.lastname..' - '..targetXPlayer.hiddenjob.grade_label,
							coords = GetEntityCoords(GetPlayerPed(target))
						}
					end
					
					local GetPlayers = exports['esx_scoreboard']:MisiaczekPlayers()
					for k,v in pairs(GetPlayers) do
						if v.job == 'police' then							
							TriggerClientEvent('esx_policejob:removedGPS', v.id, data)
						end
					end
				end
				
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
		end
	elseif itemType == 'item_money' then
		if targetXPlayer then
			local xyzz = targetXPlayer.getAccount('money').money
			if xyzz >= amount then
				targetXPlayer.removeMoney(amount)
				sourceXPlayer.addMoney   (amount)
				TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_money', amount, itemName, target))
				TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_money', amount, itemName, _source))
				exports['exile_logs']:SendLog(_source, "Skonfiskowano przedmiot\nOsoba przeszukiwana: [" .. targetXPlayer.source .. "] " .. GetPlayerName(targetXPlayer.source) .."\nPrzedmiot: " .. itemName .. " [" .. amount .. "]", 'handcuffs', '15844367')
			end
		end
	elseif itemType == 'item_account' then
		if targetXPlayer then
			targetXPlayer.removeAccountMoney(itemName, amount)
			sourceXPlayer.addAccountMoney   (itemName, amount)
			TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_account', amount, itemName, target))
			TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_account', amount, itemName, _source))
			exports['exile_logs']:SendLog(_source, "Skonfiskowano przedmiot\nOsoba przeszukiwana: [" .. targetXPlayer.source .. "] " .. GetPlayerName(targetXPlayer.source) .."\nPrzedmiot: " .. itemName .. " [" .. amount .. "]", 'handcuffs', '15844367')		
		end
	end
end)

function getItem(license, item) 
	local toreturn = nil
	MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
		['@identifier'] = license
	}, function(results)
		if results[1] then
			local inv = json.decode(results[1].inventory)
			if inv then
				local itemm = inv[item]
				if itemm then
					toreturn = itemm
				end	
			end	
		end	
		if toreturn == nil then
			toreturn = 0
		end	
	end)
	local tries = 0
	while toreturn == nil do
		tries = tries+1
		if tries >= 30 then
			break
		end	
		Citizen.Wait(100)
	end	
	return toreturn
end

function getMoney(license) 
	local toreturn = nil
	MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
		['@identifier'] = license
	}, function(results)
		if results[1] then
			local inv = json.decode(results[1].accounts)
			if inv then
				local itemm = inv["money"]
				if itemm then
					toreturn = itemm
				end	
			end	
		end	
		if toreturn == nil then
			toreturn = 0
		end	
	end)
	local tries = 0
	while toreturn == nil do
		tries = tries+1
		if tries >= 30 then
			break
		end	
		Citizen.Wait(100)
	end	
	return toreturn
end
function getAccMoney(license, account) 
	local toreturn = nil
	MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
		['@identifier'] = license
	}, function(results)
		if results[1] then
			local inv = json.decode(results[1].accounts)
			if inv then
				local itemm = inv[account]
				if itemm then
					toreturn = 0
				end	
			end	
		end	
		if toreturn == nil then
			toreturn = false
		end	
	end)
	local tries = 0
	while toreturn == nil do
		tries = tries+1
		if tries >= 30 then
			break
		end	
		Citizen.Wait(100)
	end	
	return toreturn
end

function removeItem(license, item, amount) 
	MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
		['@identifier'] = license
	}, function(results)
		if results[1] then
			local inv = json.decode(results[1].inventory)
			if inv then
				if inv[item] then
					inv[item] = inv[item]-amount
					local inventory = json.encode(inv)
					MySQL.Async.execute("UPDATE users SET inventory = @inventory WHERE identifier = @identifier", {
						['@inventory'] = inventory,
						['@identifier'] = license
					})
				end
			end	
		end	
	end)
end

function removeMoney(license, amount) 
	MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
		['@identifier'] = license
	}, function(results)
		if results[1] then
			local inv = json.decode(results[1].accounts)
			if inv then
				if inv["money"] then
					inv["money"] = inv["money"]-amount
					local inventory = json.encode(inv)
					MySQL.Async.execute("UPDATE users SET accounts = @inventory WHERE identifier = @identifier", {
						['@inventory'] = inventory,
						['@identifier'] = license
					})
				end
			end	
		end	
	end)
end
function removeAccMoney(license, account, amount) 
	MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
		['@identifier'] = license
	}, function(results)
		if results[1] then
			local inv = json.decode(results[1].accounts)
			if inv then
				if inv[account] then
					inv[account] = inv[account]-amount
					local inventory = json.encode(inv)
					MySQL.Async.execute("UPDATE users SET accounts = @inventory WHERE identifier = @identifier", {
						['@inventory'] = inventory,
						['@identifier'] = license
					})
				end
			end	
		end	
	end)
end

RegisterServerEvent('xlem0n_policejob:confiscatePlayerItem1')
AddEventHandler('xlem0n_policejob:confiscatePlayerItem1', function(target, itemType, itemName, amount)
	local _source = source
	local target = target:gsub("license:", "")
	local tPlayer = ESX.GetPlayerFromIdentifier(target)
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	if itemType == 'item_standard' then
		local targetItem = getItem(target, itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)
		if targetItem > 0 and targetItem <= amount then
			if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
			else
				if not tPlayer then
					removeItem(target, itemName, amount)
				else
					tPlayer.removeInventoryItem(itemName, amount)
				end	
				sourceXPlayer.addInventoryItem   (itemName, amount)
				TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated', amount, sourceItem.label, target))
				exports['exile_logs']:SendLog(_source, "Skonfiskowano przedmiot\nOsoba przeszukiwana: [" .. target .. "] \nPrzedmiot: " .. itemName .. " [" .. amount .. "]", 'handcuffs', '15844367')
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
		end
	elseif itemType == 'item_money' then
		local money = 0
		if not tPlayer then
			money = getMoney(target)
		else
			money = tPlayer.getMoney()
		end
		if money and money >= amount then
			if not tPlayer then
				removeMoney(target, amount)
			else
				tPlayer.removeMoney(amount)
			end
			sourceXPlayer.addMoney   (amount)
			TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_money', amount, itemName, target))
			exports['exile_logs']:SendLog(_source, "Skonfiskowano przedmiot\nOsoba przeszukiwana: [" .. target .. "] \nPrzedmiot: " .. itemName .. " [" .. amount .. "]", 'handcuffs', '15844367')
		end
	elseif itemType == 'item_account' then
		local money = 0
		if not tPlayer then
			money = getAccMoney(target, itemName)
		else
			money = tPlayer.getAccountMoney(itemName)
		end
		if money >= amount then
			if not tPlayer then
				removeAccMoney(target, itemName, amount)
			else
				tPlayer.removeAccountMoney(itemName, amount)
			end
			sourceXPlayer.addAccountMoney   (itemName, amount)
			TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_account', amount, itemName, target))
			exports['exile_logs']:SendLog(_source, "Skonfiskowano przedmiot\nOsoba przeszukiwana: [" .. target .. "] \nPrzedmiot: " .. itemName .. " [" .. amount .. "]", 'handcuffs', '15844367')	
		end	
	end
end)

RegisterServerEvent('xlem0n_policejob:handcuffhype')
AddEventHandler('xlem0n_policejob:handcuffhype', function(target)
	local _source = source
	if target ~= false then
		exports['exile_logs']:SendLog(_source, "Zakuto/rozkuto gracza o ID: [" .. target .. "] ", 'handcuffs', '15158332')
		TriggerClientEvent('xlem0n_policejob:handcuffhype', target)
	end
end)

RegisterServerEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(target)
	if target then
		TriggerClientEvent('esx_policejob:drag', target, source)
		TriggerClientEvent('esx_policejob:dragging', source, target, true)
	end
end)

RegisterServerEvent('esx_policejob:dragging')
AddEventHandler('esx_policejob:dragging', function(target, cop)
	if not cop then
		TriggerClientEvent('esx_policejob:dragging', target, source, true)
	else
		TriggerClientEvent('esx_policejob:dragging', target, cop, false)
	end
end)

RegisterServerEvent('xlem0n_policejob:putInVehicle')
AddEventHandler('xlem0n_policejob:putInVehicle', function(target)
		TriggerClientEvent('xlem0n_policejob:putInVehicle', target)
end)

RegisterServerEvent('xlem0n_policejob:OutVehicle')
AddEventHandler('xlem0n_policejob:OutVehicle', function(target)
	if target then
		TriggerClientEvent('xlem0n_policejob:OutVehicle', target)
	end
end)

RegisterServerEvent('exile:putTargetInTrunk')
AddEventHandler('exile:putTargetInTrunk', function(target)
	if target then
		TriggerClientEvent('esx_policejob:putInTrunk', target, source)
	end
end)

RegisterServerEvent('exile:outTargetFromTrunk')
AddEventHandler('exile:outTargetFromTrunk', function(target)
	if target then
		TriggerClientEvent('esx_policejob:OutTrunk', target, source)
	end
end)

RegisterServerEvent('exile:idCard')
AddEventHandler('exile:idCard', function(target)
	TriggerClientEvent('esx_exilemenu:showID', target)
end)

RegisterServerEvent('xlem0n_policejob:pay')
AddEventHandler('xlem0n_policejob:pay', function(amount, target, charge, itsJail, jailtime)
    amount = tonumber(amount)
    local xPlayer = ESX.GetPlayerFromId(target)
    xPlayer.removeBank(amount)
    if itsJail then
        GetRPName(target, function(firstname, lastname)
			TriggerClientEvent("chat:addMessage1", -1, "Sędzia", {255,166,0}, "^*"..firstname.." "..lastname.."^r^7 otrzymał mandat w wysokości ^4"..amount.."$^7 za ^4"..charge, "fas fa-gavel")
        end)
    else
        GetRPName(target, function(firstname, lastname)
			TriggerClientEvent("chat:addMessage1", -1, "Sędzia", {255,166,0}, "^*"..firstname.." "..lastname.."^r^7 otrzymał karę wiezienia: ^4"..jailtime.." miesięcy ^7 za ^4"..charge.." ^7oraz karę o wartości: ^4"..amount.."$", "fas fa-gavel")
		end)
    end
end)

function GetRPName(playerId, data)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	
	if xPlayer then
		data(xPlayer.character.firstname, xPlayer.character.lastname)
	end
end

RegisterCommand('extrasy', function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.group == 'superadmin' or xPlayer.group == 'best' or xPlayer.group == "dev" then
		TriggerClientEvent('xlem0n_policejob:dodatkiGaraz', source)
	else
		xPlayer.showNotification('~r~Nie posiadasz permisji')
	end
end, false)

RegisterNetEvent('xlem0n_policejob:DodatkiKup')
AddEventHandler('xlem0n_policejob:DodatkiKup', function(tablica, dodatek, state)
	local _source = source
	if state == true then
		local xPlayer = ESX.GetPlayerFromId(source)
		TriggerClientEvent('esx:showNotification', _source, 'Zamontowano dodatek')
	elseif state == false then
		TriggerClientEvent('esx:showNotification', _source, 'Zdemontowano dodatek')
	end
end)

RegisterServerEvent("csskrouble:CLrev", function() 
	local _source = source
	local license = "brak"
	for k,v in pairs(GetPlayerIdentifiers(_source))do
		if string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		end
	end
	SavedInfo[license] = nil
end)

RegisterServerEvent("csskrouble:CLdeath", function() 
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local license = "brak"
	for k,v in pairs(GetPlayerIdentifiers(_source))do
		if string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		end
	end
	if xPlayer then
		local firstname = xPlayer.character.firstname
		local lastname  = xPlayer.character.lastname
		local sex       = xPlayer.character.sex
		local dob       = xPlayer.character.dateofbirth
		local height    = xPlayer.character.height

		local data = {
			name      = GetPlayerName(_source),
			job       = xPlayer.job,
			inventory = xPlayer.inventory,
			license = license,
			accounts  = xPlayer.accounts,
			firstname = firstname,
			lastname  = lastname,
			sex       = sex,
			dob       = dob,
			height    = height,
			money     = xPlayer.getMoney(),
			coords    = xPlayer.getCoords()
		}

		TriggerEvent('esx_license:getLicenses', _source, function(licenses)
			data.licenses = licenses
			SavedInfo[license] = data
		end)
	end
end)

function GetCoordsSQL(license) 
	local toreturn = nil
	MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @license", {
		['@license'] = license
	}, function(results) 
		if results[1] then
			if results[1].lastpos then
				local lastpos = json.decode(results[1].lastpos)
				toreturn = {x=lastpos[1], y=lastpos[2], z=lastpos[3], heading=lastpos[4]}
			end	
			if toreturn == nil then
				toreturn = false
			end
		end
	end)
	local tries = 0
	while toreturn == nil do
		tries = tries+1
		if tries >= 30 then
			break
		end	
		Citizen.Wait(150)
	end	
	return toreturn
end

AddEventHandler('playerDropped', function()
	local _source = source
	local id = GetPlayerIdentifiers(_source)
	local crds = GetEntityCoords(GetPlayerPed(_source))
	local license = "brak"
	for k,v in pairs(id) do
		if string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		end
	end
	
	if SearchTable[_source] then
		SearchTable[_source] = nil
	end
	if SearchTable1[license] then
		SearchTable1[license] = nil
	end	
	local d = SavedInfo[license]
	if d then
		TriggerClientEvent("csskrouble:offlineLoot", -1, license, crds)
	end	
end)

ESX.RegisterServerCallback('esx_policejob:checkSearch', function(source, cb, target)
	local _source = source
	
	if SearchTable[target] then
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_policejob:checkSearch2', function(source, cb, target)
	local _source = source
	
	if SearchTable[target] then
		cb(true)
	else
		SearchTable[target] = true
		cb(false)
	end
end)



ESX.RegisterServerCallback('esx_policejob:checkSearch1', function(source, cb, target)
	local _source = source
	
	if SearchTable1[target] then
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_policejob:checkSearch3', function(source, cb, target)
	local _source = source
	
	if SearchTable1[target] then
		cb(true)
	else
		SearchTable1[target] = true
		cb(false)
	end
end)

RegisterServerEvent('esx_policejob:cancelSearch1')
AddEventHandler('esx_policejob:cancelSearch1', function(target)
	if target and SearchTable1[target] then
		SearchTable1[target] = nil
	end
end)

RegisterServerEvent('esx_policejob:cancelSearch')
AddEventHandler('esx_policejob:cancelSearch', function(target)
	if target and SearchTable[target] then
		SearchTable[target] = nil
	end
end)

ESX.RegisterServerCallback('xlem0n_policejob:getOtherPlayerData', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	if xPlayer then
		local firstname = xPlayer.character.firstname
		local lastname  = xPlayer.character.lastname
		local sex       = xPlayer.character.sex
		local dob       = xPlayer.character.dateofbirth
		local height    = xPlayer.character.height

		local data = {
			name      = GetPlayerName(target),
			job       = xPlayer.job,
			inventory = xPlayer.inventory,
			accounts  = xPlayer.accounts,
			firstname = firstname,
			lastname  = lastname,
			sex       = sex,
			dob       = dob,
			height    = height,
			money     = xPlayer.getMoney()
		}

		TriggerEvent('esx_license:getLicenses', target, function(licenses)
			data.licenses = licenses
			cb(data)
		end)
	end
end)

ESX.RegisterServerCallback('xlem0n_policejob:getOtherPlayerData1', function(source, cb, target)
	cb(SavedInfo[target])
end)

ESX.RegisterServerCallback('xlem0n_policejob:getVehicleFromPlate', function(source, cb, plate)
	MySQL.query('SELECT owner, digit FROM owned_vehicles WHERE plate = ?', {plate}, function(result)
		if result[1] ~= nil then
			MySQL.query('SELECT firstname, lastname FROM characters WHERE identifier = ? AND digit = ?',  {result[1].owner, result[1].digit
			}, function(result2)

				cb(result2[1].firstname .. ' ' .. result2[1].lastname, true)

			end)
		else
			cb(_U('unknown'), false)
		end
	end)
end)

ESX.RegisterServerCallback('xlem0n_policejob:getSIM', function(source, cb, phone_number)
	MySQL.query('SELECT identifier, digit FROM users WHERE phone_number = @phone_number', {
		['@phone_number'] = phone_number
	}, function(result)
		if result[1] ~= nil then

			MySQL.query('SELECT firstname, lastname FROM characters WHERE identifier = @identifier AND digit = @digit',  {
				['@identifier'] = result[1].identifier,
				['@digit'] = result[1].digit
			}, function(result2)

				cb(result2[1].firstname .. ' ' .. result2[1].lastname, true)

			end)
		else
			cb(_U('unknown'), false)
		end
	end)
end)

ESX.RegisterServerCallback('xlem0n_policejob:getSERIAL', function(source, cb, serial_number)
	MySQL.query('SELECT * FROM items WHERE type = @type AND data LIKE @serial_number', {
		['@type'] = "weapon",
		['@serial_number'] = "%"..serial_number.."%"
	}, function(result)
		if result[1] ~= nil then

			MySQL.query('SELECT firstname, lastname FROM users WHERE inventory LIKE @inv',  {
				['@inv'] = "%"..result[1].name.."%"
			}, function(result2)
				if result2[1] ~= nil then
					cb(result2[1].firstname .. ' ' .. result2[1].lastname, true)
				else
					MySQL.query('SELECT firstname, lastname FROM characters WHERE inventory LIKE @inv',  {
						['@inv'] = "%"..result[1].name.."%"
					}, function(result3)
						if result3[1] ~= nil then
							cb(result3[1].firstname .. ' ' .. result3[1].lastname, true)
						else
							cb(_U('unknown'), false)
						end	
					end)
				end	
			end)
		else
			cb(_U('unknown'), false)
		end
	end)
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_phone:removeNumber', 'police')
	end
end)

RegisterServerEvent('xlem0n_policejob:message')
AddEventHandler('xlem0n_policejob:message', function(target, msg)
	if target ~= false then
		TriggerClientEvent('esx:showNotification', target, msg)
	end
end)

ESX.RegisterUsableItem('handcuff', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerClientEvent('Kajdanki', source)
end)

ESX.RegisterUsableItem('krotkofalowka', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('rp-radio:toogle', source)
end)

ESX.RegisterUsableItem('radio', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('rp-radio:toogle', source)
end)

RegisterServerEvent('xlem0n_policejob:DajLicencje')
AddEventHandler('xlem0n_policejob:DajLicencje', function (target)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(target)

	TriggerEvent('esx_license:addLicense', target, 'weapon')

   local name2 = GetPlayerName(target)
   exports['exile_logs']:SendLog(_source, "Gracz wydał licencję na broń dla: [" .. target .. "] " .. name2, 'license')
end)

RegisterServerEvent('xlem0n_policejob:giveItem')
AddEventHandler('xlem0n_policejob:giveItem', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' or xPlayer.job.name == 'offpolice' then
		if (itemName ~= 'flashlight') and (itemName ~= 'ironsights') and (itemName ~= 'opaska') and (itemname ~= 'clip_smg') and (itemname ~= 'clipsmg') and (itemName ~= 'clip') and (itemName ~= 'gps') and (itemName ~= 'panic') and (itemName ~= 'bodycam') and (itemName ~= 'radio') and (itemName ~= 'kolczatka') and (itemName ~= 'barierka') and (itemName ~= 'pacholek') and (itemName ~= 'extendedclip') and (itemName ~= 'grip') and (itemName ~= 'scope') and (itemName ~= 'suppressor') and (itemName ~= 'clip_extended') then
			exports['exile_logs']:SendLog(source, "Tried to give item %s without job (esx_policejob)\nItem name: "..itemName, "anticheat")
			return
		end
		local xItem = xPlayer.getInventoryItem(itemName)
		local itemm = 1
		if xItem.limit ~= -1 then
			itemm = xItem.limit - xItem.count
		end
		if xItem.count < xItem.limit then
			xPlayer.addInventoryItem(itemName, count ~= nil and count or itemm)
		else
			TriggerClientEvent('esx:showNotification', source, _U('max_item'))
		end
	else
		TriggerEvent("csskrouble:banPlr", "nigger", source, string.format("Tried to give item %s without job (esx_policejob)", itemName))
	end
end)

ESX.RegisterServerCallback("qalle_policearmory:pedExists", function(source, cb)
    if CachedPedState then
        cb(true)
    else
        CachedPedState = true
        cb(false)
    end
end)

ESX.RegisterServerCallback("misiaczek:HaveItem", function(source, cb, item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer ~= nil then
		if xPlayer.getInventoryItem(item) and xPlayer.getInventoryItem(item).count >= 1 then
			cb(true)
		else
			cb(false)
		end
	end
end)

ESX.RegisterUsableItem('lornetka', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerClientEvent('exile_lorneta:lornetaon', source)
end)

RegisterServerEvent('esx_policejob:requestarrest')
AddEventHandler('esx_policejob:requestarrest', function(targetid, playerheading, playerCoords,  playerlocation)
    local _source = source
    TriggerClientEvent('esx_policejob:getarrested', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('esx_policejob:doarrested', _source)
end)

RegisterServerEvent('esx_policejob:requestrelease')
AddEventHandler('esx_policejob:requestrelease', function(targetid, playerheading, playerCoords,  playerlocation)
    _source = source
    TriggerClientEvent('esx_policejob:getuncuffed', targetid, playerheading, playerCoords, playerlocation)
    TriggerClientEvent('esx_policejob:douncuffing', _source)
end)