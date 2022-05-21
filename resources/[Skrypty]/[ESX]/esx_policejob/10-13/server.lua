------------------------------------------------------------------------------------------------------------

ESX = nil
TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

RegisterServerEvent("break_10-13srp:request")
AddEventHandler("break_10-13srp:request", function(Officer)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer ~= nil then
		if xPlayer.job.name == 'police' then
			jobTxt = 'Ranny funkcjonariusz'
		else
			jobTxt = 'Ranny medyk'
		end
		
			local text = "Obezwładniony funkcjonariusz użył dziwnego przycisku"
			color = {r = 256, g = 202, b = 247, alpha = 255}
			TriggerClientEvent('esx_rpchat:triggerDisplay', -1, text, _source, color)
		
		local odznaka = json.decode(xPlayer.character.job_id)
		local name = "[" .. odznaka.id .. "] " .. xPlayer.character.firstname .. " " .. xPlayer.character.lastname
		
		local GetPlayers = exports['esx_scoreboard']:MisiaczekPlayers()
		for k,v in pairs(GetPlayers) do
			if v.job == 'police' or v.job == 'ambulance' then				
				TriggerClientEvent("break_10-13srp:alert", v.id, Officer, name, jobTxt)
			end
		end
	end
	
end)

ESX.RegisterServerCallback('break_10-13srp:checkjob', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
 	if xPlayer.job.name == 'police' then
		cb(true)
	else
		cb(false)
	end
end)

RegisterCommand('c0', function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getInventoryItem('panic').count >= 1 then
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('flux:getCoords', source)
			xPlayer.removeInventoryItem('panic', 1)
			local text = "Obezwładniony funkcjonariusz użył dziwnego przycisku"
			color = {r = 256, g = 202, b = 247, alpha = 255}
			TriggerClientEvent('esx_rpchat:triggerDisplay', -1, text, _source, color)
		else
			TriggerClientEvent('esx:showNotification', source, "~r~Częstotliwość tego panic buttona została zablokowana!")
		end
	else
		TriggerClientEvent('esx:showNotification', source, "~r~Nie posiadasz panic buttona!")
	end
end)

RegisterServerEvent("flux:panicrequest")
AddEventHandler("flux:panicrequest", function(Officer)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer ~= nil then
			local text = "Obezwładniony funkcjonariusz użył dziwnego przycisku"
			color = {r = 256, g = 202, b = 247, alpha = 255}
			TriggerClientEvent('esx_rpchat:triggerDisplay', -1, text, _source, color)
		
		local odznaka = json.decode(xPlayer.character.job_id)
		local name = "[" .. odznaka.id .. "] " .. xPlayer.character.firstname .. " " .. xPlayer.character.lastname
		
		local GetPlayers = exports['esx_scoreboard']:MisiaczekPlayers()
		for k,v in pairs(GetPlayers) do
			if v.job == 'police' then								
				TriggerClientEvent("flux:triggerpanic", v.id, Officer, name)
			end
		end
		
	end
	
end)