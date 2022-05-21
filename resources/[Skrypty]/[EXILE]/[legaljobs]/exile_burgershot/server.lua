ESX = nil

local PlayersHarvesting		   = {}
local PlayersTransforming	   = {}
local PlayersSelling	   	   = {}
local recived_token_cofe = {}
local TRIGGER_SELL = "exile_burgershot:SellCoffee"..math.random(9999,999999)
local TRIGGER_TRANSFERING = "exile_burgershot:Transfering"..math.random(9999,999999)
local SERVER_TOKEN = "ExileSecurity"..math.random(9999,999999999999)
local TIRGGER_COLLECT = "exile_burgershot:collect"..math.random(9999,999999999999)
TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

local function Harvest(source, name)
		if PlayersHarvesting[source] == true then
			local xPlayer  = ESX.GetPlayerFromId(source)
            local item = xPlayer.getInventoryItem(name)
			if item.limit ~= -1 and item.count >= item.limit then
                TriggerClientEvent('esx:showNotification', source, 'Nie uniesiesz więcej ~y~'..item.label)
                TriggerClientEvent('exile_burgershot:Cancel', source)
			else
				xPlayer.addInventoryItem(name, 25)
			end
		else
			return
		end
end

function SalaryCheck(grade)
    if grade == 9 then
        return true
    else
        return false
    end
end

RegisterServerEvent(TIRGGER_COLLECT)
AddEventHandler(TIRGGER_COLLECT, function(name, token)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	PlayersHarvesting[_source] = true
    if SERVER_TOKEN == token then
        if xPlayer.job.name == 'burgershot' then
            TriggerClientEvent('esx:showNotification', _source, '~y~Trwa zbieranie proszku...')
            Harvest(_source, name)
        else
            TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to collect item without job (Prace legalne)")
            --exports['exile_logs']:SendLog(_source, "BURGERSHOT: Próba zbierania proszku bez pracy!", 'anticheat', '15844367')
        end
    else
        TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to collect item with wrong token (Prace legalne)")
        --exports['exile_logs']:SendLog(_source, "BURGERSHOT: Próba zbierania proszku bez prawidlowego tokenu! EVENT: exile:burgershot:collect", 'anticheat', '15844367')
    end
end)

RegisterServerEvent(TRIGGER_TRANSFERING)
AddEventHandler(TRIGGER_TRANSFERING, function(countBefore, token)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if SERVER_TOKEN == token then
        if xPlayer.job.name == 'burgershot' then
            if countBefore >= 100 then
                local xItem = xPlayer.getInventoryItem('skladniki')
                if xItem.count == 100 then
                    local itemCount = math.floor((countBefore / 2.5))

                    xPlayer.removeInventoryItem('skladniki', itemCount * 2.5)
                    TriggerEvent('exile:addItemToStock', _source, 'item_standard', 'burger', itemCount, 'society_'..xPlayer.job.name)
                    Paycheck('burgershot', xPlayer)
                    if itemCount >= 1 then
                        TriggerEvent('ExileRP:saveCours', xPlayer.job.name, xPlayer.job.grade, xPlayer.source)
                    end
                else
                    exports['exile_logs']:SendLog(_source, "BURGERSHOT: Próba zbugowania przeróbki! - gracz próbował przerabiać z " .. xItem.count .. ' skladniki (100 wymagane)', 'anticheat', '15844367')
                end
            else
                TriggerClientEvent('esx:showNotification', _source, '~r~Niezła próba oszustwa :)')
                exports['exile_logs']:SendLog(_source, "BURGERSHOT OSTRZEŻENIE: Próba zbugowania przeróbki!", 'anticheat', '15844367')
            end
        else
            TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to collect item without job (Prace legalne)")
            --exports['exile_logs']:SendLog(_source, "BURGERSHOT: Próba przerabiania skladników bez pracy!", 'anticheat', '15844367')
        end
    else
        TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to collect item with wrong token (Prace legalne)")
        --exports['exile_logs']:SendLog(_source, "BURGERSHOT: Próba przerabiania skladników bez prawidlowego tokenu! EVENT: exile:burgershot:Transfering", 'anticheat', '15844367')
    end
end)

Paycheck = function(job, xPlayer)
	local total = nil
	if job == 'burgershot' then
		if xPlayer.job.grade == 9 then
			total = 40500
		elseif xPlayer.job.grade == 8 then
			total = 39000
		elseif xPlayer.job.grade == 7 then
			total = 37500
		elseif xPlayer.job.grade == 6 then
			total = 36000
		elseif xPlayer.job.grade == 5 then
            total = 34500
        elseif xPlayer.job.grade == 4 then
            total = 33000
        elseif xPlayer.job.grade == 3 then
            total = 31500
        elseif xPlayer.job.grade == 2 then
            total = 30000
        elseif xPlayer.job.grade == 1 then
			total = 28500
		elseif xPlayer.job.grade == 0 then
            total = 27000
		end
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..job, function(account)
			if account then
				xPlayer.addMoney(total)
				account.removeAccountMoney(total)
				xPlayer.showNotification('Otrzymano ~g~'..total..'$ ~s~za dostarczenie Burgerów.')
                xPlayer.addInventoryItem('gwiazdki', 7)
                xPlayer.showNotification('Otrzymano 7x Jajko Wielkanocne')
				exports['exile_logs']:SendLog(xPlayer.source, "BURGERSHOT: Zakończono kurs. Zarobek: " ..total.. "$", 'burgershot', '15844367')
			else
				xPlayer.addMoney(total)
				xPlayer.showNotification('Otrzymano ~g~'..total..'$ ~s~za dostarczenie Burgerów.')
                xPlayer.addInventoryItem('gwiazdki', 7)
                xPlayer.showNotification('Otrzymano 7x Jajko Wielkanocne')
				exports['exile_logs']:SendLog(xPlayer.source, "BURGERSHOT: Zakończono kurs. Zarobek: " ..total.. "$", 'burgershot', '15844367')
			end
		end)
	end
end

RegisterServerEvent(TRIGGER_SELL) 
AddEventHandler(TRIGGER_SELL, function(count, token)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if SERVER_TOKEN == token then
        local toPocket = SalaryCheck(xPlayer.job.grade)
        local reward = 970
        local total = count * reward
        if xPlayer.job.name == 'burgershot' then
            if toPocket then
                local playerMoney  = ESX.Math.Round(total)
                xPlayer.removeInventoryItem('burger', count)
                xPlayer.addMoney(playerMoney)
                TriggerClientEvent('esx:showNotification', _source, 'Otrzymano ~g~'..playerMoney..'$ ~s~za sprzedaż Burgerów.')
                exports['exile_logs']:SendLog(xPlayer.source, "BURGERSHOT: Zakończono kurs. Zarobek: " .. playerMoney .. "$", 'burgershot', '9807270')
            else
                TriggerEvent('esx_addonaccount:getSharedAccount', 'society_burgershot', function(account)
                    local societyMoney = ESX.Math.Round(total)  
                    xPlayer.removeInventoryItem('burger', count)  
                    account.addAccountMoney(societyMoney)
                    TriggerClientEvent('esx:showNotification', _source, 'Firma zarobiła ~g~'..societyMoney..'$ ~s~za sprzedaż Burgerów.')
                    exports['exile_logs']:SendLog(_source, "BURGERSHOT: Zakończono kurs. Sprzedano x" ..count.. " burgerów. Zarobek: " .. societyMoney .. "$", 'burgershot', '9807270')
                end)
            end
        else
            TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to add money without job (Prace legalne)")
            --exports['exile_logs']:SendLog(_source, "BURGERSHOT: Próba dodania pieniędzy bez pracy!", 'anticheat', '15844367')
        end
    else
        TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to add money with wrong token (Prace legalne)")
		--exports['exile_logs']:SendLog(_source, "BURGERSHOT: Próba dodania kasy bez prawidlowego tokenu! EVENT: exile_burgershot:SellCoffee", 'anticheat', '15844367')
	end
end)

RegisterServerEvent('exile_burgershot:stopPickup')
AddEventHandler('exile_burgershot:stopPickup', function(zone)
	local _source = source
	PlayersHarvesting[_source] = nil
end)

RegisterServerEvent('exile_burgershot:request')
AddEventHandler('exile_burgershot:request', function()
	if not recived_token_cofe[source] then
		TriggerClientEvent("exile_burgershot:getrequest", source, SERVER_TOKEN, TRIGGER_SELL, TRIGGER_TRANSFERING, TIRGGER_COLLECT)
		recived_token_cofe[source] = true
	else
        TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to get token (Prace legalne)")
		--exports['exile_logs']:SendLog(source, "BURGERSHOT: Próba otrzymania ponownie tokenu!", 'anticheat', '15844367')
	end
end)

AddEventHandler('playerDropped', function()
    recived_token_cofe[source] = nil
    PlayersHarvesting[source] = nil
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function()
	PlayersHarvesting[source] = nil
end)

local SmiecieSiedzace = {}
RegisterServerEvent('exile_burgershot:insertPlayer')
AddEventHandler('exile_burgershot:insertPlayer', function(tablice)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local insertLabel = GetPlayerName(_source)..' ['..xPlayer.character.firstname ..' '.. xPlayer.character.lastname..'] '..os.date("%H:%M:%S")
	table.insert(SmiecieSiedzace, {label = insertLabel, plate = tablice})
end)

ESX.RegisterServerCallback('exile_burgershot:checkSiedzacy', function(source, cb)
	cb(SmiecieSiedzace)
end)
