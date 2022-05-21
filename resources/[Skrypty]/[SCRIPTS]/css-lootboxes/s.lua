ESX	= nil
TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

local OpeningCase = {}

function RemoveOpening(id)
    for i,v in ipairs(OpeningCase) do
        if v.id == id then
            table.remove(OpeningCase, i)
        end    
    end    
end

function CheckOpening(id) 
    local opening = false
    for i,v in ipairs(OpeningCase) do
        if v.id == id then
            opening = true
            break
        end    
    end 
    return opening  
end

ESX.RegisterUsableItem('dailycase', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	table.insert(OpeningCase, {id=source})
    TriggerClientEvent("csskrouble:openCase", source)
    TriggerClientEvent('esx:showNotification', source, 'Otworzyłeś ~g~Daily Case!')
	xPlayer.removeInventoryItem('dailycase', 1)
end)

RegisterServerEvent("csskrouble:lootWin", function(win) 
    local zz = json.decode(win)
    local src = source
    local z = CheckOpening(src)
    if z then
        RemoveOpening(src)
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer and xPlayer.source ~= false and xPlayer.source ~= 0 then
            if zz.iType == "item" then
                TriggerClientEvent("esx:showNotification", src, "~w~Wygrałeś ~g~"..zz.name)
                xPlayer.addInventoryItem(zz.item, zz.amount)
            elseif zz.iType == "money" then
                TriggerClientEvent("esx:showNotification", src, "~w~Wygrałeś ~g~"..zz.name)
                xPlayer.addMoney(zz.amount)
            end    
        end    
    else
        TriggerEvent("csskrouble:banPlr", "nigger", _source, "Tried to add items with win trigger (css_lootboxes)")
        --exports['exile_logs']:SendLog(src, string.format("Próbował dodać sobie itemki przy pomocy triggera: %s (%s)", zz.item, zz.iType), 'anticheat', 0xFF0000)
    end   
end)