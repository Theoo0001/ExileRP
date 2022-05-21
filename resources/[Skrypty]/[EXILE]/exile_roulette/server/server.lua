ESX						= nil
TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

local PlayersInGame = {}
local societyName = 'society_casino'

RegisterServerEvent(GetCurrentResourceName() .. ':removeMoney')
AddEventHandler(GetCurrentResourceName() .. ':removeMoney', function(amount)
	local amount = amount
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	PlayersInGame[xPlayer.identifier] = true
	TriggerEvent('esx_addonaccount:getSharedAccount', societyName, function(account)
		account.addAccountMoney(amount)
		xPlayer.removeMoney(amount)
		exports['exile_logs']:SendLog(_source, "RULETKA: Przegrał kwotę " .. amount .. "$", 'casino')
	end)
end)

RegisterServerEvent(GetCurrentResourceName() .. ':giveMoney')
AddEventHandler(GetCurrentResourceName() .. ':giveMoney', function(action, amount)
	local aciton = aciton
	local amount = amount
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer then
		if PlayersInGame[xPlayer.identifier] == true then
			if action == 'black' or action == 'red' then
				local win = amount*2
				PlayersInGame[xPlayer.identifier] = false
				TriggerEvent('esx_addonaccount:getSharedAccount', societyName, function(account)
					account.removeAccountMoney(win)
					xPlayer.addMoney(win)
					TriggerClientEvent('exile_slots:updateSociety', -1, account.account_money)
					exports['exile_logs']:SendLog(_source, "RULETKA: Wygrał stawiając na: "..action.." na kwotę " .. win .. "$", 'casino')
				end)
			elseif action == 'green' then
				local win = amount*14
				PlayersInGame[xPlayer.identifier] = false
				TriggerEvent('esx_addonaccount:getSharedAccount', societyName, function(account)
					account.removeAccountMoney(win)
					xPlayer.addMoney(win)
					TriggerClientEvent('exile_slots:updateSociety', -1, account.account_money)
					exports['exile_logs']:SendLog(_source, "RULETKA: Wygrał stawiając na: "..action.." na kwotę " .. win ..  "$", 'casino')
				end)
			else
			end
		else
			TriggerEvent('csskrouble:banPlr', "nigger", source, "Tried to add money (exile_roulette)")
			--exports['exile_logs']:SendLog(_source, GetCurrentResourceName() .. ':giveMoney - Wykryto próbę zrespienia pieniędzy', 'anticheat')
		end
	end
end)

ESX.RegisterServerCallback(GetCurrentResourceName() .. ':checkMoney', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local quantity = xPlayer.getMoney()
	
	cb(quantity)
end)