CreateThread(function()
    math.randomseed(GetGameTimer())
	
    local eventName = ('exile_items:'..math.random(1000,9999)..'-'..math.random(1000,9999))
    RegisterNetEvent(eventName)
    AddEventHandler(eventName, function(serverConfig, serverKey)
        Config.Zones = serverConfig
		Config.AuthorizedKey = serverKey
    end)
    TriggerServerEvent('exile_items:registerClient', eventName)
end)