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

ESX             			  = nil
local PlayerData			  = {}
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil

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

AddEventHandler('esx_securitycam:hasEnteredMarker', function (zone)
  CurrentAction     = 'cameras'
  CurrentActionMsg  = _U('marker_hint')
end)

AddEventHandler('esx_securitycam:hasExitedMarker', function (zone)
  CurrentAction = nil
end)

CreateThread(function()
	while true do
		Citizen.Wait(0)

		local isInMarker  = false
		local currentZone = nil

		if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
			local sleep = true
			local coords = GetEntityCoords(PlayerPedId(), true)
			for k,v in pairs(Config.Zones) do
				if v.Pos then
					if(v.Type ~= -1 and #(coords - vec3(v.Pos.x, v.Pos.y, v.Pos.z)) < Config.DrawDistance) then
						sleep = false
						ESX.DrawMarker(vec3(v.Pos.x, v.Pos.y, v.Pos.z))
					end
				end
				
				local pos = v.Pos
				if not pos and v.Model then
					local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 10.0, v.Model, 70)
					if vehicle and vehicle ~= 0 then
						pos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, v.Bone))
						pos = {x = pos.x + v.Offset.x, y = pos.y + v.Offset.y, z = pos.z + v.Offset.z}
					end
				end
				
				if pos and #(coords - vec3(pos.x, pos.y, pos.z)) < (v.Opacity or 1.5) then
					sleep = false
					
					isInMarker  = true
					currentZone = k
				end
			
			end
			
			if sleep then
				Citizen.Wait(250)
			end
		else
			Citizen.Wait(1000)
		end
	
		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone = currentZone
			TriggerEvent('esx_securitycam:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_securitycam:hasExitedMarker', LastZone)
			CurrentAction = nil
			ESX.UI.Menu.CloseAll()
		end
	end
end)

local createdCamera = 0
local currentCamera = nil
local currentCameraIndex = 1

CreateThread(function()
    while true do
		Citizen.Wait(0)
		if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
			local sleep = true
			
			if CurrentAction ~= nil then
				sleep = false
				SetTextComponentFormat('STRING')
				AddTextComponentString(CurrentActionMsg)
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)

				if IsControlJustReleased(0, Keys['E']) and CurrentAction == 'cameras' then
					CurrentAction = nil

					local elements = {}
					for i, v in ipairs(Config.Locations) do
						table.insert(elements, {label = v.label, value = v})
					end

					ESX.UI.Menu.CloseAll()
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'securitycam', {
						title    = _U('securitycams_menu'),
						align    = 'center',
						elements = elements
					}, function(data, menu)
						menu.close()
						

						SetFocusArea(data.current.value.cameras[1].x, data.current.value.cameras[1].y, data.current.value.cameras[1].z)
						ChangeSecurityCamera(data.current.value.cameras[1].x, data.current.value.cameras[1].y, data.current.value.cameras[1].z, data.current.value.cameras[1].r)

						currentCamera = data.current.value
						currentCameraIndex = 1
						TriggerEvent('esx_securitycam:freeze', true)
					end, function(data, menu)
						menu.close()
					end)
				end
			end

			if createdCamera ~= 0 then
				sleep = false
				HideHudAndRadarThisFrame()
				_DrawText(0.515, 0.50, 1.0, 1.0, 0.55, currentCamera.label, 66, 165, 245, 200)
				_DrawText(0.515, 0.53, 1.0, 1.0, 0.45, currentCamera.cameras[currentCameraIndex].label, 165, 165, 165, 200)

				DisableControlAction(0, Keys['W'], true)
				DisableControlAction(0, Keys['S'], true)
				DisableControlAction(0, Keys['A'], true)
				DisableControlAction(0, Keys['D'], true)
				DisableControlAction(2, 24, true) -- Attack
				DisableControlAction(2, 257, true) -- Attack 2
				DisableControlAction(2, 25, true) -- Aim
				DisableControlAction(2, 263, true) -- Melee Attack 1
				DisableControlAction(2, Keys['R'], true) -- Reload
				DisableControlAction(2, Keys['TOP'], true) -- Open phone (not needed?)
				DisableControlAction(2, Keys['SPACE'], true) -- Jump
				DisableControlAction(2, Keys['Q'], true) -- Cover
				DisableControlAction(2, Keys['~'], true) -- Handcuffs
				DisableControlAction(2, Keys['PAGEDOWN'], true) -- Crawling
				DisableControlAction(2, Keys['B'], true) -- Pointing
				DisableControlAction(2, Keys['TAB'], true) -- Select Weapon
				DisableControlAction(2, Keys['F'], true) -- Also 'enter'?
				DisableControlAction(2, Keys['F1'], true) -- Disable phone
				DisableControlAction(2, Keys['F2'], true) -- Inventory
				DisableControlAction(2, Keys['F3'], true) -- Animations
				DisableControlAction(2, Keys['V'], true) -- Disable changing view
				DisableControlAction(2, Keys['P'], true) -- Disable pause screen
				DisableControlAction(2, 59, true) -- Disable steering in vehicle
				DisableControlAction(2, Keys['LEFTCTRL'], true) -- Disable going stealth
				DisableControlAction(0, 47, true)  -- Disable weapon
				DisableControlAction(0, 264, true) -- Disable melee
				DisableControlAction(0, 257, true) -- Disable melee
				DisableControlAction(0, 140, true) -- Disable melee
				DisableControlAction(0, 141, true) -- Disable melee
				DisableControlAction(0, 142, true) -- Disable melee
				DisableControlAction(0, 143, true) -- Disable melee
				DisableControlAction(0, 75, true)  -- Disable exit vehicle
				DisableControlAction(27, 75, true) -- Disable exit vehicle

				local instructions = CreateInstuctionScaleform("instructional_buttons")
				DrawScaleformMovieFullscreen(instructions, 255, 255, 255, 255, 0)
				SetTimecycleModifier("scanline_cam_cheap")
				SetTimecycleModifierStrength(2.0)

				-- BACK/FORWARD CAMERA
				if IsControlJustPressed(0, Keys["LEFT"]) or IsControlJustPressed(0, Keys["RIGHT"]) then
					local newCamIndex = 1
					if IsControlJustPressed(0, Keys["LEFT"]) then
						if currentCameraIndex == 1 then
							newCamIndex = #currentCamera.cameras
						else
							newCamIndex = currentCameraIndex - 1
						end
					elseif currentCameraIndex ~= #currentCamera.cameras then
						newCamIndex = currentCameraIndex + 1
					end

					
					SetFocusArea(currentCamera.cameras[newCamIndex].x, currentCamera.cameras[newCamIndex].y, currentCamera.cameras[newCamIndex].z)
					ChangeSecurityCamera(currentCamera.cameras[newCamIndex].x, currentCamera.cameras[newCamIndex].y, currentCamera.cameras[newCamIndex].z, currentCamera.cameras[newCamIndex].r)
					currentCameraIndex = newCamIndex
				end

				if currentCamera.cameras[currentCameraIndex].canRotate then
					local rot = GetCamRot(createdCamera, 2)
					if IsControlPressed(1, Keys['N4']) then
						SetCamRot(createdCamera, rot.x, 0.0, rot.z + 0.7, 2)
					end

					if IsControlPressed(1, Keys['N6']) then
						SetCamRot(createdCamera, rot.x, 0.0, rot.z - 0.7, 2)
					end
				end

				-- CLOSE CAMERA
				if IsControlJustPressed(0, Keys["BACKSPACE"]) then
					CloseSecurityCamera()
					currentCamera = nil
					currentCameraIndex = 1

					TriggerEvent('esx_securitycam:freeze', false)
					CurrentAction = 'cameras'
				end
			end
			
			if sleep then
				Citizen.Wait(250)
			end
		else
			Citizen.Wait(2000)
		end
	end
end)

function _DrawText(x, y, width, height, scale, text, r, g, b, a)
	SetTextFont(4)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(2, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width / 2, y - height / 2 + 0.005)
end

function ChangeSecurityCamera(x, y, z, r)
    if createdCamera ~= 0 then
        DestroyCam(createdCamera, 0)
        createdCamera = 0
    end

    createdCamera = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(createdCamera, x, y, z)
    SetCamRot(createdCamera, r.x, r.y, r.z, 2)
    RenderScriptCams(1, 0, 0, 1, 1)
end

function CloseSecurityCamera()
	if createdCamera ~= 0 then
		DestroyCam(createdCamera, 0)
		createdCamera = 0
		RenderScriptCams(0, 0, 1, 1, 1)

		ClearTimecycleModifier("scanline_cam_cheap")
		SetFocusEntity(PlayerPedId())
	end
end

function CreateInstuctionScaleform(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
	
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    InstructionButton(GetControlInstructionalButton(0, Keys["RIGHT"], true))
    InstructionButtonMessage("Następna kamera")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    InstructionButton(GetControlInstructionalButton(0, Keys["LEFT"], true))
    InstructionButtonMessage("Poprzednia kamera")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
	InstructionButton(GetControlInstructionalButton(0, Keys["N6"], true))
    InstructionButtonMessage("Obróć kamerę")
    PopScaleformMovieFunctionVoid()

    --[[PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(3)
	InstructionButton(GetControlInstructionalButton(0, Keys["N4"], true))
    InstructionButtonMessage("")
    PopScaleformMovieFunctionVoid()]]

	PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(4)
    InstructionButton(GetControlInstructionalButton(0, Keys["BACKSPACE"], true))
    InstructionButtonMessage("Wyłącz monitoring")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

function InstructionButton(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end

function InstructionButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

RegisterNetEvent('esx_securitycam:freeze')
AddEventHandler('esx_securitycam:freeze', function(freeze)
	FreezeEntityPosition(PlayerPedId(), freeze)
	if freeze then
		ESX.UI.HUD.SetDisplay(0.0)
		TriggerEvent('chat:toggleChat', true)
		TriggerServerEvent('misiaczek:kino', true)
		TriggerEvent('hungerthirst:hud_state', true)
		TriggerEvent('bodycam:state', true)
		TriggerEvent('esx_status:setDisplay', 0.0)
		TriggerEvent('radar:setHidden', true)
		TriggerEvent('carhud:display', false)
		TriggerEvent('misiaczek:pasy', false)
		TriggerEvent('esx_customui:toggle', false)
	else
		ESX.UI.HUD.SetDisplay(1.0)
		TriggerEvent('chat:toggleChat', false)
		TriggerEvent('hungerthirst:hud_state', false)
		TriggerEvent('bodycam:state', false)
		TriggerEvent('esx_status:setDisplay', 1.0)
		TriggerEvent('radar:setHidden', false)
		TriggerEvent('carhud:display', true)
		TriggerEvent('misiaczek:pasy', true)
		TriggerEvent('esx_customui:toggle', true)
	end
end)

--[[function StartHideHUD()
	CreateThread(function()
		while blockbuttons do
			Citizen.Wait(100)
			ESX.UI.HUD.SetDisplay(0.0)
			TriggerEvent('chat:toggleChat', true)
			TriggerServerEvent('misiaczek:kino', true)
			TriggerEvent('hungerthirst:hud_state', true)
			TriggerEvent('bodycam:state', true)
			TriggerEvent('esx_status:setDisplay', 0.0)
			TriggerEvent('radar:setHidden', true)
			TriggerEvent('carhud:display', false)
			TriggerEvent('misiaczek:pasy', false)
			TriggerEvent('esx_customui:toggle', false)
		end
	end)
end

function StopHideHUD()
	CreateThread(function()
		while not blockbuttons do
			Citizen.Wait(100)
			ESX.UI.HUD.SetDisplay(1.0)
			TriggerEvent('chat:toggleChat', false)
			TriggerEvent('hungerthirst:hud_state', false)
			TriggerEvent('bodycam:state', false)
			TriggerEvent('esx_status:setDisplay', 1.0)
			TriggerEvent('radar:setHidden', false)
			TriggerEvent('carhud:display', true)
			TriggerEvent('misiaczek:pasy', true)
			TriggerEvent('esx_customui:toggle', true)
		end
	end)
end]]