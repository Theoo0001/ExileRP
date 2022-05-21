ESX                           = nil
local PlayerData              = {}
local notification = "Naciśnij ~INPUT_CONTEXT~ aby przejść"
local ped = PlayerPedId()
local pCoords = GetEntityCoords(ped)

CreateThread(function ()
    while ESX == nil do
        TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)
        Wait(10)
    end
    while ESX.GetPlayerData() == nil do
        Wait(10)
    end
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
	RequestIpl("vespucci_museum_milo_")
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('esx:setHiddenJob')
AddEventHandler('esx:setHiddenJob', function(hiddenjob)
    PlayerData.hiddenjob = hiddenjob
end)

CreateThread(function()
	while true do
		ped = PlayerPedId()
		pCoords = GetEntityCoords(ped)
		Wait(500)
	end
end)

local licenses = {
	'opium_transform',
	'exctasy_transform',
	'weapon'
}

local ownedLicenses = {}

CreateThread(function()
	while true do
		for i=1, #licenses, 1 do
			ESX.TriggerServerCallback('esx_license:checkLicense', function(hasLicense)
				if hasLicense then
					ownedLicenses[licenses[i]] = true
				else
					ownedLicenses[licenses[i]] = false
				end
			end, GetPlayerServerId(PlayerId()), licenses[i])
		end
		Wait(2 * 60 * 1000)
	end
end)

CreateThread(function()
	while PlayerData.job == nil do
		Wait(100)
	end
	while true do
		Wait(0)
		local found = false
		for i=1, #Config.TeleportsLegs, 1 do
			local distance = #(pCoords - Config.TeleportsLegs[i].From)
			if distance < Config.DrawDistance then
				found = true
				if not Config.TeleportsLegs[i].Visible then
					DrawMarker(Config.MarkerLegs.type, Config.TeleportsLegs[i].From, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerLegs.x, Config.MarkerLegs.y, Config.MarkerLegs.z, Config.MarkerLegs.r, Config.MarkerLegs.g, Config.MarkerLegs.b, Config.MarkerLegs.a, true, true, 2, Config.MarkerLegs.rotate, nil, nil, false)
					if distance < Config.MarkerLegs.x+0.5 then
						ESX.ShowHelpNotification(notification)
						if IsControlJustPressed(0, 38) then
							FastTravel(Config.TeleportsLegs[i].To, Config.TeleportsLegs[i].Heading)
						end
					end
				else
					if Config.TeleportsLegs[i].License then
						if ownedLicenses[Config.TeleportsLegs[i].License] == true then
							DrawMarker(Config.MarkerLegs.type, Config.TeleportsLegs[i].From, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerLegs.x, Config.MarkerLegs.y, Config.MarkerLegs.z, Config.MarkerLegs.r, Config.MarkerLegs.g, Config.MarkerLegs.b, Config.MarkerLegs.a, true, true, 2, Config.MarkerLegs.rotate, nil, nil, false)
							if distance < Config.MarkerLegs.x+0.5 then
								ESX.ShowHelpNotification(notification)
								if IsControlJustPressed(0, 38) then
									FastTravel(Config.TeleportsLegs[i].To, Config.TeleportsLegs[i].Heading)
								end
							end
						end
					else
						for j=1, #Config.TeleportsLegs[i].Visible, 1 do
							if PlayerData.job.name == Config.TeleportsLegs[i].Visible[j] or PlayerData.hiddenjob.name == Config.TeleportsLegs[i].Visible[j] then
								DrawMarker(Config.MarkerLegs.type, Config.TeleportsLegs[i].From, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerLegs.x, Config.MarkerLegs.y, Config.MarkerLegs.z, Config.MarkerLegs.r, Config.MarkerLegs.g, Config.MarkerLegs.b, Config.MarkerLegs.a, true, true, 2, Config.MarkerLegs.rotate, nil, nil, false)
								if distance < Config.MarkerLegs.x+0.5 then
									ESX.ShowHelpNotification(notification)
									if IsControlJustPressed(0, 38) then
										FastTravel(Config.TeleportsLegs[i].To, Config.TeleportsLegs[i].Heading)
									end
								end
							end
						end
					end
				end
			end
		end
		for i=1, #Config.TeleportsCars, 1 do
			local distance = #(pCoords - Config.TeleportsCars[i].From)
			if distance < Config.DrawDistance then
				found = true
				if not Config.TeleportsCars[i].Visible then
					DrawMarker(Config.MarkerCar.type, Config.TeleportsCars[i].From, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerCar.x, Config.MarkerCar.y, Config.MarkerCar.z, Config.MarkerCar.r, Config.MarkerCar.g, Config.MarkerCar.b, Config.MarkerCar.a, false, true, 2, Config.MarkerCar.rotate, nil, nil, false)
					if distance < Config.MarkerCar.x+0.5 then
						ESX.ShowHelpNotification(notification)
						if IsControlJustPressed(0, 38) and IsPlay then
							if (GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), -1) == ped) then
								CarTravel(Config.TeleportsCars[i].To, Config.TeleportsCars[i].Heading)
							end
						end
					end
				else
					for j=1, #Config.TeleportsCars[i].Visible, 1 do
						if PlayerData.job.name == Config.TeleportsCars[i].Visible[j] or PlayerData.hiddenjob.name == Config.TeleportsCars[i].Visible[j] then
							DrawMarker(Config.MarkerCar.type, Config.TeleportsCars[i].From, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerCar.x, Config.MarkerCar.y, Config.MarkerCar.z, Config.MarkerCar.r, Config.MarkerCar.g, Config.MarkerCar.b, Config.MarkerCar.a, false, true, 2, Config.MarkerCar.rotate, nil, nil, false)
							if distance < Config.MarkerCar.x+0.5 then
								ESX.ShowHelpNotification(notification)
								if IsControlJustPressed(0, 38) then
									if (GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), -1) == ped) then
										CarTravel(Config.TeleportsCars[i].To, Config.TeleportsCars[i].Heading)
									end
								end
							end
						end
					end
				end
			end
		end
		if not found then
			Wait(2000)
		end
	end
end)

CreateThread(function()
	while PlayerData.job == nil do
		Wait(100)
	end
	while true do
		Wait(0)
		local sleep = true
		for i=1, #Config.OrgsTeleports.Orgs do
			local dist = #(Config.OrgsTeleports.Orgs[i].From - pCoords)
			if dist < 15.0 then
				sleep = false
				if Config.OrgsTeleports.Orgs[i].Visible == PlayerData.job.name or Config.OrgsTeleports.Orgs[i].Visible == PlayerData.hiddenjob.name then
					DrawMarker(Config.MarkerLegs.type, Config.OrgsTeleports.Orgs[i].From, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerLegs.x, Config.MarkerLegs.y, Config.MarkerLegs.z, Config.MarkerLegs.r, Config.MarkerLegs.g, Config.MarkerLegs.b, Config.MarkerLegs.a, true, true, 2, Config.MarkerLegs.rotate, nil, nil, false)
					if dist < 1.0 then
						ESX.ShowHelpNotification("Naciśnij ~INPUT_PICKUP~ aby użyc przejścia")
						if IsControlJustPressed(0, 38) then
							ESX.TriggerServerCallback("exile_instancje:instance:ensure", function(bool)
								if bool then
									FastTravel(Config.OrgsTeleports.Exit, 90.0)
								end
							end, Config.OrgsTeleports.Orgs[i].Visible)
						end
					end
				end
			end
		end

		for i=1, #Config.OrgsTeleports.OrgsVehs, 1 do
			local dist = #(Config.OrgsTeleports.OrgsVehs[i].From - pCoords)
			if dist < 15.0 then
				sleep = false
				if PlayerData.job.name == Config.OrgsTeleports.OrgsVehs[i].Visible or PlayerData.hiddenjob.name == Config.OrgsTeleports.OrgsVehs[i].Visible then
					DrawMarker(Config.MarkerCar.type, Config.OrgsTeleports.OrgsVehs[i].From, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerCar.x, Config.MarkerCar.y, Config.MarkerCar.z, Config.MarkerCar.r, Config.MarkerCar.g, Config.MarkerCar.b, Config.MarkerCar.a, false, true, 2, Config.MarkerCar.rotate, nil, nil, false)
					if dist < Config.MarkerCar.x+0.5 then
						ESX.ShowHelpNotification(notification)
						if IsControlJustPressed(0, 38) then
							if (GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), -1) == ped) then
								local vehicle = GetVehiclePedIsIn(ped)
								local playersForInstance = {}

								table.insert(playersForInstance, GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(vehicle, -1))))
								if GetPedInVehicleSeat(vehicle, 0) ~= 0 then
									table.insert(playersForInstance, GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(vehicle, 0))))
								end
								for xd = 1, 6 do
									if GetPedInVehicleSeat(vehicle, xd) ~= 0 then
										table.insert(playersForInstance, GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(vehicle, xd))))
									end
								end

								TriggerServerEvent("exile_instancje:instance:ensure-with-veh-and-other-players", playersForInstance, Config.OrgsTeleports.OrgsVehs[i].Visible)
								CarTravel(Config.OrgsTeleports.ExitVehs, 90.0)
							end
						end
					end
				end
			end
		end
		if sleep then
			Wait(500)
		end
	end
end)

CreateThread(function()
	while PlayerData.job == nil do
		Wait(100)
	end
	while true do
		Wait(0)
		local sleep = true
		local distexit = #(Config.OrgsTeleports.Exit - pCoords)
		if distexit < 25 then
			DrawMarker(Config.MarkerCar.type, Config.OrgsTeleports.ExitVehs, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerCar.x, Config.MarkerCar.y, Config.MarkerCar.z, Config.MarkerCar.r, Config.MarkerCar.g, Config.MarkerCar.b, Config.MarkerCar.a, false, true, 2, Config.MarkerCar.rotate, nil, nil, false)
			DrawMarker(Config.MarkerLegs.type, Config.OrgsTeleports.Exit, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerLegs.x, Config.MarkerLegs.y, Config.MarkerLegs.z, Config.MarkerLegs.r, Config.MarkerLegs.g, Config.MarkerLegs.b, Config.MarkerLegs.a, true, true, 2, Config.MarkerLegs.rotate, nil, nil, false)
			if #(Config.OrgsTeleports.ExitVehs - pCoords) < Config.MarkerCar.x+0.5 then -- autka
				ESX.ShowHelpNotification("Naciśnij ~INPUT_PICKUP~ aby wyjść")
				if IsControlJustPressed(0, 38) then
					if (GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), -1) == ped) then
						local vehicle = GetVehiclePedIsIn(ped)
						local playersForInstance = {}

						table.insert(playersForInstance, GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(vehicle, -1))))
						if GetPedInVehicleSeat(vehicle, 0) ~= 0 then
							table.insert(playersForInstance, GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(vehicle, 0))))
						end
						for xd = 1, 6 do
							if GetPedInVehicleSeat(vehicle, xd) ~= 0 then
								table.insert(playersForInstance, GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(vehicle, xd))))
							end
						end

						TriggerServerEvent("exile_instancje:instance:exit-with-veh-and-other-players", playersForInstance)

						local coords, heading = nil, nil

						for k, v in pairs(Config.OrgsTeleports.OrgsVehs) do
							if v.Visible == PlayerData.hiddenjob.name then
								coords = v.From
								heading = v.Heading
								break
							end
							if v.Visible == PlayerData.job.name then
								coords = v.From
								heading = v.Heading
								break
							end
						end

						if coords == nil then
							local random = math.random(1, #Config.OrgsTeleports.OrgsVehs)
							coords, heading = Config.OrgsTeleports.OrgsVehs[random].From, Config.OrgsTeleports.OrgsVehs[random].Heading
						end

						CarTravel(coords, heading)
					end
				end
			end

			if distexit < 1.0 then
				ESX.ShowHelpNotification("Naciśnij ~INPUT_PICKUP~ aby wyjść")
				if IsControlJustPressed(0, 38) then
					ESX.TriggerServerCallback("exile_instancje:instance:exit", function(bool)
						if bool then
							local coords, heading = nil, nil

							for k, v in pairs(Config.OrgsTeleports.Orgs) do
								if v.Visible == PlayerData.hiddenjob.name then
									coords = v.From
									heading = v.Heading
									break
								end
								if v.Visible == PlayerData.job.name then
									coords = v.From
									heading = v.Heading
									break
								end
							end

							if coords == nil then
								local random = math.random(1, #Config.OrgsTeleports.Orgs)
								coords, heading = Config.OrgsTeleports.Orgs[random].From, Config.OrgsTeleports.Orgs[random].Heading
							end

							FastTravel(coords, heading)
						end
					end)
				end
			end
		else
			Wait(500)
		end
	end
end)

CreateThread(function()
	while PlayerData.job == nil do
		Wait(100)
	end
	while true do
		Wait(0)
		for i=1, #Config.Lifts, 1 do
			local playerCoords, sleep = pCoords, true
			for j=1, #Config.Lifts[i], 1 do
				if #(Config.Lifts[i][j].Coords - playerCoords) < 15.0 then
					sleep = false
					if not Config.Lifts[i][j].Allow then
						DrawMarker(Config.MarkerLift.type, Config.Lifts[i][j].Coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerLegs.x, Config.MarkerLegs.y, Config.MarkerLegs.z, Config.MarkerLegs.r, Config.MarkerLegs.g, Config.MarkerLegs.b, Config.MarkerLegs.a, true, true, 2, Config.MarkerLegs.rotate, nil, nil, false)
						if GetDistanceBetweenCoords(Config.Lifts[i][j].Coords,  playerCoords, true) < 1.0 then
							ESX.ShowHelpNotification("Naciśnij ~INPUT_PICKUP~ aby użyc windy")
							if IsControlJustPressed(0, 38) then
								OpenLiftMenu(i, j)
							end
						end
					else
						if Config.Lifts[i][j].Allow[PlayerData.job.name] or Config.Lifts[i][j].Allow[PlayerData.hiddenjob.name] then
							DrawMarker(Config.MarkerLift.type, Config.Lifts[i][j].Coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerLegs.x, Config.MarkerLegs.y, Config.MarkerLegs.z, Config.MarkerLegs.r, Config.MarkerLegs.g, Config.MarkerLegs.b, Config.MarkerLegs.a, true, true, 2, Config.MarkerLegs.rotate, nil, nil, false)
							if GetDistanceBetweenCoords(Config.Lifts[i][j].Coords,  playerCoords, true) < 1.0 then
								ESX.ShowHelpNotification("Naciśnij ~INPUT_PICKUP~ aby użyc windy")
								if IsControlJustPressed(0, 38) then
									OpenLiftMenu(i, j)
								end
							end
						end
					end
				end
			end
		end
		if sleep then
			Citizen.Wait(300)
		end
	end
end)

OpenLiftMenu = function(zone, currentFloor)
	ESX.UI.Menu.CloseAll()
	local elements = {}
	for i=1, #Config.Lifts[zone], 1 do
		local nextFloor = Config.Lifts[zone][i]
		if i ~= currentFloor then
			table.insert(elements, {label = nextFloor.Label, value = nextFloor.Coords, heading = nextFloor.Heading})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lift_menu',
	{
		title    = "Winda",
		align    = 'center',
		elements = elements
	}, function(data, menu)			
		menu.close()
		UseLift(data.current.value, data.current.heading)
	end, function(data, menu)
		menu.close()
	end)
end

UseLift = function(coords, heading)
	local x, y, z = coords.x, coords.y, coords.z
	z = z-0.9
	coords = vec3(x,y,z)
	TeleportFadeEffect(ped, coords, heading)
end

function CarTravel(coords, heading)
	local vehicle = GetVehiclePedIsUsing(ped)
	TriggerEvent("csskrouble:niggerCheck", false)
	TeleportCarFadeEffect(vehicle, coords, heading)
end

function FastTravel(coords, heading)
	TriggerEvent("csskrouble:niggerCheck", false)
	TeleportFadeEffect(ped, coords, heading)
end

function TeleportFadeEffect(entity, coords, heading)
	CreateThread(function()
        DoScreenFadeOut(100)
				Wait(300)
				while #(GetEntityCoords(ped) - coords) > 5 do
					ESX.Game.Teleport(entity, coords, function()
            Wait(100)
						if heading then
							SetEntityHeading(entity, heading)
						end
									DoScreenFadeIn(100)
						SetGameplayCamRelativeHeading(0.0)
					end)
					Wait(500)
				end
				DoScreenFadeIn(100)
	end)
end

function TeleportCarFadeEffect(vehicle, coords, heading)
	CreateThread(function()
		DoScreenFadeOut(800)
		Wait(300)
		RequestCollisionAtCoord(coords)
		while not HasCollisionLoadedAroundEntity(ped) do
			Wait(0)
		end

		SetEntityCoordsNoOffset(vehicle, coords, 0, 0, 0)

		Wait(600)
		--[[while #(GetEntityCoords(ped) - coords) > 5 do
			SetEntityCoordsNoOffset(ped, coords, 0, 0, 0)
			Wait(500)
		end]]

		if heading then
			SetEntityHeading(vehicle, heading)
		end

		SetGameplayCamRelativeHeading(0.0)

		DoScreenFadeIn(800)
		while IsScreenFadingIn() do
			Wait(0)
		end
		Citizen.InvokeNative(0x10D373323E5B9C0D)
	end)
end
