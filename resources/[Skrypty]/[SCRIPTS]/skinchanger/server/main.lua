ESX = nil
TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

local cached = {}

ESX.RegisterServerCallback('skinchanger:getSkin', function(source, cb, sid)
	local xPlayer = nil
	
	if sid then
		if cached[sid] then
			cb(cached[sid])
		else
			local xPlayer = ESX.GetPlayerFromId(sid)
			MySQL.Async.fetchAll('SELECT skin FROM users WHERE identifier = @identifier', {
				['@identifier'] = xPlayer.identifier
			}, function(users)
				local user, skin = users[1]
				
				if user ~= nil then
					if user.skin then
						skin = json.decode(user.skin)
					end
					
					cb(skin)
				end
			end)	
		end
	else
		local xPlayer = ESX.GetPlayerFromId(source)
		
		MySQL.Async.fetchAll('SELECT skin FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(users)
			local user, skin = users[1]
			
			if user ~= nil then
				if user.skin then
					skin = json.decode(user.skin)
				end
				
				cb(skin)
			end
		end)	
	end
end)

RegisterServerEvent('skinchanger:modelComplete')
AddEventHandler('skinchanger:modelComplete', function(Character)
	local _source = source
	if not cached[_source] then
		cached[_source] = Character
	else
		cached[_source] = Character
	end
end)

AddEventHandler('playerDropped', function()
	local _source = source
	
	if cached[_source] then
		cached[_source] = nil
	end
end)

ESX.RegisterServerCallback('skinchanger:skinCache', function(source, cb, target)    
    if cached[target] then
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent('ReturnSkin')
AddEventHandler('ReturnSkin', function(target, cb)
    local xPlayer = ESX.GetPlayerFromId(target)
    if cached[target] then
        cb(cached[target])
    else
        MySQL.Async.fetchAll('SELECT skin FROM users WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        }, function(users)
            local user, skin = users[1]
            
            if user ~= nil then
                if user.skin then
                    skin = json.decode(user.skin)
                end
                
                cb(skin)
            end
        end)
    end
end)