ESX = nil
local Timer, secondsRemaining, canTake, isDead, InZone, currentZone = {}, {}, true, false, false, nil
local CurrentAction = nil
local PlayerData = {}
local Blips = {}
local Debilktoryrobiltenskryptjestzyciowymnieudacznikiemigejemigranawlon = false

CreateThread(function()
    while ESX == nil do
        TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

	Citizen.Wait(5000)
	
    PlayerData = ESX.GetPlayerData()
	ESX.TriggerServerCallback('misiaczek:getJob', function(data)
		TriggerServerEvent("exile_strefy:SetJob", data.name)
		updateJob(data)
	end)
	
	Citizen.Wait(5000)
	refreshBlips()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer

	ESX.TriggerServerCallback('misiaczek:getJob', function(data)
		TriggerServerEvent("exile_strefy:SetJob", data.name)
		updateJob(data)
	end)
	
	Citizen.Wait(5000)
	refreshBlips()
end)

RegisterNetEvent('esx:setHiddenJob')
AddEventHandler('esx:setHiddenJob', function(hiddenjob)
	TriggerServerEvent("exile_strefy:SetJob", hiddenjob.name)
  PlayerData.hiddenjob = hiddenjob
	Wait(10)
	updateJob(hiddenjob)
	Wait(1000)
	refreshBlips()
end)

CreateThread(function()
		while true do
			local playerPed = PlayerPedId()
			playerPos = GetEntityCoords(playerPed)
			Citizen.Wait(500)
	end
end)

RegisterNetEvent('exile_strefy:refreshOcupped')
AddEventHandler('exile_strefy:refreshOcupped', function(org, currentZone)
	if PlayerData.hiddenjob and PlayerData.hiddenjob.name ~= nil then
		if PlayerData.hiddenjob.name == org then
			Config.Strefy[currentZone].ocupped = true
		else
			Config.Strefy[currentZone].ocupped = false
		end
	end
	
	refreshBlips()
end)

function updateJob(data)
	if data then
		PlayerData.hiddenjob = data
	end

	for i=1, #Config.Strefy, 1 do
		Config.Strefy[i].ocupped = false
	end
	if PlayerData.hiddenjob and PlayerData.hiddenjob.name ~= nil then
		ESX.TriggerServerCallback('exile_strefy:checkStrefy', function(data)		
			for k,v in pairs(data) do
				if v[2] == PlayerData.hiddenjob.name then
					Config.Strefy[k].ocupped = true
				else
					Config.Strefy[k].ocupped = false
				end
			end
		end)
	end
end

function refreshBlips()
	for k,v in ipairs(Blips) do
		RemoveBlip(v)
		Blips[k] = nil
	end
	
	if PlayerData.hiddenjob and PlayerData.hiddenjob.name ~= nil then
		for i=1, #Config.Strefy, 1 do
			for ii,v in ipairs(Config.Strefy[i].Jobs) do
				if PlayerData.hiddenjob.name == v then
					local blipZone = AddBlipForCoord(Config.Strefy[i].coords)
					SetBlipSprite(blipZone, 458)
					SetBlipColour(blipZone, Config.Strefy[i].ocupped and 2 or 59)
					--SetBlipAlpha(blipZone, 150)
					SetBlipScale (blipZone, 1.0)
					SetBlipAsShortRange(blipZone, true)
	
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(Config.Strefy[i].ocupped and Config.Strefy[i].label or 'Strefa')
					EndTextCommandSetBlipName(blipZone)
					
					table.insert(Blips, blipZone)
				end
			end	
		end
	end
end

function ReturnConfig()
	return Config.Strefy
end

CreateThread(function()
	while true do
		local playerPed = PlayerPedId()
		playerPos = GetEntityCoords(playerPed)
		Citizen.Wait(250)
	end
end)

RegisterNetEvent("exile_strefy:zoneTaken")
AddEventHandler("exile_strefy:zoneTaken", function(currentZone)
	ESX.ShowNotification("~g~Przejąłeś strefe, gratulacje!")
	
	TriggerServerEvent("exile_strefy:zoneTakenServer", PlayerData.hiddenjob.name, PlayerData.hiddenjob.label, currentZone)
end)

RegisterNetEvent("exile_strefy:RemoveActiveZone")
AddEventHandler("exile_strefy:RemoveActiveZone", function(currentZone, job_label, job)	
	if PlayerData.hiddenjob ~= nil and PlayerData.hiddenjob.name ~= nil then		
		for i,v in ipairs(Config.Strefy[currentZone].Jobs) do
			if PlayerData.hiddenjob.name == v then
				ESX.ShowNotification("~y~" .. job_label .. "~w~ przejęła ~y~strefę ~g~".. currentZone .. "!")
				break
			end	
		end	
	end
end)

RegisterNetEvent("exile_strefy:startZone")
AddEventHandler("exile_strefy:startZone", function(currentZone, job, job_label)
	if PlayerData.hiddenjob ~= nil then		
		TriggerServerEvent('xfsd:sendlog', currentZone)
		--for i,v in ipairs(Config.Strefy[currentZone].Jobs) do
		ESX.TriggerServerCallback('xfsd:checkZoneOwner', function(zoneOwner)
			if PlayerData.hiddenjob.name == zoneOwner then
				print(zoneOwner)
				for i = 12, 1, -1 do
					ESX.ShowNotification("~y~".. job_label .." ~w~rozpoczęła przejmowanie ~y~strefy ~g~".. currentZone .. "! Pozostało "..i.." minut do zakończenia")
						if Debilktoryrobiltenskryptjestzyciowymnieudacznikiemigejemigranawlon then
							break
						end
					Citizen.Wait(60000)
					--break
				end
			end
		--end
		end, currentZone)
	end
end)

function OpenGetWeaponMenu(zone)	
	ESX.TriggerServerCallback('exile_strefy:getStock', function(items)
		local elements = {}

		if items.blackMoney > 0 then
			table.insert(elements, {
				label = "Brudne pieniądze: <span style='color: yellow;'>"..ESX.Math.GroupDigits(items.blackMoney).."$",
				type = 'item_account',
				items = 'black_money',
				value = false
			})
		end

		for i=1, #items.items, 1 do
			local item = items.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
			
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon', {
			title    = ('Strefa ['..zone..']'),
			align    = 'center',
			elements = elements
		}, function(data, menu)
			menu.close()

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = "Ilość"
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count ~= nil then
					menu2.close()
							
					ESX.TriggerServerCallback('exile_strefy:removeStock', function()
						OpenGetWeaponMenu(zone)
					end, data.current.type, data.current.value, count, 'society_strefy'..zone)
				end
			end, function(data2, menu2)
				menu2.close()
				menu.open()
			end)
			
		end, function(data, menu)
			menu.close()
		end)
	end, 'society_strefy'..zone)
end

CreateThread(function()
    while PlayerData.job == nil do
        Citizen.Wait(3000)
    end
	
    while true do
        Citizen.Wait(3)
        for i=1, #Config.Strefy, 1 do
			if PlayerData.hiddenjob then
				if PlayerData.hiddenjob.name ~= nil then
					for ii,v in ipairs(Config.Strefy[i].Jobs) do
						if PlayerData.hiddenjob.name == v then
							if #(vec3(playerPos.x, playerPos.y, playerPos.z) - Config.Strefy[i].coords) < 30 then
								DrawMarker(27, Config.Strefy[i].coords.x, Config.Strefy[i].coords.y, Config.Strefy[i].coords.z - 0.9, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 20.0, 20.0, 20.0, 184, 86, 79, 100, false, true, 2, true, nil, nil, false)
								if #(vec3(playerPos.x, playerPos.y, playerPos.z) - Config.Strefy[i].coords) < 8.0 then
									if not isDead and not IsPedInAnyVehicle(PlayerPedId(), false) then
										ESX.ShowHelpNotification("Naciśnij ~INPUT_PICKUP~ aby rozpocząć ~r~przejmowanie strefy")
										if IsControlJustPressed(0, 38) then
											if not IsPedInAnyVehicle(PlayerPedId(), false) then
												currentZone = TakeZone(playerPos)
												if not Config.Strefy[i].ocupped then
													ESX.TriggerServerCallback('exile_strefy:CheckZone', function(hold)
														if not hold then
															TriggerServerEvent('exile_strefy:HoldZone', currentZone, true, PlayerData.hiddenjob.name, PlayerData.hiddenjob.label)
															secondsRemaining[currentZone] = Config.secondsRemaining
															Timer[currentZone] = true
															ESX.ShowNotification("Opuszczenie ~g~strefy ~w~spowoduje ~r~anulowanie ~w~przejmowania strefy!")
														end
													end, currentZone)
												else
													if PlayerData.hiddenjob.grade >= 2 then
														OpenGetWeaponMenu(currentZone)
													else
														ESX.ShowNotification('~r~Przedmioty można wyciągać od Kapitana')
													end
												end
											else
												ESX.ShowNotification("~r~Nie możesz przejmować strefy będąc w aucie!")
											end
										end
									end
								end
							end
							
							if Timer[currentZone] then
								if secondsRemaining[currentZone] <= Config.secondsRemaining and secondsRemaining[currentZone] >= 5 then
									timeLeft = 'sekund'
								elseif secondsRemaining[currentZone] <= 4 and secondsRemaining[currentZone] >= 2 then
									timeLeft = 'sekundy'
								else
									timeLeft = 'sekunda'
								end
								
								if i == currentZone then
									DrawText3D(Config.Strefy[currentZone].coords.x, Config.Strefy[currentZone].coords.y, Config.Strefy[currentZone].coords.z, "Pozostało: ".. secondsRemaining[currentZone] ..' '..timeLeft)
								end
							end
							if (isDead and Timer[currentZone]) or (Timer[currentZone] and IsPedInAnyVehicle(PlayerPedId(), false)) then
								ESX.ShowNotification("~r~Anulowano przejmowanie strefy!")
								CreateThread(function()
									Debilktoryrobiltenskryptjestzyciowymnieudacznikiemigejemigranawlon = true
									Wait(120*1000)
									Debilktoryrobiltenskryptjestzyciowymnieudacznikiemigejemigranawlon = false
								end)
								TriggerServerEvent('exile_strefy:HoldZone', currentZone, false, PlayerData.hiddenjob.name, PlayerData.hiddenjob.label)
								Timer[currentZone] = false
								secondsRemaining[currentZone] = Config.secondsRemaining
								currentZone = nil
							end
						end	
					end	
				end
			else
				Citizen.Wait(200)
			end
		end
    end
end)

CreateThread(function()
    while currentZone == nil do
        Citizen.Wait(500)
    end
	
    while true do
		Citizen.Wait(1000)
		if Timer[currentZone] then
			while currentZone ~= nil and secondsRemaining[currentZone] > 0 and not isDead do
				Citizen.Wait(1000)
				if currentZone ~= nil then
					secondsRemaining[currentZone] = secondsRemaining[currentZone] - 1
					
					if #(playerPos - Config.Strefy[currentZone].coords) > 8.0 then
						ESX.ShowNotification("~r~Anulowano przejmowanie strefy!")
						TriggerServerEvent('exile_strefy:HoldZone', currentZone, false)
						secondsRemaining[currentZone] = Config.secondsRemaining
						Timer[currentZone] = false
						currentZone = nil
						break
					end
					if secondsRemaining[currentZone] <= 0 then
						TriggerEvent('exile_strefy:zoneTaken', currentZone)
						secondsRemaining[currentZone] = Config.secondsRemaining
						Timer[currentZone] = false
						
						break
					end
				end
			end
		end
    end
end)

function DrawText3D(x, y, z, text)
	rect = {0.003, 0.02, 325}

    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = #(vec3(px, py, pz) - vec3(x, y, z))

    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

	SetTextScale(0.3, 0.3)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextCentre(1)

	SetTextEntry("STRING")
	AddTextComponentString(text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	DrawText(_x,_y)

	local factor = text:len() / rect[3]
	DrawRect(_x, _y + 0.0125, rect[1] + factor, rect[2], 41, 11, 41, 68)
end

TakeZone = function(pCoords)
    if #(vec3(pCoords.x, pCoords.y, pCoords.z) - Config.Strefy[1].coords) < 10 then
        return 1
    elseif #(vec3(pCoords.x, pCoords.y, pCoords.z) - Config.Strefy[2].coords) < 10 then
        return 2
    elseif #(vec3(pCoords.x, pCoords.y, pCoords.z) - Config.Strefy[3].coords) < 10 then
        return 3
    elseif #(vec3(pCoords.x, pCoords.y, pCoords.z) - Config.Strefy[4].coords) < 10 then
        return 4   
	elseif #(vec3(pCoords.x, pCoords.y, pCoords.z) - Config.Strefy[5].coords) < 10 then
        return 5   
	elseif #(vec3(pCoords.x, pCoords.y, pCoords.z) - Config.Strefy[6].coords) < 10 then
        return 6	
	elseif #(vec3(pCoords.x, pCoords.y, pCoords.z) - Config.Strefy[7].coords) < 10 then
        return 7	
	elseif #(vec3(pCoords.x, pCoords.y, pCoords.z) - Config.Strefy[8].coords) < 10 then
        return 8	
	elseif #(vec3(pCoords.x, pCoords.y, pCoords.z) - Config.Strefy[9].coords) < 10 then
        return 9
	elseif #(vec3(pCoords.x, pCoords.y, pCoords.z) - Config.Strefy[10].coords) < 10 then
        return 10
    end
end


AddEventHandler('esx:onPlayerDeath', function()
    isDead = true
end)

AddEventHandler('playerSpawned', function()
    isDead = false
end)