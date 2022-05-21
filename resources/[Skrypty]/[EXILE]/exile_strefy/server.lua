ESX = nil

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)
HoldZones = {}

local actived = false

--[[Restart = function()
  local hour = tonumber(os.date('%H', os.time()))
    
  if not actived and hour == 06 then
		actived = true
		Tick()
    print("^exile_streft ^0Tick")
		Citizen.Wait(3600000)
		actived = false
	elseif not actived and hour == 12 then
		actived = true
		Tick()
    print("^exile_streft ^0Tick")
		Citizen.Wait(3600000)
		actived = false	
	elseif not actived and hour == 18 then
		actived = true
		Tick()
    print("^exile_streft ^0Tick")
		Citizen.Wait(3600000)
		actived = false	
	elseif not actived and hour == 24 then
		actived = true
		Tick()
    print("^exile_streft ^0Tick")
		Citizen.Wait(3600000)
		actived = false	
    end
end]]

Restart = function()
  local hour = tonumber(os.date('%H', os.time()))
    
  if not actived and hour == 01 then
		actived = true
		Tick()
    print("^exile_strefy ^0Tick")
		Citizen.Wait(3600000)
		actived = false
	elseif not actived and hour == 02 then
		actived = true
		Tick()
    print("^exile_strefy ^0Tick")
		Citizen.Wait(3600000)
		actived = false
	elseif not actived and hour == 03 then
		actived = true
		Tick()
    print("^exile_strefy ^0Tick")
		Citizen.Wait(3600000)
		actived = false
	elseif not actived and hour == 04 then
		actived = true
		Tick()
    print("^exile_strefy ^0Tick")
		Citizen.Wait(3600000)
		actived = false
	elseif not actived and hour == 05 then
		actived = true
		Tick()
    print("^exile_strefy ^0Tick")
		Citizen.Wait(3600000)
		actived = false
	elseif not actived and hour == 06 then
		actived = true
		Tick()
    print("^exile_strefy ^0Tick")
		Citizen.Wait(3600000)
		actived = false
	elseif not actived and hour == 07 then
		actived = true
		Tick()
    print("^exile_strefy ^0Tick")
		Citizen.Wait(3600000)
		actived = false
	elseif not actived and hour == 08 then
		actived = true
		Tick()
    print("^exile_strefy ^0Tick")
		Citizen.Wait(3600000)
		actived = false
	elseif not actived and hour == 09 then
		actived = true
		Tick()
    print("^exile_strefy ^0Tick")
		Citizen.Wait(3600000)
		actived = false	
	elseif not actived and hour == 10 then
		actived = true
		Tick()
    print("^exile_strefy ^0Tick")
		Citizen.Wait(3600000)
		actived = false	
	elseif not actived and hour == 11 then
		actived = true
		Tick()
    print("^exile_strefy ^0Tick")
		Citizen.Wait(3600000)
		actived = false
	elseif not actived and hour == 12 then
		actived = true
		Tick()
    print("^exile_strefy ^0Tick")
		Citizen.Wait(3600000)
		actived = false
	elseif not actived and hour == 13 then
		actived = true
		Tick()
    print("^exile_strefy ^0Tick")
		Citizen.Wait(3600000)
		actived = false
	elseif not actived and hour == 14 then
		actived = true
		Tick()
    print("^exile_strefy ^0Tick")
		Citizen.Wait(3600000)
		actived = false
	elseif not actived and hour == 15 then
		actived = true
		Tick()
    print("^exile_strefy ^0Tick")
		Citizen.Wait(3600000)
		actived = false
	elseif not actived and hour == 16 then
		actived = true
		Tick()
    print("^exile_strefy ^0Tick")
		Citizen.Wait(3600000)
		actived = false
	elseif not actived and hour == 17 then
		actived = true
		Tick()
    print("^exile_strefy ^0Tick")
		Citizen.Wait(3600000)
		actived = false
	elseif not actived and hour == 18 then
		actived = true
		Tick()
    print("^exile_strefy ^0Tick")
		Citizen.Wait(3600000)
		actived = false
	elseif not actived and hour == 19 then
		actived = true
		Tick()
    print("^exile_strefy ^0Tick")
		Citizen.Wait(3600000)
		actived = false
	elseif not actived and hour == 20 then
		actived = true
		Tick()
    print("^exile_strefy ^0Tick")
		Citizen.Wait(3600000)
		actived = false
	elseif not actived and hour == 21 then
		actived = true
		Tick()
    print("^exile_strefy ^0Tick")
		Citizen.Wait(3600000)
		actived = false
	elseif not actived and hour == 22 then
		actived = true
		Tick()
    print("^exile_strefy ^0Tick")
		Citizen.Wait(3600000)
		actived = false
	elseif not actived and hour == 23 then
		actived = true
		Tick()
    print("^exile_strefy ^0Tick")
		Citizen.Wait(3600000)
		actived = false
	elseif not actived and hour == 24 then
		actived = true
		Tick()
    print("^exile_strefy ^0Tick")
		Citizen.Wait(3600000)
		actived = false
  end
end

CreateThread(function()
    while true do
		Citizen.Wait(1000 * 30)
        Restart()
	end
end)

function Tick()
	for event,_ in pairs(Config.Strefy) do
		if Config.Strefy[event].items ~= nil then
			for k,v in pairs(Config.Strefy[event].items) do
				TriggerEvent('esx_addoninventory:getSharedInventory', 'society_strefy' .. event, function(inventory)
					if inventory then
						local item = inventory.getItem(k)
						
						if item.count < 100 then
							inventory.addItem(k, v)
						end
					end
				end)
			end
		end
		
		if Config.Strefy[event].reward ~= false then
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_strefy' .. event, function(account)
				if account then
					if account.money < 4000000 then
						account.addMoney(Config.Strefy[event].reward)
					end
				end
			end)
		end
	end
end

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT zone, label, name, time FROM exile_zones ',  {

	}, function(result)
		for k,v in ipairs(result) do
			HoldZones[v.zone] = {v.time, v.name}
		end
	end)
	
	for event,_ in pairs(Config.Strefy) do
		local addon_account = MySQL.Sync.fetchAll('SELECT name FROM addon_account WHERE name = @name', {
			['@name'] = 'society_strefy'..event,
		})
		
		local addon_inventory = MySQL.Sync.fetchAll('SELECT name FROM addon_inventory WHERE name = @name', {
			['@name'] = 'society_strefy'..event,
		})
		
		if addon_account[1] == nil then
			MySQL.Async.execute('INSERT INTO addon_account (`name`, `label`, `shared`) VALUES (@name, @label, @shared)', {
				['@name'] = 'society_strefy'..event,
				['@label'] = 'strefy'..event,
				['@shared'] = 1,
			})			
		end
		
		if addon_inventory[1] == nil then
			MySQL.Async.execute('INSERT INTO addon_inventory (`name`, `label`, `shared`) VALUES (@name, @label, @shared)', {
				['@name'] = 'society_strefy'..event,
				['@label'] = 'strefy'..event,
				['@shared'] = 1,
			})		
		end
	end
end)

ESX.RegisterServerCallback('exile_strefy:checkStrefy', function(source, cb)	
	if HoldZones then
		cb(HoldZones)
	else
		cb({})
	end
end)

RegisterServerEvent("exile_strefy:start")
AddEventHandler("exile_strefy:start", function(zone)
    TriggerClientEvent("exile_strefy:startZone", -1, zone)
    TriggerClientEvent("exile_strefy:CreateBlip", -1, zone)
	
	SendLog('exile_strefy | STREFY', 'Strefa **'..zone..'** została uruchomiona\n**Data: **'..os.date("%Y/%m/%d %X"), 56108)
end)

RegisterServerEvent("exile_strefy:zoneTakenServer")
AddEventHandler("exile_strefy:zoneTakenServer", function(job, job_label, currentZone)
    TriggerClientEvent("exile_strefy:RemoveActiveZone", -1, currentZone, job_label, job)
    TriggerEvent("exile_strefy:SaveZone", currentZone, job, job_label)
end)


RegisterServerEvent("exile_strefy:HoldZone")
AddEventHandler("exile_strefy:HoldZone", function(currentZone, bool, job, job_label)	
	if bool then
		if not HoldZones[currentZone] then
			HoldZones[currentZone] = {os.time() + 600, 'nonjob'}	
		else
			HoldZones[currentZone][1] = os.time() + 600
		end	

		TriggerClientEvent('exile_strefy:startZone', -1, currentZone, job, job_label)
	-- else
		-- if HoldZones[currentZone] then
			-- HoldZones[currentZone][3] = false
		-- end
	end
end)

PlayersOrg = {}

RegisterNetEvent("exile_strefy:SetJob")
AddEventHandler("exile_strefy:SetJob", function(job) 
	local src = source
	if src then
		local xPlayer = ESX.GetPlayerFromId(src)
		PlayersOrg[xPlayer.identifier] = {
			digit = xPlayer.digit,
			job = job
		}
	end
end)

ESX.RegisterServerCallback('exile_strefy:CheckZone', function(source, cb, currentZone)
	local hour = tonumber(os.date('%H%M', os.time()))
	local xPlayer = ESX.GetPlayerFromId(source)
	if HoldZones[currentZone] then
		if HoldZones[currentZone][1] < os.time() then
			if xPlayer ~= nil then
				if hour <= 2400 and hour >= 1200 then
					cb(false)
				else

					local count = 0
					MySQL.Async.fetchAll('SELECT name FROM exile_zones WHERE zone = @zone',  {
						['@zone'] = currentZone,
					}, function(result)
					
						if result[1] ~= nil then
							for k,v in pairs(PlayersOrg) do
								local xPlayer = ESX.GetPlayerFromIdentifier(k)

								if xPlayer and xPlayer.digit == v.digit and result[1].name == v.job then
									count = count + 1
								end
							end
						else
							count = 10
						end
						
						if count <= 2 then
							xPlayer.showNotification('~s~Brak odpowieniej liczby osób z organizacji która posiada tą strefę!')
							cb(true)
						else
							cb(false)
						end
					end)
				end
			end
		else
			xPlayer.showNotification('Strefę będzie można przejąć: '..os.date("%Y/%m/%d %X", HoldZones[currentZone][1]))
		end
	else
		if xPlayer ~= nil then
			if hour <= 2400 and hour >= 1200 then
				cb(false)
			else
				xPlayer.showNotification('Strefę można będzie przejąć od 12:00 do 24:00')
				cb(true)
			end
		end
	end
end)

RegisterServerEvent("exile_strefy:SaveZone")
AddEventHandler("exile_strefy:SaveZone", function(currentZone, job, job_label)
	local delay = {
		[1] = 3600,
		
		[2] = 1800,
		
		[3] = 3600,
		
		[4] = 1800,
		
		[5] = 1800,
		
		[6] = 3600,
		
		[7] = 1800,

		[8] = 20,

		[9] = 20,
	}
	
	MySQL.Async.fetchAll('SELECT name FROM exile_zones WHERE zone = @zone',  {
		['@zone'] = currentZone,
	}, function(result)
		if result[1] ~= nil then
			MySQL.Async.execute('UPDATE exile_zones SET name = @name, label = @label, time = @time WHERE zone = @zone', {
				['@zone'] = currentZone,
				['@name'] = job,
				['@label'] = job_label,
				['@time'] = math.floor(os.time() + delay[currentZone])
			}, function()		
				TriggerEvent('esx_teleports:update', job, currentZone)
			end)
		else
			MySQL.Async.execute('INSERT INTO exile_zones (name, label, zone, time) VALUES (@name, @label, @zone, @time)', {
				['@name'] = job,
				['@label'] = job_label,
				['@zone'] = currentZone,
				['@time'] = math.floor(os.time() + delay[currentZone])
			}, function(result)
				TriggerEvent('esx_teleports:update', job, currentZone)
			end)
		end
	end)
	
	TriggerClientEvent('exile_strefy:refreshOcupped', -1, job, currentZone)
	
	HoldZones[currentZone] = {math.floor(os.time() + delay[currentZone]), job}
	
	if Config.Strefy[currentZone].items ~= nil then
		for k,v in pairs(Config.Strefy[currentZone].items) do
			TriggerEvent('esx_addoninventory:getSharedInventory', 'society_strefy' .. currentZone, function(inventory)
				if inventory then
					inventory.addItem(k, v)
				end
			end)
		end
	end
	
	if Config.Strefy[currentZone].reward ~= false then
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_strefy' .. currentZone, function(account)
			if account then
				account.addMoney(Config.Strefy[currentZone].reward)
			end
		end)
	end
	
	
	SendLog('Exile-Handler', '**Przejmowanie stref:**\nStrefa **'..currentZone..'** została przejęta przez organizacje:\n Nazwa: **'..job_label..'**\n Job: **'..job..'** \nZdobyte przedmioty: **'..Config.Strefy[currentZone].itemslog..'**\n Zdobyte pieniądze:** '..Config.Strefy[currentZone].reward..'$** \nData przejęcia: **'..os.date("%Y/%m/%d %X").."**", 56108)
end)

ESX.RegisterServerCallback('exile_strefy:getStock', function(source, cb, society)
	local money = 0
	local items      = {}
	
	TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
		if account then
			money = account.money
		end
	end)

	TriggerEvent('esx_addoninventory:getSharedInventory', society, function(inventory)
		if inventory then
			for i=1, #inventory.items, 1 do
				if inventory.items[i].count > 0 then
					table.insert(items, inventory.items[i])
				end
			end
		end
	end)
	
	cb({
		blackMoney = money,
		items      = items,
	})
end)

ESX.RegisterServerCallback('exile_strefy:removeStock', function(source, cb, type, value, count, society)
	local xPlayer = ESX.GetPlayerFromId(source)
	local Identifier = xPlayer.getIdentifier()
	
	if type == 'item_account' then
		TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
			if account then
				local AccountMoney = account.money

				if AccountMoney >= count then
					account.removeMoney(count)
					xPlayer.addAccountMoney('black_money', count)
					TriggerClientEvent('esx:showNotification', xPlayer.source, "Pobrałeś/aś "..count.. "$ brudnej gotówki")
					--SendLog('Exile-Handler', "Gracz ID: "..xPlayer.source.."\nGracz IDENTIFIER: "..Identifier.."\nWyjął z przejętej strefy brudną gotówkę w ilości: "..count, 56108)
					exports['exile_logs']:SendLog(xPlayer.source, "Wyjął z przejętej strefy brudną gotówkę w ilości: "..count, 'strefy', '5793266')
				else
					TriggerClientEvent('esx:showNotification', source, "Nieprawidłowa ilość")
				end
			end
		end)	
	elseif type == 'item_standard' then
		local sourceItem = xPlayer.getInventoryItem(item)
		TriggerEvent('esx_addoninventory:getSharedInventory', society, function(inventory)
			local item = inventory.getItem(value)
			local sourceItem = xPlayer.getInventoryItem(value)

			if count > 0 and item.count >= count then
				if xPlayer.canCarryItem(value, count) then
					inventory.removeItem(value, count)
					xPlayer.addInventoryItem(value, count)
					TriggerClientEvent('esx:showNotification', xPlayer.source, "Pobrałeś/aś x"..count..' '..item.label)
					--SendLog('Exile-Handler', "Gracz ID: "..xPlayer.source.."\nGracz IDENTIFIER: "..Identifier.."\nWyjął z przejętej strefy item: "..item.label.." w ilości: "..count, 56108)
					exports['exile_logs']:SendLog(xPlayer.source, "Wyjął z przejętej strefy item: "..item.label.." w ilości: "..count, 'strefy', '5793266')
				else
					xPlayer.showNotification('Nie możesz więcej unieść')
				end
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, "Nieprawidłowa ilość")
			end
		end)	
	end
	
	cb()
end)

function SendLog(name, message, color)
	local embeds = {
		{
			["description"]=message,
			["type"]="rich",
			["color"] =5793266,
			["footer"]=  {
			["text"]= "Exile-Handler",
			},
		}
	}
	if message == nil or message == '' then return FALSE end
	
	local webhook = 'https://discord.com/api/webhooks/909416366426165308/y7vXtmwik4Jgb6C0Upjun_TVNqgIx6WxakuqDXNgnmssnLLzh4Ig09GAF3JdkPvj9qTt'	
	PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

ESX.RegisterServerCallback('xfsd:checkZoneOwner', function(source, cb, currentZone)
	local result = MySQL.Sync.fetchAll("SELECT name FROM exile_zones WHERE zone=@zone", { 
		['@zone'] = currentZone
	})

	if not result[1].name then
		cb(false)
	elseif result[1].name == nil then
		cb(false)
	else
		cb(result[1].name)
	end
end)

RegisterServerEvent('xfsd:sendlog')
AddEventHandler('xfsd:sendlog', function(currentZone)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if xPlayer ~= false then
		SendLog('Exile-Handler', xPlayer.name..' \nID: '..src..'\nLICENSE: '..xPlayer.identifier..'\nORG: ('..xPlayer.hiddenjob.name..') \nRozpoczął przejmowanie strefy ['..currentZone..']\n**Data: **'..os.date("%Y/%m/%d %X"), 56108)
	end
end)