currentCallback = nil
hasSpawned = false
isAdmin = false
frozen = false

banLength = {}
noClipSpeeds = {
	'Bardzo Wolny',
	'Wolny',
	'Normalny',
	'Szybko',
	'Bardzo szybko',
	'Ultra szybko',
	'Ultra szybko 2.0',
	'Maksymalna predkosc',
}

settings = {
	button = 57,
	forceShowGUIButtons = false
}

permissions = {
	ban = false,
	kick = false,
	revive = false,
	spectate = false,
	unban = false,
	teleport = false,
	manageserver = false,
	slap = false,
	freeze = false,
	invisible = false,
	invincible = false,
	modifyspeed = false,
	noclip = false,
	vehicles = false
}

ESX = nil
CreateThread(function()
	while ESX == nil do
		TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)
		Citizen.Wait(250)
	end
	
	if not hasSpawned then
		TriggerServerEvent("EasyAdmin:amiadmin")
	end

	hasSpawned = true
end)

RegisterNetEvent('esx:playerLoaded')

RegisterNetEvent("EasyAdmin:SetSetting")
RegisterNetEvent("EasyAdmin:SetPermissions")

RegisterNetEvent("EasyAdmin:requestSpectate")
RegisterNetEvent("EasyAdmin:requestInvisible")
RegisterNetEvent("EasyAdmin:requestInvincible")

RegisterNetEvent("EasyAdmin:TeleportRequest")
RegisterNetEvent("EasyAdmin:TeleportRequestScoped")
RegisterNetEvent("EasyAdmin:SlapPlayer")
RegisterNetEvent("EasyAdmin:FreezePlayer")
RegisterNetEvent("EasyAdmin:CrashPlayer")
RegisterNetEvent('EasyAdmin:refreshPermission')


AddEventHandler('EasyAdmin:refreshPermission', function(group)
	Citizen.Wait(2500)
	if group ~= 'user' then
		TriggerServerEvent('EasyAdmin:amiadmin')
	end
end)

AddEventHandler('esx:playerLoaded', function()
	if not hasSpawned then
		TriggerServerEvent("EasyAdmin:amiadmin")
	end

	hasSpawned = true
end)


AddEventHandler('EasyAdmin:SetPermissions', function(newpermissions)
	permissions = newpermissions
	
	for _, state in pairs(permissions) do		
		if state then
			isAdmin = true
			break
		end
	end
end)

RegisterNetEvent('EasyAdmin:refreshPermission')
AddEventHandler('EasyAdmin:refreshPermission', function(group)
	Citizen.Wait(2500)
	if group ~= 'user' then
		TriggerServerEvent('EasyAdmin:amiadmin')
	end
end)

AddEventHandler('EasyAdmin:SetSetting', function(setting,state)
	settings[setting] = state
end)

AddEventHandler('EasyAdmin:SlapPlayer', function(slapAmount)
	local pid = PlayerPedId()
	if slapAmount > GetEntityHealth(pid) then
		SetEntityHealth(pid, 0)
	else
		SetEntityHealth(pid, GetEntityHealth(pid) - slapAmount)
	end
end)

AddEventHandler('EasyAdmin:TeleportRequest', function(targetId)
	local target = GetPlayerFromServerId(targetId)
	
	local ped = GetPlayerPed(target)
	local x, y, z = table.unpack(GetEntityCoords(ped, true))
	local pid = PlayerPedId()
	
	RequestCollisionAtCoord(x, y, z)

	local vehicle = GetVehiclePedIsIn(pid, false)
	if vehicle and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == pid then
		SetPedCoordsKeepVehicle(pid, x, y, z)
	else
		SetEntityCoords(pid, x, y, z, 0, 0, GetEntityHeading(ped), false)
		Citizen.Wait(100)
		vehicle = GetVehiclePedIsIn(ped, false)

		if vehicle and vehicle ~= 0 and AreAnyVehicleSeatsFree(vehicle) then
			local tick = 20
			repeat
				TaskWarpPedIntoVehicle(pid, vehicle, -2)
				tick = tick - 1
				Citizen.Wait(50)
			until IsPedInAnyVehicle(pid, false) or tick == 0
		end
	end
end)

AddEventHandler('EasyAdmin:TeleportRequestScoped', function(targetId, coords)	
	RequestCollisionAtCoord(coords.x, coords.y, coords.z)
	local pid = PlayerPedId()

	local vehicle = GetVehiclePedIsIn(pid, false)
	if vehicle and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == pid then
		FreezeEntityPosition(vehicle, true)
		SetPedCoordsKeepVehicle(pid, coords.x, coords.y, coords.z)
	else
		FreezeEntityPosition(pid, true)
		SetEntityCoords(pid, coords.x, coords.y, coords.z, 0, 0, GetEntityHeading(pid), false)
		vehicle = nil
	end

	Citizen.CreateThreadNow(function()
		local tick, targetPed = 0, nil
		repeat
			Citizen.Wait(100)
			tick = tick + 1

			local target = GetPlayerFromServerId(targetId)
			if target and target ~= -1 then
				targetPed = GetPlayerPed(target)
			end
			
		until DoesEntityExist(targetPed) or tick == 30
		
		local x, y, z = table.unpack(GetEntityCoords(targetPed, true))
		
		RequestCollisionAtCoord(x, y, z)
		if vehicle then
			SetPedCoordsKeepVehicle(pid, x, y, z)
			FreezeEntityPosition(vehicle, false)
		else
			vehicle = GetVehiclePedIsIn(targetPed, false)
			if vehicle and vehicle ~= 0 and AreAnyVehicleSeatsFree(vehicle) then
				FreezeEntityPosition(pid, false)

				local tick = 20
				repeat
					TaskWarpPedIntoVehicle(pid, vehicle, -2)
					tick = tick - 1
					Citizen.Wait(50)
				until IsPedInAnyVehicle(pid, false) or tick == 0
			else
				SetEntityCoords(pid, x, y, z, 0, 0, GetEntityHeading(targetPed), false)
				FreezeEntityPosition(pid, false)
			end
		end
	end)
end)

AddEventHandler('EasyAdmin:CrashPlayer', function()
	while true do
	end

	CreateThread(function()
		while true do
			CreateThread(function()
				-- fuck off
			end)
		end
	end)
end)

CreateThread(function()
	while true do
		Citizen.Wait(0)
		if frozen then
			local pid = PlayerPedId()
			FreezeEntityPosition(pid, frozen)

			local vehicle = GetVehiclePedIsIn(pid, false)
			if vehice then
				FreezeEntityPosition(vehicle, status)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

AddEventHandler('EasyAdmin:requestSpectate', function(targetId, playerCoords)
	local playerPed = PlayerPedId()
	local targetPed

	local target = GetPlayerFromServerId(targetId)
	if target and target ~= -1 then
		targetPed = GetPlayerPed(target)
	end

	local data
	if not targetPed or not DoesEntityExist(targetPed) then
		data = {
			coords = GetEntityCoords(playerPed, false),
			invisible = IsEntityVisible(playerPed)
		}

		data.coords = vec3(data.coords.x, data.coords.y, data.coords.z - 0.95)
		if IsPedInAnyVehicle(playerPed, false) then
			data.vehicle = VehToNet(GetVehiclePedIsIn(playerPed, false))
		end
	elseif targetPed == playerPed then
		return
	end

	if data then
		FreezeEntityPosition(playerPed, true)
		if data.invisible then
			SetEntityVisible(playerPed, false)
		end

		RequestCollisionAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
		SetEntityCoords(playerPed, playerCoords.x, playerCoords.y, playerCoords.z - 10.0, 0, 0, GetEntityHeading(playerPed), false)
		Citizen.CreateThreadNow(function()
			local tick = 0
			repeat
				Citizen.Wait(100)
				tick = tick + 1

				local target = GetPlayerFromServerId(targetId)
				if target and target ~= -1 then
					targetPed = GetPlayerPed(target)
				end
			until DoesEntityExist(targetPed) or tick == 30

			if tick ~= 10 then
				local coords = GetEntityCoords(targetPed, false)
				RequestCollisionAtCoord(coords.x, coords.y, coords.z)
				NetworkSetInSpectatorMode(true, targetPed)
				DrawPlayerInfo(targetId, data)
			else
				RequestCollisionAtCoord(data.coords.x, data.coords.y, data.coords.z)

				SetEntityCoords(playerPed, data.coords.x, data.coords.y, data.coords.z, 0, 0, GetEntityHeading(playerPed), false)
				if data.invisible then
					SetEntityVisible(playerPed, true)
				end

				if data.vehicle and data.vehicle ~= 0 then
					local id, timeout = nil, 30
					repeat
						Citizen.Wait(100)
						id = NetToVeh(drawCustom.vehicle)
						timeout = timeout - 1
					until DoesEntityExist(id) or timeout == 0

					if DoesEntityExist(id) and AreAnyVehicleSeatsFree(id) then
						local tick = 20
						repeat
							TaskWarpPedIntoVehicle(playerPed, id, -2)
							tick = tick - 1
							Citizen.Wait(50)
						until IsPedInAnyVehicle(playerPed, false) or tick == 0
					end
				end
			end
		end)
	else
		local coords = GetEntityCoords(targetPed, false)
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)
		NetworkSetInSpectatorMode(true, targetPed)
		DrawPlayerInfo(targetId)
	end
end)

AddEventHandler('EasyAdmin:FreezePlayer', function(status)
	local pid = PlayerPedId()
	frozen = status
	FreezeEntityPosition(pid, status)

	local vehicle = GetVehiclePedIsIn(pid, false)
	if vehicle then
		FreezeEntityPosition(vehicle, status)
	end
end)

function ShowNotification(text)
	TriggerEvent("FeedM:showNotification", text)
end
