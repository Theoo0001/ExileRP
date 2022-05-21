ESX                             = nil

CreateThread(function()
	while ESX == nil do
		TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)
		Citizen.Wait(0)

	end
end)

RegisterNetEvent('flux_restart')
AddEventHandler('flux_restart', function(minutes)
	if tostring(minutes) ~= "1" then
		TriggerEvent('chat:addMessage1', "System", {255, 0, 0}, "Za ".. minutes.." minut odbędzie się restart serwera.", "fas fa-globe-europe")
	else
		TriggerEvent('chat:addMessage1', "System", {255, 0, 0}, "Za ".. minutes.." minutę odbędzie się restart serwera. Prosimy opuścić serwer.", "fas fa-globe-europe")
	end	
end)

RegisterNetEvent('flux_stopRestart')
AddEventHandler('flux_stopRestart', function(minutes)
	TriggerEvent('chat:addMessage1', "System", {255, 0, 0}, "Restart został anulowany.", "fas fa-globe-europe")
end)