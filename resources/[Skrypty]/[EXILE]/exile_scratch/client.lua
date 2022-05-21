ESX = nil

CreateThread(function()
	while ESX == nil do
		TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) 
			ESX = obj 
		end)
		
		Citizen.Wait(250)
	end
end)

local isScratching = false

RegisterNetEvent('flux_scratchcard:showSC')
AddEventHandler('flux_scratchcard:showSC', function(scratch, component)
	if isScratching == false then	
		isScratching = true
		CreateThread(function()
			Citizen.Wait(100)
			Citizen.InvokeNative(0x142A02425FF02BD, PlayerPedId(), "PROP_HUMAN_PARKING_METER", 0, false)
			SetNuiFocus(true, true)
			SendNUIMessage({type = 'showNUI', scratch = scratch, component = component})
		end)
	end
end)

RegisterNUICallback('NUIFocusOff', function()
		isScratching = false
		SetNuiFocus(false, false)
		Citizen.InvokeNative(0xAAA34F8A7CB32098, PlayerPedId())
		TriggerServerEvent('flux_scratchcard:payment')
end)

CreateThread(function()
	SetNuiFocus(false, false)
end)