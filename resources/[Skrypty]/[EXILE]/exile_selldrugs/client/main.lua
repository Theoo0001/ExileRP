ESX = nil
local PlayerData		= {}

CreateThread(function()
	while ESX == nil do
		TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) 
			ESX = obj 
		end)
		
		Citizen.Wait(250)
	end

	Citizen.Wait(5000)
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

local CanSell    = false
local TargetPed  = nil
local currentPed = nil
local CurrentAnim = {}
local Thread     = nil
local czas = true
local LastDeal = GetGameTimer() - 5 * 60000

local CantDeal = {
	'police',
	'offpolice',
	'ambulance',
	'offambulance'
}

--[[local SellZones = {
	vector3(-1643.94, 217.51, 60.64),
	-- vector3(-2300.92, 266.85, 169.6),
	vector3(-1660.02, -892.94, 8.65),
	vector3(-795.25, -2392.43, 14.57),
	vector3(-80.68, -2008.02, 18.02),
	-- vector3(-1444.6, -2605.29, 48.3),
	vector3(1010.23, -2329.06, 30.51),
	vector3(-135.31, -1073.67, 29.19),
	vector3(882.89, -45.2, 78.76)
	-- vector3(340.52, 3567.8, 33.48)
	-- vector3(63.24, 3714.01, 39.75)
}]]

--[[local SellZones = {
	vector3(-1643.94, 217.51, 60.64),
	vector3(-1660.02, -892.94, 8.65),
	vector3(-795.25, -2392.43, 14.57),
	vector3(-80.68, -2008.02, 18.02),
	vector3(1010.23, -2329.06, 30.51),
	vector3(-135.31, -1073.67, 29.19),
	vector3(882.89, -45.2, 78.76),
	vector3(58.22, 3711.01, 23.80),
	vector3(-2267.79, 305.03, 174.13),
	vector3(-195.48, -2020.18, 26.66),
	vector3(1181.03, -515.75, 64.16),
	vector3(1016.47, -2336.91, 30.94),
	vector3(-1386.19, -80.91, 51.61),
	vector3(199.25, 219.992, 104.45),
	vector3(-1109.08, -1566.30, 3.28),
	vector3(1671.84, 4798.33, 42.04),
	vector3(-168.56, 6349.86, 33.07)
}]]
local SellZones = {
	vector3(-1643.94, 217.51, 60.64),--SZKOLA
	vector3(-2300.92, 266.85, 169.6),--KORTZ CENTER
	vector3(-1660.02, -892.94, 8.65),--KINO SAMOCHODOWE
	vector3(-795.25, -2392.43, 14.57),--PARKING LOTNISKO
	vector3(-80.68, -2008.02, 18.02),--PARKING MAZEBANK ARENA
	vector3(-2983.2554, 3468.6548, 8.5901),--BAZA WOJSKOWA BUNKIER
	vector3(1010.23, -2329.06, 30.51),--PARKING DOKI
	vector3(-402.8064, 1205.3591, 325.0108),--OBSERWATORIUM
	vector3(882.89, -45.2, 78.76),--PARKING KASYNO
	vector3(340.52, 3567.8, 33.48),--OBOK LOSTOW
	vector3(63.24, 3714.01, 39.75),--LOSTY
}

CreateThread(function()
	FreezeEntityPosition(PlayerPedId(), false)
end)

function GetConfigPedy()
    ConfigPedy = PedyUstawienia[math.random(#PedyUstawienia)]
end

function ShowAdvancedNotification(icon, sender, title, text)
    SetNotificationTextEntry("STRING")
    SetNotificationMessage(icon, icon, true, 4, sender, title, text)
    DrawNotification(false, true)
end

function IsAuthorized()
	if PlayerData.job == nil then
		return false
	end

	for i=1, #CantDeal, 1 do
		if CantDeal[i] == PlayerData.job.name then
			return false
		end
	end

	return true
end

function IsInZone(pCoords)
	if pCoords == nil then
		return false
	end
	
	for i=1, #SellZones, 1 do
		--if #(SellZones[i] - pCoords) <= 50.0 then
		if #(SellZones[i] - pCoords) <= 50.0 then
			return true
		end
	end

	return false
end

RegisterNetEvent('phonedealer:start')
AddEventHandler('phonedealer:start', function(pCoords)
    TriggerEvent('phone:off')
	GetConfigPedy()
	local driverhash = GetHashKey(ConfigPedy.model)
	local VehicleHash = GetHashKey(Config.Vehicle)
	ShowAdvancedNotification(ConfigPedy.icon, ConfigPedy.name, ConfigPedy.Dialog[math.random(#ConfigPedy.Dialog)])
	while not HasModelLoaded(VehicleHash) and RequestModel(VehicleHash) or not HasModelLoaded(driverhash) and RequestModel(driverhash) do
        RequestModel(VehicleHash)
		RequestModel(driverhash)
        Citizen.Wait(0)
    end
    Klient = Citizen.InvokeNative(0xD49F9B0955C367DE, 2, driverhash, GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, Config.SpawnPedDistance, 0), 200, true, true)
	local KlientPos = GetEntityCoords(Klient)
	local distancePed = #(KlientPos - pCoords)
	TaskPedSlideToCoord(Klient, GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 0, 0), 200, 10.0)
end)

RegisterNetEvent('esx_addons_gcphone:phonedealer')
AddEventHandler('esx_addons_gcphone:phonedealer', function()
	local IsAuthorized = IsAuthorized()

	ESX.TriggerServerCallback("esx_scoreboard:getConnectedCops", function(MisiaczekPlayers)
		if MisiaczekPlayers then
			if MisiaczekPlayers['police'] >= Config.LSPD then
				if IsAuthorized then
					local coords = GetEntityCoords(PlayerPedId())
					local CanSell = IsInZone(coords)
					if CanSell then
						if GetGameTimer() - LastDeal > 20000 then
							LastDeal = GetGameTimer()
							TriggerEvent('phonedealer:start')
						else
							ESX.ShowNotification("~r~Odczekaj 20 sekund przed wezwaniem kolejnego klienta")
						end
					else
						ESX.ShowNotification('~r~W tym miejscu nie można użyć tej aplikacji')
					end
				else
					ESX.ShowNotification('~r~Nie możesz korzystać z tej aplikacji')
				end
			else
				ESX.ShowNotification('~r~Brak odpowiedniej ilości funkcjonariuszy na służbie')
			end
		end
	end)
end)


CreateThread(function()
	while true do
		Citizen.Wait(0)	
		if CanSell and TargetPed then
			SetTextComponentFormat('STRING')
			AddTextComponentString('Naciśnij ~INPUT_VEH_DUCK~ aby przerwać sprzedaż')

			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			DisableControlAction(2, 23, true)
			if IsControlJustPressed(0, 73) then
				DecorSetBool(CurrentPed, "DrugsBought", true)
				if Thread then
					TerminateThread(Thread)
				end
                
				FreezeEntityPosition(CurrentPed, false)
				FreezeEntityPosition(PlayerPedId(), false)
				PlayAmbientSpeech1(CurrentPed, 'GENERIC_BYE', "SPEECH_PARAMS_FORCE", 1)
				TaskWanderStandard(CurrentPed, 10.0, 10)

				TriggerServerEvent('esx_sellnpc:denySell', nil)
				currentPed = nil
			elseif #CurrentAnim > 0 then
				local ped = PlayerPedId()
				if not IsEntityPlayingAnim(ped, CurrentAnim[1], CurrentAnim[2], 3) then
					TaskPlayAnim(ped, CurrentAnim[1], CurrentAnim[2], 1.0, -1.0, -1, 0, 1, 0, 0, 0)
				end
			end
		end
		
		if CanSell and TargetPed then
			SetTextComponentFormat('STRING')
			AddTextComponentString('Naciśnij ~INPUT_CONTEXT~ aby zaoferować ~g~narkotyki')
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			
			if IsControlJustPressed(1, 86) then
				ESX.TriggerServerCallback('xfsd-sell:checkDoesHaveAnyDrugs', function(have)
					if have then
						CurrentPed = TargetPed
						TargetPed = nil
						
						
						CurrentAnim = {"missfbi3_party_b", "talk_balcony_loop_male1"}
						RequestAnimDict("missfbi3_party_b")
						while not HasAnimDictLoaded("missfbi3_party_b") do
							Citizen.Wait(0)
						end

						Citizen.InvokeNative(0xAAA34F8A7CB32098, CurrentPed)
						ClearPedSecondaryTask(CurrentPed)
						FreezeEntityPosition(CurrentPed, true)
						FreezeEntityPosition(PlayerPedId(), true)
						
						SetEntityHeading(CurrentPed, heading)
						TaskStandStill(CurrentPed, 2.0)
						PlayAmbientSpeech1(CurrentPed, 'GENERIC_HI', "SPEECH_PARAMS_FORCE", 1)

						
						TriggerServerEvent('esx_sellnpc:sell')
						CreateThread(function()
							Thread = GetIdOfThisThread()
							Citizen.Wait(8000)
							TaskPlayAnim(CurrentPed, "missfbi3_party_b", "talk_inside_loop_male1", 1.0, -1.0, -1, 0, 1, 0, 0, 0)
							Thread = nil
						end)
					else
						ESX.ShowNotification('Nie posiadasz przy sobie narkotyków')
					end
				end)
			end
		end
	end
end)

CreateThread(function()
    while true do
        Citizen.Wait(30)

        local found = false
        if not CurrentPed and PlayerData.job ~= nil and PlayerData.job.name ~= 'police' and PlayerData.job.name ~= 'offpolice' and PlayerData.job.name ~= 'ambulance' and PlayerData.job.name ~= 'offambulance' and PlayerData.job.name ~= 'mechanic' and PlayerData.job.name ~= 'sheriff' and PlayerData.job.name ~= 'offsheriff' and not IsPauseMenuActive() then
            local playerPed = PlayerPedId()
            if not DecorIsRegisteredAsType("DrugsBought", 2) then
                DecorRegister("DrugsBought", 2)
            end
            
            if not IsPedDeadOrDying(playerPed) and not IsPedInAnyVehicle(playerPed) then
                local playerCoords = GetEntityCoords(playerPed, true)
                local inDirection = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 2.5, 0.0)
                local rayHandle = CastRayPointToPoint(playerCoords.x, playerCoords.y, playerCoords.z, inDirection.x, inDirection.y, inDirection.z, 12, playerPed, 0)

                local a, b, c, d, ped = GetRaycastResult(rayHandle)
                if DoesEntityExist(ped) and not IsPedDeadOrDying(ped) and not IsPedInAnyVehicle(ped) and not IsPedAPlayer(ped) and not IsPedFleeing(ped) and not DecorGetBool(ped, "DrugsBought") then
                    local pedType = GetPedType(ped)
                    if pedType ~= 28 and pedType ~= 27 and pedType ~= 6 then
                        found = true
                        TargetPed = ped
                        if not CanSell then
                            TriggerServerEvent('esx_sellnpc:canSell')
                        end
                    end
                end
            end
        end

        if not found then
            TargetPed = nil
        end
    end
end)

RegisterNetEvent('esx_sellnpc:canSell')
AddEventHandler('esx_sellnpc:canSell', function(test)
	CanSell = test
end)

RegisterNetEvent('esx_sellnpc:sell')
AddEventHandler('esx_sellnpc:sell', function(isInterested, notifyCops, cops, photo)
	local ped = PlayerPedId()
	CurrentAnim = {}
	StopAnimTask(ped, "missfbi3_party_b", "talk_balcony_loop_male1", 1.0)
	
	DecorSetBool(CurrentPed, "DrugsBought", true)
	local coords = GetEntityCoords(ped)
	if not isInterested then		
		if isInterested ~= nil then
			ESX.ShowNotification('~y~Oferowanie narkotyków...')
			local ticks = math.random(1000, 1500)
			local canceled = false
			local callCopsAfter = math.random(1000, ticks)
			local copsCalled = false
			while ticks > 0 do
				Citizen.Wait(3)
				ESX.ShowHelpNotification('Naciśnij ~INPUT_VEH_DUCK~ aby przerwać sprzedaż')
				DisableControlAction(2, 23, true)
				if IsControlJustPressed(0, 73) then
					canceled = true
					break
				end
				ticks = ticks - 1
				if ticks == callCopsAfter then
					copsCalled = true
					local ped = PlayerPedId()
					local coords = GetEntityCoords(ped, false)
					local str = "^6Sprzedaż narkotyków"

					local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
					if s1 ~= 0 and s2 ~= 0 then
						str = str .. " przy ^0" .. GetStreetNameFromHashKey(s1) .. "^6 na skrzyżowaniu z ^0" .. GetStreetNameFromHashKey(s2)
					elseif s1 ~= 0 then
						str = str .. " przy ^0" .. GetStreetNameFromHashKey(s1)
					end
					
					TriggerServerEvent('sellDrugsInProgress', {x = coords.x, y = coords.y, z = coords.z}, str, photo, GetEntityModel(ped) ~= `mp_f_freemode_01`)
					if photo then
						TriggerEvent('chatMessage', '', { 240, 200, 240 }, '^*Obywatel zrobił Ci zdjęcie.')
					end
				end
			end

			if canceled == true then
				FreezeEntityPosition(PlayerPedId(), false)
				TriggerServerEvent('esx_sellnpc:denySell', nil)
				if not copsCalled then
					photo = true
					local ped = PlayerPedId()
					local coords = GetEntityCoords(ped, false)
					local str = "^6Sprzedaż narkotyków"

					local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
					if s1 ~= 0 and s2 ~= 0 then
						str = str .. " przy ^0" .. GetStreetNameFromHashKey(s1) .. "^6 na skrzyżowaniu z ^0" .. GetStreetNameFromHashKey(s2)
					elseif s1 ~= 0 then
						str = str .. " przy ^0" .. GetStreetNameFromHashKey(s1)
					end
					
					TriggerServerEvent('sellDrugsInProgress', {x = coords.x, y = coords.y, z = coords.z}, str, photo, GetEntityModel(ped) ~= `mp_f_freemode_01`)
					if photo then
						TriggerEvent('chatMessage', '', { 240, 200, 240 }, '^*Obywatel zrobił Ci zdjęcie.')
					end
				end
			else
				FreezeEntityPosition(PlayerPedId(), false)
				TriggerServerEvent('esx_sellnpc:denySell', false)
			end
		else
			TriggerServerEvent('esx_sellnpc:denySell', true)
			FreezeEntityPosition(PlayerPedId(), false)
		end
		FreezeEntityPosition(CurrentPed, false)
		PlayAmbientSpeech1(CurrentPed, 'GENERIC_BYE', "SPEECH_PARAMS_FORCE", 1)
		TaskWanderStandard(CurrentPed, 10.0, 10)
		Wait(15000)
		DeletePed(CurrentPed)
		CurrentPed = nil
	elseif #(coords - GetEntityCoords(CurrentPed)) <= 2.5 then
		CreateThread(function()
			Thread = GetIdOfThisThread()
			
			ESX.ShowNotification('~y~Oferowanie narkotyków...')
			local ticks = math.random(1000, 1500)
			local canceled = false
			while ticks > 0 do
				Citizen.Wait(3)
				ESX.ShowHelpNotification('Naciśnij ~INPUT_VEH_DUCK~ aby przerwać sprzedaż')
				DisableControlAction(2, 23, true)
				if IsControlJustPressed(0, 73) then
					canceled = true
					break
				end
				ticks = ticks - 1
			end

			if canceled then
				photo = true
				FreezeEntityPosition(PlayerPedId(), false)
				
				TriggerServerEvent('esx_sellnpc:denySell', nil)
				local ped = PlayerPedId()
				local coords = GetEntityCoords(ped, false)
				local str = "^6Sprzedaż narkotyków"

				local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
				if s1 ~= 0 and s2 ~= 0 then
					str = str .. " przy ^0" .. GetStreetNameFromHashKey(s1) .. "^6 na skrzyżowaniu z ^0" .. GetStreetNameFromHashKey(s2)
				elseif s1 ~= 0 then
					str = str .. " przy ^0" .. GetStreetNameFromHashKey(s1)
				end
				
				TriggerServerEvent('sellDrugsInProgress', {x = coords.x, y = coords.y, z = coords.z}, str, photo, GetEntityModel(ped) ~= `mp_f_freemode_01`)
				if photo then
					TriggerEvent('chatMessage', '', { 240, 200, 240 }, '^*Obywatel zrobił Ci zdjęcie.')
				end
			else
				FreezeEntityPosition(PlayerPedId(), false)
		
				RequestAnimDict("mp_cop_armoury")
				while not HasAnimDictLoaded("mp_cop_armoury") do
					Citizen.Wait(0)
				end

				RequestAnimDict("mp_common")
				while not HasAnimDictLoaded("mp_common") do
					Citizen.Wait(0)
				end

				CurrentAnim = {"mp_cop_armoury", "package_from_counter"}
				TaskPlayAnim(ped, "mp_cop_armoury", "package_from_counter", 1.0, -1.0, -1, 0, 0, 0, 0, 0)
				Citizen.Wait(1500)

				TaskPlayAnim(CurrentPed, "mp_common", "givetake2_a", 1.0, -1.0, -1, 0, 0, 0, 0, 0)
				Citizen.Wait(2000)
				CurrentAnim = {}

				StopAnimTask(ped, "mp_cop_armoury", "package_from_counter", 1.0)
				PlayAmbientSpeech1(CurrentPed, 'GENERIC_THANKS', "SPEECH_PARAMS_FORCE", 1)
				Citizen.Wait(1000)

				FreezeEntityPosition(CurrentPed, false)
				PlayAmbientSpeech1(CurrentPed, 'GENERIC_BYE', "SPEECH_PARAMS_FORCE", 1)
				TaskWanderStandard(CurrentPed, 10.0, 10)

				TriggerServerEvent('esx_sellnpc:acceptSell', cops)
				Wait(15000)
				DeletePed(CurrentPed)
				CurrentPed = nil
				Thread = nil
			end
		end)		
	else
		TriggerServerEvent('esx_sellnpc:denySell', true)
		FreezeEntityPosition(PlayerPedId(), false)
		FreezeEntityPosition(CurrentPed, false)
		PlayAmbientSpeech1(CurrentPed, 'GENERIC_BYE', "SPEECH_PARAMS_FORCE", 1)
		TaskWanderStandard(CurrentPed, 10.0, 10)
		Wait(15000)
		DeletePed(CurrentPed)
		CurrentPed = nil
		EnableControlAction(0, 288, true)
	end
end)

