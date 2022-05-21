ESX = nil
local timer = nil
local maksut = 0
local saannit = 0
local societyName = 'society_casino'

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) 
  ESX = obj
end)

RegisterServerEvent('payforplayer2')
AddEventHandler('payforplayer2',function(winnings)
	
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(winnings)
	exports['exile_logs']:SendLog(_source, "SLOTY: Wygrał kwotę: " .. winnings .. "$", 'casino')
	local societyAccount = nil
	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_casino', function(account)
		societyAccount = account
	end)
end)

RegisterServerEvent('playerpays2')
AddEventHandler('playerpays2',function(bet)

	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)

	if xPlayer.getMoney() >= bet then
		TriggerEvent('esx_addonaccount:getSharedAccount', societyName, function(account)
			account.addAccountMoney(bet)
			xPlayer.removeMoney(bet)
			exports['exile_logs']:SendLog(_source, "SLOTY: Przegrał kwotę: " .. bet .. "$", 'casino')
		end)
		TriggerClientEvent('spinit2',_source)
	else
		TriggerClientEvent('errormessage2',_source)
	end
end)
