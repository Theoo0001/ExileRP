ESX = nil

local PlayersHarvesting		   = {}
local PlayersTransforming	   = {}
local PlayersSelling	   	   = {}
local recived_token_cofe = {}
local TRIGGER_SELL = "exile_rzeznik:SellCoffee"..math.random(9999,999999)
local TRIGGER_TRANSFERING = "exile_rzeznik:Transfering"..math.random(9999,999999)
local SERVER_TOKEN = "ExileSecurity"..math.random(9999,999999999999)
local TIRGGER_COLLECT = "exile_rzeznik:collect"..math.random(9999,999999999999)
TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

local function Harvest(source, name)
		if PlayersHarvesting[source] == true then
			local xPlayer  = ESX.GetPlayerFromId(source)
            local item = xPlayer.getInventoryItem(name)
			if item.limit ~= -1 and item.count >= item.limit then
                TriggerClientEvent('esx:showNotification', source, 'Nie uniesiesz więcej ~y~'..item.label)
                TriggerClientEvent('exile_rzeznik:Cancel', source)
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
        if xPlayer.job.name == 'slaughter' then
            TriggerClientEvent('esx:showNotification', _source, '~y~Trwa zbieranie kurczaków...')
            Harvest(_source, name)
        else
            TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to collect item without job (Prace legalne)")
            --exports['exile_logs']:SendLog(_source, "X-GAMER: Próba zbierania kurczaków bez pracy!", 'anticheat', '15844367')
        end
    else
        TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to collect item without token (Prace legalne)")
        --exports['exile_logs']:SendLog(_source, "X-GAMER: Próba zbierania kurczaków bez prawidlowego tokenu! EVENT: exile:cafe:collect", 'anticheat', '15844367')
    end
end)

RegisterServerEvent(TRIGGER_TRANSFERING)
AddEventHandler(TRIGGER_TRANSFERING, function(countBefore, token)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if SERVER_TOKEN == token then
        if xPlayer.job.name == 'slaughter' then
            if countBefore >= 100 then
                local xItem = xPlayer.getInventoryItem('slaughtered_chicken')
                if xItem.count == 100 then
                    local itemCount = math.floor((countBefore / 2.5))

                    xPlayer.removeInventoryItem('slaughtered_chicken', itemCount * 2.5)
                    TriggerEvent('exile:addItemToStock', _source, 'item_standard', 'packaged_chicken', itemCount, 'society_'..xPlayer.job.name)
                    Paycheck('slaughter', xPlayer)
                    if itemCount >= 1 then
                        TriggerEvent('ExileRP:saveCours', xPlayer.job.name, xPlayer.job.grade, xPlayer.source)
                    end
                else
                    exports['exile_logs']:SendLog(_source, "RZEZNIK: Próba zbugowania przeróbki! - gracz próbował przerabiać z " .. xItem.count .. ' kurczakami (100 wymagane)', 'anticheat', '15844367')
                end
            else
                TriggerClientEvent('esx:showNotification', _source, '~r~Niezła próba oszustwa :)')
                exports['exile_logs']:SendLog(_source, "RZEZNIK OSTRZEŻENIE: Próba zbugowania przeróbki!", 'anticheat', '15844367')
            end
        else
            TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to collect item without job (Prace legalne)")
            --exports['exile_logs']:SendLog(_source, "RZEZNIK: Próba przerabiania kurczaków bez pracy!", 'anticheat', '15844367')
        end
    else
        TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to collect item without token (Prace legalne)")
        --exports['exile_logs']:SendLog(_source, "RZEZNIK: Próba przerabiania kurczaków bez prawidlowego tokenu! EVENT: exile:cafe:Transfering", 'anticheat', '15844367')
    end
end)



Paycheck = function(job, xPlayer)
	local total = nil
	if job == 'slaughter' then
		if xPlayer.job.grade == 9 then
			total = 45000
		elseif xPlayer.job.grade == 8 then
			total = 43200
		elseif xPlayer.job.grade == 7 then
			total = 41600
		elseif xPlayer.job.grade == 6 then
			total = 39900
		elseif xPlayer.job.grade == 5 then
            total = 38300
        elseif xPlayer.job.grade == 4 then
            total = 36600
        elseif xPlayer.job.grade == 3 then
            total = 35000
        elseif xPlayer.job.grade == 2 then
            total = 33400
        elseif xPlayer.job.grade == 1 then
			total = 31700
		elseif xPlayer.job.grade == 0 then
            total = 30000
		end
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..job, function(account)
			if account then
				xPlayer.addMoney(total)
				account.removeAccountMoney(total)
				xPlayer.showNotification('Otrzymano ~g~'..total..'$ ~s~za dostarczenie kurczaków.')
                xPlayer.addInventoryItem('gwiazdki', 7)
                xPlayer.showNotification('Otrzymano 7x Jajko Wielkanocne')
				exports['exile_logs']:SendLog(xPlayer.source, "RZEZNIK: Zakończono kurs. Zarobek: " ..total.. "$", 'slaughter', '15844367')
			else
				xPlayer.addMoney(total)
				xPlayer.showNotification('Otrzymano ~g~'..total..'$ ~s~za dostarczenie kurczaków.')
                xPlayer.addInventoryItem('gwiazdki', 7)
                xPlayer.showNotification('Otrzymano 7x Jajko Wielkanocne')
				exports['exile_logs']:SendLog(xPlayer.source, "RZEZNIK: Zakończono kurs. Zarobek: " ..total.. "$", 'slaughter', '15844367')
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
        local reward = 1000
        local total = count * reward
        if xPlayer.job.name == 'slaughter' then
            if toPocket then
                local playerMoney  = ESX.Math.Round(total)
                xPlayer.removeInventoryItem('packaged_chicken', count)
                xPlayer.addMoney(playerMoney)
                TriggerClientEvent('esx:showNotification', _source, 'Otrzymano ~g~'..playerMoney..'$ ~s~za sprzedaż kurczaków.')
                exports['exile_logs']:SendLog(xPlayer.source, "RZEZNIK: Zakończono kurs. Zarobek: " .. playerMoney .. "$", 'slaughter', '9807270')
            else
                TriggerEvent('esx_addonaccount:getSharedAccount', 'society_slaughter', function(account)
                    local societyMoney = ESX.Math.Round(total)  
                    xPlayer.removeInventoryItem('packaged_chicken', count)  
                    account.addAccountMoney(societyMoney)
                    TriggerClientEvent('esx:showNotification', _source, 'Firma zarobiła ~g~'..societyMoney..'$ ~s~za sprzedaż kurczaków.')
                    exports['exile_logs']:SendLog(_source, "RZEZNIK: Zakończono kurs. Sprzedano x" ..count.. " kurczaków. Zarobek: " .. societyMoney .. "$", 'slaughter', '9807270')
                end)
            end
        else
            TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to add money without job (Prace legalne)")
            --exports['exile_logs']:SendLog(_source, "RZEZNIK: Próba dodania pieniędzy bez pracy!", 'anticheat', '15844367')
        end
    else
        TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to add money with wrong token (Prace legalne)")
		--exports['exile_logs']:SendLog(_source, "RZEZNIK: Próba dodania kasy bez prawidlowego tokenu! EVENT: exile_rzeznik:SellCoffee", 'anticheat', '15844367')
	end
end)

RegisterServerEvent('exile_rzeznik:stopPickup')
AddEventHandler('exile_rzeznik:stopPickup', function(zone)
	local _source = source
	PlayersHarvesting[_source] = nil
end)

RegisterServerEvent('exile_rzeznik:request')
AddEventHandler('exile_rzeznik:request', function()
	if not recived_token_cofe[source] then
		TriggerClientEvent("exile_rzeznik:getrequest", source, SERVER_TOKEN, TRIGGER_SELL, TRIGGER_TRANSFERING, TIRGGER_COLLECT)
		recived_token_cofe[source] = true
	else
        TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to get token (Prace legalne)")
		--exports['exile_logs']:SendLog(source, "RZEZNIK: Próba otrzymania ponownie tokenu!", 'anticheat', '15844367')
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
RegisterServerEvent('exile_rzeznik:insertPlayer')
AddEventHandler('exile_rzeznik:insertPlayer', function(tablice)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local insertLabel = GetPlayerName(_source)..' ['..xPlayer.character.firstname ..' '.. xPlayer.character.lastname..'] '..os.date("%H:%M:%S")
	table.insert(SmiecieSiedzace, {label = insertLabel, plate = tablice})
end)

ESX.RegisterServerCallback('exile_rzeznik:checkSiedzacy', function(source, cb)
	cb(SmiecieSiedzace)
end)
