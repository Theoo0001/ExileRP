ESX = nil
TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

local strCmd = ("/exile4.0/s1/restart.sh")
local GIGANIGA = ([[C:\SerweryNowe\RESTART\WLOFF.bat]])
local isCanceled = false

function flux_reboot(czas)
	local minuty = czas
	if minuty == nil or minuty == 0 or tonumber(minuty) == nil then
		minuty = 5
	end
	-- <@&639605530779713547> <@&719204491349590097>
	PerformHttpRequest('https://discordproxy.neonrp.solutions/api/webhooks/954095708221362217/uVdTlo6mxZJYTNkYGoqXUtKEAHvj7XhBcZsX6fya7kWw7qPY1gAwh5q_X2Qv3GQJUcuU', function(err, text, headers) end, 'POST', json.encode({username = "ExileRP", content = "Zaćmienie odbędzie się za **" .. minuty .. " minut.**"}), { ['Content-Type'] = 'application/json' })
	TriggerEvent('exile_queue:isRestarting', true)
	
	while minuty > 0 do
		if isCanceled == true then
			return
		else
			TriggerClientEvent('flux_restart', -1, minuty)
			Citizen.Wait(60000)
			minuty = minuty - 1
		end
	end
	
	if isCanceled == false then
		local xPlayers = ESX.GetExtendedPlayers()
		for _, xPlayer in ipairs(xPlayers) do     
			if xPlayer then
				xPlayer.kick('Zaćmienie! Prosimy czekać na pociąg powrotny!')
			end
		end
		
		TriggerEvent('es_extended:DoUpdateItems')
	
		Citizen.Wait(10000)
		os.execute(GIGANIGA)
	end
end

RegisterCommand('zacmienienow', function(source, args, rawcommand)
	local xPlayers = ESX.GetExtendedPlayers()
	for _, xPlayer in ipairs(xPlayers) do     
		if xPlayer then
			xPlayer.kick('Zaćmienie! Prosimy czekać na pociąg powrotny!')
		end
	end
	
	TriggerEvent('es_extended:DoUpdateItems')
	
	Citizen.Wait(10000)
	os.execute(GIGANIGA)
end, true)

RegisterCommand('zacmienie', function(source, args, rawcommand)
	flux_reboot(tonumber(args[1]))
end, true)

RegisterCommand('zacmienieoff', function(source, args, rawcommand)
	isCanceled = true
	TriggerEvent('exile_queue:isRestarting', false)
	PerformHttpRequest('https://discordproxy.neonrp.solutions/api/webhooks/954095708221362217/uVdTlo6mxZJYTNkYGoqXUtKEAHvj7XhBcZsX6fya7kWw7qPY1gAwh5q_X2Qv3GQJUcuU', function(err, text, headers) end, 'POST', json.encode({username = "ExileRP", content = "Zaćmienie zostało **anulowane**."}), { ['Content-Type'] = 'application/json' })
	TriggerClientEvent('flux_stopRestart', -1)
	return
end, true)