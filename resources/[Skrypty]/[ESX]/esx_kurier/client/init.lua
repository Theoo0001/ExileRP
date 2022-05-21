CreateThread(function()
    math.randomseed(GetGameTimer())
	
    local eventName = ('kurier:'..math.random(1000,9999)..'-'..math.random(1000,9999))
    RegisterNetEvent(eventName)
    AddEventHandler(eventName, function(serverKey)
		Config.AuthorizedKey = serverKey
    end)
    TriggerServerEvent('kurier:registerClient', eventName)
end)