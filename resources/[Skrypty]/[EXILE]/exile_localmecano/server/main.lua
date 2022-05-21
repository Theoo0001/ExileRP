ESX = nil

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_repair:checkmoneyforrepair', function (source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= 5000 then
		xPlayer.removeMoney(5000)
		xPlayer.showNotification("~w~Pobrano ~g~5000$ ~w~za naprawę pojazdu")
		cb(true)
	else
		local x = xPlayer.getAccount("bank").money
		if x >= 5000 then
			xPlayer.removeAccountMoney("bank", 5000)
			xPlayer.showNotification("~w~Pobrano ~g~5000$ ~w~z konta bankowego za naprawę pojazdu")
			cb(true)
		else
			cb(false)
		end
	end
end)