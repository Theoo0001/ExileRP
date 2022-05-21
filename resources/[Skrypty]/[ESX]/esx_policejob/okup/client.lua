local Walizki = {}
local Walizka = nil

RegisterNetEvent('esx_policejob:spawnWalizka')
AddEventHandler('esx_policejob:spawnWalizka', function(waliza)
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	local forward   = GetEntityForwardVector(playerPed)
	local x, y, z   = table.unpack(coords + forward * 1.0)
	
	ESX.ShowNotification('~y~Rozstawiłeś walizkę z okupem.')
	ESX.Game.SpawnObject('prop_cash_case_02', { x = x, y = y, z = z }, function(obj)
		SetEntityHeading(obj, GetEntityHeading(playerPed) + 180)
		PlaceObjectOnGroundProperly(obj)

		x, y, z = table.unpack(GetEntityCoords(obj))
		TriggerServerEvent('esx_policejob:spawnWalizka', waliza, { x = x, y = y, z = z })
	end)
end)

RegisterNetEvent('esx_policejob:spawnedWalizka')
AddEventHandler('esx_policejob:spawnedWalizka', function(waliza, coords, amount)
	table.insert(Walizki, {id = waliza, coords = coords, amount = amount})
end)

RegisterNetEvent('esx_policejob:despawnWalizka')
AddEventHandler('esx_policejob:despawnWalizka', function(walizka)
	for i, waliza in ipairs(Walizki) do
		if waliza.id == walizka then
			local object = GetClosestObjectOfType(waliza.coords.x, waliza.coords.y, waliza.coords.z, 3.0, `prop_cash_case_02`, false, false, false)
			if DoesEntityExist(object) then
				DeleteObject(object)
			end

			table.remove(Walizki, i)
			break
		end
	end
end)

function DrawText3Ds(x, y, z, text)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = #(vec3(px, py, pz) - vec3(x, y, z))

    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    
    SetTextScale(0.4, 0.4)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextCentre(1)

    SetTextEntry("STRING")
    AddTextComponentString(text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    DrawText(_x,_y)

	local factor = text:len() / 250
	DrawRect(_x, _y + 0.0125, 0.005 + factor, 0.03, 41, 11, 41, 68)
end

CreateThread(function()
	while true do
		Citizen.Wait(2)
		if PlayerData.job ~= nil and PlayerData.job.name ~= 'police' and PlayerData.job.name ~= 'offpolice' and PlayerData.job.name ~= 'ambulance' and PlayerData.job.name ~= 'offambulance' and PlayerData.job.name ~= 'mecano' then
			local ped = PlayerPedId()

			local coords, sleep = GetEntityCoords(ped), true
			for i, waliza in ipairs(Walizki) do
				local objectDistance = #(coords - vec3(waliza.coords.x, waliza.coords.y, waliza.coords.z))
				if objectDistance < 5.0 then
					sleep = false
					DrawText3Ds(waliza.coords.x, waliza.coords.y, waliza.coords.z + 0.2, "Naciśnij [E] aby podnieść okup")
					if objectDistance < 1.3 and IsControlJustPressed(0, 38) then
						local PlayerData = ESX.GetPlayerData
						ESX.TriggerServerCallback('esx_policejob:tryWalizka', function(allow)
							if allow then
								RequestAnimDict("amb@prop_human_bum_bin@idle_b")
								while not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b") do
									Citizen.Wait(0)
								end

								local pid = PlayerPedId()
								TaskPlayAnim(pid, "amb@prop_human_bum_bin@idle_b", "idle_d", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
								Citizen.Wait(2000)
								StopAnimTask(pid, "amb@prop_human_bum_bin@idle_b", "idle_d", 1.0)

								ESX.ShowNotification("~o~Podniosłeś walizkę. Otworzysz ją za 60 sekund.")							
								TriggerServerEvent('esx_policejob:grabWalizka', waliza.id)

								Walizka = {obj = CreateObject(`prop_security_case_01`, 0, 0, 0, true, true, true), timer = 60, id = waliza.id, amount = waliza.amount}
								AttachEntityToEntity(Walizka.obj, ped, GetPedBoneIndex(ped, 57005), 0.12, 0, -0.02, 0, 270.0, 60.0, true, true, false, true, 1, true)
							end
						end, waliza.id)
					end
				end
			end
			if sleep then
				Citizen.Wait(666)
			end
		else
			Citizen.Wait(666)
		end
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(2)
		if Walizka then
			while Walizka.timer > 0 do
				Citizen.Wait(1000)
				Walizka.timer = Walizka.timer - 1
			end

			TriggerServerEvent('esx_policejob:openWalizka', Walizka.id)
			DeleteObject(Walizka.obj)
			Walizka = nil
		else
			Citizen.Wait(666)
		end
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(2)
		if Walizka and Walizka.timer > 0 then
			SetTextFont(4)
			SetTextProportional(1)
			SetTextScale(0.45, 0.45)
			SetTextColour(255, 255, 255, 255)
			SetTextDropShadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()

			SetTextEntry('STRING')
			AddTextComponentString("Otworzysz walizkę ($" .. Walizka.amount .. " brudnej gotówki) za: " .. math.floor(Walizka.timer))
			DrawText(table.unpack({ 0.175, 0.955 }))
			SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)
		else
			Citizen.Wait(666)
		end
	end
end)
