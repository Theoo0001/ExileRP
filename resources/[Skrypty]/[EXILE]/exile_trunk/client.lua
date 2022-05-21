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

ESX = nil

CreateThread(function()
	while ESX == nil do
		TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) 
			ESX = obj 
		end)
		
		Citizen.Wait(250)
	end
end)

local disabledTrunk = {
	[1] = `adder`,
	[2] = `zentorno`,
	[3] = `fxxk`,
	[4] = `bugattichiron`,
	[5] = `bugattidivo`,
	[6] = `bugattiveyron`,
	[7] = `autarch`,
	[8] = `comet5`,
	[9] = `coquette4`,
	[10] = `deveste`,
	[11] = `emerus`,
	[12] = `gb200`,
	[13] = `infernus2`,
	[14] = `italirsx`,
	[15] = `koenigseggagera`,
	[16] = `koenigseggjesko`,
	[17] = `lambolp750sv`,
	[18] = `lambohuracan`,
	[19] = `lamborghiniurus`,
	[20] = `lambosestoelemento`,
	[21] = `lambosvj`,
	[22] = `lamboveneno`,
	[23] = `mclaren600lt`,
	[24] = `mclarenp1`,
	[25] = `nero2`,
	[26] = `paganihuayraimola`,
	[27] = `porsche911venom`,
	[28] = `reaper`,
	[29] = `t20`,
	[30] = `tempesta`,
	[31] = `ts1`,
	[32] = `turismo2`,
	[33] = `vacca`,
	[34] = `tyrus`,
	[35] = `vagner`,
	[36] = `xa21`,
	[37] = `hp_911`,
	[38] = `hp_c8`,
	[39] = `hp_chiron`,
	[40] = `hp_divo`,
	[41] = `hp_f430`,
	[42] = `hp_gt17`,
	[43] = `hp_laferrari`,
	[44] = `hp_lambo`,
	[45] = `hp_p1`,
	[46] = `hp_sf90`,
	[47] = `hp_veyron`,
	[48] = `pd_c8`,
	[49] = `pd_turismo`
}

local inTrunk = nil
local cam = 0
local isDead = false

function checkTrunk(veh)
	return disabledTrunk[model] == true
end

function cameraTrunk()
	local ped = PlayerPedId()
	if not DoesCamExist(cam) then
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
		SetCamActive(cam, true)
		RenderScriptCams(true, false, 0, true, true)
		SetCamCoord(cam, GetEntityCoords(ped))
	end

	AttachCamToEntity(cam, ped, 0.0, -2.0, 1.0, true)
	SetCamRot(cam, -30.0, 0.0, GetEntityHeading(ped))
end

function cameraTrunkDisable()
	RenderScriptCams(false, false, 0, 1, 0)
	DestroyCam(cam, false)
end

function showNotification(msg, me, cop)
	if not cop or me == cop then
		ESX.ShowNotification(msg)
	else
		TriggerServerEvent('exile_trunk:notify', cop, msg)
	end
end

RegisterNetEvent("exile:forceInTrunk")
AddEventHandler("exile:forceInTrunk", function(cop)
	local me = GetPlayerServerId(PlayerId())
	if not inTrunk then
		if not exports['esx_jailer']:getJailStatus() then
			local targetVehicle = ESX.Game.GetVehicleInDirection()
			
			if not DoesEntityExist(targetVehicle) then
				showNotification('Zbyt daleko do bagażnika', me, cop)
			elseif DecorExistOn(targetVehicle, 'trunk') then
				showNotification('~r~Bagażnik w tym aucie jest już zajęty!', me, cop)
			elseif DoesVehicleHaveDoor(targetVehicle, 6) or not DoesVehicleHaveDoor(targetVehicle, 5) then
				showNotification('~r~W tym aucie nie można jeździć w bagażniu!', me, cop)
			elseif isDead then
				showNotification('~r~W bagażniku nie możę znajdować się osoba obezwładniona!', me, cop)
			else
				local model = GetEntityModel(targetVehicle)
				if IsThisModelACar(model) and not checkTrunk(model) then
					RequestAnimDict("fin_ext_p1-7")
					while not HasAnimDictLoaded("fin_ext_p1-7") do
						Citizen.Wait(0)
					end
				
					local ped = GetPedInVehicleSeat(targetVehicle, -1)
					if not DoesEntityExist(ped) or IsPedAPlayer(ped) then
						SetVehicleDoorOpen(targetVehicle, 5, false)
					end

					local id = NetworkGetNetworkIdFromEntity(targetVehicle)
					SetNetworkIdCanMigrate(id, true)
					SetEntityAsMissionEntity(targetVehicle, true, false)
					SetVehicleHasBeenOwnedByPlayer(targetVehicle,  true)

					ped = PlayerPedId()
					ClearPedTasksImmediately(ped)
					TaskPlayAnim(ped, "fin_ext_p1-7", "cs_devin_dual-7", 8.0, 8.0, -1, 1, 999.0, 0, 0, 0)

					local d1, d2 = GetModelDimensions(model)
					AttachEntityToEntity(ped, targetVehicle, 0, -0.1, d1.y + 0.85, d2.z - 0.87, 0, 0, 40.0, 1, 1, 1, 1, 1, 1)
					TriggerServerEvent('esx:updateDecor', 'INT', id, 'trunk', me)
					inTrunk = targetVehicle
				else
					showNotification('~r~W tym aucie nie można jeździć w bagażniu!', me, cop)
				end
			end
		else
			showNotification('Nie można umieścić w bagażniku', me, cop)
		end
	else
		showNotification('Już w bagażniku', me, cop)
	end
end)

RegisterNetEvent("exile:forceOutTrunk")
AddEventHandler("exile:forceOutTrunk", function(cop)
	if inTrunk then
		local ped = PlayerPedId()
		ClearPedTasks(ped)
		DetachEntity(ped)
		
		local DropCoords = GetEntityCoords(ped, true)
		SetEntityCoords(ped, DropCoords.x + 1.5, DropCoords.y + 1.5, DropCoords.z)

		TriggerServerEvent('esx:updateDecor', 'DEL', NetworkGetNetworkIdFromEntity(inTrunk), 'trunk')
		if cop == true then
			SetVehicleDoorOpen(targetVehicle, 5, 1, 1)
		end

		inTrunk = nil
		if not isDead then
			cameraTrunkDisable()
		end
	else
		showNotification('~r~Nie jesteś w bagażniku!', GetPlayerServerId(PlayerId()), cop)
	end
end)

RegisterNetEvent('playerDroped')
AddEventHandler('playerDroped', function()
	if inTrunk then
		TriggerServerEvent('esx:updateDecor', 'DEL', NetworkGetNetworkIdFromEntity(inTrunk), 'trunk')
	end
end)

CreateThread(function()
	if not DecorIsRegisteredAsType('trunk', 3) then
		DecorRegister('trunk', 3)
	end
	
	while true do
		Citizen.Wait(0)		
		if inTrunk then
			local ped = PlayerPedId()
			local attached = IsEntityAttachedToAnyVehicle(ped)
			
			local out = nil
			
			if DoesEntityExist(inTrunk) and attached then
				if IsEntityVisible(inTrunk) then
					if not isDead then
						cameraTrunk()
						DisableControlAction(2, 24, true) -- Attack
						DisableControlAction(2, 257, true) -- Attack 2
						DisableControlAction(2, 25, true) -- Aim
						DisableControlAction(2, 263, true) -- Melee Attack 1
						DisableControlAction(2, Keys['R'], true) -- Reload
						DisableControlAction(2, Keys['TOP'], true) -- Open phone (not needed?)
						DisableControlAction(2, Keys['SPACE'], true) -- Jump
						DisableControlAction(2, Keys['Q'], true) -- Cover
						DisableControlAction(2, Keys['~'], true) -- Hands up
						DisableControlAction(2, Keys['B'], true) -- Pointing
						DisableControlAction(2, Keys['TAB'], true) -- Select Weapon
						DisableControlAction(2, Keys['F'], true) -- Also 'enter'?
						DisableControlAction(2, Keys['F3'], true) -- Animations
						DisableControlAction(2, Keys['LEFTSHIFT'], true) -- Running
						DisableControlAction(2, Keys['V'], true) -- Disable changing view
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
						DisableControlAction(0, 73, true) -- Disable X (cancel anim)
						DisableControlAction(0, 11, true)
					else
						out = true
					end
				else
					out = true
				end
			else
				out = false
			end

			if out ~= nil then
				TriggerEvent('exile:forceOutTrunk', attached)
				if out then					
					Citizen.InvokeNative(0xEA1C610A04DB6BBB, PlayerPedId(), true)
				end
			elseif not DecorExistOn(inTrunk, 'trunk') then
				TriggerServerEvent('esx:updateDecor', 'INT', NetworkGetNetworkIdFromEntity(inTrunk), 'trunk', GetPlayerServerId(PlayerId()))
			end
		else
			Citizen.Wait(500)
		end
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(0)		
		if inTrunk and DoesEntityExist(inTrunk) and not IsPedDeadOrDying(PlayerPedId(), 1) then
			if IsControlJustReleased(0, Keys['H']) and GetVehicleDoorLockStatus(inTrunk) < 2 then
				local ped = GetPedInVehicleSeat(inTrunk, -1)
				if not DoesEntityExist(ped) or IsPedAPlayer(ped) then
					if GetVehicleDoorAngleRatio(inTrunk, 5) > 0 then
						SetVehicleDoorShut(inTrunk, 5, false)
					else
						SetVehicleDoorOpen(inTrunk, 5, false, false)
					end
				end
			end

			if IsControlJustReleased(0, Keys['Y']) and GetVehicleDoorAngleRatio(inTrunk, 5) > 0.0 then
				if not exports['esx_policejob']:IsCuffed() then
					TriggerEvent('exile:forceOutTrunk', false)
				else
					ESX.ShowNotification('~r~Nie możesz wyjść z bagażnika będąc zakutym')
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function checkInTrunk()
	return inTrunk ~= nil
end

AddEventHandler('playerSpawned', function()
	isDead = false
end)

AddEventHandler('esx:onPlayerDeath', function()
	isDead = true
end)

AddEventHandler('esx:onPlayerSpawn', function()
	if inTrunk then
		TriggerEvent('exile:forceOutTrunk', false)
	end
end)
