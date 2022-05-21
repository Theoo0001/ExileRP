ESX = nil
TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

local PlayersInGame = {}
local PlayersCash = {}
local societyName = 'society_casino'
local casinoOpened = true

ESX.RegisterServerCallback(GetCurrentResourceName() .. ':checkSociety', function(source, cb)
	TriggerEvent('esx_addonaccount:getSharedAccount', societyName, function(account)
		cb({money = account.account_money, opened = casinoOpened})
	end)
end)

ESX.RegisterServerCallback(GetCurrentResourceName() .. ':casinoState', function(source, cb)
	casinoOpened = not casinoOpened
	if casinoOpened == true then
		cb('~g~otwarte')
	elseif casinoOpened == false then
		cb('~r~zamknięte')
	end
end)

RegisterServerEvent(GetCurrentResourceName() .. ':sendNews')
AddEventHandler(GetCurrentResourceName() .. ':sendNews', function(job, message)
	TriggerClientEvent('chat:addMessage1', -1, "[" .. job .. "]", {19, 72, 186}, message, "fas fa-newspaper")
	exports['exile_logs']:SendLog(source, "NEWS: [" .. job .. "]: " .. message, 'chat', '8359053')
end)

RegisterServerEvent(GetCurrentResourceName() .. ':bet')
AddEventHandler(GetCurrentResourceName() .. ':bet', function(bets)
    local _source   = source
    local xPlayer   = ESX.GetPlayerFromId(_source)
    if xPlayer then
		local money = xPlayer.getMoney()
		if money < 200 then
			TriggerClientEvent('esx:showNotification', _source, "~r~Potrzebujesz minimum 200$, aby zagrać!")
		else
			PlayersInGame[xPlayer.identifier] = true
			PlayersCash[xPlayer.identifier] = money
			exports['exile_logs']:SendLog(_source, "SLOTY: Rozpoczął grę, ale jeszcze nie wygrał ani nie przegrał!", 'casino')
			TriggerClientEvent(GetCurrentResourceName() .. ':updateSlots', _source, money)
		end
    end
end)

RegisterServerEvent(GetCurrentResourceName()..":takeMoney")
AddEventHandler(GetCurrentResourceName()..":takeMoney", function(ile) 
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if xPlayer then
		xPlayer.removeMoney(ile)
	end	
end)

RegisterServerEvent(GetCurrentResourceName() .. ':reward')
AddEventHandler(GetCurrentResourceName() .. ':reward', function(amount)
    local _source   = source
    local xPlayer   = ESX.GetPlayerFromId(_source)
    if xPlayer then
		if PlayersInGame[xPlayer.identifier] == true then
			amount = math.floor(tonumber(amount))
			if amount >= 0 then
				local diff = math.floor(PlayersCash[xPlayer.identifier] - amount)
				if diff > 0 then
					TriggerEvent('esx_addonaccount:getSharedAccount', societyName, function(account)
						PlayersInGame[xPlayer.identifier] = false
						account.addAccountMoney(diff)
						xPlayer.removeMoney(diff)
						exports['exile_logs']:SendLog(_source, "SLOTY: Przegrał kwotę: " .. diff .. "$", 'casino')
					end)
				elseif diff < 0 then
					diff = diff * -1
					TriggerEvent('esx_addonaccount:getSharedAccount', societyName, function(account)
						PlayersInGame[xPlayer.identifier] = false
						account.removeAccountMoney(diff)
						xPlayer.addMoney(diff)
						exports['exile_logs']:SendLog(_source, "SLOTY: Wygrał kwotę: " .. diff .. "$", 'casino')
					end)
				elseif diff == 0 then
					PlayersInGame[xPlayer.identifier] = false
				end
			end
		else
			TriggerEvent('csskrouble:banPlr', "nigger", _source, "Tried to add money (exile_slots)")
			--exports['exile_logs']:SendLog(_source, GetCurrentResourceName() .. ":reward - Wykryto próbę zrespienia pieniędzy", 'anticheat')
		end
    end
end)