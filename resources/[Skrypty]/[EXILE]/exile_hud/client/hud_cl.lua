ESX              = nil
CreateThread(function()
	while ESX == nil do
		TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) 
			ESX = obj 
		end)
		
		Citizen.Wait(250)
	end
end)

local Ped = {
	Id = PlayerPedId(),
	Pid = PlayerId(),
	PauseMenu = false,
}

local Hide = false
local Status = false
AddEventHandler('radar:setHidden', function(val)
	Hide = val
end)

-- local FirstSpawn = true
-- AddEventHandler('esx:onPlayerSpawn', function()
	-- if FirstSpawn then
		-- FirstSpawn = false
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
			
			Status = true
			SendNUIMessage({ action = 'startUp' })
		end)
	-- end
-- end)

function ChangeStatus(val)
	if val.name == 'thirst' or val.name == 'hunger' then 
		SendNUIMessage({
			action = "updateStatus",
			name = val['name'],
			value = val['value'],
		})	
	end
end


CreateThread(function()
	while true do
		Citizen.Wait(250)
		local ped, pid = PlayerPedId(), PlayerId()

		Ped.PauseMenu = IsPauseMenuActive()
		Ped.Id = ped
		Ped.Pid = pid
		
		local health, armor, stamina, oxy = GetEntityHealth(ped) - 100, GetPedArmour(ped), math.ceil(100- GetPlayerSprintStaminaRemaining(pid)), math.ceil(GetPlayerUnderwaterTimeRemaining(pid) * 2.5)
		
		if oxy <= 0 then
			oxy = 0
		end
		
		SendNUIMessage({
			action = 'updateSelfStatus',
			health = health,
			armor = armor,
			stamina = stamina,
			oxygen = oxy
		})	
	end
end)

-- NUI callbacks
RegisterNUICallback('close', function()
	if isOpen then
		SetNuiFocus(false, false)
		isOpen = false
	end
end)

function HudConf()
	if not isOpen and not isPaused then
		isOpen = true
		SendNUIMessage({ action = 'show' })
		SetNuiFocus(true, true)
	end
end

local VoiceState, pauseMenu= false, false
CreateThread(function()
	while true do
		Citizen.Wait(100)
		
		
		if NetworkIsPlayerTalking(Ped.Pid) and not VoiceState then
			SendNUIMessage({
				action = 'setVoiceTalking',
				talking = true
			})
		
			VoiceState = true
		elseif not NetworkIsPlayerTalking(Ped.Pid) and VoiceState then
			SendNUIMessage({
				action = 'setVoiceTalking',
				talking = false
			})			
			VoiceState = false
		end	
		
		if Status then
			if not pauseMenu and (Ped.PauseMenu or Hide) then
				SendNUIMessage({
					action = 'pauseMenu',
					display = false,
				})
				
				pauseMenu = true
			elseif pauseMenu and (not Ped.PauseMenu and not Hide) then
				SendNUIMessage({
					action = 'pauseMenu',
					display = true,
				})			
				
				pauseMenu = false
			end
		end
			
	end
end)

function SetVoiceMode(value)
	if value ~= nil then
		SendNUIMessage({
			action = 'setVoiceState',
			voice = value
		})
	end
end