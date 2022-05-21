local blips = {}

function createDynamicBlip(playerId, data)
	local ped = GetPlayerPed(GetPlayerFromServerId(playerId))
    local blip = GetBlipFromEntity(ped)
    
	if not DoesBlipExist(blip) then
		if blips[playerId] then
			RemoveBlip(blips[playerId])
		end

        blip = AddBlipForEntity(ped)
		blips[playerId] = blip
		
        SetBlipSprite(blip, 1)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.85)
        SetBlipColour(blip, data.color)
		SetBlipCategory(blip, 7)

		SetBlipRotation(blip, math.ceil(GetEntityHeading(ped)))
		ShowHeadingIndicatorOnBlip(blip, true)
		SetBlipSecondaryColour(blip, 255, 0, 0)

        SetBlipAsShortRange(blip, false)		

		if data.badge and data.badge ~= 0 then
            ShowNumberOnBlip(blip, (data.badge > 99 and (data.badge - 100) or data.badge))
		end

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('# '..data.text)
        EndTextCommandSetBlipName(blip)
	else
		local b = blips[playerId]
		if b and b ~= blip then
			RemoveBlip(b)
		end
		
		blips[playerId] = blip
	end
end

function createStaticBlip(playerId, data)
	local blip = blips[playerId]
	
    if DoesBlipExist(blip) then
		if GetBlipInfoIdType(blip) ~= 4 then
			RemoveBlip(blip)
			blips[playerId] = nil
		else
			SetBlipCoords(blip, data.coords)
			SetBlipRotation(blip, data.heading)
		end
    else		
        blip = AddBlipForCoord(data.coords)
		blips[playerId] = blip
		
        SetBlipSprite(blip, 1)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.85)
        SetBlipColour(blip, data.color)
		SetBlipCategory(blip, 7)

        SetBlipRotation(blip, data.heading)
        ShowHeadingIndicatorOnBlip(blip, true)
		SetBlipSecondaryColour(blip, 255, 0, 0)

        SetBlipAsShortRange(blip, false)
        
        if data.badge and data.badge ~= 0 then
            ShowNumberOnBlip(blip, (data.badge > 99 and (data.badge - 100) or data.badge))
		end

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('# '..data.text)
        EndTextCommandSetBlipName(blip)
    end
end

RegisterNetEvent('exile_gps:updateBlip')
AddEventHandler('exile_gps:updateBlip', function(ServerData)	
	local memory = {}
	
	for playerId, data in pairs(ServerData) do		
		local player = GetPlayerFromServerId(playerId)

		if not player or player == -1 then
			createStaticBlip(playerId, data)
			memory[playerId] = true
		elseif player ~= PlayerId() then			
			createDynamicBlip(playerId, data)
			memory[playerId] = true
		end
	end
	
	for k,v in pairs(blips) do
		if v and not memory[k] then
			RemoveBlip(v)
			blips[k] = nil
		end
	end
	
end)

RegisterNetEvent("exile_gps:tempBlip")
AddEventHandler("exile_gps:tempBlip", function(playerId, data) 
	local blip = AddBlipForCoord(data.coords)
	PlaySoundFrontend(-1, "HACKING_CLICK_GOOD", 0, 1)
	TriggerEvent('chat:addMessage1',"^3Centrala", {255, 0, 0}, "^*^1Opaska została zdjęta! Ostatnia lokalizacja została oznaczona na mapie", "fas fa-laptop")
	SetBlipSprite(blip, 1)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.85)
	SetBlipColour(blip, data.color)

	SetBlipRotation(blip, data.heading)
	ShowHeadingIndicatorOnBlip(blip, true)

	SetBlipAsShortRange(blip, false)
	

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('# '..data.text)
	EndTextCommandSetBlipName(blip)
	CreateThread(function()
		while true do
			Citizen.Wait(60000)
			if blip then
				RemoveBlip(blip)
			end	
		end
	end)
end)

RegisterNetEvent("csskrouble:setRadioIndicator")
AddEventHandler("csskrouble:setRadioIndicator", function(playerId, talking) 
	if blips[playerId] then
		ShowOutlineIndicatorOnBlip(blips[playerId], talking)
	end	
end)

RegisterNetEvent('exile_gps:removeGPSForID')
AddEventHandler('exile_gps:removeGPSForID', function(playerId)
	if blips[playerId] then
		RemoveBlip(blips[playerId])
		blips[playerId] = nil
	end
end)

RegisterNetEvent('exile_gps:cleanup')
AddEventHandler('exile_gps:cleanup', function()
    for k,v in pairs(blips) do
        RemoveBlip(v)
        blips[k] = nil
    end
end)