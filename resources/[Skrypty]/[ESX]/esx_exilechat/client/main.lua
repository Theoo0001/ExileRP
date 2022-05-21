local group 
local dontreport = false
local showkurwaid = true
kick = 1800
kickostrzezenie = true

ESX =					nil

local opisy = {}

local isLogouted = false

CreateThread(function()
	while ESX == nil do
		TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) 
			ESX = obj
		end)
		
		Citizen.Wait(250)
	end
	
    Citizen.Wait(5000)
    TriggerServerEvent('exile_chat:checkBlocklist')
	ESX.PlayerData = ESX.GetPlayerData()

	ESX.TriggerServerCallback('ExileRP:ZapodajOpisyZPrzedWejscia', function(opis) -- :D 🌘
		opisy = opis
	end)
	SendNUIMessage({
		type = "set_id",
		id = GetPlayerServerId(PlayerId())
	})
end)

local pCoords
CreateThread(function()
	while true do
		local ped = PlayerPedId()
		pCoords = GetEntityCoords(ped)
		
		Citizen.Wait(500)
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setGroup')
AddEventHandler('esx:setGroup', function(group)
	ESX.PlayerData.group = group
end)

RegisterCommand("tpm", function(source)
    TeleportToWaypoint()
		TriggerServerEvent('exile_logs:triggerLog', "Przeteleportował się do markera", 'tpm')
end)

TeleportToWaypoint = function()
	if ESX and ESX.PlayerData.group == 'trialsupport' or ESX.PlayerData.group == 'support' or ESX.PlayerData.group == 'mod' or ESX.PlayerData.group == 'admin' or ESX.PlayerData.group == 'superadmin' or ESX.PlayerData.group == 'best' then			
		local blip = GetFirstBlipInfoId(8)
		local playerPed = PlayerPedId()
		
		if blip ~= 0 then
			if IsPedInAnyVehicle(playerPed, false) then
				local vehicle = GetVehiclePedIsIn(playerPed, false)
				if GetPedInVehicleSeat(vehicle, -1) == playerPed then
					playerPed = vehicle
				else
					playerPed = nil
				end
			end

			local coord = GetBlipCoords(blip)
			local unused, ground = GetGroundZFor_3dCoord(coord.x, coord.y, 99999.0, 0)
			
			if ground == 0 then
				SetEntityCoords(playerPed, coord.x, coord.y, 0)
				
				local tries = 0
				while ground == 0 and tries < 2000 do
					Citizen.Wait(100)
					unused, ground = GetGroundZFor_3dCoord(coord.x, coord.y, 99999.0, 0)
					tries = tries + 1
				end
				
				SetEntityCoordsNoOffset(playerPed, coord.x, coord.y, ground + 2.0, true, true, true)
				RemoveBlip(blip)
			else
				SetEntityCoordsNoOffset(playerPed, coord.x, coord.y, ground + 2.0, true, true, true)
				RemoveBlip(blip)
			end
		else
			ESX.ShowNotification('Nie zaznaczono znacznika na mapie')
		end	
	else
		ESX.ShowNotification("Nie możesz tego zrobić")
	end
end


CreateThread(function()
	while true do
		Citizen.Wait(1000)
		gracz = PlayerPedId()
		if gracz then
			pozycja = GetEntityCoords(gracz, true)
			local bw = exports['esx_ambulancejob']:isDead()
			local isJailed = exports['esx_jailer']:getJailStatus()
			if pozycja == starapozycja and not bw and not isJailed then
				if time > 0 then
					if kickostrzezenie and time == math.ceil(kick / 30) then
						TriggerEvent('chat:addMessage1',"SYSTEM", {255, 0, 0}, "Zostaniesz wyrzucony za "..time .. " sekund za nieaktywność!", "fas fa-bell")
					end
					time = time - 1
				else
					TriggerServerEvent("wyjebzaafk")
				end
			else
				time = kick
			end
			starapozycja = pozycja
		end
	end
end)

RegisterCommand("adminoff", function(source)
    ESX.TriggerServerCallback("esx_marker:fetchUserRank", function(playerRank)
        if playerRank == "best" then
            if dontreport == false then
                dontreport = true
                ESX.ShowNotification("Pomyślnie wyłączono reporty!")
            else
                dontreport = false
                ESX.ShowNotification("Pomyślnie włączono reporty!")
            end
        end
    end)
end)

RegisterCommand("adminidoff", function(source)
    ESX.TriggerServerCallback("esx_marker:fetchUserRank", function(playerRank)
        if playerRank ~= "user" then
            if showkurwaid == true then
                showkurwaid = false
                ESX.ShowNotification("Pomyślnie wyłączono id!")
            else
                showkurwaid = true
                ESX.ShowNotification("Pomyślnie włączono id!")
            end
        end
    end)
end)

RegisterNetEvent('sendProximityMessage')
AddEventHandler('sendProximityMessage', function(name, id, group, message)
	local pid = GetPlayerFromServerId(id)
	
	if pid == -1 then
		return
	end
	
	if pid ~= PlayerId() then
		local ped = Citizen.InvokeNative(0x43A66C31C68491C0, pid)
		if #(pCoords - GetEntityCoords(ped, true)) > 19.99 then
			return
		end
	end
	
	if Config.group[group] ~= nil then
		TriggerEvent('chat:addMessage1',"[" .. id .. "] ".. name, {26, 26, 26}, message, "fas fa-comment-dots", Config.group[group])
	else
		TriggerEvent('chat:addMessage1',"[" .. id .. "] ".. name, {26, 26, 26}, message, "fas fa-comment-dots")
	end
end)


RegisterNetEvent('sendProximityMessageDarkWeb')
AddEventHandler('sendProximityMessageDarkWeb', function(message, playerId)
	if ESX and ESX.PlayerData.job.name ~= 'police' and ESX.PlayerData.job.name ~= 'offpolice' then
		if ESX.PlayerData.group == 'trialsupport' or ESX.PlayerData.group == 'support' or ESX.PlayerData.group == 'mod' or ESX.PlayerData.group == 'admin' or ESX.PlayerData.group == 'superadmin' or ESX.PlayerData.group == 'best' and showkurwaid then
			TriggerEvent('chat:addMessage1','[' .. playerId .. '] ' .. "^*Darkweb", {115, 25, 25}, message, "fas fa-laptop")
		else
			TriggerEvent('chat:addMessage1',"^*Darkweb", {115, 25, 25}, message, "fas fa-laptop")
		end
	end
end)

RegisterNetEvent('sendProximityMessageTweet')
AddEventHandler('sendProximityMessageTweet', function(title, message, playerId)
	if not isLogouted then
		if ESX and ESX.PlayerData.group == 'trialsupport' or ESX.PlayerData.group == 'support' or ESX.PlayerData.group == 'mod' or ESX.PlayerData.group == 'admin' or ESX.PlayerData.group == 'superadmin' or ESX.PlayerData.group == 'best' and showkurwaid then
			TriggerEvent('chat:addMessage1', '^*[' .. playerId .. '] ' .. title, {24, 133, 217}, message, "fab fa-twitter")
		else
			TriggerEvent('chat:addMessage1', "^*"..title, {24, 133, 217}, message, "fab fa-twitter")
		end
	end
end)

RegisterCommand('twt', function(source, args, user)
	if exports['gcphone']:getMenuIsOpen() then
		TriggerServerEvent("sendProximityMessageTweetServer", table.concat(args, " "))
	else
		ESX.ShowNotification('Musisz wyciągnąć telefon żeby napisać wiadomość')
	end
end, false)

RegisterCommand('dw', function(source, args, user)	
	if exports['gcphone']:getMenuIsOpen() then
		TriggerServerEvent("sendProximityMessageDarkWebServer", table.concat(args, " "))
	else
		ESX.ShowNotification('Musisz wyciągnąć telefon żeby napisać wiadomość')
	end
end, false)
local font = 4 
local time = 6000 
local nbrDisplaying = 1

RegisterNetEvent('esx_rpchat:triggerDisplay')
AddEventHandler('esx_rpchat:triggerDisplay', function(text, source, color)
	local player = GetPlayerFromServerId(source)
    if player ~= -1 then
		local offset = 0 + (nbrDisplaying*0.14)
		Display(GetPlayerFromServerId(source), text, offset, color)
	end
end)

function Display(mePlayer, text, offset, color)
    local displaying = true
    CreateThread(function()
        Wait(time)
        displaying = false
    end)
    CreateThread(function()
        nbrDisplaying = nbrDisplaying + 1
        while displaying do
            Wait(0)
			local ped = Citizen.InvokeNative(0x43A66C31C68491C0, mePlayer)
            local coordsMe = GetEntityCoords(ped, false)
            local coords = GetEntityCoords(PlayerPedId(), false)
			
			if #(coordsMe - coords) < 19.99 then
				if IsEntityVisible(Citizen.InvokeNative(0x43A66C31C68491C0, mePlayer)) then
					DrawText3D(coordsMe['x'], coordsMe['y'], coordsMe['z'] + 0.75 + offset, text, color)
				end			
			end
        end
        nbrDisplaying = nbrDisplaying - 1
    end)
end

function DrawText3D(x,y,z, text, color)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    local dist = #(vec3(px, py, pz) - vec3(x, y, z))

    local scale = (1/dist)*1.7
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextCentre(true)


        BeginTextCommandWidth("STRING")
        AddTextComponentString(text)
        local height = GetTextScaleHeight(0.55*scale, font)
        local width = EndTextCommandGetWidth(font)

        -- Diplay the text
        SetTextEntry("STRING")
        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)
		DrawRect(_x+0.0011, _y+scale/50, width*1.1, height*1.2, color.r, color.g, color.b, 100)
    end
end

RegisterNetEvent('sendProximityMessageMe')
AddEventHandler('sendProximityMessageMe', function(id, name, message)
	local pid = GetPlayerFromServerId(id)

	if pid == -1 then
		return
	end
	
	if pid ~= PlayerId() then
		local ped = Citizen.InvokeNative(0x43A66C31C68491C0, pid)
		if #(pCoords - GetEntityCoords(ped, true)) > 19.99 then
			return
		end
	end
	
	local ped = Citizen.InvokeNative(0x43A66C31C68491C0, pid)
    if IsEntityVisible(ped) then	
			TriggerEvent('chat:addMessage1', "^*"..name, {201, 14, 189}, " ".." " .. message, "fas fa-comment-dots", {255, 255, 255})
	end
end)
RegisterNetEvent('sendProximityMessageZ')
AddEventHandler('sendProximityMessageZ', function(id, name, message)
	local pid = GetPlayerFromServerId(id)

	if pid == -1 then
		return
	end
	
	if pid ~= PlayerId() then
		local ped = Citizen.InvokeNative(0x43A66C31C68491C0, pid)
		if #(pCoords - GetEntityCoords(ped, true)) > 19.99 then
			return
		end
	end
	
	local ped = Citizen.InvokeNative(0x43A66C31C68491C0, pid)
    if IsEntityVisible(ped) then	
			TriggerEvent('chat:addMessage1', "^*"..name, {20, 20, 20}, " Rozgląda się uważnie", "fas fa-clipboard-list", {255, 255, 255})
	end
end)

--[[RegisterNetEvent('sendProximityMessageMe')
AddEventHandler('sendProximityMessageMe', function(id, name, text)
	local pid = GetPlayerFromServerId(id)

	if pid == -1 then
		return
	end
	
	if pid ~= PlayerId() then
		local ped = Citizen.InvokeNative(0x43A66C31C68491C0, pid)
		if #(pCoords - GetEntityCoords(ped, true)) > 19.99 then
			return
		end
	end
	
	local ped = Citizen.InvokeNative(0x43A66C31C68491C0, pid)
    if IsEntityVisible(ped) then	
		TriggerEvent('chatMessage',"^*Obywatel["  .. name .. "] " .. text, {255, 152, 247})
	end
end)]]

--[[RegisterNetEvent('sendProximityMessageMe')
AddEventHandler('sendProximityMessageMe', function(id, name, message)
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)
	if pid == myId then
		TriggerEvent('chatMessage', "^*Obywatel [".. name .."]", {256, 202, 247}, " ".." " .. message)
	elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
		TriggerEvent('chatMessage', "^*Obywatel [".. name .."]", {256, 202, 247}, " ".." " .. message)
	end
end)]]

RegisterNetEvent('sendProximityMessageDo')
AddEventHandler('sendProximityMessageDo', function(id, name, message)
	local pid = GetPlayerFromServerId(id)

	if pid == -1 then
		return
	end
	
	if pid ~= PlayerId() then
		local ped = Citizen.InvokeNative(0x43A66C31C68491C0, pid)
		if #(pCoords - GetEntityCoords(ped, true)) > 19.99 then
			return
		end
	end
	
	local ped = Citizen.InvokeNative(0x43A66C31C68491C0, pid)
	if IsEntityVisible(ped) then
		TriggerEvent('chat:addMessage1', "^*"..name, {224, 148, 219}, " ".." " .. message, "fas fa-comment-dots", {255, 255, 255})
	end
end)

RegisterNetEvent('sendProximityMessageCzy')
AddEventHandler('sendProximityMessageCzy', function(id, name, message, czy)
	local pid = GetPlayerFromServerId(id)
	
	if pid == -1 then
		return
	end
	
	if pid ~= PlayerId() then
		local ped = Citizen.InvokeNative(0x43A66C31C68491C0, pid)
		if #(pCoords - GetEntityCoords(ped, true)) > 19.99 then
			return
		end
	end

	local ped = Citizen.InvokeNative(0x43A66C31C68491C0, pid)
	if IsEntityVisible(ped) then
		if czy == 1 then
			--TriggerEvent('chatMessage',"^*🎲 Obywatel(TRY) [" .. name .. "] TAK", {256, 202, 247})
			TriggerEvent('chat:addMessage1', name, {44, 7, 56}, "Udane", "fas fa-dice", {255, 255, 255})
		elseif czy == 2 then
			--TriggerEvent('chatMessage',"^*🎲 Obywatel(TRY) [" .. name .. "] NIE", {256, 202, 247})
			TriggerEvent('chat:addMessage1', name, {44, 7, 56}, "Nieudane", "fas fa-dice", {255, 255, 255})
		end
	end	
end)

RegisterNetEvent('esx_exilechat:pokazOpisChat')
AddEventHandler('esx_exilechat:pokazOpisChat', function(id, name, text)
	local pid = GetPlayerFromServerId(id)
	
	if pid == -1 then
		return
	end
	
	if pid ~= PlayerId() then
		local ped = Citizen.InvokeNative(0x43A66C31C68491C0, pid)
		if #(pCoords - GetEntityCoords(ped, true)) > 19.99 then
			return
		end
	end
	
	local ped = Citizen.InvokeNative(0x43A66C31C68491C0, pid)
	if IsEntityVisible(ped) then	
		--TriggerEvent('chatMessage',"^*Obywatel[" .. id .. "] ", {240, 240, 240})
		TriggerEvent('chat:addMessage1', id, {240, 240, 240}, " "..name.." ", "fas fa-id-badge")
	end
end)

--------------------------
----- ME / DO / OPIS -----
--------------------------

------------------
-----  OPIS  -----
------------------
local displayOpisHeight = -0.1


RegisterNetEvent('ExileRP:opis')
AddEventHandler('ExileRP:opis', function(player, opis)
    local info = opis
    local ajdi = player
    opisy[ajdi] = info
end)


RegisterNetEvent('ExileRP:opisInnychGraczy')  -- to jest chyba useless
AddEventHandler('ExileRP:opisInnychGraczy', function()
    local AjDi = GetPlayerServerId(PlayerId())
    local MojOpis = opisy[AjDi]
    TriggerServerEvent('ExileRP:opisInnychGraczyServer', AjDi, MojOpis)
end)

CreateThread(function()
    while true do
        Citizen.Wait(0)
		local found = false
        for _, player in ipairs(GetActivePlayers()) do
			local ajdi = GetPlayerServerId(player)
            if (opisy[ajdi] ~= nil and tostring(opisy[ajdi]) ~= '') then

				local ped = Citizen.InvokeNative(0x43A66C31C68491C0, player)
				local playerCoords = pCoords
				local targetCoords = GetEntityCoords(ped, true)
				local targetheading = GetEntityHeading(ped)
				local distance2 = #(playerCoords - targetCoords)

				if distance2 < 20 and IsEntityVisible(ped) then
					local veh = GetVehiclePedIsIn(ped, false)
					found = true
					local x, y, z = targetCoords.x, targetCoords.y, targetCoords.z
					if veh ~= 0 then
						for i = -1, 6 do
							PedInVeh = GetPedInVehicleSeat(veh, i)
							if PedInVeh == ped then
								if i == -1 then
									cord = GetObjectOffsetFromCoords(x, y, z, targetheading, -0.45, 0.5, 0.5)
								elseif i == 0 then
									cord = GetObjectOffsetFromCoords(x, y, z, targetheading, 0.45, 0.5, 0.5)
								elseif i == 1 then
									cord = GetObjectOffsetFromCoords(x, y, z, targetheading, -0.45, -0.3, 0.5)
								elseif i == 2 then
									cord = GetObjectOffsetFromCoords(x, y, z, targetheading, 0.45, -0.3, 0.5)
								elseif i == 3 then
									cord = GetObjectOffsetFromCoords(x, y, z, targetheading, -0.45, 0.5, 0.5)
								elseif i == 4 then
									cord = GetObjectOffsetFromCoords(x, y, z, targetheading, 0.45, 0.5, 0.5)
								elseif i == 5 then
									cord = GetObjectOffsetFromCoords(x, y, z, targetheading, -0.45, -0.3, 0.5)
								elseif i == 6 then
									cord = GetObjectOffsetFromCoords(x, y, z, targetheading, 0.45, -0.3, 0.5)
								end
								if cord then
									x, y, z = cord.x, cord.y, cord.z
								end
							end
						end
					end
					local tekst = tostring(opisy[ajdi])
					DrawText3DOpis(x, y, z + displayOpisHeight, tekst)
				end
            end
        end
		if not found then
			Citizen.Wait(400)
		end
    end
end)

function DrawText3DOpis(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = #(vec3(px, py, pz) - vec3(x, y, z))

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov*0.6

    if onScreen then
        SetTextScale(0.30, 0.30)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

RegisterNetEvent("textsent")
AddEventHandler('textsent', function(tPID, names2)
	ESX.ShowNotification('~w~Odpowiedź wysłana do [~o~'..tPID.."~w~] ~o~"..names2)
end)

RegisterNetEvent("textmsg")
AddEventHandler('textmsg', function(source, textmsg, names2, names3 )
	TriggerEvent('chat:addMessage1', "["..source.."] "..names3, {252, 123, 3}, textmsg, "fas fa-user-shield")
end)

amountR = 0

RegisterNetEvent("acceptedReport", function(name, id, reportId, reporter, content) 
	local pid = GetPlayerFromServerId(id)
	local pidd = GetPlayerFromServerId(reporter)
	if PlayerId() == pidd then
		TriggerEvent('chat:addMessage1', "Twój report #"..reportId, {15, 110, 26}, " ".."został przyjęty przez ^1 ["..id.."] "..name, "fas fa-flag")

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'report_rate',
			{
				title    = 'Oceń pomoc ⭐',
				align    = 'center',
				elements = {
					{label = 'Bardzo dobra', value = '5'},
					{label = 'Dobra', value = '4'},
					{label = 'Przeciętna', value = '3'},
					{label = 'Słaba', value = '2'},
					{label = 'Bardzo słaba', value = '1'}
				}
			},
			function(data, menu)
				TriggerServerEvent("csskrouble:rateReport", data.current.value, "["..id.."] "..name, content)
				ESX.ShowNotification("~g~Dziękujemy za opinie!")
				menu.close()
			end,
			function(data, menu)
				menu.close()
			end
		)
	elseif ESX and (ESX.PlayerData.group == 'trialsupport' or ESX.PlayerData.group == 'support' or ESX.PlayerData.group == 'mod' or ESX.PlayerData.group == 'admin' or ESX.PlayerData.group == 'superadmin' or ESX.PlayerData.group == 'best') and pid ~= myId and not dontreport then
		SendNUIMessage({
			type = "add_report",
			data = {
				reason = "Report został przyjęty przez ["..id.."] "..name,
				id = "#"..reportId,
				name = ""
			}
		})
		TriggerEvent('chat:addMessage1', "Report #"..reportId, {15, 110, 26}, " ".."został przyjęty przez ^1 ["..id.."] "..name, "fas fa-flag")
	end
end)
RegisterNetEvent('sendReport')
AddEventHandler('sendReport', function(reportId, id, name, message, admins)
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)
	if pid == myId then
		amountR = amountR + 1
		CreateThread(function() 
			Wait(60000)
			amountR = amountR - 1
		end)
		if amountR >= 10 then
			TriggerServerEvent("csskrouble:banReport", id)
			return
		end	
		if admins == 0 then
			TriggerEvent('chat:addMessage1', "^*Report #"..reportId, {252, 123, 3}, " Obecnie nie ma administracji na serwerze!", "fas fa-flag")
		elseif admins == 1 then
			TriggerEvent('chat:addMessage1', "^*Report #"..reportId, {252, 123, 3}, " Wysłano do "..admins.. " administratora", "fas fa-flag")
		else
			TriggerEvent('chat:addMessage1', "^*Report #"..reportId, {252, 123, 3}, " Wysłano do "..admins.. " administratorów", "fas fa-flag")
		end
	elseif ESX and (ESX.PlayerData.group == 'trialsupport' or ESX.PlayerData.group == 'support' or ESX.PlayerData.group == 'mod' or ESX.PlayerData.group == 'admin' or ESX.PlayerData.group == 'superadmin' or ESX.PlayerData.group == 'best') and pid ~= myId and not dontreport then
		SendNUIMessage({
			type = "add_report",
			data = {
				reason = message,
				id = "#"..reportId.." | "..id,
				name = name
			}
		})
		TriggerEvent('chat:addMessage1', "[#"..reportId.." | ".. id .."] ^*"..name, {252, 123, 3}, " "..message, "fas fa-flag")
	end
end)

RegisterCommand("fixicon", function() 
	hideIcon()
end)

function showProgress(icon, position, message, caption, color, timeout, showProgress) 
	SendNUIMessage({
		type = "showProgress",
		icon = icon,
		position = position,
		message = message,
		caption = caption,
		color = color,
		timeout = timeout,
		showProgress = showProgress
	})
end
function cancelProgress() 
	SendNUIMessage({
		type = "stopProgress"
	})
end
function showIcon(icon, animated, timeout) 
	SendNUIMessage({
		type = "show_icon",
		icon = icon,
		animate = animated,
		timeout = timeout
	})
end
function hideIcon() 
	SendNUIMessage({
		type = "hide_icon"
	})
end

RegisterCommand('twitterlogout', function(source, args, user)
	if isLogouted == true then
		isLogouted = false
		ESX.ShowNotification('Zalogowałeś się do twittera')
	elseif isLogouted == false then
		isLogouted = true
		ESX.ShowNotification('Wylogowaleś się z twittera')
	end
end, false)