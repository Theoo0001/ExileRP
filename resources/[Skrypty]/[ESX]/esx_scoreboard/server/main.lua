ESX = nil
local connectedPlayers = {}
local Counter = {	
	['ambulance'] = 0,
	['taxi'] = 0,
	['mechanik2'] = 0,
	['mechanik3'] = 0,
	['mechanik4'] = 0,
	['police'] = 0,
	['doj'] = 0,
	['cardealer'] = 0,
	['players'] = 0,

	['maxPlayers'] = GetConvarInt('sv_maxclients', 150)
}

RegisterCommand('stats-scoreboard', function(source, args, raw)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	if xPlayer.group == 'best' then
		for k,v in pairs(Counter) do
			print(k, v)
		end
	end
end)

function MisiaczekPlayers()
	return connectedPlayers
end

function CounterPlayers(what)
	return Counter[what]
end

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_scoreboard:getConnectedCops', function(source, cb)
	cb(Counter)
end)

ESX.RegisterServerCallback('esx_scoreboard:getConnectedPlayers', function(source, cb)
	cb(connectedPlayers)
end)

AddEventHandler('esx:setJob', function(playerId, job, lastJob)
	connectedPlayers[playerId].job = job.name
	
	if Counter[job.name] then
		Counter[job.name] = Counter[job.name] + 1
	end

	if Counter[lastJob.name] then
		Counter[lastJob.name] = Counter[lastJob.name] - 1
	end
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	if not connectedPlayers[playerId] then
		AddPlayerToScoreboard(xPlayer)
	else
		if connectedPlayers[playerId] then
			if Counter[connectedPlayers[playerId].job] then
				Counter[connectedPlayers[playerId].job] = Counter[connectedPlayers[playerId].job] - 1
			end
			
			connectedPlayers[playerId].job = xPlayer.job.name
			
			if Counter[xPlayer.job.name] then
				Counter[xPlayer.job.name] = Counter[xPlayer.job.name] + 1
			end			
		end	
	end
	
	Counter['players'] = GetNumPlayerIndices()
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		CreateThread(function()
			local players = ESX.GetExtendedPlayers()
			
			for _, xPlayer in ipairs(players) do
				AddPlayerToScoreboard(xPlayer)
			end	
			
			Citizen.Wait(10000)
			Counter['players'] = GetNumPlayerIndices()
			Counter['maxPlayers'] = GetConvarInt('sv_maxclients', 150)
		end)
	end
end)


AddEventHandler('playerDropped', function()		
	if connectedPlayers[source] then
		if Counter[connectedPlayers[source].job] then
			Counter[connectedPlayers[source].job] = Counter[connectedPlayers[source].job] - 1
		end
		
		connectedPlayers[source] = nil
	end
	
	Counter['players'] = GetNumPlayerIndices()
end)


function AddPlayerToScoreboard(xPlayer, update)
	local playerId = xPlayer.source

	connectedPlayers[playerId] = {}
	connectedPlayers[playerId].id = playerId
	connectedPlayers[playerId].identifier = xPlayer.identifier
	connectedPlayers[playerId].name = xPlayer.getName()
	connectedPlayers[playerId].job = xPlayer.job.name
	connectedPlayers[playerId].hiddenjob = xPlayer.hiddenjob.name
	connectedPlayers[playerId].group = xPlayer.group
	
	if Counter[xPlayer.job.name] ~= nil then
		Counter[xPlayer.job.name] = Counter[xPlayer.job.name] + 1
	end
end

RegisterServerEvent('esx_scoreboard:players')
AddEventHandler('esx_scoreboard:players', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local groups = {
		['trialsupport'] = true,
		['support'] = true,
		['mod'] = true,
		['admin'] = true,
		['superadmin'] = true,
		['best'] = true
	}
	
	if xPlayer then
		TriggerClientEvent('esx_scoreboard:players', _source, Counter, groups[xPlayer.group])
	end
end)

RegisterServerEvent('esx_scoreboard:Show')
AddEventHandler('esx_scoreboard:Show', function(text)
	local _source = source
	TriggerClientEvent("sendProximityMessageZ", -1, _source, _source, text)
end)