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
		TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

CreateThread(function()
	for i=1, #Config.LokalizacjaNapraw, 1 do
		NaprawaPojazdu = Config.LokalizacjaNapraw[i]

		local blip = AddBlipForCoord(NaprawaPojazdu)
		SetBlipSprite(blip, 72)
		SetBlipScale(blip, 0.9)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString(_U('blip_repair'))
		EndTextCommandSetBlipName(blip)
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local canSleep = true

		if CanRepairVehicle() then

			for i=1, #Config.LokalizacjaNapraw, 1 do
				local NaprawaPojazdu = Config.LokalizacjaNapraw[i]
				local distance = GetDistanceBetweenCoords(coords, NaprawaPojazdu, true)

				if distance < 50 then
					ESX.DrawBigMarker(vec3(Config.LokalizacjaNapraw[i]))
					canSleep = false
				end

				if distance < 5 then
					canSleep = false

					if Config.EnablePrice then
						ESX.ShowHelpNotification(_U('prompt_repair_paid', ESX.Math.GroupDigits(Config.Price)))
					else
						ESX.ShowHelpNotification(_U('prompt_repair'))
					end

					if IsControlJustReleased(0, Keys['E']) then
						local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
						if GetVehicleEngineHealth(vehicle) < 1000 then
							ESX.TriggerServerCallback('esx_repair:checkmoneyforrepair', function(hasEnoughMoney)
								if hasEnoughMoney then
									RepairVehicle()
								else
									ESX.ShowNotification('Nie posiadasz wystarczająco gotówki')
								end
							end)
						elseif GetVehicleEngineHealth(vehicle) == 1000 then
							ESX.ShowNotification(_U('repair_failed_isfine'))
						end
					end
				end
			end

			if canSleep then
				Citizen.Wait(500)
			end

		else
			Citizen.Wait(500)
		end
	end
end)

function CanRepairVehicle()
	local playerPed = PlayerPedId()

	if IsPedSittingInAnyVehicle(playerPed) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)

		if GetPedInVehicleSeat(vehicle, -1) == playerPed then
			return true
		end
	end

	return false
end

function RepairVehicle()
	local vehicle = GetVehiclePedIsIn(PlayerPedId())
	FreezeEntityPosition(vehicle, true)

	ESX.ShowNotification('Trwa naprawa pojazdu, możesz wyjść z pojazdu i czekać na zakończenie naprawy!')
	exports["exile_taskbar"]:taskBar(60000, "Trwa naprawa pojazdu", false, true)
	SetVehicleEngineHealth(vehicle, 1000.0) 
	SetVehiclePetrolTankHealth(vehicle, 1000.0)
	SetVehicleBodyHealth(vehicle, 1000.0)
	SetVehicleDeformationFixed(vehicle)
	SetVehicleFixed(vehicle)
	ESX.ShowNotification('Naprawa zakończona sukcesem!')
	FreezeEntityPosition(vehicle, false)
	Citizen.Wait(5000)
end
