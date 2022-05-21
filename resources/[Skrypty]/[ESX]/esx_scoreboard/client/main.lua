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

local PlayerData = {}
local IsNuiActive = false
local IsDisplaying = nil
local Timer = 0
local Prop = nil
local Id = nil
local IsAdmin = nil
local MisiaczekPlayers = {}

ESX = nil
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

local Ped = {
	Active = false,
	Id = 0,
	Exists = false,
	Spectate = nil
}

CreateThread(function()
	while true do
		Citizen.Wait(200)
		if not NetworkIsInSpectatorMode() then
			Ped.Spectate = nil
		end

		Ped.Active = not IsPauseMenuActive()
		if Ped.Active then
			Ped.Id = PlayerPedId()
			Ped.Exists = DoesEntityExist(Ped.Id)
		end
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	
	SendNUIMessage({
		action = "updateJob", 
		praca = xPlayer.job.label.." - "..xPlayer.job.grade_label
	})
	
	TriggerServerEvent('esx_scoreboard:players')
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	
	SendNUIMessage({
		action = "updateJob", 
		praca = PlayerData.job.label.." - "..PlayerData.job.grade_label
	})
end)

AddEventHandler('EasyAdmin:spectate', function(ped)
	Ped.Spectate = ped
end)

local cache = {}

function DrawText2D(id, int)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextScale(0.4, 0.4)
	SetTextColour(56, 197, 201, 255)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextJustification(2)

	SetTextEntry('STRING')
	AddTextComponentString(id)
	DrawText(table.unpack({ 0.0, 0.965 - int }))
end

CreateThread(function()
	while true do
		if #cache > 0 then
			Citizen.Wait(5)
			for i=1, #cache, 1 do
				local int = i * 0.0185
				DrawText2D(cache[i].id, int)
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(700)
		if not exports['esx_property']:isProperty() then
			local ped = Ped.Id
			if Ped.Spectate then
				ped = Ped.Spectate
			end

			local pid = PlayerId()
			for _, player in ipairs(GetActivePlayers()) do
				if pid ~= player then
					local playerPed = Citizen.InvokeNative(0x43A66C31C68491C0, player)
					local can = true
					if not IsEntityVisible(playerPed) then
						if not IsAdmin then
							can = false
						end	
					end	
					if can then						
						local coords1 = GetPedBoneCoords(ped, 31086, -0.4, 0.0, 0.0)
						local coords2 = GetPedBoneCoords(playerPed, 31086, -0.4, 0.0, 0.0)
						
						local dystans = 20.00
						if #(coords1 - coords2) < dystans and NetworkIsPlayerTalking(player) then
							local found = false
							for i=1, #cache, 1 do
								if cache[i].id == GetPlayerServerId(player) then
									found = true
									break
								end
							end
							if not found then
								table.insert(cache, {id = GetPlayerServerId(player)})
							end
						else
							for i=1, #cache, 1 do
								if GetPlayerServerId(player) == cache[i].id then
									table.remove(cache, i)
									break
								end
							end
						end
					end
				end  
			end					
		end
	end
end)

function DrawText3D(x, y, z, text, color)
    local onScreen, _x, _y = World3dToScreen2d(x,y,z)
	
	local scale = (1 / #(GetGameplayCamCoords() - vec3(x, y, z))) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov
    
    if onScreen then
        SetTextScale(1.0 * scale, 1.55 * scale)
        SetTextFont(0)
        SetTextColour(color[1], color[2], color[3], 255)
        SetTextDropshadow(0, 0, 5, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
		SetTextCentre(1)

        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

CreateThread(function()
	while not HasAnimDictLoaded("amb@world_human_clipboard@male@idle_a") do
		RequestAnimDict("amb@world_human_clipboard@male@idle_a")
		Citizen.Wait(0)
	end
	
	while true do
		Citizen.Wait(5)
	
		local found = false
		if Ped.Active and Ped.Exists then
			found = true
			if IsControlJustPressed(0, Keys['Z']) then
				IsDisplaying = false
				if IsEntityVisible(Ped.Id) then
					if not IsAdmin then
						TriggerServerEvent('esx_scoreboard:Show', "rozgląda się uważnie")
						if not IsPedInAnyVehicle(Ped.Id, false) and not exports["esx_ambulancejob"]:isDead() and not IsEntityDead(Ped.Id) and not IsPedFalling(Ped.Id) and not IsPedCuffed(Ped.Id) and not IsPedDiving(Ped.Id) and not IsPedInCover(Ped.Id, false) and not IsPedInParachuteFreeFall(Ped.Id) and GetPedParachuteState(Ped.Id) < 1 and not exports['exile_trunk']:checkInTrunk() and not exports['esx_policejob']:IsCuffed() then
							TaskPlayAnim(Ped.Id, "amb@world_human_clipboard@male@idle_a", "idle_a", 8.0, -8.0, -1, 1, 0.0, false, false, false)
							IsDisplaying = true

							local coords = GetEntityCoords(Ped.Id)
							ESX.Game.SpawnObject('p_cs_clipboard', {
								x = coords.x,
								y = coords.y,
								z = coords.z + 2
							}, function(object)
								AttachEntityToEntity(object, Ped.Id, GetPedBoneIndex(Ped.Id, 36029), 0.1, 0.015, 0.12, 45.0, -130.0, 180.0, true, false, false, false, 0, true)
								Prop = object
							end)					
						end
					end
				end
			end
			
			if IsDisplaying ~= nil then				
				if IsDisplaying == false or IsEntityPlayingAnim(Ped.Id, "amb@world_human_clipboard@male@idle_a", "idle_a", 3) or exports["esx_ambulancejob"]:isDead() then
					PlayerList()

					if not exports['esx_property']:isProperty() then
						local ped = Ped.Id
						if Ped.Spectate then
							ped = Ped.Spectate
						end

						local pid = PlayerId()
						for _, player in ipairs(GetActivePlayers()) do
							if id ~= player then
								local playerPed = Citizen.InvokeNative(0x43A66C31C68491C0, player)
								local can = true
								if not IsEntityVisible(playerPed) then
									if not IsAdmin then
										can = false
									end	
								end	
								if can then	
									local coords1 = GetPedBoneCoords(ped, 31086, -0.4, 0.0, 0.0)
									local coords2 = GetPedBoneCoords(playerPed, 31086, -0.4, 0.0, 0.0)
									
									local dystans = IsAdmin and 100.00 or 40.00
									if #(coords1 - coords2) < dystans then
										DrawText3D(coords2.x, coords2.y, coords2.z + 1.2, GetPlayerServerId(player), (NetworkIsPlayerTalking(player) and {0, 0, 255} or {255, 255, 255}))
									end
								end
							end  
						end					
					end
				end

				if IsControlJustReleased(0, Keys['Z']) and GetLastInputMethod(2) then					
					SendNUIMessage({
						action = 'toggle',
						state = false
					})
	
					if IsDisplaying == true then
						StopAnimTask(Ped.Id, "amb@world_human_clipboard@male@idle_a", "idle_a", 1.0)
						DeleteObject(Prop)
						Prop = nil
					end

					IsDisplaying = nil
					IsNuiActive = false
				end			
			end
		end
		
		if not found and IsDisplaying ~= nil then
			SendNUIMessage({
				action = 'toggle',
				state = false
			})
			
			if IsDisplaying == true and Ped.Exists then
				StopAnimTask(Ped.Id, "amb@world_human_clipboard@male@idle_a", "idle_a", 1.0)
				DeleteObject(Prop)
				Prop = nil
			end

			IsDisplaying = nil
			IsNuiActive = false
		end

		if Ped.Exists and Prop and not IsControlPressed(0, Keys['Z']) then
			DeleteObject(Prop)
			Prop = nil
		end
		
	end
end)

function PlayerList()

	if IsNuiActive then
		return
	end

	local timer = GetGameTimer()
	if timer - Timer > 10000 then
		Timer, Id, MisiaczekPlayers = timer, nil, nil, {}
		TriggerServerEvent('esx_scoreboard:players')
	end
	
	if Id and PlayerData.job then
		SendNUIMessage({
			action = 'updatePlayerJobs',
			jobs   = {ems = MisiaczekPlayers['ambulance'], police = MisiaczekPlayers['police'], mechanik2 = MisiaczekPlayers['mechanik2'], doj = MisiaczekPlayers['doj'], cardealer = MisiaczekPlayers['cardealer'], player_count = MisiaczekPlayers['players']}
		})

		
		SendNUIMessage({
			action = 'toggle',
			state = true
		})
		
		IsNuiActive = true
	end
end

RegisterNetEvent('esx_scoreboard:players')
AddEventHandler('esx_scoreboard:players', function(Counter, Admin)
	Id = GetPlayerServerId(PlayerId())
	
	SendNUIMessage({
		action = 'updateId',
		id = Id
	})	
	
	MisiaczekPlayers = Counter
	IsAdmin = Admin
end)