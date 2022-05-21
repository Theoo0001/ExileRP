RegisterNetEvent('rlUpdateNames')
AddEventHandler('rlUpdateNames', function()
    local names = {}

    for _, player in ipairs(GetActivePlayers()) do
        names[GetPlayerServerId(player)] = { id = player, name = GetPlayerName(player) }
    end

    TriggerServerEvent('rlUpdateNamesResult', names)
end)

CreateThread(function()
	while true do
		Wait(0)

		if NetworkIsSessionStarted() then
			TriggerServerEvent('rlPlayerActivated')

			return
		end
	end
end)