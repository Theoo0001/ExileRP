ESX                       = nil

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj)
	ESX = obj
end)

local cd = os.time()
local BlockTable = {}
local BlockTWT = {}
local BlockDW = {}
local opisy = {}

ESX.RegisterServerCallback("esx_marker:fetchUserRank", function(source, cb)
    local player = ESX.GetPlayerFromId(source)

    if player ~= nil then
        local playerGroup = player.getGroup()

        if playerGroup ~= nil then 
            cb(playerGroup)
        else
            cb("user")
        end
    else
        cb("user")
    end
end)

CreateThread(function()
	while true do
		Citizen.Wait(10000)
		for i=1, #BlockTable, 1 do
			local timeNow = os.time()
			if BlockTable[i].unix < timeNow then
				if BlockTable[i].chat == 'twt' then
					if BlockTWT[BlockTable[i].identifier] == true then
						BlockTWT[BlockTable[i].identifier] = nil
						table.remove(BlockTable, i)
						MySQL.Async.execute('DELETE FROM chat_bans WHERE identifier = @identifier AND chat = @chat', {
							['@identifier'] = BlockTable[i].identifier,
							['@chat'] = BlockTable[i].chat
						})
						break
					end
				else
					if BlockDW[BlockTable[i].identifier] == true then
						BlockDW[BlockTable[i].identifier] = nil
						table.remove(BlockTable, i)
						MySQL.Async.execute('DELETE FROM chat_bans WHERE identifier = @identifier AND chat = @chat', {
							['@identifier'] = BlockTable[i].identifier,
							['@chat'] = BlockTable[i].chat
						})
						break
					end
				end
			end
		end
	end
end)

RegisterServerEvent('exile_chat:checkBlocklist')
AddEventHandler('exile_chat:checkBlocklist', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer then
		MySQL.Async.fetchAll("SELECT * FROM chat_bans WHERE identifier = @identifier", {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			if result then
				for i=1, #result, 1 do
					local timeNow = os.time()
					if result[i].unix < timeNow then
						MySQL.Async.execute('DELETE FROM chat_bans WHERE identifier = @identifier AND chat = @chat', {
							['@identifier'] = result[i].identifier,
							['@chat'] = result[i].chat
						})
					else
						local found = false
						for j=1, #BlockTable, 1 do
							if BlockTable[j].identifier == result[i].identifier and BlockTable[j].chat == result[i].chat then
								found = true
								break
							end
						end

						if not found then
							if result[i].chat == 'twt' then
								table.insert(BlockTable, {identifier = result[i].identifier, unix = result[i].unix, chat = result[i].chat})
								BlockTWT[result[i].identifier] = true
							else
								table.insert(BlockTable, {identifier = result[i].identifier, unix = result[i].unix, chat = result[i].chat})
								BlockDW[result[i].identifier] = true
							end
						end
					end
				end
			end
		end)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	PlayerData = xPlayer
	if xPlayer ~= nil then
		local group = 'user'
		if xPlayer.group == nil then
			group = 'user'
		else
			group = xPlayer.group
		end
		TriggerClientEvent('es_admin:setGroup', playerId, group)
	end
end)

AddEventHandler('chatMessage', function(source, name, message)
    if string.sub(message, 1, string.len("/")) ~= "/" then
		local xPlayer = ESX.GetPlayerFromId(source)
		exports['exile_logs']:SendLog(source, "LOOC: " .. message, 'chat', '9807270')
		
		if xPlayer ~= nil then
			TriggerClientEvent("sendProximityMessage", -1, xPlayer.name, source, xPlayer.group, message)
		end
    end
    CancelEvent()
end)

RegisterCommand('me', function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
	local czas = os.date("%Y/%m/%d %X")
    TriggerClientEvent("sendProximityMessageMe", -1, source, source, table.concat(args, " "))

	local text = ''
    for i = 1,#args do
        text = text .. ' ' .. args[i]
    end

	color = {r = 255, g = 152, b = 247, alpha = 255}
	exports['exile_logs']:SendLog(source, "ME: " .. text, 'chat', '15158332')
	TriggerClientEvent('esx_rpchat:triggerDisplay', -1, text, source, color)
end, false)

RegisterCommand('news', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
	if CheckPhone(xPlayer.source) <= 0 then
        TriggerClientEvent('esx:showNotification', _source, 'Nie posiadasz telefonu.')
        return
    end
	
	if os.time() < cd then
		TriggerClientEvent('esx:showNotification', xPlayer.source, '~b~Poczekaj chwil??, a?? wszyscy odczytaj?? najnowszego newsa!')
        return
	end
	
    if xPlayer.job.name == 'police' or xPlayer.job.name == 'ambulance' then
        args = table.concat(args, ' ')
		cd = os.time() + 60
		TriggerClientEvent('chat:addMessage1', -1, xPlayer.job.label, {255, 206, 10}, args, "fas fa-newspaper")
		exports['exile_logs']:SendLog(source, "NEWS: [" .. xPlayer.job.label .. "]: " .. args, 'chat', '8359053')
	elseif xPlayer.job.name == 'casino' or xPlayer.job.name == 'mechanik2' then
		if xPlayer.getAccount('bank').money <= 3000 then
			TriggerClientEvent('esx:showNotification', _source, '~r~Nie posiadasz wystarczaj??co got??wki w banku, aby wys??a?? wiadomo???? na wiadomo??ciach')
			return
		end
		args = table.concat(args, ' ')
		local jobLabel = xPlayer.job.label
		if xPlayer.hiddenjob.name == 'casino' then
			jobLabel = xPlayer.hiddenjob.label
		end
		cd = os.time() + 60
		TriggerClientEvent('chat:addMessage1', -1, xPlayer.job.label, {255, 206, 10}, args, "fas fa-newspaper")
		exports['exile_logs']:SendLog(source, "NEWS: [" .. jobLabel .. "]: " .. args, 'chat', '8359053')
		xPlayer.removeAccountMoney('bank', 3000)
    else
        TriggerClientEvent('chat:addMessage1', source, "SYSTEM", {255, 0, 0}, "Nie posiadasz permisji do u??ycia tej komendy!", "fas fa-bell")
    end
end, false)

RegisterCommand('try', function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
	local czas = os.date("%Y/%m/%d %X")
	local czy = math.random(1, 2)
    TriggerClientEvent("sendProximityMessageCzy", -1, source, source, table.concat(args, " "), czy)
end, false)

RegisterCommand('do', function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
	local czas = os.date("%Y/%m/%d %X")
    TriggerClientEvent("sendProximityMessageDo", -1, source, source, table.concat(args, " "))

	local text = ''
    for i = 1,#args do
        text = text .. ' ' .. args[i]
    end

	color = {r = 256, g = 202, b = 247, alpha = 255}
	exports['exile_logs']:SendLog(source, "DO: " .. text, 'chat', '3066993')
	TriggerClientEvent('esx_rpchat:triggerDisplay', -1, text, source, color)
end, false)

RegisterServerEvent('sendProximityMessageTweetServer')
AddEventHandler('sendProximityMessageTweetServer', function(message)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
    if CheckPhone(_source) <= 0 then
        TriggerClientEvent('esx:showNotification', _source, 'Nie posiadasz telefonu.')
        return
	elseif os.time() < cd then
		TriggerClientEvent('esx:showNotification', _source, '~b~Poczekaj chwil??, a?? wszyscy odczytaj?? najnowszego newsa!')
		return
	elseif BlockTWT[xPlayer.identifier] == true then 
		TriggerClientEvent('esx:showNotification', _source, '~b~Jeste?? zablokowany i nie mo??esz wys??a?? wiadomo??ci')
        return	
    end

	TriggerClientEvent('sendProximityMessageTweet', -1, "^*"..xPlayer.character.firstname..' '..xPlayer.character.lastname, message, _source)
	exports['exile_logs']:SendLog(_source, "TWT: " .. message, 'chat', '2123412')
end)

RegisterServerEvent('sendProximityMessageDarkWebServer')
AddEventHandler('sendProximityMessageDarkWebServer', function(message)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
    if CheckPhone(_source) <= 0 then
        local playerName = GetPlayerName(_source)
        TriggerClientEvent('esx:showNotification', _source, '~r~Nie posiadasz telefonu.')
        return
	elseif BlockDW[xPlayer.identifier] == true then
		TriggerClientEvent('esx:showNotification', _source, '~b~Jeste?? zablokowany i nie mo??esz wys??a?? wiadomo??ci')
        return	
	elseif xPlayer.getAccount('bank').money <= 1000 then
		TriggerClientEvent('esx:showNotification', _source, '~r~Nie posiadasz wystarczaj??co got??wki w banku, aby wys??a?? wiadomo???? na darkwebie')
		return	
    end

	if xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff' then
		TriggerClientEvent('esx:showNotification', _source, '~r~Nie masz dost??pu do tej aplikacji!')
	else
		TriggerClientEvent("sendProximityMessageDarkWeb", -1, message, _source)
		
		exports['exile_logs']:SendLog(_source, "DW: " .. message, 'chat')
		xPlayer.removeAccountMoney('bank', 1000)
	end
end)
local Colors = {
	['best'] = {0, 0, 0},
	['dev'] = {0, 0, 128},
	['superadmin'] = {255, 0, 0},
	['admin'] = {0, 191, 255},
	['mod'] = {132, 112, 255},
	['support'] = {255, 165, 0},
	['trialsupport'] = {255, 255, 0},
}

RegisterCommand('ooc', function(source, args, rawCommand)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local userColor = Colors[xPlayer.group]
	if xPlayer.group ~= nil and xPlayer.group ~= 'user' then
		TriggerClientEvent('chat:addMessage1', -1, "^*"..GetPlayerName(_source), userColor, table.concat(args, " "), "fas fa-shield-alt")
		exports['exile_logs']:SendLog(_source, "OOC: " .. table.concat(args, " "), 'chat')
	end
end, false)

ESX.RegisterCommand('unblockdw', {'mod', 'admin', 'superadmin', 'best', 'dev'}, function(xPlayer, args, showError)
	if args.targetid ~= nil then
		local tPlayer = ESX.GetPlayerFromId(args.targetid)
		if tPlayer and BlockDW[tPlayer.identifier] and BlockDW[tPlayer.identifier] ~= nil then
			MySQL.Async.fetchAll("SELECT * FROM chat_bans WHERE identifier = @identifier AND chat = @chat", {
				['@identifier'] = tPlayer.identifier,
				['@chat']="dw"
			}, function(rows) 
				if rows[1] and rows[1] ~= nil then
					BlockDW[tPlayer.identifier] = nil
					MySQL.Async.execute('DELETE FROM chat_bans WHERE identifier = @identifier AND chat = @chat', {
						['@identifier'] = tPlayer.identifier,
						['@chat'] = "dw"
					})
					xPlayer.showNotification("~b~Odblokowano darkweba ~r~"..tPlayer.source)
					tPlayer.showNotification("~b~Odzyska??e?? dost??p do Darkweb")
					for i,v in ipairs(BlockTable) do
						if v == tPlayer.identifier then
							table.remove(BlockTable, i)
							break
						end	
					end	
					exports['exile_logs']:SendLog(xPlayer.source, "U??yto komendy /unblockdw " .. args.targetid, "admin_commands")
				else
					xPlayer.showNotification("~b~Gracz ma ju?? dost??p do darkweba")
					exports['exile_logs']:SendLog(xPlayer.source, "U??yto komendy /unblockdw " .. args.targetid, "admin_commands")
				end	
			end)
		end
	end
end, true, {help = "Odblokuj graczowi dost??p do darkweba", validate = true, arguments = {
	{name = 'targetid', help = "ID gracza", type = 'number'}
}})

ESX.RegisterCommand('unblocktwt', {'mod', 'admin', 'superadmin', 'best', 'dev'}, function(xPlayer, args, showError)
	if args.targetid ~= nil then
		local tPlayer = ESX.GetPlayerFromId(args.targetid)
		if tPlayer and BlockTWT[tPlayer.identifier] and BlockTWT[tPlayer.identifier] ~= nil then
			MySQL.Async.fetchAll("SELECT * FROM chat_bans WHERE identifier = @identifier AND chat = @chat", {
				['@identifier'] = tPlayer.identifier,
				['@chat']="twt"
			}, function(rows) 
				if rows[1] and rows[1] ~= nil then
					local userData = tPlayer.character.firstname .. ' ' .. tPlayer.character.lastname
					BlockTWT[tPlayer.identifier] = nil
					MySQL.Async.execute('DELETE FROM chat_bans WHERE identifier = @identifier AND chat = @chat', {
						['@identifier'] = tPlayer.identifier,
						['@chat'] = "twt"
					})
					xPlayer.showNotification("~b~Odblokowano twittera ~r~"..tPlayer.source)
					tPlayer.showNotification("~b~Odzyska??e?? dost??p do Tweeter")
					TriggerClientEvent('chat:addMessage1', -1, "Twitter Admin", {26, 26, 26}, userData .. " zosta?? odblokowany", "fab fa-twitter")
					for i,v in ipairs(BlockTable) do
						if v == tPlayer.identifier then
							table.remove(BlockTable, i)
							break
						end	
					end	
					exports['exile_logs']:SendLog(xPlayer.source, "U??yto komendy /unblocktwt " .. args.targetid, "admin_commands")
				else
					xPlayer.showNotification("~b~Gracz ma ju?? dost??p do twittera")
					exports['exile_logs']:SendLog(xPlayer.source, "U??yto komendy /unblocktwt " .. args.targetid, "admin_commands")
				end	
			end)
		end
	end
end, true, {help = "Odblokuj graczowi dost??p do twittera", validate = true, arguments = {
	{name = 'targetid', help = "ID gracza", type = 'number'}
}})

ESX.RegisterCommand('blocktwt', {'mod', 'admin', 'superadmin', 'best', 'dev'}, function(xPlayer, args, showError)
	if args.targetid ~= nil and (args.czas ~= nil and args.czas > 0) then
		local tPlayer = ESX.GetPlayerFromId(args.targetid)
		if tPlayer then
			local userData = tPlayer.character.firstname .. ' ' .. tPlayer.character.lastname
			local unixDuration = os.time() + (tonumber(args.czas) * 3600)
			MySQL.Async.execute('INSERT INTO chat_bans (identifier, unix, chat) VALUES (@identifier, @unix, @chat)',
			{
				['@identifier'] = tPlayer.identifier,
				['@unix'] = unixDuration,
				['@chat'] = 'twt'
			}, function(rowsChanged)
				table.insert(BlockTable, {identifier = tPlayer.identifier, unix = unixDuration, chat = 'twt'})
				BlockTWT[tPlayer.identifier] = true
				TriggerClientEvent('chat:addMessage1', -1, "Twitter Admin", {26, 26, 26}, userData .. " zosta?? zablokowany na okres " .. args.czas .. " godzin", "fab fa-twitter")
				exports['exile_logs']:SendLog(xPlayer.source, "U??yto komendy /blocktwt " .. args.targetid .. " " .. args.czas, "admin_commands")
			end)
		end
	end
end, true, {help = "Zablokuj graczowi dost??p do twittera", validate = true, arguments = {
	{name = 'targetid', help = "ID gracza", type = 'number'},
	{name = 'czas', help = "Czas blokady w godzinach", type = 'number'}
}})

ESX.RegisterCommand('blockdw', {'mod', 'admin', 'superadmin', 'best', 'dev'}, function(xPlayer, args, showError)
	if args.targetid ~= nil and (args.czas ~= nil and args.czas > 0) then
		local tPlayer = ESX.GetPlayerFromId(args.targetid)
		if tPlayer then
			local unixDuration = os.time() + (tonumber(args.czas) * 3600)
			MySQL.Async.execute('INSERT INTO chat_bans (identifier, unix, chat) VALUES (@identifier, @unix, @chat)',
			{
				['@identifier'] = tPlayer.identifier,
				['@unix'] = unixDuration,
				['@chat'] = 'dw'
			}, function(rowsChanged)
				table.insert(BlockTable, {identifier = tPlayer.identifier, unix = unixDuration, chat = 'dw'})
				BlockDW[tPlayer.identifier] = true
				tPlayer.showNotification("~b~Zosta??e?? zablokowany na " .. args.czas .. " godzin??. Nie mo??esz korzysta?? z Darkweba")
				exports['exile_logs']:SendLog(xPlayer.source, "U??yto komendy /blockdw " .. args.targetid .. " " .. args.czas, "admin_commands")
			end)
		end
	end
end, true, {help = "Zablokuj graczowi dost??p do darkweba", validate = true, arguments = {
	{name = 'targetid', help = "ID gracza", type = 'number'},
	{name = 'czas', help = "Czas blokady w godzinach", type = 'number'}
}})

ESX.RegisterServerCallback('ExileRP:ZapodajOpisyZPrzedWejscia', function(source, cb) -- fix ????
	cb(opisy)
end)

AddEventHandler('playerDropped', function()
	local _source = source
	if opisy[_source] then
		opisy[_source] = nil
	end
end)

RegisterCommand('opis', function(source, args, rawCommand)
    if args[1] ~= nil then
        local text = table.concat(args, " ")
        if #text > 91 then
			TriggerClientEvent('esx:showNotification', _source, 'Maksymalna d??ugo???? opisu to 91 znak??w!')
        else
      		TriggerClientEvent('ExileRP:opis', -1, source, ''..text..'')
			exports['exile_logs']:SendLog(source, "STWORZY?? OPIS: " .. text, 'chat', '15844367')
			opisy[source] = text
        end
	else
		TriggerClientEvent('ExileRP:opis', -1, source, '')
		opisy[source] = nil
	end
end, false)

RegisterServerEvent('ExileRP:opisInnychGraczyServer')
AddEventHandler('ExileRP:opisInnychGraczyServer', function(id, opis)
    TriggerClientEvent('ExileRP:opis', -1, id, opis)
end)

RegisterServerEvent('esx_rpchat:shareDisplay')
AddEventHandler('esx_rpchat:shareDisplay', function(text, color)
	TriggerClientEvent('esx_rpchat:triggerDisplay', -1, text, source, color)
end)

bannedIdentifiers = {}
lastReports = {}
cooldownsReport = {}

function findLastReport(id)
	for k,v in pairs(lastReports) do
		if k == tostring(id) then
			return v
		end	
	end	
	return nil
end	

function findCooldown(id)
	for i,v in ipairs(cooldownsReport) do
		if v == id then
			return true
		end	
	end	
	return false
end	

function isReportBanned(id)
	local license  = false

	for k,v in pairs(GetPlayerIdentifiers(id)) do
		if string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		end
	end

	for i,v in ipairs(bannedIdentifiers) do
		if v == license then
			return true
		end	
	end	
	return false
end	

function removeReportBan(id)
	for i,v in ipairs(bannedIdentifiers) do
		if v == id then
			table.remove(bannedIdentifiers, i)
			return
		end	
	end	
end	

function removeCooldown(id) 
	for i,v in ipairs(cooldownsReport) do
		if v == id then
			table.remove(cooldownsReport, i)
		end	
	end	
end

RegisterNetEvent("csskrouble:banReport")
AddEventHandler("csskrouble:banReport", function(id) 
	local license  = false
	for k,v in pairs(GetPlayerIdentifiers(id)) do
		if string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		end
	end
	if license ~= false then
		local xPlayer = ESX.GetPlayerFromId(src)
		table.insert(bannedIdentifiers, license)
		xPlayer.showNotification('~r~Zosta??e?? zbanowany na wysy??anie report??w przez 30 minut.')
		CreateThread(function() 
			Wait(1800000)
			removeReportBan(license)
		end)
	end	
end)

local activeReports = {}
local reportsInfo = {}

RegisterCommand("cls", function(source,args,raw) 
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if xPlayer and xPlayer.getGroup() ~= "user" then
		if args[1] then
			local rId = args[1]
			if rId then
				local report = activeReports[rId]
				if report then 
					local inforeport = reportsInfo[rId]
					if inforeport.id == src then
						TriggerClientEvent("esx:showNotification", src, "~r~Pr??bujesz przyj???? swojego reporta? XD")
						exports['exile_logs']:SendLog(src, "Administrator **"..GetPlayerName(src).."** pr??bowa?? przyj???? swojego reporta `#"..rId.."` ????", 'eckogrzywka')
					else
						local xPlr = ESX.GetPlayerFromId(inforeport.id)
						if xPlr and xPlr.source ~= 0 and xPlr.group == 'superadmin' or xPlr.group == 'admin' or xPlr.group == 'best' or xPlr.group == 'mod' or xPlr.group == 'support' or xPlr.group == 'superadmin' or xPlr.group == 'trialsupport' then
							TriggerClientEvent("esx:showNotification", src, "~r~Nie mo??esz przyj???? reporta administratora.")
							return
						end
						activeReports[rId] = false
						TriggerClientEvent("acceptedReport", -1, GetPlayerName(src), src, rId, inforeport.id, inforeport.content)
						exports['exile_logs']:SendLog(src, "Administrator **"..GetPlayerName(src).."** przyj???? reporta `#"..rId.."` o tre??ci `"..inforeport.content.."` od gracza `["..inforeport.id.."] "..inforeport.name.."`", 'eckogrzywka')
						
					end
				else
					TriggerClientEvent("esx:showNotification", src, "~r~Report zosta?? ju?? przyj??ty lub nie istnieje")
				end
			else
				TriggerClientEvent("esx:showNotification", src, "~r~Nie prawid??owe ID reporta")
			end
		else
			TriggerClientEvent("esx:showNotification", src, "~r~Podaj ID reporta")
		end
	else
		TriggerClientEvent("esx:showNotification", src, "~r~Nie posiadasz permisji")
	end
end,false)

AddEventHandler('chatMessage', function(source, color, msg)
	local xPlayer = ESX.GetPlayerFromId(source)
	cm = stringsplit(msg, " ")
	if cm[1] == 'test' then
		local tPID = tonumber(cm[2])
	end
	if cm[1] == "/reply" or cm[1] == "/r" then
		CancelEvent()
		if tablelength(cm) > 1 then
			local tPID = tonumber(cm[2])
			local names2 = GetPlayerName(tPID)
			local names3 = GetPlayerName(source)
			local textmsg = ""
			for i=1, #cm do
				if i ~= 1 and i ~=2 then
					textmsg = (textmsg .. " " .. tostring(cm[i]))
				end
			end

		    if xPlayer.group ~= nil and xPlayer.group ~= 'user'then
			    TriggerClientEvent('textmsg', tPID, source, textmsg, names2, names3)
			    TriggerClientEvent('textsent', source, tPID, names2)
				exports['exile_logs']:SendLog(source, "REPLY DO "..names2..": " .. textmsg, 'chat', '15105570')
		    else
			    TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insuficient Premissions!")
			end
		end
	end	
	
	if cm[1] == "/report" then
		CancelEvent()
		if tablelength(cm) > 1 then
			local cd = findCooldown(xPlayer.source)
			local lastR = findLastReport(xPlayer.source)
			if cd then
				TriggerClientEvent('chat:addMessage1', xPlayer.source, "^*System", {255, 0, 0}, " Wysy??a??e?? ostatnio reporta, odczekaj chwil??", "fas fa-globe-europe")
				return
			end	
			local admins = 0
			local Players = exports['esx_scoreboard']:MisiaczekPlayers()
			for k,v in pairs(Players) do
				if v.group == 'superadmin' or v.group == 'admin' or v.group == 'best' or v.group == 'mod' or v.group == 'support' or v.group == 'superadmin' or v.group == 'trialsupport' then
					admins = admins + 1
				end
			end

			local names1 = GetPlayerName(source)
			local textmsg = ""
			for i=1, #cm do
				if i ~= 1 then
					textmsg = (textmsg .. " " .. tostring(cm[i]))
				end
			end
			if lastR == textmsg then
				TriggerClientEvent('chat:addMessage1', xPlayer.source, "^*System", {255, 0, 0}, " Wysy??a??e?? ostatnio reporta o tej tre??ci", "fas fa-globe-europe")
				return
			end	
			if isReportBanned(xPlayer.source) then
				TriggerClientEvent('chat:addMessage1', xPlayer.source, "^*System", {255, 0, 0}, " Ze wzgl??du na spam report??w, jeste?? zbanowany. Spr??buj ponownie p????niej.", "fas fa-globe-europe")
				return
			end	
			local reportId = source..math.random(0,9)
			activeReports[reportId] = true
			reportsInfo[reportId] = {
				name = names1,
				content = textmsg,
				id = source
			}
			TriggerClientEvent("sendReport", -1, reportId, source, names1, textmsg, admins)
			lastReports[tostring(xPlayer.source)] = textmsg
			table.insert(cooldownsReport, xPlayer.source)
			CreateThread(function() 
				Wait(10000)
				removeCooldown(xPlayer.source)
			end)
			exports['exile_logs']:SendLog(source, "Gracz potrzebuje pomocy `#"..reportId.."`: " .. textmsg, 'report', '15158332')
		end
	end	
end)

RegisterServerEvent("csskrouble:rateReport", function(rate, admin, content) 
	local src = source
	exports['exile_logs']:SendLog(src, "Gracz oceni?? administratora `"..admin.."` na `"..rate.."/5` gwiazdek. Tre???? reporta `"..content.."`", 'eckogrzywka')
end)

RegisterCommand('w', function(source, args, raw)
	cm = stringsplit(raw, " ")
	local tPID = tonumber(args[1])
	local names2 = GetPlayerName(tPID)
	if names2 then
		local names3 = GetPlayerName(source)
		local msgVar = {}
		local textmsg = ""
		for i=1, #cm do
			if i ~= 1 and i ~= 2 then
				textmsg = (textmsg .. " " .. tostring(cm[i]))
			end
		end
		TriggerClientEvent('chat:addMessage1', tPID, "Wiadomo???? od ["..source.."] ".."^*"..names3, {121, 230, 39}, textmsg, "fas fa-envelope")
		TriggerClientEvent('chat:addMessage1', source, "Wiadomo???? do ["..tPID.."] ^*"..names2, {121, 230, 39}, textmsg, "fas fa-envelope")
		exports['exile_logs']:SendLog(source, "WIADOMOSC DO "..GetPlayerName(tPID)..": " .. textmsg, 'chat', '2123412')
	else
		TriggerClientEvent('chat:addMessage1', source, "Wiadomo????", {255, 0, 0}, "Nie wys??ano, poniewa?? gracz jest offline!", "fas fa-bell")
	end
end)

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

RegisterServerEvent("wyjebzaafk")
AddEventHandler("wyjebzaafk", function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer.group == nil or xPlayer.group == 'user' then
		DropPlayer(source, "ExileRP: By??e?? zbyt d??ugo nieaktywny")
	end
end)

RegisterServerEvent("pierdolciesieniggerydumpujacebotujestwszystko")
AddEventHandler("pierdolciesieniggerydumpujacebotujestwszystko", function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local moze = false
	if xPlayer then
		DropPlayer(source, "ExileRP: Wyrzucono za brak prop??w, :sadge: kolego.")
	end
end)

ESX.RegisterServerCallback("esx_marker:fetchUserRank", function(source, cb)
    local player = ESX.GetPlayerFromId(source)

    if player ~= nil then
        local playerGroup = player.getGroup()

        if playerGroup ~= nil then 
            cb(playerGroup)
        else
            cb("user")
        end
    else
        cb("user")
    end
end)

function CheckPhone(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    while xPlayer == nil do
        Citizen.Wait(100)
    end

    local items = xPlayer.getInventoryItem('phone')
    if items == nil then
        return(0)
    else
       return(items.count)
    end
end

function SendLog(name, message, color)
	local embeds = {
		{
			["description"]=message,
			["type"]="rich",
			["color"] =5793266,
			["footer"]=  {
			["text"] = os.date() .. " | Stan Miasta",
			},
		}
	}
	if message == nil or message == '' then return FALSE end
	
	local webhook = 'https://discordproxy.neonrp.solutions/api/webhooks/949006426582417458/nagqUR7sUfdSU6SRjJOTtQm-nT5St0QmoxBaG6kEqxXPyuUTYm34DteqDOj4z8JuyVAE'	
	PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

RegisterCommand('zielony', function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
	local characterName = xPlayer.character.firstname .. ' ' .. xPlayer.character.lastname
	local grade = xPlayer.getJob().grade_label
	local praca = xPlayer.getJob().name
	if (xPlayer.job and xPlayer.job.name == 'police') then
		TriggerClientEvent('chat:addMessage1', -1, "SASP", {120, 255, 120}, '^0San Andreas State Police informuje o wprowadzeniu na miasto poziomu zagro??enia ^2 [ZIELONEGO] ^7 dzi??kujemy za wsp????prac??!', "fas fa-newspaper")
		cd = os.time() + 60
		SendLog('Stan Miasta', "Funkcjonariusz: **" ..characterName.. "**\nStopie??: **" ..grade.. "**\nWprowadzi?? na miasto poziom zagro??enia: **Zielony!**", 56108)
	end
end, false)

RegisterCommand('pomaranczowy', function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
	local characterName = xPlayer.character.firstname .. ' ' .. xPlayer.character.lastname
	local grade = xPlayer.getJob().grade_label
	local praca = xPlayer.getJob().name
	if (xPlayer.job and xPlayer.job.name == 'police') then
		TriggerClientEvent('chat:addMessage1', -1, "SASP", {255, 123, 0}, '^0San Andreas State Police informuje o wprowadzeniu na miasto poziomu zagro??enia ^3 [POMARA??CZOWEGO] ^7 prosimy o wsp????prac?? i zostanie w domach!', "fas fa-newspaper")
		cd = os.time() + 60
		SendLog('Stan Miasta', "Funkcjonariusz: **" ..characterName.. "**\nStopie??: **" ..grade.. "**\nWprowadzi?? na miasto poziom zagro??enia: **Pomara??czowy!**", 56108)
	end
end, false)

RegisterCommand('czerwony', function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
	local characterName = xPlayer.character.firstname .. ' ' .. xPlayer.character.lastname
	local grade = xPlayer.getJob().grade_label
	local praca = xPlayer.getJob().name
	if (xPlayer.job and xPlayer.job.name == 'police') then
		TriggerClientEvent('chat:addMessage1', -1, "SASP", {255, 0, 0}, "^0San Andreas State Police informuje o wprowadzeniu na miasto poziomu zagro??enia ^1 [CZERWONEGO] ^7 prosimy o wsp????prac?? i zostanie w domach!", "fas fa-newspaper")
		cd = os.time() + 60
		SendLog('Stan Miasta', "Funkcjonariusz: **" ..characterName.. "**\nStopie??: **" ..grade.. "**\nWprowadzi?? na miasto poziom zagro??enia: **Czerwony!**", 56108)
	end
end, false)

RegisterCommand('czarny', function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
	local characterName = xPlayer.character.firstname .. ' ' .. xPlayer.character.lastname
	local grade = xPlayer.getJob().grade_label
	local praca = xPlayer.getJob().name
	if (xPlayer.job and xPlayer.job.name == 'police') then
		TriggerClientEvent('chat:addMessage1', -1, "SASP", {20, 20, 20}, "^0San Andreas State Police informuje o wprowadzeniu na miasto poziomu zagro??enia [CZARNEGO] ^7ka??da podejrzana osoba zostanie zatrzymana i wylegitymowana, prosimy o wsp????prac?? i zostanie w domach!", "fas fa-newspaper")
		cd = os.time() + 60
		SendLog('Stan Miasta', "Funkcjonariusz: **" ..characterName.. "**\nStopie??: **" ..grade.. "**\nWprowadzi?? na miasto poziom zagro??enia: **Czarny!**", 56108)
	end
end, false)

RegisterCommand('wyjatkowy', function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
	local characterName = xPlayer.character.firstname .. ' ' .. xPlayer.character.lastname
	local grade = xPlayer.getJob().grade_label
	local praca = xPlayer.getJob().name
	if (xPlayer.job and xPlayer.job.name == 'police') then
		if xPlayer.job.grade > 10 then
		TriggerClientEvent('chat:addMessage1', -1, "SASP", {20, 20, 20}, "^0San Andreas State Police informuje o wprowadzeniu na miasto poziomu zagro??enia [WYJ??TKOWEGO] ^7ka??da podejrzana osoba zostanie zatrzymana, wylegitymowana, mog?? pa???? strza??y w kierunku os??b kt??re uciekaj?? b??d?? stawiaj?? op??r, prosimy o wsp????prac?? i zostanie w domach!", "fas fa-newspaper")
		cd = os.time() + 60
		SendLog('Stan Miasta', "Funkcjonariusz: **" ..characterName.. "**\nStopie??: **" ..grade.. "**\nWprowadzi?? na miasto poziom zagro??enia: **Wyj??tkowy!**", 56108)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, '~b~Stan wyj??tkowy mo??e wprowadzi?? tylko Commander+!')	
		end
	end
end, false)

RegisterCommand('klinikaotworz', function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
	local characterName = xPlayer.character.firstname .. ' ' .. xPlayer.character.lastname
	local grade = xPlayer.getJob().grade_label
	local praca = xPlayer.getJob().name
	if (xPlayer.job and xPlayer.job.name == 'ambulance') then
		if xPlayer.job.grade > 1 then
		TriggerClientEvent('chat:addMessage1', -1, "SAMS", {20, 20, 20}, "^8 San Andreas Medical Service ^4 Informuje ??e ^2 KLINIKA SAINT FIACRE  ^4jest ponownie ^2otwarta!", "fas fa-newspaper")
		cd = os.time() + 60
		SendLog('Stan Miasta', "Medyk: **" ..characterName.. "**\nStopie??: **" ..grade.. "**\nPoinformowa?? o otwarciu: **Kliniki Saint Fiacre**", 56108)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, '~b~Nie mo??esz tego u??y??!')	
		end
	end
end, false)

RegisterCommand('klinikazamknij', function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
	local characterName = xPlayer.character.firstname .. ' ' .. xPlayer.character.lastname
	local grade = xPlayer.getJob().grade_label
	local praca = xPlayer.getJob().name
	if (xPlayer.job and xPlayer.job.name == 'ambulance') then
		if xPlayer.job.grade > 1 then
		TriggerClientEvent('chat:addMessage1', -1, "SAMS", {20, 20, 20}, "^8 San Andreas Medical Service ^4 Informuje ??e ^2 KLINIKA SAINT FIACRE ^4 jest aktualnie ^8 zamkni??ta, prosimy o wsp????prac??, ze s??u??bami!", "fas fa-newspaper")
		cd = os.time() + 60
		SendLog('Stan Miasta', "Medyk: **" ..characterName.. "**\nStopie??: **" ..grade.. "**\nPoinformowa?? o zamkni??ciu: **Kliniki Saint Fiacre**", 56108)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, '~b~Nie mo??esz tego u??y??!')	
		end
	end
end, false)

RegisterCommand('sandyotworz', function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
	local characterName = xPlayer.character.firstname .. ' ' .. xPlayer.character.lastname
	local grade = xPlayer.getJob().grade_label
	local praca = xPlayer.getJob().name
	if (xPlayer.job and xPlayer.job.name == 'ambulance') then
		if xPlayer.job.grade > 1 then
		TriggerClientEvent('chat:addMessage1', -1, "SAMS", {20, 20, 20}, "^8 San Andreas Medical Service ^4 Informuje ??e szpital ^2 SANDY  ^8 ^4 jest ponownie ^2otwarty!", "fas fa-newspaper")
		cd = os.time() + 60
		SendLog('Stan Miasta', "Medyk: **" ..characterName.. "**\nStopie??: **" ..grade.. "**\nPoinformowa?? o zamkni??ciu: **Szpitalu Sandy Shores**", 56108)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, '~b~Nie mo??esz tego u??y??!')	
		end
	end
end, false)

RegisterCommand('sandyzamknij', function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
	local characterName = xPlayer.character.firstname .. ' ' .. xPlayer.character.lastname
	local grade = xPlayer.getJob().grade_label
	local praca = xPlayer.getJob().name
	if (xPlayer.job and xPlayer.job.name == 'ambulance') then
		if xPlayer.job.grade > 1 then
		TriggerClientEvent('chat:addMessage1', -1, "SAMS", {20, 20, 20}, "^8 San Andreas Medical Service ^4 Informuje ??e szpital ^2 SANDY  ^8 ^4 jest ^8 zamkni??ty, prosimy o wsp????prac??, ze s??u??bami!", "fas fa-newspaper")
		cd = os.time() + 60
		SendLog('Stan Miasta', "Medyk: **" ..characterName.. "**\nStopie??: **" ..grade.. "**\nPoinformowa?? o zamkni??ciu: **Szpitalu Sandy Shores**", 56108)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, '~b~Nie mo??esz tego u??y??!')	
		end
	end
end, false)

RegisterCommand('paletootworz', function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
	local characterName = xPlayer.character.firstname .. ' ' .. xPlayer.character.lastname
	local grade = xPlayer.getJob().grade_label
	local praca = xPlayer.getJob().name
	if (xPlayer.job and xPlayer.job.name == 'ambulance') then
		if xPlayer.job.grade > 1 then
		TriggerClientEvent('chat:addMessage1', -1, "SAMS", {20, 20, 20}, "^8 San Andreas Medical Service ^4 Informuje ??e szpital ^2 PALETO^2 ^8 ^4 jest ponownie ^2otwarty!", "fas fa-newspaper")
		cd = os.time() + 60
		SendLog('Stan Miasta', "Medyk: **" ..characterName.. "**\nStopie??: **" ..grade.. "**\nPoinformowa?? o zamkni??ciu: **Szpitalu Paleto Bay**", 56108)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, '~b~Nie mo??esz tego u??y??!')	
		end
	end
end, false)

RegisterCommand('paletozamknij', function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
	local characterName = xPlayer.character.firstname .. ' ' .. xPlayer.character.lastname
	local grade = xPlayer.getJob().grade_label
	local praca = xPlayer.getJob().name
	if (xPlayer.job and xPlayer.job.name == 'ambulance') then
		if xPlayer.job.grade > 1 then
		TriggerClientEvent('chat:addMessage1', -1, "SAMS", {20, 20, 20}, "^8 San Andreas Medical Service ^4 Informuje ??e szpital ^2 PALETO^8 ^4 jest ^8 zamkni??ty, prosimy o wsp????prac??, ze s??u??bami!", "fas fa-newspaper")
		cd = os.time() + 60
		SendLog('Stan Miasta', "Medyk: **" ..characterName.. "**\nStopie??: **" ..grade.. "**\nPoinformowa?? o zamkni??ciu: **Szpitalu Paleto Bay**", 56108)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, '~b~Nie mo??esz tego u??y??!')	
		end
	end
end, false)

RegisterCommand('malomedykow', function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
	local characterName = xPlayer.character.firstname .. ' ' .. xPlayer.character.lastname
	local grade = xPlayer.getJob().grade_label
	local praca = xPlayer.getJob().name
	if (xPlayer.job and xPlayer.job.name == 'ambulance') then
		if xPlayer.job.grade > 1 then
		TriggerClientEvent('chat:addMessage1', -1, "SAMS", {20, 20, 20}, "^8San Andreas Medical Service ^4 Informuje o ^3 ma??ej ^4 ilo??ci medyk??w na ^8 s??u??bie. ^4 Prosimy o przyjazd z rannymi na ^2Klinike Saint Fiacre", "fas fa-newspaper")
		cd = os.time() + 60
		SendLog('Stan Miasta', "Medyk: **" ..characterName.. "**\nStopie??: **" ..grade.. "**\nPoinformowa?? o ma??ej ilo??ci medyk??w: **Prosimy o przyjazd z rannymi na Klinike Saint Fiacre**", 56108)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, '~b~Nie mo??esz tego u??y??!')	
		end
	end
end, false)