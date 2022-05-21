ESX = nil

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('hifi', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	xPlayer.removeInventoryItem('hifi', 1)
	
	TriggerClientEvent('esx_hifi:place_hifi', source)
	TriggerClientEvent('esx:showNotification', source, 'Upuściłeś BoomBox')
end)

RegisterServerEvent('esx_hifi:remove_hifi')
AddEventHandler('esx_hifi:remove_hifi', function(coords)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.canCarryItem('hifi', 1) then
		xPlayer.addInventoryItem('hifi', 1)
	else
		xPlayer.showNotification('Nie możesz więcej unieść')
	end
	TriggerClientEvent('esx_hifi:stop_music', -1, coords)
end)


RegisterServerEvent('esx_hifi:play_music')
AddEventHandler('esx_hifi:play_music', function(id, coords)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_hifi:play_music', -1, id, coords)
end)

RegisterServerEvent('esx_hifi:stop_music')
AddEventHandler('esx_hifi:stop_music', function(coords)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_hifi:stop_music', -1, coords)
end)

RegisterServerEvent('esx_hifi:setVolume')
AddEventHandler('esx_hifi:setVolume', function(volume, coords)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('esx_hifi:setVolume', -1, volume, coords)
end)
