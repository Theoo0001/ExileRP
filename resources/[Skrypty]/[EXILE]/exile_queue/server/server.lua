ESX	= nil
TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

WhiteList = {}
BanList = {}
AnticheatList = {}
BackList = {}
players = {}
waiting = {}
connecting = {}
disconnected = {}
allTickets = {}
firstDisconnected = {}
nextPlayer = nil
nextPushed = nil
tick = 1
isRestarting = false

EmojiList = Config.EmojiList

local UbWebhook = 'https://discordproxy.neonrp.solutions/api/webhooks/819712871394836490/iCvc20g9Yi8lIDcsLsPSiqJjTdZHY9K3K1rBD5sl30gzZC7TC_4UJ8IfkDF-9PuZehUx'
local BanWebhook = 'https://discordproxy.neonrp.solutions/api/webhooks/819712827013988352/vtYknPihmcGrRIi3pxODu8HWBLJd_MKUOAKqPi9-YukVY6sAfanq4ksvW9frr2JfnzdE'
local WLaddWebhook = 'https://discordproxy.neonrp.solutions/api/webhooks/923922283070910564/ilsMBCAWwKCW6ACGvs_D7Tt0VMSMv8P8kOobXzIhb_d2kmZPIwQ9ogNxrD7KBnUlbGlS'
local BiletWebhook = 'https://discordproxy.neonrp.solutions/api/webhooks/822387905657307177/ymzhfRLGxb23si0zUwMoE_GhETlq4WRL3sE58xYldr_NvKUvqc-7Ghs862TE1H232laA'

StopResource('hardcap')

RegisterServerEvent('exile_queue:isRestarting')
AddEventHandler('exile_queue:isRestarting', function(boolean)
	if boolean ~= nil then
		isRestarting = boolean
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if GetResourceState('hardcap') == 'stopped' then
			StartResource('hardcap')
		end
	end
end)

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
    if eventData.secondsRemaining == 60 then
        CreateThread(function()
            Wait(45000)
            ESX.SavePlayers()
			ESX.SaveItems()
			isRestarting = true
			local xPlayers = ESX.GetPlayers()
			for i=1, #xPlayers, 1 do
				local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
				DropPlayer(xPlayer.source, "Zaćmienie! Oczekuj na bilet powrotny.")
			end
        end)
    end
end)

CreateThread(function() 
    while true do
        Citizen.Wait(15 * 60 * 1000)
        ESX.SavePlayers()
        ESX.SaveItems()
    end
end)

AddEventHandler("playerConnecting", function(name, reject, def)
	local source	= source
	local steamID = GetSteamID(source)
	local discordID = GetDiscordID(source)
	local licenseID = GetLicenseID(source)
	
	if not steamID then
		reject(Config.NoSteam)
		CancelEvent()
		return
	end
	
	if discordID == 'Brak' then
		reject(Config.NoDiscord)
		CancelEvent()
		return
	end
	
	--[[if licenseID == 'Brak' then
		reject(Config.NoLicense)
		CancelEvent()
		return
	end]]
	
	if #WhiteList == 0 then
		reject(Config.WhitelistNotLoaded)
		CancelEvent()
		return
	end
	
	if #BanList == 0 then
		reject(Config.BanlistNotLoaded)
		CancelEvent()
		return
	end
	
	if #AnticheatList == 0 then
		reject(Config.BanlistNotLoaded)
		CancelEvent()
		return
	end
	
	if not Rocade(steamID, discordID, licenseID, def, source) then
		CancelEvent()
	end
end)

function AddBan(data)
	table.insert(BanList, data)
end	

AddEventHandler('banCheater', function(playerId,reason)
	if not reason then reason = "Cheating" end
	if getName(source) ~= "Console" then return end
	local targetName = GetPlayerName(playerId)
	for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
			identifier = v
		elseif string.sub(v, 1, string.len("live:")) == "live:" then
			liveid = v
		elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
			xblid  = v
		elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
			discord = v
		elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
			playerip = v
		end
	end
	MySQL.Async.execute('UPDATE exile_bans SET reason=@reason, expired=@expired, bannedby=@bannedby, isBanned=1 WHERE license=@license', {
		['@identifier'] = identifier,
		['@license'] = license,
		['@playerip'] = playerip,
		['@name'] = targetName,
		['@discord'] = discord,
		['@reason'] = reason,
		['@live'] = liveid,
		['@xbl'] = xblid,
		['@expired'] = -1,
		['@bannedby'] = "Exile AC"
		
	}, function (rowsChanged) end)
	
	DropPlayer(playerId, "Zostałeś zbanowany permamentnie za "..reason)
	exports['exile_logs']:SendLog(playerId, "Został zbanowany permamentnie za "..reason, 'anticheat', '5793266')
end)

CreateThread(function()
	local initHostName = GetConvar("sv_hostname")
	while true do
		Citizen.Wait(60000)
		SetConvar("Kolejka", tostring(#waiting))
		SetConvar("sv_hostname", (#waiting > 0 and "[" .. tostring(#waiting) .. "] " or "") .. initHostName)
	end
end)

CreateThread(function()
	local maxServerSlots = GetConvarInt('sv_maxclients', 32)
	while true do
		Citizen.Wait(Config.TimerCheckPlaces * 1000)
		CheckConnecting()
		
		if #waiting > 0 and #connecting + GetNumPlayerIndices() == maxServerSlots and nextPlayer == nil then
			if nextPushed == nil then
				FindNext()
			else
				nextPlayer = nextPushed
				nextPushed = nil
			end
		end
		if #waiting > 0 and #connecting + GetNumPlayerIndices() < maxServerSlots then
			ConnectFirst()
		end
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if #firstDisconnected > 0 then
			for k,v in pairs(firstDisconnected) do
				local now = os.time()
				if v[2] < now then
					nextPlayer = nil
					table.remove(firstDisconnected, k)
				end
			end
		else
			Citizen.Wait(20000)
		end
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if #disconnected > 0 then
			for k,v in pairs(disconnected) do
				local now = os.time()
				if v[2] < now then
					table.remove(disconnected, k)
				end
			end
		else
			Citizen.Wait(20000)
		end
	end
end)

RegisterServerEvent("exile_queue:playerKicked")
AddEventHandler("exile_queue:playerKicked", function(src, points)
	local sid = GetSteamID(src)
	Purge(sid)
end)

RegisterServerEvent("exile_queue:playerConnected")
AddEventHandler("exile_queue:playerConnected", function()
	local sid = GetSteamID(source)
	Purge(sid)
end)

AddEventHandler("playerDropped", function(reason)
	local steamID = GetSteamID(source)
	local backTicket = GetPlayerBackTicket(steamID)
	
	if backTicket == 1 then
		table.insert(disconnected, {steamID, (os.time() + 75)})
	end
	Purge(steamID)
end)

MySQL.ready(function()
	loadWhiteList()
	loadBanList()
	loadAnticheatList()
end)

-- /unban steamid
ESX.RegisterCommand('unban', {'mod', 'superadmin', 'admin'}, function(xPlayer, args, showError)
	local xPlayer = xPlayer
	if args.steamid then
		MySQL.Async.execute('UPDATE exile_bans SET isBanned=0 WHERE license=@license',
		{
			['@license']  = 'license:' .. args.steamid
		},function()
			for i=1, #BanList, 1 do
				if BanList[i] and BanList[i].license and (tostring(BanList[i].license)) == 'license:' .. tostring(args.steamid) then
					table.remove(BanList, i)
				end
			end
			if xPlayer then
				xPlayer.showNotification('[EXILE-QUEUE] ~o~Gracz został odbanowany!')
				local administrator = GetPlayerName(xPlayer.source)
				local date = os.date('*t')	
				if date.month < 10 then date.month = '0' .. tostring(date.month) end
				if date.day < 10 then date.day = '0' .. tostring(date.day) end
				if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
				if date.min < 10 then date.min = '0' .. tostring(date.min) end
				if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
				local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
			
				local UbEmbded = {
					{
						["color"] = 8663865,
						["title"] = "UNBAN",
						["description"] = "Gracz: **license:"..args.steamid.."** został odbanowany/a przez **"..administrator.."**",
						["footer"] = {
						["text"] = "BAN SYSTEM - " ..date.."",
						},
					}
				}
					
				PerformHttpRequest(UbWebhook, function(err, text, headers) end, 'POST', json.encode({username = "ExileRP", embeds = UbEmbded}), { ['Content-Type'] = 'application/json' })
			else
				local prompt = 'PROMPT'
				local date = os.date('*t')				
				if date.month < 10 then date.month = '0' .. tostring(date.month) end
				if date.day < 10 then date.day = '0' .. tostring(date.day) end
				if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
				if date.min < 10 then date.min = '0' .. tostring(date.min) end
				if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
				local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
			
				local UbEmbded2 = {
					{
						["color"] = 8663865,
						["title"] = "UNBAN",
						["description"] = "Gracz: **license:"..args.steamid.."** został odbanowany/a przez **"..prompt.."**",
						["footer"] = {
						["text"] = "BAN SYSTEM - " ..date.."",
						},
					}
				}
					
				PerformHttpRequest(UbWebhook, function(err, text, headers) end, 'POST', json.encode({username = "ExileRP", embeds = UbEmbded2}), { ['Content-Type'] = 'application/json' })
			end
		end)
	end
end, true, {help = "Komenda do odbanowywania gracza", validate = true, arguments = {
	{name = 'steamid', help = "Licencja steam", type = 'string'}
}})

-- /banhex steam nadajacy czas(w godzinach) powod
ESX.RegisterCommand('banhex', {'mod', 'superadmin', 'admin', 'best', 'support'}, function(xPlayer, args, showError)
	local xPlayer = xPlayer
	if args.steamid and tonumber(args.czas) and args.powod then
		local steamFound = false
		local steamID = args.steamid:lower()
		local tPlayer = ESX.GetPlayerFromIdentifier(steamID)
		if string.find(steamID, 'steam:') then
			steamFound = true
			if xPlayer then
				xPlayer.showNotification('[EXILE-QUEUE] ~o~Nie możesz zbanować użytkownika po steam ID. Użyj jego licencji!')
			end
		end
		if tPlayer and steamFound == false then
			local license, identifier, liveid, xblid, discord, playerip, targetName = "nieznane", "nieznane", "nieznane", "nieznane", "nieznane", "nieznane", "nieznane"
			local bannedby = nil
			if xPlayer == false then
				bannedby = "Administracja ExileRP"
			else
				bannedby = GetPlayerName(xPlayer.source)
			end

			local tokens = {}
            for i = 0, GetNumPlayerTokens(tPlayer.source) - 1 do 
                table.insert(tokens, GetPlayerToken(tPlayer.source, i))
            end
            tokens = json.encode(tokens)
			
			local reason = args.powod
			local currentDate = os.date("%d", os.time()) .. "." .. os.date("%m", os.time()) .. "." .. os.date("%Y", os.time()) .. " " .. os.date("%H", os.time()) .. ":" .. os.date("%M", os.time())
			local unixDuration
			if args.czas == -1 then
				unixDuration = -1
			else
				unixDuration = os.time() + (tonumber(args.czas) * 3600)
			end
			targetName = GetPlayerName(tPlayer.source)
		
			for k,v in ipairs(GetPlayerIdentifiers(tPlayer.source))do
				if string.sub(v, 1, string.len("license:")) == "license:" then
					license = v
				elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
					identifier = v
				elseif string.sub(v, 1, string.len("live:")) == "live:" then
					liveid = v
				elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
					xblid  = v
				elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
					discord = v
				elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
					playerip = v
				end
			end
			MySQL.Async.execute('UPDATE exile_bans SET reason=@reason, expired=@expired, bannedby=@bannedby, isBanned=1 WHERE license=@license', {
				['@identifier'] = identifier,
				['@license'] = license,
				['@playerip'] = playerip,
				['@name'] = targetName,
				['@discord'] = discord,
				['@hwid'] = tokens,
				['@reason'] = reason,
				['@live'] = liveid,
				['@xbl'] = xblid,
				['@expired'] = unixDuration,
				['@bannedby'] = bannedby
				
			}, function (rowsChanged)
				table.insert(BanList, {
					identifier = identifier,
					license = license,
					playerip = playerip,
					name = targetName,
					discord = discord,
					hwid = tokens,
					reason = reason,
					added = currentDate,
					live = liveid,
					xbl = xblid,
					expired = unixDuration,
					bannedby = bannedby,
					isbanned = "1"
				})
				if xPlayer then
					xPlayer.showNotification('[EXILE-QUEUE] ~o~Gracz został zbanowany')
				end
				local date = os.date('*t')			
				if date.month < 10 then date.month = '0' .. tostring(date.month) end
				if date.day < 10 then date.day = '0' .. tostring(date.day) end
				if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
				if date.min < 10 then date.min = '0' .. tostring(date.min) end
				if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
				local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
				
				local BanEmbded = {
					{
						["color"] = 8663865,
						["title"] = "BAN - LICENSE",
						["description"] = "**Kto:** "..targetName.." \n **Hex:** "..identifier.." \n **Licencja:** "..license.." \n **Discord:** "..discord.." \n **IP:** "..playerip.." \n **Przez:** "..bannedby.." \n **Powód:** "..reason.."" ,
						["footer"] = {
							["text"] = "BAN SYSTEM - " ..date.."",
						},
					}
				}
					
				PerformHttpRequest(BanWebhook, function(err, text, headers) end, 'POST', json.encode({username = "ExileRP", embeds = BanEmbded}), { ['Content-Type'] = 'application/json' })
			end)
			
			if args.czas == -1 then
				DropPlayer(tPlayer.source, "Zostałeś zbanowany permanentnie na tym serwerze przez " .. bannedby .. ". Powód: " .. reason)
			else
				DropPlayer(tPlayer.source, "Zostałeś zbanowany przez " .. bannedby .. ". Powód: " .. reason)
			end
		elseif not tPlayer and steamFound == false then
			local license, identifier, liveid, xblid, discord, playerip = "nieznane", "nieznane", "nieznane", "nieznane", "nieznane", "nieznane"
			local bannedby = nil
			if xPlayer == false then
				bannedby = "Administracja ExileRP"
			else
				bannedby = GetPlayerName(xPlayer.source)
			end
			local reason = args.powod
			local currentDate = os.date("%d", os.time()) .. "." .. os.date("%m", os.time()) .. "." .. os.date("%Y", os.time()) .. " " .. os.date("%H", os.time()) .. ":" .. os.date("%M", os.time())
			local unixDuration
			if args.czas == -1 then
				unixDuration = -1
			else
				unixDuration = os.time() + (tonumber(args.czas) * 3600)
			end
			MySQL.Async.execute('UPDATE exile_bans SET reason=@reason, expired=@expired, bannedby=@bannedby, isBanned=1 WHERE license=@license', {
				['@license'] = 'license:' .. steamID,
				['@identifier'] = "nieznane",
				['@playerip'] = "nieznane",
				['@name'] = "nieznane",
				['@discord'] = "nieznane",
				['@reason'] = reason,
				['@live'] = "nieznane",
				['@xbl'] = "nieznane",
				['@expired'] = unixDuration,
				['@bannedby'] = bannedby
				
			}, function (rowsChanged)
				table.insert(BanList, {
					license = 'license:' .. steamID,
					identifier = "nieznane",
					playerip = "nieznane",
					name = "nieznane",
					discord = "nieznane",
					reason = reason,
					added = currentDate,
					live = "nieznane",
					xbl = "nieznane",
					expired = unixDuration,
					bannedby = bannedby,
					isbanned = "1"
				})
				if xPlayer then
					xPlayer.showNotification('[EXILE-QUEUE] ~o~Gracz został zbanowany')
				end
				local date = os.date('*t')			
				if date.month < 10 then date.month = '0' .. tostring(date.month) end
				if date.day < 10 then date.day = '0' .. tostring(date.day) end
				if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
				if date.min < 10 then date.min = '0' .. tostring(date.min) end
				if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
				local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
			
				local BanEmbded1 = {
					{
						["color"] = 8663865,
						["title"] = "BAN - LICENSE",
						["description"] = "**Kto:** Gracz Offline \n **Licencja:** license:"..steamID.." \n **Przez:** "..bannedby.." \n **Powód:** "..reason.."" ,
						["footer"] = {
							["text"] = "BAN SYSTEM - " ..date.."",
						},
					}
				}
					
				PerformHttpRequest(BanWebhook, function(err, text, headers) end, 'POST', json.encode({username = "ExileRP", embeds = BanEmbded1}), { ['Content-Type'] = 'application/json' })
			end)
		end
	end
end, true, {help = "Komenda do banowania hex gracza", validate = true, arguments = {
	{name = 'steamid', help = "Licencja steam (bez license:)", type = 'string'},
	{name = 'czas', help = "Czas w godzinach", type = 'number'},
	{name = 'powod', help = "Powód -> użyj cudzysłowia", type = 'string'}
}})

ESX.RegisterCommand('bancheater', {'superadmin', 'best'}, function(xPlayer, args, showError)
	local xPlayer = xPlayer
	if args.licenseid and args.steamid and args.discordid and tonumber(args.czas) and args.powod then
		local licencjarockstar = args.licenseid:lower()
        local steamid = args.steamid:lower()
        local discordid = args.discordid:lower()
		local tPlayer = ESX.GetPlayerFromIdentifier(licencjarockstar)
		if not tPlayer then
			local license, identifier, liveid, xblid, discord, playerip = "nieznane", "nieznane", "nieznane", "nieznane", "nieznane", "nieznane"
			local bannedby = nil
			if xPlayer == false then
				bannedby = "Administracja ExileRP"
			else
				bannedby = GetPlayerName(xPlayer.source)
			end
			local reason = args.powod
			local currentDate = os.date("%d", os.time()) .. "." .. os.date("%m", os.time()) .. "." .. os.date("%Y", os.time()) .. " " .. os.date("%H", os.time()) .. ":" .. os.date("%M", os.time())
			local unixDuration
			if args.czas == -1 then
				unixDuration = -1
			else
				unixDuration = os.time() + (tonumber(args.czas) * 3600)
			end
			MySQL.Async.execute('UPDATE exile_bans SET reason=@reason, expired=@expired, bannedby=@bannedby, isBanned=1 WHERE license=@license', {
				['@license'] = 'license:' .. licencjarockstar,
				['@identifier'] = 'steam:' .. steamid,
				['@playerip'] = "nieznane",
				['@name'] = "nieznane",
				['@discord'] = 'discord:' .. discordid,
				['@reason'] = reason,
				['@live'] = "nieznane",
				['@xbl'] = "nieznane",
				['@expired'] = unixDuration,
				['@bannedby'] = bannedby
				
			}, function (rowsChanged)
				table.insert(BanList, {
					license = 'license:' .. licencjarockstar,
					identifier = 'steam:' .. steamid,
					playerip = "nieznane",
					name = "nieznane",
					discord = 'discord:' .. discordid,
					reason = reason,
					added = currentDate,
					live = "nieznane",
					xbl = "nieznane",
					expired = unixDuration,
					bannedby = bannedby,
					isbanned = "1"
				})
				if xPlayer then
					xPlayer.showNotification('[EXILE-QUEUE] ~o~Cheater został zbanowany')
				end
				local date = os.date('*t')			
				if date.month < 10 then date.month = '0' .. tostring(date.month) end
				if date.day < 10 then date.day = '0' .. tostring(date.day) end
				if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
				if date.min < 10 then date.min = '0' .. tostring(date.min) end
				if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
				local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
			
				local BanEmbded1 = {
					{
						["color"] = 8663865,
						["title"] = "BAN - LICENSE",
						["description"] = "**Kto:** CHEATER \n **Licencja:** license:"..licencjarockstar.." \n **HEX:** steam:"..steamid.." \n **DISCORDID:** discord:"..discordid.." \n **Przez:** "..bannedby.." \n **Powód:** "..reason.."" ,
						["footer"] = {
							["text"] = "BAN SYSTEM - " ..date.."",
						},
					}
				}
					
				PerformHttpRequest(BanWebhook, function(err, text, headers) end, 'POST', json.encode({username = "ExileRP", embeds = BanEmbded1}), { ['Content-Type'] = 'application/json' })
			end)
		end
	end
end, true, {help = "Komenda do banowania cheatera", validate = true, arguments = {
	{name = 'licenseid', help = "Licencja fivem (bez license:)", type = 'string'},
    {name = 'steamid', help = "Licencja steam (bez steam:)", type = 'string'},
    {name = 'discordid', help = "Discord ID (bez discord:)", type = 'string'},
	{name = 'czas', help = "Czas w godzinach", type = 'number'},
	{name = 'powod', help = "Powód -> użyj cudzysłowia", type = 'string'}
}})

-- /banid not by krzychu NIGGERCHUJ baza es 
ESX.RegisterCommand('banid', {'mod', 'superadmin', 'admin' , 'best', 'support'}, function(xPlayer, args, showError)
	local xPlayer = xPlayer
	if tonumber(args.id) and tonumber(args.czas) and args.powod then
		local tPlayer = ESX.GetPlayerFromId(tonumber(args.id))
		if tPlayer then
			local license, identifier, liveid, xblid, discord, playerip = "nieznane", "nieznane", "nieznane", "nieznane", "nieznane", "nieznane"
			local targetName = GetPlayerName(tPlayer.source)
			local bannedby = nil
			if xPlayer == false then
				bannedby = "Administracja ExileRP"
			else
				bannedby = GetPlayerName(xPlayer.source)
			end

			local tokens = {}
            for i = 0, GetNumPlayerTokens(tPlayer.source) - 1 do 
                table.insert(tokens, GetPlayerToken(tPlayer.source, i))
            end
            tokens = json.encode(tokens)
			
			local reason = args.powod
			local currentDate = os.date("%d", os.time()) .. "." .. os.date("%m", os.time()) .. "." .. os.date("%Y", os.time()) .. " " .. os.date("%H", os.time()) .. ":" .. os.date("%M", os.time())
			local unixDuration
			if args.czas == -1 then
				unixDuration = -1
			else
				unixDuration = os.time() + (tonumber(args.czas) * 3600)
			end
		
			for k,v in ipairs(GetPlayerIdentifiers(tPlayer.source))do
				if string.sub(v, 1, string.len("license:")) == "license:" then
					license = v
				elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
					identifier = v
				elseif string.sub(v, 1, string.len("live:")) == "live:" then
					liveid = v
				elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
					xblid  = v
				elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
					discord = v
				elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
					playerip = v
				end
			end
			MySQL.Async.execute('UPDATE exile_bans SET reason=@reason, expired=@expired, bannedby=@bannedby, isBanned=1 WHERE license=@license', {
				['@identifier'] = identifier,
				['@license'] = license,
				['@playerip'] = playerip,
				['@name'] = targetName,
				['@discord'] = discord,
				['@hwid'] = tokens,
				['@reason'] = reason,
				['@live'] = liveid,
				['@xbl'] = xblid,
				['@expired'] = unixDuration,
				['@bannedby'] = bannedby
				
			}, function (rowsChanged)
				table.insert(BanList, {
					identifier = identifier,
					license = license,
					playerip = playerip,
					name = targetName,
					discord = discord,
					hwid = tokens,
					reason = reason,
					added = currentDate,
					live = liveid,
					xbl = xblid,
					expired = unixDuration,
					bannedby = bannedby,
					isbanned = "1"
				})
				if xPlayer then
					xPlayer.showNotification('[EXILE-QUEUE] ~o~Gracz został zbanowany')
				end
				local date = os.date('*t')			
				if date.month < 10 then date.month = '0' .. tostring(date.month) end
				if date.day < 10 then date.day = '0' .. tostring(date.day) end
				if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
				if date.min < 10 then date.min = '0' .. tostring(date.min) end
				if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
				local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
			
				local BanEmbded2 = {
					{
						["color"] = 8663865,
						["title"] = "BAN - ID",
						["description"] = "**Kto:** "..targetName.." \n **Hex:** "..identifier.." \n **Licencja:** "..license.." \n **IP:** "..playerip.." \n **Przez:** "..bannedby.." \n **Powód:** "..reason.."" ,
						["footer"] = {
						["text"] = "BAN SYSTEM - " ..date.."",
						},
					}
				}
					
				PerformHttpRequest(BanWebhook, function(err, text, headers) end, 'POST', json.encode({username = "ExileRP", embeds = BanEmbded2}), { ['Content-Type'] = 'application/json' })
			end)

			if args.czas == -1 then
				DropPlayer(tPlayer.source, "Zostałeś zbanowany permanentnie na tym serwerze przez " .. bannedby .. ". Powód: " .. reason)
			else
				DropPlayer(tPlayer.source, "Zostałeś zbanowany przez " .. bannedby .. ". Powód: " .. reason)
			end
		end
	end
end, true, {help = "Komenda do banowania gracza po ID na serwerze", validate = true, arguments = {
	{name = 'id', help = "ID na serwerze", type = 'number'},
	{name = 'czas', help = "Czas w godzinach", type = 'number'},
	{name = 'powod', help = "Powód -> użyj cudzysłowia", type = 'string'}
}})

ESX.RegisterCommand('wldel', {'mod', 'superadmin', 'admin' , 'best'}, function(xPlayer, args, showError)
	if args.steamid ~= nil then
		MySQL.Async.execute('DELETE FROM whitelist WHERE identifier = @identifier', 
		{ 
			['@identifier'] = args.steamid
		}, function()
			for i=1, #WhiteList, 1 do
				if (tostring(WhiteList[i].steamID)) == tostring(args.steamid) then
					table.remove(WhiteList, i)
					break
				end
			end
		end)
	end
end, true, {help = "Komenda do banowania hex gracza", validate = true, arguments = {
	{name = 'steamid', help = "SteamID zaczynające się od steam:11", type = 'string'}
}})

ESX.RegisterCommand('wladd', {'mod', 'superadmin', 'admin' , 'best'}, function(xPlayer, args, showError)
	if args.steamid ~= nil then
		local steamID = args.steamid:lower()
		MySQL.Async.fetchAll('SELECT * FROM whitelist WHERE identifier = @identifier', {
			['@identifier'] = steamID
		}, function(result)
			if result[1] ~= nil then
				if xPlayer then
					xPlayer.showNotification('~r~[EXILE-QUEUE] ~o~The player is already whitelisted on this server!')
				end
			else
				MySQL.Async.execute('INSERT INTO whitelist (identifier, ticket, back, discord) VALUES (@identifier, @ticket, @back, @discord)', {
					['@identifier'] = steamID,
					['@ticket'] = 5,
					['@back'] = 0,
					['@discord'] = 'Brak'
				}, function(rowsChanged)
					table.insert(WhiteList, {
						steamID = steamID,
						ticketType = 5,
						backTicket = 0,
						discordID = 'Brak',
						licenseID = 'Brak'
					})
					if xPlayer then
						xPlayer.showNotification('~r~[EXILE-QUEUE] ~o~Dodano gracza: '..steamID..' na whiteliste!')
						local administrator = GetPlayerName(xPlayer.source)
						local date = os.date('*t')		
						if date.month < 10 then date.month = '0' .. tostring(date.month) end
						if date.day < 10 then date.day = '0' .. tostring(date.day) end
						if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
						if date.min < 10 then date.min = '0' .. tostring(date.min) end
						if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
						local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
					
						local WLaddEmbded = {
							{
								["color"] = "8663711",
								["title"] = "EXILE-QUEUE",
								["description"] = "Gracz: **"..steamID.."** został dodany na whiteliste przez **"..administrator.."**",
								["footer"] = {
								["text"] = "ExileRP WL System - " ..date.."",
								},
							}
						}
							
						PerformHttpRequest(WLaddWebhook, function(err, text, headers) end, 'POST', json.encode({username = "ExileRP", embeds = WLaddEmbded}), { ['Content-Type'] = 'application/json' })
					else
						local prompt = 'PROMPT'
						local date = os.date('*t')		
						if date.month < 10 then date.month = '0' .. tostring(date.month) end
						if date.day < 10 then date.day = '0' .. tostring(date.day) end
						if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
						if date.min < 10 then date.min = '0' .. tostring(date.min) end
						if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
						local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
					
						local WLaddEmbded1 = {
							{
								["color"] = "8663711",
								["title"] = "EXILE-QUEUE",
								["description"] = "Gracz: **"..steamID.."** został dodany na whiteliste przez **"..prompt.."**",
								["footer"] = {
								["text"] = "ExileRP WL System - " ..date.."",
								},
							}
						}
							
						PerformHttpRequest(WLaddWebhook, function(err, text, headers) end, 'POST', json.encode({username = "ExileRP", embeds = WLaddEmbded1}), { ['Content-Type'] = 'application/json' })
					end
				end)
			end
		end)
	end
end, true, {help = "Komenda do nadawania WLki", validate = true, arguments = {
	{name = 'steamid', help = "SteamID zaczynające się od steam:11", type = 'string'}
}})

ESX.RegisterCommand('bilet', {'superadmin', 'best'}, function(xPlayer, args, showError)
	if args.steamid and args.bilety then
		MySQL.Async.execute('UPDATE whitelist SET ticket = @ticket WHERE identifier = @identifier', {
			['@identifier'] = args.steamid,
			['@ticket'] = args.bilety
		}, function()
			for i=1, #WhiteList, 1 do
				if (tostring(WhiteList[i].steamID)) == tostring(args[1]) then
					WhiteList[i].ticketType = args.bilety
				end
			end
			if xPlayer then
				xPlayer.showNotification('~r~[EXILE-QUEUE] ~o~Gracz: '..args.steamid..' dostał '..args.bilety..' ticketów!')
				local administrator = GetPlayerName(xPlayer.source)
				local date = os.date('*t')		
				if date.month < 10 then date.month = '0' .. tostring(date.month) end
				if date.day < 10 then date.day = '0' .. tostring(date.day) end
				if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
				if date.min < 10 then date.min = '0' .. tostring(date.min) end
				if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
				local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
			
				local BiletEmbded = {
					{
						["color"] = "8663711",
						["title"] = "EXILE-QUEUE",
						["description"] = "Gracz: **"..args.steamid.."** dostał **"..args.bilety.."** ticketów od "..administrator.."!!",
						["footer"] = {
						["text"] = "ExileRP WL System - " ..date.."",
						},
					}
				}
					
				PerformHttpRequest(BiletWebhook, function(err, text, headers) end, 'POST', json.encode({username = "ExileRP", embeds = BiletEmbded}), { ['Content-Type'] = 'application/json' })
			else
				local prompt = 'PROMPT'
				local date = os.date('*t')		
				if date.month < 10 then date.month = '0' .. tostring(date.month) end
				if date.day < 10 then date.day = '0' .. tostring(date.day) end
				if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
				if date.min < 10 then date.min = '0' .. tostring(date.min) end
				if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
				local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
			
				local BiletEmbded1 = {
					{
						["color"] = "8663711",
						["title"] = "EXILE-QUEUE",
						["description"] = "Gracz: **"..args.steamid.."** dostał **"..args.bilety.."** ticketów od "..prompt.."!!",
						["footer"] = {
						["text"] = "ExileRP WL System - " ..date.."",
						},
					}
				}
					
				PerformHttpRequest(BiletWebhook, function(err, text, headers) end, 'POST', json.encode({username = "ExileRP", embeds = BiletEmbded1}), { ['Content-Type'] = 'application/json' })
			end
		end)
	end
end, true, {help = "Komenda do nadawania biletu", validate = true, arguments = {
	{name = 'steamid', help = "SteamID zaczynające się od steam:11", type = 'string'},
	{name = 'bilety', help = "Ilość biletów", type = 'number'}
}})

ESX.RegisterCommand('powrotny', {'superadmin', 'best'}, function(xPlayer, args, showError)
	if args.steamid and args.wartosc then
		MySQL.Async.execute('UPDATE whitelist SET back = @back WHERE identifier = @identifier', {
			['@identifier'] = args.steamid,
			['@back'] = args.wartosc
		}, function()
			for i=1, #WhiteList, 1 do
				if (tostring(WhiteList[i].steamID)) == tostring(args[1]) then
					WhiteList[i].back = args.wartosc
				end
			end
			if xPlayer then
				xPlayer.showNotification('~r~[EXILE-QUEUE] ~o~Gracz: '..args.steamid..' dostał '..args.wartosc..' ticketów!')
				local administrator = GetPlayerName(xPlayer.source)
				local date = os.date('*t')		
				if date.month < 10 then date.month = '0' .. tostring(date.month) end
				if date.day < 10 then date.day = '0' .. tostring(date.day) end
				if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
				if date.min < 10 then date.min = '0' .. tostring(date.min) end
				if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
				local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
				local tempString = ""
				if args.wartosc == 0 then
					tempString = "Gracz **" .. administrator .. "** zabrał bilet powrotny dla gracza **"..args.steamid.."**"
				else
					tempString = "Gracz **" .. administrator .. "** nadał bilet powrotny dla gracza **"..args.steamid.."**"
				end
				local BiletEmbded = {
					{
						["color"] = "8663711",
						["title"] = "EXILE-QUEUE",
						["description"] = tempString,
						["footer"] = {
						["text"] = "ExileRP WL System - " ..date.."",
						},
					}
				}
					
				PerformHttpRequest(BiletWebhook, function(err, text, headers) end, 'POST', json.encode({username = "ExileRP", embeds = BiletEmbded}), { ['Content-Type'] = 'application/json' })
			else
				local prompt = 'PROMPT'
				local date = os.date('*t')		
				if date.month < 10 then date.month = '0' .. tostring(date.month) end
				if date.day < 10 then date.day = '0' .. tostring(date.day) end
				if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
				if date.min < 10 then date.min = '0' .. tostring(date.min) end
				if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
				local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
				local tempString = ""
				if args.wartosc == 0 then
					tempString = "Zabrano bilet powrotny dla gracza **"..args.steamid.."** przez PROMPT"
				else
					tempString = "Nadano bilet powrotny dla gracza **"..args.steamid.."** przez PROMPT"
				end
				local BiletEmbded1 = {
					{
						["color"] = "8663711",
						["title"] = "EXILE-QUEUE",
						["description"] = tempString,
						["footer"] = {
						["text"] = "ExileRP WL System - " ..date.."",
						},
					}
				}
					
				PerformHttpRequest(BiletWebhook, function(err, text, headers) end, 'POST', json.encode({username = "ExileRP", embeds = BiletEmbded1}), { ['Content-Type'] = 'application/json' })
			end
		end)
	end
end, true, {help = "Komenda do nadawania biletu", validate = true, arguments = {
	{name = 'steamid', help = "SteamID zaczynające się od steam:11", type = 'string'},
	{name = 'wartosc', help = "0 albo 1 w zależności od tego czy posiada", type = 'number'}
}})

ESX.RegisterCommand('puszek', {'superadmin','best'}, function(xPlayer, args, showError)
	if args.steamid ~= nil then
		if nextPushed == nil then
			for k,v in pairs(waiting) do
				if v[1] == args.steamid then
					nextPushed = args.steamid
					if xPlayer then
						xPlayer.showNotification('~o~Gracz dodany')
					end
					break
				end
			end
		end
	end
end, true, {help = "Nie używać!", validate = true, arguments = {
	{name = 'steamid', help = "SteamID zaczynające się od steam:11", type = 'string'}
}})

ESX.RegisterCommand('puszek2', {'superadmin', 'best'}, function(xPlayer, args, showError)
	if nextPushed ~= nil then
		nextPushed = nil
		if xPlayer then
			xPlayer.showNotification('~o~Gracz usunięty')
		end
	end
end, true, {help = "Nie używać!", validate = true, arguments = {
}})