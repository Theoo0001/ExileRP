ESX = nil 

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end) 

local event = 'exilewypierz'..math.random(1111111,9999999)

local recived_token = {}

RegisterServerEvent('exile_pralnia:request')
AddEventHandler('exile_pralnia:request', function()
	if not recived_token[source] then
		TriggerClientEvent("exile_pralnia:getrequest", source, event)
		recived_token[source] = true
	else
        TriggerEvent('csskrouble:banPlr', "nigger", source, "Tried to get token (exile_pralnia)")
		--exports['exile_logs']:SendLog(source, "PRALNIA: Próba otrzymania ponownie tokenu!", 'anticheat', '15844367')
	end
end)

AddEventHandler('playerDropped', function()
    recived_token[source] = nil
end)

RegisterServerEvent(event)
AddEventHandler(event, function(resourceName)
    if resourceName == GetCurrentResourceName() then
        local xPlayer = ESX.GetPlayerFromId(source)
        local brudna = xPlayer.getAccount('black_money').money
        if brudna >= Config.MinBrud then
            local random = Config.Reward
            xPlayer.addMoney(random)
            xPlayer.removeAccountMoney('black_money',random)
            exports['exile_logs']:SendLog(source, "PRALNIA: Chłop przeprał siano i dostał: " ..random, 'pralnia', '15844367')
            TriggerClientEvent('esx:showAdvancedNotification', source, 'Lester', '~r~Pranie brudnej gotówki','Wyprałeś ~g~$'..random.."~s~ ~r~brudnej gotówki")
        else
            TriggerClientEvent('esx:showNotification', source, '~r~Nie posiadasz conajmniej ~g~$'..Config.MinBrud..'~r~ brudnej gotówki')
        end
    end
end)

ESX.RegisterServerCallback('exile_pralnia:maBrud', function(source,cb) 
    local xPlayer = ESX.GetPlayerFromId(source)
    local brudna = xPlayer.getAccount('black_money').money
    if brudna >= Config.MinBrud then
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent('exile_pralnia:alert')
AddEventHandler('exile_pralnia:alert', function(coords)
    local xPlayers = ESX.GetExtendedPlayers('job', 'police')
    for _, xPlayer in ipairs(xPlayers) do        
        TriggerClientEvent("exile_pralnia:alert", xPlayer.source, coords)
    end
end)