local Beds = {
	['Pillbox'] = {
		{
			Position = vector4(1132.92, -1547.28, 42.89-0.80, 262.5),
			GetUp = vector4(1135.99, -1557.21, 35.4, 262.5),
			Occupied = false
		},
		{
			Position = vector4(1132.81, -1568.31, 42.89-0.80, 262.5),
			GetUp = vector4(1135.99, -1557.21, 35.4, 262.5),
			Occupied = false
		},
	},
	
	['Paleto'] = {
		{
			Position = vector4(-257.55, 6321.86, 33.35, 309.0),
			GetUp = vector4(-256.72, 6321.24, 32.43, 318.31),
			Occupied = false
		},
		{
			Position = vector4(-259.91, 6324.1, 33.35, 317.0),
			GetUp = vector4(-259.4, 6323.46, 32.43, 308.01),
			Occupied = false
		},
		{
			Position = vector4(-256.51, 6327.96, 33.35, 134.0),
			GetUp = vector4(-257.48, 6328.45, 32.43, 123.33),
			Occupied = false
		},
		{
			Position = vector4(-262.28, 6326.53, 33.35, 313.0),
			GetUp = vector4(-261.52, 6325.98, 32.43, 317.75),
			Occupied = false
		},
		{
			Position = vector4(-258.85, 6330.08, 33.35, 139.0),
			GetUp = vector4(-259.77, 6330.76, 32.43, 133.99),
			Occupied = false
		},
	},
	
	['Sandy'] = {
		{
			Position = vector4(1820.06, 3669.60, 34.24, 299.33),
			GetUp = vector4(1821.50, 3670.35, 33.32, 299.83),
			Occupied = false
		},
		{
			Position = vector4(1823.02, 3672.12, 34.24, 119.66),
			GetUp = vector4(1823.75, 3671.35, 33.32, 212.84),
			Occupied = false
		},
		{
			Position = vector4(1819.26, 3671.34, 34.24, 299.85),
			GetUp = vector4(1820.47, 3672.02, 33.32, 299.94),
			Occupied = false
		},
		{
			Position = vector4(1818.35, 3672.99, 34.24, 300.02),
			GetUp = vector4(1819.50, 3673.70, 33.32, 299.31),
			Occupied = false
		},
		{
			Position = vector4(1822.04, 3673.96, 34.24, 119.78),
			GetUp = vector4(1821.66, 3674.84, 33.32, 32.62),
			Occupied = false
		},
		{
			Position = vector4(1817.30, 3674.69, 34.24, 297.91),
			GetUp = vector4(1817.16, 3675.74, 33.32, 30.84),
			Occupied = false
		},
	},  
}

RegisterServerEvent('Exile:BarabaszUnoccupied')
AddEventHandler('Exile:BarabaszUnoccupied', function(id, zone)
	if zone ~= nil and id ~= nil and Beds[zone][id].Occupied == true then
		Beds[zone][id].Occupied = false
	end
end)

function StartTreatment(source, zone, price, accountType)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local currentBed = nil
	local currentId = nil
	local currentZone = zone

	if currentZone ~= nil then
		for i=1, #Beds[currentZone], 1 do
			if Beds[currentZone][i].Occupied == false then
				currentBed = Beds[currentZone][i]
				currentId = i
				Beds[currentZone][i].Occupied = true
				break
			end
		end
	end

	if currentBed == nil then
		xPlayer.showNotification('~r~Brak wolnych łóżek')
	else
		if price ~= 0 then
			if accountType == "money" then
				xPlayer.removeMoney(price)
			else
				xPlayer.removeAccountMoney('bank', price)
			end
			xPlayer.showNotification("Zapłaciłeś ~g~"..price.."$~w~ za ~y~pomoc medyczną...")
		else
			xPlayer.showNotification("W ramach ~g~ubezpieczenia~w~ otrzymałeś ~y~pomoc medyczną...")
		end

		TriggerClientEvent('Exile:BarabaszAnim', _source, currentId, currentZone, currentBed)
	end
end

RegisterServerEvent('Exile:Barabasz')
AddEventHandler('Exile:Barabasz', function(ems, zone, accountType)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local HasInsurance = exports['esx_exilemenu']:CheckInsuranceEMS(xPlayer.job.name)

	if ems == 0 then
		TriggerEvent('esx_license:checkLicense', _source, "ems_insurance", function(has)
			if has or HasInsurance then
				StartTreatment(_source, zone, 0, accountType)
			else
				--if xPlayer.getAccount('bank').money >= 10000 or xPlayer.getMoney() >= 10000 then	
				if accountType == "money" then
					if xPlayer.getMoney() >= 10000 then
						StartTreatment(_source, zone, 10000, accountType)
					else
						xPlayer.showNotification("~r~Nie posiadasz ~g~10.000$~r~ aby zapłacić za ~g~pomoc medyczną")
					end
				elseif accountType == "bank" then
					if xPlayer.getAccount('bank').money >= 10000 then
						StartTreatment(_source, zone, 10000, accountType)
					else
						xPlayer.showNotification("~r~Nie posiadasz ~g~10.000$~r~ aby zapłacić za ~g~pomoc medyczną")
					end
				end
			end
		end)
	else
		TriggerEvent('esx_license:checkLicense', _source, "ems_insurance", function(has)
			local price
			if has or HasInsurance then
				price = 5000
			else
				price = 20000
			end

			if accountType == "money" then
				if xPlayer.getMoney() >= price then
					StartTreatment(_source, zone, price, accountType)
				else
					xPlayer.showNotification("~r~Nie posiadasz ~g~"..price.."$~r~ aby zapłacić za ~g~pomoc medyczną")
				end
			elseif accountType == "bank" then
				if xPlayer.getAccount('bank').money >= price then
					StartTreatment(_source, zone, price, accountType)
				else
					xPlayer.showNotification("~r~Nie posiadasz ~g~"..price.."$~r~ aby zapłacić za ~g~pomoc medyczną")
				end
			end
		end)
	end
end)