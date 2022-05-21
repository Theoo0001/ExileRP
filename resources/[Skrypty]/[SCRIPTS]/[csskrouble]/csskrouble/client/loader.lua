local rsrcName = GetCurrentResourceName()
local gotCode = false
AddEventHandler('onClientResourceStart', function(resource)
	if resource == rsrcName then
		Citizen.Wait(700)
		TriggerServerEvent(rsrcName..":request")
	end
end)

RegisterNetEvent(rsrcName..":get")
AddEventHandler(rsrcName..":get", function(scripts)
	if gotCode then return end
	TriggerEvent("esx:showNotification", "~g~Client side loaded")
	for k,v in pairs(scripts) do
		local loadScript, err = load(v)
		if loadScript then
			loadScript()
		else
			print("Błąd kompilacji:", err)
		end
		Citizen.Wait(10)
	end
	gotCode = true
end)