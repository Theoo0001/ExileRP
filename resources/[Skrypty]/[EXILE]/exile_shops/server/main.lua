ESX             = nil

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_shops:buyItem')
AddEventHandler('esx_shops:buyItem', function(itemName, amount, price, itemlimit, moneytype, zone)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	amount = ESX.Round(amount)

	if amount < 0 then
		return
	end
	
	if type(price) == 'string' then
		price = tonumber(price)
	end

	if price ~= nil and amount ~= nil then
		price = price * amount
		local jebacciemoney = xPlayer.getAccount(moneytype).money
		local missingMoney = (jebacciemoney - price) * -1

		if xPlayer.getAccount(moneytype).money >= price then
			local item = xPlayer.getInventoryItem(itemName)
			
			if item ~= nil then
				if itemName == 'sim' then			
					ESX.CreateDynamicItem({
						type = 'sim',
						owner = xPlayer.identifier,
						ownerdigit = xPlayer.digit,
						blocked = 0,
						admin1 = '',
						admindigit1 = '',			
						admin2 = '',
						admindigit2 = '',
					}, function(data, number)
						xPlayer.showNotification("Kupiłeś nowy starter #" .. number)
						xPlayer.addInventoryItem(data, 1)
						xPlayer.removeAccountMoney(moneytype, price)	
					end)
				else
					local count = 0

					for k,v in pairs(Config.Zones[zone].Items) do
						if v.item == itemName then
							count = 1
						end
					end

					if count ~= 1 then
						TriggerEvent('csskrouble:banPlr', "nigger", _source, "Event-detected (exile_shops)")
						--exports['exile_logs']:SendLog(_source, "Event-Detect shops?", 'anticheat')
						--TriggerEvent('banCheater', _source, "Cheaty | Powód: Event-Detect") 
					else
						if itemlimit ~= nil then
							if itemlimit < amount or (item.count + amount) > itemlimit then
								xPlayer.showNotification('~r~Nie masz~s~ tyle ~y~wolnego miejsca ~s~ w ekwipunku!')
							else
								xPlayer.removeAccountMoney(moneytype, price)
								xPlayer.addInventoryItem(itemName, amount)
							end	
						end						
					end
				end
			end
		else
			xPlayer.showNotification('~r~Nie masz tyle '..(moneytype == 'money' and 'gotówki' or 'pieniędzy na karcie')..', brakuje ci ~g~$'.. missingMoney..'~r~!')
		end
	end
end)

--[[RegisterServerEvent('esx_shops:coffee')
AddEventHandler('esx_shops:coffee', function(kroljestjeden, krolsentino)
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_kawiarnia', function(account)
        account.addAccountMoney(kroljestjeden * (krolsentino or 1))
    end)

    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_kawiarnia', function(inventory)
        inventory.removeItem('kawa', krolsentino)
    end)
end)

ESX.RegisterServerCallback('esx_shops:getcoffee', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_kawiarnia', function(inventory)
			local shit = inventory.getItem('kawa')
			cb(json.encode(shit.count))
	end)
end) ]]

ESX.RegisterServerCallback('gcPhone:getHasSims', function(source, cb, admin)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

if admin then		
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	local Items = ESX.GetItems()
	
	local result = {}
	for k,v in pairs(Items) do			
		if v.type == 'sim' then
			if (v.data.owner == xPlayer.identifier and v.data.ownerdigit == xPlayer.digit) or (v.data.admin1 == xPlayer.identifier and v.data.admindigit1 == xPlayer.digit) or (v.data.admin2 == xPlayer.identifier and v.data.admindigit2 == xPlayer.digit) then
				if v.data.mainsim == true then
					table.insert(result, v.data)
				end
			end
		end
	end
	
	cb(result)  

else		
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	local Items = ESX.GetItems()
	
	local result = {}
	for k,v in pairs(Items) do
		if v.type == 'sim' then
			if v.data.owner == xPlayer.identifier and v.data.ownerdigit == xPlayer.digit then
				if v.data.mainsim == true then
					table.insert(result, v.data)
				end
			end
		end
	end
	
	cb(result)  

end

end)

ESX.RegisterServerCallback('gcPhone:getHasSimsCopy', function(source, cb)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	
	local Items = ESX.GetItems()
	
	local result = {}
	for k,v in pairs(Items) do
		if v.type == 'sim' then
			if v.data.owner == xPlayer.identifier and v.data.ownerdigit == xPlayer.digit then
				if v.data.mainsim == true then
					table.insert(result, v.data)
				end
			end
		end
	end
	
	cb(result, xPlayer.character.phone_number)  
end)


local SellTrigger = 'esx_shops:sellItem'..math.random(111111,999999)
local recived_token_shops = {}
RegisterServerEvent(SellTrigger)
AddEventHandler(SellTrigger, function(resourceName,itemName)
	if itemName == "phone" or itemName == "bizuteria" or itemName == "handcuff" or itemName == "krotkofalowka" or itemName == "fixkit2" or itemName == "gopro"  or itemName == "bon1" then
		if resourceName == GetCurrentResourceName() then
			local xPlayer = ESX.GetPlayerFromId(source)
			local xItem = xPlayer.getInventoryItem(itemName)
			if xItem.count <= xItem.limit then
				for k,v in pairs(Config.LombardItems) do
					if xItem.count > 0 then
						if itemName == v.item then
							local cena = xItem.count * v.price
							xPlayer.removeInventoryItem(itemName, xItem.count)
							xPlayer.addMoney(cena)
						end
					else
						TriggerClientEvent('esx:showNotification', source, 'Nie posiadasz tego przedmiotu w ekwipunku')
					end
				end
			else
				TriggerEvent('csskrouble:banPlr', "nigger", source, "Tried to sell more items than intended (exile_shops)")
				--exports['exile_logs']:SendLog(source, "SHOPS: Próba sprzedania ilości itemu ponad limit", 'anticheat', '15844367')
			
			end
		else
			TriggerEvent('csskrouble:banPlr', "nigger", source, "Tried to bypass (exile_shops)")
			--exports['exile_logs']:SendLog(source, "SHOPS: Niewłaściwa nazwa skryptu, próba obejścia", 'anticheat', '15844367')
		end
	else
		TriggerEvent('csskrouble:banPlr', "nigger", source, "Tried to give item (exile_shops)")
		--exports['exile_logs']:SendLog(source, "SHOPS: Próba sprzedania innego itemu niz w skrypcie", 'anticheat', '15844367')
	end
end)

RegisterServerEvent('esx_shops:request')
AddEventHandler('esx_shops:request', function()
	if not recived_token_shops[source] then
		TriggerClientEvent("esx_shops:getrequest", source, SellTrigger)
		recived_token_shops[source] = true
	else
		TriggerEvent('csskrouble:banPlr', "nigger", source, "Tried to get token (exile_shops)")
		--exports['exile_logs']:SendLog(source, "Shops: Próba otrzymania ponownie tokenu!", 'anticheat', '15844367')
	end
end)

AddEventHandler('playerDropped', function()
    recived_token_shops[source] = nil
end)