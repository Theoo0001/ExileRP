ESX = nil
TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

TriggerEvent('esx_society:registerSociety', 'courier', 'Kurier', 'society_courier', 'society_courier', 'society_courier', {type = 'private'})
local AuthorizedKey = math.random(100,999)
local AuthorizedClients = {}
--TriggerEvent('ExileAC:addEvent', GetCurrentResourceName() .. ':zaplata' .. AuthorizedKey)
--RegisterNetEvent(GetCurrentResourceName() .. ':zaplata' .. AuthorizedKey)
--AddEventHandler(GetCurrentResourceName() .. ':zaplata' .. AuthorizedKey, function()

local event1 = 'esx_kurier:DajHajs' .. math.random(1000,1000000)
local token = math.random(100000,99999999)

RegisterNetEvent(event1)
AddEventHandler(event1, function(gettoken)
	local _source = source
    if gettoken == token then
        local xPlayer = ESX.GetPlayerFromId(_source)
        local total = math.random(Config.Zaplata.min, Config.Zaplata.max)
        
        if xPlayer.job.name == 'courier' then
            if xPlayer.job.grade == 8 then
                total = total * 1.5
            elseif xPlayer.job.grade == 7 then
                total = total * 1.45
            elseif xPlayer.job.grade == 6 then
                total = total * 1.4
            elseif xPlayer.job.grade == 5 then
                total = total * 1.35
            elseif xPlayer.job.grade == 4 then
                total = total * 1.28
            elseif xPlayer.job.grade == 3 then
                total = total * 1.21
            elseif xPlayer.job.grade == 2 then
                total = total * 1.14
            elseif xPlayer.job.grade == 1 then
                total = total * 1.07
            elseif xPlayer.job.grade == 0 then
                total = total
            end
            if tonumber(exports['esx_jobs']:ExportLevel(xPlayer.identifier)) > 0 then
                total = total + ((total * tonumber(exports['esx_jobs']:ExportLevel(xPlayer.identifier))) / 100)
            else
                total = total
            end
            TriggerEvent('esx_addonaccount:getSharedAccount', 'society_courier', function(account)
                if account then
                    local playerMoney  = ESX.Math.Round(total)
                    local societyMoney = ESX.Math.Round(total / 100 * 30)    
                    xPlayer.addMoney(playerMoney)
                    account.addAccountMoney(societyMoney)
                    TriggerClientEvent('esx:showNotification', _source, 'Otrzymano ~g~'..playerMoney..'$ ~s~za dostarczenie przesyłki.')
                    xPlayer.addInventoryItem('gwiazdki', 1)
                    xPlayer.showNotification('Otrzymano 1x gwiazdki')
                    exports['exile_logs']:SendLog(_source, "ESX_KURIER: Zakończono kurs. Zarobek: " .. playerMoney .. "$", 'courier', '15844367')
                else
                    xPlayer.addMoney(total)
                    TriggerClientEvent('esx:showNotification', _source, 'Otrzymano ~g~'..total..'$ ~s~za dostarczenie przesyłki.')
                    xPlayer.addInventoryItem('gwiazdki', 1)
                    xPlayer.showNotification('Otrzymano 1x gwiazdki')
                    exports['exile_logs']:SendLog(_source, "ESX_KURIER: Zakończono kurs. Zarobek: " .. total .. "$", 'courier', '15844367')
                end
            end)
            TriggerEvent('ExileRP:saveCours', xPlayer.job.name, xPlayer.job.grade, xPlayer.source)
        else
            TriggerEvent("csskrouble:banPlr", "nigger", source,  "Tried to trigger event (esx_kurier)")
            --exports['exile_logs']:SendLog(_source, "Wykryto próbę wywołania eventu bez odpowiedniej pracy: ESX_KURIER", 'anticheat', '15158332')
        end
    else
        TriggerEvent("csskrouble:banPlr", "nigger", source,  "Tried to trigger event (esx_kurier)")
        --exports['exile_logs']:SendLog(_source, "Wykryto próbę wywołania eventu ze złym tokenem: ESX_KURIER", 'anticheat', '15158332')
    end
end)

RegisterServerEvent('esx_kurier:PobierzKaucje')
AddEventHandler('esx_kurier:PobierzKaucje', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.removeMoney(500)
    --TriggerClientEvent('pNotify:SendNotification', source, {text = 'Pobrano kaucję w wysokości $750 za wypożyczenie pojazdu.'})
    TriggerClientEvent('esx:showNotification', _source, 'Pobrano kaucję w wysokości ~r~$400 za wypożyczenie pojazdu.')
end)

-- RegisterServerEvent('esx_kurier:OddajKaucje')
-- AddEventHandler('esx_kurier:OddajKaucje', function(info)
-- 	local _source = source
--     local xPlayer = ESX.GetPlayerFromId(_source)
    
--     if info == 'anulowanie' then
--         xPlayer.addMoney(400)
--         --TriggerClientEvent('pNotify:SendNotification', source, {text = 'Zwrócono niepełną kaucję w wysokości $500 za anulowanie zleceń.'})
--         TriggerClientEvent('esx:showNotification', _source, 'Zwrócono niepełną kaucję w wysokości ~g~$400 za anulowanie zleceń.')
--     elseif info == 'zakonczenie' then
--         xPlayer.addMoney(400)
--         --TriggerClientEvent('pNotify:SendNotification', source, {text = 'Otrzymano premią w wysokości $500 za dostarczenie wszystkich przesyłek.'})
--         TriggerClientEvent('esx:showNotification', _source, 'Otrzymano premią w wysokości ~g~$400 za dostarczenie wszystkich przesyłek.')
--     end
-- end)


RegisterServerEvent('kurier:registerClient')
AddEventHandler('kurier:registerClient', function(_eventName)
	local _source = source
	local _sourceName = GetPlayerName(_source)
	local _sourceIdentifier = GetPlayerIdentifier(_source, 0)

	if _sourceIdentifier ~= nil then
		if (AuthorizedClients[_sourceIdentifier:lower()] == nil) then
			AuthorizedClients[_sourceIdentifier:lower()] = _eventName
			TriggerClientEvent(AuthorizedClients[_sourceIdentifier:lower()], _source, AuthorizedKey)
		end
	end
end)


--TriggerEvent('ExileAC:addEvent', GetCurrentResourceName() .. ':sprzedajFaktury' .. AuthorizedKey)
--RegisterNetEvent(GetCurrentResourceName() .. ':sprzedajFaktury' .. AuthorizedKey)
--AddEventHandler(GetCurrentResourceName() .. ':sprzedajFaktury' .. AuthorizedKey, function()
RegisterNetEvent('exile_kurier:SprzedajFaktury')
AddEventHandler('exile_kurier:SprzedajFaktury', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local item = xPlayer.getInventoryItem('fakturakurier')
	
	if xPlayer.job.name == 'courier' then
		if item.count >= 5 then
			xPlayer.removeInventoryItem('fakturakurier', 5)
			TriggerClientEvent('exile_courier:invoicesSold', _source)
			exports['exile_logs']:SendLog(_source, "ESX_KURIER: Oddano 5 faktur", 'courier', '15105570')
		else
			TriggerClientEvent('esx:showNotification', _source, "Nie masz wystarczająco ~y~faktur")
		end
	else
		--print(('[esx_taxijob] [^3WARNING^7] %s attempted to trigger sellInvoices'):format(xPlayer.identifier))
	end
end)

local SmiecieSiedzace = {}
RegisterServerEvent('kurier:insertSmiec')
AddEventHandler('kurier:insertSmiec', function(tablice)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local insertLabel = GetPlayerName(_source)..' ['..xPlayer.character.firstname ..' '.. xPlayer.character.lastname..'] '..os.date("%H:%M:%S")
    table.insert(SmiecieSiedzace, {label = insertLabel, plate = tablice})
    --print(nick)
end)

ESX.RegisterServerCallback('kurier:checkSiedzacy', function(source, cb)
	cb(SmiecieSiedzace)
end)


local get_code = {}
RegisterNetEvent("esx_kurier:code")
AddEventHandler("esx_kurier:code", function()   
    if not get_code[source] then
        TriggerClientEvent("esx_kurier:code", source, event1, token)
        get_code[source] = true
    else
        return
    end
end)