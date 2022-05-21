local Keys = {
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
CreateThread(function()
	while ESX == nil do
		TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) 
			ESX = obj 
		end)
		
		Citizen.Wait(250)
	end
end)

CreateThread(function()
    Citizen.Wait(1000)
	for i=1, #Config.Blipy, 1 do
		local blip = AddBlipForCoord(Config.Blipy[i].Pos)

		SetBlipSprite (blip, Config.Blipy[i].Sprite)
		SetBlipDisplay(blip, Config.Blipy[i].Display)
		SetBlipScale  (blip, Config.Blipy[i].Scale)
		SetBlipColour (blip, Config.Blipy[i].Colour)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.Blipy[i].Label)
		EndTextCommandSetBlipName(blip)
	end
end)

local jablkoQTE = 0
local jablko_poochQTE
local myJob 					= nil
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local isInZone                  = false
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local drunk 					= 0
local cooldown = false

AddEventHandler('exile_items:hasEnteredMarker', function(zone)


    ESX.UI.Menu.CloseAll()
    if IsPedInAnyVehicle(PlayerPedId(), false) then
		return
	end

	if zone == 'JablkoField' then
		CurrentAction     = zone
		CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~, aby zbierać jabłka'
		CurrentActionData = {}
	end

	if zone == 'JablkoField2' then
		CurrentAction     = zone
		CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~, aby zbierać jabłka'
		CurrentActionData = {}
	end

	if zone == 'JablkoField3' then
		CurrentAction     = zone
		CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~, aby zbierać jabłka'
		CurrentActionData = {}
	end

	if zone == 'JablkoProcessing' then
		if jablkoQTE >= 2 then
			CurrentAction     = zone
			CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~, aby przetworzyć jabłka na kompot'
			CurrentActionData = {}
		end
	end

end)

AddEventHandler('exile_items:exitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
	TriggerServerEvent(GetCurrentResourceName() .. ':stopzbieranko' .. Config.AuthorizedKey, zone)
	TriggerServerEvent(GetCurrentResourceName() .. ':stopprzerabianko' .. Config.AuthorizedKey, zone)
	
	cooldown = true
	Citizen.Wait(10000)
	cooldown = false
end)

CreateThread(function()
	while Config.Zones == nil do
		Citizen.Wait(500)
	end

	while true do
		Citizen.Wait(0)
		sleep = true
		local coords = GetEntityCoords(PlayerPedId())
		for k,v in pairs(Config.Zones) do

			if #(coords - vec3(v.x, v.y, v.z)) < Config.DrawDistance then
				ESX.DrawMarker(vec3(v.x, v.y, v.z))
				sleep = false
			end
		end
		if sleep then
			Wait(2000)
		end
	end
end)

RegisterNetEvent('exile_items:returnInventory')
AddEventHandler('exile_items:returnInventory', function(jablkaNbr, jablkapNbr, jobName, currentZone)
	jablkoQTE = jablkaNbr
	jablko_poochQTE = jablkapNbr
	myJob		 = jobName
	TriggerEvent('exile_items:hasEnteredMarker', currentZone)
end)

CreateThread(function()
	while Config.Zones == nil do
		Citizen.Wait(500)
	end
	while true do
		Citizen.Wait(1000)

		local coords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			if #(coords - vec3(v.x, v.y, v.z)) <= Config.ZoneSize.x then
				isInMarker  = true
				currentZone = k
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			lastZone				= currentZone
			TriggerServerEvent('exile_items:getInventory', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('exile_items:exitedMarker', lastZone)
		end

		if isInMarker and isInZone then
			TriggerEvent('exile_items:hasEnteredMarker', 'exitMarker')
		end
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(5)
		if CurrentAction ~= nil and cooldown == false then
			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			if IsControlJustReleased(0, Keys['E']) and not IsPedInAnyVehicle(PlayerPedId(), false) then
				isInZone = true
				if CurrentAction == 'JablkoField' then
					TriggerServerEvent(GetCurrentResourceName() .. ':zbieranko' .. Config.AuthorizedKey, 'jablko')
				elseif CurrentAction == 'JablkoField2' then
					TriggerServerEvent(GetCurrentResourceName() .. ':zbieranko' .. Config.AuthorizedKey, 'jablko')
				elseif CurrentAction == 'JablkoField3' then
					TriggerServerEvent(GetCurrentResourceName() .. ':zbieranko' .. Config.AuthorizedKey, 'jablko')
				elseif CurrentAction == 'JablkoProcessing' then
					TriggerServerEvent(GetCurrentResourceName() .. ':przerabianko' .. Config.AuthorizedKey, 'jablko', 'jablko')
				else
					isInZone = false
				end

				CurrentAction = nil
			end
		else
			Wait(1000)
		end
	end
end)

RegisterNetEvent('exile_items:DodajHP')
AddEventHandler('exile_items:DodajHP', function(ileHP)
	local playerPed = PlayerPedId()
	Citizen.InvokeNative(0x6B76DC1F3AE6E6A3, playerPed, ileHP)
end)

-- [[ SPADOCHRONY ]]
RegisterNetEvent("xfsd-parachute:addPedParachute")
AddEventHandler("xfsd-parachute:addPedParachute", function()
    local weapon = GetHashKey("GADGET_PARACHUTE")
    local ped = GetPlayerPed(PlayerId())
    Citizen.InvokeNative(0xBF0FD6E56C964FCB, ped, weapon, 1000, false, false)
    SetPedComponentVariation(GetPlayerPed(-1), 5, 63, 0, 0)
end)

RegisterNetEvent("xfsd-parachute:removePedParachute")
AddEventHandler("xfsd-parachute:removePedParachute", function()
    local weapon = GetHashKey("GADGET_PARACHUTE")
    local ped = GetPlayerPed(PlayerId())
    Citizen.InvokeNative(0x4899CB088EDF59B8, ped, weapon)
    Wait(10)
    SetPedComponentVariation(GetPlayerPed(-1), 5, 0, 0, 0)
end)

RegisterNetEvent("xfsd-parachute:removePedParachute2")
AddEventHandler("xfsd-parachute:removePedParachute2", function()
    local weapon = GetHashKey("GADGET_PARACHUTE")
    local ped = GetPlayerPed(PlayerId())
    SetPedComponentVariation(GetPlayerPed(-1), 5, 0, 0, 0)
end)

RegisterNetEvent("falszywyy:dodaj_molotov")
AddEventHandler("falszywyy:dodaj_molotov", function()
    local weapon = GetHashKey("weapon_molotov")
    local ped = GetPlayerPed(PlayerId())
    Citizen.InvokeNative(0xBF0FD6E56C964FCB, ped, weapon, 1, false, true)
end)

RegisterNetEvent("falszywyy:usun_molotov")
AddEventHandler("falszywyy:usun_molotov", function()
    local weapon = GetHashKey("weapon_molotov")
    local ped = GetPlayerPed(PlayerId())
    Citizen.InvokeNative(0x4899CB088EDF59B8, ped, weapon)
    Wait(10)
end)

RegisterNetEvent("falszywyy:dodaj_flashbang")
AddEventHandler("falszywyy:dodaj_flashbang", function()
    local weapon = GetHashKey("weapon_flashbang")
    local ped = GetPlayerPed(PlayerId())
    Citizen.InvokeNative(0xBF0FD6E56C964FCB, ped, weapon, 1, false, true)
end)

RegisterNetEvent("falszywyy:usun_flashbang")
AddEventHandler("falszywyy:usun_flashbang", function()
    local weapon = GetHashKey("weapon_flashbang")
    local ped = GetPlayerPed(PlayerId())
    Citizen.InvokeNative(0x4899CB088EDF59B8, ped, weapon)
    Wait(10)
end)

local playerPed = PlayerPedId()

CreateThread(function()
	while true do
	  	Citizen.Wait(1200)
		if IsEntityInWater(playerPed) then
			TriggerServerEvent('falszywyy:przemakanie')
		end
	  end
end)