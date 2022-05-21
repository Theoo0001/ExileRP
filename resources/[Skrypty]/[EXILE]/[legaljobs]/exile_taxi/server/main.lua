ESX = nil

PlayerSalary = {}
Events = {}

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

local taxiTable = {
	{
        name = "taxi",
        organizationName = "DownTown Cab"
    }
}

for i=1, #taxiTable, 1 do
    TriggerEvent('esx_society:registerSociety', taxiTable[i].name, taxiTable[i].organizationName, 'society_'..taxiTable[i].name, 'society_'..taxiTable[i].name, 'society_'..taxiTable[i].name, {type = 'private'})
end

RegisterServerEvent('exile_taxi:registerNewNPCTrack')
AddEventHandler('exile_taxi:registerNewNPCTrack', function(trackLenght)
	local xPlayer = ESX.GetPlayerFromId(source)

	if (Config.Zones[xPlayer.job.name]) then
		if Events[xPlayer.source] == nil then
			Events[xPlayer.source] = {
				type = 0,
				driver = xPlayer.source,
				lenght = trackLenght
			}
		end
	end
end)

RegisterServerEvent('exile_taxi:unregisterNPCTrack')
AddEventHandler('exile_taxi:unregisterNPCTrack', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if (Config.Zones[xPlayer.job.name]) then
		if Events[xPlayer.source] ~= nil then
			Events[xPlayer.source] = nil
		end
	end
end)

RegisterServerEvent('exile_taxi:registerNewPlayerTrack')
AddEventHandler('exile_taxi:registerNewPlayerTrack', function(passager, trackLenght)
	local xPlayer = ESX.GetPlayerFromId(source)

	if (Config.Zones[xPlayer.job.name]) then
		if Events[xPlayer.source] == nil then
			Events[xPlayer.source] = {
				type = 1,
				driver = xPlayer.source,
				passager = passager,
				lenght = trackLenght
			}
		end
	end
end)

RegisterServerEvent('exile_taxi:setTrackAsDone')
AddEventHandler('exile_taxi:setTrackAsDone', function(passager)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if (Config.Zones[xPlayer.job.name]) then
		if (Events[xPlayer.source] ~= nil) then
			if Events[xPlayer.source].type == 0 then
				if (xPlayer.source == Events[xPlayer.source].driver) then
					local total = ((Events[xPlayer.source].lenght/1000) * SConfig.Pricing["PER_KM"])
					if xPlayer.job.grade == 9 then
						total = total * 1.50
					elseif xPlayer.job.grade == 8 then
						total = total * 1.44
					elseif xPlayer.job.grade == 7 then
						total = total * 1.38
					elseif xPlayer.job.grade == 6 then
						total = total * 1.33
					elseif xPlayer.job.grade == 5 then
						total = total * 1.27
					elseif xPlayer.job.grade == 4 then
						total = total * 1.22
					elseif xPlayer.job.grade == 3 then
						total = total * 1.16
					elseif xPlayer.job.grade == 2 then
						total = total * 1.11
					elseif xPlayer.job.grade == 1 then
						total = total * 1.05
					end
					
					if tonumber(exports['esx_jobs']:ExportLevel(xPlayer.identifier)) > 0 then
						total = total + ((total * tonumber(exports['esx_jobs']:ExportLevel(xPlayer.identifier))) / 100)
					else
						total = total
					end
					if total < 45000 then
						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_taxi', function(account)
							if account then
								local playerMoney  = ESX.Math.Round(total)
								local societyMoney = ESX.Math.Round(total / 100 * 30)
		
								xPlayer.addMoney(playerMoney)
								account.addAccountMoney(societyMoney)
								if xPlayer.job.grade == 8 or xPlayer.job.grade == 9 then
									xPlayer.addInventoryItem('gwiazdki', 3)
									xPlayer.showNotification('Otrzymano 3x Jajko Wielkanocne')
									TriggerClientEvent('esx:showNotification', _source, "Twoja firma zarobiła ~g~" .. societyMoney .."$ ~s~\nZarobiłeś ~g~" .. playerMoney .. "$")
								else
									xPlayer.addInventoryItem('gwiazdki', 3)
									xPlayer.showNotification('Otrzymano 3x Jajko Wielkanocne')
									TriggerClientEvent('esx:showNotification', _source, "Zarobiłeś ~g~" .. playerMoney .. "$")
								end
								exports['exile_logs']:SendLog(_source, "ESX_TAXIJOB: Zakończono kurs. Zarobek: " .. playerMoney .. "$", 'taxi', '15844367')
							else
								xPlayer.addMoney(total)
								TriggerClientEvent('esx:showNotification', _source, "Zarobiłeś ~g~" .. total .. "$")
								xPlayer.addInventoryItem('gwiazdki', 2)
								xPlayer.showNotification('Otrzymano 2x Jajko Wielkanocne')
								exports['exile_logs']:SendLog(_source, "ESX_TAXIJOB: Zakończono kurs. Zarobek: " .. total .. "$", 'taxi', '15844367')
							end
						end)
						TriggerEvent('ExileRP:saveCours', xPlayer.job.name, xPlayer.job.grade, xPlayer.source)

						Events[xPlayer.source] = nil
					else
						TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to add money (Prace legalne)")
						--exports['exile_logs']:SendLog(_source, "ESX_TAXIJOB: Próba zarobienia wiecej siana niz 45k!", 'anticheat', '15844367')
					end
				end
			end
		else
			TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to add money too fast (Prace legalne)")
			--exports['exile_logs']:SendLog(_source, "ESX_TAXIJOB: Wykryto szybką próbę wypłaty pieniędzy", 'anticheat')
		end
	end
end)

RegisterNetEvent(GetCurrentResourceName() .. ':sellInvoices')
AddEventHandler(GetCurrentResourceName() .. ':sellInvoices', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local item = xPlayer.getInventoryItem('fakturataxi')
	
	if xPlayer.job.name == 'taxi' then
		if item.count >= 5 then
			xPlayer.removeInventoryItem('fakturataxi', 5)
			TriggerClientEvent('exile_taxi:invoicesSold', _source)
			exports['exile_logs']:SendLog(_source, "ESX_TAXIJOB: Oddano 5 faktur", 'taxi', '15105570')
		else
			TriggerClientEvent('esx:showNotification', _source, "Nie masz wystarczająco ~y~faktur")
		end
	end
end)

local SmiecieSiedzace = {}
RegisterServerEvent('taxi:insertSmiec')
AddEventHandler('taxi:insertSmiec', function(tablice)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local insertLabel = GetPlayerName(_source)..' ['..xPlayer.character.firstname ..' '.. xPlayer.character.lastname..'] '..os.date("%H:%M:%S")
	table.insert(SmiecieSiedzace, {label = insertLabel, plate = tablice})
end)

ESX.RegisterServerCallback('taxi:checkSiedzacy', function(source, cb)
	cb(SmiecieSiedzace)
end)