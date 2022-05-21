Barabasz = {}
local onBed = false

Barabasz.Zones = {
	Pos = {
		{
			Coords = vector3(-254.45, 6334.11, 31.53),
			Name = 'Paleto'
		}, 
		
		{
			Coords = vector3(1135.99, -1557.21, 35.4-0.95),
			Name = 'Pillbox'
		},
		
		{
			Coords = vector3(1824.88, 3669.13, 33.32),
			Name = 'Sandy'
		},
	},
}

function DrawText3D(x, y, z, text, scale)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 255)
	SetTextOutline()

	AddTextComponentString(text)
	DrawText(_x, _y)

	local factor = (string.len(text)) / 270
	DrawRect(_x, _y + 0.015, 0.005 + factor, 0.03, 31, 31, 31, 155)
end

local timeLeft = nil
CreateThread(function()
	while true do
		Citizen.Wait(0)
		if timeLeft ~= nil then
			DrawText3D(playercoords.x, playercoords.y, playercoords.z + 0.1, timeLeft .. '~g~%', 0.4)
		else
			Citizen.Wait(500)
		end
	end
end)

function DrawProcent(time, cb)
	if cb ~= nil then
		CreateThread(function()
			timeLeft = 0
			repeat
				timeLeft = timeLeft + 1
				Citizen.Wait(time)
			until timeLeft == 100
			timeLeft = nil
			cb()
		end)
	else
		timeLeft = 0
		repeat
			timeLeft = timeLeft + 1
			Citizen.Wait(time)
		until timeLeft == 100
		timeLeft = nil
	end
end

RegisterNetEvent('Exile:BarabaszAnim')
AddEventHandler('Exile:BarabaszAnim', function(id, zone, bed)
	onBed = true

	DoScreenFadeOut(200)
	Citizen.Wait(1000)
	TriggerEvent('hypex_ambulancejob:hypexrevive')
	Citizen.Wait(1000)
	Citizen.InvokeNative(0x239A3351AC1DA385, playerPed, bed.Position, 0, 0, 0)
	SetEntityHeading(playerPed, bed.Position.w)

	ESX.Streaming.RequestAnimDict("missfbi5ig_0",function()
        Citizen.InvokeNative(0xEA47FE3719165B94, playerPed, "missfbi5ig_0", "lyinginpain_loop_steve", 8.0, 1.0, -1, 45, 1.0, 0, 0, 0)
	end)

	CreateThread(function()
        while onBed do
          	Citizen.Wait(0)
          	DisableControlAction(2, 199, true) -- Disable pause screen
			DisableControlAction(2, 200, true) -- Disable pause screen alternate
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 311, true) -- K
			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle
			DisableControlAction(0, 69, true) -- INPUT_VEH_ATTACK
			DisableControlAction(0, 92, true) -- INPUT_VEH_PASSENGER_ATTACK
			DisableControlAction(0, 114, true) -- INPUT_VEH_FLY_ATTACK
			DisableControlAction(0, 140, true) -- INPUT_MELEE_ATTACK_LIGHT
			DisableControlAction(0, 141, true) -- INPUT_MELEE_ATTACK_HEAVY
			DisableControlAction(0, 142, true) -- INPUT_MELEE_ATTACK_ALTERNATE
			DisableControlAction(0, 257, true) -- INPUT_ATTACK2
			DisableControlAction(0, 263, true) -- INPUT_MELEE_ATTACK1
			DisableControlAction(0, 264, true) -- INPUT_MELEE_ATTACK2
			DisableControlAction(0, 24, true) -- INPUT_ATTACK
			DisableControlAction(0, 25, true) -- INPUT_AIM
			DisableControlAction(0, 21, true) -- SHIFT
			DisableControlAction(0, 22, true) -- SPACE
			DisableControlAction(0, 288, true) -- F1
			DisableControlAction(0, 289, true) -- F2
			DisableControlAction(0, 170, true) -- F3
			DisableControlAction(0, 73, true) -- X
			DisableControlAction(0, 244, true) -- M
			DisableControlAction(0, 246, true) -- Y
			DisableControlAction(0, 74, true) -- H
			DisableControlAction(0, 29, true) -- B
			DisableControlAction(0, 243, true) -- ~
			DisableControlAction(0, 38, true) -- E
			DisableControlAction(0, 167, true) -- Job
			if not IsEntityPlayingAnim(playerPed, "missfbi5ig_0", "lyinginpain_loop_steve", 3) then
				Citizen.InvokeNative(0xEA47FE3719165B94, playerPed, "missfbi5ig_0", "lyinginpain_loop_steve", 8.0, 1.0, -1, 45, 1.0, 0, 0, 0)
			end
        end
    end)

	DoScreenFadeIn(200)

	DrawProcent(500, function()
		onBed = false

		DoScreenFadeOut(200)
		Citizen.Wait(500)
		Citizen.InvokeNative(0xAAA34F8A7CB32098, playerPed)
		Citizen.Wait(500)
		SetEntityCoords(playerPed, bed.GetUp)
		SetEntityHeading(playerPed, bed.GetUp.w)
		TriggerServerEvent('Exile:BarabaszUnoccupied', id, zone)
		Citizen.Wait(500)

		DoScreenFadeIn(200)
	end)
end)

CreateThread(function()
    while true do
		Citizen.Wait(3)
		local found = false
		for k,v in pairs(Barabasz.Zones) do
			for i=1, #v, 1 do
				local distance = #(playercoords - v[i].Coords)
				if distance < 6 then
					found = true
					ESX.DrawMarker(v[i].Coords)
					if distance < 1.5 then
						if not IsPedInAnyVehicle(playerPed, true) then
							ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~ aby uzyskać ~y~pomoc medyczną~s~')
							if IsControlJustPressed(0, 46) or IsDisabledControlJustPressed(0, 46) and not onBed then
								if GetEntityHealth(playerPed) < 200 or exports["esx_ambulancejob"]:isDead() then
									ESX.TriggerServerCallback("esx_scoreboard:getConnectedCops", function(MisiaczekPlayers)
										if MisiaczekPlayers then
											if MisiaczekPlayers['ambulance'] < 4 then
												PayMenu(MisiaczekPlayers['ambulance'], v[i].Name)
											else
												ESX.ShowNotification('Nie możesz skorzystać z ~r~pomocy medycznej~w~ ponieważ na służbie jest już ~y~' .. MisiaczekPlayers['ambulance'] .. ' medyków')
											end
										end
									end)
								else
									ESX.ShowNotification('~r~Nie potrzebujesz~w~ pomocy medycznej!')
								end
							end
						end
					end
				end
			end
		end

		if not found then
			Citizen.Wait(1000)
		end
    end
end)

function PayMenu(a,b)
    local elements = {
        { label = 'Zapłać gotówką', value = 'money' },
        { label = 'Zapłać kartą', value = 'bank' },
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'paymenu',
    {
        title    = 'Wybierz sposób płatności',
        align    = 'center',
        elements = elements
    }, function(data, menu)
        if data.current.value ~= nil then
            TriggerServerEvent('Exile:Barabasz', a,b,data.current.value)
        end
    end, function(data, menu)
        menu.close()
    end)

end