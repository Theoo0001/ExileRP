ESX = nil
local Walizki = {}
TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

RegisterCommand("okup", function(source, args, rawCommand)
	if (source > 0) then
		local xPlayer = ESX.GetPlayerFromId(source)
		if args[1] ~= nil and tonumber(args[1]) > 0 then
			if xPlayer.job.name == 'police' and xPlayer.job.grade >= 5 then
				local lastWalizka = 1
				for i=1, #Walizki, 1 do
					if Walizki[i].id > lastWalizka then
						lastWalizka = Walizki[i].id
					end
				end
				table.insert(Walizki, {id = lastWalizka + 1, amount = tonumber(args[1]), allow = true})
				TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
					account.removeAccountMoney(tonumber(args[1]))
				end)
				TriggerClientEvent('esx_policejob:spawnWalizka', source, lastWalizka + 1)
				exports['exile_logs']:SendLog(source, "Gracz postawił walizkę z okupem o wysokości: " .. tonumber(args[1]) .. "$", 'okupsasp')
			end
		end
    end
end, false)

ESX.RegisterServerCallback('esx_policejob:tryWalizka', function(source, cb, id)
	local found = false
	for i=1, #Walizki, 1 do
		if Walizki[i].id == id then
			if Walizki[i].allow == true then
				Walizki[i].allow = false
				found = true
				break
			else
				found = false
				break
			end
		end
	end

	cb(found)
end)

RegisterServerEvent('esx_policejob:spawnWalizka')
AddEventHandler('esx_policejob:spawnWalizka', function(id, coords)
	for i=1, #Walizki, 1 do
		if Walizki[i].id == id then
			TriggerClientEvent('esx_policejob:spawnedWalizka', -1, id, coords, Walizki[i].amount)
			break
		end
	end
end)

RegisterServerEvent('esx_policejob:grabWalizka')
AddEventHandler('esx_policejob:grabWalizka', function(id)
	TriggerClientEvent('esx_policejob:despawnWalizka', -1, id)
end)	

RegisterServerEvent('esx_policejob:openWalizka')
AddEventHandler('esx_policejob:openWalizka', function(id)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	for i=1, #Walizki, 1 do
		if Walizki[i].id == id then
			xPlayer.addAccountMoney('black_money', Walizki[i].amount)
			xPlayer.showNotification('Walizka z ~y~' .. Walizki[i].amount .. '$~w~ została ~g~otwarta')
			exports['exile_logs']:SendLog(_source, "Gracz otworzył walizkę z okupem: " .. Walizki[i].amount .. "$", 'okupsasp')
			table.remove(Walizki, i)
			break
		end
	end
end)