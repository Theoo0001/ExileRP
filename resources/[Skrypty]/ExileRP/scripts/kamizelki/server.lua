ESX.RegisterUsableItem('kamzasmall', function (source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('kamzasmall', 1)
	TriggerClientEvent('exile_kamza', source, 'small')
	TriggerClientEvent('esx:showNotification', source, "~y~Założono małą kamizelkę")
end)

ESX.RegisterUsableItem('kamzaduza', function (source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('kamzaduza', 1)
	TriggerClientEvent('exile_kamza', source, 'big')
	TriggerClientEvent('esx:showNotification', source, "~y~Założono dużą kamizelkę")
end)

ESX.RegisterUsableItem('skarpetka', function (source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('skarpetka', 1)
	TriggerClientEvent('exile_kamza', source, 'skarpetka')
	TriggerClientEvent('esx:showNotification', source, "~y~Założono skarpetę na głowę")
end)

RegisterServerEvent("falszywyy_barylki:mieszacz")
AddEventHandler("falszywyy_barylki:mieszacz", function(es)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local checkziolo = xPlayer.getInventoryItem('weed_pooch').count >= 30
    local checkmetaamfetamina = xPlayer.getInventoryItem('meth_pooch').count >= 30
    local checkkokaina = xPlayer.getInventoryItem('coke_pooch').count >= 30
    local checkopium = xPlayer.getInventoryItem('opium_pooch').count >= 30
	if es == 'weed' then
		if checkziolo and not isDead then 
			xPlayer.removeInventoryItem('weed_pooch', 30)
			xPlayer.showNotification('~y~Zmieszałeś 30 porcji marihuany!')
			xPlayer.addInventoryItem('barylkaziola', 1)
		else
			xPlayer.showNotification('~r~Nie posiadasz 30 porcji marihuany!')
		end
	elseif es == 'meth' then
		if checkmetaamfetamina and not isDead then 
			xPlayer.removeInventoryItem('meth_pooch', 30)
			xPlayer.showNotification('~y~Zmieszałeś 30 porcji metaamfetaminy!')
			xPlayer.addInventoryItem('barylkametaamfetaminy', 1)
		else
			xPlayer.showNotification('~r~Nie posiadasz 30 porcji metaamfetaminy!')
		end
    elseif es == 'coke' then
		if checkkokaina and not isDead then 
			xPlayer.removeInventoryItem('coke_pooch', 30)
			xPlayer.showNotification('~y~Zmieszałeś 30 porcji kokainy!')
			xPlayer.addInventoryItem('barylkakokainy', 1)
		else
			xPlayer.showNotification('~r~Nie posiadasz 30 porcji kokainy!')
		end
    elseif es == 'opium' then
		if checkopium and not isDead then 
			xPlayer.removeInventoryItem('opium_pooch', 30)
			xPlayer.showNotification('~y~Zmieszałeś 30 porcji opium!')
			xPlayer.addInventoryItem('barylkaopium', 1)
		else
			xPlayer.showNotification('~r~Nie posiadasz 30 porcji opium!')
		end
	end
end)

RegisterServerEvent('falszywyy_barylki:komunikat')
AddEventHandler('falszywyy_barylki:komunikat', function(text)
	local _source = source
	TriggerClientEvent("sendProximityMessageMe", -1, _source, _source, text)
	
	color = {r = 112, g = 56, b = 128, alpha = 255}
	TriggerClientEvent('esx_rpchat:triggerDisplay', -1, text, _source, color)
end)

ESX.RegisterUsableItem('mieszacz', function(source)
	TriggerClientEvent('falszywyy_barylki:mieszaczmenu', source)
	Wait(1500)
end)

ESX.RegisterUsableItem('barylkaziola', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local checknozyczki = xPlayer.getInventoryItem('nozyczki').count >= 1

	if checknozyczki and not isDead then
		xPlayer.removeInventoryItem('barylkaziola', 1)
		TriggerClientEvent('esx:showNotification', _source, '~y~Odpakowałeś baryłkę marihuany!')
        xPlayer.addInventoryItem('weed_pooch', 30)
	else
	    TriggerClientEvent('esx:showNotification', _source, '~r~Nie posiadasz nożyczek!')
	end
end)

ESX.RegisterUsableItem('barylkametaamfetaminy', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local checknozyczki = xPlayer.getInventoryItem('nozyczki').count >= 1

	if checknozyczki and not isDead then      
		xPlayer.removeInventoryItem('barylkametaamfetaminy', 1)
        xPlayer.removeInventoryItem('nozyczki', 1)
		TriggerClientEvent('esx:showNotification', _source, '~y~Odpakowałeś baryłkę metaamfetaminy!')
        xPlayer.addInventoryItem('meth_pooch', 30)
	else
	    TriggerClientEvent('esx:showNotification', _source, '~r~Nie posiadasz nożyczek!')
	end
end)

ESX.RegisterUsableItem('barylkakokainy', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local checknozyczki = xPlayer.getInventoryItem('nozyczki').count >= 1

	if checknozyczki and not isDead then   
		xPlayer.removeInventoryItem('barylkakokainy', 1)
        xPlayer.removeInventoryItem('nozyczki', 1)
		TriggerClientEvent('esx:showNotification', _source, '~y~Odpakowałeś baryłkę kokainy!')
        xPlayer.addInventoryItem('coke_pooch', 30)
	else
	    TriggerClientEvent('esx:showNotification', _source, '~r~Nie posiadasz nożyczek!')
	end
end)

ESX.RegisterUsableItem('barylkaopium', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local checknozyczki = xPlayer.getInventoryItem('nozyczki').count >= 1

	if checknozyczki and not isDead then  
		xPlayer.removeInventoryItem('barylkaopium', 1)
        xPlayer.removeInventoryItem('nozyczki', 1)
		TriggerClientEvent('esx:showNotification', _source, '~y~Odpakowałeś baryłkę opium!')
        xPlayer.addInventoryItem('opium_pooch', 30)
	else
	    TriggerClientEvent('esx:showNotification', _source, '~r~Nie posiadasz nożyczek!')
	end
end)