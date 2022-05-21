ESX = nil

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

StockTable = {}

function GetProperty(name)
	for i=1, #Config.Properties, 1 do
		if Config.Properties[i].name == name then
			return Config.Properties[i]
		end
	end
end

function ChangeStatePropety(name, state)
	MySQL.Async.execute('UPDATE properties SET is_available = @state WHERE name = @name', {
		['@state'] = state == false and 0 or 1,
		['@name'] = name
	}, function(value)
		for i = 1, #Config.Properties, 1 do
			if Config.Properties[i].name == name then		
				Config.Properties[i].isAvailable = state
			end
		end
		
		TriggerClientEvent('esx_property:changestate', -1, name, state)
	end)	
end

function SetPropertyOwned(name, price, rented, owner)
	local xPlayer = ESX.GetPlayerFromIdentifier(owner)
	MySQL.Async.execute('INSERT INTO owned_properties (name, price, rented, owner, digit) VALUES (@name, @price, @rented, @owner, @digit)',
	{
		['@name']   = name,
		['@price']  = price,
		['@rented'] = (rented and 1 or 0),
		['@owner']  = owner,
		['@digit'] 	= xPlayer.getDigit()
	}, function(rowsChanged)
		local xPlayer = ESX.GetPlayerFromIdentifier(owner)
		
		if xPlayer then
			ChangeStatePropety(name, false)
			TriggerClientEvent('esx_property:setPropertyBuyable', -1, {name=name,owned=false,subowned=false, owner=xPlayer.identifier}, true)
			TriggerClientEvent('esx_property:setPropertyOwned', xPlayer.source, {name=name,owned=true,subowned=false,owner=xPlayer.identifier}, true)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('purchased_for', ESX.Math.GroupDigits(price)))
		end
	end)
end

function RemoveOwnedProperty(name, owner, price)
	local xPlayer = ESX.GetPlayerFromIdentifier(owner)
	MySQL.Async.execute('DELETE FROM owned_properties WHERE name = @name AND owner = @owner AND digit = @digit', {
		['@name']  = name,
		['@owner'] = owner,
		['@digit'] = xPlayer.getDigit()
	}, function(rowsChanged)
		local pPrice = 0
		pPrice = math.floor(price * 0.6)
		if pPrice > 0 then
			xPlayer.addAccountMoney('money', pPrice)
		end
		if xPlayer then
			TriggerClientEvent('esx_property:setPropertyBuyable', -1, {name=name,owned=false,subowned=false, owner = nil}, false)
			TriggerClientEvent('esx_property:setPropertyOwned', xPlayer.source, {name=name,owned=false,subowned=false,owner=nil}, false)
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Sprzedałeś/aś mieszkanie za ~g~$" .. ESX.Math.GroupDigits(pPrice))
			ChangeStatePropety(name, true)
			exports['exile_logs']:SendLog(xPlayer.source, "Sprzedaż mieszkania do urzędu:\nNazwa mieszkania: " .. name .. "\nCena: " .. pPrice .. "$", 'property_sell', '3066993')
		end
	end)
end

RegisterServerEvent('esx_property:setSubowner')
AddEventHandler('esx_property:setSubowner', function(name, target)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local tPlayer = ESX.GetPlayerFromId(target)
	local pName = name
	if xPlayer.getMoney() >= 30000 then
		local test = MySQL.Sync.fetchAll('SELECT co_owner1, co_owner2 FROM owned_properties WHERE name = @name AND owner = @owner AND digit = @digit',
		{
			['@name'] = pName,
			['@owner'] = xPlayer.identifier,
			['@digit'] = xPlayer.getDigit()
		})
		while test == nil do
			Citizen.Wait(100)
		end
		
		if test[1].co_owner1 ~= nil and test[1].co_owner2 ~= nil then
			TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~To mieszkanie posiada maksymalną ilość współwłaścicieli")
			return
		else
			if test[1].co_owner1 == nil then
				MySQL.Async.execute('UPDATE owned_properties SET co_owner1=@co_owner1, co_digit1 = @co_digit1 WHERE name = @name AND owner = @owner AND digit = @digit', 
				{
					['@owner'] 		= xPlayer.identifier,
					['@digit']		= xPlayer.getDigit(),
					['@co_owner1']	= tPlayer.identifier,
					['@co_digit1']	= tPlayer.getDigit(),
					['@name']       = pName
				})
				TriggerClientEvent('esx:showNotification', xPlayer.source, "Nadałeś klucze do mieszkania dla " .. target)
				TriggerClientEvent('esx:showNotification', tPlayer.source, "Otrzymałeś klucze do mieszkania od " .. _source)
				xPlayer.removeAccountMoney('money', 30000)
				TriggerClientEvent('esx_property:setPropertyOwned', tPlayer.source, {name=name,owned=false,subowned=true,owner=xPlayer.identifier}, true)
				return
			elseif test[1].co_owner2 == nil then
				MySQL.Async.execute('UPDATE owned_properties SET co_owner2=@co_owner2, co_digit2 = @co_digit2 WHERE name = @name AND owner = @owner AND digit = @digit', 
				{
					['@owner'] 		= xPlayer.identifier,
					['@digit']		= xPlayer.getDigit(),
					['@co_owner2']	= tPlayer.identifier,
					['@co_digit2']	= tPlayer.getDigit(),
					['@name']       = pName
				})
				TriggerClientEvent('esx:showNotification', xPlayer.source, "Nadałeś klucze do mieszkania dla " .. target)
				TriggerClientEvent('esx:showNotification', tPlayer.source, "Otrzymałeś klucze do mieszkania od " .. _source)
				xPlayer.removeAccountMoney('money', 30000)
				TriggerClientEvent('esx_property:setPropertyOwned', tPlayer.source, {name=name,owned=false,subowned=true,owner=xPlayer.identifier}, true)
				return
			end
		end
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Nie posiadasz wystarczająco gotówki przy sobie!")
	end
end)

RegisterServerEvent('flux_properties:deleteSubowners')
AddEventHandler('flux_properties:deleteSubowners', function(name)
	local xPlayer = ESX.GetPlayerFromId(source)
	local test = MySQL.Sync.fetchAll('SELECT co_owner1, co_owner2 FROM owned_properties WHERE name = @name AND owner = @owner AND digit = @digit',
	{
		['@name'] = name,
		['@owner'] = xPlayer.identifier,
		['@digit'] = xPlayer.getDigit()
	})
	while test == nil do
		Citizen.Wait(100)
	end

	MySQL.Sync.execute(
		'UPDATE owned_properties SET co_owner1 = NULL, co_digit1 = 0, co_owner2 = NULL, co_digit2 = 0 WHERE owner = @owner AND digit = @digit AND name = @name',
		{
			['@owner']   = xPlayer.identifier,
			['@digit']	 = xPlayer.getDigit(),
			['@name'] 	 = name
		}
	)
	local tPlayer1 = ESX.GetPlayerFromIdentifier(test[1].co_owner1)
	local tPlayer2 = ESX.GetPlayerFromIdentifier(test[1].co_owner2)
	if tPlayer1 then
		TriggerClientEvent('esx_property:setPropertyOwned', tPlayer1.source, {name=name,owned=false,subowned=false,owner=xPlayer.identifier}, true)
	end
	if tPlayer2 then
		TriggerClientEvent('esx_property:setPropertyOwned', tPlayer2.source, {name=name,owned=false,subowned=false,owner=xPlayer.identifier}, true)
	end
	TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~Usunięto wszystkich współwłaścicieli mieszkania " .. name)
end)

function round(num, numDecimalPlaces)
	if numDecimalPlaces and numDecimalPlaces>0 then
	  local mult = 10^numDecimalPlaces
	  return math.floor(num * mult + 0.5) / mult
	end
	return math.floor(num + 0.5)
  end
  
ESX.RegisterServerCallback('esx_property:getAllProperties', function()
	MySQL.Async.fetchAll('SELECT * FROM properties', {
	}, function(properties)
		local allProperties = {}

		for i=1, #properties, 1 do
			table.insert(allProperties, {name = properties[i].name})
		end

		cb(properties)
	end)
end)
--[[
MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT name FROM properties', {}, function(properties)
		for i=1, #properties, 1 do
			MySQL.Async.fetchAll('SELECT owner FROM owned_properties WHERE name = @name', {
				['@name'] = properties[i].name
			}, function(owned)
				if owned[1] ~= nil then
					MySQL.Async.execute('DELETE FROM datastore_data WHERE owner IS NOT NULL AND owner NOT LIKE @owner AND name = @name', {
						['@owner'] = owned[1].owner,
						['@name'] = 'property' .. properties[i].name
					})
					MySQL.Async.execute('DELETE FROM addon_account_data WHERE owner IS NOT NULL AND owner NOT LIKE @owner AND account_name = @name', {
						['@owner'] = owned[1].owner,
						['@name'] = 'property_black_money' .. properties[i].name
					})
					MySQL.Async.execute('DELETE FROM addon_inventory_items WHERE owner IS NOT NULL AND owner NOT LIKE @owner AND inventory_name = @name', {
						['@owner'] = owned[1].owner,
						['@name'] = 'property' .. properties[i].name
					})
				end
			end)
		end
	end)
end)]]

MySQL.ready(function()
	--[[
	MySQL.Async.fetchAll('SELECT name FROM owned_properties', {}, function(properties)
		for k,v in ipairs(properties) do
			print(v.name)
			MySQL.Sync.execute('UPDATE properties SET is_available = @is_available WHERE name = @name', {
				['@name'] = v.name,
				['@is_available'] = 0
			})			
		end
	end)
	]]
	
	MySQL.Async.fetchAll('SELECT * FROM properties', {}, function(properties)

		for i=1, #properties, 1 do
			local entering  = nil
			local exit      = nil
			local inside    = nil
			local outside   = nil
			local isSingle  = nil
			local isRoom    = nil
			local isGateway = nil
			local isOpen 	= nil
			local roomMenu  = nil
			local garage	= nil
			local doors 	= nil
			local _isAvailable = false

			if properties[i].entering ~= nil then
				entering = json.decode(properties[i].entering)
			end

			if properties[i].exit ~= nil then
				exit = json.decode(properties[i].exit)
			end

			if properties[i].inside ~= nil then
				inside = json.decode(properties[i].inside)
			end

			if properties[i].outside ~= nil then
				outside = json.decode(properties[i].outside)
			end

			if properties[i].is_single == 0 then
				isSingle = false
			else
				isSingle = true
			end

			if properties[i].is_room == 0 then
				isRoom = false
			else
				isRoom = true
			end

			if properties[i].is_gateway == 0 then
				isGateway = false
			else
				isGateway = true
			end
			
			if properties[i].is_open == 0 then
				isOpen = false
			else
				isOpen = true
			end

			if properties[i].room_menu ~= nil then
				roomMenu = json.decode(properties[i].room_menu)
			end
			
			if properties[i].garage ~= nil then
				garage = json.decode(properties[i].garage)
			end
			
			if properties[i].doors ~= nil then
				doors = json.decode(properties[i].doors)
			end
			
			if properties[i].is_available == 1 then
				_isAvailable = true
			end

			table.insert(Config.Properties, {
				name      = properties[i].name,
				label     = properties[i].label,
				entering  = entering,
				exit      = exit,
				inside    = inside,
				outside   = outside,
				ipls      = json.decode(properties[i].ipls),
				gateway   = properties[i].gateway,
				isSingle  = isSingle,
				isRoom    = isRoom,
				isGateway = isGateway,
				isOpen	  = isOpen,
				roomMenu  = roomMenu,
				price     = properties[i].price,
				garage 	  = garage,
				doors 	  = doors,
				isAvailable = _isAvailable
			})
		end
		
		MySQL.Async.fetchAll('SELECT name, owner FROM owned_properties', {}, function(ownedProperties)
			for i=1, #ownedProperties, 1 do
				for j=1, #Config.Properties, 1 do
					if Config.Properties[j].name == ownedProperties[i].name then
						if Config.Properties[j].doors ~= nil then
							for k=1, #Config.Properties[j].doors, 1 do
								TriggerEvent('esx_doorlock:addNewDoors', Config.Properties[j].doors[k].model, Config.Properties[j].doors[k].x, Config.Properties[j].doors[k].y, Config.Properties[j].doors[k].z, ownedProperties[i].owner)
							end
						end
						break
					end
				end
			end
		end)

		TriggerClientEvent('esx_property:sendProperties', -1, Config.Properties)
	end)
end)

ESX.RegisterServerCallback('esx_property:getProperties', function(source, cb)
	cb(Config.Properties)
end)

--[[AddEventHandler('esx_ownedproperty:getOwnedProperties', function(cb)
	MySQL.Async.fetchAll('SELECT * FROM owned_properties', {}, function(result)
		local properties = {}

		for i=1, #result, 1 do
			table.insert(properties, {
				id     = result[i].id,
				name   = result[i].name,
				label  = GetProperty(result[i].name).label,
				price  = result[i].price,
				rented = (result[i].rented == 1 and true or false),
				owner  = result[i].owner
			})
		end

		cb(properties)
	end)
end)]]

AddEventHandler('esx_property:setPropertyOwned', function(name, price, rented, owner)
	SetPropertyOwned(name, price, rented, owner)
end)

RegisterServerEvent('esx_property:rentProperty')
AddEventHandler('esx_property:rentProperty', function(propertyName)
	local xPlayer  = ESX.GetPlayerFromId(source)
	local property = GetProperty(propertyName)
	local rent     = ESX.Math.Round(property.price / 200)

	SetPropertyOwned(propertyName, rent, true, xPlayer.identifier)
end)

RegisterServerEvent('esx_property:buyProperty')
AddEventHandler('esx_property:buyProperty', function(propertyName)
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	local property = GetProperty(propertyName)

	if property.price <= xPlayer.getMoney() then
		xPlayer.removeAccountMoney('money', property.price)
		SetPropertyOwned(propertyName, property.price, false, xPlayer.identifier)
		exports['exile_logs']:SendLog(_source, "Kupno mieszkania:\nNazwa mieszkania: " .. propertyName .. "\nCena: " .. property.price .. "$", 'property_buy', '15844367')
	else
		TriggerClientEvent('esx:showNotification', _source, _U('not_enough'))
	end
end)

RegisterServerEvent('esx_property:removeOwnedProperty')
AddEventHandler('esx_property:removeOwnedProperty', function(property)
	local xPlayer = ESX.GetPlayerFromId(source)
	RemoveOwnedProperty(property.name, xPlayer.identifier, property.price)
end)

RegisterServerEvent('esx_property:saveLastProperty')
AddEventHandler('esx_property:saveLastProperty', function(property)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE users SET last_property = @last_property WHERE identifier = @identifier',
	{
		['@last_property'] = property,
		['@identifier']    = xPlayer.identifier
	})
end)

RegisterServerEvent('esx_property:deleteLastProperty')
AddEventHandler('esx_property:deleteLastProperty', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE users SET last_property = NULL WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	})
end)

RegisterServerEvent('esx_property:getItem')
AddEventHandler('esx_property:getItem', function(owner, type, item, count, property)
	local _source      = source
	local xPlayer      = ESX.GetPlayerFromId(_source)
	local xPlayerOwner = ESX.GetPlayerFromIdentifier(owner)

	if type == 'item_standard' then

		local sourceItem = xPlayer.getInventoryItem(item)

		TriggerEvent('esx_addoninventory:getSharedInventory', 'property' .. property.name, function(inventory)
			local inventoryItem = inventory.getItem(item)

			if count > 0 and inventoryItem.count >= count then
			
				if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
					TriggerClientEvent('esx:showNotification', _source, _U('player_cannot_hold'))
				else
					inventory.removeItem(item, count)
					xPlayer.addInventoryItem(item, count)
					TriggerClientEvent('esx:showNotification', _source, _U('have_withdrawn', count, inventoryItem.label))
					exports['exile_logs']:SendLog(_source, "Wyciągnięto przedmiot: " .. item .. " x" .. count, 'property_get', '2123412')
				end
			else
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough_in_property'))
			end
		end)

	elseif type == 'item_account' then

		TriggerEvent('esx_addonaccount:getSharedAccount', 'property_' .. item .. property.name, function(account)
			local roomAccountMoney = account.money

			if roomAccountMoney >= count then
				account.removeMoney(count)
				xPlayer.addAccountMoney(item, count)
				exports['exile_logs']:SendLog(_source, "Wyciągnięto brudną gotówkę: " .. count .. "$", 'property_get', '10181046')
			else
				TriggerClientEvent('esx:showNotification', _source, _U('amount_invalid'))
				
			end
		end)
	end

end)

RegisterServerEvent('esx_property:putItem')
AddEventHandler('esx_property:putItem', function(owner, type, item, count, property)
	local _source      = source
	local xPlayer      = ESX.GetPlayerFromId(_source)
	local xPlayerOwner = ESX.GetPlayerFromIdentifier(owner)

	if type == 'item_standard' then

		local playerItemCount = xPlayer.getInventoryItem(item).count

		if playerItemCount >= count and count > 0 then
			TriggerEvent('esx_addoninventory:getSharedInventory', 'property'..property.name, function(inventory)
				local inventoryItem = inventory.getItem(item)
				local sourceItem = xPlayer.getInventoryItem(item)
				
				if sourceItem.limit ~= -1 and (inventoryItem.count + count) > (sourceItem.limit * 5) then
					TriggerClientEvent('esx:showNotification', _source, "~r~Nie masz odpowiednio dużo miejsca w mieszkaniu")
				else
					xPlayer.removeInventoryItem(item, count)
					inventory.addItem(item, count)
					TriggerClientEvent('esx:showNotification', _source, _U('have_deposited', count, inventory.getItem(item).label))
					exports['exile_logs']:SendLog(_source, "Włożono przedmiot: " .. item .. " x" .. count, 'property_put', '2123412')
				end
				
			end)
		else
			TriggerClientEvent('esx:showNotification', _source, _U('invalid_quantity'))
		end

	elseif type == 'item_account' then

		local playerAccountMoney = xPlayer.getAccount(item).money

		if playerAccountMoney >= count and count > 0 then
			xPlayer.removeAccountMoney(item, count)

			TriggerEvent('esx_addonaccount:getSharedAccount', 'property_' .. item .. property.name, function(account)
				account.addMoney(count)
			end)
			exports['exile_logs']:SendLog(_source, "Włożono brudną gotówkę: " .. count .. "$", 'property_put', '10181046')
		else
			TriggerClientEvent('esx:showNotification', _source, _U('amount_invalid'))
		end
	end

end)

ESX.RegisterServerCallback('esx_property:getAllOwnedProperties', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT name FROM owned_properties', {
	}, function(ownedProperties)
		local properties = {}

		for i=1, #ownedProperties, 1 do
			table.insert(properties, {name = ownedProperties[i].name})
		end

		cb(properties)
	end)
end)

ESX.RegisterServerCallback('esx_property:getOwnedProperties', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer then
		MySQL.Async.fetchAll('SELECT owner, digit, co_owner1, co_owner2, co_digit1, co_digit2, name FROM owned_properties WHERE (owner = @owner AND digit = @digit) OR (co_owner1 = @owner AND co_digit1 = @digit) OR (co_owner2 = @owner AND co_digit2 = @digit)', {
		['@owner'] = xPlayer.identifier,
		['@digit'] = xPlayer.getDigit()
		}, function(ownedProperties)
			local properties = {}

			for i=1, #ownedProperties, 1 do
				local isOwner, isSubowner
				if (ownedProperties[i].owner == xPlayer.identifier and ownedProperties[i].digit == xPlayer.getDigit()) then
					isOwner = true
					isSubowner = false
				elseif (ownedProperties[i].co_owner1 == xPlayer.identifier and ownedProperties[i].co_digit1 == xPlayer.getDigit()) or (ownedProperties[i].co_owner2 == xPlayer.identifier and ownedProperties[i].co_digit2 == xPlayer.getDigit()) then
					isOwner = false
					isSubowner = true
				else
					isOwner = false
					isSubowner = false
				end
				table.insert(properties, {name=ownedProperties[i].name, owned=isOwner, subowned=isSubowner, owner=ownedProperties[i].owner})
			end

			cb(properties)
		end)
	end
end)

ESX.RegisterServerCallback('flux_properties:getOwnedProperties', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT name FROM owned_properties WHERE owner = @owner AND digit = @digit AND rented = 0', {
		['@owner'] = xPlayer.identifier,
		['@digit'] = xPlayer.getDigit()
	}, function(ownedProperties)
		local properties = {}

		for i=1, #ownedProperties, 1 do
			table.insert(properties, {name = ownedProperties[i].name})
		end

		cb(properties)
	end)
end)

ESX.RegisterServerCallback('esx_property:getLastProperty', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT last_property FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(users)
		cb(users[1].last_property)
	end)
end)

ESX.RegisterServerCallback('esx_property:getPropertyInventory', function(source, cb, owner, property)
	local xPlayer    = ESX.GetPlayerFromIdentifier(owner)
	local blackMoney = 0
	local items      = {}

	TriggerEvent('esx_addonaccount:getSharedAccount', 'property_black_money' .. property.name, function(account)
		blackMoney = account.money
	end)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'property' .. property.name, function(inventory)
		if inventory == nil then
			items = {}
		else
			items = inventory.items
		end
	end)

	cb({
		blackMoney = blackMoney,
		items      = items
	})
end)

ESX.RegisterServerCallback('esx_property:getPlayerInventory', function(source, cb)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local blackMoney = xPlayer.getAccount('black_money').money
	local items      = xPlayer.inventory

	cb({
		blackMoney = blackMoney,
		items      = items,
	})
end)

ESX.RegisterServerCallback('esx_property:getPlayerDressing', function(source, cb)
	local xPlayer  = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local labels = {}

		if xPlayer.getDigit() == 1 then 
			local count  = store.count('dressing')
			for i=1, count, 1 do
				local entry = store.get('dressing', i)
				table.insert(labels, entry.label)
			end
		else
			local count  = store.count2('dressing')
			for i=1, count, 1 do
				local entry = store.get2('dressing', i)
				table.insert(labels, entry.label)
			end
		end

		cb(labels)
	end)
end)

ESX.RegisterServerCallback('esx_property:getPlayerOutfit', function(source, cb, num)
	local xPlayer  = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local outfit = nil
		if xPlayer.getDigit() == 1 then
			outfit = store.get('dressing', num)
		else
			outfit = store.get2('dressing', num)
		end
		
		if outfit.skin == nil then
			outfit.skin = {}
		end
		
		cb(outfit.skin)
	end)
end)

RegisterServerEvent('esx_property:removeOutfit')
AddEventHandler('esx_property:removeOutfit', function(label)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local dressing = nil
		if xPlayer.getDigit() == 1 then
			dressing = store.get('dressing') or {}
			table.remove(dressing, label)
			store.set('dressing', dressing)
		else
			dressing = store.get2('dressing') or {}
			table.remove(dressing, label)
			store.set2('dressing', dressing)
		end
	end)
end)

RegisterServerEvent('esx_property:sellForPlayer')
AddEventHandler('esx_property:sellForPlayer', function(name, price, target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local tPlayer = ESX.GetPlayerFromId(target)
	local pName, pPrice = name, price
	TriggerClientEvent('esx_property:acceptBuy', tPlayer.source, xPlayer.identifier, pName, pPrice)
end)

RegisterServerEvent('esx_property:changeOwner')
AddEventHandler('esx_property:changeOwner', function(owner, name, price)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local pOwner, pName, pPrice = owner, name, price
	local xPlayerOwner = ESX.GetPlayerFromIdentifier(pOwner)
	if xPlayer.getMoney() > price  then
		if xPlayerOwner ~= nil then
			MySQL.Async.execute('UPDATE owned_properties SET owner=@owner1, digit = @digit1, co_owner1 = NULL, co_digit1 = NULL, co_owner2 = NULL, co_digit2 = NULL WHERE name = @name AND owner = @owner2 AND digit = @digit2', 
			{
				['@owner1'] 	= xPlayer.identifier,
				['@digit1']		= xPlayer.getDigit(),
				['@owner2']		= pOwner,
				['@digit2']		= xPlayerOwner.getDigit(),
				['@name']       = pName
			})
			xPlayer.removeAccountMoney('money', pPrice)
			xPlayerOwner.addAccountMoney('money', pPrice - 20000)
			-- prowizja do ratusza
			TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~Kupiłeś ~w~ mieszkanie za ~g~" .. pPrice .. "$")
			TriggerClientEvent('esx:showNotification', xPlayerOwner.source, "~g~Sprzedałeś ~w~ mieszkanie za ~g~" .. pPrice .. "$")

			TriggerClientEvent('esx_property:setPropertyOwned', xPlayerOwner.source, {name=name,owned=false,subowned=false,owner=xPlayer.identifier}, true)
			TriggerClientEvent('esx_property:setPropertyBuyable', -1, {name=name,owned=false,subowned=false,owner=xPlayer.identifier}, true)
			TriggerClientEvent('esx_property:setPropertyOwned', xPlayer.source, {name=name,owned=true,subowned=false,owner=xPlayer.identifier}, true)
			exports['exile_logs']:SendLog(xPlayerOwner.source, "Sprzedaż mieszkania dla gracza:\nNowy właściciel: [" .. xPlayer.source .. "] " .. GetPlayerName(xPlayer.source) .. "\nNazwa mieszkania: " .. pName .. "\nCena: " .. pPrice .. "$", 'property_sell', '3447003')
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Wystąpił nieoczekiwany błąd")
		end
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Nie masz wystarczającej ilości gotówki przy sobie!")
		TriggerClientEvent('esx:showNotification', xPlayerOwner.source, "~r~Obywatel nie ma wystarczająco pieniędzy na kupno mieszkania!")
	end
end)

ESX.RegisterServerCallback('esx_property:checkStock', function(source, cb, name)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if StockTable[name] == nil then
		StockTable[name] = xPlayer.identifier
		cb(false)
	else
		if StockTable[name] == xPlayer.identifier then
			cb(false)
		else
			cb(true)
		end
	end
end)

RegisterServerEvent('esx_property:setStockUsed')
AddEventHandler('esx_property:setStockUsed', function(name, bool)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if bool == true then
		StockTable[name] = xPlayer.identifier
	else
		StockTable[name] = nil
	end
end)

RegisterServerEvent('esx_property:renameOutfit')
AddEventHandler('esx_property:renameOutfit', function(label, newlabel)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)	
		local dressing = store.get('dressing') or {}
		
		if dressing ~= {} then			
			for k,v in ipairs(dressing) do
				if k == label then
					v.label = newlabel
					break
				end
			end
			
			if xPlayer.getDigit() == 1 then
				store.set('dressing', dressing)
			else
				store.set2('dressing', dressing)
			end
		end
	end)
end)