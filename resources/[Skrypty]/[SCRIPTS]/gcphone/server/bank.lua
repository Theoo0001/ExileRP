local ESX = nil

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) 
    ESX = obj 
end)

RegisterServerEvent('csskrouble:przelew', function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer.source ~= 0 then
        local amount = tonumber(data.amount)
        local id = tonumber(data.id)
        if amount and id then
            local bankMoney = xPlayer.getAccount('bank').money
            if bankMoney >= amount then
                local contest = "Przelew przez telefon"
                MySQL.Async.fetchAll('SELECT accounts, identifier, digit, phone_number FROM users WHERE account_number = ?', {id}, function(result)
                    if result[1] ~= nil then
                        if result[1].identifier == xPlayer.identifier then
                        --if false then
                            xPlayer.showNotification('~r~Nie możesz przelać pieniędzy sam sobie')
                        else
                            local moneyTable = json.decode(result[1].accounts)
                            local currentBank = moneyTable.bank
                            local tPlayer = ESX.GetPlayerFromIdentifier(result[1].identifier)
                            xPlayer.removeAccountMoney('bank', tonumber(amount))
                            string = xPlayer.character.firstname .. ' ' .. xPlayer.character.lastname
                            MySQL.Async.execute("INSERT INTO `bank_transfers` (`from`, `from_label`, `to`, `to_digit`, `title`, `money`) VALUES (@fromI, @fromL, @receiver, @receiverD, @title, @moneyA)", {
                                ['@fromI'] = xPlayer.identifier,
                                ['@fromL'] = string,
                                ['@receiver'] = result[1].identifier,
                                ['@receiverD'] = result[1].digit,
                                ['@title'] = "Przelew przez telefon",
                                ['@moneyA'] = tonumber(amount)
                            })
                            if tPlayer then
                                tPlayer.showNotification('~y~Otrzymałeś przelew~w~ na kwotę ~g~' .. amount .. '$ ~w~od ~y~' .. string .. ' ~w~o treści ~y~'..contest)
                                tPlayer.addAccountMoney('bank', tonumber(amount))
                            else
                                MySQL.Async.execute('UPDATE users SET accounts = JSON_SET(accounts, "$.bank", @newBank) WHERE identifier = @identifier',
                                {
                                    ['@identifier'] = result[1].identifier,
                                    ['@newBank'] = currentBank + amount
                                })
                                MySQL.Async.execute('INSERT INTO phone_messages (`transmitter`, `receiver`,`message`, `isRead`,`owner`) VALUES (@transmitter, @receiver, @message, @isRead, @owner);',
                                {
                                    ['@transmitter'] = 'Bank',
                                    ['@receiver'] = result[1].phone_number,
                                    ['@message'] = 'Otrzymałeś przelew na kwotę ' .. amount .. '$ od ' .. string .. ' o treści '..contest,
                                    ['@isRead'] = 0,
                                    ['@owner'] = 0
                                })
                            end
                            xPlayer.showNotification('~y~Wysłałeś przelew~w~ na kwotę ~g~' .. amount .. '$')
                            exports['exile_logs']:SendLog(src, "Przelano pieniądze do gracza [" .. result[1].identifier .. "] w wysokości " .. amount .. "$", 'money')
                        end
                    else
                        xPlayer.showNotification("~r~Taki numer konta nie istnieje bądź jest nieaktywny")
                    end
                end)
            else
                xPlayer.showNotification("~r~Nie stać Cie na zrobienie tego przelewu")
            end    
        else
            xPlayer.showNotification("~r~Błędne dane w przelewie")
        end    
    end
    --data.amount,data.id
end)