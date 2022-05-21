ESX = nil
local PlayerData = {}
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

RegisterNetEvent('esx_impound')
AddEventHandler('esx_impound', function(type, police)
	local playerPed = PlayerPedId()

	local vehicle = nil
	if IsPedInAnyVehicle(playerPed, false) then
		vehicle = GetVehiclePedIsIn(playerPed, false)
	else
		vehicle = ESX.Game.GetVehicleInDirection()
		if not vehicle then
			local coords = GetEntityCoords(playerPed, false)
			if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
			  vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
			end
		end
	end
	
	if vehicle and vehicle ~= 0 then
		if PlayerData.job and PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'police' or PlayerData.job.name == 'mechanik' or PlayerData.job.name == 'mechanik2' or PlayerData.job.name == 'mechanik3' or PlayerData.job.name == 'mechanik4' or PlayerData.job.name == 'sheriff' or Playerdata.job.name then
			local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
			if vehicleProps then
				ESX.TriggerServerCallback('esx_impound:checkVehicleOwner', function(data, model, owner)
					TriggerEvent('esx_vehicleshop:getVehicles', function(base)
						local name = GetDisplayNameFromVehicleModel(vehicleProps.model)
						if name ~= 'CARNOTFOUND' then				
							local found = false
							for _, veh in ipairs(base) do
								if (veh.name:len() > 0 and veh.name == name) or veh.model == name then
									name = veh.name
									found = true
									break
								end
							end

							if not found then
								local label = GetLabelText(name)
								if label ~= "NULL" then
									name = label
								end
							end
						end

						if data then
							if model.model == vehicleProps.model then
								if police then 
									TriggerServerEvent('flux_garages:addCarFromPoliceParking', vehicleProps.plate)
								else
									TriggerServerEvent('flux_garages:updateState', vehicleProps.plate)
								end
							end
						else
							data = {
								foundOwner = false
							}
						end

						if GetVehicleNumberPlateText(vehicle) == vehicleProps.plate then
							--TriggerEvent('ls:notify', vehicleProps.plate, '~y~Pojazd: ~s~' .. name .. '\n~y~Własność: ~s~' .. (owner and owner or 'Brak danych'), 2.0)
							ESX.ShowAdvancedNotification('ExileRP', vehicleProps.plate, '~y~Pojazd: ~s~' .. name .. '\n~y~Własność: ~s~' .. (owner and owner or 'Brak danych'), 'CHAR_BANK_MAZE', 6000)
						else
							--TriggerEvent('ls:notify', '~r~--------~s~', '~y~Pojazd: ~s~' .. name .. '\n~y~Własność: ~s~Brak danych', 2.0)
							ESX.ShowAdvancedNotification('ExileRP', '~r~--------~s~', '~y~Pojazd: ~s~' .. name .. '\n~y~Własność: ~s~Brak danych', 'CHAR_BANK_MAZE', 6000)
						end
						
						ESX.Game.DeleteVehicle(vehicle)
					end)
				end, vehicleProps.plate)
			end
		end
	else
		ESX.ShowNotification('Nie znaleziono pojazdu, podejdź bliżej!!')
	end
end)