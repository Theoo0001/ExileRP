local PlayersWorking = {}
local PlayersLevels = {}
ESX = nil

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

function ExportLevel(identifier)
	return PlayersLevels[identifier]
end

local function Sell(source, item)
	if PlayersWorking[source] then
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.showNotification('~b~Poczekaj chwilę.~w~ Trwa ~y~sprzedawanie~w~ produktów...')
		Citizen.Wait(math.random(60000, 120000))
		if PlayersWorking[source] then
			local plevel = tonumber(PlayersLevels[xPlayer.identifier])
			local tempPrice = 0
			
			if plevel > 0 then
				tempPrice = item[1].price + ((item[1].price * plevel) / 100 )
			else
				tempPrice = item[1].price
			end

			if xPlayer.job.grade == 4 then
				tempPrice = tempPrice * 1.35
			elseif xPlayer.job.grade == 3 then
				tempPrice = tempPrice * 1.25
			elseif xPlayer.job.grade == 2 then
				tempPrice = tempPrice * 1.15
			elseif xPlayer.job.grade == 1 then
				tempPrice = tempPrice * 1.1
			end
			local itemToRemoveQtty = xPlayer.getInventoryItem(item[1].requires).count
			if itemToRemoveQtty > 0 then
				xPlayer.removeInventoryItem(item[1].requires, itemToRemoveQtty)
			end
			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..xPlayer.job.name, function(account)
				if account then
					local playerMoney  = ESX.Math.Round((tempPrice / 100 * 85) * itemToRemoveQtty)
					local societyMoney = ESX.Math.Round((tempPrice / 100 * 15) * itemToRemoveQtty)
					xPlayer.addMoney(playerMoney)
					account.addAccountMoney(societyMoney)
					xPlayer.showNotification("Sprzedałeś ~b~" .. item[1].requires_name .. " [" .. itemToRemoveQtty .. "]~w~ za ~y~" .. playerMoney .. "$")
				else
					xPlayer.addMoney(tempPrice * itemToRemoveQtty)
					xPlayer.showNotification("Sprzedałeś ~b~" .. item[1].requires_name .. " [" .. itemToRemoveQtty .. "]~w~ za ~y~" .. tempPrice * itemToRemoveQtty .. "$")
				end
			end)

			if itemToRemoveQtty >= item[1].max then
				TriggerClientEvent('flux:checkPoints', source, item[1].needs)
			end
		end
	end
end

local function Work(source, item, currentZone)

	SetTimeout(item[1].time, function()
		if PlayersWorking[source] == true then
			local xPlayer = ESX.GetPlayerFromId(source)
			
			if item ~= nil and xPlayer ~= nil then
				for i=1, #item, 1 do
					local itemQtty = 0
					
					if item[i].name ~= _U('delivery') then
						itemQtty = xPlayer.getInventoryItem(item[i].db_name).count
					end

					local requiredItemQtty = 0
					if item[1].requires ~= "nothing" then
						requiredItemQtty = xPlayer.getInventoryItem(item[1].requires).count
					end

					if item[i].name ~= _U('delivery') and itemQtty >= item[i].max then
						TriggerClientEvent('esx:showNotification', source, _U('max_limit', item[i].name))
						TriggerClientEvent('esx_jobs:stopAnim', source)
						TriggerClientEvent('flux:localPoint', source)
					elseif item[i].name ~= _U('delivery') and (item[1].requires ~= "nothing" and requiredItemQtty < item[i].remove) then
							TriggerClientEvent('esx:showNotification', source, _U('not_enough', item[1].requires_name))
							TriggerClientEvent('esx_jobs:stopAnim', source)
					elseif item[i].requires ~= "nothing" and requiredItemQtty <= 0 then
						if currentZone ~= 'TransferingNasiona' then
							TriggerClientEvent('esx:showNotification', source, _U('not_enough', item[1].requires_name))
							TriggerClientEvent('esx_jobs:stopAnim', source)
						else
							TriggerClientEvent('esx_jobs:stopAnim', source)
						end
					else
						if item[i].name ~= _U('delivery') then
							if item[i].drop == 100 then
								if currentZone ~= 'TransferingNasiona' then
									xPlayer.addInventoryItem(item[i].db_name, item[i].add)
								end
							else
								local chanceToDrop = math.random(100)
								if chanceToDrop <= item[i].drop then
									xPlayer.addInventoryItem(item[i].db_name, item[i].add)
								end
							end
						end
					end
				end

				if item[1].requires ~= "nothing" then
					local itemToRemoveQtty = xPlayer.getInventoryItem(item[1].requires).count
					if itemToRemoveQtty > 0 and currentZone ~= 'TransferingNasiona' then
						xPlayer.removeInventoryItem(item[1].requires, item[1].remove)
					elseif currentZone == 'TransferingNasiona' then
						if itemToRemoveQtty >= 100 then
							xPlayer.showNotification('~b~Poczekaj chwilę.~w~ Trwa ~y~przerabianie~w~ produktów...')
							Citizen.Wait(math.random(10000, 15000))
							xPlayer.removeInventoryItem(item[1].requires, 100)
							TriggerEvent('exile:addItemToStock', source, 'item_standard', item[1].db_name, 10, 'society_'..xPlayer.job.name)
						else
							xPlayer.showNotification("Potrzebujesz ~b~100 ziaren ~w~aby rozpocząć przerabianie!")
						end
					end
				end
			end
		
			Work(source, item, currentZone)

		end
	end)
end

RegisterServerEvent('flux:TriggerujSzmato')
AddEventHandler('flux:TriggerujSzmato', function(item, currentZone)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not PlayersWorking[source] then
		local itemQtty = 0
		if item[1].name ~= _U('delivery') then
			itemQtty = xPlayer.getInventoryItem(item[1].db_name).count
		end
		if item[1].name ~= _U('delivery') and itemQtty >= item[1].max then
			TriggerClientEvent('esx:showNotification', source, _U('max_limit', item[1].name))
			TriggerClientEvent('esx_jobs:stopAnim', source)
		else
			--[[if item[1].name == _U('delivery') then
				itemQtty = xPlayer.getInventoryItem(item[1].requires).count
			end
			if item[1].name == _U('delivery') and itemQtty >= item[1].max then
				item[1].hasMax = true
			else
				item[1].hasMax = false
			end]]
			PlayersWorking[source] = true
			if item[1].name == _U('delivery') then
				Sell(source, item)
			else
				Work(source, item, currentZone)
			end
		end
	end
end)

RegisterServerEvent('Flux:stopSzmato')
AddEventHandler('Flux:stopSzmato', function()
	PlayersWorking[source] = false
end)

RegisterServerEvent('flux:DawajAuto')
AddEventHandler('flux:DawajAuto', function(cautionType, spawnPoint, vehicle)
	local xPlayer = ESX.GetPlayerFromId(source)

	if cautionType == "take_car" then
		TriggerClientEvent('Flux:ustawiajFure', source, spawnPoint, vehicle)
	end
end)

RegisterServerEvent('flux:getLevel')
AddEventHandler('flux:getLevel', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer then
		MySQL.Async.fetchAll('SELECT job_level FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			local tTable = json.decode(result[1].job_level)
			local level = tTable.level
			PlayersLevels[xPlayer.identifier] = level
		end)
	end
end)

RegisterServerEvent('exile_jobs:DawajFaktureKurwo')
AddEventHandler('exile_jobs:DawajFaktureKurwo', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local losujIle = math.random(1, 4)
	if xPlayer ~= nil then
		if xPlayer.job.name == 'baker' or xPlayer.job.name == 'fisherman' or xPlayer.job.name == 'grower' or xPlayer.job.name == 'kawiarnia' or xPlayer.job.name == 'milkman' or xPlayer.job.name == 'weazel' then
			xPlayer.addInventoryItem('faktura'..xPlayer.job.name, losujIle)
		else
			TriggerEvent("csskrouble:banPlr", "nigger", source,  "Tried to give a invoice without job (esx_jobs)")
			--exports['exile_logs']:SendLog(_source, "Wykryto próbę dodania faktur bez odpowiedniej pracy: ESX_JOBS", 'anticheat', '15158332')
		end
	end
end)

RegisterServerEvent('flux:addLevelPoint')
AddEventHandler('flux:addLevelPoint', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.fetchAll('SELECT job_level FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
	
		local tTable = json.decode(result[1].job_level)
		local points = tTable.points
		local level = tTable.level
		local notification = ""

		
		if level < 50 then
			
			if (points + 1) == 5 then
				level = level + 1
				points = 0
				notification = "~g~Otrzymałeś awans!~w~ Jesteś na " .. level .. " szczeblu kariery!"
			elseif (points + 1) < 5 then
				level = level
				points = points + 1
				notification = "~b~Twój aktualny poziom to " .. level .. ".~w~ Musisz postarać się bardziej, aby otrzymać awans"
			end
			PlayersLevels[xPlayer.identifier] = level
			
			local sqlTable = {
				level = level,
				points = points
			}
			
			MySQL.Async.execute('UPDATE users SET job_level = @job_level WHERE identifier = @identifier', {
				['@identifier'] = xPlayer.identifier,
				['@job_level'] = json.encode(sqlTable)
			})

		else
			--[[if level > 50 then
				
				local nadajmax = {
					level = 50,
					points = 0,
					}

					MySQL.Async.execute('UPDATE users SET job_level = @job_level WHERE identifier = @identifier', {
						['@identifier'] = xPlayer.identifier,
						['@job_level'] = json.encode(nadajmaxa)
					})
					notification = "~g~Zredukowano twoj level do maximum!"
			else]]
				notification = "~w~Jesteś już na "..level.." szczeblu kariery! ~r~Nie możesz już otrzymać awansu."
			
			--end
		end
		

		--TriggerClientEvent('esx:showNotification', _source, notification)
		xPlayer.showNotification(notification)
	end)
end)