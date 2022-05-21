ESX                = nil

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

RegisterServerEvent('gunshotInProgress')
AddEventHandler('gunshotInProgress', function(coords, str, isPolice)
	local src = source
	if string.find(str, "Uwaga, strzały") then
		local Players = exports['esx_scoreboard']:MisiaczekPlayers()
		for k,v in pairs(Players) do
			if v.job == 'police' then
				TriggerClientEvent('gunshotPlace', v.id, coords, isPolice, str)
			end
		end
	else
		--TriggerEvent("csskrouble:banPlr", "nigger", source,  "Tried to send custom message (esx_jb_outlawalert)")
		exports['exile_logs']:SendLog(src, "Próbował wysłać inne powiadomienie poprzez centrale! [esx_jb_outlawalert]", 'anticheat', 0xFF0000)
	end	
end)

RegisterServerEvent('destroyingInProgress')
AddEventHandler('destroyingInProgress', function(coords, str)
	local _source = source
	if string.find(str, "Uwaga, podejrzany obywatel w okolicach złomowiska") then
		local Players = exports['esx_scoreboard']:MisiaczekPlayers()
		for k,v in pairs(Players) do
			if v.job == 'police' then
				TriggerClientEvent('destroyPlace', v.id, coords, str)
			end
		end
	else
		--TriggerEvent("csskrouble:banPlr", "nigger", source,  "Tried to send custom message (esx_jb_outlawalert)")
		exports['exile_logs']:SendLog(_source, "Próbował wysłać inne powiadomienie poprzez centrale! [esx_jb_outlawalert]", 'anticheat', 0xFF0000)
	end	
end)

RegisterServerEvent('sellDrugsInProgress')
AddEventHandler('sellDrugsInProgress', function(coords, str, photo, sex)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if string.find(str, " przy ^0") then
		local Players = exports['esx_scoreboard']:MisiaczekPlayers()
		for k,v in pairs(Players) do
			if v.job == 'police' then
				if photo == true then
					TriggerEvent('ReturnSkin', _source, function(data)
						local currentSkin = data
						TriggerClientEvent('drugPlace', v.id, coords, photo, xPlayer.source, sex, str, currentSkin)
					end)
				else
					TriggerClientEvent('drugPlace', v.id, coords, photo, xPlayer.source, sex, str)
				end
			end
		end
	else
		--TriggerEvent("csskrouble:banPlr", "nigger", source,  "Tried to send custom message (esx_jb_outlawalert)")
		exports['exile_logs']:SendLog(_source, "Próbował wysłać inne powiadomienie poprzez centrale! [esx_jb_outlawalert]", 'anticheat', 0xFF0000)
	end	
end)

RegisterServerEvent('notifyAccident')
AddEventHandler('notifyAccident', function(coords, str)
	local _source = source
	if string.find(str, " przy ^0") then
		local Players = exports['esx_scoreboard']:MisiaczekPlayers()
		for k,v in pairs(Players) do
			if v.job == 'police' then
				TriggerClientEvent('accidentPlace', v.id, coords, str)
			end
		end
	else
		--TriggerEvent("csskrouble:banPlr", "nigger", source,  "Tried to send custom message (esx_jb_outlawalert)")
		exports['exile_logs']:SendLog(_source, "Próbował wysłać inne powiadomienie poprzez centrale! [esx_jb_outlawalert]", 'anticheat', 0xFF0000)
	end	
end)

RegisterServerEvent('notifyThief')
AddEventHandler('notifyThief', function(coords, str)
	local _source = source
	if string.find(str, " przy ^0") then
		local Players = exports['esx_scoreboard']:MisiaczekPlayers()
		for k,v in pairs(Players) do
			if v.job == 'police' then
				TriggerClientEvent('thiefPlace', v.id, coords, str)
			end
		end
	else
		--TriggerEvent("csskrouble:banPlr", "nigger", source,  "Tried to send custom message (esx_jb_outlawalert)")
		exports['exile_logs']:SendLog(_source, "Próbował wysłać inne powiadomienie poprzez centrale! [esx_jb_outlawalert]", 'anticheat', 0xFF0000)
	end	
end)

RegisterServerEvent('outlawalert:sendNotif')
AddEventHandler('outlawalert:sendNotif', function(type, code, str)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if string.find(str, " przy ^0") then
		local GetPlayers = exports['esx_scoreboard']:MisiaczekPlayers()
		for k,v in pairs(GetPlayers) do		
			if v.job == 'police' then
				local odznaka = json.decode(xPlayer.character.job_id)
				
				TriggerClientEvent('bkPlace', v.id, v.job, xPlayer.getCoords(true), code, odznaka.id, str)
			end
		end
	else
		--TriggerEvent("csskrouble:banPlr", "nigger", source,  "Tried to send custom message (esx_jb_outlawalert)")
		exports['exile_logs']:SendLog(_source, "Próbował wysłać inne powiadomienie poprzez powiadomienia BK! [esx_jb_outlawalert]", 'anticheat', 0xFF0000)
	end	
end)

RegisterServerEvent("csskrouble:triedToEscapePD", function(id) 
	local src = source
	if tonumber(src) ~= nil then
		TriggerEvent('csskrouble:banPlr', "nigger", src, "Tried to trigger event (esx_jb_outlawalert)")
	else
		local xPlayer = ESX.GetPlayerFromId(id)
		local Players = exports['esx_scoreboard']:MisiaczekPlayers()
		for k,v in pairs(Players) do
			if v.job == 'police' then
				TriggerClientEvent('chat:addMessage1', v.id, "Służba więzienna", {0, 0, 0}, "^5"..xPlayer.character.firstname..' '..xPlayer.character.lastname.." ^7 próbował uciec z więzienia!", "fas fa-exclamation-triangle")
			end
		end
	end	
end)