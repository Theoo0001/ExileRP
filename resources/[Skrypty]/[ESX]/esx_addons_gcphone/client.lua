ESX = nil
local PlayerData = {}

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

local alert = nil
local alertOwner = nil

RegisterNetEvent('esx_addons_gcphone:call')
AddEventHandler('esx_addons_gcphone:call', function(data)  
	local cbs = function(msg)
		if msg ~= nil and msg ~= "" then
			local coords = GetEntityCoords(PlayerPedId(), false)			
			TriggerServerEvent('esx_addons_gcphone:startCall', data.number, msg, {
				x = coords.x,
				y = coords.y,
				z = coords.z
			})
		end
	end
  
	if data.message == nil then
		TriggerEvent('misiaczek:keyboard', function(value)
		  cbs(value)
		end, {
		  limit = 255,
		  type = 'textarea',
		  title = 'Wpisz wiadomość:'
		})
	else 
		cbs(data.message)
	end
end)


CreateThread(function()
	while true do
		Citizen.Wait(10)
		if alert ~= nil then	
		
            SetTextComponentFormat("STRING")
            AddTextComponentString("Nacisnij ~INPUT_PICKUP~ aby, zaakceptowac\nNaciśnij ~INPUT_VEH_DUCK~ aby, odrzucić")
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			
			if IsControlJustReleased(0, 38) then
				AcceptAlert(alert, alertOwner)
				Citizen.Wait(10)
				alert = nil	
				alertOwner = nil			
			end			
			if IsControlJustReleased(0, 73) then
				Citizen.Wait(10)
				alert = nil	
				alertOwner = nil
			end
		else
			Citizen.Wait(150)
		end
	end
end)

RegisterNetEvent("csskrouble:notifAccepted", function(msg) 
	ESX.ShowNotification(msg)
end)

function AcceptAlert(data, aO)
	ClearGpsPlayerWaypoint()
	SetNewWaypoint(data.coords.x, data.coords.y)
	TriggerServerEvent("csskrouble:przyjetoWezwanie", aO)
	TriggerServerEvent('esx_addons_gcphone:acceptedAlert', alert.number)
	
	alert = nil
end

RegisterNetEvent('esx_addons_gcphone:acceptClient')
AddEventHandler('esx_addons_gcphone:acceptClient', function(name)
	ESX.ShowNotification(name..' przyjął wezwanie')
	alert = nil
end)

RegisterNetEvent('genesis-alert:sendAlert')
AddEventHandler('genesis-alert:sendAlert', function(data, id)
	alert = data
	alertOwner = id
end)