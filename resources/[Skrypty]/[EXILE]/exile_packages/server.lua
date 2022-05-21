ESX = nil
TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj)
    ESX = obj
end)

RegisterServerEvent('exile_packages:showNotification')
AddEventHandler('exile_packages:showNotification', function(item, count, type)
    local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)
    local itemLabel = nil
    local xcount = nil

    if type == 'item_standard' then
		local sourceItem = xPlayer.getInventoryItem(item)

		if count > 0 and sourceItem.count >= count then
			xPlayer.removeInventoryItem(item, count)
            xcount = count and 'x' .. count

            xPlayer.showNotification('Spakowano ~b~' .. sourceItem.label .. ' ' .. xcount .. '~w~ do paczki')
		end
    elseif type == 'item_weapon' then
        if xPlayer.hasWeapon(item) then
            local weaponLabel = ESX.GetWeaponLabel(item)

            local _, weapon = xPlayer.getWeapon(item)
            local _, weaponObject = ESX.GetWeapon(item)

            if count > 0 then
                count = count
            else
                count = 1
            end

            xPlayer.removeWeapon(item, count)

            if weaponObject.ammo and count > 0 then
                local ammoLabel = weaponObject.ammo.label
                xPlayer.showNotification('Spakowano ~b~' .. weaponLabel .. ' [' .. count .. ']~w~ do paczki')
            else
                xPlayer.showNotification('Spakowano ~b~' .. weaponLabel .. ' ~w~ do paczki')
            end
        end
    end
end)

RegisterServerEvent('exile_packages:addDelivery')
AddEventHandler('exile_packages:addDelivery', function(deliveryPrice, price, phoneNumber, id, method, allItems, lockerLabel, title, targetLocker)
    local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)
    local _target = getIdentifierByPhoneNumber(tonumber(phoneNumber))
    local tPlayer = ESX.GetPlayerFromIdentifier(_target)
    local str = nil

    if xPlayer.getMoney() >= deliveryPrice then
        xPlayer.removeAccountMoney('money', deliveryPrice)
    else
        xPlayer.showNotification('~r~Potrzebujesz ' .. deliveryPrice .. '$, aby wysłać paczkę.')
        TriggerClientEvent('exile_packages:removeList', _source, allItems)
        return
    end

    local code = GenerateCode()

    str = 'Twoja paczka właśnie dotarła, znajduje się ona w ' .. lockerLabel .. '. Tytuł przesyłki: ' .. title .. '. Kod potrzebny do odbioru: ' .. code


    MySQL.Async.execute('INSERT INTO exile_packages (sender, senderDigit, receiver, targetid, price, title, lockerid, targetLockerid, method, code, items) VALUES (@sender, @senderDigit, @receiver, @targetid, @price, @title, @lockerid, @targetLockerid, @method, @code, @items)',
	{
		['@sender']   = xPlayer.identifier,
        ['@senderDigit']   = xPlayer.getDigit(),
		['@receiver']  = tonumber(phoneNumber),
        ['@targetid'] = tPlayer and tPlayer.identifier or _target,
		['@price'] = tonumber(price),
        ['@title'] = tostring(title),
		['@lockerid']  = tonumber(id),
        ['@targetLockerid'] = tonumber(targetLocker),
        ['@method'] = method,
        ['@code'] = code,
		['@items'] 	= json.encode(allItems)
	}, function(rowsChanged)
        xPlayer.showNotification('~g~Pomyślnie wysłano paczkę. Zapłacono za przesyłkę ' .. deliveryPrice .. '$')

		if tPlayer then
            TriggerEvent('gcPhone:_internalAddMessagexdxdtesttesttest', 'exilomaty', phoneNumber, str, 0, function (smsMess)
                TriggerClientEvent("gcPhone:receiveMessage", tPlayer.source, smsMess)
            end)
        else
            MySQL.Async.execute('INSERT INTO phone_messages (`transmitter`, `receiver`,`message`, `isRead`,`owner`) VALUES (@transmitter, @receiver, @message, @isRead, @owner);',
            {
                ['@transmitter'] = 'Exilomaty.eu',
                ['@receiver'] = tonumber(phoneNumber),
                ['@message'] = str,
                ['@isRead'] = 0,
                ['@owner'] = 0
            })
		end
	end)

    --exports['exile_logs']:SendLog(xPlayer.source, 'Wysłano paczkę, koszt wysyłki: **' .. deliveryPrice .. '**. Tytuł przesyłki **' .. title .. '**. Odbiorca: **' .. _target .. "**", 'paczkomaty')
end)

RegisterServerEvent('exile_packages:returnInventory')
AddEventHandler('exile_packages:returnInventory', function(packageList)
    local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)
    if packageList[1] ~= nil then
        local inventory = packageList
        xPlayer.showNotification('~r~Anulowano przesyłkę, oddano przedmioty z paczki')
        for i=1, #inventory, 1 do
            if inventory[i].type == 'item_standard' or inventory[i].type == 'item_weapon' then
                xPlayer.addInventoryItem(inventory[i].value, inventory[i].count)
                --exports['exile_logs']:SendLog(xPlayer.source, 'Oddano przedmioty: ' .. inventory[i].value .. ' x' .. inventory[i].count, 'paczkomaty')
            -- elseif inventory[i].type == 'item_weapon' then
                -- if not xPlayer.hasWeapon(inventory[i].value) then
                    -- local _, weapon = xPlayer.getWeapon(inventory[i].value)
                    -- local _, weaponObject = ESX.GetWeapon(inventory[i].value)
                    -- local itemCount = inventory[i].count

                    -- if itemCount ~= nil then
                        -- itemCount = itemCount
                    -- else
                        -- itemCount = 1
                    -- end

                    -- xPlayer.addWeapon(inventory[i].value, itemCount)
                   -- exports['exile_logs']:SendLog(xPlayer.source, 'Oddano broń: ' .. inventory[i].value .. ' x' .. itemCount, 'paczkomaty')
                end
            end
        end
    end
end)

RegisterServerEvent('exile_packages:cancelDelivery')
AddEventHandler('exile_packages:cancelDelivery', function(id, packageList, receiver)
    local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)
    local _target = getIdentifierByPhoneNumber(receiver)
    while _target == nil do
        Wait(100)
    end
    local tPlayer = ESX.GetPlayerFromIdentifier(_target)
    
    if tPlayer then
        xPlayer.showNotification('~r~Aby anulować wysyłkę, odbiorca musi iść spać')
        return
    else
        MySQL.Async.execute('INSERT INTO phone_messages (`transmitter`, `receiver`,`message`, `isRead`,`owner`) VALUES (@transmitter, @receiver, @message, @isRead, @owner);',
        {
            ['@transmitter'] = 'Exilomaty.eu',
            ['@receiver'] = tonumber(receiver),
            ['@message'] = 'Wysyłka Paczki #' .. id .. ' została anulowana przez nadawcę',
            ['@isRead'] = 0,
            ['@owner'] = 0
        })

        if packageList[1] ~= nil then
            local inventory = packageList
            xPlayer.showNotification('~g~Pomyślnie anulowano wysyłkę, zwrócono przedmioty z paczki')
            for i=1, #inventory, 1 do
                if inventory[i].type == 'item_standard' then
                    xPlayer.addInventoryItem(inventory[i].value, inventory[i].count)
                elseif inventory[i].type == 'item_weapon' then
                    if not xPlayer.hasWeapon(inventory[i].value) then
                        local _, weapon = xPlayer.getWeapon(inventory[i].value)
                        local _, weaponObject = ESX.GetWeapon(inventory[i].value)
                        local itemCount = inventory[i].count

                        if itemCount ~= nil then
                            itemCount = itemCount
                        else
                            itemCount = 1
                        end

                        xPlayer.addWeapon(inventory[i].value, itemCount)
                    end
                end
            end
            MySQL.Async.execute('DELETE FROM exile_packages WHERE sender = @sender AND id = @id', {
                ['@sender']  = xPlayer.identifier,
                ['@id'] = id,
            })
        end
    end
end)

RegisterServerEvent('exile_packages:returnPackage')
AddEventHandler('exile_packages:returnPackage', function(sender, id, packageList)
    local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)
    local tPlayer = ESX.GetPlayerFromIdentifier(sender)

    if tPlayer then
        if packageList[1] ~= nil then
            local inventory = packageList
            xPlayer.showNotification('~g~Pomyślnie zwrócono paczkę')
            tPlayer.showNotification('~g~Paczka #' .. id .. ' została zwrócona')
            for i=1, #inventory, 1 do
                if inventory[i].type == 'item_standard' then
                    tPlayer.addInventoryItem(inventory[i].value, inventory[i].count)
                elseif inventory[i].type == 'item_weapon' then
                    if not tPlayer.hasWeapon(inventory[i].value) then
                        local _, weapon = tPlayer.getWeapon(inventory[i].value)
                        local _, weaponObject = ESX.GetWeapon(inventory[i].value)
                        local itemCount = inventory[i].count

                        if itemCount ~= nil then
                            itemCount = itemCount
                        else
                            itemCount = 1
                        end

                        tPlayer.addWeapon(inventory[i].value, itemCount)
                    end
                end
            end
            MySQL.Async.execute('DELETE FROM exile_packages WHERE sender = @sender AND id = @id', {
                ['@sender']  = sender,
                ['@id'] = id,
            })
        end
    else
        xPlayer.showNotification('~r~Aby zwrócić paczkę, nadawca musi znajdować się na wyspie')
    end
end)

RegisterServerEvent('exile_packages:collectPackage')
AddEventHandler('exile_packages:collectPackage', function(code, id, method, price, sender)
    local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)
    local tPlayer = ESX.GetPlayerFromIdentifier(sender)
    local tPhone = getNumberPhone(sender)

    if method == 'cash' then
        if xPlayer.getMoney() >= tonumber(price) then
            xPlayer.removeAccountMoney('money', tonumber(price))
            if tPlayer then
                tPlayer.showNotification('~y~Otrzymałeś przelew~w~ na kwotę ~g~' .. price .. '$ ~w~za wysłaną ~y~paczkę')
				tPlayer.addAccountMoney('bank', tonumber(price))
            else
                MySQL.Async.fetchAll('SELECT accounts FROM users WHERE identifier = @identifier',
                {
                    ['@identifier'] = sender
                }, function(result)
                    if result[1] ~= nil then
                        local currentBank = json.decode(result[1].accounts).bank
                        MySQL.Async.execute('UPDATE users SET accounts = JSON_SET(accounts, "$.bank", @newBank) WHERE identifier = @identifier',
                        {
                            ['@identifier'] = sender,
                            ['@newBank'] = currentBank + price
                        })
                        MySQL.Async.execute('INSERT INTO phone_messages (`transmitter`, `receiver`,`message`, `isRead`,`owner`) VALUES (@transmitter, @receiver, @message, @isRead, @owner);',
                        {
                            ['@transmitter'] = 'Exilomaty.eu',
                            ['@receiver'] = tonumber(tPhone),
                            ['@message'] = 'Otrzymałeś przelew na kwotę ' .. price .. '$ za wysłaną paczkę',
                            ['@isRead'] = 0,
                            ['@owner'] = 0
                        })
                    end
                end)
            end
        else
            xPlayer.showNotification('~r~Potrzebujesz ' .. price .. '$, aby odebrać paczkę.')
            return
        end
    end

    xPlayer.showNotification('~g~Pomyślnie odebrano paczkę')
    MySQL.Async.fetchAll('SELECT items FROM exile_packages WHERE targetid = @targetid AND code = @code', {
        ['@targetid']  = xPlayer.identifier,
		['@code'] = code,
    }, function(data)
        if data[1] ~= nil then
            local inventory = json.decode(data[1].items)
            xPlayer.showNotification('~g~Pomyślnie odebrano paczkę')
            for i=1, #inventory, 1 do
                if inventory[i].type == 'item_standard' then
                    xPlayer.addInventoryItem(inventory[i].value, inventory[i].count)
                elseif inventory[i].type == 'item_weapon' then
                    if not xPlayer.hasWeapon(inventory[i].value) then
                        local _, weapon = xPlayer.getWeapon(inventory[i].value)
        				local _, weaponObject = ESX.GetWeapon(inventory[i].value)
                        local itemCount = inventory[i].count

                        if itemCount ~= nil then
        					itemCount = itemCount
        				else
        					itemCount = 1
        				end

                        xPlayer.addWeapon(inventory[i].value, itemCount)
                    else
                        xPlayer.showNotification('~r~Broń znajdującą się w paczkomacie posiadasz przy sobie, odłóż ją i odbierz paczkę ponownie!')
                        return
                    end
                end
            end
            MySQL.Async.execute('DELETE FROM exile_packages WHERE targetid = @targetid AND code = @code', {
                ['@targetid']  = xPlayer.identifier,
        		['@code'] = code,
            })
        end
    end)
end)

ESX.RegisterServerCallback('exile_packages:checkNumber', function(source, cb, phoneNumber)
    local checkNumber = getIdentifierByPhoneNumber(tonumber(phoneNumber))

    while checkNumber == nil do
        Wait(100)
    end

	if checkNumber then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('exile_packages:checkNigger', function(source, cb, phoneNumber)
    local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)
    local checkNumber = getIdentifierByPhoneNumber(tonumber(phoneNumber))

    while checkNumber == nil do
        Wait(100)
    end

    if checkNumber == xPlayer.identifier then
        cb(false)
    else
        cb(true)
    end
end)

ESX.RegisterServerCallback('exile_packages:checkLockers', function(source, cb, id)
    local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)
    local xNumber = getNumberPhone(xPlayer.identifier)
    local data = {}
    local itemsLabel = {}

    local result = MySQL.Sync.fetchAll('SELECT id, title, code, method, price, sender, items FROM exile_packages WHERE targetid = @targetid AND targetLockerid = @targetLockerid AND receiver = @receiver',
	{
		['@targetLockerid'] = id,
		['@targetid'] = xPlayer.identifier,
        ['@receiver'] = xNumber,
	})

    if result[1] ~= nil then
        for i=1, #result, 1 do
            table.insert(data, {
                id = result[i].id,
                title = result[i].title,
                code = result[i].code,
                method = result[i].method,
                price = result[i].price,
                sender = result[i].sender,
                items = json.decode(result[i].items)
            })
        end
        cb(data)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('exile_packages:checkDeliveries', function(source, cb)
    local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)
    local data = {}

    local result = MySQL.Sync.fetchAll('SELECT id, title, items, receiver FROM exile_packages WHERE sender = @sender AND senderDigit = @senderDigit',
	{
		['@sender'] = xPlayer.identifier,
		['@senderDigit'] = xPlayer.getDigit()
	})

    if result[1] ~= nil then
        for i=1, #result, 1 do
            table.insert(data, {
                id = result[i].id,
                title = result[i].title,
                items = json.decode(result[i].items),
                receiver = result[i].receiver
            })
        end
        cb(data)
    else
        cb(false)
    end
end)

GenerateCode = function()
    return tostring(math.random(111111,999999))
end

getIdentifierByPhoneNumber = function(phone_number)
    local result = MySQL.Sync.fetchAll("SELECT identifier FROM users WHERE number = @phone_number", {
        ['@phone_number'] = phone_number
    })
    if result[1] ~= nil then
        return result[1].identifier
    end
    return false
end

getNumberPhone = function(identifier)
    local result = MySQL.Sync.fetchAll("SELECT users.phone_number FROM users WHERE users.identifier = @identifier", {
        ['@identifier'] = identifier
    })
    if result[1] ~= nil then
        return result[1].phone_number
    end
    return nil
end
