ESX = nil
TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) 
    ESX = obj 
end)

local Config = {
	['police'] = {
		label = 'SASP',
		color = 3,
	},
	
	['ambulance'] = {
		label = 'SAMS',
		color = 1
	},
	
	['mechanik'] = {
		label = 'LST',
		color = 58
	},

	['k9'] = {
		label = 'K9',
		color = 35
	},

	['mechanik2'] = {
		label = 'MG',
		color = 58
	},
	
	['opaska'] = {
		label = 'OPASKA',
		color = 55
	}
}

local blips = {}

--utils check

local opaskaArr = {}

function checkOpaska(id)
	local opaska = false
	for i,v in ipairs(opaskaArr) do
		if v == id then
			opaska = true
			break
		end
	end	
	return opaska	
end	

function removeOpaska(id)
	for i,v in ipairs(opaskaArr) do
		if v == id then
			table.remove(opaskaArr, i)
			break
		end
	end	
end	

AddEventHandler('esx:playerLoaded',function(playerId, xPlayer)
	if xPlayer ~= nil then
		if xPlayer.getInventoryItem('opaska').count >= 1 then
			if not blips[playerId] then
				local data = Config['opaska']
				
				if data then
					blips[playerId] = {
						text = '['..data.label..'] '..xPlayer.character.firstname..' '..xPlayer.character.lastname,
						badge = 0,
						color = data.color,
						coords =  GetEntityCoords(playerPed),
						heading = GetEntityHeading(playerPed),
						opaska = true
					}	
				end	
			end
		end
	end	
end)

RegisterNetEvent("csskrouble:walkieTalkie")
AddEventHandler("csskrouble:walkieTalkie", function(talking) 
	local src = source
	TriggerClientEvent("csskrouble:setRadioIndicator", -1, src, talking)
end)

AddEventHandler('esx:setJob', function(playerId, job, lastJob)
	local xPlayer = ESX.GetPlayerFromId(playerId) 
	
	if xPlayer ~= nil then			
		if Config[job.name] and not Config[lastJob.name] then
			local item = xPlayer.getInventoryItem('gps')
			
			if item and item.count >= 1 then
				if not blips[playerId] then				
					if xPlayer ~= nil then
						local data = Config[job.name]
						if data then
							local playerPed = GetPlayerPed(playerId)					
							local badge = json.decode(xPlayer.character.job_id)
							
							if not badge.id then
								badge.id = 0
							end

							local unit
							local grade
							local colorek = 0
							if xPlayer.hiddenjob.name == 'sheriff' then
								unit = 'SASD'
								grade = xPlayer.hiddenjob.grade_label
								colorek = 31
							else
								unit = data.label
								grade = xPlayer.job.grade_label
								colorek = data.color
							end

							blips[playerId] = {
								text = '['..unit..'] ['..badge.id..'] '..xPlayer.character.firstname..' '..xPlayer.character.lastname..' - '..grade,
								badge = badge.id,
								color = colorek,
								coords =  GetEntityCoords(playerPed),
								heading = GetEntityHeading(playerPed),
								opaska = false
							}
						end
					end
				end	
			end
		elseif not Config[job.name] and Config[lastJob.name] then
			local item = xPlayer.getInventoryItem('gps')
			
			if item.name == 'gps' then
				if blips[playerId] then
					blips[playerId] = nil
					
					TriggerClientEvent('exile_gps:cleanup', playerId)	

					for k,v in pairs(blips) do
						TriggerClientEvent('exile_gps:removeGPSForID', k, playerId)
					end				
				end	
			end	
		elseif Config[job.name] and Config[lastJob.name] then
			local item = xPlayer.getInventoryItem('gps')
			
			if item and item.count >= 1 then				
				if not blips[playerId] then		
					if xPlayer ~= nil then
						local data = Config[job.name]
						if data then
							local playerPed = GetPlayerPed(playerId)					
							local badge = json.decode(xPlayer.character.job_id)
							
							if not badge.id then
								badge.id = 0
							end

							local unit
							local grade
							local colorek = 0
							if xPlayer.hiddenjob.name == 'sheriff' then
								unit = 'SASD'
								grade = xPlayer.hiddenjob.grade_label
								colorek = 31
							else
								unit = data.label
								grade = xPlayer.job.grade_label
								colorek = data.color
							end
							
							blips[playerId] = {
								text = '['..unit..'] ['..badge.id..'] '..xPlayer.character.firstname..' '..xPlayer.character.lastname..' - '..grade,
								badge = badge.id,
								color = colorek,
								coords =  GetEntityCoords(playerPed),
								heading = GetEntityHeading(playerPed),
								opaska = false
							}
						end
					end
				end	
			end	
		end
	end
end)

ESX.RegisterUsableItem('opaska', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local check = checkOpaska(xPlayer.source)
	if check then 
		TriggerClientEvent('esx:showNotification', _source, '~r~Nie możesz sobie zdjąć opaski!')
	else
		table.insert(opaskaArr, xPlayer.source)
		TriggerClientEvent('esx:showNotification', _source, '~y~Założyłeś sobie opaskę')
		local playerPed = GetPlayerPed(_source)					
	
		local data = Config["opaska"]
		blips[xPlayer.source] = {
			text = '[OPASKA] '..xPlayer.character.firstname..' '..xPlayer.character.lastname,
			badge = 0,
			color = data.color,
			coords =  GetEntityCoords(playerPed),
			heading = GetEntityHeading(playerPed),
			opaska = true
		}
	end	
end)


AddEventHandler('esx:onAddInventoryItem', function(playerId, item, count)
	if item == 'gps' and count >= 1 then
		if not blips[playerId] then
			local xPlayer = ESX.GetPlayerFromId(playerId)
			
			if xPlayer ~= nil then
				local data = Config[xPlayer.job.name]
				if data then
					local playerPed = GetPlayerPed(playerId)					
					local badge = json.decode(xPlayer.character.job_id)
					
					if not badge.id then
						badge.id = 0
					end

					local unit
					local grade
					local colorek = 0
					if xPlayer.hiddenjob.name == 'sheriff' then
						unit = 'SASD'
						grade = xPlayer.hiddenjob.grade_label
						colorek = 31
					else
						unit = data.label
						grade = xPlayer.job.grade_label
						colorek = data.color
					end
					
					blips[playerId] = {
						text = '['..unit..'] ['..badge.id..'] '..xPlayer.character.firstname..' '..xPlayer.character.lastname..' - '..grade,
						badge = badge.id,
						color = colorek,
						coords =  GetEntityCoords(playerPed),
						heading = GetEntityHeading(playerPed),
						opaska = false
					}
				end
			end
		end
	end
end)

AddEventHandler('esx:onRemoveInventoryItem', function(playerId, item, count)
	if item == 'gps' and count <= 0 then
		if blips[playerId] then
			blips[playerId] = nil
			
			TriggerClientEvent('exile_gps:cleanup', playerId)	

			for k,v in pairs(blips) do
				TriggerClientEvent('exile_gps:removeGPSForID', k, playerId)
			end				
		end	
	end
	if item == "opaska" then
		if blips[playerId] then
			removeOpaska(playerId)
			if blips[playerId].opaska then
				local xPlayer = ESX.GetPlayerFromId(playerId)
				local playerPed = GetPlayerPed(playerId)
				blips[playerId] = nil
				TriggerClientEvent('exile_gps:cleanup', playerId)	

				for k,v in pairs(blips) do
					if string.find(v.text, "[SASP]") then
						TriggerClientEvent('esx:showNotification', k, '~c~'..xPlayer.character.firstname.." "..xPlayer.character.lastname.." ~r~zdjął sobię opaske!")
						TriggerClientEvent('exile_gps:tempBlip', k, xPlayer.source, {
							color=55,
							text="[OPASKA - Ostatnia lokalizacja] "..xPlayer.character.firstname.." "..xPlayer.character.lastname,
							coords=GetEntityCoords(playerPed),
							heading=GetEntityHeading(playerPed),
							badge=0
						})
					end	
					TriggerClientEvent('exile_gps:removeGPSForID', k, playerId)
				end	
			end	
		end	
	end	
end)

AddEventHandler('playerDropped', function(reason)
    local playerId = source

    if blips[playerId] then
        blips[playerId] = nil

        for k,v in pairs(blips) do
            TriggerClientEvent('exile_gps:removeGPSForID', k, playerId)
        end
    end
end)

--utils end check

ESX.RegisterServerCallback('exile_gps:checkHasGPS', function(source, cb, playerId)
	if playerId ~= nil then
		local xPlayer = ESX.GetPlayerFromId(playerId)
		local data = {
			playerId = playerId,
			has = checkOpaska(playerId),
			firstname = xPlayer.character.firstname,
			lastname = xPlayer.character.lastname
		}

		cb(data)
	end
end)

RegisterServerEvent('exile_gps:opaska')
AddEventHandler('exile_gps:opaska', function(state, data)
	local xPlayer = ESX.GetPlayerFromId(source)
	if state then
		if not blips[data.playerId] then
			local data = Config['opaska']
			if data then
				blips[data.playerId] = {
					text = '['..data.label..'] '..xPlayer.character.firstname..' '..xPlayer.character.lastname,
					badge = 0,
					color = data.color,
					coords =  GetEntityCoords(playerPed),
					heading = GetEntityHeading(playerPed),
					opaska = true
				}	
			end			
		end
	else
		if blips[data.playerId] then
			for k,v in pairs(blips) do
				TriggerClientEvent('exile_gps:removeGPSForID', k, data.playerId)
			end							
		end
	end
end)

CreateThread(function()
    while true do
      	for playerId, data in pairs(blips) do
			local playerPed = GetPlayerPed(playerId)
			if playerPed then
				data.coords = GetEntityCoords(playerPed)
				data.heading = GetEntityHeading(playerPed)
			end
      	end

			for playerId, data in pairs(blips) do
				if not checkOpaska(playerId) then
					TriggerClientEvent('exile_gps:updateBlip', playerId, blips)
				end
			end
		
      Citizen.Wait(1000)
    end
end)