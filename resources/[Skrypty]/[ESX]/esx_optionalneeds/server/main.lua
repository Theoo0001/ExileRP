ESX = nil

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj)
	ESX = obj
end)

ESX.RegisterUsableItem('papieros', function(source)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local checkzapalniczka = xPlayer.getInventoryItem('zapalniczka').count >= 1

	if checkzapalniczka and not isDead then 
	
		xPlayer.removeInventoryItem('papieros', 1)
		TriggerClientEvent('esx:showNotification', _source, 'Zapaliłeś papierosa.')
		TriggerClientEvent('esx_optionalneeds:smoke', _source)

	else

	    TriggerClientEvent('esx:showNotification', _source, '~r~Nie posiadasz zapalniczki!')
	
	end

end)

ESX.RegisterUsableItem('vape', function(source)
	
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local checkliquid = xPlayer.getInventoryItem('liquid').count >= 1

	if checkliquid and not isDead then
		xPlayer.removeInventoryItem('liquid', 1)
		TriggerClientEvent('esx:showNotification', _source, 'Użyłeś ~b~E-Papierosa.')
		TriggerClientEvent("Vape:StartVaping", source, 0)
	else
		TriggerClientEvent('esx:showNotification', _source, '~r~Nie posiadasz liquidu!')
	end

end)

ESX.RegisterUsableItem('gumka', function(source)
	
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if not isDead then
		TriggerClientEvent('esx:showNotification', _source, 'Założyleś prezerwatywę.')
	end

end)

RegisterServerEvent("esx_optionalneeds:crusher")
AddEventHandler("esx_optionalneeds:crusher", function(es)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local checkweed = xPlayer.getInventoryItem('weed').count >= 1
	local checkoghaze = xPlayer.getInventoryItem('oghaze_pooch').count >= 1
	local checkbletka = xPlayer.getInventoryItem('bletka').count >= 1
	local checkpapieros = xPlayer.getInventoryItem('papieros').count >= 1
	if es == '1' then
		if checkoghaze and checkbletka and checkpapieros and not isDead then 
			xPlayer.removeInventoryItem('oghaze_pooch', 1)
			xPlayer.removeInventoryItem('bletka', 1)
			xPlayer.removeInventoryItem('papieros', 1)
			xPlayer.showNotification('Skręciłeś blanta z ~g~OG Haze~s~.')
			xPlayer.addInventoryItem('blantoghaze', 1)
		else
			xPlayer.showNotification('~r~Nie posiadasz OG Haze, bletki lub papierosa!')
		end
	elseif es == '2' then
		if checkweed and checkbletka and checkpapieros and not isDead then 
			xPlayer.removeInventoryItem('oghaze_pooch', 1)
			xPlayer.removeInventoryItem('bletka', 1)
			xPlayer.removeInventoryItem('papieros', 1)
			xPlayer.showNotification('Skręciłeś ~g~jointa~s~.')
			xPlayer.addInventoryItem('joint', 1)
		else
			xPlayer.showNotification('~r~Nie posiadasz Marihuany, bletki lub papierosa!')
		end
	end
end)

ESX.RegisterUsableItem('crusher', function(source)
	TriggerClientEvent('esx_optionalneeds:menucrushera', source)
	Wait(1500)
end)

ESX.RegisterUsableItem('blantoghaze', function(source)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local checkzapalniczka = xPlayer.getInventoryItem('zapalniczka').count >= 1

	if checkzapalniczka and not isDead then 
	
		xPlayer.removeInventoryItem('blantoghaze', 1)
		TriggerClientEvent('esx:showNotification', _source, 'Zjarałeś blanta z ~b~OG Haze ~s~enjoy.')
		TriggerClientEvent('esx_optionalneeds:OGHaze', _source)

	else

	    TriggerClientEvent('esx:showNotification', _source, '~r~Nie posiadasz zapalniczki!')
	
	end

end)

ESX.RegisterUsableItem('joint', function(source)
	
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local checkzapalniczka = xPlayer.getInventoryItem('zapalniczka').count >= 1

	if checkzapalniczka and not isDead then 

		xPlayer.removeInventoryItem('joint', 1)
		TriggerClientEvent('xlem0n_drugs:onPot', _source)
		TriggerClientEvent('esx_status:add', _source, 'drug', 120000)
		TriggerClientEvent('esx:showNotification', _source, 'Zjarałeś ~b~jointa')
	
	else

		TriggerClientEvent('esx:showNotification', _source, '~r~Nie posiadasz zapalniczki!')
	
	end

end)

ESX.RegisterUsableItem('exctasy_pooch', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	xPlayer.removeInventoryItem('exctasy_pooch', 1)
	TriggerClientEvent('esx_optionalneeds:Exctasy', _source)
	TriggerClientEvent('esx:showNotification', _source, 'Masz zjazd po ~b~ex')
end)

ESX.RegisterUsableItem('antydzwon', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local checkzapalniczka = xPlayer.getInventoryItem('zapalniczka').count >= 1

	if checkzapalniczka and not isDead then 
		xPlayer.removeInventoryItem('antydzwon', 1)
		TriggerClientEvent('esx_optionalneeds:AntyDzwon', _source)
		TriggerClientEvent('esx:showNotification', _source, '~y~Zjarałeś OG Creisa, ale się urobiłeś')
	else
		TriggerClientEvent('esx:showNotification', _source, '~r~Nie posiadasz zapalniczki!')
	end
end)