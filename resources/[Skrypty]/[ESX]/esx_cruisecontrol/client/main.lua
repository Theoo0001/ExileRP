local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
CreateThread(function()
	while ESX == nil do
		TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) 
			ESX = obj 
		end)
		
		Citizen.Wait(250)
	end
end)

local CruisedSpeed    = 0
local CruisedSpeedKm  = 0

RegisterCommand('tempomat', function()
	if IsDriver() and GetIsVehicleEngineRunning(GetVehicle()) then
		TriggerCruiseControl()
	end
end)

RegisterKeyMapping('tempomat', 'Włącz/wyłącz tempomat', 'keyboard', 'L')

function TriggerCruiseControl()
	if CruisedSpeed == 0 and IsDriving() then
		if GetVehicleSpeed() > 0 then

			CruisedSpeed = GetVehicleSpeed()
			CruisedSpeedKm = TransformToKm(CruisedSpeed)

			ESX.ShowNotification('Włączono tempomat, prędkość: ~b~' .. CruisedSpeedKm .. ' km/h ~w~jeśli chcesz wyłączyć tempomat zwolnij.')
			CreateThread(function ()
				while CruisedSpeed > 0 and IsInVehicle() == PlayerPedId() do
					Citizen.Wait(0)
					if not GetIsVehicleEngineRunning(GetVehicle()) then
						CruisedSpeed = 0
						break
					end

					if not IsTurningOrHandBraking() and GetVehicleSpeed() < (CruisedSpeed - 5.0) then
						CruisedSpeed = 0
						ESX.ShowNotification('Wyłączono tempomat poprzez zwolnienie prędkości pojazdu przez kierowcę.')
						Citizen.Wait(2000)
						break
					end

					if not IsTurningOrHandBraking() and IsVehicleOnAllWheels(GetVehicle()) and GetVehicleSpeed() < CruisedSpeed then
						SetVehicleForwardSpeed(GetVehicle(), CruisedSpeed)
					end

					if IsControlJustPressed(0, Keys["L"]) then
						CruisedSpeed = GetVehicleSpeed()
						CruisedSpeedKm = TransformToKm(CruisedSpeed)
					end

					if IsControlJustPressed(2, 72) then
						CruisedSpeed = 0
						ESX.ShowNotification('Wyłączono tempomat poprzez zwolnienie prędkości pojazdu przez kierowcę.')
						Citizen.Wait(2000)
						break
					end
				end
			end)
		end
	end
end

function angle(veh)
	if not veh then return false end
	local vx,vy,vz = table.unpack(GetEntityVelocity(veh))
	local modV = math.sqrt(vx*vx + vy*vy)
	
	
	local rx,ry,rz = table.unpack(GetEntityRotation(veh,0))
	local sn,cs = -math.sin(math.rad(rz)), math.cos(math.rad(rz))
	
	if GetEntitySpeed(veh)* 3.6 < 30 or GetVehicleCurrentGear(veh) == 0 then return 0,modV end --speed over 30 km/h
	
	local cosX = (sn*vx + cs*vy)/modV
	if cosX > 0.966 or cosX < 0 then return 0,modV end
	return math.deg(math.acos(cosX))*0.5, modV
end
	

function IsTurningOrHandBraking ()
	return IsControlPressed(2, 76) or IsControlPressed(2, 63) or IsControlPressed(2, 64) or IsControlPressed(2, 71) or angle(GetVehicle()) > 2.5
end

function IsDriving ()
  return IsPedInAnyVehicle(PlayerPedId(), false)
end

function GetVehicle ()
  local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
  if (GetVehicleClass(vehicle) >= 0 and GetVehicleClass(vehicle) <= 12) or GetVehicleClass(vehicle) == 17 or GetVehicleClass(vehicle) == 18 or GetVehicleClass(vehicle) == 20 then
    return vehicle
  end
end

function IsInVehicle ()
  return GetPedInVehicleSeat(GetVehicle(), -1)
end

function IsDriver ()
  return GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId()
end

function GetVehicleSpeed ()
  local vehicle = GetVehicle()
  local speed = GetEntitySpeed(vehicle)
  return GetVehicleCurrentGear(vehicle) > 0 and speed or (speed * -1)
end

function TransformToKm (speed)
  return math.floor(speed * 3.6 + 0.5)
end

function IsEnabled()
  return CruisedSpeed ~= 0
end