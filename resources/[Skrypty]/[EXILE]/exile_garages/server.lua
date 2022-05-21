ESX                = nil
TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)


ESX.RegisterServerCallback('flux_garages:getVehicles', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local carsToReturn = {}
	
	local result = MySQL.Sync.fetchAll('SELECT vehicle FROM owned_vehicles WHERE ((owner = @identifier AND digit = @digit) or (co_owner = @identifier AND co_digit = @digit) or (co_owner2 = @identifier AND co_digit2 = @digit)) AND state = @state AND job IS NULL AND type = @type', {
		['@identifier'] = xPlayer.identifier, ['@digit'] = xPlayer.getDigit(), ['@state'] = 'stored', ['@type'] = 'car'}
	)

	for i=1, #result, 1 do
		local car = json.decode(result[i].vehicle)
	
		table.insert(carsToReturn, car)
	end

	Citizen.Wait(150)
	cb(carsToReturn)
end)

ESX.RegisterServerCallback('flux_garages:getBoats', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local carsToReturn = {}
	
	local result = MySQL.Sync.fetchAll('SELECT vehicle FROM owned_vehicles WHERE ((owner = @identifier AND digit = @digit) or (co_owner = @identifier AND co_digit = @digit) or (co_owner2 = @identifier AND co_digit2 = @digit)) AND state = @state AND job IS NULL AND type = @type', {
		['@identifier'] = xPlayer.identifier, ['@digit'] = xPlayer.getDigit(), ['@state'] = 'stored', ['@type'] = 'boat'}
	)

	for i=1, #result, 1 do
		local car = json.decode(result[i].vehicle)
	
		table.insert(carsToReturn, car)
	end

	Citizen.Wait(150)
	cb(carsToReturn)
end)

ESX.RegisterServerCallback('flux_garages:getPlanes', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local carsToReturn = {}
	
	local result = MySQL.Sync.fetchAll('SELECT vehicle FROM owned_vehicles WHERE ((owner = @identifier AND digit = @digit) or (co_owner = @identifier AND co_digit = @digit) or (co_owner2 = @identifier AND co_digit2 = @digit)) AND state = @state AND job IS NULL AND type = @type', {
		['@identifier'] = xPlayer.identifier, ['@digit'] = xPlayer.getDigit(), ['@state'] = 'stored', ['@type'] = 'plane'}
	)

	for i=1, #result, 1 do
		local car = json.decode(result[i].vehicle)
	
		table.insert(carsToReturn, car)
	end

	Citizen.Wait(150)
	cb(carsToReturn)
end)

RegisterServerEvent('flux_garages:updateState')
AddEventHandler('flux_garages:updateState', function(plate)
	MySQL.Sync.execute(
		'UPDATE `owned_vehicles` SET state = @state WHERE plate = @plate',
		{
			['@plate'] = plate,
			['@state'] = "stored"
		}
	)
end)

RegisterServerEvent('flux_garages:updatePlate')
AddEventHandler('flux_garages:updatePlate', function(oldplate, newplate)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local oldPlate = string.upper(oldplate)
	local newPlate = string.upper(newplate)
	if xPlayer.getMoney() >= 500000 then
		xPlayer.removeAccountMoney('money', 500000)
		MySQL.Async.execute('UPDATE owned_vehicles SET plate = @newPlate, vehicle = JSON_SET(vehicle, "$.plate", @newPlate) WHERE plate = @plate',{ 
			['@plate'] = oldPlate,
			['@newPlate'] = newPlate
		})
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_doj', function(account)
			account.addAccountMoney(50000)
		end)
		xPlayer.showNotification('Rejestracja ~b~' .. oldPlate .. '~w~ została zmieniona na ~y~' .. newPlate)
		exports['exile_logs']:SendLog(xPlayer.source, 'Rejestracja **' .. oldPlate .. '** została zmieniona na **' .. newPlate .. "**", 'plates')
	else
		xPlayer.showNotification('~r~Potrzebujesz minimum 500 000$, aby zmienić rejestrację')
	end
end)

ESX.RegisterServerCallback('flux_garages:checkIfVehicleIsOwned', function (source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	local found = nil
	local vehicleData = nil
	MySQL.Async.fetchAll(
	'SELECT vehicle FROM owned_vehicles WHERE (owner = @owner AND digit = @digit) or (co_owner = @owner AND co_digit = @digit) or (co_owner2 = @owner AND co_digit2) AND state=@state',
	{
		['@owner'] = identifier,
		['@digit'] = xPlayer.getDigit(),
		['state'] = 'stored'
	},
	function (result2)
		local vehicles = {}
		for i=1, #result2, 1 do
			vehicleData = json.decode(result2[i].vehicle)
			if vehicleData ~= nil and vehicleData.plate == plate then
				found = true
				cb(vehicleData)
				break
			end
		end
		if not found then
			cb(nil)
		end
	end
	)
end)

RegisterServerEvent('flux_garages:pullCar')
AddEventHandler('flux_garages:pullCar', function(car)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Sync.execute("UPDATE owned_vehicles SET state=@stan WHERE plate=@plate", {
		['@plate'] = car.plate,
		['@stan'] = 'pulledout'
	})
	TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~Pojazd wyciągnięty")
end)

RegisterServerEvent('flux_garages:leftCar')
AddEventHandler('flux_garages:leftCar', function(car)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local result = MySQL.Sync.fetchAll("SELECT firstmodel FROM owned_vehicles WHERE plate=@plate", { 
		['@plate'] = car.plate
	})
	if result then
		if result[1].firstmodel then
			if tostring(car.model) ~= tostring(result[1].firstmodel) then
				MySQL.Sync.execute("UPDATE owned_vehicles SET state=@stan, vehicle = @vehicle WHERE plate=@plate", {
					['@plate'] = car.plate,
					['@stan'] = 'stored',
					['@vehicle'] = json.encode(car)
				})
				TriggerEvent("csskrouble:banPlr", "nigger", source,  "Tried to change car hash (exile_garages)")
				--exports['exile_logs']:SendLog(_source, "CARDEALER: Gracz zhashował sobie auto z: "..result[1].firstmodel..' Na: '..car.model, 'anticheat')
			else
				MySQL.Sync.execute("UPDATE owned_vehicles SET state=@stan, vehicle = @vehicle WHERE plate=@plate", {
					['@plate'] = car.plate,
					['@stan'] = 'stored',
					['@vehicle'] = json.encode(car)
				})
			end
		else
			MySQL.Sync.execute("UPDATE owned_vehicles SET state=@stan, vehicle = @vehicle WHERE plate=@plate", {
				['@plate'] = car.plate,
				['@stan'] = 'stored',
				['@vehicle'] = json.encode(car)
			})
		end
	else
		MySQL.Sync.execute("UPDATE owned_vehicles SET state=@stan, vehicle = @vehicle WHERE plate=@plate", {
			['@plate'] = car.plate,
			['@stan'] = 'stored',
			['@vehicle'] = json.encode(car)
		})
	end
end)

RegisterServerEvent('exile_garages:findVehicle')
AddEventHandler('exile_garages:findVehicle', function(plate)
	local _source = source
	local result = MySQL.Sync.fetchAll("SELECT state FROM owned_vehicles WHERE plate=@plate", { 
		['@plate'] = plate
	})
	if result[1] ~= nil then
		if result[1].state == "anonymous" then
		else
			TriggerClientEvent('exile_garages:findVehicle', -1, plate, _source)
		end
	else
		TriggerClientEvent('exile_garages:findVehicle', -1, plate, _source)
	end
end)

RegisterServerEvent('exile_garages:findVehicleAll')
AddEventHandler('exile_garages:findVehicleAll', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local result = MySQL.Sync.fetchAll("SELECT state, plate FROM owned_vehicles WHERE owner=@owner AND digit=@digit", { 
		['@owner'] = xPlayer.getIdentifier(),
		['@digit'] = xPlayer.getDigit()
	})
	if result ~= nil then
		local countOut = 0
		for i,v in ipairs(result) do
			if v.state ~= "anonymous" and v.state == "pulledout" then
				countOut = countOut + 1
				TriggerClientEvent('exile_garages:findVehicle', -1, v.plate, _source)
				TriggerEvent('flux_garages:updateState', v.plate)
			end
		end
		if countOut == 0 then
			xPlayer.showNotification("~r~Nie masz żadnych pojazdów do odholowania")
		end
	end
end)

RegisterServerEvent('exile_garages:isBusy')
AddEventHandler('exile_garages:isBusy', function(plate, owner)
	TriggerClientEvent('exile_garages:setBusy', owner, plate)
end)

RegisterServerEvent('flux_garages:destroyCar')
AddEventHandler('flux_garages:destroyCar', function(car)
	local xPlayer = ESX.GetPlayerFromId(source)
	local randHours = math.random(12, 24)
	local destroyTime = os.time() + (tonumber(randHours) * 3600)
	local result = MySQL.Sync.fetchAll("SELECT owner, co_owner, co_owner2, vehicle FROM owned_vehicles WHERE plate=@plate", { 
		['@plate'] = car.plate
	})
	
	if result[1] ~= nil then
		if result[1].owner == xPlayer.identifier or result[1].co_owner == xPlayer.identifier or result[1].co_owner2 == xPlayer.identifier then
			MySQL.Sync.execute("UPDATE owned_vehicles SET state=@state, destroyed = @destroyed, vehicle = @vehicle WHERE plate=@plate", {
				['@plate'] = car.plate,
				['@state'] = 'destroyed',
				['@destroyed'] = destroyTime,
				['@vehicle'] = json.encode(car)
			})
			xPlayer.showNotification('~y~Zezłomowałeś ~w~, własny pojazd i ~r~nic nie zarobiłeś')
			--exports['exile_logs']:SendLog(xPlayer.source, "Zezłomowano własny pojazd", 'scrapyard')
		else
			local price = 5000
			local choosenVeh = json.decode(result[1].vehicle)
			local findVeh = exports['esx_vehicleshop']:GetVehicle(choosenVeh.model)
			if findVeh ~= nil then
				price = math.floor((findVeh.price * 4) / 1000)
			end
			MySQL.Sync.execute("UPDATE owned_vehicles SET state=@state, destroyed = @destroyed, vehicle = @vehicle WHERE plate=@plate", {
				['@plate'] = car.plate,
				['@state'] = 'destroyed',
				['@destroyed'] = destroyTime,
				['@vehicle'] = json.encode(car)
			})
			xPlayer.addMoney(price)
			xPlayer.showNotification('~y~Zezłomowałeś pojazd~w~ i zarobiłeś ~g~' .. price .. '$')
			--exports['exile_logs']:SendLog(xPlayer.source, "Zezłomowano pojazd - Gracz zarobił " .. price .. "$", 'scrapyard')
		end
	else
		xPlayer.showNotification("~r~Ten pojazd do nikogo nie należy. Nic nie zarobisz")
		--exports['exile_logs']:SendLog(xPlayer.source, "Zezłomowano pojazd nienależący do nikogo - Nie otrzymano zapłaty", 'scrapyard')
	end
end)

ESX.RegisterServerCallback('flux_garages:checkCar', function(source, cb, plates)
	local xPlayer = ESX.GetPlayerFromId(source)
	local cebulion = false

	local result = MySQL.Sync.fetchAll("SELECT owner, digit, co_owner, co_digit, co_owner2, co_digit2 FROM owned_vehicles WHERE plate=@plate", { 
		['@plate'] = plates.plate
	})

	if not result[1] then
		cb(false)
	else
		if result[1].owner == xPlayer.identifier and result[1].digit == xPlayer.getDigit() then
			cb(1)
		elseif (result[1].co_owner == xPlayer.identifier and result[1].co_digit == xPlayer.getDigit()) or (result[1].co_owner2 == xPlayer.identifier and result[1].co_digit2 == xPlayer.getDigit()) then
			cb(2)
		else
			cb(false)
		end
	end
end)

ESX.RegisterServerCallback('flux_garages:getVehiclesToTow',function(source, cb)	
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local identifier = xPlayer.identifier
	local vehicles = {}
	MySQL.Async.fetchAll("SELECT state, destroyed, plate, vehicle FROM owned_vehicles WHERE ((owner=@identifier AND digit=@digit) or (co_owner = @identifier AND co_digit=@digit) or (co_owner2 = @identifier AND co_digit2=@digit)) AND (state=@state or state=@state2) AND job IS NULL",
	{
		['@identifier'] = identifier,
		['@digit']	= xPlayer.getDigit(),
		['@state'] = "pulledout",
		['@state2'] = "destroyed"
	}, 
	function(data)
		for _,v in pairs(data) do
			if v.state == 'destroyed' then
				local nowTime = os.time()
				local resultTime = v.destroyed
				if resultTime <= nowTime then
					MySQL.Async.execute(
						'UPDATE `owned_vehicles` SET state = @state, destroyed = NULL WHERE plate = @plate',
						{
						  ['@plate'] = v.plate,
						  ['@state'] = 'pulledout'
						}
					)
					local vehicle = json.decode(v.vehicle)
					table.insert(vehicles, vehicle)
				end
			else
				local vehicle = json.decode(v.vehicle)
				table.insert(vehicles, vehicle)
			end
		end
		cb(vehicles)
	end)
end)

ESX.RegisterServerCallback('flux_garages:getTakedVehicles', function(source, cb)
	local vehicles = {}
	MySQL.Async.fetchAll("SELECT vehicle FROM owned_vehicles WHERE state = @state",
	{ ['@state'] = 'policeParking'}, 
	function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(vehicles, vehicle)
		end
		cb(vehicles)
	end)
end)

RegisterServerEvent('flux_garages:removeCarFromPoliceParking')
AddEventHandler('flux_garages:removeCarFromPoliceParking', function(plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	if plate ~= nil then
		MySQL.Async.execute(
			'UPDATE `owned_vehicles` SET state = @state WHERE plate = @plate',
			{
			  ['@plate'] = plate,
			  ['@state'] = 'pulledout'
			}
		)
		TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~Pojazd wyciągnięty")
		exports['exile_logs']:SendLog(source, 'WYCIĄGNIĘTO: Auto z parkingu policyjnego rej: '..plate, 'policeparking')
	end
end)

RegisterServerEvent('flux_garages:addCarFromPoliceParking')
AddEventHandler('flux_garages:addCarFromPoliceParking', function(plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	if plate ~= nil then
		MySQL.Async.execute(
			'UPDATE `owned_vehicles` SET state = @state WHERE plate = @plate',
			{
			  ['@plate'] = plate,
			  ['@state'] = 'policeParking',
			}
		)
		exports['exile_logs']:SendLog(source, 'WŁOŻONO: Auto na parking policyjny rej: '..plate, 'policeparking')
	end
end)

ESX.RegisterServerCallback('flux_garages:checkVehProps', function (source, cb, plate)
	MySQL.Async.fetchAll(
	'SELECT vehicle FROM owned_vehicles WHERE plate = @plate',
	{ 
		['@plate'] = plate
	},
	function (result2)
		if result2[1] then
			cb(json.decode(result2[1].vehicle))
		end
	end
	)
end)

ESX.RegisterServerCallback('flux_garages:checkMoney', function(source, cb, pedal)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local HasInsurance = exports['esx_exilemenu']:CheckInsuranceLSC(xPlayer.job.name)

	TriggerEvent('esx_license:checkLicense', _source, "oc_insurance", function(has)
		if has == true or HasInsurance then
			if not pedal then
				if xPlayer.getMoney() >= 2500 then
					xPlayer.removeMoney(2500)
					TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
						account.addAccountMoney(1250)
					end)
					cb(1)
				elseif xPlayer.getAccount('bank').money >= 2500 then
					xPlayer.removeAccountMoney('bank', 2500)
					TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
						account.addAccountMoney(1250)
					end)
					cb(1)
				else
					cb(2)
				end
			else
				if xPlayer.getMoney() >= 15000 then
					xPlayer.removeMoney(15000)
					TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
						account.addAccountMoney(7500)
					end)
					cb(1)
				elseif xPlayer.getAccount('bank').money >= 15000 then
					xPlayer.removeAccountMoney('bank', 15000)
					TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
						account.addAccountMoney(7500)
					end)
					cb(1)
				else
					cb(4)
				end
			end	
		else
			if not pedal then
				if xPlayer.getMoney() >= 5000 then
					xPlayer.removeMoney(5000)
					TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
						account.addAccountMoney(2500)
					end)
					cb(1)
				elseif xPlayer.getAccount('bank').money >= 5000 then
					xPlayer.removeAccountMoney('bank', 2500)
					TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
						account.addAccountMoney(2500)
					end)
					cb(1)
				else
					cb(3)
				end
			else
				if xPlayer.getMoney() >= 30000 then
					xPlayer.removeMoney(30000)
					TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
						account.addAccountMoney(1500)
					end)
					cb(1)
				elseif xPlayer.getAccount('bank').money >= 30000 then
					xPlayer.removeAccountMoney('bank', 30000)
					TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
						account.addAccountMoney(15000)
					end)
					cb(1)
				else
					cb(5)
				end
			end	
		end
	end)	
end)

RegisterServerEvent('flux_garages:buyContract')
AddEventHandler('flux_garages:buyContract', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= 15000 then
		xPlayer.removeMoney(15000)
		xPlayer.addInventoryItem('contract', 1)
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_doj', function(account)
			account.addAccountMoney(7500)
		end)
	else
		xPlayer.showNotification("~r~Nie masz wystarczająco pieniędzy!")
	end
end)

------------------------------
ESX.RegisterServerCallback('flux_garages:checkIfPlayerIsOwner', function (source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier
	MySQL.Async.fetchAll(
	'SELECT owner FROM owned_vehicles WHERE owner = @owner AND digit = @digit AND plate = @plate',
	{ 
		['@owner'] = identifier,
		['@digit'] = xPlayer.getDigit(),
		['@plate'] = plate
	},
	function (result2)
		if result2[1] ~= nil then
			cb(true)
		else
			cb(false)
		end
	end
	)
end)
RegisterServerEvent('flux_garages:setSubowner')
AddEventHandler('flux_garages:setSubowner', function(plate, tID)
	local xPlayer = ESX.GetPlayerFromId(source)
	local subPrice = 200000	
	local tPlayer = ESX.GetPlayerFromId(tID)
	local identifier = xPlayer.identifier
	local tIdentifier = tPlayer.identifier
	
	MySQL.Async.fetchAll(
		'SELECT owner, co_owner, co_owner2, vehicle FROM owned_vehicles WHERE plate = @plate',
		{
			['@plate'] = plate
		},
		function(result)
			if result ~= nil then
				if result[1].owner == identifier then
					if result[1].co_owner ~= nil and result[1].co_owner2 ~= nil then
						xPlayer.showNotification("~r~Ten pojazd posiada maksymalną liczbę współwłaścicieli!")
					else
						local choosenVeh = json.decode(result[1].vehicle)
						local findVeh = exports['esx_vehicleshop']:GetVehicle(choosenVeh.model)
						if findVeh ~= nil then
							subPrice = math.floor(findVeh.price * 0.05)
						end
						if xPlayer.getMoney() < subPrice then
							xPlayer.showNotification("~r~Dodanie współwłaściciela w tym aucie kosztuje " .. subPrice .. "$")
						else
							if result[1].co_owner == nil then
								MySQL.Sync.execute(
									'UPDATE owned_vehicles SET co_owner = @co_owner, co_digit = @co_digit WHERE plate = @plate',
									{
										['@co_owner']   = tIdentifier,
										['@co_digit']	= tPlayer.getDigit(),
										['@plate'] = plate,
									}
								)
								TriggerClientEvent('esx:showNotification', xPlayer.source,"~g~Dodałeś nowego współwłaściciela")
								TriggerClientEvent('esx:showNotification', tPlayer.source, "~g~Zostałeś współwłaścicielem pojazdu o numerach " .. plate)
							elseif result[1].co_owner2 == nil then
								MySQL.Sync.execute(
									'UPDATE owned_vehicles SET co_owner2 = @co_owner2, co_digit2 = @co_digit2 WHERE plate = @plate',
									{
										['@co_owner2']   = tIdentifier,
										['@co_digit2']	= tPlayer.getDigit(),
										['@plate'] = plate,
									}
								)
								TriggerClientEvent('esx:showNotification', xPlayer.source,"~g~Dodałeś nowego współwłaściciela")
								TriggerClientEvent('esx:showNotification', tPlayer.source, "~g~Zostałeś współwłaścicielem pojazdu o numerach " .. plate)
							end
							xPlayer.removeMoney(subPrice)
						end
					end
				else
					TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Nie jesteś właścicielem tego pojazdu!")
				end
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Taki pojazd nie istnieje!")
			end
		end
	)
end)

ESX.RegisterServerCallback('flux_garages:getSubOwners', function(source,cb,plate) 
	MySQL.Async.fetchAll(
		'SELECT co_owner FROM owned_vehicles WHERE plate = @plate',
		{
			['@plate'] = plate,
		},
		function(result)
		if result[1] ~= nil then
			if result[1].co_owner ~= nil then
				who = result[1].co_owner
				MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier',
					{
						['@identifier'] = who,
					},
					function(dane)
						cb(dane[1], result[1])
					end
				)
			else

				cb(nil,nil)
			end
		end
	end)
end)

ESX.RegisterServerCallback('flux_garages:getSubOwners2', function(source,cb,plate) 
	MySQL.Async.fetchAll(
		'SELECT co_owner2 FROM owned_vehicles WHERE plate = @plate',
		{
			['@plate'] = plate,
		},
		function(result)
		if result[1] ~= nil then
			if result[1].co_owner2 ~= nil then
				who = result[1].co_owner2
				MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier',
					{
						['@identifier'] = who,
					},
					function(dane)
						cb(dane[1], result[1])
					end
				)
			else

				cb(nil,nil)
			end
		end
	end)
end)

RegisterServerEvent('flux_garages:deleteSubowner')
AddEventHandler('flux_garages:deleteSubowner', function(plate, who)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll(
		'SELECT owner FROM owned_vehicles WHERE plate = @plate',
		{
			['@plate'] = plate,
		},
		function(result)
			if result[1] ~= nil then
				if xPlayer.identifier ~= result[1].owner then
					TriggerEvent("csskrouble:banPlr", "nigger", source,  "Tried to delete someones car (exile_garages)")
					--exports['exile_logs']:SendLog(source, "Garages: Niepoprawny license check, gracz próbował usunąć komuś auto. [Cheater: "..xPlayer.identifier.." / pojazd należy do: "..result[1].owner.."]", 'anticheat')
					return
				end
			end
		end
	)
	MySQL.Sync.execute(
		'UPDATE owned_vehicles SET co_owner = NULL, co_digit = 0 WHERE owner = @owner AND plate = @plate',
		{
			['@owner']   = xPlayer.identifier,
			['@plate'] 	 = plate
		}
	)
	TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~Usunięto ~s~pierwszego~g~ współwłaściciela auta ~s~" .. plate)
end)

RegisterServerEvent('flux_garages:deleteSubowner2')
AddEventHandler('flux_garages:deleteSubowner2', function(plate, who)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll(
		'SELECT owner FROM owned_vehicles WHERE plate = @plate',
		{
			['@plate'] = plate,
		},
		function(result)
			if result[1] ~= nil then
				if xPlayer.identifier ~= result[1].owner then
					TriggerEvent("csskrouble:banPlr", "nigger", source,  "Tried to delete someones car (exile_garages)")
					--exports['exile_logs']:SendLog(source, "Garages: Niepoprawny license check, gracz próbował usunąć komuś auto. [Cheater: "..xPlayer.identifier.." / pojazd należy do: "..result[1].owner.."]", 'anticheat')
					return
				end
			end
		end
	)
	MySQL.Sync.execute(
		'UPDATE owned_vehicles SET co_owner2 = NULL, co_digit2 = 0 WHERE owner = @owner AND plate = @plate',
		{
			['@owner']   = xPlayer.identifier,
			['@plate'] 	 = plate
		}
	)
	TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~Usunięto ~s~drugiego~g~ współwłaściciela auta ~s~" .. plate)
end)


RegisterServerEvent('esx_clothes:sellVehicle')
AddEventHandler('esx_clothes:sellVehicle', function(target, plate, model)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local _target = target
	local tPlayer = ESX.GetPlayerFromId(_target)
	local result = MySQL.Sync.fetchAll('SELECT owner FROM owned_vehicles WHERE owner = @identifier AND digit = @digit AND plate = @plate', {
			['@identifier'] = xPlayer.identifier,
			['@digit']	= xPlayer.getDigit(),
			['@plate'] = plate
		})
	if result[1] ~= nil then
		MySQL.Async.execute('UPDATE owned_vehicles SET owner = @target, digit = @tdigit WHERE owner = @owner AND digit = @digit AND plate = @plate', {
			['@owner'] = xPlayer.identifier,
			['@digit'] = xPlayer.getDigit(),
			['@plate'] = plate,
			['@target'] = tPlayer.identifier,
			['@tdigit'] = tPlayer.getDigit()
		}, function (rowsChanged)
			if rowsChanged ~= 0 then
				TriggerClientEvent('esx_contract:showAnim', _source)
				Wait(22000)
				TriggerClientEvent('esx_contract:showAnim', _target)
				Wait(22000)
				TriggerClientEvent('esx:showNotification', _source, 'Sprzedales samochód o numerach: '..plate)
				TriggerClientEvent('esx:showNotification', _target, 'Kupiłeś samochód o numerach: '..plate)
				exports['exile_logs']:SendLog(_source, "Sprzedano pojazd:\nModel: " .. model .. "\nNr. rej: " .. plate .. "\nNowy właścicel: [" .. _target .. "] " .. GetPlayerName(_target), 'contract')
				xPlayer.removeInventoryItem('contract', 1)
			end
		end)
	else
		TriggerClientEvent('esx:showNotification', _source, 'To nie twój samochód')
	end
end)

ESX.RegisterUsableItem('contract', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	TriggerClientEvent('esx_contract:getVehicle', _source)
end)

ESX.RegisterServerCallback('xfsd-vehstatus:getVehicles', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local vehicules = {}

	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @identifier AND digit = @digit OR co_owner = @identifier AND co_digit = @digit OR co_owner2 = @identifier AND co_digit2 = @digit",{
		['@identifier'] = xPlayer.getIdentifier(),
		['@digit'] = xPlayer.getDigit()
	}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			local state = v.state
			local plate = v.plate
			table.insert(vehicules, {
				vehicle = vehicle,
				plate = plate,
				state = state
			})
		end
		cb(vehicules)
	end)
end)