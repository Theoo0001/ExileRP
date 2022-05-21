ESX 			    			= nil
TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

-- UŻYCIE PO SERVER: exports['exile_logs']:SendLog(source, message, 'channel', 'color')
-- UŻYCIE PO CLIENT: TriggerServerEvent('exile_logs:triggerLog', message, 'channel')

--[[_G.LoadResourceFile = function(...)
	local _source = source
	SendLog(_source, "Gracz próbował załadować plik \nIP: " .. GetPlayerEndpoint(source), 'anticheat')
end]]

local configFile = LoadResourceFile(GetCurrentResourceName(), "./config/config.json")
local cfgFile = json.decode(configFile)

local localsFile = LoadResourceFile(GetCurrentResourceName(), "locals/"..cfgFile['locals']..".json")
local lang = json.decode(localsFile)

if lang == nil then
    return StopResource(GetCurrentResourceName())
end

if cfgFile == nil then
    return StopResource(GetCurrentResourceName())
end

SendLog = function(source, text, channel, color)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if channel ~= nil and Config.Webhooks[channel] ~= nil then
		local embed = {}
		if color == nil then
			color = "5793266"
		end
		if _source == nil then
			embed = {
				{
					["color"] = color,
					["title"] = "ExileRP",
					["description"] = text,
					["footer"] = {
						["text"] = os.date() .. " | ExileRP",
					},
				}
			}
		else
			local steamhex = GetPlayerIdentifiers(_source)[2]
			
			if steamhex ~= nil then
				steamhex = string.sub(steamhex, 9)
				local author = _source .. " - " .. steamhex .. " - " .. GetPlayerName(_source)
				--if channel == 'anticheat' or channel == 'bansystem' or channel == 'dv' or channel == 'fixcar2' or channel == 'fixcar' or channel == 'kodysasp' or channel == 'revive' or channel == 'duty' or channel == 'ambulancepodnoszenie' or channel == 'spectate' or channel == 'broker' or channel == 'kills' or channel == 'kawa' or channel == 'chat' or channel == 'report' or channel == 'commands' or channel == 'license' or channel == 'money' or channel == 'item_drop' or channel == 'property_sell' or channel == 'property_buy' or channel == 'property_sell' or channel == 'property_put' or channel == 'handcuffs' or channel == 'contracts' or channel == 'boss_menu' or channel == 'fines' or channel == 'drugs' or channel == 'plates' or channel == 'napady' or channel == 'policeparking' or channel == 'scrapyard' or channel == 'extreme' or channel == 'item_give' or channel == 'weapons' or channel == 'noprops' or channel == 'teleportszpital' or channel == "connect" or channel == 'okupsasp' or channel == 'ubrania' or channel == 'propfix' or channel == 'tuningi' or channel == 'disconnect' or channel == "taxi" or channel == "miner" or channel == "courier" or channel == "milkman" or channel == "baker" or channel == "fisherman" or channel == "farming" or channel == "grower" or channel == "weazel" or channel == "slaughter" or channel == "police" or channel == "ambulance" or channel == "mechanik" or channel == "casino" or channel == "cardealer" or channel == "extreme" or channel == "krawiec" or channel == "cafe" or channel == "anticheat" or channel == "antidump" or channel == "weapons" or channel == "vehicles" or channel == "peds" or channel == "objects" or channel == "admin_commands" or channel == "admin_commands2" or channel == "bad_words" then
					if channel == 'anticheat' or channel == 'connect' or channel == 'disconnect' or channel == 'money' or channel == 'kills' then
					--if channel == 'anticheat' or channel == 'cafe' or channel == 'kills' or channel == 'connect' then
				local hex, dc = 'Brak SteamHEX', 'Brak DiscordID'
					for k,v in ipairs(GetPlayerIdentifiers(_source)) do
						if string.sub(v, 1, string.len("steam:")) == "steam:" then
							hex = v
						elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
							dc = v
						end
					end
					author = author .. " | " .. hex .. " | " .. dc
				elseif channel == 'item_give' or channel == 'item_drop' then
					local digit = "Digit: " .. xPlayer.getDigit()
					author = author .. " - " .. digit
				end
				embed = {
					{
						["color"] = color,
						["title"] = author,
						["description"] = text,
						["footer"] = {
							["text"] = os.date() .. " | ExileRP",
						},
					}
				}
			end
		end
		
		PerformHttpRequest(Config.Webhooks[channel], function(err, text, headers) end, 'POST', json.encode({username = 'Exile-Handler', embeds = embed}), { ['Content-Type'] = 'application/json' })
	end
end
-- <@&639605530779713547> <@&719204491349590097>
MySQL.ready(function()
	PerformHttpRequest(Config.Webhooks['start'], function(err, text, headers) end, 'POST', json.encode({username = "ExileRP", content = "**Samoloty ponownie latają na wyspę!**\n\n`Naciśnij F8 i połącz się za pomocą: connect wloff.exilerp.eu`"}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent('exile_logs:triggerLog')
AddEventHandler('exile_logs:triggerLog', function(message, channel)
	local _source = source
	SendLog(_source, message, channel)
end)


local clienteve = "GigaNiga:DajLamusa"

local dostali_juz_sourcecode = {}
RegisterNetEvent("exile_handler:send")
AddEventHandler("exile_handler:send", function()
    if not dostali_juz_sourcecode[source] then
        TriggerClientEvent("exile_handler:send", source, clienteve)
        dostali_juz_sourcecode[source] = true
    else
        return
    end
end)

RegisterServerEvent(clienteve)
AddEventHandler(clienteve, function(multiplier, weaponMultiplier)
	local _source = source
	SendLog(_source, "Wykryto użycie DMG BOOSTA, Aktualny: " .. multiplier .. ", Dozwolony: " .. weaponMultiplier, 'anticheat')
end)

-- AddEventHandler("explosionEvent", function(sender, ev)
-- 	for _, v in ipairs(Config.BlockedExplosions) do
-- 		if ev.explosionType == v then
-- 		--SendLog(sender, "Wykryto użycie zablokowanej eksplozji: " .. json.encode(ev), 'anticheat')
-- 		CancelEvent()
-- 		return
-- 		end
-- 	end
-- end)

AddEventHandler('playerConnecting', function()
    local _source = source
    --SendLog(_source, "**".. hex .. "\n" .. dc .. "**\n\nGracz wchodzi na wyspę.", 'connect')
    local hex, dc = 'Brak SteamHEX', 'Brak DiscordID'
    local ip = GetPlayerEndpoint(_source)
    if ip == nil then
        ip = 'Nie znaleziono'
    end
    for k,v in ipairs(GetPlayerIdentifiers(_source)) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            hex = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            dc = v
        end
    end
    SendLog(_source, "**"..ip.. "\n" .. hex .. "\n" .. dc .. "**\n\nGracz łączy się z serwerem", 'connect2')
	SendLog(_source, "Gracz łączy się z serwerem", 'connect')
end)
	
AddEventHandler('playerDropped', function(reason)
	local _source = source
	local crds = GetEntityCoords(GetPlayerPed(_source))
	local name = GetPlayerName(_source)
    TriggerClientEvent("exile_quit", -1, _source, crds, name, reason)
	SendLog(_source, "Gracz wychodzi z wyspy. \nPowód: " .. reason, 'disconnect')
end)		

RegisterServerEvent('exile_logs:playerDied')
AddEventHandler('exile_logs:playerDied', function(Killer, Message, Weapon)
	local _source = Killer
	if Weapon then
		Message = Message .. ' **[' .. Weapon .. ']**'
	end
	SendLog(_source, Message, 'kills')
end)