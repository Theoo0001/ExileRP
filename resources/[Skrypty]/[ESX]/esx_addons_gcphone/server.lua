
ESX                = nil
local PhoneNumbers = {
	['police'] = {
		type = 'police',
		sources = {},
		alerts = {}
	},
	['ambulance'] = {
		type = 'ambulance',
		sources = {},
		alerts = {}
	},
	
	['sheriff'] = {
		type = 'sheriff',
		sources = {},
		alerts = {}
	},

	['mechanik2'] = {
		type = 'mechanik2',
		sources = {},
		alerts = {}
	},
	
	['cardealer'] = {
		type = 'cardealer',
		sources = {},
		alerts = {}
	},
	
	['realestateagent'] = {
		type = 'realestateagent',
		sources = {},
		alerts = {}
	},
	
	['taxi'] = {
		type = 'taxi',
		sources = {},
		alerts = {}
	},
	
	['fire'] = {
		type = 'fire',
		sources = {},
		alerts = {}
	},
	
	['weazel'] = {
		type = 'weazel',
		sources = {},
		alerts = {}
	},
	
	['doj'] = {
		type = 'doj',
		sources = {},
		alerts = {}
	},
}

local alertsCount = 0

local actAlert = {
	number = nil,
	message = '',
	coords = nil
}

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj)
  ESX = obj
end)

function notifyAlertSMS(number, alert, listSrc)
	if PhoneNumbers[number] ~= nil then
		for k, _ in pairs(listSrc) do
			getPhoneNumber(tonumber(k), function (n)
				if n ~= nil then
					if alert.numero ~= nil then
						local text = '#' .. alert.numero  .. ': ' .. alert.message
						if alert.coords ~= nil then
							text = text .. '\nGPS: ' .. alert.coords.x .. ', ' .. alert.coords.y
						end
						
						TriggerEvent('gcPhone:_internalAddMessagexdxdtesttesttest', 'Centrala', n, text, 0, function (smsMess)
							TriggerClientEvent("gcPhone:receiveMessage", tonumber(k), smsMess)
						end)
					end
				end
			end)
		end
	end
end

AddEventHandler('esx:setJob', function(source, job, lastJob)
	if PhoneNumbers[lastJob.name] ~= nil then
		TriggerEvent('esx_addons_gcphone:removeSource', lastJob.name, source)
	end

	if PhoneNumbers[job.name] ~= nil then
		TriggerEvent('esx_addons_gcphone:addSource', job.name, source)
	end
end)

AddEventHandler('esx_addons_gcphone:addSource', function(number, source)
	PhoneNumbers[number].sources[tostring(source)] = true
end)

AddEventHandler('esx_addons_gcphone:removeSource', function(number, source)
	PhoneNumbers[number].sources[tostring(source)] = nil
end)

local numbers = {
	['police'] = true,
	['ambulance'] = true,
	['sheriff'] = true,
	['mechanik2'] = true,
	['cardealer'] = true,
	['realestateagent'] = true,
	['taxi'] = true,
	['fire'] = true,
	['weazel'] = true,
	['doj'] = true,
}

RegisterServerEvent('esx_addons_gcphone:startCall')
AddEventHandler('esx_addons_gcphone:startCall', function (number, message, coords)
	local source = source
	local _source = source
	if PhoneNumbers[number] ~= nil then
		getPhoneNumber(source, function (phone) 
			notifyAlertSMS(number, {
				message = message,
				coords = coords,
				numero = phone,
		}, PhoneNumbers[number].sources)
		end)
	end
	
	if numbers[number] then
		actAlert = {
			number = number,
			message = message,
			coords = coords,
			oneAccept = false,
		}
	
		alertsCount = alertsCount + 1

		local GetPlayers = exports['esx_scoreboard']:MisiaczekPlayers()
		for k,v in pairs(GetPlayers) do
			if v.job == number then
				TriggerClientEvent('genesis-alert:sendAlert', v.id, actAlert, _source)
			end
		end			
	end
end)


AddEventHandler('esx:playerLoaded', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

    if PhoneNumbers[xPlayer.job.name] ~= nil then
		TriggerEvent('esx_addons_gcphone:addSource', xPlayer.job.name, source)
    end
end)


AddEventHandler('esx:playerDropped', function(source)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if PhoneNumbers[xPlayer.job.name] ~= nil then
		TriggerEvent('esx_addons_gcphone:removeSource', xPlayer.job.name, source)
	end
end)


function getPhoneNumber (source, callback) 
	local xPlayer = ESX.GetPlayerFromId(source)	
	if xPlayer ~= nil then
		callback(xPlayer.character.phone_number)
	else
		callback(nil)
		return
	end
end

RegisterServerEvent("csskrouble:przyjetoWezwanie", function(id) 
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer ~= nil then
		local name = xPlayer.character.firstname..' '..xPlayer.character.lastname
		
		TriggerClientEvent("csskrouble:notifAccepted", id, name .. " przyjął twoje wezwanie")
		
	end
end)

RegisterServerEvent('esx_addons_gcphone:acceptedAlert')
AddEventHandler('esx_addons_gcphone:acceptedAlert', function(job)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer ~= nil then
		local name = xPlayer.character.firstname..' '..xPlayer.character.lastname
		
		local GetPlayers = exports['esx_scoreboard']:MisiaczekPlayers()
		for k,v in pairs(GetPlayers) do
			if v.job == job then
				TriggerClientEvent('esx_addons_gcphone:acceptClient', v.id, name)
			end
		end
		
	end
end)

RegisterServerEvent('esx_phone:send')
AddEventHandler('esx_phone:send', function(number, message, _, coords)
  local source = source
  if PhoneNumbers[number] ~= nil then
    getPhoneNumber(source, function (phone) 
      notifyAlertSMS(number, {
        message = message,
        coords = coords,
        numero = phone,
      }, PhoneNumbers[number].sources)
    end)
  end
end)