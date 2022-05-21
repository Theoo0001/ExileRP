local Ped = {
	Vehicle = nil,
	VehicleClass = nil,
	VehicleStopped = true,
	VehicleEngine = false,
	VehicleGear = nil,
}

local Hide = false
AddEventHandler('radar:setHidden', function(val)
	Hide = val
end)

CreateThread(function()		
	while true do
		Citizen.Wait(250)
		local ped, pid = PlayerPedId(), PlayerId()
		
		Ped.PauseMenu = IsPauseMenuActive()
		
		if IsPedInAnyVehicle(ped, false) then
			Ped.Vehicle = GetVehiclePedIsIn(ped, false)
			
			Ped.Vehicle = GetVehiclePedIsIn(ped, false)
			Ped.VehicleClass = GetVehicleClass(Ped.Vehicle)
			Ped.VehicleStopped = IsVehicleStopped(Ped.Vehicle)
			Ped.VehicleEngine = GetIsVehicleEngineRunning(Ped.Vehicle)
			Ped.VehicleGear = GetVehicleCurrentGear(Ped.Vehicle)
		else			
			Ped.Vehicle = nil
		end
		
	end
end)

local directions = {	
	[0] = false,
	[1] = '⮯',
	[2] = '⮬',
	[3] = '⮪',
	[4] = '⮫',
	[5] = '⮬',
	[6] = '⮪',
	[7] = '⮫',
	[8] = false,
}

function GroupDigits(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10 ^ numDecimalPlaces
		return math.floor((value * power) + 0.5) / (power)
	else
		return math.floor(value + 0.5)
	end
end

local lastDirection, displayWaypoint = '', false

CreateThread(function()
	while true do
		Citizen.Wait(500)
		
		local waypoint = GetFirstBlipInfoId(8)
		local blip = GetBlipCoords(waypoint)
		
		if waypoint ~= 0 and Ped.Vehicle then		
			if displayWaypoint == false then
				SendNUIMessage({
					action = 'setStateDirection',	
					state = true
				})
				displayWaypoint = true
			end
			
			local _, direction, __, ___ = GenerateDirectionsToCoord(blip.x, blip.y, blip.z, true)				
			local distance = #(GetEntityCoords(PlayerPedId()) - blip)
			
			if directions[direction] ~= false then
				if directions[direction] == true then
					SendNUIMessage({
						action = 'setDirection',
						direction = lastDirection,
						distance = GroupDigits(distance / 1000, 2)..' KM'
					})				
				else
					lastDirection = directions[direction]
					
					SendNUIMessage({
						action = 'setDirection',
						direction = directions[direction],
						distance = GroupDigits(distance / 1000, 2)..' KM'
					})				
				end
			end	
		else
			if displayWaypoint then
				SendNUIMessage({
					action = 'setStateDirection',	
					state = false
				})			
				displayWaypoint = false
			end
		end			
	

		
	end
end)

function UpdateBelt(value)
	if value ~= nil then
		SendNUIMessage({
			action = 'setBelt',
			state = value
		})
	end
end

local FirstSpawn = true
AddEventHandler('esx:onPlayerSpawn', function()
	if FirstSpawn then
		FirstSpawn = false
		CreateThread(function()
			local status = 0
			while true do
				if status == 0 then
					status = 1
					TriggerEvent('misiaczek:load', function(result)
						if result == 3 then
							status = 2
						else
							status = 0
						end
					end)
				end

				Citizen.Wait(200)
				if status == 2 then
					break
				end
			end

			SendNUIMessage({
				action  = 'initHud'
			})

		end)
	end
end)

local pauseMenu, vehshow = false, true
CreateThread(function()
	while true do
		Citizen.Wait(100)
		if Ped.Vehicle then
			if not vehshow and (not Hide and not Ped.PauseMenu) then
				vehshow = true
				
				SendNUIMessage({
					action = 'setVehicle',
					state = true
				})
			elseif (Ped.PauseMenu or Hide) and vehshow then
				SendNUIMessage({
					action = 'setVehicle',
					state = false
				})		
				vehshow = false
			end
			
			local Gear = Ped.VehicleGear
			
			if not Ped.VehicleEngine then
				Gear = 'P'
			elseif Ped.VehicleStopped then
				Gear = 'N'
			elseif Ped.VehicleClass == 15 or Ped.VehicleClass == 16 then
				Gear = 'F'
			elseif Ped.VehicleClass == 14 then
				Gear = 'S'
			elseif Gear == 0 then
				Gear = 'R'
			end
			
			local RPMScale = 0
			if (Ped.VehicleClass >= 0 and Ped.VehicleClass <= 5) or (Ped.VehicleClass >= 9 and Ped.VehicleClass <= 12) or Ped.VehicleClass == 17 or Ped.VehicleClass == 18 or Ped.VehicleClass == 20 then
				RPMScale = 7000
			elseif Ped.VehicleClass == 6 then
				RPMScale = 7500
			elseif Ped.VehicleClass == 7 then
				RPMScale = 8000
			elseif Ped.VehicleClass == 8 then
				RPMScale = 11000
			elseif Ped.VehicleClass == 15 or Ped.VehicleClass == 16 then
				RPMScale = -1
			end
			
			local r = GetVehicleCurrentRpm(Ped.Vehicle)
			
			if not Ped.VehicleEngine then
				r = 0
			elseif r > 0.99 then
				r = r * 100
				r = r + math.random(-2,2)

				r = r / 100
				if r < 0.12 then
					r = 0.12
				end
			else
				r = r - 0.1
			end

			local RPM = math.floor(RPMScale * r + 0.5)
			if RPM < 0 then
				RPM = 0
			elseif Speed == 0.0 and r ~= 0 then
				RPM = math.random(RPM, (RPM + 50))
			end

			RPM = math.floor(RPM / 10) * 10
				
			SendNUIMessage({
				action = 'setKmh',
				kmh = math.ceil(GetEntitySpeed(Ped.Vehicle) * 3.6),
				rpm = RPM / 100,
				gear = Gear,
			})
		else
			if vehshow then
				vehshow = false
				
				SendNUIMessage({
					action = 'setVehicle',
					state = false
				})
			end
		end
		
		if Status then
			if not pauseMenu and (Ped.PauseMenu or Hide) then
				SendNUIMessage({
					action = 'pauseMenu',
					display = false,
				})
				
				pauseMenu = true
			elseif pauseMenu and (not Ped.PauseMenu and not Hide) then
				SendNUIMessage({
					action = 'pauseMenu',
					display = true,
				})			
				
				pauseMenu = false
			end
		end
	end
end)