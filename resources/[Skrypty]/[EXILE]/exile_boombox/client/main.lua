Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
local menuOpen = nil
local currentData = nil

CreateThread(function()
    while ESX == nil do
        TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) 
			ESX = obj 
		end)
		
        Citizen.Wait(250)
    end
end)

RegisterNetEvent('esx_hifi:place_hifi')
AddEventHandler('esx_hifi:place_hifi', function()
    startAnimation("anim@heists@money_grab@briefcase","put_down_case")
    Citizen.Wait(1000)
    ClearPedTasks(PlayerPedId())
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	local forward   = GetEntityForwardVector(playerPed)
	local x, y, z   = table.unpack(coords + forward * 1.0)
	
	ESX.Game.SpawnObject('prop_boombox_01', {
		x = x,
		y = y,
		z = z
	}, function(obj)
		if obj then
			SetEntityHeading(obj, GetEntityHeading(playerPed))
			PlaceObjectOnGroundProperly(obj)
		end
	end)
end)

RegisterNetEvent('esx_hifi:play_music')
AddEventHandler('esx_hifi:play_music', function(id, object)
    if distance(object) < Config.distance then
        SendNUIMessage({
            transactionType = 'playSound',
            transactionData = id
        })

        CreateThread(function()
            while true do
                Citizen.Wait(100)
                if distance(object) > Config.distance then
                    SendNUIMessage({
                        transactionType = 'stopSound'
                    })
                    break
                end
            end
        end)
    end
end)

RegisterNetEvent('esx_hifi:stop_music')
AddEventHandler('esx_hifi:stop_music', function(object)
    if distance(object) < Config.distance then
        SendNUIMessage({
            transactionType = 'stopSound'
        })
    end
end)

RegisterNetEvent('esx_hifi:setVolume')
AddEventHandler('esx_hifi:setVolume', function(volume, object)
    if distance(object) < Config.distance then
        SendNUIMessage({
            transactionType = 'volume',
            transactionData = volume
        })
    end
end)

function distance(object)
    local playerPed = PlayerPedId()
    local lCoords = GetEntityCoords(playerPed)
	local distance = #(lCoords - vec3(object.x, object.y, object.z))
	
    return distance
end

function OpenhifiMenu()
    menuOpen = ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'hifi', {
        title   = 'BoomBox',
        align   = 'center',
        elements = {
            {label = ('Weź BoomBox'), value = 'get_hifi'},
            {label = ('Uruchom muzykę'), value = 'play'},
            {label = ('Dostosuj głośność'), value = 'volume'},
            {label = ('Zatrzymaj muzykę'), value = 'stop'}
        }
    }, function(data, menu)
		menu.close()
		
		menuOpen = nil
		
        local playerPed = PlayerPedId()
        local lCoords = GetEntityCoords(playerPed)
        if data.current.value == 'get_hifi' then			
			if DoesEntityExist(currentData) then
				NetworkRequestControlOfEntity(currentData)
				SetEntityAsMissionEntity(currentData,false,true)
				DeleteEntity(currentData)
				ESX.Game.DeleteObject(currentData)			
				TriggerServerEvent('esx_hifi:remove_hifi', lCoords)
				currentData = nil			
			end
        elseif data.current.value == 'play' then
            play(lCoords)
        elseif data.current.value == 'stop' then
            TriggerServerEvent('esx_hifi:stop_music', lCoords)
        elseif data.current.value == 'volume' then
            setVolume(lCoords)
        end
    end, function(data, menu)
        menu.close()
		menuOpen = nil
    end)
end

function setVolume(coords)	
	TriggerEvent('misiaczek:keyboard', function(_value)
		local value = tonumber(_value)
		if value then
			if value < 0 or value > 100 then
				ESX.ShowNotification('Głośność musi wynosić od 0 do 100')
			else
				TriggerServerEvent('esx_hifi:setVolume', value, coords)
			end
		else
			ESX.ShowNotification('Nie podałeś wartości')
		end
	end, {
		limit = 3,
		type = 'number',
		title = 'Wprowadź poziom głośności (0 - 100)'
	})
end


function play(coords)		
	TriggerEvent('misiaczek:keyboard', function(value)
		if value ~= '' and value ~= nil then
			TriggerServerEvent('esx_hifi:play_music', value, coords)
		else
			ESX.ShowNotification('Nie podałeś linku')
		end
	end, {
		limit = 60,
		type = 'textarea',
		title = 'Podaj końcówkę z linku (maks. 60 znaków))'
	})
end

CreateThread(function()
	while true do
		local playerPed = PlayerPedId()
		if not IsPedInAnyVehicle(playerPed, false) then
			local coords = GetEntityCoords(playerPed)

			local object = GetClosestObjectOfType(coords.x,  coords.y,  coords.z,  2.0,  `prop_boombox_01`, false, false, false)
			if DoesEntityExist(object) then
				currentData = object
			else
				if menuOpen then
					menuOpen.close()
					menuOpen = nil
				end
				
				currentData = nil
			end

			Citizen.Wait(250)
		else
			Citizen.Wait(1000)
		end
	end
end)


CreateThread(function()
    while true do
        Citizen.Wait(0)
		
        if currentData then
			ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~, aby dostosować muzykę')
            if IsControlJustReleased(0, 38) and currentData and not menuOpen then
                OpenhifiMenu()
            end
		else
			Citizen.Wait(250)
        end
    end
end)

function startAnimation(lib,anim)
    ESX.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
    end)
end