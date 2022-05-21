ESX = nil

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_skin:save')
AddEventHandler('esx_skin:save', function(skin)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE users SET `skin` = @skin WHERE identifier = @identifier',
	{
		['@skin']       = json.encode(skin),
		['@identifier'] = xPlayer.identifier
	})
end)

RegisterServerEvent('esx_skin:responseSaveSkin')
AddEventHandler('esx_skin:responseSaveSkin', function(skin)

	TriggerEvent('es:getPlayerFromId', source, function(user)
		TriggerEvent('es:canGroupTarget', user.getGroup(), "admin", function(available)
			if available then
				local file = io.open('resources/[esx]/esx_skin/skins.txt', "a")

				file:write(json.encode(skin) .. "\n\n")
				file:flush()
				file:close()
			end
		end)
	end)

end)

ESX.RegisterServerCallback('esx_skin:getPlayerSkin', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT skin FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(users)
		local user = users[1]
		local skin = nil

		local jobSkin = {
			skin_male   = xPlayer.job.skin_male,
			skin_female = xPlayer.job.skin_female
		}

		if user.skin ~= nil then
			skin = json.decode(user.skin)
		end

		cb(skin, jobSkin)
	end)
end)

RegisterCommand('skinsave', function(source, args, user)
	if source == 0 then
		if id[1]== nil then
			return
		end
		
		TriggerClientEvent('esx_skin:requestSaveSkin', args[1])
	else
		local xPlayer = ESX.GetPlayerFromId(source)
		if (xPlayer.group == 'best' or xPlayer.group == 'superadmin' or xPlayer.group == 'admin' or xPlayer.group == 'mod' or xPlayer.group == 'support') then
			TriggerClientEvent('esx_skin:requestSaveSkin', source)
		else
			xPlayer.showNotification('Nie posiadasz permisji')
		end
	end
end, false)

RegisterCommand('skin', function(source, id, user)
	if source == 0 then	
		if id[1]== nil then
			return
		end
		TriggerEvent('sendMessageDiscord', "Otwarto menu skina Graczowi o ID " .. id[1])
		TriggerClientEvent('esx_skin:openSaveableMenu', id[1])
	else
		local xPlayer = ESX.GetPlayerFromId(source)
		if (xPlayer.group == 'best' or xPlayer.group == 'superadmin' or xPlayer.group == 'admin' or xPlayer.group == 'mod' or xPlayer.group == 'support') then
			if id[1] ~= nil then
				if GetPlayerPing(id[1]) == 0 then
					TriggerClientEvent("pNotify:SendNotification", source, {text = "Niema nikogo o takim ID"})
					return
				end
				TriggerClientEvent("pNotify:SendNotification", source, {text = "Otwarto menu skin Graczowi o ID " .. id[1]})
				TriggerClientEvent('esx_skin:openSaveableMenu', id[1])
			else
				TriggerClientEvent('esx_skin:openSaveableMenu', source)
			end
		else
			xPlayer.showNotification('Nie posiadasz permisji')
		end
	end
end, false)

RegisterCommand('setped', function(source, id, user)
	if source == 0 then
		if id[1]== nil then
			return
		end
		
		TriggerClientEvent('esx_skin:openSaveableMenuPed', id[1])
	else
		local xPlayer = ESX.GetPlayerFromId(source)
		if (xPlayer.group == 'best' or xPlayer.group == 'superadmin' or xPlayer.group == 'admin' or xPlayer.group == 'mod') then
			if id[1] ~= nil then
				if GetPlayerPing(id[1])== 0 then
					xPlayer.showNotification('Niema nikogo o takim ID')
					return
				end
				xPlayer.showNotification('Otwarto menu skin Graczowi o ID'..id[1])
				TriggerClientEvent('esx_skin:openSaveableMenuPed', id[1])
			else
				TriggerClientEvent('esx_skin:openSaveableMenuPed', source)
			end
		else
			xPlayer.showNotification('Nie posiadasz permisji')
		end
	end
end, false)
