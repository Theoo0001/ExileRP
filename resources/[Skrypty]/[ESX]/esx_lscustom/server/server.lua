ESX = nil
TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)
local Vehicles = nil


local occuped = {
	[1] = {locked = false, player = nil},
	--[[[2] = {locked = false, player = nil},
	[3] = {locked = false, player = nil},
	[5] = {locked = false, player = nil},
	[6] = {locked = false, player = nil},
	[7] = {locked = false, player = nil},]]
}

RegisterServerEvent('LSC:lock')
AddEventHandler('LSC:lock', function(b,garage)
	if b ~= nil then
		occuped[tonumber(garage)].locked = b
		
		if not b then
			occuped[tonumber(garage)].player = nil
		else
			occuped[tonumber(garage)].player = source
		end
		TriggerClientEvent('LSC:lock', -1, occuped, 
			math.floor(exports['esx_scoreboard']:CounterPlayers('mechanik2') + 
			exports['esx_scoreboard']:CounterPlayers('mechanik3') + 
			exports['esx_scoreboard']:CounterPlayers('mechanik4')
			)
		)
	end
end)

RegisterServerEvent('LSC:garages')
AddEventHandler('LSC:garages', function()
	TriggerClientEvent('LSC:lock', -1, occuped, 
		math.floor(exports['esx_scoreboard']:CounterPlayers('mechanik2') + 
		exports['esx_scoreboard']:CounterPlayers('mechanik3') + 
		exports['esx_scoreboard']:CounterPlayers('mechanik4')
		)
	)
end)
AddEventHandler('playerDropped', function()
	for i,g in pairs(occuped) do
		if g.player then
			if source == g.player then
				g.locked = false
				g.player = nil
				TriggerClientEvent('LSC:lock', -1, occuped, 
					math.floor(exports['esx_scoreboard']:CounterPlayers('mechanik2') + 
					exports['esx_scoreboard']:CounterPlayers('mechanik3') + 
					exports['esx_scoreboard']:CounterPlayers('mechanik4')
					)
				)
			end
		end
	end
end)

RegisterServerEvent("LSC:accept")
AddEventHandler("LSC:accept", function(name, button)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if button.price then
		if button.price <= xPlayer.getMoney() then
			TriggerClientEvent("LSC:accept", source, name, button)
			if xPlayer.job.name == 'mechanik' then
				TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. xPlayer.job.name, function(account)
					local hajs = math.floor((button.price / 100) * 50)
					account.addAccountMoney(hajs)
				end)
			elseif xPlayer.job.name == 'mechanik2' then
				TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. xPlayer.job.name, function(account)
					local hajs = math.floor((button.price / 100) * 50)
					account.addAccountMoney(hajs)
				end)
			else
				TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanik', function(account)
					local hajs = math.floor((button.price / 100) * 50)
					account.addAccountMoney(hajs)
				end)
			end
			xPlayer.removeMoney(button.price)
			xPlayer.showNotification("Zapłacono: $"..button.price.." za zakup modyfikacji.")
		else
			TriggerClientEvent("LSC:cancel", source, name, xPlayer.getMoney() - button.price)
		end
	end
end)

RegisterServerEvent('LSC:refreshOwnedVehicle')
AddEventHandler('LSC:refreshOwnedVehicle', function(myCar)
	MySQL.Async.execute('UPDATE `owned_vehicles` SET `vehicle` = @vehicle WHERE `plate` = @plate', {
		['@plate']   = myCar.plate,
		['@vehicle'] = json.encode(myCar)
	})
end)

RegisterServerEvent("LSC:finished")
AddEventHandler("LSC:finished", function(veh)
	local model = veh.model --Display name from vehicle model(comet2, entityxf)
	local mods = veh.mods
	local color = veh.color
	local extracolor = veh.extracolor
	local neoncolor = veh.neoncolor
	local smokecolor = veh.smokecolor
	local plateindex = veh.plateindex
	local windowtint = veh.windowtint
	local wheeltype = veh.wheeltype
end)

ESX.RegisterServerCallback('esx_vehicleshop:getVehiclePrice', function(source, cb, model)
	MySQL.Async.fetchAll('SELECT price FROM vehicles WHERE model = @model', {
		['@model'] = model
	}, function(result)
		if result[1] ~= nil then			
			cb(result[1].price)
			--print(model)
			--print('cena')
		else
			cb(2000000)
			--print(model)
			--print('es')
		end
	end)
end)