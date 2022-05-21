ESX = nil

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)


RegisterServerEvent('exile:setJob')
AddEventHandler('exile:setJob', function(job, status)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local grade = xPlayer.getJob().grade
	local praca = xPlayer.getJob().name
	if praca == job or praca == "off"..job then
		if status == true then
			xPlayer.setJob(job, grade)
			exports['exile_logs']:SendLog(source, "Gracz: " ..xPlayer.name.. " wszedł na służbę\n Praca: " ..praca, 'duty', '5793266')
		elseif status == false then
			xPlayer.setJob('off' .. job, grade)
			exports['exile_logs']:SendLog(source, "Gracz: " ..xPlayer.name.. " zszedł ze służby\n Praca: " ..praca, 'duty', '5793266')
		end
	else
		TriggerEvent("csskrouble:banPlr", "nigger", source,  "Tried to change job (exile_duty)")
	end		
end)

AddEventHandler("playerDropped", function(reason)
	local license = string.sub(GetPlayerIdentifiers(source)[2], 9)
	Wait(5000)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	local allowedjob = {
		['police'] = true,
		['ambulance'] = true,
		['mechanik'] = true,
		['fire'] = true,
		['doj'] = true,
		['k9'] = true,
	}
	
	if xPlayer ~= nil then
		if allowedjob[xPlayer.job.name] then
			MySQL.Async.execute('UPDATE users SET job = @job WHERE identifier = @identifier', {
				['@job'] = 'off'..xPlayer.job.name,
				['@identifier'] = xPlayer.identifier
			})			
		end
	end
end)