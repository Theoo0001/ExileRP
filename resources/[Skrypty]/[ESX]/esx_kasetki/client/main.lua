local holdingUp = false
local store = ""
local blipRobbery = nil
ESX = nil
local PlayerData                = {}
local dualjob = nil

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
	while ESX == nil do
		TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) 
			ESX = obj 
		end)
		
		Citizen.Wait(250)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.37, 0.37)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 33, 33, 33, 133)
end

RegisterNetEvent('esx_kasetki:currentlyRobbing')
AddEventHandler('esx_kasetki:currentlyRobbing', function(currentStore)
	holdingUp, store = true, currentStore
	ESX.ShowAdvancedNotification('~b~~h~ROZPOCZYNASZ RABUNEK', 'Uważaj na policje!', 'Opróżnij kasetkę do końca, wynegocjuj odjazd i uciekaj jak najszybciej!')
end)

RegisterNetEvent('esx_kasetki:killBlip')
AddEventHandler('esx_kasetki:killBlip', function()
	if blipRobbery ~= nil then
		RemoveBlip(blipRobbery)
	end
end)

RegisterNetEvent('esx_kasetki:setBlip')
AddEventHandler('esx_kasetki:setBlip', function(position, alert)
	blipRobbery = AddBlipForCoord(position.x, position.y, position.z)
	SetBlipSprite(blipRobbery, 161)
	SetBlipScale(blipRobbery, 2.0)
	SetBlipColour(blipRobbery, 3)
	PulseBlip(blipRobbery)
    BeginTextCommandSetBlipName("STRING")
	EndTextCommandSetBlipName(blipRobbery)
	PlaySoundFrontend(-1, "ASSASSINATIONS_HOTEL_TIMER_COUNTDOWN", "ASSASSINATION_MULTI", 1)
	TriggerEvent('chat:addMessage1',"^0[^3Centrala^0]", {0, 0, 0}, alert, "fas fa-laptop")
end)

RegisterNetEvent('esx_kasetki:tooFar')
AddEventHandler('esx_kasetki:tooFar', function()
	holdingUp, store = false, ''
	exports["esx_exilechat"]:cancelProgress()
	ESX.ShowNotification(_U('robbery_cancelled'))
end)

RegisterNetEvent('esx_kasetki:robberyComplete')
AddEventHandler('esx_kasetki:robberyComplete', function(award)
	holdingUp, store = false, ''
	Citizen.InvokeNative(0xAAA34F8A7CB32098, PlayerPedId())
	ESX.ShowAdvancedNotification('~b~~h~OBRABOWANIE UDANE!', 'Z kasetki zdobyto:', award)
end)

RegisterNetEvent('esx_kasetki:animation')
AddEventHandler('esx_kasetki:animation', function(code)
	local ped = PlayerPedId()
	ClearPedTasks(ped)

	local dict = "oddjobs@shop_robbery@rob_till"
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(10)
	end
	
	TaskPlayAnim(PlayerPedId(), dict, "loop", 1.0, -8.0, 200000, 1, 1, true, false, true)
end)

RegisterNetEvent('esx_kasetki:startTimer')
AddEventHandler('esx_kasetki:startTimer', function(timer)
	CreateThread(function()
		exports["esx_exilechat"]:showProgress("notification_important", "top", "Rabowanie...", "Rozpoczęto napad", "grey-10", timer, true)
		while timer > 0 and holdingUp do
			Citizen.Wait(1000)

			if timer > 0 then
				timer = timer - 1
			end
		end
	end)

	CreateThread(function()
		while holdingUp do
			Citizen.Wait(2)
			DisableControlAction(0, Keys['F1'], true)
			DisableControlAction(0, Keys['G'], true)
			DisableControlAction(0, Keys['X'], true)
			DisableControlAction(0, Keys['F3'], true)
			DisableControlAction(0, Keys['K'], true)
			DisableControlAction(0, Keys['TAB'], true)
			DisableControlAction(0, Keys['1'], true)
			DisableControlAction(0, Keys['2'], true)
			DisableControlAction(0, Keys['3'], true)
			DisableControlAction(0, Keys['4'], true)
			DisableControlAction(0, Keys['5'], true)
			DisableControlAction(0, Keys['6'], true)
			DisableControlAction(0, Keys['7'], true)
			DisableControlAction(0, Keys['8'], true)
			DisableControlAction(0, Keys['9'], true)
		end
	end)
end)

CreateThread(function()
	while true do
		Citizen.Wait(1)
		local playerPos, sleep = GetEntityCoords(PlayerPedId(), true), true

		for k,v in pairs(Stores) do
			local storePos = v.position
			local distance = #(playerPos - vec3(storePos.x, storePos.y, storePos.z))

			if distance < 10 then
				sleep = false
				if not holdingUp then
					
					if distance < 2 then
						DrawText3D(storePos.x, storePos.y, storePos.z,"~b~ NAPAD NA ~s~[~b~"..v.name.."~s~]")
					end
					
					if distance < 1.25 then
						ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~ aby rozpocząć ~r~obrabowywanie kasetki~s~')
						if IsControlJustReleased(0, Keys['E']) then
							if IsPedArmed(PlayerPedId(), 4) then
								TriggerServerEvent('esx_kasetki:robberyStarted', k)
								PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0)
							else
								ESX.ShowNotification(_U('no_threat'))
							end
						end
					end
					
				end
			end
		end

		if holdingUp then
			local storePos = Stores[store].position
			local taki = Stores[store].name
			if Vdist(playerPos.x, playerPos.y, playerPos.z, storePos.x, storePos.y, storePos.z) > Config.MaxDistance then
				sleep = false
				TriggerServerEvent('esx_kasetki:tooFar', store)
				Citizen.Wait(1000)
			end
		end
		
		if sleep then
			Citizen.Wait(500)
		end
	end
end)
