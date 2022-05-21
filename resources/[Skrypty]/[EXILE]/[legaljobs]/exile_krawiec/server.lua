ESX = nil

local PlayersHarvesting		   = {}
local PlayersTransforming	   = {}
local PlayersSelling	   	   = {}
local recived_token_cofe = {}

local TRIGGER_SELL = "exile_krawiec:SellCoffee"..math.random(9999,999999)
local TRIGGER_TRANSFERING = "exile_krawiec:Transfering"..math.random(9999,999999)
local SERVER_TOKEN = "ExileSecurity"..math.random(9999,999999999999)

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

local function Harvest(source, name)
	SetTimeout(60000, function()
		if PlayersHarvesting[source] == true then
			local xPlayer  = ESX.GetPlayerFromId(source)
            local item = xPlayer.getInventoryItem(name)
			if item.limit ~= -1 and item.count >= item.limit then
                TriggerClientEvent('esx:showNotification', source, 'Nie uniesiesz więcej ~y~'..item.label)
                TriggerClientEvent('exile_krawiec:Cancel', source)
			else
				xPlayer.addInventoryItem(name, 20)
				Harvest(source, name)
			end
		else
			return
		end
	end)
end

function SalaryCheck(grade)
    if grade == 9 then
        return true
    else
        return false
    end
end

RegisterServerEvent('exile_krawiec:collect')
AddEventHandler('exile_krawiec:collect', function(name)
	local _source = source
    if name == "material_krawiec" then
        local xPlayer  = ESX.GetPlayerFromId(source)
        if xPlayer.getInventoryItem('ubrania_krawiec').count == 0 then
            PlayersHarvesting[_source] = true
            TriggerClientEvent('esx:showNotification', _source, '~y~Trwa zbieranie materiału...')
            Harvest(_source, name)
        else
            TriggerClientEvent('esx:showNotification', _source, '~r~Nie możesz zbierać materiału posiadając ubrania!')
        end
    else
        TriggerEvent("csskrouble:banPlr", "nigger", source, string.format("Tried to get item %s (Prace legalne)", name))
        --exports['exile_logs']:SendLog(_source, "KRAWIEC: Próba zbieranie innego itemu niz material!", 'anticheat', '15844367')
    end
end)

RegisterServerEvent(TRIGGER_TRANSFERING)
AddEventHandler(TRIGGER_TRANSFERING, function(countBefore, token)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if SERVER_TOKEN == token then
        if xPlayer.job.name == 'krawiec' then
            if xPlayer.getInventoryItem('ubrania_krawiec').count == 0 then
                if countBefore >= 100 then
                    local itemCount = math.floor((countBefore / 10))
                    xPlayer.removeInventoryItem('material_krawiec', itemCount * 10)
                    xPlayer.addInventoryItem('ubrania_krawiec', itemCount)
                    --TriggerEvent('exile:addItemToStock', _source, 'item_standard', 'ubrania_krawiec', itemCount, 'society_'..xPlayer.job.name)
                    -- if itemCount >= 10 then
                    --     TriggerEvent('ExileRP:saveCours', xPlayer.job.name, xPlayer.job.grade, xPlayer.source)
                    -- end
                else
                    TriggerClientEvent('esx:showNotification', _source, '~r~Niezła próba oszustwa :)')
                    exports['exile_logs']:SendLog(_source, "KRAWIEC OSTRZEŻENIE: Próba zbugowania przeróbki!", 'anticheat', '15844367')
                end
            else
                TriggerClientEvent('esx:showNotification', _source, '~r~Nie możesz przerabiać materiału posiadając ubrania!')
            end
        else
            TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to collect item without job (Prace legalne)")
            --exports['exile_logs']:SendLog(_source, "KRAWIEC: Próba przerabiania ziaren bez pracy!", 'anticheat', '15844367')
        end
    else
        TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to collect item with wrong token (Prace legalne)")
        --exports['exile_logs']:SendLog(_source, "KRAWIEC: Próba przerabiania ziaren bez prawidlowego tokenu! EVENT: exile:krawiec:Transfering", 'anticheat', '15844367')
    end
end)

RegisterServerEvent(TRIGGER_SELL) 
AddEventHandler(TRIGGER_SELL, function(count, token)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if SERVER_TOKEN == token then
        local toPocket = SalaryCheck(xPlayer.job.grade)
        local reward = 2000
        local total = count * reward
        local clothesC = xPlayer.getInventoryItem('ubrania_krawiec').count
        if xPlayer.job.grade == 9 then
            total = total * 1.50
        elseif xPlayer.job.grade == 8 then
            total = total * 1.44
        elseif xPlayer.job.grade == 7 then
            total = total * 1.38
        elseif xPlayer.job.grade == 6 then
            total = total * 1.33
        elseif xPlayer.job.grade == 5 then
            total = total * 1.27
        elseif xPlayer.job.grade == 4 then
            total = total * 1.22
        elseif xPlayer.job.grade == 3 then
            total = total * 1.16
        elseif xPlayer.job.grade == 2 then
            total = total * 1.11
        elseif xPlayer.job.grade == 1 then
            total = total * 1.05
        end 
        if xPlayer.job.name == 'krawiec' then
            if clothesC == 10 then
                if xPlayer.job.grade >= 7 then
                    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_krawiec', function(account)
                        local playerMoney  = ESX.Math.Round(total)
                        local societyMoney = ESX.Math.Round(total / 100 * 30)
                        xPlayer.removeInventoryItem('ubrania_krawiec', count)
                        xPlayer.addMoney(playerMoney)
                        account.addAccountMoney(societyMoney)
                        TriggerClientEvent('esx:showNotification', _source, 'Otrzymano ~g~'..playerMoney..'$ ~s~za sprzedaż ubrań.\nFirma zarobiła ~g~'..societyMoney..'$~s~')
                        xPlayer.addInventoryItem('gwiazdki', 5)
                        xPlayer.showNotification('Otrzymano 5x Jajko Wielkanocne')
                        exports['exile_logs']:SendLog(xPlayer.source, "KRAWIEC: Zakończono kurs. Zarobek: " .. playerMoney .. "$", 'krawiec', '9807270')
                    end)
                else
                    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_krawiec', function(account)
                        local playerMoney  = ESX.Math.Round(total)
                        local societyMoney = ESX.Math.Round(total / 100 * 20)
                        xPlayer.removeInventoryItem('ubrania_krawiec', count)
                        xPlayer.addMoney(playerMoney)
                        account.addAccountMoney(societyMoney)
                        TriggerClientEvent('esx:showNotification', _source, 'Otrzymano ~g~'..playerMoney..'$ ~s~za sprzedaż ubrań.')
                        xPlayer.addInventoryItem('gwiazdki', 7)
                        xPlayer.showNotification('Otrzymano 7x Jajko Wielkanocne')
                        exports['exile_logs']:SendLog(xPlayer.source, "KRAWIEC: Zakończono kurs. Zarobek: " .. playerMoney .. "$", 'krawiec', '9807270')
                    end)
                end

                if clothesC == 10 then
                    TriggerEvent('ExileRP:saveCours', xPlayer.job.name, xPlayer.job.grade, xPlayer.source)
                end
            else
                TriggerClientEvent('esx:showNotification', _source, '~r~Posiadając wiecej niż 10 ubrań nie sprzedasz ich :*')
            end
        else
            TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to add money without job (Prace legalne)")
            --exports['exile_logs']:SendLog(_source, "KRAWIEC: Próba dodania pieniędzy bez pracy!", 'anticheat', '15844367')
        end
    else
        TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to add money with wrong token (Prace legalne)")
		--exports['exile_logs']:SendLog(_source, "KRAWIEC: Próba dodania kasy bez prawidlowego tokenu! EVENT: exile_krawiec:SellCoffee", 'anticheat', '15844367')
	end
end)

RegisterServerEvent('exile_krawiec:stopPickup')
AddEventHandler('exile_krawiec:stopPickup', function(zone)
	local _source = source
	PlayersHarvesting[_source] = nil
end)

RegisterServerEvent('exile_krawiec:request')
AddEventHandler('exile_krawiec:request', function()
	if not recived_token_cofe[source] then
		TriggerClientEvent("exile_krawiec:getrequest", source, SERVER_TOKEN, TRIGGER_SELL, TRIGGER_TRANSFERING)
		recived_token_cofe[source] = true
	else
        TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to get token (Prace legalne)")
		--exports['exile_logs']:SendLog(source, "KRAWIEC: Próba otrzymania ponownie tokenu!", 'anticheat', '15844367')
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
RegisterServerEvent('exile_krawiec:insertPlayer')
AddEventHandler('exile_krawiec:insertPlayer', function(tablice)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local insertLabel = GetPlayerName(_source)..' ['..xPlayer.character.firstname ..' '.. xPlayer.character.lastname..'] '..os.date("%H:%M:%S")
	table.insert(SmiecieSiedzace, {label = insertLabel, plate = tablice})
end)

ESX.RegisterServerCallback('exile_krawiec:checkSiedzacy', function(source, cb)
	cb(SmiecieSiedzace)
end)