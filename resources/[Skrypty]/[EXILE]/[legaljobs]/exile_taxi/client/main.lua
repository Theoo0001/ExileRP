ESX                           = nil

local CurrentZone = nil
local PlayerData = nil
local IsPlayerOnDuty = false
local JobVehicle = nil
local JobOrder = nil
local hasAlreadyJoined        = false
local loaded = false
local PlayerCoords = vector3(0.0, 0.0, 0.0)
local blip_ped = nil
local LastCancel = GetGameTimer() - 5 * 60000

CreateThread(function()
	while ESX == nil do
		TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) 
			ESX = obj 
		end)
		
		Citizen.Wait(250)
	end
	
	Citizen.Wait(5000)
	
	PlayerData = ESX.GetPlayerData()
	loaded = true
	
	while true do
		PlayerCoords = GetEntityCoords(PlayerPedId())
		Citizen.Wait(1000)
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

CreateThread(function()
	while true do
		if (PlayerCoords ~= nil and PlayerData ~= nil and PlayerData.job ~= nil and (Config.Zones[PlayerData.job.name] or Config.Zones[string.sub(PlayerData.job.name, 4)])) then
			CurrentZone = nil
			local configTable
			if Config.Zones[PlayerData.job.name] ~= nil then
				configTable = Config.Zones[PlayerData.job.name]
			else
				configTable = Config.Zones[string.sub(PlayerData.job.name, 4)]
			end
			for zone,zoneData in pairs(configTable) do
				local canDraw = true
				if (zoneData.settings.dutyOnly == true) then
					if not (IsPlayerOnDuty) then
						canDraw = false
					end
				end

				if (canDraw) then
					local zoneVDist = #(PlayerCoords - zoneData.coords)

					if (zoneVDist < 20.0) then
						if (zoneVDist < 1.0) then
							CurrentZone = zone
						end
						ESX.DrawMarker(vec3(zoneData.coords+zoneData.marker.offset))
					end
				end
			end
		else
			Citizen.Wait(500)
		end
		Citizen.Wait(4)
	end
end)

function setUniform(job, grade)
	grade = tostring(grade)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if Config.Uniforms[job].male[grade] ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male[grade])
			else
				ESX.ShowNotification("Brak ubrania")
			end
		else
			if Config.Uniforms[job].female[grade] ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female[grade])
			else
				ESX.ShowNotification("Brak ubrania")
			end
		end
	end)
end

OpenBossMenu = function()
	local elements = {
		{label = "Akcje szefa", value = '1'},
	}
	if PlayerData.job.grade >= 9 then
		--table.insert(elements, {label = "Lista kursów", value = '2'})
		table.insert(elements, {label = "Zarządzanie frakcją", value = '3'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'taxi_actionss', {
		title    = "Taxi",
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)

		if data.current.value == '1' then
			if PlayerData.job.grade >= 9 then
				TriggerEvent('esx_society:openBossMenu', 'taxi', function(data, menu)
					menu.close()
				end, { showmoney = true, withdraw = true, deposit = true, wash = false, employees = true})
			elseif PlayerData.job.grade >= 8 then
				TriggerEvent('esx_society:openBossMenu', 'taxi', function(data, menu)
					menu.close()
				end, { showmoney = false, withdraw = false, deposit = true, wash = false, employees = true})
			else
				TriggerEvent('esx_society:openBossMenu', 'taxi', function(data, menu)
					menu.close()
				end, { showmoney = false, withdraw = false, deposit = true, wash = false, employees = false})
			end
		elseif data.current.value == '2' then
			menu.close()
			ESX.TriggerServerCallback('ExileRP:getCourses', function(kursy)
				if kursy then
					local elements = {
						head = {'Imię i nazwisko', 'Liczba kursów', 'Stopień'},
						rows = {}
					}
					for i=1, #kursy, 1 do
						if kursy[i].job_grade == 0 then
							grade = 'Okres próbny'
						elseif kursy[i].job_grade == 1 then
							grade = 'Rekrut'
						elseif kursy[i].job_grade == 2 then
							grade = 'Nowicjusz'
						elseif kursy[i].job_grade == 3 then
							grade = 'Kierowca'
						elseif kursy[i].job_grade == 4 then
							grade = 'Stażysta'
						elseif kursy[i].job_grade == 5 then
							grade = 'Specjalista'
						elseif kursy[i].job_grade == 6 then
							grade = 'Zawodowiec'
						elseif kursy[i].job_grade == 7 then
							grade = 'Obsługa'
						elseif kursy[i].job_grade == 8 then
							grade = 'Manager'
						elseif kursy[i].job_grade == 9 then
							grade = 'Właściciel'
						end
						local name = kursy[i].firstname .. ' ' ..kursy[i].lastname
						table.insert(elements.rows, {
							data = kursy[i],
							cols = {
								name, 
								kursy[i].courses_count, 
								grade
							}
						})
						ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'taxi', elements, function(data, menu)
						end, function(data, menu)
							menu.close()
						end)
					end
				else
                    ESX.ShowNotification("~r~Lista kursów jest pusta!")
				end
			end, 'taxi')
		elseif data.current.value == '3' then
			menu.close()
			exports['exile_legaljobs']:OpenLicensesMenu(PlayerData.job.name)
		end

	end, function(data, menu)
		menu.close()
		CurrentZone = "BossMenu"
	end)
end

-- GivebackInvoices = function()
-- 	TriggerServerEvent(GetCurrentResourceName() .. ':sellInvoices')
-- end

CreateThread(function()
	while true do
		if (PlayerData ~= nil and PlayerData.job ~= nil and (Config.Zones[PlayerData.job.name] or Config.Zones[string.sub(PlayerData.job.name, 4)])) then
			local CurrentZone_Data
			if Config.Zones[PlayerData.job.name] ~= nil then
				CurrentZone_Data = Config.Zones[PlayerData.job.name][CurrentZone]
			else
				CurrentZone_Data = Config.Zones[string.sub(PlayerData.job.name, 4)][CurrentZone]
			end
			
			if (CurrentZone == "JobManager") then
				if not (IsPlayerOnDuty) then
					DrawNotification(CurrentZone_Data.settings.prompt:format("rozpocząć pracę."))
				else
					DrawNotification(CurrentZone_Data.settings.prompt:format("zakończyć pracę."))
				end

				if IsControlJustReleased(0, CurrentZone_Data.settings.control) then
					if not (DoesEntityExist(JobVehicle)) then
						IsPlayerOnDuty = not IsPlayerOnDuty
						if (IsPlayerOnDuty) then
							setUniform(PlayerData.job.name, PlayerData.job.grade)
							Citizen.Wait(50)
							ESX.ShowNotification("~y~Rozpocząłeś pracę!")
						else
							CancelOrder()
							ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
								TriggerEvent('skinchanger:loadSkin', skin)
								ESX.ShowNotification("~y~Zakończyłeś pracę!")
							end)
						end
					else
						ESX.ShowNotification("~y~Musisz zwrócić pojazd, aby, zakończyć zmianę!")
					end
					Citizen.Wait(500)
				end
			elseif (CurrentZone == "Garage") then
				if not (IsPedSittingInVehicle(PlayerPedId(), JobVehicle)) then
					DrawNotification(CurrentZone_Data.settings.prompt:format("wziąć pojazd służbowy."))
				end

				if IsControlJustReleased(0, CurrentZone_Data.settings.control) then
					if (IsPlayerOnDuty) then
						if not (IsPedSittingInVehicle(PlayerPedId(), JobVehicle)) then
							if not DoesEntityExist(JobVehicle) then
								GetJobVehicle(CurrentZone_Data.vehicles, CurrentZone_Data.coords)
							else
								ESX.ShowNotification('~r~Najpierw schowaj swój aktualny pojazd')
							end
						end
					else
						ESX.ShowNotification("~y~Musisz zacząć pracę aby, korzystać z garażu!")
					end
					Citizen.Wait(500)
				end
			elseif (CurrentZone == "BossMenu") then
				DrawNotification(CurrentZone_Data.settings.prompt:format("otworzyć menu zarządzania"))
				if IsControlJustReleased(0, CurrentZone_Data.settings.control) then
					if (IsPlayerOnDuty) then
						OpenBossMenu()
					end
					Citizen.Wait(1)
				end
			-- elseif (CurrentZone == 'Invoices') then
			-- 	DrawNotification(CurrentZone_Data.settings.prompt:format("oddać faktury"))
			-- 	if IsControlJustReleased(0, CurrentZone_Data.settings.control) then
			-- 		if (IsPlayerOnDuty) then
			-- 			GivebackInvoices()
			-- 		end
			-- 		Citizen.Wait(1)
			-- 	end
			elseif (CurrentZone == 'DeleteVeh') then
				DrawNotification(CurrentZone_Data.settings.prompt:format("schować pojazd służbowy."))
				if IsControlJustReleased(0, CurrentZone_Data.settings.control) then
					if (IsPlayerOnDuty) then
						if (IsPedSittingInVehicle(PlayerPedId(), JobVehicle)) then
							StoreJobVehicle()
						else
							ESX.ShowNotification("~r~Musisz siedzieć w pojeździe lub to nie jest Twój pojazd służbowy")
						end
					end
				end
			end

			if IsControlJustReleased(0, 167) and IsInputDisabled(0) and not IsDead and PlayerData.job and PlayerData.job.name == 'taxi' then
				if (IsPlayerOnDuty) then
					OpenMobileTaxiActionsMenu()
				end
			end

		else
			Citizen.Wait(100)
		end
		Citizen.Wait(7)
	end
end)

OpenMobileTaxiActionsMenu = function()
	while PlayerData == nil do
		Wait(200)
	end
	ESX.UI.Menu.CloseAll()
	local elements = {
		{label = "Rozpocznij/Zakończ pracę", value = 'start_job'}
	}
	if PlayerData.job.grade >= 8 then -- do zmiany na 9
		table.insert(elements, {label = "Sprawdź ostatniego kierowce", value = 'checkcar'})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_taxi_actions', {
		title    = "Taxi",
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'start_job' then
			if JobOrder ~= nil then
				CancelOrder()
			else
				if PlayerData.job ~= nil and PlayerData.job.name == 'taxi' then
					local playerPed = PlayerPedId()
					local vehicle   = GetVehiclePedIsIn(playerPed, false)
					if PlayerData.job.grade >= 9 then
						MakeOrder()
						TriggerServerEvent('taxi:insertSmiec', GetVehicleNumberPlateText(vehicle))
					else
						if (IsPedSittingInVehicle(PlayerPedId(), JobVehicle)) then
							MakeOrder()
							TriggerServerEvent('taxi:insertSmiec', GetVehicleNumberPlateText(vehicle))
						else
							ESX.ShowNotification("~y~Musisz być w pojeździe służbowym, aby rozpocząć przewóz osób")
						end
					end
				end
			end
		elseif data.current.value == 'checkcar' then
			local playerPed = PlayerPedId()
			local vehicle   = GetVehiclePedIsIn(playerPed, false)
			if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
				ESX.TriggerServerCallback('taxi:checkSiedzacy', function(siedzi)
					if siedzi then
						local elements = {}
						local plate =  GetVehicleNumberPlateText(vehicle)
						for i=1, #siedzi, 1 do
							if siedzi[i].plate == plate then
								table.insert(elements, {label = siedzi[i].label, value = siedzi[i].plate})
							end
						end
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lastdriver', {
							title    = "Lista kierowców ["..plate..']',
							align    = 'bottom-right',
							elements = elements
						}, function(data, menu)
						end, function(data, menu)
							menu.close()
						end)

					end
				end)
			else
				ESX.ShowNotification("~r~Musisz znajdować się w pojeździe jako kierwoca!")
			end

		end
	end, function(data, menu)
		menu.close()
	end)
end

MakeOrder = function()
	if (PlayerData ~= nil and PlayerData.job ~= nil and Config.Zones[PlayerData.job.name]) then
		if (DoesEntityExist(JobVehicle) and IsPlayerOnDuty and IsPedSittingInVehicle(PlayerPedId(), JobVehicle)) then
			if (JobOrder == nil) then
				CreateNewTaxiOrder()
			end
		end
	end
end

CreateThread(function()
	while true do
		if PlayerData ~= nil and Config.Zones[PlayerData.job.name] then
			if (DoesEntityExist(JobVehicle) and IsPlayerOnDuty and IsPedSittingInVehicle(PlayerPedId(), JobVehicle))  then
				if JobOrder ~= nil then
					if JobOrder.status == 0 and JobOrder.ped == nil and #(PlayerCoords - JobOrder.start_point) < 40.0 then
						SpawnOrderPed()
						Citizen.Wait(1000)
					end
				end
			else
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(500)
		end
		Citizen.Wait(100)
	end
end)

CreateThread(function()
	while true do
		if (PlayerData ~= nil and PlayerData.job ~= nil and Config.Zones[PlayerData.job.name]) then
			if (DoesEntityExist(JobVehicle) and IsPlayerOnDuty and IsPedSittingInVehicle(PlayerPedId(), JobVehicle)) then
				if (JobOrder ~= nil and DoesEntityExist(JobOrder.ped)) then
					if JobOrder.status == 0 and #(PlayerCoords - GetEntityCoords(JobOrder.ped)) < 5.0 then
						if IsControlJustReleased(0, 86) then
							HornOnClient(GetVehiclePedIsIn(PlayerPedId()))
						end
					end

					if JobOrder.status == 1 and #(PlayerCoords - JobOrder.end_point) < 10.0 then
						PlayAmbientSpeech1(JobOrder.ped, "TAXID_CLOSE_AS_POSS", "SPEECH_PARAMS_FORCE_NORMAL")
						GetTheFuckOutBitch()
					end
				else
					Citizen.Wait(500)
				end
			else
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(500)
		end
		Citizen.Wait(7)
	end
end)

SpawnOrderPed = function()
	local pedModel = GetHashKey(Config.PedsList[math.random(1, #Config.PedsList)])

	RequestModel(pedModel)
	while not HasModelLoaded(pedModel) do
		Citizen.Wait(10)
	end

	JobOrder.ped = Citizen.InvokeNative(0xD49F9B0955C367DE, 5, pedModel, JobOrder.start_point.x, JobOrder.start_point.y, JobOrder.start_point.z-0.5, 0.0, true, true)
	FreezeEntityPosition(JobOrder.ped, true)
	SetBlockingOfNonTemporaryEvents(JobOrder.ped, true)
	SetEntityAsMissionEntity(JobOrder.ped, 1, 1)
	SetModelAsNoLongerNeeded(pedModel)
	TaskStartScenarioInPlace(JobOrder.ped, "WORLD_HUMAN_STAND_MOBILE", 0, false)
	CanPedSpeak(JobOrder.ped, "TAXID_CLOSE_AS_POSS")
end

CancelOrder = function()
	if (JobOrder ~= nil) then
		if GetGameTimer() - LastCancel > 5 * 60000 then
			TriggerServerEvent('exile_taxi:unregisterNPCTrack')
			FreezeEntityPosition(JobVehicle, false)
			SetEntityAsNoLongerNeeded(JobOrder.ped)
			DeleteEntity(JobOrder.ped)
			if DoesBlipExist(blip_ped) then
				RemoveBlip(blip_ped)
			end
			if DoesBlipExist(JobOrder.blip) then
				RemoveBlip(JobOrder.blip)
			end
			JobOrder = nil
			LastCancel = GetGameTimer()
		else
			ESX.ShowNotification("Odczekaj ~y~5 minut~w~ przed następną ~r~anulacją trasy")
		end
	end
end

GetTheFuckOutBitch = function()
	BringVehicleToHalt(JobVehicle, 5.0, 3, 0)
	while (GetEntitySpeed(JobVehicle) < 0.2) do
		Citizen.Wait(500)
	end
	TriggerServerEvent('exile_taxi:setTrackAsDone')
	TaskLeaveVehicle(JobOrder.ped, JobVehicle, 0)
	Citizen.Wait(1000)
	TaskWanderStandard(JobOrder.ped, 1000.0, 1000.0)
	SetEntityAsNoLongerNeeded(JobOrder.ped)
	FreezeEntityPosition(JobVehicle, false)
	RemoveBlip(blip_ped)
	RemoveBlip(JobOrder.blip)
	JobOrder = nil	
end

HornOnClient = function(vehicle)
	if PlayerData.job.grade >= 9 then
		JobVehicle = vehicle
	end
	JobOrder.status = 1

	FreezeEntityPosition(JobOrder.ped, false)
	FreezeEntityPosition(JobVehicle, true)
	TaskEnterVehicle(JobOrder.ped, JobVehicle, 10000, 2, 1.0, 1, 0)

	while not (IsPedSittingInVehicle(JobOrder.ped, JobVehicle)) do
		Citizen.Wait(500)
	end
	PlayAmbientSpeech1(PlayerPedId(), "TAXID_WHERE_TO", "SPEECH_PARAMS_FORCE_NORMAL")
	FreezeEntityPosition(JobVehicle, false)

	RemoveBlip(blip_ped)

	JobOrder.blip = AddBlipForCoord(JobOrder.end_point)
	SetBlipSprite(JobOrder.blip, 164)
	SetBlipColour(JobOrder.blip, 60)
	SetBlipAsShortRange(JobOrder.blip, false)

	SetBlipRoute(JobOrder.blip, true)
	SetBlipRouteColour(JobOrder.blip, 60)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName("~y~Miejsce docelowe")
	EndTextCommandSetBlipName(JobOrder.blip)
end

CreateNewTaxiOrder = function()
	JobOrder = { status = 0 }
	math.randomseed(math.random(1000, 9999999999))
	JobOrder.start_point = Config.CoordsList[math.random(1, #Config.CoordsList)]

	math.randomseed(math.random(1000, 9999999999))
	JobOrder.end_point = Config.CoordsList[math.random(1, #Config.CoordsList)]
	while #(PlayerCoords - JobOrder.end_point) < 1500.0 do
		math.randomseed(math.random(1000, 9999999999))
		JobOrder.end_point = Config.CoordsList[math.random(1, #Config.CoordsList)]
		Citizen.Wait(100)
	end

	blip_ped = AddBlipForCoord(vec3(JobOrder.start_point.x, JobOrder.start_point.y, JobOrder.start_point.z))
	SetBlipSprite(blip_ped, 280)
	SetBlipColour(blip_ped, 60)
	SetBlipFlashes(blip_ped, true)
	SetBlipFlashInterval(blip_ped, 1000)
	SetBlipDisplay(blip_ped, 4)
	SetBlipAsShortRange(blip_ped, false)

	SetBlipRoute(blip_ped, true)
	SetBlipRouteColour(blip_ped, 60)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName("~y~Klient")
	EndTextCommandSetBlipName(blip_ped)

	local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(JobOrder.start_point.x, JobOrder.start_point.y, JobOrder.start_point.z))
	ESX.ShowNotification("Witam, czy można podjechać na ulicę, "..street.." ?")
	local playerLenght = #(PlayerCoords - JobOrder.start_point) * 1.25
	local truckLenght = #(JobOrder.start_point - JobOrder.end_point) * 1.25
	local wholeLenght = playerLenght + truckLenght
	TriggerServerEvent('exile_taxi:registerNewNPCTrack', wholeLenght)
end

SetDodatki = function(vehicle)
	local dodatki = {
		modBrakes       = 2,
		modArmor        = 4,
		color1          = 88, --zolty
		color2          = 88, --zolty
		modTurbo        = false,
		modXenon        = true,
		wheels          = 0,
		plateIndex      = 1,
		modXenonColor   = 6,
		windowTint      = 3,
		dirtLevel       = 0,
		modFrontWheels  = 19,
		modBackWheels = 19,
		wheelColor    = 1,
		extras          = {1,1,1,1}
	}
	local carmodel = GetEntityModel(vehicle)


	--[[if carmodel == -662904049 then --e63amg
		dodatki.color1 = 120
		dodatki.wheels = 4
		dodatki.wheelColor = 88
	end]]
		

	ESX.Game.SetVehicleProperties(vehicle, dodatki)
	--SetVehicleExtra(vehicle, extrasoff, false)
end

GetJobVehicle = function(vehicle, coords)
	ESX.UI.Menu.CloseAll()
	local grade = 0
	if PlayerData.job and PlayerData.job.name == 'taxi' then
		grade = PlayerData.job.grade
	end
	local elements = {}

	for _, vehicle in ipairs(Config.Vehicles) do
		if grade >= vehicle.grade then
			table.insert(elements, {label = vehicle.name, value = vehicle.spawn})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
		title    = "Garaż",
		align    = 'bottom-right',
		elements = elements

	}, function(data, menu)

		if not ESX.Game.IsSpawnPointClear(vehicle.coords, 5.0) then
			ESX.ShowNotification("~r~Wyjazd jest zablokowany przez inny pojazd!")
			return
		end

		menu.close()
		ESX.Game.SpawnVehicle(data.current.value, vehicle.coords, vehicle.heading, function(veh)
			JobVehicle = veh
			local tablicetaxi = ('TAXI '..math.random(100, 999))
			local playerPed = PlayerPedId()
			SetDodatki(veh)
			SetVehicleNumberPlateText(veh, tablicetaxi)
			local localVehPlate = string.lower(GetVehicleNumberPlateText(veh))
			TriggerEvent('ls:dodajklucze2', localVehPlate)
			TaskWarpPedIntoVehicle(playerPed, veh, -1)
		end)
	end, function(data, menu)
		CurrentZone = 'Garage'
		menu.close()
	end)
end

StoreJobVehicle = function()
	ESX.Game.DeleteVehicle(JobVehicle)
	JobVehicle = nil
end

DrawNotification = function(string)
	SetTextComponentFormat('STRING')
	AddTextComponentString(string)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

-- RegisterNetEvent('exile_taxi:invoicesSold')
-- AddEventHandler('exile_taxi:invoicesSold', function()
-- 	TriggerServerEvent('flux:addLevelPoint')
-- end)

