ESX				= nil
local DoorInfo	= {}

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_doorlock:updateState')
AddEventHandler('esx_doorlock:updateState', function(doorID, state)
	local xPlayer = ESX.GetPlayerFromId(source)

	if type(doorID) ~= 'number' then
		return
	end

	DoorInfo[doorID] = {}

	DoorInfo[doorID].state = state
	DoorInfo[doorID].doorID = doorID

	TriggerClientEvent('esx_doorlock:setState', -1, doorID, state)
end)

ESX.RegisterServerCallback('esx_doorlock:getDoorList', function(source, cb)
	cb(Config.DoorList)
end)

ESX.RegisterServerCallback('esx_doorlock:getDoorInfo', function(source, cb)
	cb(DoorInfo, #DoorInfo)
end)

MySQL.ready(function()	
	MySQL.Async.fetchAll('SELECT name, doors FROM properties', {}, function(properties)
		if properties[1] ~= nil then
			for j=1, #properties, 1 do
				if properties[j].doors ~= nil then
					local _doors = json.decode(properties[j].doors)
					if _doors ~= nil then
						for k=1, #_doors, 1 do
							local tempTable = {authorizedJobs = {properties[j].name}, objModel = _doors[k].model, objCoords = {x = _doors[k].x, y = _doors[k].y, z = _doors[k].z}, textCoords = {x = _doors[k].x, y = _doors[k].y, z = _doors[k].z}, locked = true, distance = 2.4}
							table.insert(Config.DoorList, tempTable)
							table.insert(DoorInfo, {state = true, doorID = tonumber(#Config.DoorList + 1)})									
						end
					end
				end	
			end
		end
		
		TriggerClientEvent('esx_doorlock:updateUserDoors', -1, Config.DoorList)
	end)
end)