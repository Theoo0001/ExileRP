ESX = nil
TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

local SERVER_TOKEN = "ExileSecurity"..math.random(9999,999999999999)

local TRIGGER_PAYCHECK = "exile_baker:paycheck"..math.random(99999,999999999)

RegisterServerEvent(TRIGGER_PAYCHECK)
AddEventHandler(TRIGGER_PAYCHECK, function(token, bCount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if token == SERVER_TOKEN then
		local count = xPlayer.getInventoryItem('breads').count
		local total = Config.PriceForBread * count

		if xPlayer.job.name == 'baker' then
			if xPlayer.job.grade == 8 then
				total = total * 1.5
			elseif xPlayer.job.grade == 7 then
				total = total * 1.45
			elseif xPlayer.job.grade == 6 then
				total = total * 1.4
			elseif xPlayer.job.grade == 5 then
				total = total * 1.35
			elseif xPlayer.job.grade == 4 then
				total = total * 1.28
			elseif xPlayer.job.grade == 3 then
				total = total * 1.21
			elseif xPlayer.job.grade == 2 then
				total = total * 1.14
			elseif xPlayer.job.grade == 1 then
				total = total * 1.07
			elseif xPlayer.job.grade == 0 then
				total = total
			end
		if bCount == count then
			if total < 60000 then
				TriggerEvent('esx_addonaccount:getSharedAccount', 'society_baker', function(account)
					if account then
						local playerMoney  = ESX.Math.Round(total)
						local societyMoney = ESX.Math.Round(total / 100 * 20)    
						xPlayer.addMoney(playerMoney)
						account.addAccountMoney(societyMoney)
						xPlayer.removeInventoryItem('breads',count)
						TriggerClientEvent('esx:showNotification', _source, '~o~Otrzymujesz wypłatę '..playerMoney..'$!')
						xPlayer.addInventoryItem('gwiazdki', 7)
                        xPlayer.showNotification('Otrzymano 7x Jajko Wielkanocne')
						exports['exile_logs']:SendLog(_source, "PIEKARZ: Zakończono kurs. Zarobek: " .. playerMoney .. "$", 'baker', '15844367')
					else
						xPlayer.addMoney(total)
						xPlayer.removeInventoryItem('breads',count)
						TriggerClientEvent('esx:showNotification', _source, '~o~Otrzymujesz wypłatę '..total..'$!')
						xPlayer.addInventoryItem('gwiazdki', 7)
                        xPlayer.showNotification('Otrzymano 7x Jajko Wielkanocne')
						exports['exile_logs']:SendLog(_source, "PIEKARZ: Zakończono kurs. Zarobek: " .. total .. "$", 'baker', '15844367')
					end
				end)
				if count >= 100 then
					TriggerEvent('ExileRP:saveCours', xPlayer.job.name, xPlayer.job.grade, xPlayer.source)
				end
			else
				TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to get money (Prace legalne)")
				--exports['exile_logs']:SendLog(_source, "PIEKARZ: Próba zarobienia wiecej siana niz 45k!", 'anticheat', '15844367')
			end
		else
			exports['exile_logs']:SendLog(_source, "PIEKARZ: Próba zbugowania sprzedawania", 'anticheat', '15844367')
		end

		else
			TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to add money without job (Prace legalne)")
			--exports['exile_logs']:SendLog(_source, "PIEKARZ: Próba dodania pieniędzy bez pracy!", 'anticheat', '15844367')
		end
	else
		TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to add money with wrong token (Prace legalne)")
		--exports['exile_logs']:SendLog(_source, "PIEKARZ: Próba dodania pieniędzy bez poprawnego tokenu", 'anticheat', '15844367')
	end
end)

ESX.RegisterServerCallback('exile_baker:giveItemCount', function(source, cb, itemName, itemCount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem(itemName)

	local countToAdd = itemCount

	if xItem.limit ~= -1 and (xItem.count + itemCount) > 1000 then
		countToAdd = 1000-xItem.count
	end

	xPlayer.addInventoryItem(xItem.name, countToAdd)
	cb(countToAdd)
end)

RegisterServerEvent('exile_baker:removeItemCount')
AddEventHandler('exile_baker:removeItemCount', function(itemName, itemCount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem(itemName)

	local countToAdd = itemCount

	if (xItem.count - itemCount) <= 0 then
		xPlayer.setInventoryItem(xItem.name, 0)
		countToAdd = xItem.count
	else		
		xPlayer.removeInventoryItem(xItem.name, countToAdd)
	end
end)

ESX.RegisterServerCallback('exile_baker:changeToAnother', function(source, cb, itemBeforeName, itemAfterName)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItemBefore = xPlayer.getInventoryItem(itemBeforeName)
	local xItemAfter = xPlayer.getInventoryItem(itemAfterName)

	local itemCount = math.floor((xItemBefore.count / 10))

	if (xItemBefore.count - itemCount) <= 0 then
		xPlayer.setInventoryItem(xItemBefore.name, 0)
	else
		xPlayer.removeInventoryItem(xItemBefore.name, xItemBefore.count)
	end

	if (xItemAfter.count + itemCount) > xItemAfter.limit then
		xPlayer.setInventoryItem(xItemAfter.name, xItemAfter.limit)
	else
		xPlayer.addInventoryItem(xItemAfter.name, itemCount)
	end

	cb(itemCount)
end)

ESX.RegisterServerCallback('exile_baker:changeToAnothers', function(source, cb, itemBeforeName, itemAfterName, removed)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItemBefore = xPlayer.getInventoryItem(itemBeforeName)
	local xItemAfter = xPlayer.getInventoryItem(itemAfterName)

	local counted = math.floor((xItemBefore.count / removed))

	for i=1, counted, 1 do
		if (xItemBefore.count - removed) <= 0 then
			xPlayer.setInventoryItem(xItemBefore.name, 0)
		else
			xPlayer.removeInventoryItem(xItemBefore.name, removed)
		end

		if (xItemAfter.count + 1) > xItemAfter.limit then
			xPlayer.setInventoryItem(xItemAfter.name, xItemAfter.limit)
		else
			xPlayer.addInventoryItem(xItemAfter.name, 1)
		end
	end

	cb(counted)
end)

local recived_token_baker = {}
RegisterServerEvent('exile_baker:request')
AddEventHandler('exile_baker:request', function()
	if not recived_token_baker[source] then
		TriggerClientEvent("exile_baker:getrequest", source, SERVER_TOKEN, TRIGGER_PAYCHECK)
		recived_token_baker[source] = true
	else
		TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to get token (Prace legalne)")
		--exports['exile_logs']:SendLog(source, "PIEKARZ: Próba otrzymania ponownie tokenu!", 'anticheat', '15844367')
	end
end)

AddEventHandler('playerDropped', function()
	recived_token_baker[source] = nil
end)


local SmiecieSiedzace = {}
RegisterServerEvent('exile_baker:insertPlayer')
AddEventHandler('exile_baker:insertPlayer', function(tablice)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local insertLabel = GetPlayerName(_source)..' ['..xPlayer.character.firstname ..' '.. xPlayer.character.lastname..'] '..os.date("%H:%M:%S")
	table.insert(SmiecieSiedzace, {label = insertLabel, plate = tablice})
end)

ESX.RegisterServerCallback('exile_baker:checkSiedzacy', function(source, cb)
	cb(SmiecieSiedzace)
end)
