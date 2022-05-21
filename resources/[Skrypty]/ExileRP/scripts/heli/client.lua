-- Config
local fov_max = 80.0
local fov_min = 5.0 -- max zoom level (smaller fov is more zoom)
local zoomspeed = 3.0 -- camera zoom speed
local speed_lr = 4.0 -- speed by which the camera pans left-right 
local speed_ud = 4.0 -- speed by which the camera pans up-down
local toggle_helicam = 51 -- control id of the button by which to toggle the helicam mode. Default: INPUT_CONTEXT (E)
local toggle_vision = 25 -- control id to toggle vision mode. Default: INPUT_AIM (Right mouse btn)
local toggle_rappel = 154 -- control id to rappel out of the heli. Default: INPUT_DUCK (X)
local toggle_spotlight = 183 -- control id to toggle the various spotlight states Default: INPUT_PhoneCameraGrid (G)
local toggle_lock_on = 22 -- control id to lock onto a vehicle with the camera or unlock from vehicle (with or without camera). Default is INPUT_SPRINT (spacebar)
local toggle_display = 29 -- control id to toggle vehicle info display. Default: INPUT_SPECIAL_ABILITY_SECONDARY (B)
local lightup_key = 172 -- control id to increase spotlight brightness. Default: INPUT_CELLPHONE_UP (ARROW-UP)
local lightdown_key = 173 -- control id to decrease spotlight brightness. Default: INPUT_CELLPHONE_DOWN  (ARROW-DOWN)
local radiusup_key = 137 -- control id to increase manual spotlight radius. Default: INPUT_VEH_PUSHBIKE_SPRINT (CAPSLOCK)
local radiusdown_key = 21 -- control id to decrease spotlight radius. Default: INPUT_SPRINT (LEFT-SHIFT)
local maxtargetdistance = 1000 -- max distance at which target lock is maintained
local brightness = 1.0 -- default spotlight brightness
local spotradius = 4.0 -- default manual spotlight radius
local speed_measure = "Km/h" -- default unit to measure vehicle speed but can be changed to "MPH". Use either exact string, "Km/h" or "MPH", or else functions break.

-- Script starts here
local target_vehicle = nil
local manual_spotlight = false
local tracking spotlight = false
local vehicle_display = 0 -- 0 is default full vehicle info display with speed/model/plate, 1 is model/plate, 2 turns off display
local helicam = false
local fov = (fov_max+fov_min)*0.5
local vision_state = 0 -- 0 is normal, 1 is nightmode, 2 is thermal vision
local vehicles = {}

CreateThread(function() -- Register ped decorators used to pass some variables from heli pilot to other players (variable settings: 1=false, 2=true)
	while true do
	Citizen.Wait(0)
		if NetworkIsSessionStarted() then
			DecorRegister("SpotvectorX", 3) -- For direction of manual spotlight
			DecorRegister("SpotvectorY", 3)
			DecorRegister("SpotvectorZ", 3)
			break
		end
	end
end)



CreateThread(function()
	Citizen.Wait(5000)
	TriggerEvent('esx_vehicleshop:getVehicles', function(base)
		vehicles = base
	end)

	local heli
	CreateThread(function()
		local ticks = 0
		while true do
			Citizen.Wait(100)
			if heli and target_vehicle and not HasEntityClearLosToEntity(heli, target_vehicle, 17) then
				ticks = ticks + 1
				if ticks == 10 then -- cut the laser target after 1 second on LOS lose
					target_vehicle = nil
					ticks = 0
				end
			else
				ticks = 0
			end
		end
	end)

	while true do
        Citizen.Wait(0)
		heli = GetVehiclePedIsIn(playerPed, false)
		
		local sleep = true

		local model = GetEntityModel(heli)
		if model == `ms_heli` or model == `pd_heli` or model == `SamolocikKrzychu` or model == `annihilator2` then
			sleep = false
			if IsHeliHighEnough(heli) then
				if IsControlJustPressed(0, toggle_helicam) and (GetPedInVehicleSeat(heli, -1) == playerPed or GetPedInVehicleSeat(heli, 0) == playerPed) then -- Toggle Helicam
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					helicam = true

					ESX.UI.HUD.SetDisplay(0.0)
					TriggerEvent('es:setMoneyDisplay', 0.0)
					TriggerEvent('esx_status:setDisplay', 0.0)
					TriggerEvent('esx_voice:setDisplay', 0.0)
					TriggerEvent('radar:setHidden', true)
					TriggerEvent('carhud:display', false)
				end
				
				if IsControlJustPressed(0, toggle_rappel) then -- Initiate rappel
					if GetPedInVehicleSeat(heli, 1) == playerPed or GetPedInVehicleSeat(heli, 2) == playerPed then
						PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
						SetPedCanRagdoll(playerPed, false)
						TaskRappelFromHeli(playerPed, 1)
						CreateThread(function()
							Citizen.Wait(30000)
							SetPedCanRagdoll(playerPed, true)
						end)
					else
						PlaySoundFrontend(-1, "5_Second_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", false) 
					end
				end
			end
			
			if IsControlJustPressed(0, toggle_spotlight) and GetPedInVehicleSeat(heli, -1) == playerPed and not helicam then -- Toggle forward and tracking spotlight states
				if target_vehicle then
					if tracking_spotlight then
						if not pause_Tspotlight then
							pause_Tspotlight = true
							TriggerServerEvent("heli:pause.tracking.spotlight", pause_Tspotlight)
						else
							pause_Tspotlight = false
							TriggerServerEvent("heli:pause.tracking.spotlight", pause_Tspotlight)
						end

						PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					else
						if Fspotlight_state then
							Fspotlight_state = false	
							TriggerServerEvent("heli:forward.spotlight", Fspotlight_state)
						end

						local target_netID = VehToNet(target_vehicle)
						local target_plate = GetVehicleNumberPlateText(target_vehicle, true)
						local targetposx, targetposy, targetposz = table.unpack(GetEntityCoords(target_vehicle))

						pause_Tspotlight = false
						tracking_spotlight = true
						TriggerServerEvent("heli:tracking.spotlight", target_netID, target_plate, targetposx, targetposy, targetposz)
						PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					end				
				else
					if tracking_spotlight then
						pause_Tspotlight = false
						tracking_spotlight = false
						TriggerServerEvent("heli:tracking.spotlight.toggle")
					end

					Fspotlight_state = not Fspotlight_state
					TriggerServerEvent("heli:forward.spotlight", Fspotlight_state)
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
				end
			end

			if IsControlJustPressed(0, toggle_display) and (GetPedInVehicleSeat(heli, -1) == playerPed or GetPedInVehicleSeat(heli, 0) == playerPed) then 
				ChangeDisplay()
			end

			if target_vehicle and (GetPedInVehicleSeat(heli, -1) == playerPed or GetPedInVehicleSeat(heli, 0) == playerPed) then
				local coords1 = GetEntityCoords(heli)
				local coords2 = GetEntityCoords(target_vehicle)

				local target_distance = #(coords1 - coords2)
				if IsControlJustPressed(0, toggle_lock_on) or target_distance > maxtargetdistance then
					if tracking_spotlight then
						TriggerServerEvent("heli:tracking.spotlight.toggle")
					end

					tracking_spotlight = false
					pause_Tspotlight = false
					target_vehicle = nil					
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
				end
			end
		end
		
		if helicam then
			sleep = false
			SetTimecycleModifier("heliGunCam")
			SetTimecycleModifierStrength(0.3)

			local scaleform = RequestScaleformMovie("HELI_CAM")
			while not HasScaleformMovieLoaded(scaleform) do
				Citizen.Wait(0)
			end

			local heli = GetVehiclePedIsIn(playerPed, false)

			local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
			AttachCamToEntity(cam, heli, 0.0,0.0,-1.5, true)
			SetCamRot(cam, 0.0,0.0,GetEntityHeading(heli))
			SetCamFov(cam, fov)
			RenderScriptCams(true, false, 0, 1, 0)
			PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
			PushScaleformMovieFunctionParameterInt(0) -- 0 for nothing, 1 for LSPD logo
			PopScaleformMovieFunctionVoid()

			local locked_on_vehicle = nil
			while helicam and not DecorExistOn(playerPed, 'injured') and (GetVehiclePedIsIn(playerPed, false) == heli) and IsHeliHighEnough(heli) do
				if IsControlJustPressed(0, toggle_helicam) then -- Toggle Helicam
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					if manual_spotlight and target_vehicle then -- If exiting helicam while manual spotlight is locked on a target, transition to non-helicam auto tracking spotlight
						TriggerServerEvent("heli:manual.spotlight.toggle")
						local target_netID = VehToNet(target_vehicle)
						local target_plate = GetVehicleNumberPlateText(target_vehicle, true)
						local targetposx, targetposy, targetposz = table.unpack(GetEntityCoords(target_vehicle))

						pause_Tspotlight = false
						tracking_spotlight = true
						TriggerServerEvent("heli:tracking.spotlight", target_netID, target_plate, targetposx, targetposy, targetposz)
						PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					end

					manual_spotlight = false
					helicam = false
				end

				if IsControlJustPressed(0, toggle_vision) then
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
					ChangeVision()
				end

				if IsControlJustPressed(0, toggle_spotlight) then -- Spotlight_toggles within helicam
					if tracking_spotlight then -- If tracking spotlight active, pause it & toggle manual spotlight
						pause_Tspotlight = true
						TriggerServerEvent("heli:pause.tracking.spotlight", pause_Tspotlight)
						manual_spotlight = not manual_spotlight
						if manual_spotlight then
							local rotation = GetCamRot(cam, 2)
							local forward_vector = RotAnglesToVec(rotation)
							local SpotvectorX, SpotvectorY, SpotvectorZ = table.unpack(forward_vector)
							DecorSetInt(playerPed, "SpotvectorX", SpotvectorX)
							DecorSetInt(playerPed, "SpotvectorY", SpotvectorY)
							DecorSetInt(playerPed, "SpotvectorZ", SpotvectorZ)
							PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
							TriggerServerEvent("heli:manual.spotlight")
						else
							TriggerServerEvent("heli:manual.spotlight.toggle")
						end
					elseif Fspotlight_state then -- If forward spotlight active, disable it & toggle manual spotlight
						Fspotlight_state = false
						TriggerServerEvent("heli:forward.spotlight", Fspotlight_state)
						manual_spotlight = not manual_spotlight
						if manual_spotlight then
							PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
							TriggerServerEvent("heli:manual.spotlight")
						else
							TriggerServerEvent("heli:manual.spotlight.toggle")
						end
					else -- If no other spotlight mode active, toggle manual spotlight
						manual_spotlight = not manual_spotlight
						if manual_spotlight then
							PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
							TriggerServerEvent("heli:manual.spotlight")
						else
							TriggerServerEvent("heli:manual.spotlight.toggle")
						end
					end
				end

				if IsControlJustPressed(0, lightup_key) then
					TriggerServerEvent("heli:light.up")
				end

				if IsControlJustPressed(0, lightdown_key) then
					TriggerServerEvent("heli:light.down")
				end

				if IsControlJustPressed(0, radiusup_key) then
					TriggerServerEvent("heli:radius.up")
				end

				if IsControlJustPressed(0, radiusdown_key) then
					TriggerServerEvent("heli:radius.down")
				end

				if IsControlJustPressed(0, toggle_display) then 
					ChangeDisplay()
				end

				if locked_on_vehicle then
					if DoesEntityExist(locked_on_vehicle) then
						PointCamAtEntity(cam, locked_on_vehicle, 0.0, 0.0, 0.0, true)
						RenderVehicleInfo(locked_on_vehicle)
						local coords1 = GetEntityCoords(heli)
						local coords2 = GetEntityCoords(locked_on_vehicle)

						local target_distance = #(coords1 - coords2)
						if IsControlJustPressed(0, toggle_lock_on) or target_distance > maxtargetdistance then
							PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
							if tracking_spotlight then
								TriggerServerEvent("heli:tracking.spotlight.toggle")
								tracking_spotlight = false
							end
							target_vehicle = nil
							locked_on_vehicle = nil
							local rot = GetCamRot(cam, 2) -- All this because I can't seem to get the camera unlocked from the entity
							local fov = GetCamFov(cam)
							local old cam = cam
							DestroyCam(old_cam, false)
							cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
							AttachCamToEntity(cam, heli, 0.0,0.0,-1.5, true)
							SetCamRot(cam, rot, 2)
							SetCamFov(cam, fov)
							RenderScriptCams(true, false, 0, 1, 0)
						end
					else
						locked_on_vehicle = nil -- Cam will auto unlock when entity doesn't exist anyway
						target_vehicle = nil
					end
				else
					local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
					CheckInputRotation(cam, zoomvalue)
					local vehicle_detected = GetVehicleInView(cam, heli)
					if DoesEntityExist(vehicle_detected) then
						RenderVehicleInfo(vehicle_detected)
						if IsControlJustPressed(0, toggle_lock_on) then
							PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
							locked_on_vehicle = vehicle_detected
							target_vehicle = vehicle_detected

							--[[NetworkRequestControlOfEntity(target_vehicle)
							local target_netID = VehToNet(target_vehicle) 
							SetNetworkIdCanMigrate(target_netID, true)
							NetworkRegisterEntityAsNetworked(VehToNet(target_vehicle))
							SetNetworkIdExistsOnAllMachines(target_vehicle, true) 
							SetEntityAsMissionEntity(target_vehicle, true, false) ]]--

							target_plate = GetVehicleNumberPlateText(target_vehicle, true)
							if tracking_spotlight then -- If tracking previous target, terminate and start tracking new target
								TriggerServerEvent("heli:tracking.spotlight.toggle")
								target_vehicle = locked_on_vehicle
								
								if not pause_Tspotlight then -- If spotlight was paused when tracking old target, 
									local target_netID = VehToNet(target_vehicle)
									local target_plate = GetVehicleNumberPlateText(target_vehicle, true)
									local targetposx, targetposy, targetposz = table.unpack(GetEntityCoords(target_vehicle))
									pause_Tspotlight = false
									tracking_spotlight = true
									TriggerServerEvent("heli:tracking.spotlight", target_netID, target_plate, targetposx, targetposy, targetposz)
									PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
								else
									tracking_spotlight = false
									pause_Tspotlight = false
								end
							end
						end
					end
				end

				HandleZoom(cam)
				HideHUDThisFrame()
				PushScaleformMovieFunction(scaleform, "SET_ALT_FOV_HEADING")
				PushScaleformMovieFunctionParameterFloat(GetEntityCoords(heli).z)
				PushScaleformMovieFunctionParameterFloat(zoomvalue)
				PushScaleformMovieFunctionParameterFloat(GetCamRot(cam, 2).z)
				PopScaleformMovieFunctionVoid()
				DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
				Citizen.Wait(0)

				if manual_spotlight then -- Continuously update manual spotlight direction, sync client-client with decorators
					local rotation = GetCamRot(cam, 2)
					local forward_vector = RotAnglesToVec(rotation)
					local SpotvectorX, SpotvectorY, SpotvectorZ = table.unpack(forward_vector)
					local camcoords = GetCamCoord(cam)

					-- local netId = NetworkGetNetworkIdFromEntity(playerPed)
					-- TriggerServerEvent('esx:updateDecor', 'INT', netId, "SpotvectorX", SpotvectorX)
					-- TriggerServerEvent('esx:updateDecor', 'INT', netId, "SpotvectorY", SpotvectorY)
					-- TriggerServerEvent('esx:updateDecor', 'INT', netId, "SpotvectorZ", SpotvectorZ)
					DecorSetInt(playerPed, "SpotvectorX", SpotvectorX)
					DecorSetInt(playerPed, "SpotvectorY", SpotvectorY)
					DecorSetInt(playerPed, "SpotvectorZ", SpotvectorZ)
					DrawSpotLight(camcoords, forward_vector, 255, 255, 255, 800.0, 10.0, brightness, spotradius, 1.0, 1.0)
				else
					TriggerServerEvent("heli:manual.spotlight.toggle")
				end

			end

			if manual_spotlight then
				manual_spotlight = false
				TriggerServerEvent("heli:manual.spotlight.toggle")
			end

			helicam = false
			ClearTimecycleModifier()

			ESX.UI.HUD.SetDisplay(1.0)
			TriggerEvent('es:setMoneyDisplay', 1.0)
			TriggerEvent('esx_status:setDisplay', 1.0)
			TriggerEvent('esx_voice:setDisplay', 1.0)
			TriggerEvent('radar:setHidden', false)
			TriggerEvent('carhud:display', true)

			fov = (fov_max+fov_min)*0.5 -- reset to starting zoom level
			RenderScriptCams(false, false, 0, 1, 0) -- Return to gameplay camera
			SetScaleformMovieAsNoLongerNeeded(scaleform) -- Cleanly release the scaleform
			DestroyCam(cam, false)
			SetNightvision(false)
			SetSeethrough(false)
			vision_state = 0
		end

		if (model == `pd_heli` or model == `SamolocikKrzychu` or model == `annihilator2`) and target_vehicle and not helicam and vehicle_display ~= 2 then
			RenderVehicleInfo(target_vehicle)
			sleep = false
		end
		
		if sleep then
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('heli:forward.spotlight')
AddEventHandler('heli:forward.spotlight', function(serverID, state)
	local player = GetPlayerFromServerId(serverID)
	if player and player ~= -1 then
		SetVehicleSearchlight(GetVehiclePedIsIn(GetPlayerPed(player), false), state, false)
	end
end)

RegisterNetEvent('heli:Tspotlight')
AddEventHandler('heli:Tspotlight', function(serverID, target_netID, target_plate, targetposx, targetposy, targetposz)
	-- Client target identification and verification, with fail-safes until FiveM code around global networked entities is sorted out
	if GetVehicleNumberPlateText(NetToVeh(target_netID), true) == target_plate then
		Tspotlight_target = NetToVeh(target_netID)
	elseif GetVehicleNumberPlateText(GetClosestVehicle(targetposx, targetposy, targetposz, 25.0, 0, 70), true) == target_plate then
		Tspotlight_target = GetClosestVehicle(targetposx, targetposy, targetposz, 25.0, 0, 70)
	else 
		vehicle_match = FindVehicleByPlate(target_plate)
		if vehicle_match then
			Tspotlight_target = vehicle_match
		else 
			Tspotlight_target = nil
		end
	end

	local player = GetPlayerFromServerId(serverID)
	if player and player ~= -1 then
		local heliPed = GetPlayerPed(player)
		local heli = GetVehiclePedIsIn(heliPed, false)

		Tspotlight_toggle = true
		Tspotlight_pause = false
		tracking_spotlight = true

		CreateThread(function()
			local ticks = 0
			while heli and Tspotlight_target do
				Citizen.Wait(100)
				if not HasEntityClearLosToEntity(heli, Tspotlight_target, 17) then
					ticks = ticks + 1
					if ticks == 10 then -- cut the laser target after 1 second on LOS lose
						break
					end
				end
			end

			Tspotlight_target = nil
		end)

		Citizen.CreateThreadNow(function()
			while DoesEntityExist(heli) and not DecorExistOn(heliPed, 'injured') and GetVehiclePedIsIn(heliPed, false) == heli and Tspotlight_target and Tspotlight_toggle do
				Citizen.Wait(0)
				local helicoords = GetEntityCoords(heli)
				local targetcoords = GetEntityCoords(Tspotlight_target)
				local spotVector = targetcoords - helicoords
				local target_distance = #(targetcoords - helicoords)
				if Tspotlight_target and Tspotlight_toggle and not Tspotlight_pause then -- Redundant condition seems needed here or a function breaks
					DrawSpotLight(helicoords['x'], helicoords['y'], helicoords['z'], spotVector['x'], spotVector['y'], spotVector['z'], 255, 255, 255, (target_distance+20), 10.0, brightness, 4.0, 1.0, 0.0)
				end
				if Tspotlight_target and Tspotlight_toggle and target_distance > maxtargetdistance then -- Ditto for this target loss section
					target_vehicle = nil
					tracking_spotlight = false

					TriggerServerEvent("heli:tracking.spotlight.toggle")
					Tspotlight_target = nil
					break
				end
			end

			Tspotlight_toggle = false
			Tspotlight_pause = false
			Tspotlight_target = nil
			tracking_spotlight = false
		end)
	end
end)

RegisterNetEvent('heli:Tspotlight.toggle')
AddEventHandler('heli:Tspotlight.toggle', function(serverID)
	Tspotlight_toggle = false
	tracking_spotlight = false
end)

RegisterNetEvent('heli:pause.Tspotlight')
AddEventHandler('heli:pause.Tspotlight', function(serverID, pause_Tspotlight)
	if pause_Tspotlight then
		Tspotlight_pause = true
	else
		Tspotlight_pause = false
	end
end)

RegisterNetEvent('heli:Mspotlight')
AddEventHandler('heli:Mspotlight', function(serverID)
	if GetPlayerServerId(playerid) ~= serverID then -- Skip event for the source, since heli pilot already sees a more responsive manual spotlight
		local player = GetPlayerFromServerId(serverID)
		if player and player ~= -1 then
			local heliPed = GetPlayerPed(player)
			local heli = GetVehiclePedIsIn(heliPed, false)

			Mspotlight_toggle = true
			while not DecorExistOn(heliPed, 'injured') and (GetVehiclePedIsIn(heliPed, false) == heli) and Mspotlight_toggle do
				Citizen.Wait(0) 
				local helicoords = GetEntityCoords(heli)
				spotoffset = helicoords + vector3(0.0, 0.0, -1.5)
				SpotvectorX = DecorGetInt(heliPed, "SpotvectorX")
				SpotvectorY = DecorGetInt(heliPed, "SpotvectorY")
				SpotvectorZ = DecorGetInt(heliPed, "SpotvectorZ")
				if SpotvectorX then
					DrawSpotLight(spotoffset['x'], spotoffset['y'], spotoffset['z'], SpotvectorX, SpotvectorY, SpotvectorZ, 255, 255, 255, 800.0, 10.0, brightness, spotradius, 1.0, 1.0)
				end
			end

			Mspotlight_toggle = false
			local netId = NetworkGetNetworkIdFromEntity(heliPed)
			DecorSetInt(heliPed, "SpotvectorX", nil)
			DecorSetInt(heliPed, "SpotvectorY", nil)
			DecorSetInt(heliPed, "SpotvectorZ", nil)
		end
	end
end)

RegisterNetEvent('heli:Mspotlight.toggle')
AddEventHandler('heli:Mspotlight.toggle', function(serverID)
	Mspotlight_toggle = false
end)

RegisterNetEvent('heli:light.up')
AddEventHandler('heli:light.up', function(serverID)
	if brightness < 10 then
		brightness = brightness + 1.0
		PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
	end
end)

RegisterNetEvent('heli:light.down')
AddEventHandler('heli:light.down', function(serverID)
	if brightness > 1.0 then
		brightness = brightness - 1.0
		PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
	end
end)

RegisterNetEvent('heli:radius.up')
AddEventHandler('heli:radius.up', function(serverID)
	if spotradius < 10.0 then
		spotradius = spotradius + 1.0
		PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
	end
end)

RegisterNetEvent('heli:radius.down')
AddEventHandler('heli:radius.down', function(serverID)
	if spotradius > 4.0 then
		spotradius = spotradius - 1.0
		PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
	end
end)

function IsHeliHighEnough(heli)
	return GetEntityHeightAboveGround(heli) > 1.5
end

function ChangeVision()
	if vision_state == 0 then
		SetNightvision(true)
		vision_state = 1
	elseif vision_state == 1 then
		SetNightvision(false)
		SetSeethrough(true)
		vision_state = 2
	else
		SetSeethrough(false)
		vision_state = 0
	end
end

function ChangeDisplay()
	if vehicle_display == 0 then
		vehicle_display = 1
	elseif vehicle_display == 1 then
		vehicle_display = 2
	else
		vehicle_display = 0
	end
end

function HideHUDThisFrame()
	HideHelpTextThisFrame()
	for i = 1, 35 do
		HideHudComponentThisFrame(i)
	end
end

function CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5) -- Clamping at top (cant see top of heli) and at bottom (doesn't glitch out in -90deg)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

function HandleZoom(cam)
	DisableControlAction(2, 85, true)

	if IsControlJustPressed(0,241) then -- Scrollup
		fov = math.max(fov - zoomspeed, fov_min)
	end

	if IsControlJustPressed(0,242) then
		fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown		
	end

	local current_fov = GetCamFov(cam)
	if math.abs(fov-current_fov) < 0.1 then -- the difference is too small, just set the value directly to avoid unneeded updates to FOV of order 10^-5
		fov = current_fov
	end

	SetCamFov(cam, current_fov + (fov - current_fov)*0.05) -- Smoothing of camera zoom
end

function GetVehicleInView(cam, heli)
	local coords = GetCamCoord(cam)
	local forward_vector = RotAnglesToVec(GetCamRot(cam, 2))
	--DrawLine(coords, coords+(forward_vector*200.0), 255,0,0,255) -- debug line to show LOS of cam

	local rayhandle = StartShapeTestRay(coords, coords+(forward_vector*200.0), 2, heli, 0)
	local result, hit, entityCoords, surfaceVector, entityHit = GetShapeTestResult(rayhandle)
	if hit and IsEntityAVehicle(entityHit) then
		return entityHit
	end
end

function RenderVehicleInfo(vehicle)	
	if DoesEntityExist(vehicle) then
		local name = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
		if name ~= 'CARNOTFOUND' then				
			local found = false
			
			for _, veh in ipairs(vehicles) do
				if (veh.game == name) or veh.model == fmodel then
					fmodel = veh.name
					found = true
					break
				end
			end

			if not found then
				local label = GetLabelText(name)
				if label ~= "NULL" then
					name = label
				end
			end
		end

		local licenseplate = GetVehicleNumberPlateText(vehicle)
		local vehspeed = GetEntitySpeed(vehicle)*3.6

		local coords = GetEntityCoords(vehicle, true)
		local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
		local street1, street2 = GetStreetNameFromHashKey(s1), GetStreetNameFromHashKey(s2)

		SetTextFont(0)
		SetTextProportional(1)
		if vehicle_display == 0 then
			SetTextScale(0.0, 0.34)
		elseif vehicle_display == 1 then
			SetTextScale(0.0, 0.4)
		end

		SetTextColour(255, 255, 255, 255)
		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextEdge(1, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()

		SetTextEntry("STRING")
		if vehicle_display == 0 then
			AddTextComponentString("Prędkość: " .. math.floor(vehspeed + 0.5) .. " " .. speed_measure .. "\nPojazd: " .. name .. "\nNr rej.: " .. licenseplate .. "\n~y~" .. street1 .. (street2 ~= "" and "~s~ / " .. street2 or "~s~"))
		elseif vehicle_display == 1 then
			AddTextComponentString("Pojazd: " .. name .. "\nNr rej.: " .. licenseplate .. "\n~y~" .. street1 .. (street2 ~= "" and "~s~ / " .. street2 or "~s~"))
		end

		DrawText(0.75, 0.9)
	end
end

function RotAnglesToVec(rot) -- input vector3
	local z = math.rad(rot.z)
	local x = math.rad(rot.x)
	local num = math.abs(math.cos(x))
	return vector3(-math.sin(z)*num, math.cos(z)*num, math.sin(x))
end

local entityEnumerator = {
  __gc = function(enum)
    if enum.destructor and enum.handle then
      enum.destructor(enum.handle)
    end
    enum.destructor = nil
    enum.handle = nil
  end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
  return coroutine.wrap(function()
    local iter, id = initFunc()
    if not id or id == 0 then
      disposeFunc(iter)
      return
    end
    
    local enum = {handle = iter, destructor = disposeFunc}
    setmetatable(enum, entityEnumerator)
    
    local next = true
    repeat
      coroutine.yield(id)
      next, id = moveFunc(iter)
    until not next
    
    enum.destructor, enum.handle = nil, nil
    disposeFunc(iter)
  end)
end

function EnumerateVehicles()
  return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function FindVehicleByPlate(plate) -- Search existing vehicles enumerated above for target plate and return the matching vehicle
	for vehicle in EnumerateVehicles() do
		if GetVehicleNumberPlateText(vehicle, true) == plate then
			return vehicle
		end
	end
end