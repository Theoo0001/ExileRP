ESX  = nil
local Categories, Vehicles, BCategories, Boats, PCategories, Planes = {}, {}, {}, {}, {}, {}

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

local date = os.date('*t')
if date.month < 10 then date.month = '0' .. tostring(date.month) end
if date.day < 10 then date.day = '0' .. tostring(date.day) end
if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
if date.min < 10 then date.min = '0' .. tostring(date.min) end
if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' o godz: ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')

CreateThread(function()
	local char = Config.PlateLetters
	char = char + Config.PlateNumbers
	if Config.PlateUseSpace then char = char + 1 end

	if char > 8 then
		--print(('esx_vehicleshop: ^1WARNING^7 plate character count reached, %s/8 characters.'):format(char))
	end
end)

function RemoveOwnedVehicle(plate)
	MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	})
end

function GetVehicle(model)
	local vehicleData = nil
	
	for i=1, #Vehicles, 1 do
		if GetHashKey(Vehicles[i].model) == model then
			vehicleData = Vehicles[i]
			break
		end
	end

	if vehicleData == nil then
		for i=1, #Boats, 1 do
			if GetHashKey(Boats[i].model) == model then
				vehicleData = Boats[i]
				break
			end
		end
	end
	
	if vehicleData == nil then
		for i=1, #Planes, 1 do
			if GetHashKey(Planes[i].model) == model then
				vehicleData = Planes[i]
				break
			end
		end
	end
	
	return vehicleData
end

MySQL.ready(function()
	Categories     = MySQL.Sync.fetchAll('SELECT * FROM vehicle_categories')
	local vehicles = MySQL.Sync.fetchAll('SELECT * FROM vehicles ORDER BY price ASC')
	BCategories    = MySQL.Sync.fetchAll('SELECT * FROM boats_categories')
	local boats    = MySQL.Sync.fetchAll('SELECT * FROM boats ORDER BY price ASC')
	PCategories    = MySQL.Sync.fetchAll('SELECT * FROM planes_categories')
	local planes   = MySQL.Sync.fetchAll('SELECT * FROM planes ORDER BY price ASC')

	for i=1, #vehicles, 1 do
		local vehicle = vehicles[i]

		for j=1, #Categories, 1 do
			if Categories[j].name == vehicle.category then
				vehicle.categoryLabel = Categories[j].label
				break
			end
		end

		table.insert(Vehicles, vehicle)
	end

	for i=1, #boats, 1 do
		local boat = boats[i]

		for j=1, #BCategories, 1 do
			if BCategories[j].name == boat.category then
				boat.categoryLabel = BCategories[j].label
				break
			end
		end

		table.insert(Boats, boat)
	end

	for i=1, #planes, 1 do
		local plane = planes[i]

		for j=1, #PCategories, 1 do
			if PCategories[j].name == plane.category then
				plane.categoryLabel = PCategories[j].label
				break
			end
		end

		table.insert(Planes, plane)
	end

	TriggerClientEvent('esx_vehicleshop:sendCategories', -1, Categories, BCategories, PCategories)
	TriggerClientEvent('esx_vehicleshop:sendVehicles', -1, Vehicles, Boats, Planes)
end)

ESX.RegisterServerCallback('esx_vehiclekatalog:payTest', function (source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer.getMoney() >= 5000 then
		xPlayer.removeMoney(5000)
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('exile_vehicles:setOwned')
AddEventHandler('exile_vehicles:setOwned', function (vehicleProps, auto, cena, vehicleType)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, digit, type) VALUES (@owner, @plate, @vehicle, @digit, @type)',
	{
		['@owner']   = xPlayer.identifier,
		['@plate']   = vehicleProps.plate,
		['@vehicle'] = json.encode(vehicleProps),
		['@digit'] = xPlayer.getDigit(),
		['@type'] = vehicleType
	}, function (rowsChanged)
		TriggerClientEvent('esx:showNotification', _source, 'Zakupiono pojazd ~o~['.. vehicleProps.plate ..']~s~ za kwote ~g~'.. cena ..'$')
	end)

	local vehicleData = nil

	for i=1, #Vehicles, 1 do
		if Vehicles[i].model == vehicleModel then
			vehicleData = Vehicles[i]
			break
		end
	end

	if vehicleData == nil then
		for i=1, #Boats, 1 do
			if Boats[i].model == vehicleModel then
				vehicleData = Boats[i]
				break
			end
		end
	end

	if vehicleData == nil then
		for i=1, #Planes, 1 do
			if Planes[i].model == vehicleModel then
				vehicleData = Planes[i]
				break
			end
		end
	end
	
	exports['exile_logs']:SendLog(source, "Zakupiono pojazd: \nModel: " .. auto .. "\nNr. rej.: " .. vehicleProps.plate .. "\nCena: " .. cena .. "$", 'cardealer', '3066993')
end)

ESX.RegisterServerCallback('esx_vehicleshop:getCategories', function (source, cb)
	local AllCategories = {
		Vehicles = Categories,
		Boats = BCategories,
		Planes = PCategories
	}
	cb(AllCategories)
end)

ESX.RegisterServerCallback('esx_vehicleshop:getVehicles', function (source, cb)
	local AllVehicles = {
		Vehicles = Vehicles,
		Boats = Boats,
		Planes = Planes
	}
	cb(AllVehicles)
end)

ESX.RegisterServerCallback('esx_vehicleshop:buyVehicle', function (source, cb, vehicleModel)
	local xPlayer     = ESX.GetPlayerFromId(source)
	local vehicleData = nil
	local vehPrice = nil
	
	for i=1, #Vehicles, 1 do
		if Vehicles[i].model == vehicleModel then
			vehicleData = Vehicles[i]
			break
		end
	end
	
	if xPlayer.job.name == 'cardealer' then
		vehPrice = math.floor((vehicleData.price * 92) / 100)
	else
		vehPrice = vehicleData.price
	end
	
	if xPlayer.getMoney() >= vehPrice then
		xPlayer.removeMoney(vehPrice)
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_vehicleshop:buyBoat', function (source, cb, vehicleModel)
	local xPlayer     = ESX.GetPlayerFromId(source)
	local vehicleData = nil
	local vehPrice = nil
	
	for i=1, #Boats, 1 do
		if Boats[i].model == vehicleModel then
			vehicleData = Boats[i]
			break
		end
	end
	
	vehPrice = vehicleData.price
	
	if xPlayer.getMoney() >= vehPrice then
		xPlayer.removeMoney(vehPrice)
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_vehicleshop:buyPlane', function (source, cb, vehicleModel)
	local xPlayer     = ESX.GetPlayerFromId(source)
	local vehicleData = nil
	local vehPrice = nil
	
	for i=1, #Planes, 1 do
		if Planes[i].model == vehicleModel then
			vehicleData = Planes[i]
			break
		end
	end
	
	vehPrice = vehicleData.price
	
	if xPlayer.getMoney() >= vehPrice then
		xPlayer.removeMoney(vehPrice)
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_vehicleshop:getCommercialVehicles', function (source, cb)
	MySQL.Async.fetchAll('SELECT vehicle, price FROM cardealer_vehicles ORDER BY vehicle ASC', {}, function (result)
		local vehicles = {}

		for i=1, #result, 1 do
			table.insert(vehicles, {
				name  = result[i].vehicle,
				price = result[i].price
			})
		end

		cb(vehicles)
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:resellVehicle', function (source, cb, plate, model, auto)
	local resellPrice = 0
	-- calculate the resell price
	for i=1, #Vehicles, 1 do
		if GetHashKey(Vehicles[i].model) == model then
			resellPrice = ESX.Math.Round(Vehicles[i].price / 100 * Config.ResellPercentage)
			break
		end
	end

	if resellPrice == 0 then
		cb(false)
	end
			local _source = source
			local xPlayer = ESX.GetPlayerFromId(source)
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
				['@owner'] = xPlayer.identifier,
				['@plate'] = plate
			}, function (result)
				if result[1] then -- does the owner match?
					local vehicle = json.decode(result[1].vehicle)
					if vehicle.model == model then
						if vehicle.plate == plate then
							xPlayer.addMoney(resellPrice)
							RemoveOwnedVehicle(plate)
							TriggerClientEvent('esx:showNotification', _source, 'Sprzedano pojazd ~o~['.. vehicle.plate ..']~s~ za kwote ~g~'.. resellPrice ..'$')
							cb(true)
							exports['exile_logs']:SendLog(source, "Sprzedał: " ..auto.. "\nRejestracja: "..plate.." \nCena: "..resellPrice, 'broker', '5793266')
						else
							cb(false)
						end
					else
						cb(false)
					end
				end
			end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:isPlateTaken', function (source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function (result)
		cb(result[1] ~= nil)
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:retrieveJobVehicles', function (source, cb, type)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND type = @type AND job = @job', {
		['@owner'] = xPlayer.identifier,
		['@type'] = type,
		['@job'] = xPlayer.job.name
	}, function (result)
		cb(result)
	end)
end)

RegisterServerEvent('esx_vehicleshop:setJobVehicleState')
AddEventHandler('esx_vehicleshop:setJobVehicleState', function(plate, state)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE plate = @plate AND job = @job', {
		['@stored'] = state,
		['@plate'] = plate,
		['@job'] = xPlayer.job.name
	}, function(rowsChanged)
		if rowsChanged == 0 then
			--print(('esx_vehicleshop: %s exploited the garage!'):format(xPlayer.identifier))
		end
	end)
end)


TriggerEvent('cron:runAt', 22, 00, PayRent)
