ESX = nil

local PlayersHarvesting		   = {}
local PlayersTransforming	   = {}
local PlayersSelling	   	   = {}
local recived_token_winiarz = {}
local TRIGGER_SELL = "exile_winiarz:SellCoffee"..math.random(9999,999999)
local TRIGGER_TRANSFERING = "exile_winiarz:Transfering"..math.random(9999,999999)
local SERVER_TOKEN = "ExileSecurity"..math.random(9999,999999999999)
local TIRGGER_COLLECT = "exile_winiarz:collect"..math.random(9999,999999999999)
TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

local function Harvest(source, name)
		if PlayersHarvesting[source] == true then
			local xPlayer  = ESX.GetPlayerFromId(source)
            local item = xPlayer.getInventoryItem(name)
			if item.limit ~= -1 and item.count >= item.limit then
                TriggerClientEvent('esx:showNotification', source, 'Nie uniesiesz więcej ~y~'..item.label)
                TriggerClientEvent('exile_winiarz:Cancel', source)
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
        if xPlayer.job.name == 'winiarz' then
            TriggerClientEvent('esx:showNotification', _source, '~y~Trwa zbieranie miejscowych winogron...')
            Harvest(_source, name)
        else
            TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to get item without job (Prace legalne)")
            --exports['exile_logs']:SendLog(_source, "WINIARZ: Próba zbierania winogron bez pracy!", 'anticheat', '15844367')
        end
    else
        TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to get item without token (Prace legalne)")
        --exports['exile_logs']:SendLog(_source, "WINIARZ: Próba zbierania winogron bez prawidlowego tokenu! EVENT: exile:winiarz:collect", 'anticheat', '15844367')
    end
end)

RegisterServerEvent(TRIGGER_TRANSFERING)
AddEventHandler(TRIGGER_TRANSFERING, function(countBefore, token)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if SERVER_TOKEN == token then
        if xPlayer.job.name == 'winiarz' then
            if countBefore >= 100 then
                local xItem = xPlayer.getInventoryItem('pear')
                if xItem.count == 100 then
                    local itemCount = math.floor((countBefore / 2.5))

                    xPlayer.removeInventoryItem('pear', itemCount * 2.5)
                    TriggerEvent('exile:addItemToStock', _source, 'item_standard', 'winogrono2', itemCount, 'society_'..xPlayer.job.name)
                    Paycheck('winiarz', xPlayer)
                    if itemCount >= 1 then
                        TriggerEvent('ExileRP:saveCours', xPlayer.job.name, xPlayer.job.grade, xPlayer.source)
                    end
                else
                    exports['exile_logs']:SendLog(_source, "WINIARZ: Próba zbugowania przeróbki! - gracz próbował przerabiać z " .. xItem.count .. ' pearmi (100 wymagane)', 'anticheat', '15844367')
                end
            else
                TriggerClientEvent('esx:showNotification', _source, '~r~Niezła próba oszustwa :)')
                exports['exile_logs']:SendLog(_source, "WINIARZ OSTRZEŻENIE: Próba zbugowania przeróbki!", 'anticheat', '15844367')
            end
        else
            TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to get item without job (Prace legalne)")
            --exports['exile_logs']:SendLog(_source, "WINIARZ: Próba przerabiania winogron bez pracy!", 'anticheat', '15844367')
        end
    else
        TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to get item without token (Prace legalne)")
        --exports['exile_logs']:SendLog(_source, "WINIARZ: Próba przerabiania winogron bez prawidlowego tokenu! EVENT: exile:winiarz:Transfering", 'anticheat', '15844367')
    end
end)



Paycheck = function(job, xPlayer)
	local total, playerMoney = nil, nil
	if job == 'winiarz' then
		if xPlayer.job.grade == 9 then
			total = 36000
		elseif xPlayer.job.grade == 8 then
			total = 34600
		elseif xPlayer.job.grade == 7 then
			total = 33300
		elseif xPlayer.job.grade == 6 then
			total = 32000
		elseif xPlayer.job.grade == 5 then
            total = 30600
        elseif xPlayer.job.grade == 4 then
            total = 29300
        elseif xPlayer.job.grade == 3 then
            total = 28000
        elseif xPlayer.job.grade == 2 then
            total = 26600
        elseif xPlayer.job.grade == 1 then
			total = 25300
		elseif xPlayer.job.grade == 0 then
            total = 24000
		end
		    local playerMoney = total
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..job, function(account)
			if account then
				xPlayer.addMoney(playerMoney)
				account.removeAccountMoney(playerMoney)
				xPlayer.showNotification('Otrzymano ~g~'..playerMoney..'$ ~s~za dostarczenie Winogron.')
                xPlayer.addInventoryItem('gwiazdki', 6)
                xPlayer.showNotification('Otrzymano 6x Jajko Wielkanocne')
				exports['exile_logs']:SendLog(xPlayer.source, "WINIARZ: Zakończono kurs. Zarobek: " .. playerMoney .. "$", 'winiarz', '15844367')
			else
				xPlayer.addMoney(playerMoney)
				xPlayer.showNotification('Otrzymano ~g~'..playerMoney..'$ ~s~za dostarczenie Winogron.')
                xPlayer.addInventoryItem('gwiazdki', 6)
                xPlayer.showNotification('Otrzymano 6x Jajko Wielkanocne')
				exports['exile_logs']:SendLog(xPlayer.source, "WINIARZ: Zakończono kurs. Zarobek: " .. playerMoney .. "$", 'winiarz', '15844367')
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
        local reward = 862
        local total = count * reward
        if xPlayer.job.name == 'winiarz' then
            if toPocket then
                local playerMoney  = ESX.Math.Round(total)
                xPlayer.removeInventoryItem('winogrono2', count)
                xPlayer.addMoney(playerMoney)
                TriggerClientEvent('esx:showNotification', _source, 'Otrzymano ~g~'..playerMoney..'$ ~s~za sprzedaż Winogron.')
                exports['exile_logs']:SendLog(xPlayer.source, "WINIARZ: Zakończono kurs. Zarobek: " .. playerMoney .. "$", 'winiarz', '9807270')
            else
                TriggerEvent('esx_addonaccount:getSharedAccount', 'society_winiarz', function(account)
                    local societyMoney = ESX.Math.Round(total)  
                    xPlayer.removeInventoryItem('winogrono2', count)  
                    account.addAccountMoney(societyMoney)
                    TriggerClientEvent('esx:showNotification', _source, 'Firma zarobiła ~g~'..societyMoney..'$ ~s~za sprzedaż Winogron.')
                    exports['exile_logs']:SendLog(_source, "WINIARZ: Zakończono kurs. Sprzedano x" ..count.. " winogrona. Zarobek: " .. societyMoney .. "$", 'winiarz', '9807270')
                end)
            end
        else
            TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to add money without job (Prace legalne)")
            --exports['exile_logs']:SendLog(_source, "WINIARZ: Próba dodania pieniędzy bez pracy!", 'anticheat', '15844367')
        end
    else
        TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to add money without token (Prace legalne)")
		--exports['exile_logs']:SendLog(_source, "WINIARZ: Próba dodania kasy bez prawidlowego tokenu! EVENT: exile_winiarz:SellCoffee", 'anticheat', '15844367')
	end
end)

RegisterServerEvent('exile_winiarz:stopPickup')
AddEventHandler('exile_winiarz:stopPickup', function(zone)
	local _source = source
	PlayersHarvesting[_source] = nil
end)

RegisterServerEvent('exile_winiarz:request')
AddEventHandler('exile_winiarz:request', function()
	if not recived_token_winiarz[source] then
		TriggerClientEvent("exile_winiarz:getrequest", source, SERVER_TOKEN, TRIGGER_SELL, TRIGGER_TRANSFERING, TIRGGER_COLLECT)
		recived_token_winiarz[source] = true
	else
        TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to get token (Prace legalne)")
		--exports['exile_logs']:SendLog(source, "WINIARZ: Próba otrzymania ponownie tokenu!", 'anticheat', '15844367')
	end
end)

AddEventHandler('playerDropped', function()
    recived_token_winiarz[source] = nil
    PlayersHarvesting[source] = nil
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function()
	PlayersHarvesting[source] = nil
end)

local SmiecieSiedzace = {}
RegisterServerEvent('exile_winiarz:insertPlayer')
AddEventHandler('exile_winiarz:insertPlayer', function(tablice)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local insertLabel = GetPlayerName(_source)..' ['..xPlayer.character.firstname ..' '.. xPlayer.character.lastname..'] '..os.date("%H:%M:%S")
	table.insert(SmiecieSiedzace, {label = insertLabel, plate = tablice})
end)

ESX.RegisterServerCallback('exile_winiarz:checkSiedzacy', function(source, cb)
	cb(SmiecieSiedzace)
end)