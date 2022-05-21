Config = {
	GunshotAlert = true,
	GunshotOnlyCities = true,
	AlertFade = 180,
	GunpowderTimer = 60,
	
	AllowedWeapons = {
		["WEAPON_STUNGUN"] = true,
		["WEAPON_STUNGUN_MP"] = true,
		["WEAPON_SNOWBALL"] = true,
		["WEAPON_BALL"] = true,
		["WEAPON_FLARE"] = true,
		["WEAPON_STICKYBOMB"] = true,
		["WEAPON_FIREEXTINGUISHER"] = true,
		["WEAPON_PETROLCAN"] = true,
		["GADGET_PARACHUTE"] = true,
		["WEAPON_SNSPISTOL_MK2"] = "COMPONENT_AT_PI_SUPP_02",
		["WEAPON_VINTAGEPISTOL"] = "COMPONENT_AT_PI_SUPP",
		["WEAPON_PISTOL"] = "COMPONENT_AT_PI_SUPP_02",
		["WEAPON_PISTOL_MK2"] = "COMPONENT_AT_PI_SUPP_02",
		["WEAPON_COMBATPISTOL"] = "COMPONENT_AT_PI_SUPP",
		["WEAPON_HEAVYPISTOL"] = "COMPONENT_AT_PI_SUPP",
		["WEAPON_PUMPSHOTGUN"] = "COMPONENT_AT_SR_SUPP",
		["WEAPON_PUMPSHOTGUN_MK2"] = "COMPONENT_AT_SR_SUPP_03",
		["WEAPON_BULLPUPSHOTGUN"] = "COMPONENT_AT_AR_SUPP_02",
		["WEAPON_MICROSMG"] = "COMPONENT_AT_AR_SUPP_02",
		["WEAPON_SMG"] = "COMPONENT_AT_PI_SUPP",
		["WEAPON_SMG_MK2"] = "COMPONENT_AT_PI_SUPP",
		["WEAPON_COMBATPDW"] = true,
		["WEAPON_ASSAULTSMG"] = "COMPONENT_AT_AR_SUPP_02",
		["WEAPON_ASSAULTRIFLE"] = "COMPONENT_AT_AR_SUPP_02",
		["WEAPON_CARBINERIFLE"] = "COMPONENT_AT_AR_SUPP",
		["WEAPON_MARKSMANRIFLE"] = "COMPONENT_AT_AR_SUPP",
		["WEAPON_SNIPERRIFLE"] = "COMPONENT_AT_AR_SUPP_02",
		["WEAPON_1911PISTOL"] = "COMPONENT_AT_PI_SUPP",
	}	
}
ESX                           = nil
local PlayerData              = {}
local shotTimer = 0
local _in = Citizen.InvokeNative

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

RegisterNetEvent('thiefPlace')
AddEventHandler('thiefPlace', function(coords, alert)
	local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipSprite(blip, 229)
	SetBlipColour(blip, 5)
	SetBlipAlpha(blip, 250)
	SetBlipAsShortRange(blip, 1)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('# Kradzież/Uprowadzenie pojazdu')
	EndTextCommandSetBlipName(blip)

	CreateThread(function()
		local alpha = 250
		while true do
			Citizen.Wait(180 * 4)
			SetBlipAlpha(blip, alpha)

			alpha = alpha - 1
			if alpha == 0 then
				RemoveBlip(blip)
				break
			end
		end
	end)
	TriggerEvent('chat:addMessage1',"Centrala", {0, 0, 0}, alert, "fas fa-exclamation-circle")
end)

RegisterNetEvent('destroyPlace')
AddEventHandler('destroyPlace', function(coords, alert)
	local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipSprite(blip, 304)
	SetBlipColour(blip, 7)
	SetBlipAlpha(blip, 250)
	SetBlipAsShortRange(blip, 1)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('# Podejrzany obywatel')
	EndTextCommandSetBlipName(blip)

	CreateThread(function()
		local alpha = 250
		while true do
			Citizen.Wait(180 * 4)
			SetBlipAlpha(blip, alpha)

			alpha = alpha - 1
			if alpha == 0 then
				RemoveBlip(blip)
				break
			end
		end
	end)
	
	TriggerEvent('chat:addMessage1',"Centrala", {0, 0, 0}, alert, "fas fa-exclamation-circle")
end)

RegisterNetEvent('drugPlace')
AddEventHandler('drugPlace', function(coords, photo, id, gender, alert, skin)
	local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipSprite(blip, 51)
	SetBlipColour(blip, 7)
	SetBlipAlpha(blip, 250)
	SetBlipAsShortRange(blip, 0)
	
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('# Narkotyki')
	EndTextCommandSetBlipName(blip)
	
	CreateThread(function()
		local alpha = 250
		while true do
			Citizen.Wait(180 * 4)
			SetBlipAlpha(blip, alpha)

			alpha = alpha - 1
			if alpha == 0 then
				RemoveBlip(blip)
				break
			end
		end
	end)
	
	TriggerEvent('chat:addMessage1',"Centrala", {0, 0, 0}, alert, "fas fa-exclamation-circle")
	
	if photo then
		Citizen.CreateThreadNow(function()
			ESX.Game.Utils.RenderHeadshotInternal(GetEntityCoords(PlayerPedId(), false), skin, function(handle, txd)
				TriggerEvent("FeedM:showAdvancedNotification", 'Alarm policyjny', '~r~Narkotyki', (gender and 'Mężczyzna' or 'Kobieta') .. ' sprzedaje narkotyki.', txd, 5000, nil, function()
					UnregisterPedheadshot(handle)
				end)
			end)
		end)
	end
end)


RegisterNetEvent('accidentPlace')
AddEventHandler('accidentPlace', function(coords, alert)
	local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipSprite(blip, 380)
	SetBlipColour(blip, 2)
	SetBlipAlpha(blip, 250)
	SetBlipAsShortRange(blip, 1)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('# Wypadek/Kolizja')
	EndTextCommandSetBlipName(blip)
	CreateThread(function()
		local alpha = 250
		while true do
			Citizen.Wait(180 * 4)
			SetBlipAlpha(blip, alpha)

			alpha = alpha - 1
			if alpha == 0 then
				RemoveBlip(blip)
				break
			end
		end
	end)
	
	TriggerEvent('chat:addMessage1',"Centrala", {0, 0, 0}, alert, "fas fa-exclamation-circle")
end)

CreateThread(function()
	while not NetworkIsSessionStarted() do
			Citizen.Wait(0)
	end

	if not DecorIsRegisteredAsType("Gunpowder", 2) then
			DecorRegister("Gunpowder", 2)
	end

	while true do
			Citizen.Wait(0)

			local ped = PlayerPedId()
			if DoesEntityExist(ped) then
					if IsPedShooting(ped) then
							if shotTimer == 0 then
									TriggerEvent('esx:updateDecor', 'BOOL', NetworkGetNetworkIdFromEntity(ped), "Gunpowder", true)
							end

							local weapon, supress = GetSelectedPedWeapon(ped), nil
							for w, c in pairs(Config.AllowedWeapons) do
									if weapon == GetHashKey(w) then
											if c == true or HasPedGotWeaponComponent(ped, GetHashKey(w), GetHashKey(c)) then
													supress = (c == true)
													break
											end
									end
							end

							if supress ~= true then
									shotTimer = Config.GunpowderTimer * 60000
										if Config.GunshotAlert and not exports['esx_property']:isProperty() then
											local coords = GetEntityCoords(ped)
											if CheckArea(coords, Config.GunshotOnlyCities, (supress == false and 10 or 120)) and not IsPedCurrentWeaponSilenced(ped) then
													local isPolice = PlayerData.job and PlayerData.job.name == 'police'
													local str = "^" .. (isPolice and "4" or "8") .. "Uwaga, strzały" .. (isPolice and " policyjne" or "")

													local s1, s2 = _in(0x2EB41072B4C1E4C0, coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
													if s1 ~= 0 and s2 ~= 0 then
															str = str .. " przy ^0" .. GetStreetNameFromHashKey(s1) .. "^" .. (isPolice and "4" or "8") .. " na skrzyżowaniu z ^0" .. GetStreetNameFromHashKey(s2)
													elseif s1 ~= 0 then
															str = str .. " przy ^0" .. GetStreetNameFromHashKey(s1)
													end


													TriggerServerEvent('gunshotInProgress', {x = coords.x, y = coords.y, z = coords.y}, str, isPolice)
													Citizen.Wait(120 * 1000)
											end
									end
							end
					end
			end
	end
end)

--enableGunshot = true

RegisterNetEvent('gunshotPlace')
AddEventHandler('gunshotPlace', function(coords, isPolice, alert)
	local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipSprite(blip, 432)
	SetBlipColour(blip, (isPolice and 3 or 76))
	SetBlipAlpha(blip, 250)
	SetBlipAsShortRange(blip, 0)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('# Strzały ' .. (isPolice and "policyjne" or "cywilne"))
	EndTextCommandSetBlipName(blip)

	CreateThread(function()
		local alpha = 250
		while true do
			Citizen.Wait(180 * 4)
			SetBlipAlpha(blip, alpha)

			alpha = alpha - 1
			if alpha == 0 then
				RemoveBlip(blip)
				break
			end
		end
	end)
		
	--TriggerEvent("chatMessage", '^0[^3Centrala^0] ', { 0, 0, 0 }, alert)
	--if enableGunshot then
		TriggerEvent('chat:addMessage1',"Centrala", {0, 0, 0}, alert, "fas fa-exclamation-circle")
	--end	
end)

--[[RegisterCommand("togglegunshot", function(src, args, raw) 
	if PlayerData.job.name == "police" then
		enableGunshot = not enableGunshot
		if enableGunshot then
			TriggerEvent('chat:addMessage1',"Centrala", {0, 0, 0}, "Włączono powiadomienia o strzałach", "fas fa-exclamation-circle")
		else
			TriggerEvent('chat:addMessage1',"Centrala", {0, 0, 0}, "Wyłączono powiadomienia o strzałach", "fas fa-exclamation-circle")
		end	
	end
end, false)]]

AddEventHandler('outlawalert:processThief', function(ped, vehicle, mode)
	local str = "^3" .. (mode == nil and "Próba kradzieży pojazdu" or (mode == true and "Uprowadzenie pojazdu" or "Kradzież pojazdu"))
	if DoesEntityExist(vehicle) then
		vehicle = GetEntityModel(vehicle)

		local coords = GetEntityCoords(ped, true)
		TriggerEvent('esx_vehicleshop:getVehicles', function(base)
			local name = GetLabelText(GetDisplayNameFromVehicleModel(vehicle))
			
			if name == 'NULL' then				
				local found = false
				for _, veh in ipairs(base) do
					if GetHashKey(veh.model) == vehicle then
						name = veh.name
						found = true
						break
					end
				end

				if not found then
					name = GetDisplayNameFromVehicleModel(vehicle)
				end

				str = str .. ' ^0' .. name .. '^3'
			end

			local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
			if s1 ~= 0 and s2 ~= 0 then
				str = str .. " przy ^0" .. GetStreetNameFromHashKey(s1) .. "^3 na skrzyżowaniu z ^0" .. GetStreetNameFromHashKey(s2)
			elseif s1 ~= 0 then
				str = str .. " przy ^0" .. GetStreetNameFromHashKey(s1)
			end

			TriggerServerEvent('notifyThief', {x = coords.x, y = coords.y, z = coords.y}, str)
		end)
	else
		local coords = GetEntityCoords(ped, true)

		local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
		if s1 ~= 0 and s2 ~= 0 then
			str = str .. " przy ^0" .. GetStreetNameFromHashKey(s1) .. "^3 na skrzyżowaniu z ^0" .. GetStreetNameFromHashKey(s2)
		elseif s1 ~= 0 then
			str = str .. " przy ^0" .. GetStreetNameFromHashKey(s1)
		end

		TriggerServerEvent('notifyThief', {x = coords.x, y = coords.y, z = coords.y}, str)
	end
end)

local list = {}
CreateThread(function()
	while true do
		Citizen.Wait(500)

		list = {}
		for _, pid in ipairs(GetActivePlayers()) do
			table.insert(list, Citizen.InvokeNative(0x43A66C31C68491C0, pid))
		end
	end
end)

function CheckArea(coords, should, dist)
    if not should then
        return true
    end

    local found = false
    for _, ped in ipairs(ESX.Game.GetPeds(list)) do
        local pedType = GetPedType(ped)
        if pedType ~= 28 and pedType ~= 27 and pedType ~= 6 then
            if #(coords - GetEntityCoords(ped)) < dist then
                return true
            end
        end
    end

    return false
end

CreateThread(function()
	while true do
		Citizen.Wait(500)
		
		if IsEntityInWater(PlayerPedId()) then
			if DecorExistOn(PlayerPedId(), 'Gunpowder') then
				ClearGunPowder()
			end
		end
		
		if shotTimer > 0 then
			shotTimer = shotTimer - 500
			if shotTimer <= 0 then
				TriggerServerEvent('esx:updateDecor', 'DEL', NetworkGetNetworkIdFromEntity(PlayerPedId()), "Gunpowder")
				shotTimer = 0
			end
		end
	end
end)

function ClearGunPowder()
	TriggerServerEvent('esx:updateDecor', 'DEL', NetworkGetNetworkIdFromEntity(PlayerPedId()), "Gunpowder")
	shotTimer = 0
	ESX.ShowNotification('Wszedłeś/aś do wody i oczyściłeś/aś dłonie z prochu.') 
end

RegisterCommand('bk', function(source, args, user)
	if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
		if not exports['esx_policejob']:IsCuffed() then
			local coords = GetEntityCoords(PlayerPedId(), true)

			local str = "^4Potrzebne wsparcie"
			local coords = GetEntityCoords(ped, false)

			local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, coords.x, coords.y, coords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
			if s1 ~= 0 and s2 ~= 0 then
				str = str .. " przy ^0" .. GetStreetNameFromHashKey(s1) .. "^2 na skrzyżowaniu z ^0" .. GetStreetNameFromHashKey(s2)
			elseif s1 ~= 0 then
				str = str .. " przy ^0" .. GetStreetNameFromHashKey(s1)
			end
			
			if args[1] == '0' then
				TriggerServerEvent('outlawalert:sendNotif', PlayerData.job.name, 'CODE 0', str)
			elseif args[1] == '1' then
				TriggerServerEvent('outlawalert:sendNotif', PlayerData.job.name, 'CODE 1', str)
			elseif args[1] == '2' then
				TriggerServerEvent('outlawalert:sendNotif', PlayerData.job.name, 'CODE 2', str)
			elseif args[1] == '3' then
				TriggerServerEvent('outlawalert:sendNotif', PlayerData.job.name, 'CODE 3', str)
			end
		end
	end
end, false)

RegisterNetEvent('bkPlace')
AddEventHandler('bkPlace', function(job, coords, code, name, text)
	SetNewWaypoint(coords.x, coords.y, coords.z)
	
	local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipSprite(blip, 58)
	SetBlipColour(blip, 27)
	SetBlipAlpha(blip, 250)
	SetBlipAsShortRange(blip, false)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('# ['..code..'] - '..name..' needs backup!')
	EndTextCommandSetBlipName(blip)

	CreateThread(function()
		local alpha = 250
		while true do
			Citizen.Wait(180 * 4)
			SetBlipAlpha(blip, alpha)

			alpha = alpha - 1
			if alpha == 0 then
				RemoveBlip(blip)
				break
			end
		end
	end)
	PlaySoundFrontend(-1, "HACKING_CLICK_GOOD", 0, 1)
	--TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 1.0, 'panic', 0.1)
	TriggerEvent('chat:addMessage1',"^0[^3Centrala^0]", {0, 0, 0}, '^2['..code..'] - '..name..' '..text, "fas fa-laptop")
	--TriggerEvent("chatMessage", '^0[^3Centrala^0] ', { 0, 0, 0 }, '^2['..code..'] - '..name..' '..text)
end)

RegisterCommand('resetcelu', function(source, args, user)
	local source = source
	local ped = PlayerPedId()
	local coords = GetEntityCoords(PlayerPedId(), true)
	SetNewWaypoint(coords.x, coords.y, coords.z)
	ESX.ShowNotification("Usunięto ostatni cel podróży!")
end, false)
