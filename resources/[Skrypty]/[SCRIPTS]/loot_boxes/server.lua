ESX = nil

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)


local playerWinnings = {}
CreateThread(function()
	for k, v in pairs(Config["exilecases"]) do
		ESX.RegisterUsableItem(k, function(source)
			local xPlayer = ESX.GetPlayerFromId(source)
			if not playerWinnings[source] then
				xPlayer.removeInventoryItem(k, 1)
				local winning = calculateWin(k)
				playerWinnings[source] = winning
				TriggerClientEvent('exile_boxes:openexilecases', source,k, winning)
			end
		end)
	end
end)
AddEventHandler("playerDropped", function() 
	playerWinnings[source] = nil
end)

function calculateWin(type) 
	local sum = 0
	draw = {}
	for k, v in pairs(Config["exilecases"][type].list) do
		local rate = Config["chance"][v.tier].rate * 100
		for i=1,rate do 
			if v.item then
				if v.amount then
					table.insert(draw, {item = v.item ,amount = v.amount, tier = v.tier})
				else
					table.insert(draw, {item = v.item ,amount = 1, tier = v.tier})
				end
			elseif v.weapon then
				table.insert(draw, {weapon = v.weapon , amount = v.amount, tier = v.tier})
			elseif v.vehicle then
				table.insert(draw, {vehicle = v.vehicle, tier = v.tier})
			elseif v.money then
				table.insert(draw, {money = v.money, tier = v.tier})
			elseif v.black_money then
				table.insert(draw, {black_money = v.black_money, tier = v.tier})
			end
			i = i + 1
		end
		sum = sum + rate
	end
	local random = math.random(1,sum)
	local data = Config["exilecases"][type].list
	local img = Config["image_source"]
	local win = draw[random]
	return {data = data, img = img, win = win}
end


--[[RegisterServerEvent('exile_boxes:giveReward')
AddEventHandler('exile_boxes:giveReward', function (t, data, amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if t == "item" then
		xPlayer.addInventoryItem(data, amount)
		exports['exile_logs']:SendLog(source, "Wylosowal "..data.." x"..amount.."", 'skrzynki', '5793266')
	elseif t == "weapon" then
		xPlayer.addInventoryWeapon(data, amount, 1, false)
		exports['exile_logs']:SendLog(source, "Wylosowal "..data.." x"..amount.." z 5 ammo", 'skrzynki', '5793266')
	elseif t == "money" then
		xPlayer.addMoney(data)
		exports['exile_logs']:SendLog(source, "Wylosowal "..data.."$", 'skrzynki', '5793266')
	elseif t == "black_money" then
		xPlayer.addAccountMoney('black_money', data)
		exports['exile_logs']:SendLog(source, "Wylosowal "..data.."$ brudnej gotowki", 'skrzynki', '5793266')
	end
end)]]

RegisterServerEvent('exile_boxes:giveReward', function() 
	local src = source
	if not playerWinnings[src] then
		TriggerEvent('csskrouble:banPlr', "nigger", src, "Próba oszukiwania w skrzynkach")
		return
	end
	local xPlayer = ESX.GetPlayerFromId(src)
	local win = playerWinnings[src].win
	if win.item then
		xPlayer.addInventoryItem(win.item, win.amount)
		exports['exile_logs']:SendLog(src, "Wylosowal "..win.item.." x"..win.amount.."", 'skrzynki', '5793266')
	elseif win.weapon then
		xPlayer.addInventoryWeapon(win.weapon, win.amount, 1, false)
		exports['exile_logs']:SendLog(src, "Wylosowal "..win.weapon.." x"..win.amount.." z 5 ammo", 'skrzynki', '5793266')
	elseif win.money then
		xPlayer.addMoney(win.money)
		exports['exile_logs']:SendLog(src, "Wylosowal "..win.money.."$", 'skrzynki', '5793266')
	elseif win.black_money then
		xPlayer.addAccountMoney('black_money', win.black_money)
		exports['exile_logs']:SendLog(src, "Wylosowal "..win.black_money.."$ brudnej gotowki", 'skrzynki', '5793266')
	end
	TriggerClientEvent("csskrouble:save", src)
	playerWinnings[src] = nil
end)

RegisterServerEvent("exile_boxes:exchange")
AddEventHandler("exile_boxes:exchange", function(type)
	local _source = source
	TriggerEvent('csskrouble:banPlr', "nigger", _source, "Próba wymienienia serc na skrzynki :kekw:")
end)