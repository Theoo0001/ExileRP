ESX = nil

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

TriggerEvent('esx_society:registerSociety', 'ambulance', 'Ambulance', 'society_ambulance', 'society_ambulance', 'society_ambulance', {type = 'public'})
TriggerEvent('esx_society:registerSociety', 'ambulance', 'Ambulance', 'society_sams2', 'society_sams2', 'society_sams2', {type = 'public'})

local date = os.date('*t')
if date.month < 10 then date.month = '0' .. tostring(date.month) end
if date.day < 10 then date.day = '0' .. tostring(date.day) end
if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
if date.min < 10 then date.min = '0' .. tostring(date.min) end
if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' o godz: ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')

RegisterServerEvent('hypex_ambulancejob:hypexrevive')
AddEventHandler('hypex_ambulancejob:hypexrevive', function(target)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.getJob().name == 'ambulance' or xPlayer.getJob().name == 'offambulance' then 
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_sams2', function(account)
			account.addAccountMoney(3000)
			xPlayer.addMoney(Config.ReviveReward)
		end)
		TriggerClientEvent('hypex_ambulancejob:hypexrevive', target)
		--exports['exile_logs']:SendLog(source, "Medyk: "..xPlayer.name.." wskrzesił gracza: " ..target1.name.. " \nLicencja Gracza: "..target1.identifier, 'ambulancepodnoszenie', '5793266')
	else
		TriggerEvent("csskrouble:banPlr", "nigger", _source, "Tried to revive (esx_ambulancejob)")
		--exports['exile_logs']:SendLog(xPlayer.source, 'Chciał zarobić sianko na revive bez pracy medyka', 'anticheat', '5793266')
	end
end)

RegisterServerEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(target, type)
	TriggerClientEvent('esx_ambulancejob:heal', target, type)
end)

TriggerEvent('esx_phone:registerNumber', 'ambulance', _U('alert_ambulance'), true, true)

ESX.RegisterServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer ~= nil then
		if xPlayer.getAccount('money').money > 0 then
			xPlayer.setAccountMoney('money', 0)
		end

		if xPlayer.getAccount('black_money').money > 0 then
			xPlayer.setAccountMoney('black_money', 0)
		end

		for i=1, #xPlayer.inventory, 1 do
			if xPlayer.inventory[i].count > 0 then
				if xPlayer.inventory[i].type ~= 'sim' then
					xPlayer.removeInventoryItem(xPlayer.inventory[i].name, xPlayer.inventory[i].count)
				end
			end
		end
	end

	cb()
end)

if Config.EarlyRespawn and Config.EarlyRespawnFine then
	ESX.RegisterServerCallback('esx_ambulancejob:checkBalance', function(source, cb)

		local xPlayer = ESX.GetPlayerFromId(source)
		local bankBalance = xPlayer.getAccount('bank').money
		local finePayable = false

		if bankBalance >= Config.EarlyRespawnFineAmount then
			finePayable = true
		else
			finePayable = false
		end

		cb(finePayable)
	end)

	ESX.RegisterServerCallback('esx_ambulancejob:payFine', function(source, cb)
		local xPlayer = ESX.GetPlayerFromId(source)
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('respawn_fine', Config.EarlyRespawnFineAmount))
		xPlayer.removeAccountMoney('bank', Config.EarlyRespawnFineAmount)
		cb()
	end)
end

ESX.RegisterServerCallback('esx_ambulancejob:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local qtty = xPlayer.getInventoryItem(item).count
	cb(qtty)
end)

RegisterServerEvent('esx_ambulancejob:removeItem')
AddEventHandler('esx_ambulancejob:removeItem', function(item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem(item, 1)
	if item == 'bandage' then
		TriggerClientEvent('esx:showNotification', _source, _U('used_bandage'))
	elseif item == 'medikit' then
		TriggerClientEvent('esx:showNotification', _source, _U('used_medikit'))
	end
end)

RegisterServerEvent('esx_ambulancejob:giveItem')
AddEventHandler('esx_ambulancejob:giveItem', function(item, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if item == 'medikit' or item == 'bandage' or item == 'gps' or item == 'bodycam' or item == 'radio' then
		local limit = xPlayer.getInventoryItem(item).limit
		
		local delta = 1
		local qtty = xPlayer.getInventoryItem(item).count
		if limit ~= -1 then
			delta = limit - qtty
		end
		if qtty < limit then
			xPlayer.addInventoryItem(item, count ~= nil and count or delta)
		else
			TriggerClientEvent('esx:showNotification', _source, _U('max_item'))
		end
	else
		exports['exile_logs']:SendLog(_source, "ESX_AMBULANCEJOB: Uzycie eventu giveItem chciał zrespić item: "..item, "anticheat")
	end
end)

RegisterServerEvent('kossek-god-ambulance_naprawka')
AddEventHandler('kossek-god-ambulance_naprawka', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.getMoney() >= Config.CenaNaprawki then
		xPlayer.removeMoney(Config.CenaNaprawki)
		xPlayer.addInventoryItem('fixkit', 1)
		TriggerClientEvent('esx:showNotification', _source, "~g~Zakupiłeś zestaw naprawczy")
	else
		TriggerClientEvent('esx:showNotification', _source, "~r~Nie posiadasz "..Config.CenaNaprawki.."$")
	end

end)

RegisterCommand('revive', function(source, args, user)
	if source == 0 then
		TriggerClientEvent('hypex_ambulancejob:hypexrevive', tonumber(args[1]), true)
	else
		local xPlayer = ESX.GetPlayerFromId(source)
		if (xPlayer.group == 'best' or xPlayer.group == 'superadmin' or xPlayer.group == 'admin' or xPlayer.group == 'mod' or xPlayer.group == 'support' or xPlayer.group == 'trialsupport') then
			if args[1] ~= nil then
				if GetPlayerName(tonumber(args[1])) ~= nil then
					TriggerClientEvent("esx:showNotification", tonumber(args[1]), "~g~Zostałeś ożywiony przez administratora ~b~"..GetPlayerName(xPlayer.source).."~g~!")
					TriggerClientEvent('hypex_ambulancejob:hypexrevive', tonumber(args[1]), true)
					exports['exile_logs']:SendLog(source, "Użyto komendy /revive " .. tonumber(args[1]), "revive")
				end
			else
				TriggerClientEvent("esx:showNotification", source, "~g~Zostałeś ożywiony przez administratora!")
				TriggerClientEvent('hypex_ambulancejob:hypexrevive', source, true)
				exports['exile_logs']:SendLog(source, "Użyto komendy /revive", "revive")
			end
		else
			xPlayer.showNotification('~r~Nie posiadasz permisji')
		end
	end
end, false)

ESX.RegisterUsableItem('apteczka', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem('apteczka', 1)
	TriggerClientEvent('esx_ambulancejob:healitem', _source, 'bmedium')
	TriggerClientEvent('esx:showNotification', _source, _U('used_medikit'))
end)

ESX.RegisterUsableItem('bandaz', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent('esx_ambulancejob:healitem', _source, 'bsmall')
	xPlayer.removeInventoryItem('bandaz', 1)
end)


RegisterServerEvent('esx_ambulancejob:firstSpawn')
AddEventHandler('esx_ambulancejob:firstSpawn', function()
	local _source    = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.fetchAll('SELECT phone_number FROM users WHERE identifier=@identifier', {
		['@identifier'] = xPlayer.getIdentifier(),
	}, function(result)
		if result[1] ~= nil then
			
			local numer = result[1].phone_number
			if numer ~= nil then
				TriggerClientEvent('gcphone:myPhoneNumber', _source, numer)
				xPlayer.setCharacter('phone_number', result[1].phone_number)
			end
		end
	end)
end)

ESX.RegisterServerCallback('esx_ambulancejob:getDeathStatus', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.fetchScalar('SELECT isDead FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.getIdentifier(),
	}, function(isDead)

		cb(isDead)
	end)
end)

RegisterServerEvent('esx_ambulancejob:setDeathStatus')
AddEventHandler('esx_ambulancejob:setDeathStatus', function(isDead)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer ~= nil then
		MySQL.Sync.execute("UPDATE users SET isDead=@isDead WHERE identifier=@identifier", {
			['@identifier'] = xPlayer.identifier,
			['@isDead'] = isDead
		})
	end
end)

RegisterServerEvent('esx:ambulancejob:deathspawn')
AddEventHandler('esx:ambulancejob:deathspawn', function()
	local _source    = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.fetchAll('SELECT isDead FROM users WHERE identifier=@identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		if result[1] ~= nil then
			if result[1].isDead == 1 then
				TriggerClientEvent('esx_ambulancejob:requestDeath', _source)
			end
		end
	end)
end)

local SAMSList = {}

RegisterServerEvent('esx_ambulancejob:checkIsDuty')
AddEventHandler('esx_ambulancejob:checkIsDuty', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer then
		local grade = '[' .. xPlayer.job.grade_label .. '] '
		local characterName = xPlayer.character.firstname .. ' ' .. xPlayer.character.lastname
		if xPlayer.job.name == 'ambulance' then
			SAMSList[xPlayer.getName()] = { label = grade .. characterName }
		elseif SAMSList[xPlayer.getName()] then
			SAMSList[xPlayer.getName()] = nil
		end
	end
end)

AddEventHandler('esx:setJob', function(source, job, lastJob)
	local xPlayer = ESX.GetPlayerFromId(source)
	local grade = '[' .. xPlayer.job.grade_label .. '] '
	local characterName = xPlayer.character.firstname .. ' ' .. xPlayer.character.lastname
	if xPlayer then
		if xPlayer.getJob().name == 'ambulance' then
			SAMSList[xPlayer.getName()] = { label = grade .. characterName }
		elseif SAMSList[xPlayer.getName()] then
			SAMSList[xPlayer.getName()] = nil
		end
	end
end)

ESX.RegisterServerCallback('esx_ambulancejob:getDutyList', function(source, cb)
    if SAMSList then
      cb(SAMSList)
    else
      TriggerClientEvent('esx:showNotification', source, '~r~Brak medyków na służbie')
    end
end)

AddEventHandler('esx:playerDropped', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		local characterName = xPlayer.character.firstname .. ' ' .. xPlayer.character.lastname
		if xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'offambulance' then
			if SAMSList[xPlayer.getName()] then
				SAMSList[xPlayer.getName()] = nil
			end
		end
	end
end)

RegisterNetEvent('esx:onPlayerSpawn')
AddEventHandler('esx:onPlayerSpawn', function()
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)
    if xPlayer ~= nil then
		MySQL.Async.fetchScalar('SELECT isDead FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.getIdentifier(),
		}, function(isDead)
            if not isDead or isDead == 0 then 
                MySQL.Async.fetchAll("SELECT health, armour FROM users WHERE identifier = ?", {xPlayer.identifier}, function(data)
                    if data[1].health ~= nil and data[1].armour ~= nil then
                        TriggerClientEvent('esx_healthnarmour:set', playerId, data[1].health, data[1].armour)
                    end
                end)
            else
                TriggerClientEvent('esx_healthnarmour:set', playerId, 0, 0)
            end
        end)
    end
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
  local xPlayer = ESX.GetPlayerFromId(playerId)
  
  if xPlayer ~= nil then
    local health = GetEntityHealth(GetPlayerPed(xPlayer.source))
    local armour = GetPedArmour(GetPlayerPed(xPlayer.source))
	MySQL.Async.execute('UPDATE users SET health = @health, armour = @armour WHERE identifier = @identifier', {
		['@health'] = health,
		['@armour'] = armour,
		['@identifier'] = xPlayer.identifier})
  	end
end)

ESX.RegisterServerCallback('esx_society:getEmployeeslic', function(source, cb, job, society)
	MySQL.Async.fetchAll('SELECT firstname, lastname, identifier, job, job_grade FROM users WHERE job = @job OR job = @job2 ORDER BY job_grade DESC', {
		['@job'] = society,
		['@job2'] = 'off'..society,			
	}, function (results)
		local employees = {}
		local count = 0		
		for i=1,99 do if results[i] ~= nil then count = i else break end end
			for i=1, #results, 1 do
	
				local heli = false
				MySQL.Async.fetchAll('SELECT * FROM user_licenses WHERE owner = @owner', {
					['@owner'] = results[i].identifier,	
				}, function (results2)
					for k,v in pairs (results2) do
						
						if v.type == 'sams_heli' then
							heli = true
						end
					end	
				table.insert(employees, {
					name       = results[i].firstname .. ' ' .. results[i].lastname,
					identifier = results[i].identifier,
					licensess = {
					heli = heli,
					}
				})	
				if count == i then
					cb(employees)
				end				
				end)	
			end
	end)
end)

RegisterServerEvent('esx_ambulancejob:addlicense')
AddEventHandler('esx_ambulancejob:addlicense', function (identifier, licka)
    local _source = source
  	MySQL.Async.execute(
    	'INSERT INTO user_licenses (type, owner) VALUES (@type, @owner)',
    	{
      	['@type'] = licka,
      	['@owner']   = identifier
    	},
    	function (rowsChanged)
	end)
end)

RegisterServerEvent('esx_ambulancejob:removelicense')
AddEventHandler('esx_ambulancejob:removelicense', function (identifier, licka)
    local _source = source
  	MySQL.Async.execute(
    	'DELETE FROM user_licenses WHERE owner = @owner AND type = @type',
    	{
      	['@type'] = licka,
      	['@owner']   = identifier
    	},
    	function (rowsChanged)
	end)
end)