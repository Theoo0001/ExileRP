ESX                = nil

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

local SERVER_TOKEN = "ExileSecurity"..math.random(9999,999999999999)

local TRIGGER_SELL = "exile_weazel:sellNewspaper"..math.random(99999,999999999999)

RegisterNetEvent('Cam:ToggleCam')
AddEventHandler('Cam:ToggleCam', function()
    local src = source
    TriggerClientEvent("Cam:ToggleCam", src)
end)

RegisterNetEvent('Mic:ToggleBMic')
AddEventHandler('Mic:ToggleBMic', function()
    local src = source
    TriggerClientEvent("Mic:ToggleBMic", src)
end)

RegisterNetEvent('Mic:ToggleMic')
AddEventHandler('Mic:ToggleMic', function()
    local src = source
    TriggerClientEvent("Mic:ToggleMic", src)
end)

RegisterNetEvent('exile_weazel:giveItem')
AddEventHandler('exile_weazel:giveItem', function(itemName, itemCount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xItem = xPlayer.getInventoryItem(itemName)

    local countToAdd = itemCount

    if itemName == 'photos' then
        if xItem.count >= xItem.limit then
            xPlayer.showNotification('~r~Nie uniesiesz więcej zdjęć!')
            return
        elseif xItem.limit ~= -1 and (xItem.count + itemCount) > 100 then
            countToAdd = 100-xItem.count
        end
    else
        TriggerEvent("csskrouble:banPlr", "nigger", source, string.format("Tried to give item %s (Prace legalne)", itemName))
        --exports['exile_logs']:SendLog(_source, "WEAZEL: Próba zrespienia itemu!", 'anticheat', '15844367')
    end

    xPlayer.addInventoryItem(xItem.name, countToAdd)
end)

ESX.RegisterServerCallback('exile_weazel:changeToAnother', function(source, cb, itemBeforeName, itemAfterName, countBefore)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItemBefore = xPlayer.getInventoryItem(itemBeforeName)
	local xItemAfter = xPlayer.getInventoryItem(itemAfterName)

	local itemCount = math.floor((countBefore / 5))

	if (countBefore - itemCount) <= 0 then
		xPlayer.setInventoryItem(xItemBefore.name, 0)
	else
		xPlayer.removeInventoryItem(xItemBefore.name, countBefore)
	end

	if (xItemAfter.count + itemCount) > xItemAfter.limit then
		xPlayer.setInventoryItem(xItemAfter.name, xItemAfter.limit)
	else
		xPlayer.addInventoryItem(xItemAfter.name, itemCount)
	end

	cb(itemCount)
end)

RegisterNetEvent(TRIGGER_SELL)
AddEventHandler(TRIGGER_SELL, function(token)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if token == SERVER_TOKEN then
        local xItem = xPlayer.getInventoryItem('gazeta')
        local reward = 1200
        local total = xItem.count * reward
        if xItem.count == 20 then
            if xPlayer.job.name == 'weazel' then
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
                if total < 45000 then
                    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_weazel', function(account)
                        if account then
                            xPlayer.removeInventoryItem('gazeta', xItem.count)
                            local playerMoney  = ESX.Math.Round(total)
                            local societyMoney = ESX.Math.Round(total / 100 * 30)    
                            xPlayer.addMoney(playerMoney)
                            account.addAccountMoney(societyMoney)
                            TriggerClientEvent('esx:showNotification', _source, 'Otrzymano ~g~'..playerMoney..'$ ~s~za sprzedaż gazet.')
                            xPlayer.addInventoryItem('gwiazdki', 6)
                            xPlayer.showNotification('Otrzymano 6x Jajko Wielkanocne')
                            exports['exile_logs']:SendLog(_source, "WEAZEL NEWS: Zakończono kurs. Sprzedano x" ..xItem.count.. " gazet. Zarobek: " .. playerMoney .. "$", 'weazel', '15844367')
                        else
                            xPlayer.removeInventoryItem('gazeta', xItem.count)
                            xPlayer.addMoney(total)
                            TriggerClientEvent('esx:showNotification', _source, 'Otrzymano ~g~'..total..'$ ~s~za sprzedaż gazet.')
                            xPlayer.addInventoryItem('gwiazdki', 6)
                            xPlayer.showNotification('Otrzymano 6x Jajko Wielkanocne')
                            exports['exile_logs']:SendLog(_source, "WEAZEL NEWS: Zakończono kurs. Sprzedano x" ..xItem.count.. " gazet. Zarobek: " .. total .. "$", 'weazel', '15844367')
                        end
                    end)
                    if xItem.count >= 20 then
                        TriggerEvent('ExileRP:saveCours', xPlayer.job.name, xPlayer.job.grade, xPlayer.source)
                    end
                else
                    TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to add money (Prace legalne)")
                    --exports['exile_logs']:SendLog(_source, "WEAZEL NEWS: Próba zarobienia wiecej siana niz 45k!", 'anticheat', '15844367')
                end
            end
        else
            TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to add money without job (Prace legalne)")
            --exports['exile_logs']:SendLog(_source, "WEAZEL NEWS: Próba dodania pieniędzy bez pracy!", 'anticheat', '15844367')
        end
    else
        TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to add money without a token (Prace legalne)")
        --exports['exile_logs']:SendLog(_source, "WEAZEL NEWS: Próba dodania pieniędzy bez tokenu!", 'anticheat', '15844367')
    end
end)

local recived_token_weazel = {}
RegisterServerEvent('exile_weazel:request')
AddEventHandler('exile_weazel:request', function()
	if not recived_token_weazel[source] then
		TriggerClientEvent("exile_weazel:getrequest", source, SERVER_TOKEN, TRIGGER_SELL)
		recived_token_weazel[source] = true
	else
        TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to get token (Prace legalne)")
		--exports['exile_logs']:SendLog(source, "WEAZEL NEWS: Próba otrzymania ponownie tokenu!", 'anticheat', '15844367')
	end
end)

AddEventHandler('playerDropped', function()
    recived_token_weazel[source] = nil
end)

local SmiecieSiedzace = {}
RegisterServerEvent('exile_weazel:insertPlayer')
AddEventHandler('exile_weazel:insertPlayer', function(tablice)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local insertLabel = GetPlayerName(_source)..' ['..xPlayer.character.firstname ..' '.. xPlayer.character.lastname..'] '..os.date("%H:%M:%S")
	table.insert(SmiecieSiedzace, {label = insertLabel, plate = tablice})
end)

ESX.RegisterServerCallback('exile_weazel:checkSiedzacy', function(source, cb)
	cb(SmiecieSiedzace)
end)

