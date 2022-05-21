ESX = nil

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

local SERVER_TOKEN = "ExileSecurity"..math.random(9999,999999999999)

RegisterServerEvent('milkman:CollectMilk') 
AddEventHandler('milkman:CollectMilk', function(token)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xItem = xPlayer.getInventoryItem('milk_in_pail')

    local countToAdd = 20

    if SERVER_TOKEN == token then
        if xPlayer.job.name == 'milkman' then
            if xItem.count >= xItem.limit then
                xPlayer.showNotification('~r~Nie uniesiesz więcej mleka!')
                return
            elseif xItem.limit ~= -1 and (xItem.count + 10) > 100 then
                countToAdd = 100-xItem.count
            end
            xPlayer.addInventoryItem('milk_in_pail', countToAdd)
            TriggerClientEvent('esx:showNotification', _source, 'Zebrałeś ~y~'.. countToAdd .. ' mleka')
        else
            TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to add money without job (Prace legalne)")
            --exports['exile_logs']:SendLog(_source, "MLECZARZ: Próba dodania pieniędzy bez pracy!", 'milkman', '5793266')
        end
    else
        TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to add money without token (Prace legalne)")
        --exports['exile_logs']:SendLog(_source, "MLECZARZ: Próba dodania kasy bez prawidlowego tokenu!", 'anticheat', '5793266')
    end
end)

local TRIGGER_SELL = "milkman:SellMilk"..math.random(9999,999999)

RegisterServerEvent(TRIGGER_SELL) 
AddEventHandler(TRIGGER_SELL, function(token)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if SERVER_TOKEN == token then
        local count = xPlayer.getInventoryItem('milk_in_pail').count
        local reward = 300
        local total = count * reward
        if xPlayer.job.name == 'milkman' then
            if xPlayer.job.grade == 8 then
                total = total * 1.50
            elseif xPlayer.job.grade == 7 then
                total = total * 1.43
            elseif xPlayer.job.grade == 6 then
                total = total * 1.37
            elseif xPlayer.job.grade == 5 then
                total = total * 1.31
            elseif xPlayer.job.grade == 4 then
                total = total * 1.25
            elseif xPlayer.job.grade == 3 then
                total = total * 1.18
            elseif xPlayer.job.grade == 2 then
                total = total * 1.12
            elseif xPlayer.job.grade == 1 then
                total = total * 1.06
            elseif xPlayer.job.grade == 0 then
                total = total
            end
            if total < 65000 then
                TriggerEvent('esx_addonaccount:getSharedAccount', 'society_milkman', function(account)
                    if account then
                        xPlayer.removeInventoryItem('milk_in_pail', count)
                        local playerMoney  = ESX.Math.Round(total)
                        local societyMoney = ESX.Math.Round(total / 100 * 30)    
                        xPlayer.addMoney(playerMoney)
                        account.addAccountMoney(societyMoney)
                        TriggerClientEvent('esx:showNotification', _source, 'Otrzymano ~g~'..playerMoney..'$ ~s~za sprzedaż mleka.')
                        xPlayer.addInventoryItem('gwiazdki', 9)
                        xPlayer.showNotification('Otrzymano 9x Jajko Wielkanocne')
                        exports['exile_logs']:SendLog(_source, "MLECZARZ: Zakończono kurs. Sprzedano x" ..count.. " mleka. Zarobek: " .. playerMoney .. "$", 'milkman', '5793266')
                    else
                        xPlayer.removeInventoryItem('milk_in_pail', count)
                        xPlayer.addMoney(total)
                        TriggerClientEvent('esx:showNotification', _source, 'Otrzymano ~g~'..total..'$ ~s~za sprzedaż mleka.')
                        xPlayer.addInventoryItem('gwiazdki', 9)
                        xPlayer.showNotification('Otrzymano 9x Jajko Wielkanocne')
                        exports['exile_logs']:SendLog(_source, "MLECZARZ: Zakończono kurs. Sprzedano x" ..count.. " mleka. Zarobek: " .. total .. "$", 'milkman', '5793266')
                    end
                end)
                if count >= 100 then
                    TriggerEvent('ExileRP:saveCours', xPlayer.job.name, xPlayer.job.grade, xPlayer.source)
                end
            else
                TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to add money (Prace legalne)")
                --exports['exile_logs']:SendLog(_source, "MLECZARZ: Próba zarobienia wiecej siana niz 45k!", 'anticheat', '5793266')
            end
        else
            TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to add money without job (Prace legalne)")
            --exports['exile_logs']:SendLog(_source, "MLECZARZ: Próba dodania pieniędzy bez pracy!", 'anticheat', '5793266')
        end
    else
        TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to add money with wrong token (Prace legalne)")
		--exports['exile_logs']:SendLog(_source, "MLECZARZ: Próba dodania kasy bez prawidlowego tokenu!", 'anticheat', '5793266')
	end
end)

local recived_token_milkman = {}
RegisterServerEvent('milkman:request')
AddEventHandler('milkman:request', function()
	if not recived_token_milkman[source] then
		TriggerClientEvent("milkman:getrequest", source, SERVER_TOKEN, TRIGGER_SELL)
		recived_token_milkman[source] = true
	else
        TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to get token (Prace legalne)")
		--exports['exile_logs']:SendLog(source, "MLECZARZ: Próba otrzymania ponownie tokenu!", 'anticheat', '5793266')
	end
end)

AddEventHandler('playerDropped', function()
    recived_token_milkman[source] = nil
end)

local SmiecieSiedzace = {}
RegisterServerEvent('exile_milkman:insertPlayer')
AddEventHandler('exile_milkman:insertPlayer', function(tablice)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local insertLabel = GetPlayerName(_source)..' ['..xPlayer.character.firstname ..' '.. xPlayer.character.lastname..'] '..os.date("%H:%M:%S")
	table.insert(SmiecieSiedzace, {label = insertLabel, plate = tablice})
end)

ESX.RegisterServerCallback('exile_milkman:checkSiedzacy', function(source, cb)
	cb(SmiecieSiedzace)
end)