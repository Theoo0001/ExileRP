garages = { 
	--{ label = "Los Santos Customs", sprite = "shopui_title_carmod2", hidden = true, locked = false, camera = {x = 818.6667, y = -889.3673, z = 24.3008, heading = 225.63}, driveOut = {x = 823.8687,y = -894.2131, z = 24.3011, heading = 88.52}, driveIn = {x = 823.8687,y = -894.2131, z = 24.3011, heading = 88.52}, outside = {x = 823.8687,y = -894.2131, z = 24.3011, heading = 88.52}, inside = {x = 823.8687,y = -894.2131, z = 24.3011, heading = 88.52}},
	--{ label = "Los Santos Customs", sprite = "shopui_title_carmod2", locked = false, camera = {x = 962.5572, y = -105.7563, z = 73.4893, heading = 222.52}, driveOut = {x = 966.338, y = -109.4791, z = 73.4893, heading = 225.52}, driveIn = {x = 967.2497,y = -110.5007, z = 73.4893, heading = 43.33}, outside = {x = 969.3383, y = -112.9241, z = 73.4034, heading = 351.579}, inside = {x = 964.9035,y = -109.0822, z = 73.4893, heading = 45.12}},
}

local currentLock = 0
local hasRequestedLock = false
local firstSpawn = false
local wasInvincible = false

AddEventHandler('playerSpawned', function(spawn)
	if not firstSpawn then
		TriggerServerEvent('LSC:garages')
		firstSpawn = true
	end
end)

RegisterNetEvent('LSC:lock')
AddEventHandler('LSC:lock', function(data, mecano)
	--for i, garage in ipasirs(data) do

		--garages[i].locked = garage.locked
	--end

	fullMecanoConnected = mecano
	
	hasRequestedLock = false
end)

function StartFade()
	CreateThread(function()
		DoScreenFadeOut(0)
		while IsScreenFadingOut() do
			Citizen.Wait(0)
		end
	end)
end

function EndFade()
	CreateThread(function()
		ShutdownLoadingScreen()

        DoScreenFadeIn(3000)
        while IsScreenFadingIn() do
            Citizen.Wait(0)
        end
	end)
end

CreateThread(function()
		if LSC:isVisible() then
			if HasScaleformMovieLoaded(instructionalButtons) then
				DrawScaleformMovie(instructionalButtons, 0.5, 0.5, 1.0, 1.0, 255, 255, 255, 255)
			end

			if (IsDisabledControlJustPressed(1, 0) or IsControlJustPressed(1, 0)) and cam and IsCamActive(cam) then -- [V]
				SetCamCoord(cam, GetGameplayCamCoords())
				SetCamRot(cam, GetGameplayCamRot(2), 2)

				RenderScriptCams(1, 1, 0, 0, 0)
				RenderScriptCams(0, 1, 1000, 0, 0)

				SetCamActive(gameplayCamera, true)
				EnableGameplayCam(true)
				SetCamActive(cam, false)

				SetInstructionalButtons({
					{GetControlInstructionalButton(1, LSC.config.controls.menu_back, 0), "Wstecz"},
					{GetControlInstructionalButton(1, LSC.config.controls.menu_select, 0), "Wybierz"},
					{GetControlInstructionalButton(1, LSC.config.controls.menu_up, 0), "Do góry"},
					{GetControlInstructionalButton(1, LSC.config.controls.menu_down, 0), "W dół"},
					{GetControlInstructionalButton(1, LSC.config.controls.menu_left, 0), "W lewo"},
					{GetControlInstructionalButton(1, LSC.config.controls.menu_right, 0), "W prawo"}
				 }, 0)
			end
		end
	--end
end)