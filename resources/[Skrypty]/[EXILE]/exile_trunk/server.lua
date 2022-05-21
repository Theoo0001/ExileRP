ESX                     = nil
TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

RegisterServerEvent('exile_trunk:notify')
AddEventHandler('exile_trunk:notify', function(cop, text)
	local xPlayer = ESX.GetPlayerFromId(cop)
	if xPlayer then
		xPlayer.showNotification(text)
	end
end)