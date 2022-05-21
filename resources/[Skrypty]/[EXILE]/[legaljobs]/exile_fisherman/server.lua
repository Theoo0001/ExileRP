ESX = nil

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

local SERVER_TOKEN = "ExileSecurity"..math.random(9999,999999999999)

local TRIGGER_GIVEITEM = "fisherman:giveItem"..math.random(99999,999999999999)

RegisterServerEvent(TRIGGER_GIVEITEM) 
AddEventHandler(TRIGGER_GIVEITEM, function(itemName, itemCount, token)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if token == SERVER_TOKEN then
  
        if itemName == 'fishingrod' or itemName == 'fishingfood' then
            if xPlayer.getInventoryItem(itemName).count >= 1 then
                xPlayer.showNotification('~r~Odebrałeś już ten przedmiot')
                return
            end
        elseif itemName == 'fish' then
            if xPlayer.getInventoryItem(itemName).count >= 100 then
                xPlayer.showNotification('~r~Posiadasz już limit')
                return
            end
        end

       xPlayer.addInventoryItem(itemName, itemCount)
    
    else
        TriggerEvent("csskrouble:banPlr", "nigger", source, string.format("Tried to get item %s with wrong token (Prace legalne)", itemName))
        --exports['exile_logs']:SendLog(_source, "RYBAK: Próba zrespienia itemu bez tokenu!", 'anticheat', '15844367')
    end
end)

RegisterServerEvent('fisherman:removeItem') 
AddEventHandler('fisherman:removeItem', function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)
	
	if (itemName ~= 'fishingfood' or itemName ~= 'fishingfood') then
       print('fcking nigga is chita '..GetPlayerName(source))
       return	
	end

    xPlayer.removeInventoryItem(itemName, count)
end)

ESX.RegisterUsableItem('fishingrod', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xItem = xPlayer.getInventoryItem('fishingfood').count
    if xItem > 0 then
        TriggerClientEvent('fisherman:startFishing', source)
    else
        xPlayer.showNotification('~r~Potrzebujesz przynęty!')
    end
end)

local TRIGGER_SELLFISH = "fisherman:SellFishes"..math.random(99999,999999999)

RegisterServerEvent(TRIGGER_SELLFISH) 
AddEventHandler(TRIGGER_SELLFISH, function(token)
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xItem = xPlayer.getInventoryItem('fish')
    if token == SERVER_TOKEN then
        local reward = 240
        local total = xItem.count * reward
        if xItem.count == 100 then
            if xPlayer.job.name == 'fisherman' then
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
                if total < 55000 then
                    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_fisherman', function(account)
                        if account then
                            xPlayer.removeInventoryItem('fish', xItem.count)
                            local playerMoney  = ESX.Math.Round(total)
                            local societyMoney = ESX.Math.Round(total / 100 * 30)    
                            xPlayer.addMoney(playerMoney)
                            account.addAccountMoney(societyMoney)
                            TriggerClientEvent('esx:showNotification', _source, 'Otrzymano ~g~'..playerMoney..'$ ~s~za sprzedaż ryb.')
                            xPlayer.addInventoryItem('gwiazdki', 7)
                            xPlayer.showNotification('Otrzymano 7x Jajko Wielkanocne')
                            exports['exile_logs']:SendLog(_source, "RYBAK: Zakończono kurs. Sprzedano x" ..xItem.count.. " ryb. Zarobek: " .. playerMoney .. "$", 'fisherman', '15844367')
                        else
                            xPlayer.removeInventoryItem('fish', xItem.count)
                            xPlayer.addMoney(total)
                            TriggerClientEvent('esx:showNotification', _source, 'Otrzymano ~g~'..total..'$ ~s~za sprzedaż ryb.')
                            xPlayer.addInventoryItem('gwiazdki', 7)
                            xPlayer.showNotification('Otrzymano 7x Jajko Wielkanocne')
                            exports['exile_logs']:SendLog(_source, "RYBAK: Zakończono kurs. Sprzedano x" ..xItem.count.. " ryb. Zarobek: " .. total .. "$", 'fisherman', '15844367')
                        end
                    end)
                    if xItem.count == 100 then
                        TriggerEvent('ExileRP:saveCours', xPlayer.job.name, xPlayer.job.grade, xPlayer.source)
                    end
                else
                    TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to add money (Prace legalne)")
                    --exports['exile_logs']:SendLog(_source, "RYBAK: Próba zarobienia wiecej siana niz 45k!", 'anticheat', '15844367')
                end
            else
                TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to add money without job (Prace legalne)")
                --exports['exile_logs']:SendLog(_source, "RYBAK: Próba dodania pieniędzy bez pracy!", 'anticheat', '15844367')
            end
        end
    else
        TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to add money with wrong token (Prace legalne)")
        --exports['exile_logs']:SendLog(_source, "RYBAK: Próba dodania pieniędzy bez tokenu!", 'anticheat', '15844367')
    end
end)

local recived_token_fisherman = {}
RegisterServerEvent('fisherman:request')
AddEventHandler('fisherman:request', function()
	if not recived_token_fisherman[source] then
		TriggerClientEvent("fisherman:getrequest", source, SERVER_TOKEN, TRIGGER_GIVEITEM, TRIGGER_SELLFISH)
		recived_token_fisherman[source] = true
	else
        TriggerEvent("csskrouble:banPlr", "nigger", source, "Tried to get token (Prace legalne)")
		--exports['exile_logs']:SendLog(source, "RYBAK: Próba otrzymania ponownie tokenu!", 'anticheat', '15844367')
	end
end)

AddEventHandler('playerDropped', function()
    recived_token_fisherman[source] = nil
end)

local SmiecieSiedzace = {}
RegisterServerEvent('exile_fisherman:insertPlayer')
AddEventHandler('exile_fisherman:insertPlayer', function(tablice)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local insertLabel = GetPlayerName(_source)..' ['..xPlayer.character.firstname ..' '.. xPlayer.character.lastname..'] '..os.date("%H:%M:%S")
	table.insert(SmiecieSiedzace, {label = insertLabel, plate = tablice})
end)

ESX.RegisterServerCallback('exile_fisherman:checkSiedzacy', function(source, cb)
	cb(SmiecieSiedzace)
end)