ESX = nil
local PlayerData = {}
local haveItem = false
local Loaded = false
local time = 0

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
	Loaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	if PlayerData.job ~= nil and (PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'police' or PlayerData.job.name == 'mechanik2') and haveItem then
		TriggerEvent('bodycam:showw')
	else
		TriggerEvent('bodycam:closee')
	end
end)

RegisterNetEvent('esx:setHiddenJob')
AddEventHandler('esx:setHiddenJob', function(hiddenjob)
	PlayerData.hiddenjob = hiddenjob
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
	
	if PlayerData.job ~= nil and PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'police' or PlayerData.job.name == 'mechanik2' then
		if item == 'bodycam' and count > 0 then
			TriggerEvent('bodycam:showw')
		end	
	end
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count)
	if PlayerData and PlayerData.inventory then
		CreateThread(function()
			Citizen.Wait(100)
			ESX.PlayerData = ESX.GetPlayerData()

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
	
	if PlayerData.job ~= nil and PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'police' or PlayerData.job.name == 'mechanik2' then
		if item == 'bodycam' and count <= 0 then
			TriggerEvent('bodycam:closee')
		end	
	end
end)

RegisterNetEvent('bodycam:state')
AddEventHandler('bodycam:state', function(rodzaj)
	if PlayerData.job ~= nil and PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'police' or PlayerData.job.name == 'mechanik2' and haveItem then
		if rodzaj == true then
			TriggerEvent('bodycam:closee')
		elseif rodzaj == false then
			TriggerEvent('bodycam:showw')
		end
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(500)
		if Loaded then
			if PlayerData.inventory ~= nil then
				for i = 1, #PlayerData.inventory, 1 do
					if PlayerData.inventory[i].name == 'bodycam' then
						if PlayerData.inventory[i].count > 0 then
							haveItem = true
						else
							haveItem = false
						end
					end
				end	
			end
		end		
	end
end)

local IsPaused = false
CreateThread(function()
	while true do
		Citizen.Wait(1)
		if Loaded then
			if PlayerData.job ~= nil and PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'police' or PlayerData.job.name == 'mechanik2' and haveItem then
				if IsPauseMenuActive() and not IsPaused then
					IsPaused = true
					TriggerEvent('bodycam:closee')
				elseif not IsPauseMenuActive() and IsPaused then
					IsPaused = false
					TriggerEvent('bodycam:showw')
				end
			else
				Citizen.Wait(500)
			end
		end
	end
end)

RegisterNetEvent("bodycam:showw")
AddEventHandler("bodycam:showw", function()
	local text = ''
	ESX.TriggerServerCallback('xk3ly-bodycam:getPlayerName', function(result)
	if PlayerData.job.name == 'ambulance' then
		text = 'San Andreas Medical Services'
	elseif PlayerData.job.name == 'police' then
		text = 'SASP - '..PlayerData.job.grade_label
	elseif PlayerData.job.name == 'mechanik2' then
		text = 'Moltisanti Garage'
	end
	if PlayerData.hiddenjob.name == 'sheriff' then
		text = 'SASD - '..PlayerData.hiddenjob.grade_label
	elseif PlayerData.hiddenjob.name == 'hwp' then
		text = 'SAHP - '..PlayerData.hiddenjob.grade_label
	end
		SendNUIMessage({
			action = 'updatecam',
			odznaka = result.name,
			napis = text,
		})
	end)
end)

RegisterNetEvent("bodycam:closee")
AddEventHandler("bodycam:closee", function()
	SendNUIMessage({
		action = 'closecam'
	})
end)

local updateGlobal = 0
local delay = 10 * 60000
CreateThread(function()
	while true do
		Citizen.Wait(5000)
		if PlayerData.job and (PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'mechanik2' or PlayerData.job.name == 'doj') then
			time = time + 5
			
			local timer = GetGameTimer()
			if not updateGlobal or updateGlobal < timer then
				TriggerServerEvent('bodycam:save', time)
				time = 0
				updateGlobal = timer + delay
			end
		end
	end
end)