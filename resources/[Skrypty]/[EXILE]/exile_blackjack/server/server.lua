ESX						= nil
TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

local PlayersInGame = {}
local societyName = 'society_casino'

ESX.RegisterServerCallback(GetCurrentResourceName() .. ':checkMoney', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local quantity = xPlayer.getMoney()
	cb(quantity)
end)

RegisterServerEvent(GetCurrentResourceName() .. ':removeMoney')
AddEventHandler(GetCurrentResourceName() .. ':removeMoney', function(amount)
	local amount = amount
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	PlayersInGame[xPlayer.identifier] = true
	TriggerEvent('esx_addonaccount:getSharedAccount', societyName, function(account)
		account.addAccountMoney(amount)
		xPlayer.removeMoney(amount)
	end)
	TriggerClientEvent('esx:showNotification', _source, "Postawiłeś ~g~"..amount.."$~w~ w ~y~BlackJack'a")
	exports['exile_logs']:SendLog(_source, "BLACKJACK: Postawił kwotę "..amount.."$", 'casino')
end)

RegisterServerEvent(GetCurrentResourceName() .. ':giveMoney')
AddEventHandler(GetCurrentResourceName() .. ':giveMoney', function(amount, multi)
	local win = math.floor(amount * multi)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer then
		if PlayersInGame[xPlayer.identifier] == true then
			TriggerEvent('esx_addonaccount:getSharedAccount', societyName, function(account)
				account.removeAccountMoney(win)
				xPlayer.addMoney(win)
				TriggerClientEvent('exile_slots:updateSociety', -1, account.money)
			end)
			PlayersInGame[xPlayer.identifier] = false
			if multi == 2 then
				TriggerClientEvent('esx:showNotification', _source, "Wygrałeś ~g~"..win.."$! ~y~Dobra robota!")
				exports['exile_logs']:SendLog(_source, "BLACKJACK: Wygrał kwotę " .. win .. "$", 'casino')
			elseif multi == 1 then
				TriggerClientEvent('esx:showNotification', _source, "~y~Remis! Nic nie wygrałeś, nic nie straciłeś")
				exports['exile_logs']:SendLog(_source, "BLACKJACK: Zremisował nic nie zdobył nic nie stracił!", 'casino')
			end
		else
			exports['exile_logs']:SendLog(_source, GetCurrentResourceName() .. ':giveMoney - Wykryto próbę zrespienia pieniędzy', 'anticheat')
		end
	end
end)