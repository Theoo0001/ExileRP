ESX = nil
TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)


RegisterServerEvent('exile_jobs:nadawanie')
AddEventHandler('exile_jobs:nadawanie', function(job)
	
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.setJob(job, 0)
	TriggerClientEvent('esx:showNotification', source, '~b~Zatrudniłeś/aś się jako ~g~' ..xPlayer.getJob().label)

end)