local rob = false
local robbers = {}
local LastRobbed = {}
local GlobalLastRobbed = 0
ESX = nil

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM holdup', {}, function(result)
		for i=1, #result, 1 do
			if result[i].nextRob == nil then result[i].nextRob = 0 end
			LastRobbed[tostring(result[i].name)] = result[i].nextRob
		end
	end)
end)

function UpdateDB(name, tTime)
	MySQL.Async.execute('UPDATE holdup SET nextRob = @nextRob WHERE name = @name', 
		{
			['@name'] = name,
			['@nextRob'] = tTime
		}
	)
end

RegisterServerEvent('esx_holdup:tooFar')
AddEventHandler('esx_holdup:tooFar', function(currentStore)
	local _source = source
	local store = Stores[currentStore]
	rob = false
	
	local xPlayers = exports['esx_scoreboard']:MisiaczekPlayers()
	for k,v in pairs(xPlayers) do
		if v.job == 'police' then
			TriggerClientEvent('esx_holdup:killBlip', v.id)
		end
	end
	
	napad = false
	if robbers[_source] then
		local _source = source
		local xPlayer = ESX.GetPlayerFromId(_source)
		TriggerClientEvent('esx_holdup:tooFar', _source)
		robbers[_source] = nil
		TriggerClientEvent('esx:showNotification', _source, _U('robbery_cancelled_at', Stores[currentStore].name))
		LastRobbed[currentStore] = os.time() + Stores[currentStore].delay.failure
		UpdateDB(currentStore, os.time() + Stores[currentStore].delay.failure)
	end
end)

function checkOtherItems(xPlayer, type) 
	local has = false
	local hasItems = {}
	local missingItems = {}
	local str = "~b~By rozpocząć ten napad musisz posiadać: ~w~"
	if Stores[type].requiredItems then
		for i,v in pairs(Stores[type].requiredItems) do
			if xPlayer.getInventoryItem(v.item) and xPlayer.getInventoryItem(v.item).count >= 1 then
				table.insert(hasItems, v.item)
			else
				table.insert(missingItems, v.label)
			end
		end
	end
	if #missingItems < 1 then
		has = true
	end
	if has then
		for k,v in pairs(hasItems) do
			if xPlayer.getInventoryItem(v) and xPlayer.getInventoryItem(v).count >= 1 then
				xPlayer.removeInventoryItem(v, 1)
			else
				has = false
			end
		end
	else
		str = str..table.concat(missingItems, ", ")
		TriggerClientEvent('esx:showNotification', xPlayer.source, str)
	end
	return has
end

RegisterServerEvent('esx_holdup:robberyStarted')
AddEventHandler('esx_holdup:robberyStarted', function(currentStore)
	local _source  = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	local store = Stores[currentStore]
	local xPlayers = exports['esx_scoreboard']:MisiaczekPlayers()
	local cops = exports['esx_scoreboard']:CounterPlayers('police')
	local podjebalWiertlo = ''
	
	if cops >= Config.typeNapad[store.type].cops then
		if LastRobbed[currentStore] == nil then 
			LastRobbed[currentStore] = 0
			MySQL.Async.execute('INSERT INTO holdup (name, nextRob) VALUES (@name, @nextRob)', 
			{
				['@name'] = currentStore,
				['@nextRob'] = 0
			})
		end
		if LastRobbed[currentStore] <= os.time() then
		
		else
			TriggerClientEvent('esx:showNotification', _source, _U('recently_robbed', LastRobbed[currentStore] - os.time()))
			return
		end

		if GlobalLastRobbed <= os.time() then
			
		else 
			TriggerClientEvent('esx:showNotification', _source, "Poczekaj jeszcze ~y~" .. GlobalLastRobbed - os.time() .. " sekund~w~ zanim będzie można ~r~rozpocząć jakikolwiek napad")
			return
		end

		if not rob then
			if Config.typeNapad[store.type].drill then
				if xPlayer.getInventoryItem('drill').count >= 1 then
					local a = checkOtherItems(xPlayer, currentStore)
					if a then
						xPlayer.removeInventoryItem('drill', 1)
						podjebalWiertlo = 'drill'
						napad = true
					end
				else
					TriggerClientEvent('esx:showNotification', _source, ('~r~Aby zacząć wiercić potrzebujesz wiertło'))
				end
			if Config.typeNapad[store.type].drill2 then
					if xPlayer.getInventoryItem('drill2').count >= 1 then
						local a = checkOtherItems(xPlayer, currentStore)
						if a then
							xPlayer.removeInventoryItem('drill2', 1)
							podjebalWiertlo = 'drill2'
							napad = true
						end
					else
						TriggerClientEvent('esx:showNotification', _source, ('~r~Aby zacząć wiercić potrzebujesz wiertło drugiej generacji'))
					end
				end
			else
				napad = true
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('robbery_already'))
			return
		end
	else
		TriggerClientEvent('esx:showNotification', _source, 'Minimalnie musi być ~b~'..Config.typeNapad[store.type].cops..' ~s~policjantów, aby rozpocząć napad')
	end
	
	if napad then
		if Stores[currentStore] then

			if not rob then
				rob = true	
				podjebalWiertlo = ''
				for k,v in pairs(xPlayers) do
					if v.job == 'police' then
						TriggerClientEvent('esx_holdup:setBlip', v.id, Stores[currentStore].position, _U('rob_in_prog', store.name))
					end
				end
				exports['exile_logs']:SendLog(_source, "Rozpoczął napad na: "..currentStore, "napady")

				TriggerClientEvent('esx_holdup:animation', _source, Config.typeNapad[store.type].Animation)

				TriggerClientEvent('esx_holdup:currentlyRobbing', _source, currentStore)
				TriggerClientEvent('esx_holdup:startTimer', _source, Config.typeNapad[store.type].secondsRemaining)
				
				robbers[_source] = currentStore

				SetTimeout(Config.typeNapad[store.type].secondsRemaining * 1000, function()
					if robbers[_source] then
						if xPlayer then
							xPlayer.addAccountMoney('black_money', store.reward)
							local rewardString = nil
							if store.secondChance ~= nil and store.secondChance > 0 then
								local chanceToDrop = math.random(100)
								rewardString = ""
								if chanceToDrop <= store.secondChance then
									for j=1, #store.secondRewards, 1 do
										local chanceToDrop2 = math.random(100)
										if chanceToDrop2 <= store.secondRewards[j].chance then
											xPlayer.addInventoryItem(store.secondRewards[j].item, store.secondRewards[j].count)
											xPlayer.addInventoryWeapon(store.secondRewards[j].weapon, store.secondRewards[j].count, 50, true)
											rewardString = rewardString .. " oraz " .. store.secondRewards[j].label .. " x" .. store.secondRewards[j].count
										end
									end
								end
							end
							if rewardString ~= nil and rewardString ~= "" then
								TriggerClientEvent('esx_holdup:robberyComplete', _source, store.reward .. rewardString)
								exports['exile_logs']:SendLog(_source, "Zakończono napad na: "..currentStore.." Zarobek: "..store.reward .. rewardString, "napady")
							else
								TriggerClientEvent('esx_holdup:robberyComplete', _source, store.reward)
								exports['exile_logs']:SendLog(_source, "Zakończono napad na: "..currentStore.." Zarobek: "..store.reward, "napady")
							end
							napad = false
							
							for k,v in pairs(xPlayers) do
								if v.job == 'police' then
									TriggerClientEvent('esx_holdup:killBlip', v.id)
								end
							end
							LastRobbed[currentStore] = os.time() + Stores[currentStore].delay.success
							UpdateDB(currentStore, os.time() + Stores[currentStore].delay.success)
							GlobalLastRobbed = os.time() + 2100
							rob = false
						end
					end
				end)
			else
				if podjebalWiertlo ~= '' then
					if xPlayer then
						xPlayer.addInventoryItem(podjebalWiertlo, 1)
						podjebalWiertlo = ''
					end
				end
				TriggerClientEvent('esx:showNotification', _source, _U('robbery_already'))
			end
		end
	end
end)
