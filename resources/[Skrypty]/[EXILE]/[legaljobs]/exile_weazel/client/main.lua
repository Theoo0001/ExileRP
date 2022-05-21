local holdingCam = false
local holdingMic = false
local holdingBmic = false
local camModel = `prop_v_cam_01`
local camanimDict = "missfinale_c2mcs_1"
local camanimName = "fin_c2_mcs_1_camman"
local micModel = `p_ing_microphonel_01`
local micanimDict = "missheistdocksprep1hold_cellphone"
local micanimName = "hold_cellphone"
local bmicModel = `prop_v_bmike_01`
local bmicanimDict = "missfra1"
local bmicanimName = "mcs2_crew_idle_m_boom"
local bmic_net = nil
local mic_net = nil
local cam_net = nil
local UI = { 
	x =  0.000 ,
	y = -0.001 ,
}

---------------------------------------------------------------------------
-- Toggling Cam --
---------------------------------------------------------------------------
RegisterNetEvent("Cam:ToggleCam")
AddEventHandler("Cam:ToggleCam", function()
    if not holdingCam then
        RequestModel(camModel)
        while not HasModelLoaded(camModel) do
            Citizen.Wait(0)
        end
		
        local plyCoords = GetOffsetFromEntityInWorldCoords(Citizen.InvokeNative(0x43A66C31C68491C0, PlayerId()), 0.0, 0.0, -5.0)
        local camspawned = CreateObject(camModel, plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
        Citizen.Wait(1000)
        local netid = ObjToNet(camspawned)
        SetNetworkIdExistsOnAllMachines(netid, true)
        NetworkSetNetworkIdDynamic(netid, true)
        SetNetworkIdCanMigrate(netid, false)
        AttachEntityToEntity(camspawned, Citizen.InvokeNative(0x43A66C31C68491C0, PlayerId()), GetPedBoneIndex(Citizen.InvokeNative(0x43A66C31C68491C0, PlayerId()), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
		SetModelAsNoLongerNeeded(camModel)
        TaskPlayAnim(Citizen.InvokeNative(0x43A66C31C68491C0, PlayerId()), 1.0, -1, -1, 50, 0, 0, 0, 0) -- 50 = 32 + 16 + 2
        TaskPlayAnim(Citizen.InvokeNative(0x43A66C31C68491C0, PlayerId()), camanimDict, camanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)
        cam_net = netid
        holdingCam = true
		DisplayNotification("~INPUT_PICKUP~ - tryb wydarzeń\n~INPUT_INTERACTION_MENU~ - tryb filmowy")
    else
        ClearPedSecondaryTask(Citizen.InvokeNative(0x43A66C31C68491C0, PlayerId()))
        DetachEntity(NetToObj(cam_net), 1, 1)
        DeleteEntity(NetToObj(cam_net))
        cam_net = nil
        holdingCam = false
    end
end)

CreateThread(function()
	while true do
		Citizen.Wait(0)
		if holdingCam then
			RequestAnimDict(camanimDict)
			while not HasAnimDictLoaded(camanimDict) do
				Citizen.Wait(0)
			end

			if not IsEntityPlayingAnim(PlayerPedId(), camanimDict, camanimName, 3) then
				TaskPlayAnim(Citizen.InvokeNative(0x43A66C31C68491C0, PlayerId()), 1.0, -1, -1, 50, 0, 0, 0, 0) -- 50 = 32 + 16 + 2
				TaskPlayAnim(Citizen.InvokeNative(0x43A66C31C68491C0, PlayerId()), camanimDict, camanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)
			end
				
			DisablePlayerFiring(PlayerId(), true)
			DisableControlAction(0,25,true) -- disable aim
			DisableControlAction(0, 44,  true) -- INPUT_COVER
			DisableControlAction(0,37,true) -- INPUT_SELECT_WEAPON
			SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)
		else
			Citizen.Wait(1000)
		end
	end
end)

---------------------------------------------------------------------------
-- Cam Functions --
---------------------------------------------------------------------------

local fov_max = 70.0
local fov_min = 5.0
local zoomspeed = 10.0
local speed_lr = 8.0
local speed_ud = 8.0
local fov = (fov_max+fov_min)*0.5

---------------------------------------------------------------------------
-- Movie Cam --
---------------------------------------------------------------------------

CreateThread(function()
	while true do
		Citizen.Wait(0)
		if holdingCam then
			if IsControlJustReleased(1, 244) then
				local lPed = PlayerPedId()
				local vehicle = GetVehiclePedIsIn(lPed, false)

				movcamera = true
				SetTimecycleModifier("default")
				SetTimecycleModifierStrength(0.3)
				
				local scaleform = RequestScaleformMovie("security_camera")
				while not HasScaleformMovieLoaded(scaleform) do
					Citizen.Wait(0)
				end

				DisplayNotification("~INPUT_CELLPHONE_CANCEL~ - wyłącz nagrywanie")
				ESX.UI.HUD.SetDisplay(0.0)
				TriggerEvent('es:setMoneyDisplay', 0.0)
				TriggerEvent('esx_status:setDisplay', 0.0)
				TriggerEvent('esx_voice:setDisplay', 0.0)
				TriggerEvent('radar:setHidden', true)
				TriggerEvent('chat:display', false)
				TriggerEvent('carhud:display', false)
				TriggerEvent('exile_dzwon:display', false)
				TriggerEvent('FeedM:halt', true)

				local lPed = PlayerPedId()
				local vehicle = GetVehiclePedIsIn(lPed, false)
				local cam1 = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)

				AttachCamToEntity(cam1, lPed, 0.0,0.0,1.0, true)
				SetCamRot(cam1, 2.0,1.0,GetEntityHeading(lPed))
				SetCamFov(cam1, fov)
				RenderScriptCams(true, false, 0, 1, 0)
				PushScaleformMovieFunction(scaleform, "security_camera")
				PopScaleformMovieFunctionVoid()

				while movcamera and not DecorExistOn(lPed, 'injured') and (GetVehiclePedIsIn(lPed, false) == vehicle) and true do
					if IsControlJustPressed(0, 177) then
						PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
						movcamera = false
					end
					
					SetEntityRotation(lPed, 0, 0, new_z,2, true)

					local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
					CheckInputRotation(cam1, zoomvalue)
					HandleZoom(cam1)

					drawRct(UI.x + 0.0, 	UI.y + 0.0, 1.0,0.15,0,0,0,255) -- Top Bar
					DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
					drawRct(UI.x + 0.0, 	UI.y + 0.85, 1.0,0.16,0,0,0,255) -- Bottom Bar
					
					local camHeading = GetGameplayCamRelativeHeading()
					local camPitch = GetGameplayCamRelativePitch()
					if camPitch < -70.0 then
						camPitch = -70.0
					elseif camPitch > 42.0 then
						camPitch = 42.0
					end
					camPitch = (camPitch + 70.0) / 112.0
					
					if camHeading < -180.0 then
						camHeading = -180.0
					elseif camHeading > 180.0 then
						camHeading = 180.0
					end
					camHeading = (camHeading + 180.0) / 360.0
					
					Citizen.InvokeNative(0xD5BB4025AE449A4E, PlayerPedId(), "Pitch", camPitch)
					Citizen.InvokeNative(0xD5BB4025AE449A4E, PlayerPedId(), "Heading", camHeading * -1.0 + 1.0)
					
					Citizen.Wait(0)
				end

				movcamera = false
				ClearTimecycleModifier()
				fov = (fov_max+fov_min)*0.5
				RenderScriptCams(false, false, 0, 1, 0)
				SetScaleformMovieAsNoLongerNeeded(scaleform)
				DestroyCam(cam1, false)
				SetNightvision(false)
				SetSeethrough(false)

				ESX.UI.HUD.SetDisplay(1.0)
				TriggerEvent('es:setMoneyDisplay', 1.0)
				TriggerEvent('esx_status:setDisplay', 1.0)
				TriggerEvent('esx_voice:setDisplay', 1.0)
				TriggerEvent('radar:setHidden', false)
				TriggerEvent('chat:display', true)
				TriggerEvent('carhud:display', true)
				TriggerEvent('exile_dzwon:display', true)
				TriggerEvent('FeedM:halt', false)

				DisplayNotification("~INPUT_PICKUP~ - tryb wydarzeń\n~INPUT_INTERACTION_MENU~ - tryb filmowy")
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

---------------------------------------------------------------------------
-- News Cam --
---------------------------------------------------------------------------

CreateThread(function()
	while true do
		Citizen.Wait(0)
		if holdingCam then
			if IsControlJustReleased(1, 38) then
				local lPed = PlayerPedId()
				local vehicle = GetVehiclePedIsIn(lPed, false)

				newscamera = true
				SetTimecycleModifier("default")
				SetTimecycleModifierStrength(0.3)
				
				local scaleform = RequestScaleformMovie("security_camera")
				while not HasScaleformMovieLoaded(scaleform) do
					Citizen.Wait(0)
				end

				local scaleform2 = RequestScaleformMovie("breaking_news")
				while not HasScaleformMovieLoaded(scaleform2) do
					Citizen.Wait(0)
				end

				DisplayNotification("~INPUT_CELLPHONE_CANCEL~ - wyłącz nagrywanie")
				ESX.UI.HUD.SetDisplay(0.0)
				TriggerEvent('es:setMoneyDisplay', 0.0)
				TriggerEvent('esx_status:setDisplay', 0.0)
				TriggerEvent('esx_voice:setDisplay', 0.0)
				TriggerEvent('radar:setHidden', true)
				TriggerEvent('chat:display', false)
				TriggerEvent('carhud:display', false)
				TriggerEvent('exile_dzwon:display', false)
				TriggerEvent('FeedM:halt', true)

				local lPed = PlayerPedId()
				local vehicle = GetVehiclePedIsIn(lPed, false)
				local cam2 = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)

				AttachCamToEntity(cam2, lPed, 0.0,0.0,1.0, true)
				SetCamRot(cam2, 2.0,1.0,GetEntityHeading(lPed))
				SetCamFov(cam2, fov)
				RenderScriptCams(true, false, 0, 1, 0)
				PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
				PushScaleformMovieFunction(scaleform2, "breaking_news")
				PopScaleformMovieFunctionVoid()

				while newscamera and not DecorExistOn(lPed, 'injured') and (GetVehiclePedIsIn(lPed, false) == vehicle) and true do
					if IsControlJustPressed(1, 177) then
						PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
						newscamera = false
					end

					SetEntityRotation(lPed, 0, 0, new_z,2, true)
						
					local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
					CheckInputRotation(cam2, zoomvalue)
					HandleZoom(cam2)

					DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
					DrawScaleformMovie(scaleform2, 0.5, 0.63, 1.0, 1.0, 255, 255, 255, 255)
					Breaking("BREAKING NEWS")
					
					local camHeading = GetGameplayCamRelativeHeading()
					local camPitch = GetGameplayCamRelativePitch()
					if camPitch < -70.0 then
						camPitch = -70.0
					elseif camPitch > 42.0 then
						camPitch = 42.0
					end
					camPitch = (camPitch + 70.0) / 112.0
					
					if camHeading < -180.0 then
						camHeading = -180.0
					elseif camHeading > 180.0 then
						camHeading = 180.0
					end
					camHeading = (camHeading + 180.0) / 360.0
					
					Citizen.InvokeNative(0xD5BB4025AE449A4E, PlayerPedId(), "Pitch", camPitch)
					Citizen.InvokeNative(0xD5BB4025AE449A4E, PlayerPedId(), "Heading", camHeading * -1.0 + 1.0)
					
					Citizen.Wait(0)
				end

				newscamera = false
				ClearTimecycleModifier()
				fov = (fov_max+fov_min)*0.5
				RenderScriptCams(false, false, 0, 1, 0)
				SetScaleformMovieAsNoLongerNeeded(scaleform)
				DestroyCam(cam2, false)
				SetNightvision(false)
				SetSeethrough(false)

				ESX.UI.HUD.SetDisplay(1.0)
				TriggerEvent('es:setMoneyDisplay', 1.0)
				TriggerEvent('esx_status:setDisplay', 1.0)
				TriggerEvent('esx_voice:setDisplay', 1.0)
				TriggerEvent('radar:setHidden', false)
				TriggerEvent('chat:display', true)
				TriggerEvent('carhud:display', true)
				TriggerEvent('exile_dzwon:display', true)
				TriggerEvent('FeedM:halt', false)

				DisplayNotification("~INPUT_PICKUP~ - tryb wydarzeń\n~INPUT_INTERACTION_MENU~ - tryb filmowy")
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

---------------------------------------------------------------------------
-- Events --
---------------------------------------------------------------------------

--FUNCTIONS--
function CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX*-1.0*(speed_ud)*(zoomvalue+0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(speed_lr)*(zoomvalue+0.1)), -89.5)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

function HandleZoom(cam)
	local lPed = PlayerPedId()
	if not ( IsPedSittingInAnyVehicle( lPed ) ) then

		if IsControlJustPressed(0,241) then
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsControlJustPressed(0,242) then
			fov = math.min(fov + zoomspeed, fov_max)
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
	else
		if IsControlJustPressed(0,17) then
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsControlJustPressed(0,16) then
			fov = math.min(fov + zoomspeed, fov_max)
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
	end
end


---------------------------------------------------------------------------
-- Toggling Mic --
---------------------------------------------------------------------------
RegisterNetEvent("Mic:ToggleMic")
AddEventHandler("Mic:ToggleMic", function()
    if not holdingMic then
        RequestModel(micModel)
        while not HasModelLoaded(micModel) do
            Citizen.Wait(0)
        end

		RequestAnimDict(micanimDict)
		while not HasAnimDictLoaded(micanimDict) do
			Citizen.Wait(0)
		end

        local plyCoords = GetOffsetFromEntityInWorldCoords(Citizen.InvokeNative(0x43A66C31C68491C0, PlayerId()), 0.0, 0.0, -5.0)
        local micspawned = CreateObject(micModel, plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
        Citizen.Wait(1000)
        local netid = ObjToNet(micspawned)
        SetNetworkIdExistsOnAllMachines(netid, true)
        NetworkSetNetworkIdDynamic(netid, true)
        SetNetworkIdCanMigrate(netid, false)
        AttachEntityToEntity(micspawned, Citizen.InvokeNative(0x43A66C31C68491C0, PlayerId()), GetPedBoneIndex(Citizen.InvokeNative(0x43A66C31C68491C0, PlayerId()), 60309), 0.055, 0.05, 0.0, 240.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
		SetModelAsNoLongerNeeded(micModel)
        TaskPlayAnim(Citizen.InvokeNative(0x43A66C31C68491C0, PlayerId()), 1.0, -1, -1, 50, 0, 0, 0, 0) -- 50 = 32 + 16 + 2
        TaskPlayAnim(Citizen.InvokeNative(0x43A66C31C68491C0, PlayerId()), micanimDict, micanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)
        mic_net = netid
        holdingMic = true
    else
        ClearPedSecondaryTask(Citizen.InvokeNative(0x43A66C31C68491C0, PlayerId()))
        DetachEntity(NetToObj(mic_net), 1, 1)
        DeleteEntity(NetToObj(mic_net))
        mic_net = nil
        holdingMic = false
    end
end)

---------------------------------------------------------------------------
-- Toggling Boom Mic --
---------------------------------------------------------------------------
RegisterNetEvent("Mic:ToggleBMic")
AddEventHandler("Mic:ToggleBMic", function()
    if not holdingBmic then
        RequestModel(bmicModel)
        while not HasModelLoaded(bmicModel) do
            Citizen.Wait(0)
        end
		
        local plyCoords = GetOffsetFromEntityInWorldCoords(Citizen.InvokeNative(0x43A66C31C68491C0, PlayerId()), 0.0, 0.0, -5.0)
        local bmicspawned = CreateObject(bmicModel, plyCoords.x, plyCoords.y, plyCoords.z, true, true, false)
        Citizen.Wait(1000)
        local netid = ObjToNet(bmicspawned)
        SetNetworkIdExistsOnAllMachines(netid, true)
        NetworkSetNetworkIdDynamic(netid, true)
        SetNetworkIdCanMigrate(netid, false)
        AttachEntityToEntity(bmicspawned, Citizen.InvokeNative(0x43A66C31C68491C0, PlayerId()), GetPedBoneIndex(Citizen.InvokeNative(0x43A66C31C68491C0, PlayerId()), 28422), -0.08, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
		SetModelAsNoLongerNeeded(bmicModel)
        TaskPlayAnim(Citizen.InvokeNative(0x43A66C31C68491C0, PlayerId()), 1.0, -1, -1, 50, 0, 0, 0, 0) -- 50 = 32 + 16 + 2
        TaskPlayAnim(Citizen.InvokeNative(0x43A66C31C68491C0, PlayerId()), bmicanimDict, bmicanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)
        bmic_net = netid
        holdingBmic = true
    else
        ClearPedSecondaryTask(Citizen.InvokeNative(0x43A66C31C68491C0, PlayerId()))
        DetachEntity(NetToObj(bmic_net), 1, 1)
        DeleteEntity(NetToObj(bmic_net))
        bmic_net = nil
        holdingBmic = false
    end
end)

CreateThread(function()
	while true do
		Citizen.Wait(0)
		if holdingBmic then
			RequestAnimDict(bmicanimDict)
			while not HasAnimDictLoaded(bmicanimDict) do
				Citizen.Wait(0)
			end

			local ped = PlayerPedId()
			if not IsEntityPlayingAnim(ped, bmicanimDict, bmicanimName, 3) then
				TaskPlayAnim(ped, 1.0, -1, -1, 50, 0, 0, 0, 0) -- 50 = 32 + 16 + 2
				TaskPlayAnim(ped, bmicanimDict, bmicanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)
			end
			
			DisablePlayerFiring(PlayerId(), true)
			DisableControlAction(0,25,true) -- disable aim
			DisableControlAction(0, 44,  true) -- INPUT_COVER
			DisableControlAction(0,37,true) -- INPUT_SELECT_WEAPON
			SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
			
			if IsPedInAnyVehicle(ped, false) or exports['esx_policejob']:getStatus(true, true, true) then
				local id
				if holdingBmic then
					id = bmic_net
					bmic_net = nil
					holdingBmic = false
				elseif holdingCam then
					id = cam_net
					cam_net = nil
					holdingCam = false
				elseif holdingMic then
					id = mic_net
					mic_net = nil
					holdingMic = false
				end

				if id then
					ClearPedSecondaryTask(ped)
					DetachEntity(NetToObj(id), 1, 1)
					DeleteEntity(NetToObj(id))
				end
			end
		end
	end
end)

---------------------------------------------------------------------------------------
-- misc functions --
---------------------------------------------------------------------------------------

function drawRct(x,y,width,height,r,g,b,a)
	DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end

function Breaking(text)
		SetTextColour(255, 255, 255, 255)
		SetTextFont(8)
		SetTextScale(1.2, 1.2)
		SetTextWrap(0.0, 1.0)
		SetTextCentre(false)
		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextEdge(1, 0, 0, 0, 205)
		SetTextEntry("STRING")
		AddTextComponentString(text)
		DrawText(0.2, 0.85)
end

function DisplayNotification(string)
	SetTextComponentFormat("STRING")
	AddTextComponentString(string)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end