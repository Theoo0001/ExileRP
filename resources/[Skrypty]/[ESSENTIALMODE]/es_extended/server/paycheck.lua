local SERVER_TOKEN = "ExileSecurity"..math.random(9999,999999999999)
local TRIGGER_PAYCHECK = "minutuwa:paycheck"..math.random(99999,999999999)

local acTrigger = "csskroubleAC:payCheck"

RegisterServerEvent(TRIGGER_PAYCHECK)
AddEventHandler(TRIGGER_PAYCHECK, function(token)
	if SERVER_TOKEN == token then
		local _source = source
		local xPlayer = ESX.GetPlayerFromId(_source)
		TriggerEvent(acTrigger, _source)
		local job     = xPlayer.job.name
		local praca   = xPlayer.job.label
		local stopien = xPlayer.job.grade_label
		local salary  = xPlayer.job.grade_salary
		local hiddenjob = xPlayer.hiddenjob.name
		local hiddenpraca = xPlayer.hiddenjob.label
		local hiddensalary = xPlayer.hiddenjob.grade_salary
		if salary > 0 then
			if job == 'unemployed' then
				xPlayer.addAccountMoney('bank', salary)
				if hiddenjob ~= 'unemployed' and hiddenjob ~= job then
					xPlayer.addAccountMoney('bank', hiddensalary)
					TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Bank', 'Konto bankowe: ~g~'..xPlayer.getAccount('bank').money..'$~s~', 'Wynagrodzenia:\n~y~Zasiłek: ~g~'..salary..'$\n~y~' .. hiddenpraca .. ':~g~ ' .. hiddensalary .. '$')
				else
					TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Bank', 'Konto bankowe: ~g~'..xPlayer.getAccount('bank').money..'$~s~', 'Wynagrodzenia:\n~y~Zasiłek: ~g~'..salary..'$')
				end
			else
				xPlayer.addAccountMoney('bank', salary)
				if hiddenjob ~= 'unemployed' and hiddenjob ~= job then
					xPlayer.addAccountMoney('bank', hiddensalary)
					TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Bank', 'Konto bankowe: ~g~'..xPlayer.getAccount('bank').money..'$~s~', 'Wynagrodzenia:\n~y~'..praca..' - '..stopien..':~g~ '..salary..'$\n~y~' .. hiddenpraca .. ':~g~ ' .. hiddensalary .. '$')
				else
					TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Bank', 'Konto bankowe: ~g~'..xPlayer.getAccount('bank').money..'$~s~', 'Wynagrodzenia:\n~y~'..praca..' - '..stopien..':~g~ '..salary..'$')	
				end
			end
		end
	else
		exports['exile_logs']:SendLog(source, "PAYCHECK_ES-EXTENDED: Próba dodania pieniędzy bez poprawnego tokenu", 'anticheat', '15844367')
	end
end)

local recived_token_paycheck = {}
RegisterServerEvent('minutuwa:request')
AddEventHandler('minutuwa:request', function()
	if not recived_token_paycheck[source] then
		TriggerClientEvent("minutuwa:getrequest", source, SERVER_TOKEN, TRIGGER_PAYCHECK)
		recived_token_paycheck[source] = true
	else
		exports['exile_logs']:SendLog(source, "PAYCHECK_ES-EXTENDED: Próba otrzymania ponownie tokenu!", 'anticheat', '15844367')
	end
end)

AddEventHandler('playerDropped', function()
	recived_token_paycheck[source] = nil
end)