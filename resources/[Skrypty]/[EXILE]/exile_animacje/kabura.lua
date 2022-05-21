local kabura = false
local allowed = false

ESX = nil
CreateThread(function()
	while ESX == nil do
		TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(5000)
	local PlayerData = ESX.GetPlayerData()
	allowed = (PlayerData.job and (PlayerData.job.name == 'police' or PlayerData.job.name == 'offpolice' or PlayerData.hiddenjob.name == 'sheriff'))
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(PlayerData)
	allowed = (PlayerData.job and (PlayerData.job.name == 'police' or PlayerData.job.name == 'offpolice' or PlayerData.hiddenjob.name == 'sheriff'))
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	allowed = (job and (job.name == 'police' or job.name == 'offpolice'))
end)

RegisterCommand('+kabura', function()
	if not exports['esx_ambulancejob']:isDead() and not exports['esx_policejob']:IsCuffed() and allowed then
		kaburaOn()
	end
end)
RegisterCommand('-kabura', function()
	if not exports['esx_ambulancejob']:isDead() and not exports['esx_policejob']:IsCuffed() and allowed then
		kaburaOff()
	end
end)

RegisterKeyMapping('+kabura', 'Trzymanie za kaburę', 'keyboard', 'LMENU')

--[[function kaburka()
	while not HasAnimDictLoaded("move_m@intimidation@cop@unarmed") do
		RequestAnimDict("move_m@intimidation@cop@unarmed")
		Citizen.Wait(2)
	end
	if Ped.Active then
		if Ped.Available then
			if not kabura then
				kabura = true
				TaskPlayAnim(Ped.Id, "move_m@intimidation@cop@unarmed", "idle", 8.0, 8.0, -1, 50, 0, false, false, false)
			elseif kabura then
				kabura = false
				ClearPedSecondaryTask(Ped.Id)
			end
		end
	elseif kabura then
		kabura = false
		if Ped.Available then
			ClearPedSecondaryTask(Ped.Id)
		end
	end
end]]

function kaburaOn() 
	while not HasAnimDictLoaded("move_m@intimidation@cop@unarmed") do
		RequestAnimDict("move_m@intimidation@cop@unarmed")
		Citizen.Wait(2)
	end
	if Ped.Active then
		if Ped.Available then
			if not kabura then
				kabura = true
				TaskPlayAnim(Ped.Id, "move_m@intimidation@cop@unarmed", "idle", 8.0, 8.0, -1, 50, 0, false, false, false)
			end
		end
	end
end
function kaburaOff() 
	while not HasAnimDictLoaded("move_m@intimidation@cop@unarmed") do
		RequestAnimDict("move_m@intimidation@cop@unarmed")
		Citizen.Wait(2)
	end
	if Ped.Active then
		if Ped.Available then
			if kabura then
				kabura = false
				ClearPedSecondaryTask(Ped.Id)
			end
		end
	elseif kabura then
		kabura = false
		if Ped.Available then
			ClearPedSecondaryTask(Ped.Id)
		end
	end
end