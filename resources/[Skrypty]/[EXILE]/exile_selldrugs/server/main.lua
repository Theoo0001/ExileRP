ESX = nil

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

local interested = {}

RegisterServerEvent('esx_sellnpc:canSell')
AddEventHandler('esx_sellnpc:canSell', function(distance)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local weedqty = xPlayer.getInventoryItem('weed_pooch').count
	local metaqty = xPlayer.getInventoryItem('meth_pooch').count
	local kokainaqty = xPlayer.getInventoryItem('coke_pooch').count
	local kokainapericoqty = xPlayer.getInventoryItem('cokeperico_pooch').count
	local heroinaqty = xPlayer.getInventoryItem('opium_pooch').count
	local oghazeqty = xPlayer.getInventoryItem('oghaze_pooch').count
	local exctasyqty = xPlayer.getInventoryItem('exctasy_pooch').count
	local drugType = nil
	
	if metaqty >= 1 then
		drugType = 'meth_pooch'
	end
	
	if kokainaqty >= 1 then
		drugType = 'coke_pooch' 
	end

	if kokainapericoqty >= 1 then
		drugType = 'cokeperico_pooch' 
	end
	
	if heroinaqty >= 1 then
		drugType = 'opium_pooch'
	end
	
	if weedqty >= 1 then
		drugType = 'weed_pooch'
	end		

	if oghazeqty >= 1 then
		drugType = 'oghaze_pooch'
	end	

	if exctasyqty >= 1 then
		drugType = 'exctasy_pooch'
	end
	
	if drugType ~= nil then
		TriggerClientEvent('esx_sellnpc:canSell', _source, true, distance)
	else
		TriggerClientEvent('esx_sellnpc:canSell', _source, false, distance)
	end	
end)

RegisterServerEvent('esx_sellnpc:sell')
AddEventHandler('esx_sellnpc:sell', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local police = exports['esx_scoreboard']:CounterPlayers('police')
	local isInterested = math.random(1, Config.intrested)
	local notifyCops = math.random(1, Config.psy)
	local photo		= math.random(1, Config.photo)
	local samarkaStatus = exports['esx_basicneeds']:samarkaStatus(_source)
	local zainteresowany = false
	local psy = false
	local fotka = false
	if samarkaStatus and isInterested > 1 then
		isInterested = math.random(1, 2)
		if isInterested == 1 then
			zainteresowany = true
		end
	elseif isInterested == 1 then
		zainteresowany = true
	end

	if notifyCops == 1 then
		psy = true
	else
		psy = false
	end	

	if photo == 1 then
		fotka = true
	else
		fotka = false
	end

	interested[_source] = true

	if police >= Config.LSPD then
		TriggerClientEvent('esx_sellnpc:sell', _source, zainteresowany, psy, police, fotka)
	else
		TriggerClientEvent('esx:showNotification', _source, '~r~Zbyt mało jednostek SASP żeby sprzedać narkotyki')
		TriggerClientEvent('esx_sellnpc:sell', _source, nil, nil, nil)
	end
end)

RegisterServerEvent('esx_sellnpc:acceptSell')
AddEventHandler('esx_sellnpc:acceptSell', function(cops)
	local _source = source
	if interested[_source] ~= nil then
		interested[_source] = nil
		local xPlayer = ESX.GetPlayerFromId(_source)
		local weedqty = xPlayer.getInventoryItem('weed_pooch').count
		local metaqty = xPlayer.getInventoryItem('meth_pooch').count
		local kokainaqty = xPlayer.getInventoryItem('coke_pooch').count
		local kokainapericoqty = xPlayer.getInventoryItem('cokeperico_pooch').count
		local heroinaqty = xPlayer.getInventoryItem('opium_pooch').count
		local oghazeqty = xPlayer.getInventoryItem('oghaze_pooch').count
		local exctasyqty = xPlayer.getInventoryItem('exctasy_pooch').count
		local x = 0
		local blackMoney = 0
		local drugType = nil

		if metaqty > 0 then
			drugType = 'meth_pooch'
			if metaqty == 1 then
				x = 1
			elseif metaqty == 2 then
				x = math.random(1,2)
			elseif metaqty == 3 then
				x = math.random(1,3)
			elseif metaqty == 4 then
				x = math.random(1,4)
			elseif metaqty >= 5 then
				x = math.random(1,5)
			end
		end

		if kokainaqty > 0 then
			drugType = 'coke_pooch'
			if kokainaqty == 1 then
				x = 1
			elseif kokainaqty == 2 then
				x = math.random(1,2)
			elseif kokainaqty == 3 then
				x = math.random(1,3)
			elseif kokainaqty == 4 then
				x = math.random(1,4)
			elseif kokainaqty >= 5 then
				x = math.random(1,5)
			end
		end

		if kokainapericoqty > 0 then
			drugType = 'cokeperico_pooch'
			if kokainapericoqty == 1 then
				x = 1
			elseif kokainapericoqty == 2 then
				x = math.random(1,2)
			elseif kokainapericoqty == 3 then
				x = math.random(1,3)
			elseif kokainapericoqty == 4 then
				x = math.random(1,4)
			elseif kokainapericoqty >= 5 then
				x = math.random(1,5)
			end
		end

		if heroinaqty > 0 then
			drugType = 'opium_pooch'
			if heroinaqty == 1 then
				x = 1
			elseif heroinaqty == 2 then
				x = math.random(1,2)
			elseif heroinaqty == 3 then
				x = math.random(1,3)
			elseif heroinaqty == 4 then
				x = math.random(1,4)
			elseif heroinaqty >= 5 then
				x = math.random(1,5)
			end
		end

		if weedqty > 0 then
			drugType = 'weed_pooch'
			if weedqty == 1 then
				x = 1
			elseif weedqty == 2 then
				x = math.floor(1,2)
			elseif weedqty == 3 then
				x = math.random(1,3)
			elseif weedqty == 4 then
				x = math.random(1,4)
			elseif weedqty >= 5 then
				x = math.random(1,5)
			end
		end

		if oghazeqty > 0 then
			drugType = 'oghaze_pooch'
			if oghazeqty == 1 then
				x = 1
			elseif oghazeqty == 2 then
				x = math.floor(1,2)
			elseif oghazeqty == 3 then
				x = math.random(1,3)
			elseif oghazeqty == 4 then
				x = math.random(1,4)
			elseif oghazeqty >= 5 then
				x = math.random(1,5)
			end
		end

		if exctasyqty > 0 then
			drugType = 'exctasy_pooch'
			if exctasyqty == 1 then
				x = 1
			elseif exctasyqty == 2 then
				x = math.floor(1,2)
			elseif exctasyqty == 3 then
				x = math.random(1,3)
			elseif exctasyqty == 4 then
				x = math.random(1,4)
			elseif exctasyqty >= 5 then
				x = math.random(1,5)
			end
		end

		if drugType == 'meth_pooch' then
			blackMoney = math.random(4500, 5500) * x -- 2900-3500 /
		elseif drugType == 'coke_pooch' then
			blackMoney = math.random(6000, 7000) * x -- 4100-4600/
		elseif drugType == 'cokeperico_pooch' then
			blackMoney = math.random(100, 200) * x  -- nie ruszać (krzychu)/
		elseif drugType == 'opium_pooch' then
			blackMoney = math.random(8000, 11000) * x   --7200-8100/
		elseif drugType == 'weed_pooch' then
			blackMoney = math.random(2300, 3300)  * x  -- 1600-2300/
		elseif drugType == 'oghaze_pooch' then
			blackMoney = math.random(3300, 4300) * x -- 2500-3200/
		elseif drugType == 'exctasy_pooch' then
			blackMoney = math.random(3500, 4500) * x --2900-3500/
		end

		if cops > 4 and cops < 6 then 
			blackMoney = blackMoney * 1.15
		elseif cops > 6 and cops < 8 then
			blackMoney = blackMoney * 1.25
		elseif cops > 8 and cops < 10 then
			blackMoney = blackMoney * 1.35
		elseif cops > 10 then
			blackMoney = blackMoney * 1.40
		end

		local jajka = math.random(1,2)
		if drugType ~= nil then
			xPlayer.addInventoryItem("Jajko Wielkanoce", jajka)
			xPlayer.removeInventoryItem(drugType, x)
		end

		local locale = {
			['meth_pooch'] = x == 1 and 'paczkę metamfetaminy za' or 'paczki metamfetaminy za',
			['opium_pooch'] = x == 1 and 'paczkę opium za' or 'paczki opium za',
			['weed_pooch'] = x == 1 and 'paczkę marihuany za' or 'paczki marihuany za',
			['coke_pooch'] = x == 1 and 'paczkę kokainy za' or 'paczki kokainy za',
			['cokeperico_pooch'] = x == 1 and 'paczkę kokainy Perico za' or 'paczki kokainy za',
			['oghaze_pooch'] = x == 1 and 'woreczek OG Haze za' or 'woreczków OG Haze za',
			['exctasy_pooch'] = x == 1 and 'tabletkę ekstazy' or 'tabletek ekstazy'
		}
		if xPlayer.getDealerLevel().level > 0 then
			blackMoney = math.floor(blackMoney + ((xPlayer.getDealerLevel().level / 100) * blackMoney))
		end
		if drugType == 'weed_pooch' or drugType == 'oghaze_pooch' then
			xPlayer.addMoney(blackMoney)
		else
			xPlayer.addAccountMoney('black_money', blackMoney)
		end
		xPlayer.addDealerLevel()
		TriggerClientEvent('esx:showNotification', _source, '~y~Sprzedałeś '..x..' '..locale[drugType]..' ~g~'..blackMoney..'$')
		TriggerClientEvent('klientblip:remove',_source)
		local samarkaReward = math.random(1, 100)
		if samarkaReward <= 10 then
			xPlayer.addInventoryItem('samarka', 1)
			TriggerClientEvent('esx:showNotification', _source, '~g~Gratulację! ~w~Znalazłeś/aś ~b~samarkę')
		end
	end
end)

RegisterServerEvent('esx_sellnpc:denySell')
AddEventHandler('esx_sellnpc:denySell', function(type)
	local _source = source
	if type == nil then
		TriggerClientEvent('esx:showNotification', _source, '~r~Anulowałeś ofertę sprzedaży')
		TriggerClientEvent('esx_sellnpc:canSell', _source, false, 0)	
		interested[_source] = nil
	elseif type == false then
		if interested[_source] ~= nil then
			TriggerClientEvent('esx:showNotification', _source, '~r~Obywatel odrzucił ofertę sprzedaży')
			TriggerClientEvent("klientblip:remove", _source)
			TriggerClientEvent('esx_sellnpc:canSell', _source, false, 0)
			interested[_source] = nil
		end
	elseif type == true then
		if interested[_source] ~= nil then
			TriggerClientEvent('esx_sellnpc:canSell', _source, false, 0)
			interested[_source] = nil
		end
	end
end)

ESX.RegisterServerCallback('xfsd-sell:checkDoesHaveAnyDrugs', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local weedqty = xPlayer.getInventoryItem('weed_pooch').count
	local metaqty = xPlayer.getInventoryItem('meth_pooch').count
	local kokainaqty = xPlayer.getInventoryItem('coke_pooch').count
	local kokainapericoqty = xPlayer.getInventoryItem('cokeperico_pooch').count
	local heroinaqty = xPlayer.getInventoryItem('opium_pooch').count
	local oghazeqty = xPlayer.getInventoryItem('oghaze_pooch').count
	local exctasyqty = xPlayer.getInventoryItem('exctasy_pooch').count

	if weedqty ~= 0 or metaqty ~= 0 or kokainaqty ~= 0 or kokainapericoqty ~= 0 or heroinaqty ~= 0 or oghazeqty ~= 0 or exctasyqty ~= 0 then
		cb(true)
	else
		cb(false)
	end
end)