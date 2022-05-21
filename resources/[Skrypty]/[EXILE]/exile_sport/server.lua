ESX = nil

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('pilka', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('pilka', 1)
	TriggerClientEvent('pilka', source)
end)

RegisterNetEvent('pilka:dodaj')
AddEventHandler('pilka:dodaj', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.setInventoryItem('pilka', 1)
end)