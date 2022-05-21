ESX = nil
TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

ESX['RegisterServerCallback']('loffe_animations:get_favorites', function(source, cb)
    local xPlayer = ESX['GetPlayerFromId'](source)

    MySQL['Async']['fetchScalar']("SELECT animacje FROM users WHERE identifier=@identifier", {['@identifier'] = xPlayer['identifier']}, function(result)
        if not result then
            MySQL['Async']['execute']([[
                UPDATE `users` SET animacje=@animacje WHERE identifier=@identifier
            ]], {
                ['@animacje'] = '{}',
                ['@identifier'] = xPlayer['identifier'],
            })
            cb('{}')
        else
            cb(result or '{}')
        end
    end)
end)

RegisterServerEvent('loffe_animations:update_favorites')
AddEventHandler('loffe_animations:update_favorites', function(animacje)
    local xPlayer = ESX['GetPlayerFromId'](source)

    MySQL['Async']['execute']([[
        UPDATE `users` SET animacje=@animacje WHERE identifier=@identifier
    ]], {
        ['@animacje'] = animacje,
        ['@identifier'] = xPlayer['identifier'],
    })

    if Config['pNotify'] then
        pNotify(xPlayer['source'], Strings['Updated_Favorites'], 'success', 3500)
    else
        TriggerClientEvent('esx:showNotification', xPlayer['source'], Strings['Updated_Favorites'])
    end
end)

RegisterServerEvent('loffe_animations:syncAccepted')
AddEventHandler('loffe_animations:syncAccepted', function(requester, id)
    local accepted = source
    
    TriggerClientEvent('loffe_animations:playSynced', accepted, requester, id, 'Accepter')
    TriggerClientEvent('loffe_animations:playSynced', requester, accepted, id, 'Requester')
end)

RegisterServerEvent('loffe_animations:requestSynced')
AddEventHandler('loffe_animations:requestSynced', function(target, id)
    local requester = source
    local xPlayer = ESX['GetPlayerFromId'](requester)
    
    MySQL['Async']['fetchScalar']("SELECT firstname FROM users WHERE identifier=@identifier", {['@identifier'] = xPlayer['identifier']}, function(firstname)
        TriggerClientEvent('loffe_animations:syncRequest', target, requester, id, firstname)
    end)
end)

RegisterServerEvent('route68_animacje:OdpalAnimacje4')
AddEventHandler('route68_animacje:OdpalAnimacje4', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)
	
	xTarget.showNotification('~y~Naciśnij ~b~[Y] ~y~aby zostać noszonym przez ~b~['..xPlayer.source..']')
	xPlayer.showNotification('~b~Oczekiwanie na akceptację przez obywatela ~y~['..xTarget.source..']')
	TriggerClientEvent('route68_animacje:przytulSynchroC2', xTarget.source, xPlayer.source)
end)

RegisterServerEvent('cmg2_animations:stop')
AddEventHandler('cmg2_animations:stop', function(target)
	local xTarget = ESX.GetPlayerFromId(target)
	if xTarget ~= nil then
		TriggerClientEvent('cmg2_animations:cl_stop', xTarget.source)
	end
end)

RegisterServerEvent('cmg2_animations:sync')
AddEventHandler('cmg2_animations:sync', function(target, animationLib,animationLib2, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget)
	TriggerClientEvent('cmg2_animations:syncTarget', targetSrc, source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget)
	TriggerClientEvent('cmg2_animations:syncMe', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
end)

RegisterServerEvent('route68_animacje:OdpalAnimacje5')
AddEventHandler('route68_animacje:OdpalAnimacje5', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)

	TriggerClientEvent('cmg2_animations:startMenu2', xTarget.source)
end)