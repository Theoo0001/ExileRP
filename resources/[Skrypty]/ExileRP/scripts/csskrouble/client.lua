--[[local knockedOut = false
local wait = 30

CreateThread(function()
	while true do
		Citizen.Wait(0)
        local myPed = PlayerPedId()
		if HasEntityBeenDamagedByWeapon(myPed, `WEAPON_UNARMED`, 0) or HasEntityBeenDamagedByWeapon(myPed, `WEAPON_NIGHTSTICK`, 0) then
			ClearEntityLastDamageEntity(myPed)
			Citizen.Wait(1000)
			if exports['esx_ambulancejob']:isDead() then
				knockedOut = true
				exports["exile_taskbar"]:taskBar(30000, "Jesteś poturbowany", false, true)
				knockedOut = false
				RespawnPed(myPed, GetEntityCoords(myPed), 0.0)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

local inveh = nil

CreateThread(function()
	while true do
		Citizen.Wait(500)
		if IsPedInAnyVehicle(PlayerPedId(), false) then
			inveh = true
		else
			inveh = false
		end
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(0)
        local myPed = PlayerPedId()
		if HasEntityBeenDamagedByWeapon(myPed, `WEAPON_RUN_OVER_BY_CAR`, 0) then
			ClearEntityLastDamageEntity(myPed)
			Citizen.Wait(1000)
			if exports['esx_ambulancejob']:isDead() and not inveh then
				knockedOut = true
				exports["exile_taskbar"]:taskBar(30000, "Jesteś poturbowany", false, true)
				knockedOut = false
				RespawnPed(myPed, GetEntityCoords(myPed), 0.0)
			end
		else
			Citizen.Wait(400)
		end
	end
end)

CreateThread(function()
	local lastHealth = GetEntityHealth(PlayerPedId())
	while true do
		Citizen.Wait(1000)
		local myPed = PlayerPedId()
		local health = GetEntityHealth(myPed)
		if HasEntityBeenDamagedByWeapon(myPed, `WEAPON_RAMMED_BY_CAR`, 0) then
			ClearEntityLastDamageEntity(myPed)
			if (health ~= lastHealth) then
				SetEntityHealth(myPed, lastHealth)
			end
		end
		lastHealth = health
	end
end)

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

CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if knockedOut then
			wait = wait-1
			if wait <= 0 then
				knockedOut = false
				SetTimecycleModifier("")
				SetTransitionTimecycleModifier("")		
				SetPlayerInvincible(PlayerId(), false)
			end
		end
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(0)
		if knockedOut then
			SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
			ResetPedRagdollTimer(PlayerPedId())
			DisableControlAction(2, 24, true)
			DisableControlAction(2, 257, true)
			DisableControlAction(2, 25, true)
			DisableControlAction(2, 263, true)
			DisableControlAction(2, Keys['R'], true)
			DisableControlAction(2, Keys['TOP'], true)
			DisableControlAction(2, Keys['Q'], true)
			DisableControlAction(2, Keys['~'], true)
			DisableControlAction(2, Keys['X'], true)
			DisableControlAction(2, Keys['Y'], true)
			DisableControlAction(2, Keys['PAGEDOWN'], true)
			DisableControlAction(2, Keys['B'], true)
			DisableControlAction(2, Keys['TAB'], true)
			DisableControlAction(2, Keys['F1'], true)
			DisableControlAction(2, Keys['F2'], true)
			DisableControlAction(2, Keys['F3'], true)
			DisableControlAction(2, Keys['F6'], true)
			DisableControlAction(2, Keys['V'], true)
      		DisableControlAction(2, Keys['P'], true)
      		DisableControlAction(2, Keys['U'], true)
			DisableControlAction(2, 59, true)
			DisableControlAction(2, Keys['LEFTCTRL'], true)
			DisableControlAction(0, 47, true)
			DisableControlAction(0, 264, true)
			DisableControlAction(0, 257, true)
			DisableControlAction(0, 140, true)
			DisableControlAction(0, 141, true)
			DisableControlAction(0, 142, true)
			DisableControlAction(0, 143, true)
		else
			Citizen.Wait(500)
		end
	end
end)

function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	TriggerEvent('playerSpawned', coords.x, coords.y, coords.z)
	ClearPedBloodDamage(ped)

	TriggerEvent("esx:onPlayerSpawn")

	ESX.UI.Menu.CloseAll()
end]]


--[[


wiadomość niżej
wiadomość niżej
wiadomość niżej
wiadomość niżej
wiadomość niżej
wiadomość niżej
wiadomość niżej
wiadomość niżej
wiadomość niżej
wiadomość niżej
wiadomość niżej
wiadomość niżej
wiadomość niżej
wiadomość niżej
wiadomość niżej
wiadomość niżej
wiadomość niżej
wiadomość niżej
wiadomość niżej
wiadomość niżej
wiadomość niżej
wiadomość niżej
wiadomość niżej
wiadomość niżej
wiadomość niżej
wiadomość niżej
wiadomość niżej
wiadomość niżej
wiadomość niżej
wiadomość niżej
wiadomość niżej
wiadomość niżej
wiadomość niżej
wiadomość niżej














PEDALE JEBANY Z NICKIEM DESIRE
JESZCZE RAZ COS TU DOTKNIESZ I ROZJEBIESZ
I ZAKODUJE TEN KOD

POZDRO Z FARTEM // CSSKROUBLE
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
^
]]

CreateThread(function() 
	while true do
		Citizen.Wait(1000)
		N_0xf4f2c0d4ee209e20()
		N_0x9e4cfff989258472()
	end	
end)

local scenarios = {
	'WORLD_VEHICLE_ATTRACTOR',
	'WORLD_VEHICLE_AMBULANCE',
	'WORLD_VEHICLE_BOAT_IDLE',
	'WORLD_VEHICLE_BOAT_IDLE_ALAMO',
	'WORLD_VEHICLE_BOAT_IDLE_MARQUIS',
	'WORLD_VEHICLE_BOAT_IDLE_MARQUIS',
	'WORLD_VEHICLE_BROKEN_DOWN',
	'WORLD_VEHICLE_BUSINESSMEN',
	'WORLD_VEHICLE_HELI_LIFEGUARD',
	'WORLD_VEHICLE_CLUCKIN_BELL_TRAILER',
	'WORLD_VEHICLE_CONSTRUCTION_SOLO',
	'WORLD_VEHICLE_CONSTRUCTION_PASSENGERS',
	'WORLD_VEHICLE_DRIVE_PASSENGERS',
	'WORLD_VEHICLE_DRIVE_PASSENGERS_LIMITED',
	'WORLD_VEHICLE_DRIVE_SOLO',
	'WORLD_VEHICLE_FARM_WORKER',
	'WORLD_VEHICLE_FIRE_TRUCK',
	'WORLD_VEHICLE_EMPTY',
	'WORLD_VEHICLE_MARIACHI',
	'WORLD_VEHICLE_MECHANIC',
	'WORLD_VEHICLE_MILITARY_PLANES_BIG',
	'WORLD_VEHICLE_MILITARY_PLANES_SMALL',
	'WORLD_VEHICLE_PARK_PARALLEL',
	'WORLD_VEHICLE_PARK_PERPENDICULAR_NOSE_IN',
	'WORLD_VEHICLE_PASSENGER_EXIT',
	'WORLD_VEHICLE_POLICE_BIKE',
	'WORLD_VEHICLE_POLICE_CAR',
	'WORLD_VEHICLE_POLICE',
	'WORLD_VEHICLE_POLICE_NEXT_TO_CAR',
	'WORLD_VEHICLE_QUARRY',
	'WORLD_VEHICLE_SALTON',
	'WORLD_VEHICLE_SALTON_DIRT_BIKE',
	'WORLD_VEHICLE_SECURITY_CAR',
	'WORLD_VEHICLE_STREETRACE',
	'WORLD_VEHICLE_TOURBUS',
	'WORLD_VEHICLE_TOURIST',
	'WORLD_VEHICLE_TANDL',
	'WORLD_VEHICLE_TRACTOR',
	'WORLD_VEHICLE_TRACTOR_BEACH',
	'WORLD_VEHICLE_TRUCK_LOGS',
	'WORLD_VEHICLE_TRUCKS_TRAILERS',
	'WORLD_VEHICLE_DISTANT_EMPTY_GROUND'
}

for i, v in ipairs(scenarios) do
	SetScenarioTypeEnabled(v, false)
end

CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		if IsPedInAnyVehicle(playerPed, true) then
			SetPedHelmet(playerPed, false)
		else
			Citizen.Wait(500)
		end
	end
end)

--RECE
local ConfigKey = 243

local handsup = false

local _animation = nil

local animations = { --enter nie wymagany

	{ lib = 'random@mugging3' , base = 'handsup_standing_base', enter = 'handsup_standing_enter', exit = 'handsup_standing_exit', fade = 1 }

}



CreateThread(function()

	while true do

		Citizen.Wait(3)

		if IsControlJustReleased(0, ConfigKey) then

			if handsup then

				handsup = false

				TaskPlayAnim(PlayerPedId(), _animation.lib, _animation.exit, 8.0, 8.0, 1.0, 48, 0, 0, 0, 0)	

				Wait(_animation.fade)

				ClearPedTasks(PlayerPedId())	

			elseif not IsPedInAnyVehicle(PlayerPedId(), false) and not IsPedSwimming(PlayerPedId()) and not IsPedShooting(PlayerPedId()) and not IsPedClimbing(PlayerPedId()) and not IsPedCuffed(PlayerPedId()) and not IsPedDiving(PlayerPedId()) and not IsPedFalling(PlayerPedId()) and not IsPedJumping(PlayerPedId()) and not IsPedJumpingOutOfVehicle(PlayerPedId()) and IsPedOnFoot(PlayerPedId()) and not IsPedInParachuteFreeFall(PlayerPedId()) then							

				handsup = true			

				_animation = animations[math.random(1, #animations)]

				RequestAnimDict(_animation.lib)

				while not HasAnimDictLoaded(_animation.lib) do

					Citizen.Wait(1)

				end

				TaskPlayAnim(PlayerPedId(), _animation.lib, _animation.enter, 8.0, 8.0, 1.0, 50, 0, 0, 0, 0)

			end

		end

	end

end)

--KUCANIE
local crouched = false
local mode = 0

PedAXD = {
	Active = false,
	Locked = false,
	Id = 0,
	Alive = false,
	Available = false,
	Visible = false,
	InVehicle = false
}
CreateThread(function()
	while true do
		Citizen.Wait(100)

		PedAXD.Id = PlayerPedId()
		if DoesEntityExist(PedAXD.Id) then
			PedAXD.Active = not IsPauseMenuActive()
			PedAXD.Visible = IsEntityVisible(PedAXD.Id)
			PedAXD.InVehicle = IsPedInAnyVehicle(PedAXD.Id, false)
		else
			PedAXD.Alive = false
			PedAXD.Available = false
		end
	end
end)

CreateThread(function()
	while not HasAnimSetLoaded("move_ped_crouched") do
		RequestAnimSet("move_ped_crouched")
		Citizen.Wait(0)
	end

    while true do
        Citizen.Wait(2)
		local crouchKey = 36

		DisableControlAction(0, crouchKey, true)
		if IsDisabledControlJustPressed(0, crouchKey) then
			if PedAXD.Active then
				if not PedAXD.InVehicle and PedAXD.Visible then
					if not IsPedFalling(PedAXD.Id) and not IsPedCuffed(PedAXD.Id) and not IsPedDiving(PedAXD.Id) and not IsPedInCover(PedAXD.Id, false) and not IsPedInParachuteFreeFall(PedAXD.Id) and (GetPedParachuteState(PedAXD.Id) == 0 or GetPedParachuteState(PedAXD.Id) == -1) and not IsPedBeingStunned(PedAXD.Id) then
						mode = mode+1
						if mode == 1 then
							SetPedMovementClipset(PedAXD.Id, "move_ped_crouched", 0.25)
						elseif mode == 2 then
							ResetPedMovementClipset(PedAXD.Id, 0)
							SetPedStealthMovement(PedAXD.Id ,true, "")
						elseif mode == 3 then
							mode = 0
							SetPedStealthMovement(PedAXD.Id ,false, "")
						end
					end
				end
            end
        end
    end
end)

local mp_pointing = false

startPointing = function()
    local ped = PlayerPedId()
    RequestAnimDict("anim@mp_point")
    while not HasAnimDictLoaded("anim@mp_point") do
        Wait(0)
    end
    SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
    SetPedConfigFlag(ped, 36, 1)
	TaskMoveNetworkByName(ped, 'task_mp_pointing', 0.5, false, 'anim@mp_point', 24)
    RemoveAnimDict("anim@mp_point")
end

stopPointing = function()
    local ped = PlayerPedId()
	RequestTaskMoveNetworkStateTransition(ped, 'Stop')
    if not IsPedInjured(ped) then
        ClearPedSecondaryTask(ped)
    end
    if not IsPedInAnyVehicle(ped, 1) then
        SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
    end
    SetPedConfigFlag(ped, 36, 0)
    ClearPedSecondaryTask(PlayerPedId())
end

RegisterCommand('point', function()
	local x = GetVehiclePedIsEntering(PlayerPedId())
    if not IsPedInAnyVehicle(PlayerPedId(), false) and x and x == nil then
        if mp_pointing then
            stopPointing()
            mp_pointing = false
        else
            startPointing()
            mp_pointing = true
        end
        while mp_pointing do
            local ped = PlayerPedId()
            local camPitch = GetGameplayCamRelativePitch()
            if camPitch < -70.0 then
                camPitch = -70.0
            elseif camPitch > 42.0 then
                camPitch = 42.0
            end
            camPitch = (camPitch + 70.0) / 112.0

            local camHeading = GetGameplayCamRelativeHeading()
            local cosCamHeading = Cos(camHeading)
            local sinCamHeading = Sin(camHeading)
            if camHeading < -180.0 then
                camHeading = -180.0
            elseif camHeading > 180.0 then
                camHeading = 180.0
            end
            camHeading = (camHeading + 180.0) / 360.0

            local blocked = 0
            local nn = 0

            local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
            local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7);
            nn,blocked,coords,coords = GetRaycastResult(ray)	
			SetTaskMoveNetworkSignalFloat(ped, "Pitch", camPitch)
			SetTaskMoveNetworkSignalFloat(ped, "Heading", camHeading * -1.0 + 1.0)
			SetTaskMoveNetworkSignalBool(ped, "isBlocked", blocked)
			SetTaskMoveNetworkSignalBool(ped, "isFirstPerson", GetCamViewModeForContext(GetCamActiveViewModeContext()) == 4)
            Citizen.Wait(1)
        end
    end
end)

RegisterKeyMapping('point', 'Pokazywanie palcem', 'keyboard', 'b')