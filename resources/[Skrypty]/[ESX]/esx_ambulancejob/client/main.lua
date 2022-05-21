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

local PlayerData				= {}
local FirstSpawn				= true
local IsDead					= false
local TimerThreadId	   = nil
local DistressThreadId	= nil
local HasAlreadyEnteredMarker	= false
local LastZone					= nil
local CurrentAction				= nil
local obezwladniony = false
local CurrentActionMsg			= ''
local CurrentActionData			= {}
local IsBusy					= false
local blockShooting = GetGameTimer()
local CurrentTask = {}
local Melee = { `WEAPON_UNARMED`, `WEAPON_KNUCKLE`, `WEAPON_BAT`, `WEAPON_FLASHLIGHT`, `WEAPON_HAMMER`, `WEAPON_CROWBAR`, `WEAPON_PIPEWRENCH`, `WEAPON_NIGHTSTICK`, `WEAPON_GOLFCLUB`, `WEAPON_WRENCH` }
local Knife = { `WEAPON_KNIFE`, `WEAPON_DAGGER`, `WEAPON_MACHETE`, `WEAPON_HATCHET`, `WEAPON_SWITCHBLADE`, `WEAPON_BATTLEAXE`, `WEAPON_BATTLEAXE`, `WEAPON_STONE_HATCHET` }
local Bullet = { `WEAPON_SNSPISTOL`, `WEAPON_SNSPISTOL_MK2`, `WEAPON_PISTOL50`, `WEAPON_VINTAGEPISTOL`, `WEAPON_PISTOL`, `WEAPON_MILITARYRIFLE`, `WEAPON_PISTOL_MK2`, `WEAPON_GADGETPISTOL`, `WEAPON_DOUBLEACTION`, `WEAPON_COMBATPISTOL`, `WEAPON_HEAVYPISTOL`, `WEAPON_DBSHOTGUN`, `WEAPON_SAWNOFFSHOTGUN`, `WEAPON_PUMPSHOTGUN`, `WEAPON_PUMPSHOTGUN_MK2`, `WEAPON_BULLPUPSHOTGUN`, `WEAPON_MICROSMG`, `WEAPON_SMG`, `WEAPON_SMG_MK2`, `WEAPON_ASSAULTSMG`, `WEAPON_COMBATPDW`, `WEAPON_GUSENBERG`, `WEAPON_COMPACTRIFLE`, `WEAPON_ASSAULTRIFLE`, `WEAPON_ASSAULTRIFLE`, `WEAPON_EMPLAUNCHER`, `WEAPON_FERTILIZERCAN`, `WEAPON_CARBINERIFLE`, `WEAPON_MARKSMANRIFLE`, `WEAPON_SNIPERRIFLE`, `WEAPON_NAVYREVOLVER`, `WEAPON_RPG` }
local Electricity = { `WEAPON_STUNGUN`, `WEAPON_STUNGUN_MP` }
local Animal = { -100946242, 148160082 }
local FallDamage = { -842959696 }
local Explosion = { -1568386805, 1305664598, -1312131151, 375527679, 324506233, 1752584910, -1813897027, 741814745, -37975472, 539292904, 341774354, -1090665087 }
local Gas = { -1600701090 }
local Burn = { 615608432, 883325847, -544306709 }
local Drown = { -10959621, 1936677264 }
local Car = { 133987706, -1553120962 }
local SamsBlip = {}
local tekst = 0
local isUsing = false
local cam = nil

local choosedHospital = nil
local heli = false

ESX								= nil

function isDead()
	return IsDead
end

function checkArray(array, val)
	for _, value in ipairs(array) do
		local v = value
		if type(v) == 'string' then
			v = GetHashKey(v)
		end

		if v == val then
			return true
		end
	end

	return false
end

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

CreateThread(function()
	while ESX == nil do
		TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) 
			ESX = obj 
		end)
		Citizen.Wait(250)
	end

	Citizen.Wait(5000)
	TriggerServerEvent('esx_ambulancejob:checkIsDuty')
	PlayerData = ESX.GetPlayerData()
	refreshBlip()
end)

function cleanPlayer(playerPed)
	Citizen.InvokeNative(0xCEA04D83135264CC, playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

function RespawnPed(ped, coords)
	TriggerEvent("csskrouble:niggerCheck", false)
	TriggerEvent("csskrouble:save")
	SetEntityCoords(ped, coords.x, coords.y, coords.z)
	SetEntityHeading(ped, coords.heading)
	if ped == PlayerPedId() then
		SetGameplayCamRelativeHeading(coords.heading)
	end
	
	Citizen.InvokeNative(0x6B76DC1F3AE6E6A3, ped, GetEntityMaxHealth(ped))
	
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.heading, true, false)
	TriggerEvent('playerSpawned', coords.x, coords.y, coords.z, coords.heading)
	TriggerEvent('esx:onPlayerSpawn', coords.x, coords.y, coords.z)
	Citizen.InvokeNative(0x239528EACDC3E7DE, ped, false)
	ClearPedBloodDamage(ped)
end

RegisterNetEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(_type)
	local playerPed = PlayerPedId()
	local maxHealth = GetEntityMaxHealth(playerPed)
	if _type == 'small' then
		local health = GetEntityHealth(playerPed)
		local newHealth = math.min(maxHealth , math.floor(health + maxHealth/4))
		Citizen.InvokeNative(0x6B76DC1F3AE6E6A3, playerPed, newHealth)
	elseif _type == 'big' then
		Citizen.InvokeNative(0x6B76DC1F3AE6E6A3, playerPed, maxHealth)
	end
	
	ESX.ShowNotification(_U('healed'))
end)

RegisterNetEvent('esx_ambulancejob:healitem')
AddEventHandler('esx_ambulancejob:healitem', function(_type)
	local playerPed = PlayerPedId()
	local health = GetEntityHealth(playerPed)
	local maxHealth = GetEntityMaxHealth(playerPed)

	if not isUsing then
		if _type == 'bsmall' then
			if health < 200 then 
				isUsing = true
				ESX.UI.Menu.CloseAll()
				local newHealth = health + 50
				FreezeEntityPosition(playerPed, true)
				ClearPedTasks(playerPed)
				FreezeEntityPosition(playerPed, true)
				TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
				
				exports['ExileRP']:DrawProcent(150, function()
					Citizen.InvokeNative(0x6B76DC1F3AE6E6A3, playerPed, newHealth)
					FreezeEntityPosition(playerPed, false)
					ClearPedTasks(playerPed)
					isUsing = false				
					FreezeEntityPosition(playerPed, false)
				end)
			elseif health == 200 then
				ESX.ShowNotification('Zużyłeś bandaż.')
			end
		elseif _type == 'bmedium' then
			isUsing = true
			ESX.UI.Menu.CloseAll()
			ClearPedTasks(playerPed)
			FreezeEntityPosition(playerPed, true)
			TaskStartScenarioInPlace(playerPed, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
			
			exports['ExileRP']:DrawProcent(300, function()
				FreezeEntityPosition(playerPed, false)
				ClearPedTasks(playerPed)
				isUsing = false
				Citizen.InvokeNative(0x6B76DC1F3AE6E6A3, playerPed, maxHealth)
				ESX.ShowNotification(_U('healed'))			
			end)
		end
	else
		ESX.ShowNotification('Juz sobie pomagasz')
	end
end)

function StartRespawnTimer()
	Citizen.SetTimeout(Config.RespawnDelayAfterRPDeath, function()
			if IsDead then
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'rp_dead', {
			title = _U('rp_dead'),
			align = 'center',
			elements = {
				{ label = _U('yes'), value = 'yes' },
				{ label = _U('no'), value = 'no' },
			}
		}, function (data, menu)
			if data.current.value == 'yes' then
				RemoveItemsAfterRPDeath()
			end
			menu.close()
		end, function (data, menu)
			menu.close()
			if data.current.value == 'no' and IsControlJustPressed(1, 178) then
				RemoveItemsAfterRPDeath()
			end
			menu.close()
		end)
			end
	end)
end

function setUniform(job, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if Config.Uniforms[job].male ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end
		else
			if Config.Uniforms[job].female ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end
		end
	end)
end

function StartDistressSignal()
	CreateThread(function()
		local timer = Config.RespawnDelayAfterRPDeath

		local signal = 0
		while IsDead do
			Citizen.Wait(0)

			if obezwladniony then
				return
			else
				if signal < GetGameTimer() then
					SetTextFont(4)
					SetTextCentre(true)
					SetTextProportional(1)
					SetTextScale(0.45, 0.45)
					SetTextColour(255, 255, 255, 255)
					SetTextDropShadow(0, 0, 0, 0, 255)
					SetTextEdge(1, 0, 0, 0, 255)
					SetTextDropShadow()
					SetTextOutline()

					BeginTextCommandDisplayText('STRING')
					AddTextComponentSubstringPlayerName(_U('distress_send'))
					EndTextCommandDisplayText(0.5, 0.905)		

					if IsDisabledControlPressed(0, Keys['G']) and not exports['esx_policejob']:IsCuffed() then
						SendDistressSignal()
						signal = GetGameTimer() + 90000 * 4
					end					
				end
			end
		end
	end)
end

function SendDistressSignal()	
	ESX.TriggerServerCallback('gcphone:getItemAmount', function(qtty)
		if qtty > 0 then
			ESX.TriggerServerCallback('route68:getSimWczytana', function(sim)
				if sim == nil then
					ESX.ShowNotification('~r~Nie posiadasz podpiętej karty sim')
				else
					local godzinaInt = GetClockHours()
					local godzina = ''
					if string.len(tostring(godzinaInt)) == 1 then
						godzina = '0'..godzinaInt
					else
						godzina = godzinaInt
					end
					local minutaInt = GetClockMinutes()
					local minuta = ''
					if string.len(tostring(minutaInt)) == 1 then
						minuta = '0'..minutaInt
					else
						minuta = minutaInt
					end
					godzina = godzina..":"..minuta
					
					ESX.ShowNotification('Sygnał alarmowy został wysłany!')
					
					local coords = GetEntityCoords(PlayerPedId())
					TriggerServerEvent('esx_addons_gcphone:startCall', 'ambulance', 'Ranny obywatel o godzienie: '..godzina, {
						x = coords.x,
						y = coords.y,
						z = coords.z
					})				
				end
			end)
		end
	end, 'phone')
end

function ShowDeathTimer()
	if DistressThreadId then
		TerminateThread(DistressThreadId)
	end
	
	local respawnTimer = Config.RespawnDelayAfterRPDeath
	local allowRespawn = Config.RespawnDelayAfterRPDeath/2
	local fineAmount = Config.EarlyRespawnFineAmount
	local payFine = false

	if Config.EarlyRespawn and Config.EarlyRespawnFine then
		ESX.TriggerServerCallback('esx_ambulancejob:checkBalance', function(finePayable)
			if finePayable then
				payFine = true
			else
				payFine = false
			end
		end)
	end

	CreateThread(function()
		ClearPedTasksImmediately(PlayerPedId())
		while respawnTimer > 0 and IsDead do
			Citizen.Wait(0)
			if obezwladniony then
				return
			else
				raw_seconds = respawnTimer/1000
				raw_minutes = raw_seconds/60
				minutes = stringsplit(raw_minutes, ".")[1]
				seconds = stringsplit(raw_seconds-(minutes*60), ".")[1]

				SetTextFont(4)
				SetTextProportional(0)
				SetTextScale(0.0, 0.5)
				SetTextColour(255, 255, 255, 255)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 1, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()

				local text = _U('please_wait', minutes, seconds)

				if Config.EarlyRespawn then
					if not Config.EarlyRespawnFine and respawnTimer <= allowRespawn then
						text = text .. _U('press_respawn')
					elseif Config.EarlyRespawnFine and respawnTimer <= allowRespawn and payFine then
						text = text .. _U('respawn_now_fine', fineAmount)
					else
						text = text
					end
				end

				SetTextCentre(true)
				SetTextEntry("STRING")
				AddTextComponentString(text)
				DrawText(0.5, 0.8)

				if Config.EarlyRespawn then
					if not Config.EarlyRespawnFine then
						if IsControlPressed(0, 46) then
							RemoveItemsAfterRPDeath()
							break
						end
					elseif Config.EarlyRespawnFine then
						if respawnTimer <= allowRespawn and payFine then
							if IsControlPressed(0, 46) then
								PayFine()
								break
							end
						end
					end
				end
				respawnTimer = respawnTimer - 15
			end
		end
	end)
end

function RemoveItemsAfterRPDeath()
	CreateThread(function()
		DoScreenFadeOut(800)
		while not IsScreenFadedOut() do
			Citizen.Wait(10)
		end
		ESX.UI.Menu.CloseAll()
		ESX.TriggerServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function()			
			local hospital = string.upper(choosedHospital)
			ESX.SetPlayerData('lastPosition', Config["RespawnPlace"..hospital])
			TriggerServerEvent('esx:updateCoords', Config["RespawnPlace"..hospital])
			RespawnPed(PlayerPedId(), Config["RespawnPlace"..hospital])
			TriggerServerEvent('esx_ambulancejob:setDeathStatus', 0)
			StopScreenEffect('DeathFailOut')
			DoScreenFadeIn(800)
			TriggerServerEvent('exile_logs:triggerLog', "Przeteleportował się na szpital: "..hospital, 'teleportszpital')
		end)
	end)
end

function PayFine()
	ESX.TriggerServerCallback('esx_ambulancejob:payFine', function()
	RemoveItemsAfterRPDeath()
	end)
end

function secondsToClock(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format('%02.f', math.floor(seconds / 3600))
		local mins = string.format('%02.f', math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format('%02.f', math.floor(seconds - hours * 3600 - mins * 60))

		return secs, mins
	end
end

function StartDeathTimer()
	if TimerThreadId then
		TerminateThread(TimerThreadId)
	end
	local timer = ESX.Math.Round(Config.RespawnToHospitalDelay / 1000)
	local seconds,minutes = secondsToClock(timer)
	local firstScreen = true
	CreateThread(function() 
		HasTimer = true
		while timer > 0 and IsDead do
			Citizen.Wait(1000)
			if timer > 0 then
				timer = timer - 1
			end
			seconds,minutes = secondsToClock(timer)
		end
		HasTimer = false
		firstScreen = false
	end)
	CreateThread(function()
		TimerThreadId = GetIdOfThisThread()

		while firstScreen do
			Citizen.Wait(1)
			if obezwladniony then
				return
			else
				SetTextFont(4)
				SetTextCentre(true)
				SetTextProportional(1)
				SetTextScale(0.45, 0.45)
				SetTextColour(255, 255, 255, 255)
				SetTextDropShadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()

				BeginTextCommandDisplayText("STRING")
				AddTextComponentSubstringPlayerName('Pozostało: [~b~'..minutes..' minut i '..seconds..' sekund~w~] do przyjazdu lokalnych medyków')
				EndTextCommandDisplayText(0.5, 0.870)
			end
		end

		local pressStart = nil
		while IsDead do
			Citizen.Wait(1)
			if obezwladniony then 
				return
			else
				SetTextFont(4)
				SetTextCentre(true)
				SetTextProportional(1)
				SetTextScale(0.45, 0.45)
				SetTextColour(255, 255, 255, 255)
				SetTextDropShadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()

				BeginTextCommandDisplayText("STRING")
				AddTextComponentSubstringPlayerName('Przytrzymaj [~b~E~s~] aby zostać transportowanym do szpitala')
				EndTextCommandDisplayText(0.5, 0.860)

				if IsControlPressed(0, Keys['E']) or IsDisabledControlPressed(0, Keys['E']) then
					if not pressStart then
						pressStart = GetGameTimer()
					end

					if GetGameTimer() - pressStart > 3000 then
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'rp_dead', {
							title = ('Wybierz szpital'),
							align = 'center',
							elements = {
								{ label = ('Los Santos'), value = 'ls' },
								{ label = ('Sandy Shores'), value = 'sandy' },
								{ label = ('Paleto Bay'),  value = 'paleto'},
							}
						}, function (data, menu)
							if data.current.value == 'ls' then
								choosedHospital = 'ls'
								RemoveItemsAfterRPDeath()
							elseif data.current.value == 'sandy' then
								choosedHospital = 'sandy'
								RemoveItemsAfterRPDeath()
							elseif data.current.value == 'paleto' then
								choosedHospital = 'paleto'
								RemoveItemsAfterRPDeath()
							end
							menu.close()
						end, function (data, menu)
							menu.close()
						end)
						pressStart = nil
						break
					end
				else
					pressStart = nil
				end
			end	
		end
	end)
end

function loadAnimDict(dict)
    RequestAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do        
        Citizen.Wait(1)
    end
end


--CHUJOWY KOD FALSZYWEGO
--[[
CreateThread(function()
    while true do
    	local player = GetPlayerPed(-1)
		local ragdoll = SetPedCanRagdoll(player, false)
        Citizen.Wait(0)
        if IsDead == true then
			exports.spawnmanager:setAutoSpawn(false)
			SetPedMaxHealth(player, 200)             
			SetEntityHealth(player, 101)
			loadAnimDict( "mini@cpr@char_b@cpr_def" )
			if not IsEntityPlayingAnim(playerPed, "mini@cpr@char_b@cpr_def", "cpr_pumpchest_idle", 3) then
				TaskPlayAnim(player, "mini@cpr@char_b@cpr_def", "cpr_pumpchest_idle", 100.0, 1.0, -1, 1, 0, 0, 0, 0)
			end
		end
 	end
end)]]

--kod by csskrouble
--[[CreateThread(function()
    while true do
        Citizen.Wait(500)
        local playerPed = PlayerPedId()
		local veh = GetVehiclePedIsIn(playerPed, false)
        if IsDead then
			deathAnim = true
            ClearPedTasksImmediately(playerPed)
			if veh ~= 0 then
				while (GetEntitySpeed(veh) * 3.6) > 10 do
					Citizen.Wait(100)
				end	
			end	
            CreateThread(function()
                while IsDead do
					SetPedCanRagdoll(playerPed, false)
					SetPedCanRagdollFromPlayerImpact(playerPed, false)
					SetEntityInvincible(playerPed, true)
					SetEntityCanBeDamaged(playerPed, false)
                    DisableAllControlActions(0)
                    EnableControlAction(0, 1)
                    EnableControlAction(0, 2)
                    EnableControlAction(0, Keys['G'], true)
                    EnableControlAction(0, Keys['H'], true)
                    EnableControlAction(0, Keys['T'], true)
					EnableControlAction(0, Keys['Z'], true)
                    EnableControlAction(0, Keys['E'], true)
                    EnableControlAction(0, Keys['N'], true)
                    EnableControlAction(0, Keys['DEL'], true)
                    EnableControlAction(0, Keys['F10'], true)
                    Citizen.Wait(1)
                end
                EnableAllControlActions(0)
            end)
            Citizen.Wait(200)
            SetEntityHealth(playerPed, GetPedMaxHealth(playerPed))
            ClearPedTasksImmediately(playerPed)
            --local lib, anim = 'random@drunk_driver_1', 'drunk_fall_over'
            --[[local lib, anim = 'move_fall', 'land_fall'
                Citizen.Wait(1000)
                while IsDead do
                    if not IsEntityPlayingAnim(playerPed, 'dead', 'dead_a', 3) and deathAnim then
                        ESX.Streaming.RequestAnimDict('dead', function()
                            TaskPlayAnim(playerPed, 'dead', 'dead_a', 8.0, 8.0, -1, 33, 0, 0, 0, 0)
                        end)
                        Citizen.Wait(500)
                    end
                    Citizen.Wait(50)
                end
				deathAnim = false
				SetPedCanRagdoll(playerPed, true)
				SetPedCanRagdollFromPlayerImpact(playerPed, true)
				SetEntityInvincible(playerPed, false)
				SetEntityCanBeDamaged(playerPed, true)
        end
    end
end)]]

CreateThread(function()
	while true do
		Citizen.Wait(2)

		if IsDead then
			DisableAllControlActions(0)
			EnableControlAction(0, Keys['G'], true)
			EnableControlAction(0, Keys['T'], true)
			EnableControlAction(0, Keys['E'], true)
			EnableControlAction(0, Keys['F5'], true)
			EnableControlAction(0, Keys['N'], true)
			EnableControlAction(0, Keys['HOME'], true)
			EnableControlAction(0, Keys['DELETE'], true)
			EnableControlAction(0, Keys['H'], true)
			EnableControlAction(0, 21, true)
			EnableControlAction(0, Keys['Z'], true)
			EnableControlAction(0, Keys['F5'], true)
			--drawTxt(0.905, 1.375, 1.0, 1.0, 0.4, 'Użyj komendy ~b~/bwrefresh~s~ aby odswieżyć swoją pozycję', 255, 255, 255, 255)
		else
			Citizen.Wait(500)
		end
	end
end)


--[[RegisterNetEvent('misiaczek:kill')
AddEventHandler('misiaczek:kill', function()
	local playerPed = PlayerPedId()
	Citizen.InvokeNative(0x6B76DC1F3AE6E6A3, playerPed, 0)
end)]]


function DeathFunc() 
	local playerPed = PlayerPedId()
	ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 2.0)
	CreateThread(function ()
		RequestAnimDict('dead')
		while not HasAnimDictLoaded('dead') do
			Citizen.Wait(0)
		end

		if IsPedInAnyVehicle(playerPed, false) then
			while IsPedInAnyVehicle(playerPed, true) do
				Citizen.Wait(0)
			end
		else
			if GetEntitySpeed(playerPed) > 0.2 then
				while GetEntitySpeed(playerPed) > 0.2 do
					Citizen.Wait(0)
				end
			end
		end

		local weapon = GetPedCauseOfDeath(playerPed)
		local sourceofdeath = GetPedSourceOfDeath(playerPed)
		local damagedbycar = false
		if weapon == 0 and sourceofdeath == 0 and HasEntityBeenDamagedByWeapon(playerPed, `WEAPON_RUN_OVER_BY_CAR`, 0) then
			damagedbycar = true
		end
		local coords = GetEntityCoords(playerPed)
		NetworkResurrectLocalPlayer(coords, 0.0, false, false)
		Citizen.Wait(100)
		SetEntityCoords(playerPed, coords)
		SetPlayerInvincible(PlayerId(), true)
		SetPlayerCanUseCover(PlayerId(), false)

		local knockoutDuration = 15000

		if weapon == `WEAPON_UNARMED` or ((weapon == `WEAPON_RUN_OVER_BY_CAR` or damagedbycar) and sourceofdeath ~= playerPed) or weapon == `WEAPON_NIGHTSTICK` then
			obezwladniony = true
			CreateThread(function() 
				exports["exile_taskbar"]:taskBar(knockoutDuration, "Odzyskujesz siły...", false, true)
			end)
			Citizen.SetTimeout(knockoutDuration, function() 
				RespawnPed(PlayerPedId(), GetEntityCoords(GetPlayerPed(-1)))
				Citizen.Wait(500)
				SetEntityHealth(PlayerPedId(), 170)
			end)
		end

		while IsDead do
			local playerPed = PlayerPedId()
			SetEntityInvincible(playerPed, true)
			SetEntityCanBeDamaged(playerPed, false)
			if not IsPedInAnyVehicle(playerPed, false) then
				if not IsEntityPlayingAnim(playerPed, 'dead', 'dead_a', 3) then
					TaskPlayAnim(playerPed, 'dead', 'dead_a', 1.0, 1.0, -1, 2, 0, 0, 0, 0)
				end
			end

			Citizen.Wait(1)
		end
		obezwladniony = false
		SetPlayerInvincible(PlayerId(), false)
		SetPlayerCanUseCover(PlayerId(), true)
		SetEntityInvincible(playerPed, false)
		SetEntityCanBeDamaged(playerPed, true)
		StopAnimTask(PlayerPedId(), 'dead', 'dead_a', 4.0)
		RemoveAnimDict('dead')
		EnableAllControlActions(0)
	end)
end

function OnPlayerDeath()
	if not IsDead then
		StartDeathCam()
		IsDead = true
		ESX.UI.Menu.CloseAll()
		TriggerServerEvent('esx_ambulancejob:setDeathStatus', 1)

		local playerPed = PlayerPedId()
		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed, false)
			if GetPedInVehicleSeat(vehicle, -1) == playerPed then
				SetVehicleEngineOn(vehicle, false, true, true)
				while GetEntitySpeed(vehicle) > 0.0 do
					local vehSpeed = GetEntitySpeed(vehicle)
					SetVehicleForwardSpeed(vehicle, (vehSpeed * 0.85))
					Citizen.Wait(300)
				end
			else
				SetEntityCoords(playerPed, GetEntityCoords(playerPed))
			end
		end

		StartDeathTimer()
		StartDistressSignal()

		Citizen.InvokeNative(0xAAA34F8A7CB32098, PlayerPedId())

		DeathFunc()
	else
		SetEntityHealth(PlayerPedId(), GetPedMaxHealth(PlayerPedId()))
	end	
end

function TeleportFadeEffect(entity, coords)

	CreateThread(function()

		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(0)
		end

		ESX.Game.Teleport(entity, coords, function()
			DoScreenFadeIn(800)
		end)
	end)
end

function WarpPedInClosestVehicle(ped)

	local coords = GetEntityCoords(ped)

	local vehicle, distance = ESX.Game.GetClosestVehicle({
		x = coords.x,
		y = coords.y,
		z = coords.z
	})

	if distance ~= -1 and distance <= 5.0 then

		local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
		local freeSeat = nil

		for i=maxSeats - 1, 0, -1 do
			if IsVehicleSeatFree(vehicle, i) then
				freeSeat = i
				break
			end
		end

		if freeSeat ~= nil then
			TaskWarpPedIntoVehicle(ped, vehicle, freeSeat)
		end

	else
		ESX.ShowNotification(_U('no_vehicles'))
	end
end

function OpenAmbulanceActionsMenu()

	local elements = {
		{label = 'Ubranie Służbowe', value = 'cloakroom'},
		{label = 'Ubrania Prywatne', value = 'player_dressing' },
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ambulance_actions', {
		title		= _U('ambulance'),
		align		= 'center',
		elements	= elements
	}, function(data, menu)
		if data.current.value == 'player_dressing' then
			ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
				local elements = {}
	
				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end
	
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
					title    = "Garderoba prywatna",
					align    = 'bottom-right',
					elements = elements
				}, function(data2, menu2)
					TriggerEvent('skinchanger:getSkin', function(skin)
						ESX.TriggerServerCallback('esx_property:getPlayerOutfit', function(clothes)
							TriggerEvent('skinchanger:loadClothes', skin, clothes)
							TriggerEvent('esx_skin:setLastSkin', skin)
	
							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
							end)
						end, data2.current.value)
					end)
				end, function(data2, menu2)
					menu2.close()
				end)
			end)
		elseif data.current.value == 'cloakroom' then
			OpenCloakroomMenu()
		end
	end, function(data, menu)
		menu.close()

		CurrentAction		= 'ambulance_actions_menu'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby się przebrać"
		CurrentActionData	= {}
	end)
end

function OpenMobileAmbulanceActionsMenu()

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_ambulance_actions',
	{
		title		= _U('ems_menu_title'),
		align		= 'center',
		elements	= {
			{label = ('Interakcje z cywilem'), value = 'citizen_interaction'},
			{label = ('Interakcje z pojazdem'), value = 'vehicle_interaction'},
			{label = ('Kajdanki'), value = 'Kajdanki'},
			{label = ('Tablet SAMS'), value = 'tablet'}
		}
	}, function(data, menu)
		if data.current.value == 'OpenRehabMenu' then					
			menu.close()
			OpenRehabMenu()
		elseif data.current.value == 'tablet' then
			menu.close()
			TriggerEvent('tabletmed')
		elseif data.current.value == 'Kajdanki' then
			menu.close()
			TriggerEvent('Kajdanki')
		elseif data.current.value == 'citizen_interaction' then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction',
			{
				title		= _U('ems_menu_title'),
				align		= 'center',
				elements	= {
					{label = ('Zbadaj pacjenta'), value = 'zbadaj'},
					{label = ('Ożywa obywatela'), value = 'revive'},
					{label = ('Ulecz małe rany'), value = 'small'},
					{label = ('Ulecz poważne rany'), value = 'big'},
					{label = ('Wsadz do pojazdu'), value = 'put_in_vehicle'},
					{label = ('Wyciągnij z pojazdu'), value = 'out_vehicle'},
					
				}
			}, function(data, menu)
				if IsBusy then 
					return 
				end
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

						if closestPlayer == -1 or closestDistance > 1.0 then
							ESX.ShowNotification('~r~Brak graczy w pobliżu')
						else
		
							if data.current.value == 'revive' then
		
								ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
									if quantity > 0 then
										local closestPlayerPed = Citizen.InvokeNative(0x43A66C31C68491C0, closestPlayer)
		
										if IsPedDeadOrDying(closestPlayerPed, 1) or IsEntityPlayingAnim(closestPlayerPed, 'dead', 'dead_a', 3) then
											local playerPed = PlayerPedId()
		
											IsBusy = true
											ESX.ShowNotification(_U('revive_inprogress'))
		
											local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'
		
											for i=1, 7, 1 do
												Citizen.Wait(900)
										
												ESX.Streaming.RequestAnimDict(lib, function()
													TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
												end)
											end
		
											TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
											TriggerServerEvent('hypex_ambulancejob:hypexrevive', GetPlayerServerId(closestPlayer))
											IsBusy = false
		
											-- Show revive award?
											if Config.ReviveReward > 0 then
												ESX.ShowNotification(_U('revive_complete_award', GetPlayerName(closestPlayer), Config.ReviveReward))
											else
												ESX.ShowNotification(_U('revive_complete', GetPlayerName(closestPlayer)))
											end
										else
											ESX.ShowNotification(_U('player_not_unconscious'))
										end
									else
										ESX.ShowNotification(_U('not_enough_medikit'))
									end
								end, 'medikit')
							
							elseif data.current.value == 'zbadaj' then
								if IsPlayerDead(closestPlayer) then
									menu.close()
		
									RequestAnimDict('amb@medic@standing@kneel@base')
									while not HasAnimDictLoaded('amb@medic@standing@kneel@base') do
										Citizen.Wait(0)
									end
		
									RequestAnimDict('anim@gangops@facility@servers@bodysearch@')
									while not HasAnimDictLoaded('anim@gangops@facility@servers@bodysearch@') do
										Citizen.Wait(0)
									end
		
									local closestPlayerPed = Citizen.InvokeNative(0x43A66C31C68491C0, closestPlayer)
									ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_ambulance_actions_test', {
										title= 'EMS - Badanie pacjetna',
										align= 'center',
										elements = {
											{label = 'Zbadaj przyczynę utraty przytomności', value = 'death'},
											{label = 'Zbadaj uszkodzenia ciała', value = 'damage'}
										}
									}, function(data2, menu2)
										menu2.close()
		
										local ac = data2.current.value
										if ac == 'damage' then
											local success, bone = GetPedLastDamageBone(closestPlayerPed)
											if success then
												local x, y, z = table.unpack(GetPedBoneCoords(closestPlayerPed, bone))
		
												local timestamp = GetGameTimer()
												while (timestamp + 10000) > GetGameTimer() do
													Citizen.Wait(0)
													DrawText3D(x, y, z, '~g~*', 0.6)
												end
											else
												ESX.ShowNotification('~r~Nie jesteś w stanie zbadać, gdzie pacjent doznał obrażeń')
											end
										elseif ac == 'death' then
											IsBusy = true
											ESX.ShowNotification('Rozpoczynasz ~y~badanie ~s~pacjenta')
		
											local playerPed = PlayerPedId()
											TaskPlayAnim(playerPed, "amb@medic@standing@kneel@base", "base", 8.0, -8.0, -1, 1, 0, false, false, false)
											TaskPlayAnim(playerPed, "anim@gangops@facility@servers@bodysearch@", "player_search", 8.0, -8.0, -1, 48, 0, false, false, false)
		
											Citizen.Wait(5000)
											Citizen.InvokeNative(0xAAA34F8A7CB32098, playerPed)
											IsBusy = false
		
											local d = GetPedCauseOfDeath(closestPlayerPed)
											if checkArray(Melee, d) then
												ESX.ShowNotification(_U('dc_hardmeele'))
											elseif checkArray(Bullet, d) then
												ESX.ShowNotification(_U('dc_bullet'))
											elseif checkArray(Knife, d) then
												ESX.ShowNotification(_U('dc_knifes'))
											elseif checkArray(Electricity, d) then
												ESX.ShowNotification(_U('dc_electricity'))
											elseif checkArray(Animal, d) then
												ESX.ShowNotification(_U('dc_bitten'))
											elseif checkArray(FallDamage, d) then
												ESX.ShowNotification(_U('dc_brokenlegs'))
											elseif checkArray(Explosion, d) then
												ESX.ShowNotification(_U('dc_explosive'))
											elseif checkArray(Gas, d) then
												ESX.ShowNotification(_U('dc_gas'))
											elseif checkArray(Burn, d) then
												ESX.ShowNotification(_U('dc_fire'))
											elseif checkArray(Drown, d) then
												ESX.ShowNotification(_U('dc_drown'))
											elseif checkArray(Car, d) then
												ESX.ShowNotification(_U('dc_caraccident'))
											else
												ESX.ShowNotification(_U('dc_unknown'))
											end
										end
									end, function(data2, menu2)
										menu2.close()
									end)
								else
									ESX.ShowNotification(_U('player_not_conscious'))
								end	
							elseif data.current.value == 'small' then
		
								ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
									if quantity > 0 then
										local closestPlayerPed = Citizen.InvokeNative(0x43A66C31C68491C0, closestPlayer)
										local health = GetEntityHealth(closestPlayerPed)
		
										if health > 0 then
											local playerPed = PlayerPedId()
		
											IsBusy = true
											ESX.ShowNotification(_U('heal_inprogress'))
											TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
											Citizen.Wait(10000)
											ClearPedTasks(playerPed)
		
											TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
											TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'small')
											ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
											IsBusy = false
										else
											ESX.ShowNotification(_U('player_not_conscious'))
										end
									else
										ESX.ShowNotification(_U('not_enough_bandage'))
									end
								end, 'bandage')
		
							elseif data.current.value == 'big' then
		
								ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
									if quantity > 0 then
										local closestPlayerPed = Citizen.InvokeNative(0x43A66C31C68491C0, closestPlayer)
										local health = GetEntityHealth(closestPlayerPed)
		
										if health > 0 then
											local playerPed = PlayerPedId()
		
											IsBusy = true
											ESX.ShowNotification(_U('heal_inprogress'))
											TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
											Citizen.Wait(10000)
											ClearPedTasks(playerPed)
		
											TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
											TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
											ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
											IsBusy = false
										else
											ESX.ShowNotification(_U('player_not_conscious'))
										end
									else
										ESX.ShowNotification(_U('not_enough_medikit'))
									end
								end, 'medikit')
		
							elseif data.current.value == 'put_in_vehicle' then
								TriggerServerEvent('xlem0n_policejob:putInVehicle', GetPlayerServerId(closestPlayer))
							elseif data.current.value == 'out_vehicle' then
								TriggerServerEvent('xlem0n_policejob:OutVehicle', GetPlayerServerId(closestPlayer))
							end

					
				end
			end, function(data, menu)
				menu.close()
			end)
		elseif data.current.value == 'vehicle_interaction' then
			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_interaction',
			{
				title		= _U('ems_menu_title'),
				align		= 'center',
				elements	= {
					{label = ('Napraw pojazd'), value = 'repair'},
					{label = ('Odholuj pojazd'), value = 'impound_vehicle'},
				}
			}, function(data, menu)
				local vehicle = ESX.Game.GetVehicleInDirection()
				if IsPedSittingInAnyVehicle(playerPed) then
					ESX.ShowNotification('Nie możesz tego w aucie zrobić!')
					return
				end
					
				if not IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
					ESX.ShowNotification('~r~Brak pojazdu w pobliżu')
				else

					if data.current.value == 'repair' then
						if(not IsPedInAnyVehicle(playerPed)) then
							TriggerEvent('esx_mechanicjobdrugi:onFixkitFree')
						end
					elseif data.current.value == 'hijack' then
						if(not IsPedInAnyVehicle(playerPed)) then
							TriggerServerEvent('exile:pay', 1500)
							menu.close()
							TriggerEvent('esx_mechanicjobdrugi:onHijack')
						end
					elseif data.current.value == 'impound_vehicle' then
						local playerPed = PlayerPedId()
						local coords    = GetEntityCoords(playerPed)	 
						if CurrentTask.Busy then
							return
						end
				
						ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~ żeby unieważnić ~y~zajęcie~s~')
						TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
				
						CurrentTask.Busy = true
						CurrentTask.Task = ESX.SetTimeout(10000, function()
							ClearPedTasks(playerPed)
							vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
							ESX.Game.DeleteVehicle(vehicle)
				
							CurrentTask.Busy = false
							Citizen.Wait(100)
						end)
				
						-- keep track of that vehicle!
						CreateThread(function()
							while CurrentTask.Busy do
								Citizen.Wait(1000)
				
								vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
								if not DoesEntityExist(vehicle) and CurrentTask.Busy then
									ESX.ShowNotification(_U(action .. '_canceled_moved'))
									ESX.ClearTimeout(CurrentTask.Task)
				
									ClearPedTasks(playerPed)
									CurrentTask.Busy = false
									break
								end
							end
						end)
					end

					
				end
			end, function(data, menu)
				menu.close()
			end)		
		end

	end, function(data, menu)
		menu.close()
	end)
end


function OpenCloakroomMenu()

	ESX.UI.Menu.CloseAll()
	local playerPed = PlayerPedId()
	local grade = PlayerData.job.grade_name

	local elements = {
		{label = "Zejdź ze służby", value = 'citizen_wear'},
		{label = "Wejdź na służbę", value = 'ambulance_wear'},
	}

	if PlayerData.job.name == 'ambulance' then
		table.insert(elements, {label = 'Ubrania Służbowe', value = 'alluniforms'})
	end



	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
	{
		title    = _U('cloakroom'),
		align    = 'right',
		elements = elements
	}, function(data, menu)

		cleanPlayer(playerPed)

		if data.current.value == 'ambulance_wear' then
			menu.close()
			setUniform('pielegniarz_wear', playerPed)
			if PlayerData.job.name == 'offambulance' then
				TriggerServerEvent('exile:setJob', 'ambulance', true)
				ESX.ShowNotification('~b~Wchodzisz na służbę')
			end
		end
		
		if data.current.value == 'citizen_wear' then
			menu.close()
			if PlayerData.job.name == 'ambulance' then
				ESX.ShowNotification('~b~Schodzisz ze służby')
				TriggerServerEvent('exile:setJob', 'ambulance', false)
			end
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		end

		if data.current.value == 'alluniforms' then
			local elements2 = {
				{label = "Nurse", value = 'pielegniarz_wear'},
				{label = "Paramedic", value = 'ratownik_wear'},
				{label = "Senior Paramedic", value = 'stratownik_wear'},
				{label = "Doctor", value = 'lekarz_wear'},
				{label = "Senior Doctor", value = 'lekarzsoru_wear'},
				{label = "Medical Specialist", value = 'lekarzspecjalista_wear'},
				{label = "Assistant Neurosurgeon", value = 'doktor_wear'},
				{label = "Surgeon", value = 'chirurg_wear'},
				{label = "Neurosurgeon ", value = 'neurochirurg_wear'},
			}

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'alluniforms', {
				title    = "Szatnia - SAMS",
				align    = 'right',
				elements = elements2
			}, function(data2, menu2)
				setUniform(data2.current.value, playerPed)
			end, function(data2, menu2)
				menu2.close()
			end)
		end

	if
		data.current.value == 'pielegniarz_wear' or
		data.current.value == 'ratownik_wear' or
		data.current.value == 'stratownik_wear' or
		data.current.value == 'lekarz_wear' or
		data.current.value == 'lekarzsoru_wear' or
		data.current.value == 'lekarzspecjalista_wear' or
		data.current.value == 'doktor_wear' or
		data.current.value == 'chirurg_wear' or
		data.current.value == 'neurochirurg_wear'
	then
		setUniform(data.current.value, playerPed)
	end

	end, function(data, menu)
		menu.close()
		
		CurrentAction		= 'ambulance_actions_menu'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby się przebrać"
		CurrentActionData	= {}

	end)
end

function SetVehicleMaxMods(vehicle, livery, offroad, wheelsxd, color, extrason, extrasoff, bulletproof, tint, wheel, tuning, plate)
	local t = {
		modArmor        = 4,
		modTurbo        = true,
		modXenon        = true,
		windowTint      = 0,
		dirtLevel       = 0,
		color1			= 0,
		color2			= 0
	}
	
	if tuning then
		t.modEngine = 3
		t.modBrakes = 2
		t.modTransmission = 2
		t.modSuspension = 3
	end

	if offroad then
		t.wheelColor = 5
		t.wheels = 4
		t.modFrontWheels = 17
	end

	if wheelsxd then
		t.wheels = 1
		t.modFrontWheels = 5
	end

	if bulletproof then
		t.bulletProofTyre = true
	end

	if color then
		t.color1 = color
	end

	if tint then
		t.windowTint = tint
	end

	if wheel then
		t.wheelColor = wheel.color
		t.wheels = wheel.group
		t.modFrontWheels = wheel.type
	end
	
	ESX.Game.SetVehicleProperties(vehicle, t)

	if #extrason > 0 then
		for i=1, #extrason do
			SetVehicleExtra(vehicle, extrason[i], false)
		end
	end
	
	if #extrasoff > 0 then
		for i=1, #extrasoff do
			SetVehicleExtra(vehicle, extrasoff[i], true)
		end
	end
	  
	if livery then
		SetVehicleLivery(vehicle, livery)
	end
end

function CanPlayerUseHidden(grade)
	return not grade or PlayerData.hiddenjob.grade >= grade
end

function CanPlayerUse(grade)
	return not grade or PlayerData.job.grade >= grade
end

function OpenVehicleSpawnerMenu(partNum)
	local vehicles = Config.Ambulance.Vehicles
	
	ESX.UI.Menu.CloseAll()
	local elements = {}
	local found = true
	
	for i, group in ipairs(Config.VehicleGroups) do
		local elements2 = {}
		
		for _, vehicle in ipairs(Config.AuthorizedVehicles) do
			local let = false
			for _, group in ipairs(vehicle.groups) do
				if group == i then
					let = true
					break
				end
			end

			if let then
				if vehicle.grade then
					if vehicle.hidden == true then
						if i ~= 5 then
							if not CanPlayerUseHidden(vehicle.grade) then
								let = false
							end
						else
							if not CanPlayerUseHidden(vehicle.grade) and not CanPlayerUse(vehicle.grade) then
								let = false
							end
						end
					else
						if not CanPlayerUse(vehicle.grade) then
							let = false
						end
					end
				elseif vehicle.grades and #vehicle.grades > 0 then
					let = false
					for _, grade in ipairs(vehicle.grades) do
						if ((vehicle.swat and IsSWAT) or grade == PlayerData.job.grade) and (not vehicle.label:find('SEU') or IsSEU) then
							let = true
							break
						end
					end
				end

				if let then
					table.insert(elements2, { label = vehicle.label, model = vehicle.model, livery = vehicle.livery, extrason = vehicle.extrason, extrasoff = vehicle.extrasoff, offroad = vehicle.offroad, wheelsxd = vehicle.wheelsxd, color = vehicle.color, plate = vehicle.plate, tint = vehicle.tint, bulletproof = vehicle.bulletproof, wheel = vehicle.wheel, tuning = vehicle.tuning })
				end
			end
		end
			
		if (PlayerData.job.name == 'ambulance' and PlayerData.job.grade >= 12) or (PlayerData.hiddenjob.name == 'sheriff' and PlayerData.hiddenjob.grade >= 11) then
			if #elements2 > 0 then
				table.insert(elements, {label = group, value = elements2, group = i})				
			end
		else
			if i == 5 then
				found = false
				ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
					if hasWeaponLicense then
						table.insert(elements, { label = group, value = elements2, group = i })
					end
					
					found = true
				end, GetPlayerServerId(PlayerId()), 'seu')
			elseif i == 6 then
				found = false
				ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
					if hasWeaponLicense then
						table.insert(elements, { label = group, value = elements2, group = i })
					end
					
					found = true
				end, GetPlayerServerId(PlayerId()), 'dtu')
			elseif i == 7 then
				found = false
				ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
					if hasWeaponLicense then
						table.insert(elements, { label = group, value = elements2, group = i })
					end
					
					found = true
				end, GetPlayerServerId(PlayerId()), 'sert')
			elseif i == 8 then
				if PlayerData.hiddenjob.name == 'sheriff' then
					table.insert(elements, { label = group, value = elements2, group = i })
				end
			elseif i == 9 then
				found = false
				ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
					if hasWeaponLicense then
						table.insert(elements, { label = group, value = elements2, group = i })
					end
					
					found = true
				end, GetPlayerServerId(PlayerId()), 'usms')
			elseif i == 10 then
				if PlayerData.hiddenjob.name == 'hwp' then
					table.insert(elements, { label = group, value = elements2, group = i })
				end
			elseif i == 11 then
				if PlayerData.hiddenjob.name == 'hwp' then
					table.insert(elements, { label = group, value = elements2, group = i })
				end
			else
				table.insert(elements, { label = group, value = elements2, group = i })
			end
		end
	end
	
	while not found do
		Citizen.Wait(100)
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
	  title    = _U('vehicle_menu'),
	  align    = 'right',
	  elements = elements
	}, function(data, menu)
		menu.close()
		if type(data.current.value) == 'table' and #data.current.value > 0 then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner_' .. data.current.group, {
				title    = data.current.label,
				align    = 'right',
				elements = data.current.value
			}, function(data2, menu2)
				local livery = data2.current.livery
				local extrason = data2.current.extrason
				local extrasoff = data2.current.extrasoff
				local offroad = data2.current.offroad
				local wheelsxd = data2.current.wheelsxd
				local color = data2.current.color
				local bulletproof = data2.current.bulletproof or false
				local tint = data2.current.tint
				local wheel = data2.current.wheel
				local tuning = data2.current.tuning

				local setPlate = true
				if data2.current.plate ~= nil and not data2.current.plate then
					setPlate = false
				end

				local vehicle = GetClosestVehicle(vehicles[partNum].spawnPoint.x,  vehicles[partNum].spawnPoint.y,  vehicles[partNum].spawnPoint.z, 3.0, 0, 71)
				if not DoesEntityExist(vehicle) then
					local playerPed = PlayerPedId()
					if Config.MaxInService == -1 then
						ESX.Game.SpawnVehicle(data2.current.model, {
							x = vehicles[partNum].spawnPoint.x,
							y = vehicles[partNum].spawnPoint.y,
							z = vehicles[partNum].spawnPoint.z
						}, vehicles[partNum].heading, function(vehicle)
							SetVehicleMaxMods(vehicle, livery, offroad, wheelsxd, color, data2.current.extrason, data2.current.extrasoff, bulletproof, tint, wheel, tuning)
							
							if setPlate then
								local plate = ""
								if data.current.label == 'PATROL' then
									plate = math.random(100, 999) .. "SAMS" .. math.random(100, 999)
								elseif data.current.label == 'HP UNMARKED' then
									plate = math.random(100, 999) .. "SAMS" .. math.random(100, 999)
								elseif PlayerData.hiddenjob.name == 'sheriff' then
									plate = "SAMS " .. math.random(100,999)
								elseif PlayerData.hiddenjob.name == 'hwp' then
									plate = "SAMS " .. math.random(100,999)
								else
									plate = "SAMS " .. math.random(100,999)
								end
								
								SetVehicleNumberPlateText(vehicle, plate)
								local localVehPlate = string.lower(GetVehicleNumberPlateText(vehicle))
								TriggerEvent('ls:dodajklucze2', localVehPlate)
							else
								local localVehPlate = string.lower(GetVehicleNumberPlateText(vehicle))
								TriggerEvent('ls:dodajklucze2', localVehPlate)
							end

							TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
						end)
					else
						ESX.Game.SpawnVehicle(data2.current.model, {
							x = vehicles[partNum].spawnPoint.x,
							y = vehicles[partNum].spawnPoint.y,
							z = vehicles[partNum].spawnPoint.z
						}, vehicles[partNum].heading, function(vehicle)
							SetVehicleMaxMods(vehicle, livery, offroad, wheelsxd, color, data2.current.extrason, data2.current.extrasoff, bulletproof, tint, wheel, tuning)

							if setPlate then
								local plate = ""
								
								if data.current.label == 'PATROL' then
									plate = math.random(100, 999) .. "SAMS" .. math.random(100, 999)
								elseif PlayerData.hiddenjob.name == 'sheriff' then
									plate = "SAMS " .. math.random(100,999)
								else
									plate = "SAMS " .. math.random(100,999)
								end
								
								SetVehicleNumberPlateText(vehicle, plate)
								local localVehPlate = string.lower(GetVehicleNumberPlateText(vehicle))
								TriggerEvent('ls:dodajklucze2', localVehPlate)
							else
								local localVehPlate = string.lower(GetVehicleNumberPlateText(vehicle))
								TriggerEvent('ls:dodajklucze2', localVehPlate)
							end

							TaskWarpPedIntoVehicle(playerPed,  vehicle,  -1)
						end)
					end
				else
					ESX.ShowNotification('Pojazd znaduje się w miejscu wyciągnięcia następnego')
				end
			end, function(data2, menu2)
				menu.close()
				OpenVehicleSpawnerMenu(partNum)
			end)
		else
			ESX.ShowNotification("~r~Brak pojazdów dostępnych w tej kategorii dla twojego stopnia.")
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_vehicle_spawner'
		CurrentActionMsg  = _U('vehicle_spawner')
		CurrentActionData = {station = station, partNum = partNum}
	end)
end

function OpenHeliSpawnerMenu(zoneNumber)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'heli_spawner',
	{
		title		= "Helikoptery",
		align		= 'center',
		elements	= Config.AuthorizedHeli
	}, function(data, menu)
		menu.close()
		ESX.Game.SpawnVehicle(data.current.model, Config.Ambulance.Helicopters[zoneNumber].spawnPoint, Config.Ambulance.Helicopters[zoneNumber].heading, function(vehicle)
			local playerPed = PlayerPedId()
			local plate = "SAMS " .. math.random(100,999)
			SetVehicleNumberPlateText(vehicle, plate)
			local localVehPlate = string.lower(GetVehicleNumberPlateText(vehicle))
			TriggerEvent('ls:dodajklucze2', localVehPlate)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		end)
	end, function(data, menu)
		menu.close()
		CurrentAction		= 'heli_spawner_menu'
		CurrentActionMsg	= 'Naciśnij ~INPUT_CONTEXT~ aby wyciągnąć helikopter.'
		CurrentActionData	= {zoneNumber = zoneNumber}
	end
	)
end

function OpenBoatSpawnerMenu(zoneNumber)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boat_spawner',
	{
		title		= "Garaż łodzi",
		align		= 'center',
		elements	= Config.AuthorizedBoats
	}, function(data, menu)
		menu.close()

		ESX.Game.SpawnVehicle(data.current.model, Config.Ambulance.Boats[zoneNumber].spawnPoint, Config.Ambulance.Boats[zoneNumber].heading, function(vehicle)
			local playerPed = PlayerPedId()
			local plate = "SAMS " .. math.random(100,999)
			SetVehicleNumberPlateText(vehicle, plate)
			local localVehPlate = string.lower(GetVehicleNumberPlateText(vehicle))
			TriggerEvent('ls:dodajklucze2', localVehPlate)
			TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		end)
	end, function(data, menu)
		menu.close()
		CurrentAction		= 'boat_spawner_menu'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~ aby wyciągnąć łódź"
		CurrentActionData	= {zoneNumber = zoneNumber}
	end)
end

function OpenPharmacyMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'pharmacy',
	{
		title		= _U('pharmacy_menu_title'),
		align		= 'center',
		elements = {
			{label = _U('pharmacy_take') .. ' ' .. _('medikit'), value = 'medikit'},
			{label = _U('pharmacy_take') .. ' ' .. _('bandage'), value = 'bandage'},
			{label = _U('pharmacy_take') .. ' ' .. "Gps", value = 'gps', count = 1},
			{label = _U('pharmacy_take') .. ' ' .. "BodyCam", value = 'bodycam', count = 1},
			{label = _U('pharmacy_take') .. ' ' .. "Radio", value = 'radio', count = 1},
		},
	}, function(data, menu)
		TriggerServerEvent('esx_ambulancejob:giveItem', data.current.value, data.current.count)

	end, function(data, menu)
		menu.close()
		CurrentAction		= 'pharmacy'
		CurrentActionMsg	= _U('open_pharmacy')
		CurrentActionData	= {}
	end
	)
end

AddEventHandler('playerSpawned', function()
	EndDeathCam()
	IsDead = false

	if FirstSpawn then
		FirstSpawn = false
		CreateThread(function()
			local status = 0
			while true do
				if status == 0 then
					status = 1 
					TriggerEvent('misiaczek:load', function(result)
						if result == 3 then
							status = 2
						else
							status = 0
						end
					end)
				end
				
				Citizen.Wait(200)
				if status == 2 then
					break
				end
			end
			
			exports.spawnmanager:setAutoSpawn(false)
		end)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	ESX.TriggerServerCallback('esx_license:checkLicense', function(lickajest)
		if lickajest then
			heli = true
		else
			heli = false
		end
	end, GetPlayerServerId(PlayerId()), 'sams_heli')
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	deleteBlip()
	refreshBlip()
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)

	local specialContact = {
	name		= 'Ambulance',
	number		= 'ambulance',
	base64Icon	= 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAALEwAACxMBAJqcGAAABp5JREFUWIW1l21sFNcVhp/58npn195de23Ha4Mh2EASSvk0CPVHmmCEI0RCTQMBKVVooxYoalBVCVokICWFVFVEFeKoUdNECkZQIlAoFGMhIkrBQGxHwhAcChjbeLcsYHvNfsx+zNz+MBDWNrYhzSvdP+e+c973XM2cc0dihFi9Yo6vSzN/63dqcwPZcnEwS9PDmYoE4IxZIj+ciBb2mteLwlZdfji+dXtNU2AkeaXhCGteLZ/X/IS64/RoR5mh9tFVAaMiAldKQUGiRzFp1wXJPj/YkxblbfFLT/tjq9/f1XD0sQyse2li7pdP5tYeLXXMMGUojAiWKeOodE1gqpmNfN2PFeoF00T2uLGKfZzTwhzqbaEmeYWAQ0K1oKIlfPb7t+7M37aruXvEBlYvnV7xz2ec/2jNs9kKooKNjlksiXhJfLqf1PXOIU9M8fmw/XgRu523eTNyhhu6xLjbSeOFC6EX3t3V9PmwBla9Vv7K7u85d3bpqlwVcvHn7B8iVX+IFQoNKdwfstuFtWoFvwp9zj5XL7nRlPXyudjS9z+u35tmuH/lu6dl7+vSVXmDUcpbX+skP65BxOOPJA4gjDicOM2PciejeTwcsYek1hyl6me5nhNnmwPXBhjYuGC699OpzoaAO0PbYJSy5vgt4idOPrJwf6QuX2FO0oOtqIgj9pDU5dCWrMlyvXf86xsGgHyPeLos83Brns1WFXLxxgVBorHpW4vfQ6KhkbUtCot6srns1TLPjNVr7+1J0PepVc92H/Eagkb7IsTWd4ZMaN+yCXv5zLRY9GQ9xuYtQz4nfreWGdH9dNlkfnGq5/kdO88ekwGan1B3mDJsdMxCqv5w2Iq0khLs48vSllrsG/Y5pfojNugzScnQXKBVA8hrX51ddHq0o6wwIlgS8Y7obZdUZVjOYLC6e3glWkBBVHC2RJ+w/qezCuT/2sV6Q5VYpowjvnf/iBJJqvpYBgBS+w6wVB5DLEOiTZHWy36nNheg0jUBs3PoJnMfyuOdAECqrZ3K7KcACGQp89RAtlysCphqZhPtRzYlcPx+ExklJUiq0le5omCfOGFAYn3qFKS/fZAWS7a3Y2wa+GJOEy4US+B3aaPUYJamj4oI5LA/jWQBt5HIK5+JfXzZsJVpXi/ac8+mxWIXWzAG4Wb4g/jscNMp63I4U5FcKaVvsNyFALokSA47Kx8PVk83OabCHZsiqwAKEpjmfUJIkoh/R+L9oTpjluhRkGSPG4A7EkS+Y3HZk0OXYpIVNy01P5yItnptDsvtIwr0SunqoVP1GG1taTHn1CloXm9aLBEIEDl/IS2W6rg+qIFEYR7+OJTesqJqYa95/VKBNOHLjDBZ8sDS2998a0Bs/F//gvu5Z9NivadOc/U3676pEsizBIN1jCYlhClL+ELJDrkobNUBfBZqQfMN305HAgnIeYi4OnYMh7q/AsAXSdXK+eH41sykxd+TV/AsXvR/MeARAttD9pSqF9nDNfSEoDQsb5O31zQFprcaV244JPY7bqG6Xd9K3C3ALgbfk3NzqNE6CdplZrVFL27eWR+UASb6479ULfhD5AzOlSuGFTE6OohebElbcb8fhxA4xEPUgdTK19hiNKCZgknB+Ep44E44d82cxqPPOKctCGXzTmsBXbV1j1S5XQhyHq6NvnABPylu46A7QmVLpP7w9pNz4IEb0YyOrnmjb8bjB129fDBRkDVj2ojFbYBnCHHb7HL+OC7KQXeEsmAiNrnTqLy3d3+s/bvlVmxpgffM1fyM5cfsPZLuK+YHnvHELl8eUlwV4BXim0r6QV+4gD9Nlnjbfg1vJGktbI5UbN/TcGmAAYDG84Gry/MLLl/zKouO2Xukq/YkCyuWYV5owTIGjhVFCPL6J7kLOTcH89ereF1r4qOsm3gjSevl85El1Z98cfhB3qBN9+dLp1fUTco+0OrVMnNjFuv0chYbBYT2HcBoa+8TALyWQOt/ImPHoFS9SI3WyRajgdt2mbJgIlbREplfveuLf/XXemjXX7v46ZxzPlfd8YlZ01My5MUEVdIY5rueYopw4fQHkbv7/rZkTw6JwjyalBCHur9iD9cI2mU0UzD3P9H6yZ1G5dt7Gwe96w07dl5fXj7vYqH2XsNovdTI6KMrlsAXhRyz7/C7FBO/DubdVq4nBLPaohcnBeMr3/2k4fhQ+Uc8995YPq2wMzNjww2X+vwNt1p00ynrd2yKDJAVN628sBX1hZIdxXdStU9G5W2bd9YHR5L3f/CNmJeY9G8WAAAAAElFTkSuQmCC'
	}

	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)

end)

AddEventHandler('esx:onPlayerDeath', function(reason)
	OnPlayerDeath()
end)

RegisterNetEvent('esx_healthnarmour:set')
AddEventHandler('esx_healthnarmour:set', function(health, armour)
	local status = 0
	while true do
		if status == 0 then
			status = 1
			TriggerEvent('misiaczek:load', function(result)
				if result == 3 then
					status = 2
				else
					status = 0
				end
			end)
		end
		
		Citizen.Wait(200)
		if status == 2 then
			break
		end
	end
	SetEntityHealth(PlayerPedId(), tonumber(health))
	Citizen.InvokeNative(0xCEA04D83135264CC, PlayerPedId(), tonumber(armour))
	if tonumber(health) == 0 then
		ESX.ShowNotification('~r~Jesteś nieprzytomny/a, ponieważ przed wyjściem z serwera Twoja postać miała BW')
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(5)
		
		if blockShooting > GetGameTimer() then
			SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)
		else
			Citizen.Wait(2000)
		end
	end
end)

function IsBlockWeapon()
	return blockShooting > GetGameTimer()
end

RegisterNetEvent('hypex_ambulancejob:hypexrevive')
AddEventHandler('hypex_ambulancejob:hypexrevive', function(notBlock)
	if notBlock == nil then
		notBlock = false
	end
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	if IsDead and not notBlock then
		TriggerServerEvent('exile_wypadanie:bron')
		blockShooting = GetGameTimer() + (5 * 60000)
	end
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', 0)

	DoScreenFadeOut(800)

	Citizen.Wait(800)
	
	local formattedCoords = {
		x = ESX.Math.Round(coords.x, 1),
		y = ESX.Math.Round(coords.y, 1),
		z = ESX.Math.Round(coords.z, 1)
	}

	ESX.SetPlayerData('lastPosition', formattedCoords)
	ESX.SetPlayerData('loadout', {})
	TriggerServerEvent('esx:updateCoords', formattedCoords)
	RespawnPed(playerPed, formattedCoords, 0.0)

	StopScreenEffect('DeathFailOut')
	DoScreenFadeIn(800)
end)

CreateThread(function()
	local lastHealth = Citizen.InvokeNative(0xEEF059FAD016D209, PlayerPedId())
	while true do
		Citizen.Wait(1000)
		local myPed = PlayerPedId()
		local health = Citizen.InvokeNative(0xEEF059FAD016D209, myPed)
		if HasEntityBeenDamagedByWeapon(myPed, `WEAPON_RAMMED_BY_CAR`, 0) then
			ClearEntityLastDamageEntity(myPed)
			if (health ~= lastHealth) then
				Citizen.InvokeNative(0x6B76DC1F3AE6E6A3, myPed, lastHealth)
			end
		end
		lastHealth = health
	end
end)

RegisterNetEvent('hypex_ambulancejob:hypexreviveblack')
AddEventHandler('hypex_ambulancejob:hypexreviveblack', function(admin)
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	if IsDead then
		TriggerServerEvent('exile_wypadanie:bron')
	end
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', 0)

	DoScreenFadeOut(800)

	Citizen.Wait(800)

	local formattedCoords = {
		x = ESX.Math.Round(coords.x, 1),
		y = ESX.Math.Round(coords.y, 1),
		z = ESX.Math.Round(coords.z, 1)
	}

	ESX.SetPlayerData('lastPosition', formattedCoords)
	ESX.SetPlayerData('loadout', {})
	TriggerServerEvent('esx:updateCoords', formattedCoords)
	RespawnPed(playerPed, formattedCoords, 0.0)

	if admin and admin ~= nil then
		TriggerEvent("esx:showNotification", "~g~Zostałeś ożywiony przez administratora ~b~"..admin.."~g~!")
	end

	StopScreenEffect('DeathFailOut')
	DoScreenFadeIn(800)
end)

CreateThread(function()
	while true do
		Citizen.Wait(2)
		if IsDead then
			DisableControlAction(0, 288, true)
			DisableControlAction(0, 170, true)
			DisableControlAction(0, 56, true)
			exports["pma-voice"]:SetMumbleProperty("radioEnabled", false)
		else
			Citizen.Wait(500)
			exports["pma-voice"]:SetMumbleProperty("radioEnabled", true)
		end
	end
end)

function RestrictedMenu()
	ESX.UI.Menu.CloseAll()
	
	TriggerEvent('skinchanger:getSkin', function(skin)
		currentSkin = skin
	end)
	
	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)
		menu.close()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
			title = _U('valid_this_purchase'),
			align = 'right',
			elements = {
				{label = _U('no'), value = 'no'},
				{label = _U('yes'), value = 'yes'}
			}
		}, function(data, menu)
			menu.close()

			local t = true
			if data.current.value == 'yes' then
				ESX.TriggerServerCallback('esx_clotheshop:buyClothes', function(bought)
					if bought then
						
						TriggerEvent('skinchanger:getSkin', function(skin)
							TriggerServerEvent('esx_skin:save', skin)
							currentSkin = skin
						end)

						ESX.TriggerServerCallback('esx_clotheshop:checkPropertyDataStore', function(foundStore)
							if foundStore then
								ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'save_dressing',
								{
									title = _U('save_in_dressing'),
									align = 'right',
									elements = {
										{label = _U('no'),  value = 'no'},
										{label = _U('yes'), value = 'yes'}
									}
								}, function(data2, menu2)
									menu2.close()

									if data2.current.value == 'yes' then
										ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'outfit_name', {
											title = _U('name_outfit')
										}, function(data3, menu3)
											menu3.close()

											TriggerEvent('skinchanger:getSkin', function(skin)
												TriggerServerEvent('esx_clotheshop:saveOutfit', data3.value, skin)
												ESX.ShowNotification('~g~Ubranie zostalo zapisane w domu\n~b~Nazwą zapisanego ubrania: ~g~'..data3.value)
												t = true												
											end)
										end, function(data3, menu3)
											menu3.close()
										end)
									end
								end)
							end
						end)

					else
						t = false
						ESX.ShowNotification(_U('not_enough_money'))
						cleanPlayer()
					end
				end)
			elseif data.current.value == 'no' then
				OpenShopMenu()
				t = false
			end
			
			if t then
				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_menu')
				CurrentActionData = {}
			end
		end, function(data, menu)
			menu.close()
			cleanPlayerskin()
		end)

	end, function(data, menu)
		menu.close()
		cleanPlayerskin()
		
		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('press_menu')
		CurrentActionData = {}
	end, {
		'tshirt_1',
		'tshirt_2',
		'torso_1',
		'torso_2',
		'decals_1',
		'decals_2',
		'arms',
		'pants_1',
		'pants_2',
		'shoes_1',
		'shoes_2',
		'chain_1',
		'chain_2',
		'watches_1',
		'watches_2',
		'helmet_1',
		'helmet_2',
		'mask_1',
		'mask_2',
		'glasses_1',
		'glasses_2',
		'bags_1',
		'bags_2'
	})
end

function OpenShopMenu()
	local elements = {
		{label = _U('shop_clothes'),  value = 'shop_clothes'},
		{label = ('Własne ubrania'), value = 'player_dressing'}
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_main', {
		title    = _U('shop_main_menu'),
		align    = 'left',
		elements = elements,
    }, function(data, menu)
		menu.close()
		if data.current.value == 'shop_clothes' then
			RestrictedMenu()
		end

		if data.current.value == 'player_dressing' then
			OpenClothes()
		end
    end, function(data, menu)
		menu.close()
		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('press_menu')
		CurrentActionData = {}
    end)
end

function OpenClothes()
	ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
		local elements = {}
		for k,v in pairs(dressing) do
			table.insert(elements, {label = v, value = k})
		end
		
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'dress_menu',{
			title    = 'Garderoba',
			align    = 'left',
			elements = elements
		}, function(data, menu)		
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing_opts', {
				title = 'Wybierz ubranie - ' .. data.current.label,
				align = 'center',
				elements = {
					{label = 'Ubierz', value = 'wear'},
					{label = 'Zmień nazwę', value = 'rename'},
					{label = 'Usuń ubranie', value = 'remove'}
				}
			}, function(data2, menu2)
				menu2.close()
				if data2.current.value == 'wear' then
					TriggerEvent('skinchanger:getSkin', function(skin)
						ESX.TriggerServerCallback('esx_property:getPlayerOutfit', function(clothes)
							TriggerEvent('skinchanger:loadClothes', skin, clothes)
							TriggerEvent('esx_skin:setLastSkin', skin)

							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
							end)
						end, data.current.value)
					end)
				elseif data2.current.value == 'rename' then
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'player_dressing_rename', {
						title = 'Zmień nazwę - ' .. data.current.label
					}, function(data3, menu3)
						menu3.close()
						TriggerServerEvent('esx_property:renameOutfit', data.current.value, data3.value)
						ESX.ShowNotification('Zmieniono nazwę ubrania!')
						OpenClothes()
					end, function(data3, menu3)
						menu3.close()
						menu2.open()
					end)
				elseif data2.current.value == 'remove' then
					TriggerServerEvent('esx_property:removeOutfit', data.current.value)
					ESX.ShowNotification('Ubranie usunięte z Twojej garderoby: ' .. data.current.label)
					OpenClothes()
				end
			end, function(data2, menu2)
				menu2.close()
				menu.open()
			end)		
		end, function(data, menu)
			menu.close()
			CurrentAction     = 'shop_menu'
			CurrentActionMsg  = _U('press_menu')
			CurrentActionData = {}
		end)
	end)
end

function cleanPlayerskin()
	TriggerEvent('skinchanger:loadSkin', currentSkin)
	currentSkin = nil
end

AddEventHandler('esx_ambulancejob:hasEnteredMarker', function(zone, number)
	local ped = PlayerPedId()

	if zone == 'DutyList' then
		CurrentAction		= 'ambulance_duty_list'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby sprawdzić listę dostępnych medyków"
		CurrentActionData	= {}
	end

	if zone == 'Cloakrooms' then
		CurrentAction		= 'ambulance_actions_menu'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby się przebrać"
		CurrentActionData	= {}
	end

	if zone == 'LicensesMenu' then
		CurrentAction				 	= 'ambulance_licenes_menu'
		CurrentActionMsg			= "Naciśnij ~INPUT_CONTEXT~, aby zarządzać licencjami"
		CurrentActionData    = {}
	end

	if zone == 'Vehicles' then
		CurrentAction		= 'vehicle_spawner_menu'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~, aby wyciągnąć pojazd"
		CurrentActionData	= {zoneNumber = number}
	end

	if zone == 'Boats' then
		CurrentAction		= 'boat_spawner_menu'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~ aby wyciągnąć łódź"
		CurrentActionData	= {zoneNumber = number}
	end

	if zone == 'Pharmacies' then
		CurrentAction		= 'pharmacy'
		CurrentActionMsg	= _U('open_pharmacy')
		CurrentActionData	= {}
	end

	if zone == 'Helicopters' then
		CurrentAction		= 'heli_spawner_menu'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~ aby wyciągnąć helikopter."
		CurrentActionData	= {zoneNumber = number}
	end
	
	if zone == 'Inventories' then
		CurrentAction		= 'items_menu'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~ aby otworzyć szafkę"
		CurrentActionData	= {}
	end

	if zone == 'Inventories2' then
		CurrentAction		= 'items2_menu'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~ aby otworzyć szafkę"
		CurrentActionData	= {}
	end
	
	if zone == 'BossActions' then
		CurrentAction		= 'boss_actions'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~ aby otworzyć menu zarządzania"
		CurrentActionData	= {}
	end

  if zone == 'SkinMenu' then
	CurrentAction = 'menu_skin'
	CurrentActionMsg = "Naciśnij ~INPUT_CONTEXT~ aby się przebrać"
	CurrentActionData = {}
	end

	if zone == 'VehicleDeleters' then
		if IsPedInAnyVehicle(ped, false) then
			local coords	= GetEntityCoords(ped, true)
	  
			local vehicle, distance = ESX.Game.GetClosestVehicle({
			  x = coords.x,
			  y = coords.y,
			  z = coords.z
			})
			if distance ~= -1 and distance <= 1.0 then
				CurrentAction	 = 'delete_vehicle'
				CurrentActionMsg  = _U('store_veh')
				CurrentActionData = {vehicle = vehicle}
			end
		end
	end
end)

function FastTravel(pos)
		TeleportFadeEffect(PlayerPedId(), pos)
end

function FastTravelCar(x, y, z)
		etPedCoordsKeepVehicle(PlayerPedId(), pos)
end

AddEventHandler('esx_ambulancejob:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

-- Create blips
function refreshBlip()
	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' then
		for _, ez in ipairs(Config.OnlySamsBlip) do
			local blip = AddBlipForCoord(ez.Pos.x, ez.Pos.y, ez.Pos.z)
			SetBlipSprite (blip, ez.Sprite)
			SetBlipDisplay(blip, ez.Display)
			SetBlipScale  (blip, ez.Scale)
			SetBlipColour (blip, ez.Colour)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Łodzie - SAMS")
			EndTextCommandSetBlipName(blip)
			Citizen.Wait(0)
			table.insert(SamsBlip, blip)
		end
	end
end

function deleteBlip()
	if SamsBlip[1] ~= nil then
		for i=1, #SamsBlip, 1 do
			RemoveBlip(SamsBlip[i])
		end
		SamsBlip = {}
	end
end

CreateThread(function()
	for i=1, #Config.Blips, 1 do
		local cBlip = Config.Blips[i]
		local blip = AddBlipForCoord(cBlip.coords)

		SetBlipSprite(blip, Config.Sprite)
		SetBlipDisplay(blip, Config.Display)
		SetBlipScale(blip, Config.Scale)
		SetBlipColour(blip, Config.Colour)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Szpital")
		EndTextCommandSetBlipName(blip)
	end
end)

-- Display markers
CreateThread(function()
	while PlayerData.job == nil do
		Citizen.Wait(1000)
	end
	
	while true do
		Citizen.Wait(3)
		if PlayerData.job ~= nil and (PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'offambulance') then
			local found = false
			local coords = GetEntityCoords(PlayerPedId())
			for k,v in pairs(Config.Ambulance) do
				for i=1, #v, 1 do
					if k == 'VehicleDeleters' then
						if #(coords - v[i].coords) < Config.DrawDistance then
							found = true
							ESX.DrawBigMarker(v[i].coords)
						end
					elseif k == 'Cloakrooms' and (PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'offambulance') then
						if #(coords - v[i].coords) < Config.DrawDistance then
							found = true
							ESX.DrawMarker(v[i].coords)
						end					
					end
					if k ~= 'VehicleDeleters' and k ~= 'Cloakrooms' and PlayerData.job.name == 'ambulance' then
						if #(coords - v[i].coords) < Config.DrawDistance then
							found = true
							ESX.DrawMarker(v[i].coords)
						end
					end
				end
			end
			
			if not found then
				Citizen.Wait(2000)
			end
		else
			Citizen.Wait(2000)
		end
	end
end)

-- Activate menu when player is inside marker
CreateThread(function()
	while true do
		Citizen.Wait(60)

		local coords, sleep		= GetEntityCoords(PlayerPedId()), true
		local isInMarker	= false
		local currentZone	= nil
		local zoneNumber 	= nil
		
		for k,v in pairs(Config.Ambulance) do
			if PlayerData.job ~= nil and (PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'offambulance') then
				for i=1, #v, 1 do
					if k == 'VehicleDeleters' then
					
						if #(coords - v[i].coords) < 3.0 then
							sleep = false
							isInMarker	= true
							currentZone = k
							zoneNumber = i
						end
					elseif k == 'Cloakrooms' and (PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'offambulance') then						
						if #(coords - v[i].coords) < Config.MarkerSize.x then
							sleep = false
							isInMarker	= true
							currentZone = k
							zoneNumber = i
						end
					end
					if k ~= 'VehicleDeleters' and k ~= 'Cloakrooms' and PlayerData.job.name == 'ambulance' then
						if #(coords - v[i].coords) < Config.MarkerSize.x then
							sleep = false
							isInMarker	= true
							currentZone = k
							zoneNumber = i
						end
					end
				end
			end
		end
		
		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			lastZone				= currentZone
			TriggerEvent('esx_ambulancejob:hasEnteredMarker', currentZone, zoneNumber)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_ambulancejob:hasExitedMarker', lastZone)
		end
		
		if sleep then
			Citizen.Wait(250)
		end
	end
end)

function OpenInventoryMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'items', {
		title    = 'Szafka',
		align    = 'center',
		elements = {
			{label = 'Wyciągnij ekwipunek', value = 'get'},
			{label = 'Zdeponuj ekwipunek', value = 'put'},
		}
	}, function(data,menu)
		menu.close()
		if data.current.value == 'get' then
			TriggerEvent('exile:getInventoryItem', 'society_ambulance')
		elseif data.current.value == 'put' then
			TriggerEvent('exile:putInventoryItem', 'society_ambulance')
		end
	end, function(data, menu)
		menu.close()
		CurrentAction		= 'items_menu'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~ aby otworzyć szafkę"
		CurrentActionData	= {}
	end)
end

function OpenInventoryMenu2()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'items', {
		title    = 'Szafka',
		align    = 'center',
		elements = {
			{label = 'Wyciągnij ekwipunek', value = 'get'},
			{label = 'Zdeponuj ekwipunek', value = 'put'},
		}
	}, function(data,menu)
		menu.close()
		if data.current.value == 'get' then
			TriggerEvent('exile:getInventoryItem', 'society_sams2')
		elseif data.current.value == 'put' then
			TriggerEvent('exile:putInventoryItem', 'society_sams2')
		end
	end, function(data, menu)
		menu.close()
		CurrentAction		= 'items2_menu'
		CurrentActionMsg	= "Naciśnij ~INPUT_CONTEXT~ aby otworzyć szafkę"
		CurrentActionData	= {}
	end)
end

-- Key Controls
CreateThread(function()
	while true do

		Citizen.Wait(10)

		if CurrentAction ~= nil then
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlJustReleased(0, 46) then
				if PlayerData.job ~= nil and (PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'offambulance') then

					if CurrentAction == 'ambulance_duty_list' then
						if PlayerData.job.grade >= 10 then
							OpenAmbulanceDutyList()
						else
							ESX.ShowNotification('Nie masz do tego dostępu')
						end
					end
					
					if CurrentAction == 'ambulance_actions_menu' then
						OpenAmbulanceActionsMenu()
					end

					if CurrentAction == 'vehicle_spawner_menu' then
						OpenVehicleSpawnerMenu(CurrentActionData.zoneNumber)
					end

					if CurrentAction == 'heli_spawner_menu' then
						if heli then
							OpenHeliSpawnerMenu(CurrentActionData.zoneNumber)
						else
							ESX.ShowNotification('Nie posiadasz licencji na helikopter')
						end
					end

					if CurrentAction == 'boat_spawner_menu' then
						OpenBoatSpawnerMenu(CurrentActionData.zoneNumber)
					end

					if CurrentAction == 'pharmacy' then
						OpenPharmacyMenu()
					end

					if CurrentAction == 'ambulance_licenes_menu' then
						if PlayerData.job.grade >= 11 then
							LicenseSAMS('ambulance')
						else
							ESX.ShowNotification('Nie masz do tego dostępu')
						end
					end
					
					if CurrentAction == 'items_menu' then
						OpenInventoryMenu()
					end

					if CurrentAction == 'items2_menu' then
						OpenInventoryMenu2()
					end

					if CurrentAction == 'menu_skin' then
						OpenShopMenu()
					end
					
					if CurrentAction == 'boss_actions' then
						ESX.UI.Menu.CloseAll()
						if PlayerData.job.grade >= 10 then
							TriggerEvent('esx_society:openBossMenu', 'ambulance', function(data, menu)
								menu.close()
							end, { showmoney = true, withdraw = true, deposit = true, wash = false, employees = true, badges = true})
						else
							TriggerEvent('esx_society:openBossMenu', 'ambulance', function(data, menu)
								menu.close()
							end, { showmoney = false, withdraw = false, deposit = true, wash = false, employees = false, badges = true})
						end

					if CurrentAction == 'fast_travel_goto_top' or CurrentAction == 'fast_travel_goto_bottom' then
						FastTravel(CurrentActionData.pos)
					end
				end
					if CurrentAction == 'delete_vehicle' then
						ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
					end
				end
				
				CurrentAction = nil	
			end
		
		else
			Citizen.Wait(1000)
		end
	end
end)

CreateThread(function()
	local timer = GetGameTimer()
	
	while true do

		Citizen.Wait(10)
		if PlayerData.job ~= nil and PlayerData.job.name == 'ambulance' then
		
			if IsControlJustReleased(0, 38) and CurrentTask.busy and timer < GetGameTimer() then
				ESX.ShowNotification('Unieważniasz zajęcie')
				ESX.ClearTimeout(CurrentTask.task)
				ClearPedTasks(PlayerPedId())

				CurrentTask.busy = false
				
				timer = GetGameTimer() + 500
			end	
		
			if IsControlJustReleased(0, Keys['F6']) and not IsDead and timer < GetGameTimer() then
				OpenMobileAmbulanceActionsMenu()
				
				timer = GetGameTimer() + 500
			end
		
		else
			Citizen.Wait(1000)
		end
	end
end)

RegisterNetEvent('esx_ambulancejob:requestDeath')
AddEventHandler('esx_ambulancejob:requestDeath', function()
	if Config.AntiCombatLog then
		Citizen.Wait(6000)
		local playerPed = PlayerPedId()
		Citizen.InvokeNative(0x6B76DC1F3AE6E6A3, playerPed, 0)
		ESX.ShowNotification('~r~Jesteś nieprzytomny/a, ponieważ przed wyjściem z serwera Twoja postać miała BW')
	end
end)

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

function OpenAmbulanceDutyList()
	ESX.TriggerServerCallback('esx_ambulancejob:getDutyList', function(list)
		local elements = {}
		for i, data in pairs(list) do
			table.insert(elements, { label = data.label, value = i })
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'duty_list', {
            title    = "Lista pracowników na służbie",
            align    = 'center',
            elements = elements
        }, function(data2, menu2)
			menu2.close()
        end, function(data2, menu2)
            menu2.close()
        end)
	end)
end

function GetPlayerByEntityID(id)
	for _, player in ipairs(GetActivePlayers()) do
		if id == Citizen.InvokeNative(0x43A66C31C68491C0, player) then
			return player
		end
	end
end

function LicenseSAMS(society)
	ESX.TriggerServerCallback('esx_society:getEmployeeslic', function(employees)
		local elements = nil
		local identifier = ''
			elements = {
				head = {"Pracownik", "HELI", "Akcje"},
				rows = {}
			}
			for i=1, #employees, 1 do
				local licki = {}
				if employees[i].licensess.heli == true then
					licki[1] = '✔️'
				else
					licki[1] = "❌"
				end				
				table.insert(elements.rows, {
					data = employees[i],
					cols = {
						employees[i].name,
						licki[1],
						'{{' .. "Nadaj Licencję" .. '|give}} {{' .. "Odbierz Licencję" .. '|take}}'
					}
				})
			end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_' .. society, elements, function(data, menu)
			local employee = data.data
			local elements = {
				{label = ('Licencja HELI'), value = 'heli'},
			}
			if data.value == 'give' then
				menu.close()
				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'licencje',
					{
					  title = ('Nadaj licencje dla '..employee.name),
					  align = 'center',
					  elements = elements
					}, function(data2, menu2)
						local amount = data2.current.value
						local wartosc = ''

						if amount == 'heli' then
							wartosc = 'sams_heli'
						end
						TriggerServerEvent('esx_ambulancejob:addlicense', employee.identifier, wartosc)
						ESX.ShowNotification('Nadano licencje ~b~'..amount.. '~s~ dla ~b~' ..employee.name)
					end, function(data2, menu2)
					menu2.close()
				end)
			elseif data.value == 'take' then
				menu.close()
				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'licencje',
					{
					  title = ('Wycofaj licencje dla '..employee.name),
					  align = 'center',
					  elements = elements
					}, function(data3, menu3)
						local amount = data3.current.value
						local wartosc = ''
						
						if amount == 'heli' then
							wartosc = 'sams_heli'
						end
						TriggerServerEvent('esx_ambulancejob:removelicense', employee.identifier, wartosc)
						ESX.ShowNotification('Wycofano licencje ~b~'..amount.. ' ~s~dla ~b~' ..employee.name)		
					end, function(data3, menu3)
					menu3.close()
				end)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, 'ambulance', society)
end

local cam = nil

local angleY = 0.0
local angleZ = 0.0

CreateThread(function()
    while true do
        Citizen.Wait(1)
        if (cam and IsDead) then
            ProcessCamControls()
		else
			Citizen.Wait(500)
		end
    end
end)

-- initialize camera
function StartDeathCam()
    ClearFocus()

    local playerPed = PlayerPedId()
    
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", GetEntityCoords(playerPed), 0, 0, 0, GetGameplayCamFov())

    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1000, true, false)
end

-- destroy camera
function EndDeathCam()
    ClearFocus()

    RenderScriptCams(false, false, 0, true, false)
    DestroyCam(cam, false)
    
    cam = nil
end

function ProcessCamControls()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    DisableFirstPersonCamThisFrame()
    
    local newPos = ProcessNewPosition()

    SetFocusArea(newPos.x, newPos.y, newPos.z, 0.0, 0.0, 0.0)
    
    SetCamCoord(cam, newPos.x, newPos.y, newPos.z)
    
    PointCamAtCoord(cam, playerCoords.x, playerCoords.y, playerCoords.z + 0.5)
end

function ProcessNewPosition()
    local mouseX = 0.0
    local mouseY = 0.0
    
    if (IsInputDisabled(0)) then
        mouseX = GetDisabledControlNormal(1, 1) * 8.0
        mouseY = GetDisabledControlNormal(1, 2) * 8.0
    else
        mouseX = GetDisabledControlNormal(1, 1) * 1.5
        mouseY = GetDisabledControlNormal(1, 2) * 1.5
    end

    angleZ = angleZ - mouseX
    angleY = angleY + mouseY
    if (angleY > 89.0) then angleY = 89.0 elseif (angleY < -89.0) then angleY = -89.0 end
    
    local pCoords = GetEntityCoords(PlayerPedId())
    
    local behindCam = {
        x = pCoords.x + ((Cos(angleZ) * Cos(angleY)) + (Cos(angleY) * Cos(angleZ))) / 2 * (3.5 + 0.5),
        y = pCoords.y + ((Sin(angleZ) * Cos(angleY)) + (Cos(angleY) * Sin(angleZ))) / 2 * (3.5 + 0.5),
        z = pCoords.z + ((Sin(angleY))) * (3.5 + 0.5)
    }
    local rayHandle = StartShapeTestRay(pCoords.x, pCoords.y, pCoords.z + 0.5, behindCam.x, behindCam.y, behindCam.z, -1, PlayerPedId(), 0)
    local a, hitBool, hitCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)
    
    local maxRadius = 3.5
    if (hitBool and Vdist(pCoords.x, pCoords.y, pCoords.z + 0.5, hitCoords) < 3.5 + 0.5) then
        maxRadius = Vdist(pCoords.x, pCoords.y, pCoords.z + 0.5, hitCoords)
    end
    
    local offset = {
        x = ((Cos(angleZ) * Cos(angleY)) + (Cos(angleY) * Cos(angleZ))) / 2 * maxRadius,
        y = ((Sin(angleZ) * Cos(angleY)) + (Cos(angleY) * Sin(angleZ))) / 2 * maxRadius,
        z = ((Sin(angleY))) * maxRadius
    }
    
    local pos = {
        x = pCoords.x + offset.x,
        y = pCoords.y + offset.y,
        z = pCoords.z + offset.z
    }
    return pos
end


RegisterNetEvent('route68:wczytajnumer')
AddEventHandler('route68:wczytajnumer', function(numer)
    TriggerServerEvent("route68:SetNumberWejscie", numer)
end)

-- String string
function stringsplit(inputstr, sep)
  if sep == nil then
	  sep = "%s"
  end
  local t={} ; i=1
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
	  t[i] = str
	  i = i + 1
  end
  return t
end

function GetPedVehicleSeat(ped)
    local vehicle = GetVehiclePedIsIn(ped, false)
    for i= -1, GetVehicleMaxNumberOfPassengers(vehicle) do
        if GetPedInVehicleSeat(vehicle, i) == ped then
			return i
		end
    end
	
    return -2
end

function GetPlayerByEntityID(id)
	for _, player in ipairs(GetActivePlayers()) do
		if id == Citizen.InvokeNative(0x43A66C31C68491C0, player) then
			return player
		end
	end
end

function GetVehicleName(name)
	if name ~= 'CARNOTFOUND' then
		local found = false

		if not found then
			local label = GetLabelText(name)
			if label ~= "NULL" then
				name = label
			end
		end
	end

	return name
end
