ESX 						   = nil
local PlayersHarvesting		   = {}
local TimeToFarm = 5000
local TimeToProcess = 20000

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

local function ClearTransfer(source)
	if PlayersHarvesting[source] then
		ESX.ClearTimeout(PlayersHarvesting[source])
		PlayersHarvesting[source] = nil
	end
end

local function Harvest(source, name)	
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer ~= nil then			
		PlayersHarvesting[source] = ESX.SetTimeout(TimeToFarm, function()
			local item = xPlayer.getInventoryItem(name)
			if item ~= nil then
				if item.limit ~= -1 and item.count >= item.limit then
					TriggerClientEvent('esx:showNotification', source, 'Nie możesz już zbierać, Twój ekwipunek jest ~r~pełen~s~')
					
					ClearTransfer(source)
				else
					PlayersHarvesting[source] = nil
					
					xPlayer.addInventoryItem(name, 1)
					exports['exile_logs']:SendLog(source, "Zbieranie: " .. name .. " x1", 'drugs', '3066993')
					Harvest(source, name)
				end	
			else
				ClearTransfer(source)
			end			
		end)
	else
		ClearTransfer(source)
	end
end

RegisterServerEvent('esx_drugs:stopDrugs')
AddEventHandler('esx_drugs:stopDrugs', function()
	local _source = source
	ClearTransfer(_source)
end)

RegisterServerEvent(GetCurrentResourceName() .. ':pickup')
AddEventHandler(GetCurrentResourceName() .. ':pickup', function(name)
	local _source = source
	
	if PlayersHarvesting[_source] == nil then 
		TriggerClientEvent('esx:showNotification', _source, '~y~Zbieranie w trakcie~s~...')
		Harvest(_source, name)
	end
end)

local function Transform(source, name, name2)	
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer ~= nil then		
		PlayersHarvesting[source] = ESX.SetTimeout(TimeToProcess, function()
			local pooch = xPlayer.getInventoryItem(name2..'_pooch')
			local itemQuantity = xPlayer.getInventoryItem(name).count
			local poochQuantity = xPlayer.getInventoryItem(name2..'_pooch').count
			
			if pooch ~= nil and itemQuantity ~= nil and poochQuantity ~= nil then
				if pooch.limit ~= -1 and poochQuantity >= pooch.limit then
					TriggerClientEvent('esx:showNotification', source, '~r~Masz zbyt wiele woreczków!')
					
					ClearTransfer(source)
				elseif itemQuantity < 5 then
					TriggerClientEvent('esx:showNotification', source, 'Nie masz wystarczająco narkotyku, aby go ~r~przetworzyć~s~')
					
					ClearTransfer(source)
				else
					xPlayer.removeInventoryItem(name, 5)
					xPlayer.addInventoryItem(name2 .. '_pooch', 1)
					exports['exile_logs']:SendLog(source, "Przetwarzanie: " .. name2 .. "_pooch x1", 'drugs', '3447003')
					
					PlayersHarvesting[source] = nil
					Transform(source, name, name2)
				end	
			else
				ClearTransfer(source)
			end
		end)
	else
		ClearTransfer(source)
	end
end

RegisterServerEvent(GetCurrentResourceName() .. ':transform')
AddEventHandler(GetCurrentResourceName() .. ':transform', function(name, name2)
	local _source = source
	
	if PlayersHarvesting[_source] == nil then 
		TriggerClientEvent('esx:showNotification', _source, '~y~Przetwarzanie w trakcie~s~...')
		Transform(_source, name, name2)
	end
end)

local AuthorizedClients = {}


local Zones = {	
	MethField          = {
        x = -440.82, y = 6340.9, z = 12.72-0.95,           
        name = "Pole metamfetaminy",
        db_item = 'meth',            
        sprite = 499,    
        color = 26
    },
	MethProcessing 	= {
		x = 351.7612, y = 3566.8086, z = 21.8344,			
		name = "Przetwarzanie metamfetaminy",	 
		required = 'meth', 
		db_item = 'meth_pooch', 
		sprite = 499,	
		color = 26
	},
	WeedField 		= {
		x = 2186.5, y = 5561.5, z = 53.62-0.95, 	
		name = "Pole marihuany",      
		db_item = 'weed', 		
		sprite = 496,	
		color = 52
	},
	WeedProcessing 	= {
		x =  -1155.4248,	y = -2033.3641,	z = 12.2105, 		
		name = "Przetwarzanie marihuany",  
		required = 'weed', 
		db_item = 'weed_pooch'
	},

	CokeField 		= {x = 3312.8955, y = 5176.0156, z = 18.6646, 		name = "Pole kokainy",	 db_item = 'coke',				sprite = 501,	color = 40},  
	CokeProcessing 	= {x = 1108.93, y = -2007.43, z = 31.0,  		name = "Przetwarzanie kokainy",	 required = 'coke', db_item = 'coke_pooch',		sprite = 478,	color = 40},

	CokePericoField 		= {x = 999, y = 999, z = -999, 		name = "Pole kokainy Perico",	 db_item = 'cokeperico',				sprite = 501,	color = 40}, 
	CokePericoProcessing 	= {x = 999, y = 999, z = -999, 		name = "Przetwarzanie kokainy Perico",	required = 'cokeperico', db_item = 'cokeperico_pooch',		sprite = 478,	color = 40},	
	
	OpiumField      	= {x = 1011.2738, y = -3199.0823, z = -39.9431,		name = "Pole opium",	db_item = 'opium',				sprite = 501,	color = 26},
	OpiumProcessing 	= {x = 1160.7366, y = -3191.6396, z = -39.9579,		name = "Przetwarzanie opium",	required = 'opium', db_item = 'opium_pooch',		sprite = 501,	color = 26},

	OgHazeProcessing 	= {x = -628.4888, y = -1720.983, z = 23.1607,		name = "Przetwarzanie marihuany na OG Haze",	required = 'weed', db_item = 'oghaze_pooch',		sprite = 501,	color = 26},

	ExctasyField      	= {x = 1100.9709, y = -3100.1357, z = -39.95,			name = "Pole ekstazy",		db_item = 'mdp2p',			sprite = 501,	color = 26},
	ExctasyProcessing 	= {x = 1101.2207, y = -3195.9104, z = -39.9434,		name = "Przetwarzanie ekstazy",	required = 'mdp2p', db_item = 'exctasy_pooch',		sprite = 501,	color = 26},

	MilkjuiceField      	= {x = 2368.3408, y = 3056.6101, z = 1047.3546,			name = "Pole soku mlecznego",		db_item = 'milkjuice',			sprite = 501,	color = 26},
	-- podaje kordy do zbiórki jak ustawisz opisalem ci all na managment ~krzychu    2219.2375  5577.082 52.8908
}

RegisterServerEvent('exile_drugs:getInventory')
AddEventHandler('exile_drugs:getInventory', function(currentZone)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local count = 0
	local itemName = nil
	for i, data in pairs(Zones) do
		if i == currentZone then
			if string.find(currentZone, "Processing") then
				count = xPlayer.getInventoryItem(data.db_item).count
				itemName = data.db_item
				itemRequired = xPlayer.getInventoryItem(data.required).count
			else
				count = xPlayer.getInventoryItem(data.db_item).count
				itemName = data.db_item
			end
			break
		end
	end
	TriggerClientEvent('exile_drugs:returnInventory', _source, count, itemName, itemRequired, xPlayer.job.name, currentZone)
end)

RegisterServerEvent('drugs:registerClient')
AddEventHandler('drugs:registerClient', function(_eventName)
	local _source = source
	local _sourceName = GetPlayerName(_source)
	local _sourceIdentifier = GetPlayerIdentifier(_source, 0)

	if _sourceIdentifier ~= nil then
		if (AuthorizedClients[_sourceIdentifier:lower()] == nil) then
			AuthorizedClients[_sourceIdentifier:lower()] = _eventName
			TriggerClientEvent(AuthorizedClients[_sourceIdentifier:lower()], _source, Zones)
		end
	end
end)

AddEventHandler('playerDropped', function(reason)
	local _source = source
	local _sourceName = GetPlayerName(_source)
	local _sourceIdentifier = GetPlayerIdentifier(_source, 0)

	if (AuthorizedClients[_sourceIdentifier:lower()] ~= nil) then
		AuthorizedClients[_sourceIdentifier:lower()] = nil
	end
end)