local holstered = false
local kased = false
local PlayerData = {}
local allow = {
	allow = false,
	job = false,
	item = false
}


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
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function(item, count)
	if PlayerData and PlayerData.inventory then
		CreateThread(function()
			Citizen.Wait(100)
			PlayerData = ESX.GetPlayerData()

			if PlayerData.inventory ~= nil then
				local found = false
				for i = 1, #PlayerData.inventory, 1 do
					if PlayerData.inventory[i].name == item.name then
						PlayerData.inventory[i] = item
						found = true
						break
					end
				end
				
				if not found then
					ESX.TriggerServerCallback('esx:isValidItem', function(status)
						if status then
							table.insert(PlayerData.inventory, item)
						end
					end, item.name)			
				end
			end
		end)
	end
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count)
	if PlayerData and PlayerData.inventory then
		CreateThread(function()
			Citizen.Wait(100)
			PlayerData = ESX.GetPlayerData()

			if PlayerData.inventory ~= nil then
				local found = false
				for i = 1, #PlayerData.inventory, 1 do
					if PlayerData.inventory[i].name == item.name then
						PlayerData.inventory[i] = item
						found = true
						break
					end
				end
				
				if not found then
					ESX.TriggerServerCallback('esx:isValidItem', function(status)
						if status then
							table.insert(ESX.PlayerData.inventory, item)
						end
					end, item.name)
				end
			end
		end)
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(500)
		if PlayerData and PlayerData.job and (PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'mechanik') and PlayerData.inventory ~= nil then
			allow.job, allow.item = true, false
			for i = 1, #PlayerData.inventory, 1 do
				if PlayerData.inventory[i].name == 'radio' and PlayerData.inventory[i].count > 0 then
					allow.item = true
				end
			end
			
			allow.allow = (exports['exile_trunk']:checkInTrunk() or exports['esx_policejob']:IsCuffed())
		else
			allow.job, allow.item = false, false
		end
	end
end)

-- RADIO ANIMATIONS -- 


CreateThread(function()
	while true do
		Citizen.Wait(3)
		local ped = PlayerPedId()
		if not IsPauseMenuActive() then 
			if DoesEntityExist(ped) and not IsEntityDead(ped) then
				if allow.job and allow.item and allow.allow then
					loadAnimDict("random@arrests")
					loadAnimDict("amb@code_human_police_investigate@idle_a")
					if IsControlJustReleased(0, 244) then
						TriggerServerEvent('InteractSound_SV:PlayOnSource', 'off', 0.1)
						ClearPedTasks(ped)
						SetEnableHandcuffs(ped, false)
					else
						if IsControlJustPressed( 0, 244 )  and not IsPlayerFreeAiming(PlayerId()) then
							TriggerServerEvent('InteractSound_SV:PlayOnSource', 'on', 0.1)
							TaskPlayAnim(ped, "amb@code_human_police_investigate@idle_a", "idle_b", 8.0, -8, -1, 49, 0, 0, 0, 0 )
							SetEnableHandcuffs(ped, true)
						elseif IsControlJustPressed( 0, 244 ) and IsPlayerFreeAiming(PlayerId()) then
							TriggerServerEvent('InteractSound_SV:PlayOnSource', 'on', 0.1)
							TaskPlayAnim(ped, "random@arrests", "radio_chatter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
							SetEnableHandcuffs(ped, true)
						end 
						if IsEntityPlayingAnim(Citizen.InvokeNative(0x43A66C31C68491C0, PlayerId()), "random@arrests", "generic_radio_enter", 3) then
							DisableActions(ped)
						elseif IsEntityPlayingAnim(Citizen.InvokeNative(0x43A66C31C68491C0, PlayerId()), "random@arrests", "radio_chatter", 3) then
							DisableActions(ped)
						end
					end
				else
					Citizen.Wait(500)
				end
			end 
		end 
	end
end)



function DisableActions(ped)
	DisableControlAction(1, 140, true)
	DisableControlAction(1, 141, true)
	DisableControlAction(1, 142, true)
	DisablePlayerFiring(ped, true) -- Disable weapon firing
end

function loadAnimDict( dict )
	while ( not HasAnimDictLoaded( dict ) ) do
		RequestAnimDict( dict )
		Citizen.Wait( 0 )
	end
end
