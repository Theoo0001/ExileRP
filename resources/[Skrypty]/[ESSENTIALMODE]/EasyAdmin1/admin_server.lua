ESX = nil

TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

permissions = {
	ban = false,
	kick = false,
	revive = false,
	spectate = false,
	unban = false,
	teleport = false,
	manageserver = false,
	slap = false,
	freeze = false,
	invisible = false,
	invincible = false,
	modifyspeed = false,
	noclip = false,
	vehicles = false
}

local OnlineAdmins = {}
local LastPlayers = {}

AddEventHandler('playerDropped', function (reason)	
	if OnlineAdmins[source] then
		OnlineAdmins[source] = nil
	end
end)

RegisterServerEvent('EasyAdmin:amiadmin')
AddEventHandler("EasyAdmin:amiadmin", function()	
	if OnlineAdmins[source] then
		OnlineAdmins[source] = nil
	end
	
	local identifiers = GetPlayerIdentifiers(source)
	local perms = {}
	for perm, val in pairs(permissions) do
		local thisPerm = DoesPlayerHavePermission(source, "easyadmin."..perm)

		if thisPerm == true then
			OnlineAdmins[source] = true 
		end
		
		perms[perm] = thisPerm
	end
	
	TriggerClientEvent("EasyAdmin:SetPermissions", source, perms)
	
	if GetConvar("ea_alwaysShowButtons", "false") == "true" then
		TriggerClientEvent("EasyAdmin:SetSetting", source, "forceShowGUIButtons", true)
	else
		TriggerClientEvent("EasyAdmin:SetSetting", source, "forceShowGUIButtons", false)
	end
	
end)

function GetOnlineAdmins()
	return OnlineAdmins
end

function IsPlayerAdmin(pid)
	return OnlineAdmins[pid]
end


function DoesPlayerHavePermission(player, object)
	local haspermission = false
	if (player == 0 or player == "") then
		return true
	end
	
	if IsPlayerAceAllowed(player,object) then -- check if the player has access to this permission
		haspermission = true
	else
		haspermission = false
	end

	return haspermission
end

CreateThread(function()	
	RegisterServerEvent("EasyAdmin:kickPlayer")
	AddEventHandler('EasyAdmin:kickPlayer', function(playerId,reason)
		if DoesPlayerHavePermission(source,"easyadmin.kick") then
			DropPlayer(playerId, string.format('Wyrzucony przez %s, Powód: %s', GetPlayerName(source), reason) )
		end
	end)

	RegisterServerEvent("csskrouble:callRzadowy", function(playerId) 
		if DoesPlayerHavePermission(source,"easyadmin.spectate") then 
			TriggerClientEvent("csskrouble:rzadowyCalled", playerId, GetPlayerName(source))
		end
	end)
	
	RegisterServerEvent("EasyAdmin:RequestSpectate")
	AddEventHandler('EasyAdmin:RequestSpectate', function(playerId)
		if DoesPlayerHavePermission(source,"easyadmin.spectate") then			
			local xPlayer = ESX.GetPlayerFromId(playerId)
			if xPlayer ~= nil then
				local coords = GetEntityCoords(GetPlayerPed(playerId))
				TriggerClientEvent("EasyAdmin:requestSpectate", source, playerId, coords)
				
				local czas = os.date("%Y/%m/%d %X")
				exports['exile_logs']:SendLog(source, "Administrator: "..GetPlayerName(source).."\n Administrator ID: " ..source.. " \nGracz: "..GetPlayerName(playerId).. "\nGracz ID: "..playerId.."\nData: "..czas, 'spectate', '5793266')
			end
		end
	end)
	-- logi gdzie kurwa do teg poczekaj 
	RegisterCommand('crash', function(source, id, user)
		if source == 0 then
			if GetPlayerPing(id[1]) == 0 then
				TriggerEvent('sendMessageDiscord', "Niema nikogo o takim ID")
			else
				TriggerClientEvent("EasyAdmin:CrashPlayer", id[1])
				TriggerEvent('sendMessageDiscord', 'Crash gracza: '..id[1])			
			end
		else
			local xPlayer = ESX.GetPlayerFromId(source)
			if DoesPlayerHavePermission(source,"easyadmin.slap") then
				if id[1] ~= nil then
					if GetPlayerPing(id[1]) == 0 then
						TriggerClientEvent("pNotify:SendNotification", source, {text = "Niema nikogo o takim ID"})
						return
					end
					TriggerClientEvent("EasyAdmin:CrashPlayer", id[1])
				end
			end
		end
	end, false)
	
	RegisterServerEvent("EasyAdmin:FreezePlayer")
	AddEventHandler('EasyAdmin:FreezePlayer', function(playerId,toggle)
		if DoesPlayerHavePermission(source,"easyadmin.freeze") then
			TriggerClientEvent("EasyAdmin:FreezePlayer", playerId, toggle)
		end
	end)
	
	RegisterServerEvent('EasyAdmin:TeleportPlayerToSource')
	AddEventHandler('EasyAdmin:TeleportPlayerToSource', function(playerId, secondId, state)		
		local coords = GetEntityCoords(GetPlayerPed(playerId))
		local coords2 = GetEntityCoords(GetPlayerPed(secondId))
		
		local event = 'EasyAdmin:TeleportRequestScoped'
		if #(coords - coords2) < 430 then
			event = 'EasyAdmin:TeleportRequest'
		end
		
		if state then
			TriggerClientEvent(event, secondId, playerId, coords)
		else
			TriggerClientEvent(event, secondId, playerId, coords)
		end
	end)
end)

function checkIsAdmin(src) 
	local is = false
	if DoesPlayerHavePermission(src,"easyadmin.spectate") then
		is = true
	end
	return is
end

ESX.RegisterServerCallback('EasyAdmin:players', function(source, cb, cached)	
	if not cached then
		cb(LastPlayers)
	else
		LastPlayers = {}
		
		for _, playerId in ipairs(GetPlayers()) do					
			table.insert(LastPlayers, {
				id = tonumber(playerId),
				name = GetPlayerName(playerId),
				admin = checkIsAdmin(playerId)
			})
		end
		
		table.sort(LastPlayers, function(a, b)
			if a.id ~= b.id then
				return a.id < b.id
			end
		end)
		
		cb(LastPlayers)
	end
end)

function SendLog(name, message, link)
	local embeds = {
		{
			["description"]=message,
			["type"]="rich",
			["color"] =5793266,
			["image"]= {
				["url"]=link
			},
			["footer"]=  {
			["text"]= "ExileRP",
			},
		}
	}
	if message == nil or message == '' then return FALSE end
	
	local webhook = 'https://discord.com/api/webhooks/920300260935483393/cFpHbhgeMichPf72tDiT_gTsQS_4vBqPTDIH5xNzo7Afj50jDGAfa4OMWJmcJ8s_gODa'	
	PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent("EasyAdmin:jebacDisa")
AddEventHandler("EasyAdmin:jebacDisa", function(target, name) 
	TriggerClientEvent("csskrouble_ea:zrubskrina", target, name)
end)

RegisterNetEvent("EasyAdmin:falszywyPedalJebany")
AddEventHandler("EasyAdmin:falszywyPedalJebany", function(link, name) 
	local src = source
	local steamid  = "Brak"
	local license  = "Brak"
	local discord  = "Brak"

	for k,v in pairs(GetPlayerIdentifiers(src))do
			if string.sub(v, 1, string.len("steam:")) == "steam:" then
				steamid = v
			elseif string.sub(v, 1, string.len("license:")) == "license:" then
				license = v
			elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
				discord = v
			end
		
	end
	SendLog("Screenshot", "Wykonano screenshot gracza `"..GetPlayerName(src).."` dla admina `"..name.."`\n\nID: "..src.."\nSteam: "..steamid.."\nLicencja: "..license.."\nDiscord: "..discord, link)
end)

ESX.RegisterServerCallback('EasyAdmin:daneInnegoGracza', function(source, cb, target)

    local xPlayer = ESX.GetPlayerFromId(target)
    if xPlayer ~= nil then
		local data = {
			name = GetPlayerName(target),
			money = xPlayer.money,
			idd = xPlayer.source,
			inventory = xPlayer.inventory,
			accounts  = xPlayer.accounts,
			firstname = firstname,
			lastname  = lastname,
			sex       = sex,
			dob       = dob,
			height    = height,
			money     = xPlayer.getMoney(),
			bank = xPlayer.getAccount('bank').money,
			job = xPlayer.job,
			hiddenjob = xPlayer.hiddenjob,
			hex = xPlayer.identifier,
		}


		cb(data)
    end
end)