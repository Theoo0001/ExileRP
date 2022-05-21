oldVehicle = nil
oldDamage = 0
injuredTime = 0

isBlackedOut = false
isInjured = false
dzwonCalled = false

beltOn = false
beltStatus = true
beltCalled = false
local pokazPasy = true

AddEventHandler('exile_blackout:pasy', function(status)
	beltOn = status
end)

AddEventHandler('misiaczek_dzwon:display', function(status)
	beltStatus = status
end)

RegisterNetEvent("exile:pasy")
AddEventHandler("exile:pasy", function(a)
	pokazPasy = a
end)

function pasyState()
	return beltOn
end

local oldhud = false
RegisterNetEvent("csskrouble:oldHud", function(m) 
	oldhud = m
end)

RegisterNetEvent('exile_blackout:dzwon')
AddEventHandler('exile_blackout:dzwon', function(damage)
	isBlackedOut = true
	dzwonCalled = false
	CreateThread(function()
		SendNUIMessage({
			transaction = 'play'
		})

		StartScreenEffect('DeathFailOut', 0, true)

		-- if not exports['esx_optionalneeds']:isDrunk() then
		-- 	SetTimecycleModifier("hud_def_blur")
		-- end

		SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
		ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 1.0)
		Citizen.Wait(1000)

		ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 1.0)
		Citizen.Wait(1000)

		ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 1.0)
		Citizen.Wait(1000)
		StopScreenEffect('DeathFailOut')

		isInjured = false
		injuredTime = math.min(20, damage)
		isBlackedOut = false
	end)
end)

--[[CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()
		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed, false)
			local exists = DoesEntityExist(vehicle)

			local driver
			if exists then
				driver = GetPedInVehicleSeat(vehicle, -1)
			end

			if (exists and (not driver or driver == 0 or driver == playerPed)) or (not exists and DoesEntityExist(oldVehicle)) then
				local fall = true
				if exists then
					oldVehicle = vehicle
					fall = false
				end

				if not GetPlayerInvincible(PlayerId()) and not dzwonCalled then
					if IsCar(oldVehicle, false) then
						local currentDamage = GetVehicleEngineHealth(oldVehicle)
						if not isBlackedOut then
							local speed, vehicleClass = math.floor(GetEntitySpeed(oldVehicle) * 3.6 + 0.5), GetVehicleClass(oldVehicle)
							if (currentDamage < oldDamage and (oldDamage - currentDamage) >= 150) or (fall and speed > (vehicleClass == 8 and 5 or 30)) then
								local damage
								if not fall then
									damage = math.floor((oldDamage - currentDamage) / 20 + 0.5)
								else
									damage = math.floor(speed / 10 + 0.5)
								end

								local list = {}
								if oldVehicle == vehicle and driver == playerPed then
									local tmp = {}
									for _, player in ipairs(GetActivePlayers()) do
										tmp[Citizen.InvokeNative(0x43A66C31C68491C0, player)] = GetPlayerServerId(player)
									end

									for i = 0, GetVehicleNumberOfPassengers(oldVehicle) do
										local ped = GetPedInVehicleSeat(oldVehicle, i)
										if ped and ped ~= 0 then
											table.insert(list, tmp[ped])
										end
									end
								end

								dzwonCalled = true
								TriggerServerEvent('exile_blackout:dzwon', list, damage)
									--print('AntyDzwon:Activated')
							end
						end

						if not fall then
							oldDamage = currentDamage
						end
					end
				end

				if fall then
					oldVehicle = nil
					oldDamage = 0
				end
			else
				oldDamage = 0
			end
		else
			oldDamage = 0
		end

		if isBlackedOut then
			DisableControlAction(0,71,true) -- veh forward
			DisableControlAction(0,72,true) -- veh backwards
			DisableControlAction(0,63,true) -- veh turn left
			DisableControlAction(0,64,true) -- veh turn right
			DisableControlAction(0,288,true) -- disable phone
			DisableControlAction(0,75,true) -- disable exit vehicle
		end

		if injuredTime > 0 and not isInjured then
			isInjured = true
			CreateThread(function()
				ShakeGameplayCam("DRUNK_SHAKE", 5.0)
				repeat
					injuredTime = injuredTime - 1
					if not exports['esx_optionalneeds']:isDrunk() then
						SetPedMovementClipset(playerPed, "move_m@injured", 1.0)
						--SetTimecycleModifier("hud_def_blur")
					end
					Citizen.Wait(1400)
				until injuredTime == 0
				if not exports['esx_optionalneeds']:isDrunk() then
					ClearTimecycleModifier()
					ResetPedMovementClipset(playerPed, 0.0)
				end
				StopGameplayCamShaking(true)
				ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 1.0)
				
				SendNUIMessage({
					transaction = 'fade',
					time = 3000
				})
				isInjured = false
			end)
		end
	end
end)]]

RegisterNetEvent("exile_blackoutC:dzwonCb")
AddEventHandler("exile_blackoutC:dzwonCb", function(dmg) 
	if exports['esx_optionalneeds']:isAntyDzwon() then
		TriggerServerEvent("exile_blackout:dzwonCb", false, dmg)
	else TriggerServerEvent("exile_blackout:dzwonCb", true, dmg) end
end)


RegisterNetEvent('exile_blackout:impact')
AddEventHandler('exile_blackout:impact', function(speedBuffer, velocityBuffer)
	CreateThread(function()
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped, false) then
			local vehicle = GetVehiclePedIsIn(ped, false)
			local pass = GetEntityHealth(ped)
			
			if pass and not beltOn then
				local hr = GetEntityHeading(vehicle) + 90.0
				if hr < 0.0 then
					hr = 360.0 + hr
				end

				hr = hr * 0.0174533
				local forward = { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
				local coords = GetEntityCoords(ped)

				SetEntityCoords(ped, coords.x + forward.x, coords.y + forward.y, coords.z - 0.47, true, true, true)
				SetEntityVelocity(ped, velocityBuffer[2].x, velocityBuffer[2].y, velocityBuffer[2].z)
				Citizen.Wait(1)

				SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
				if not beltOn then
					local speed = math.floor(speedBuffer[2] * 3.6 + 0.5)
					if speed > 120 then
						Citizen.Wait(500)
						Citizen.InvokeNative(0x6B76DC1F3AE6E6A3, ped, math.floor(math.max(99, (pass - (speed - 100))) + 0.5))
					end
				else
					Citizen.Wait(500)
					--Citizen.InvokeNative(0x6B76DC1F3AE6E6A3, ped, pass)
				end
			end
		end

		beltCalled = false
	end)
end)

AddEventHandler('exile_blackout:belt', function(status)
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped, false) then
		beltOn = status

		local tmp = {}
		for _, player in ipairs(GetActivePlayers()) do
			tmp[Citizen.InvokeNative(0x43A66C31C68491C0, player)] = GetPlayerServerId(player)
		end

		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		for i = -1, GetVehicleNumberOfPassengers(vehicle) do
			local ped = GetPedInVehicleSeat(vehicle, i)
			if ped and ped ~= 0 then
				TriggerServerEvent('InteractSound_SV:PlayOnOne', tmp[ped], (beltOn and 'belton' or 'beltoff'), 0.35)
			end
		end
	end
end)

CreateThread(function()
	RequestStreamedTextureDict('mpinventory')
	while not HasStreamedTextureDictLoaded('mpinventory') do
			Citizen.Wait(0)
	end

	local speedBuffer = {}
	local velocityBuffer = {}

	local timer = GetGameTimer()
	while true do
		Citizen.Wait(0)

		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped, false) then
			local vehicle = GetVehiclePedIsIn(ped, false)
			if vehicle ~= 0 and IsCar(vehicle, true) then
				if IsControlJustReleased(0, 29) then
					TriggerEvent('exile_blackout:belt', not beltOn)
				end

				if not beltStatus then
					--nil
				elseif beltOn then
					DisableControlAction(0, 75)
					if pokazPasy and oldhud then
						DrawSprite('mpinventory', 'mp_specitem_ped', 0.162, 0.984, 0.015, 0.025, 0.0, 255, 255, 255, 255)
						DrawSprite('mpinventory', 'mp_specitem_partnericon', 0.162, 0.984, 0.01, 0.02, 0.0, 0, 255, 0, 255)
					end
				else	
					if pokazPasy and oldhud then
						DrawSprite('mpinventory', 'mp_specitem_ped', 0.162, 0.984, 0.015, 0.025, 0.0, 255, 255, 255, 255)
					end
					local tmp = GetGameTimer() - timer
					if tmp > 1000 then
						timer = GetGameTimer()
					elseif tmp > 500 then
						if pokazPasy and oldhud then
							DrawSprite('mpinventory', 'mp_specitem_partnericon', 0.162, 0.984, 0.01, 0.02, 0.0, 255, 0, 0, 255)
						end
					end				
				end

				if GetPedInVehicleSeat(vehicle, -1) == ped then
					speedBuffer[2] = speedBuffer[1]
					speedBuffer[1] = GetEntitySpeed(vehicle)
					if speedBuffer[2] ~= nil and not beltCalled and speedBuffer[2] > 40.77 and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * 0.25) and not GetPlayerInvincible(PlayerId()) and GetEntitySpeedVector(vehicle, true).y > 1.0 then
						local tmp = {}
						for _, player in ipairs(GetActivePlayers()) do
							tmp[Citizen.InvokeNative(0x43A66C31C68491C0, player)] = GetPlayerServerId(player)
						end

						local list = {}
						for i = 0, GetVehicleNumberOfPassengers(vehicle) do
							local ped = GetPedInVehicleSeat(vehicle, i)
							if ped and ped ~= 0 then
								table.insert(list, tmp[ped])
							end
						end

						local str = "^2Wypadek lub kolizja"
						local coords = GetEntityCoords(ped, false)

						local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
						if s1 ~= 0 and s2 ~= 0 then
							str = str .. " przy ^0" .. GetStreetNameFromHashKey(s1) .. "^2 na skrzyżowaniu z ^0" .. GetStreetNameFromHashKey(s2)
						elseif s1 ~= 0 then
							str = str .. " przy ^0" .. GetStreetNameFromHashKey(s1)
						end

						TriggerServerEvent('notifyAccident', {x = coords.x, y = coords.y, z = coords.y}, str)
						
						dzwonCalled = true
						beltCalled = true

						if not exports['esx_optionalneeds']:isAntyDzwon() then
							--TriggerServerEvent('exile_blackout:dzwon', list, 10)
							TriggerServerEvent('exile_blackout:impact', list, speedBuffer, velocityBuffer)
						else
							--print('AntyDzwon:Activated')
						end
					end

					velocityBuffer[2] = velocityBuffer[1]
					velocityBuffer[1] = GetEntityVelocity(vehicle)
				else
					speedBuffer[1], speedBuffer[2], velocityBuffer[1], velocityBuffer[2] = 0.0, nil, 0.0, nil
				end
			else
				Wait(250)
				speedBuffer[1], speedBuffer[2], velocityBuffer[1], velocityBuffer[2] = 0.0, nil, 0.0, nil
			end
		else
			Wait(250)
			beltOn = false
			speedBuffer[1], speedBuffer[2], velocityBuffer[1], velocityBuffer[2] = 0.0, nil, 0.0, nil
		end
	end
end)

function IsCar(v, ignoreBikes)
	if ignoreBikes and IsThisModelABike(GetEntityModel(v)) then
		return false
	end

	local vc = GetVehicleClass(v)
	return (vc >= 0 and vc <= 12) or vc == 15 or vc == 17 or vc == 18 or vc == 20
end

function IsAffected()
	return isBlackedOut or isInjured
end

-- [[ KLASY POJAZDÓW ]] --
--[[  
0: Compacts  
1: Sedans  
2: SUVs  
3: Coupes  
4: Muscle  
5: Sports Classics  
6: Sports  
7: Super  
8: Motorcycles  
9: Off-road  
10: Industrial  
11: Utility  
12: Vans  
13: Cycles  
14: Boats  
15: Helicopters  
16: Planes  
17: Service  
18: Emergency  
19: Military  
20: Commercial  
21: Trains 
]]