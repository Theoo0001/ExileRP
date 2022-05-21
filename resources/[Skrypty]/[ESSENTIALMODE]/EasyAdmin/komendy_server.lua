ESX = nil
TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

ESX.RegisterCommand('goto', {'trialsupport', 'support', 'mod', 'admin', 'superadmin'}, function(xPlayer, args, showError)
    if args.id then
        local xTarget = ESX.GetPlayerFromId(args.id)
		if xPlayer and xTarget then
			local targetCoords = xTarget.coords
			xPlayer.setCoords(targetCoords)
			exports['exile_logs']:SendLog(xPlayer.source, "Użyto komendy /goto do gracza: " .. args.id, "admin_commands2")
        end
    end
end, true, {help = "Teleportuj się do gracza", validate = true, arguments = {
    {name = 'id', help = "ID gracza", type = 'number'},
}})

ESX.RegisterCommand('bring', {'trialsupport', 'support', 'mod', 'admin', 'superadmin'}, function(xPlayer, args, showError)
    if args.id then
        local xTarget = ESX.GetPlayerFromId(args.id)
        if xPlayer and xTarget then
            local targetCoords = xPlayer.coords
			xTarget.setCoords(targetCoords)
			exports['exile_logs']:SendLog(xPlayer.source, "Użyto komendy /bring na graczu: " .. args.id, "admin_commands2")
        end
    end
end, true, {help = "Teleportuj gracza do siebie", validate = true, arguments = {
    {name = 'id', help = "ID gracza", type = 'number'},
}})

ESX.RegisterCommand('slap', {'best'}, function(xPlayer, args, showError)
    if args.id then
        local xTarget = ESX.GetPlayerFromId(args.id)
        if xPlayer and xTarget then
			local xTarget = ESX.GetPlayerFromId(args.id)
			TriggerClientEvent('EasyAdmin:Slap', xTarget.source)
			exports['exile_logs']:SendLog(xPlayer.source, "Użyto komendy /slap " .. xTarget.source, "admin_commands")
        end
    end
end, true, {help = "Wyjeb gracza w kosmos", validate = true, arguments = {
    {name = 'id', help = "ID gracza", type = 'number'},
}})

ESX.RegisterCommand('slay', {'best', 'mod', 'admin', 'superadmin'}, function(xPlayer, args, showError)
    if args.id then
        local xTarget = ESX.GetPlayerFromId(args.id)
        if xPlayer and xTarget then
			local xTarget = ESX.GetPlayerFromId(args.id)
            TriggerClientEvent('EasyAdmin:Slay', xTarget.source)
        end
    end
end, true, {help = "Zabij gracza", validate = true, arguments = {
    {name = 'id', help = "ID gracza", type = 'number'},
}})

ESX.RegisterCommand('tpp', {'support', 'mod', 'admin', 'superadmin'}, function(xPlayer, args, showError)
    if args.steamid and args.targetid then
        local xPlayer = ESX.GetPlayerFromId(args.steamid)
        local xPlayerTarget = ESX.GetPlayerFromId(args.targetid)
        if xPlayer and xPlayerTarget then
            TriggerClientEvent('EasyAdmin:Teleport', xPlayer.source, xPlayerTarget.source)
			exports['exile_logs']:SendLog(xPlayer.source, "Użyto komendy /tpp gracza: " .. args.steamid .. " do gracza: " .. args.targetid, "admin_commands2")
        end
    end
end, true, {help = "Teleportuj gracza do gracza", validate = true, arguments = {
    {name = 'steamid', help = "ID gracza 1", type = 'number'},
    {name = 'targetid', help = "ID gracza 2", type = 'number'}
}})

ESX.RegisterCommand('savecar', {'admin', 'superadmin', 'best'}, function(xPlayer, args, showError)
	if args.targetid ~= nil then
		local tPlayer = ESX.GetPlayerFromId(args.targetid)
		if xPlayer and tPlayer then
			TriggerClientEvent('EasyAdmin:GetCurrentCar', tPlayer.source, 1337)
			exports['exile_logs']:SendLog(xPlayer.source, "Użyto komendy /savecar " .. args.targetid, "car")
		end
	end
end, true, {help = "Przypisz auto w którym siedzi gracz do niego", validate = true, arguments = {
    {name = 'targetid', help = "ID gracza", type = 'number'},
}})

ESX.RegisterCommand('updateplayer', {'mod', 'admin', 'superadmin'}, function(xPlayer, args, showError)
	if args.license ~= nil and args.var ~= nil and args.newVar then
		MySQL.Async.execute('UPDATE users SET ' .. args.var .. ' = @newVar WHERE identifier = @identifier',{ 
			['@identifier'] = args.license,
			['@newVar'] = args.newVar
		})

		MySQL.Async.fetchAll('SELECT digit FROM users WHERE identifier = @identifier', {
			['@identifier'] = args.license
		}, function(result)
			if result then
				MySQL.Async.execute('UPDATE characters SET ' .. args.var .. ' = @newVar WHERE identifier = @identifier AND digit = @digit',{ 
					['@identifier'] = args.license,
					['@newVar'] = args.newVar,
					['@digit'] = result[1].digit
				})
			end
		end)
	end
end, true, {help = "Zmień dane gracza", validate = true, arguments = {
	{name = 'license', help = "Licencja steam", type = 'string'},
    {name = 'var', help = "Zmienna do zmiany w bazie", type = 'string'},
    {name = 'newVar', help = "Na jaką zmienną zmieniamy (np. nowe imię)", type = 'string'}
}})

ESX.RegisterCommand('updateplate', {'admin', 'superadmin', 'best'}, function(xPlayer, args, showError)
	if args.oldPlate ~= nil and args.newPlate ~= nil then
		local oldPlate = string.upper(args.oldPlate)
		local newPlate = string.upper(args.newPlate)
		MySQL.Async.execute('UPDATE owned_vehicles SET plate = @newPlate, vehicle = JSON_SET(vehicle, "$.plate", @newPlate) WHERE plate = @plate',{ 
			['@plate'] = oldPlate,
			['@newPlate'] = newPlate
		})
		exports['exile_logs']:SendLog(xPlayer.source, "Użyto komendy /updateplate " .. oldPlate .. " " .. newPlate, "car")
	end
end, true, {help = "Zmień rejestrację auta", validate = true, arguments = {
    {name = 'oldPlate', help = "Stara rejestracja w cudzysłowiu", type = 'string'},
    {name = 'newPlate', help = "Nowa rejestracja w cudzysłowiu", type = 'string'}
}})


ESX.RegisterCommand('delcar', {'superadmin', 'best'}, function(xPlayer, args, showError)
	if args.Plate ~= nil then
		if xPlayer then
			local Plate = string.upper(args.Plate)
			MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate',{ 
				['@plate'] = Plate
			})
			exports['exile_logs']:SendLog(xPlayer.source, "Użyto komendy /delcar "..Plate, "car")
		else
			local Plate = string.upper(args.Plate)
			MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate',{ 
				['@plate'] = Plate
			})
		end
	end
end, true, {help = "Usun auto", validate = true, arguments = {
    {name = 'Plate', help = "Rejestracja pojazdu", type = 'string'},
}})


ESX.RegisterCommand('givecar', {'admin', 'superadmin', 'best'}, function(xPlayer, args, showError)
    if args.steamid and args.targetid then
		local xPlayer = ESX.GetPlayerFromId(args.steamid)
		if xPlayer then
			TriggerClientEvent('esx:spawnVehicle', args.steamid, args.targetid)
			exports['exile_logs']:SendLog(xPlayer.source, "Użyto komendy /givecar o modelu: " .. args.targetid .. " dla gracza o id: " .. args.steamid, "car")
		end
	end
end, true, {help = "Daj auto", validate = true, arguments = {
    {name = 'steamid', help = "SteamID zaczynające się od steam:11", type = 'string'},
    {name = 'targetid', help = "SteamID zaczynające się od steam:11", type = 'string'}
}})

ESX.RegisterCommand('cleareq', {'mod', 'admin', 'superadmin', 'best'}, function(xPlayer, args, showError)
    if args.steamid then
		MySQL.Async.execute("UPDATE users SET inventory = '[]', accounts = JSON_SET(accounts, '$.money', 0) WHERE identifier = @identifier",{
			['@identifier'] = args.steamid
		})
		MySQL.Async.execute("UPDATE users SET accounts = JSON_SET(accounts, '$.black_money', 0) WHERE identifier = @identifier",{
			['@identifier'] = args.steamid
		})
	end
end, true, {help = "Wyczyść ekwipunek", validate = true, arguments = {
    {name = 'steamid', help = "Licencja gracza (działa tylko na aktywną postać!)", type = 'string'},
}})

ESX.RegisterCommand('admins', {'trialsupport', 'support', 'mod', 'admin', 'superadmin', 'best'}, function(xPlayerr, args, showError)
	local xPlayers = ESX.GetPlayers()
	local admins = {}

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.group == "trialsupport" or xPlayer.group == "support" or xPlayer.group == "mod" or xPlayer.group == "admin" or xPlayer.group == "superadmin" or xPlayer.group == "dev" or xPlayer.group == "best" then
			table.insert(admins, {label="["..xPlayer.source.."] "..GetPlayerName(xPlayer.source), value="admin"..i})
		end	
	end
	TriggerClientEvent("EasyAdmin:adminList", xPlayerr.source, admins)
end, true, {help = "Sprawdź listę administracji"})

--- KOMENDA NA USUWANIE POSTACI - WSZYSTKO PONIŻEJ
local delchartables = { -- Z TABELĄ DIGIT
    { "users", "identifier" },
    { "characters", "identifier" },
    { "owned_properties", "owner" },
    { "owned_vehicles", "owner" },
	{ "user_licenses", "owner" },
	{ "lscmtablet_history", "owner" },
	{ "emstablet_history", "owner" },
}

local delchartables2 = { -- BEZ TABELI DIGIT
	{ "jail", "identifier" },
	{ "lspd_user_judgments", "userId" }, 
}

ESX.RegisterCommand('delchar', {'admin', 'superadmin', 'best'}, function(xPlayer, args, showError)
	if args.steamid and args.digitid then
		MySQL.Async.fetchAll('SELECT digit FROM characters WHERE identifier = @identifier', {
			['@identifier'] = args.steamid
		}, function(result)
			if result[1] then
				if tonumber(result[1].digit) == tonumber(args.digitid) then
					for i in pairs(delchartables) do
						MySQL.Async.execute('DELETE FROM ' .. delchartables[i][1] .. ' WHERE ' .. delchartables[i][2] .. ' = "' .. args.steamid .. '" AND digit = ' .. args.digitid .. ';',{ 
						})
					end
					for i in pairs(delchartables2) do
						MySQL.Async.execute('DELETE FROM ' .. delchartables2[i][1] .. ' WHERE ' .. delchartables2[i][2] .. ' = "' .. args.steamid .. '";',{ 
						})
					end
					MySQL.Async.fetchAll('SELECT digit, accounts, inventory, skin, job, job_level, job_grade, job_id, hiddenjob, hiddenjob_grade, position, firstname, lastname, dateofbirth, sex, height, status, isDead, phone_number, tattoos FROM characters WHERE identifier = @identifier', {
						['@identifier'] = args.steamid
					}, function(swap)
						if swap[1] then
							MySQL.Async.execute("UPDATE users SET digit = @digit, accounts = @accounts, inventory = @inventory, skin = @skin, job = @job, job_grade = @job_grade, job_level = @job_level, job_id = @job_id, hiddenjob = @hiddenjob, hiddenjob_grade = @hiddenjob_grade, position = @position, firstname = @firstname, lastname = @lastname, dateofbirth = @dateofbirth, sex = @sex, height = @height, status = @status, isDead = @isDead, phone_number = @phone_number, tattoos = @tattoos WHERE identifier = @identifier", {
								['@identifier'] = args.steamid,
								['@digit'] = swap[1].digit,
								['@accounts'] = swap[1].accounts,
								['@inventory'] = swap[1].inventory,
								['@skin'] = swap[1].skin,
								['@job'] = swap[1].job,
								['@job_level'] = swap[1].job_level,
								['@job_grade'] = swap[1].job_grade,
								['@job_id'] = swap[1].job_id,
								['@hiddenjob'] = swap[1].hiddenjob,
								['@hiddenjob_grade'] = swap[1].hiddenjob_grade,
								['@position'] = swap[1].position,
								['@firstname'] = swap[1].firstname,
								['@lastname'] = swap[1].lastname,
								['@dateofbirth'] = swap[1].dateofbirth,
								['@sex'] = swap[1].sex,
								['@height'] = swap[1].height,
								['@status'] = swap[1].status,
								['@isDead'] = swap[1].isDead,
								['@phone_number'] = swap[1].phone_number,
								['@tattoos'] = swap[1].tattoos
							})
						end
					end)
				elseif tonumber(result[1].digit) ~= tonumber(args.digitid) then
					for i in pairs(delchartables) do
						MySQL.Async.execute('DELETE FROM ' .. delchartables[i][1] .. ' WHERE ' .. delchartables[i][2] .. ' = "' .. args.steamid .. '" AND digit = ' .. args.digitid .. ';',{ 
						})
					end
				end
			end
		end)
	end
end, true, {help = "Usun postac", validate = true, arguments = {
    {name = 'steamid', help = "Licencja steam", type = 'string'},
    {name = 'digitid', help = "Numer postaci", type = 'number'}
}})

RegisterServerEvent('EasyAdmin:SaveCar')
AddEventHandler('EasyAdmin:SaveCar', function(vehicleProps, recieved)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if recieved == 1337 then
		MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, digit) VALUES (@owner, @plate, @vehicle, @digit)',
		{
			['@owner']   = xPlayer.identifier,
			['@plate']   = vehicleProps.plate,
			['@vehicle'] = json.encode(vehicleProps),
			['@digit'] = xPlayer.getDigit()
		}, function (rowsChanged)
			TriggerClientEvent('esx:showNotification', _source, "~g~Pojazd należy teraz do Ciebie")
		end)
	else
		exports['exile_logs']:SendLog(_source, "Próbwa wywołania eventu SaveCar", "anticheat")
	end
end)




RegisterCommand('popierdolilocie', function(source, args, user)
	if source == 0 then
		TriggerClientEvent('exile_admin:crash', tonumber(args[1]))
	else
		local xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer.group == 'best' then
			if args[1] ~= nil then
				if GetPlayerName(tonumber(args[1])) ~= nil then
					TriggerClientEvent('exile_admin:crash', tonumber(args[2]))
					--exports['exile_logs']:SendLog(source, "Użyto komendy /crash " .. tonumber(args[2]), "admin_commands")
				end
			else
				TriggerClientEvent('exile_admin:crash', source)
				--exports['exile_logs']:SendLog(source, "Użyto komendy /crash", "admin_commands")
			end
		else
			xPlayer.showNotification('~r~Nie posiadasz permisji')
		end
	end
end, false)

ESX.RegisterCommand('przywrocpostac', {'mod', 'admin', 'superadmin'}, function(xPlayer, args, showError)
	if args.newlicense ~= nil and args.oldlicense ~= nil then
		MySQL.Async.execute('UPDATE users SET identifier = @newlicense WHERE identifier = @oldlicense',{ 
			['@newlicense'] = args.newlicense,
			['@oldlicense'] = args.oldlicense
		})
        MySQL.Async.execute('UPDATE addon_account_data SET owner = @newlicense WHERE owner = @oldlicense',{ 
			['@newlicense'] = args.newlicense,
			['@oldlicense'] = args.oldlicense
		})
        MySQL.Async.execute('UPDATE addon_inventory_items SET owner = @newlicense WHERE owner = @oldlicense',{ 
			['@newlicense'] = args.newlicense,
			['@oldlicense'] = args.oldlicense
		})
        MySQL.Async.execute('UPDATE characters SET identifier = @newlicense WHERE identifier = @oldlicense',{ 
			['@newlicense'] = args.newlicense,
			['@oldlicense'] = args.oldlicense
		})
        MySQL.Async.execute('UPDATE datastore_data SET owner = @newlicense WHERE owner = @oldlicense',{ 
			['@newlicense'] = args.newlicense,
			['@oldlicense'] = args.oldlicense
		})
        MySQL.Async.execute('UPDATE owned_properties SET owner = @newlicense WHERE owner = @oldlicense',{ 
			['@newlicense'] = args.newlicense,
			['@oldlicense'] = args.oldlicense
		})
        MySQL.Async.execute('UPDATE owned_properties SET co_owner1 = @newlicense WHERE co_owner1 = @oldlicense',{ 
			['@newlicense'] = args.newlicense,
			['@oldlicense'] = args.oldlicense
		})
        MySQL.Async.execute('UPDATE owned_properties SET co_owner2 = @newlicense WHERE co_owner2 = @oldlicense',{ 
			['@newlicense'] = args.newlicense,
			['@oldlicense'] = args.oldlicense
		})
        MySQL.Async.execute('UPDATE owned_vehicles SET owner = @newlicense WHERE owner = @oldlicense',{ 
			['@newlicense'] = args.newlicense,
			['@oldlicense'] = args.oldlicense
		})
        MySQL.Async.execute('UPDATE owned_vehicles SET co_owner = @newlicense WHERE co_owner = @oldlicense',{ 
			['@newlicense'] = args.newlicense,
			['@oldlicense'] = args.oldlicense
		})
        MySQL.Async.execute('UPDATE owned_vehicles SET co_owner2 = @newlicense WHERE co_owner2 = @oldlicense',{ 
			['@newlicense'] = args.newlicense,
			['@oldlicense'] = args.oldlicense
		})
        MySQL.Async.execute('UPDATE user_licenses SET owner = @newlicense WHERE owner = @oldlicense',{ 
			['@newlicense'] = args.newlicense,
			['@oldlicense'] = args.oldlicense
		})
        MySQL.Async.execute('UPDATE lspd_mdc_user_notes SET userId = @newlicense WHERE userId = @oldlicense',{ 
			['@newlicense'] = args.newlicense,
			['@oldlicense'] = args.oldlicense
		})
        MySQL.Async.execute('UPDATE lspd_user_judgments SET userId = @newlicense WHERE userId = @oldlicense',{ 
			['@newlicense'] = args.newlicense,
			['@oldlicense'] = args.oldlicense
		})
	end
end, true, {help = "Przywróć postać gracza", validate = true, arguments = {
	{name = 'newlicense', help = "Nowa licencja", type = 'string'},
    {name = 'oldlicense', help = "Stara licencja", type = 'string'}
}})

ESX.RegisterCommand('revivedist', {'trialsupport', 'support', 'mod', 'admin', 'superadmin', 'best'}, function(xPlayer, args, showError)
    if args.dist then
		if args.dist <= 500 then
			local admincoords = GetEntityCoords(GetPlayerPed(xPlayer.source))
			exports['exile_logs']:SendLog(xPlayer.source, "Użyto komendy /revivedist " .. tonumber(args.dist), "revive")
			for k, v in pairs(GetPlayers()) do
				local playercoords = GetEntityCoords(GetPlayerPed(v))
				local distance = #(admincoords - playercoords)
				if distance < args.dist then
					TriggerClientEvent('hypex_ambulancejob:hypexreviveblack', v)
				end
			end
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Za duży dystans :v (>500)")
		end
    end
end, true, {help = "Ożywia graczy w danym dystansie", validate = true, arguments = {
    {name = 'dist', help = "Odległość do reva", type = 'number'},
}})

ESX.RegisterCommand('bitkiadd', {'mod', 'admin', 'superadmin'}, function(xPlayer, args, showError)
	if args.job ~= nil and args.wartosc ~= nil and args.wartosc ~= nil then
		MySQL.Async.fetchAll('SELECT wins,loses FROM bitki WHERE org_name = @org_name', {
			['@org_name'] = args.job
		}, function(result)
			if result[1] ~= nil then
				if args.what == 'win' then
					MySQL.Async.execute('UPDATE bitki SET wins = @wins WHERE org_name = @org_name',{ 
						['@wins'] = result[1].wins + args.wartosc,
						['@org_name'] = args.job
					})
					exports['exile_logs']:SendLog(source, xPlayer.name..' dodal '..args.wartosc..' winy dla organizacji '..args.job, 'bitkimanage', '5793266')
				elseif args.what == 'lose' then
					MySQL.Async.execute('UPDATE bitki SET loses = @loses WHERE org_name = @org_name',{ 
						['@loses'] = result[1].loses + args.wartosc,
						['@org_name'] = args.job
					})
					exports['exile_logs']:SendLog(source, xPlayer.name..' dodal '..args.wartosc..' lose dla organizacji '..args.job, 'bitkimanage', '5793266')
				end
			end
		end)
	end
end, true, {help = "Zaktualizuj bitki", validate = true, arguments = {
	{name = 'job', help = "Nazwa joba organizacji", type = 'string'},
	{name = 'what', help = "win/lose", type = 'string'},
    {name = 'wartosc', help = "Ile dodac", type = 'string'}
}})

ESX.RegisterCommand('bitkiremove', {'mod', 'admin', 'superadmin', 'best'}, function(xPlayer, args, showError)
	if args.job ~= nil and args.wartosc ~= nil and args.wartosc ~= nil then
		MySQL.Async.fetchAll('SELECT wins,loses FROM bitki WHERE org_name = @org_name', {
			['@org_name'] = args.job
		}, function(result)
			if result[1] ~= nil then
				if args.what == 'win' then
					MySQL.Async.execute('UPDATE bitki SET wins = @wins WHERE org_name = @org_name',{ 
						['@wins'] = result[1].wins - args.wartosc,
						['@org_name'] = args.job
					})
					exports['exile_logs']:SendLog(source, xPlayer.name..' usunal '..args.wartosc..' winow dla organizacji '..args.job, 'bitkimanage', '5793266')
				elseif args.what == 'lose' then
					MySQL.Async.execute('UPDATE bitki SET loses = @loses WHERE org_name = @org_name',{ 
						['@loses'] = result[1].loses - args.wartosc,
						['@org_name'] = args.job
					})
					exports['exile_logs']:SendLog(source, xPlayer.name..' usunal '..args.wartosc..' lose dla organizacji '..args.job, 'bitkimanage', '5793266')
				end
			end
		end)
	end
end, true, {help = "Zaktualizuj bitki", validate = true, arguments = {
	{name = 'job', help = "Nazwa joba organizacji", type = 'string'},
	{name = 'what', help = "win/lose", type = 'string'},
    {name = 'wartosc', help = "Ile odjac", type = 'string'}
}})

ESX.RegisterCommand('updateorgname', {'mod', 'admin', 'superadmin', 'best'}, function(xPlayer, args, showError)
	if args.job ~= nil and args.label ~= nil and args.number ~= nil then
		MySQL.Async.execute('UPDATE bitki SET org_label = @org_label WHERE org_name = @org_name',{ 
			['@org_label'] = '#'..args.number..' '..args.label,
			['@org_name'] = args.job
		})
		MySQL.Async.execute('UPDATE jobs SET label = @org_label WHERE name = @org_name',{ 
			['@org_label'] = '#'..args.number..' '..args.label,
			['@org_name'] = args.job
		})
	end
end, true, {help = "Zaktualizuj nazwe organizacji", validate = true, arguments = {
	{name = 'job', help = "Nazwa joba organizacji", type = 'string'},
	{name = 'number', help = "Numer z # organizacji (Podaj bez #)", type = 'string'},
	{name = 'label', help = "win/lose", type = 'string'}
}})

ESX.RegisterCommand('spawn', {'trialsupport', 'support', 'mod', 'admin', 'superadmin'}, function(xPlayer, args, showError)
    if args.targetid then
        local xPlayerTarget = ESX.GetPlayerFromId(args.targetid)
        if xPlayerTarget then
			xPlayerTarget.setCoords({x=-538.02, y=-217.01, z=36.69})
        end
    end
end, true, {help = "Teleportuj gracza na urząd", validate = true, arguments = {
    {name = 'targetid', help = "ID gracza", type = 'number'}
}})