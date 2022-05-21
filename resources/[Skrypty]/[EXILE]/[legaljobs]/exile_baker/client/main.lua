RegisterNetEvent("exile_baker:getrequest")
TriggerServerEvent("exile_baker:request")
AddEventHandler("exile_baker:getrequest", function(a, b, c)
	_G.donttry = a
	_G.exile_baker = b

	local exile_bakerpay = _G.exile_baker
	local donttouchme = _G.donttry

ESX                           = nil
local PlayerData = nil

local npc, jobBlip, veh, breadCount, rollCount, jobReward, CurrentAction, CurrentActionData, isCurrentlyBusy = nil, nil, nil, 0, 0, 0, '', nil, false, nil, nil
local blips = {}

local mustPlayAnim = false

local isCurrentlyWorking = false

CreateThread(function()
	while ESX == nil do
		TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) 
			ESX = obj 
		end)
		
		Citizen.Wait(250)
	end

	Citizen.Wait(5000)
	PlayerData = ESX.GetPlayerData()
	RegisterJobBlip()
end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	deleteBlips()
	RegisterJobBlip()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	deleteBlips()
	RegisterJobBlip()
end)

CreateThread(function()
	while true do
		Citizen.Wait(3)
		if PlayerData ~= nil then
			if PlayerData.job.name == 'baker' and npc ~= nil and jobBlip ~= nil then
				local playerCoord = GetEntityCoords(PlayerPedId())
				local npcCoords = GetEntityCoords(npc)

				if #(playerCoord - npcCoords) < 3.0 then
					DrawText3D(npcCoords.x, npcCoords.y, npcCoords.z, Config.Ped.name)
				
					if isCurrentlyWorking then
						ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~ aby, zakończyć pracę.')
						if IsControlJustPressed(0, 51) then
							if DoesEntityExist(veh) then
								ESX.ShowNotification('~r~Nie możesz zakończyć zmiany, zwróć pojazd!')
								Citizen.Wait(200)
							else
								isCurrentlyWorking = false
								ChangeSuit('citizen_wear')
								RemoveAllBlips()
								Citizen.Wait(200)
							end
						end
					else
						ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~ aby, porozmawiać.')
						if IsControlJustPressed(0, 51) then
							OpenJobMenu()
						end
					end
				end

				if IsControlJustReleased(0, 167) and IsInputDisabled(0) and PlayerData.job.grade >= 6 then
					OpenMobileBakerActionsMenu()
				end
			else
				Citizen.Wait(5000)
			end
		else
			Citizen.Wait(5000)
		end
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(3)
		if PlayerData ~= nil then
			if PlayerData.job.name == 'baker' and npc ~= nil and jobBlip ~= nil and isCurrentlyWorking then
				local playerCoord = GetEntityCoords(PlayerPedId())

				for i=1, #Config.Zones, 1 do
					if #(playerCoord - Config.Zones[i].coord) < Config.Zones[i].scale then
						CurrentAction = Config.Zones[i].action
						Citizen.Wait(25)
					else
						CurrentAction = nil
						CurrentActionData = nil
					end
				end
			else
				Citizen.Wait(5000)
			end		
		else
			Citizen.Wait(5000)
		end
	end
end)

--- Markers
CreateThread(function()
	while true do
		Citizen.Wait(0)
		if PlayerData ~= nil then
			if PlayerData.job.name == 'baker' and npc ~= nil and jobBlip ~= nil and isCurrentlyWorking then
				local playerCoord = GetEntityCoords(PlayerPedId())
				local sleep = true

				for i=1, #Config.Zones, 1 do
					if #(playerCoord - Config.Zones[i].coord) < 25.0 then
						sleep = false
						ESX.DrawMarker(vec3(Config.Zones[i].coord.x,  Config.Zones[i].coord.y,  Config.Zones[i].coord.z))
					end
				end

				if sleep then
					Wait(500)
				end
			else
				Citizen.Wait(5000)
			end
		else
			Citizen.Wait(5000)
		end
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(10)
		if PlayerData ~= nil then
			if PlayerData.job.name == 'baker' and npc ~= nil and jobBlip ~= nil and isCurrentlyWorking then
				if DoesEntityExist(veh) then
					if not IsPedSittingInVehicle(PlayerPedId(), veh) then
						local vehCoord = GetEntityCoords(veh)
						ESX.DrawMarker(vec3(Config.Zones[i].coord.x,  Config.Zones[i].coord.y,  Config.Zones[i].coord.z))
					end
				end
			else
				Citizen.Wait(5000)
			end
		else
			Citizen.Wait(5000)
		end
	end
end)

CreateThread(function()
	while true do
		Citizen.Wait(0)
		if PlayerData ~= nil then
			if PlayerData.job.name == 'baker' and npc ~= nil and jobBlip ~= nil and isCurrentlyWorking then
				if CurrentAction == 'getVehicle' then
					ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~ aby, odebrać lub zaparkować pojazd służbowy.')
					if IsControlJustPressed(0, 51) then
						if veh == nil then
							if ESX.Game.IsSpawnPointClear(Config.CarSpawners[1].coord, 3.0)then
								ESX.Game.SpawnVehicle(Config.CarSpawners[1].model, Config.CarSpawners[1].coord, Config.CarSpawners[1].heading, function(vehicle)
									TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
									SetVehicleNumberPlateText(vehicle, ('BOCHEN'..math.random(10, 99)))
									veh = vehicle
									TriggerServerEvent('exile_baker:insertPlayer', GetVehicleNumberPlateText(veh))
								end)
							else
								ESX.ShowNotification('~o~Jakiś pojazd blokuje wyjazd!')
							end
						elseif IsPedSittingInVehicle(PlayerPedId(), veh) then
							DeleteEntity(veh)
							veh = nil
							ESX.ShowNotification('~o~Pojazd wprowadzony do garażu.')
						else
							ESX.ShowNotification('~o~Pojazd został już wydany.')
						end
					end
				elseif CurrentAction == 'deliverybread' then
					if IsPedSittingInVehicle(PlayerPedId(), veh) then
						ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~ aby, dostarczyć chleb.')
						if IsControlJustPressed(0, 51) then
							if not isCurrentlyBusy then	
								local inventory = ESX.GetPlayerData().inventory
								local result = 0
								for i=1, #inventory, 1 do
									if inventory[i].name == 'breads' then
										result = inventory[i].count
									end
								end
								if result < 1 then
									ESX.ShowNotification('~r~Nie posiadasz chleba do sprzedania.')
									Citizen.Wait(250)	
								else
									isCurrentlyBusy = true

									FreezeEntityPosition(veh, true)

									local ttPickup = Config.TimeToSell							

									for i=1, (Config.TimeToSell*1000/5), 1 do
										Citizen.Wait(0)

										ttPickup = (ttPickup-0.015)
										local percentToDisplay = math.floor(math.floor(ttPickup) / Config.TimeToSell * 100);
										if math.floor(ttPickup) ~= 0 then
											local cord = GetEntityCoords(veh)

											DrawText3D(cord.x, cord.y, cord.z, '~o~['..percentToDisplay..'%]')
										else
									--		jobReward = jobReward+(Config.PriceForBread * result)
											--ESX.ShowNotification('~o~Bochenki chleba sprzedane w liczbie '..result..' sztuk, doliczono do wypłaty '..(Config.PriceForBread * result)..'$')
										--	TriggerServerEvent('exile_baker:removeItemCount', 'breads', result)
											
											FreezeEntityPosition(veh, false)

											isCurrentlyBusy = false
											--ESX.ShowNotification('~o~Otrzymujesz wypłatę '..jobReward..'$!')
											TriggerServerEvent(exile_bakerpay, donttouchme, result)
											jobReward = 0
											break
										end
									end
								end
							end
						end
					end
				elseif CurrentAction == 'mill' then
					if IsPedSittingInVehicle(PlayerPedId(), veh) then
						ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~ aby, odebrać mąke.')
						if IsControlJustPressed(0, 51) then
							if not isCurrentlyBusy then	
								local inventory = ESX.GetPlayerData().inventory
								local result = 0
								for i=1, #inventory, 1 do
									if inventory[i].name == 'flavour' then
										result = inventory[i].count
									end
								end
								if result >= 1000 then
									ESX.ShowNotification('~r~Nie zdołasz przewieść więcej mąki!')
									Citizen.Wait(250)							
								elseif result < 1000 then
									isCurrentlyBusy = true

									FreezeEntityPosition(veh, true)


									local ttPickup = Config.TimeToPickupFlavour							

									for i=1, (Config.TimeToPickupFlavour*1000/5), 1 do
										Citizen.Wait(0)

										ttPickup = (ttPickup-0.015)
										local percentToDisplay = math.floor(math.floor(ttPickup) / Config.TimeToPickupFlavour * 100);
										if math.floor(ttPickup) ~= 0 then
											local cord = GetEntityCoords(veh)

											DrawText3D(cord.x, cord.y, cord.z, '~o~['..percentToDisplay..'%]')
										else
											ESX.TriggerServerCallback('exile_baker:giveItemCount', function(result)
												ESX.ShowNotification('~o~Załadowano do pojazdu '..result..' kg mąki.')																					
											end, 'flavour', 1000)	
											
											FreezeEntityPosition(veh, false)

											isCurrentlyBusy = false	
											break
										end
									end
								end
							end
						end
					end
				elseif CurrentAction == 'mixer' then
					ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~ aby, wyrobić ciasto.')
					if IsControlJustPressed(0, 51) then
						if not isCurrentlyBusy then	
							local inventory = ESX.GetPlayerData().inventory
							local result = 0
							for i=1, #inventory, 1 do
								if inventory[i].name == 'flavour' then
									result = inventory[i].count
								end
							end													
							if result < 10 then
								ESX.ShowNotification('~r~Nie posiadasz więcej mąki!')
								Citizen.Wait(250)							
							else
								isCurrentlyBusy = true

								FreezeEntityPosition(PlayerPedId(), true)

								-- lub mini@repair  fixing_a_ped

								ESX.Streaming.RequestAnimDict('mini@repair', function()
									TaskPlayAnim(PlayerPedId(), 'mini@repair', 'fixing_a_ped', 8.0, -8.0, -1, 1, 0, false, false, false)
								end)

								SetEntityHeading(PlayerPedId(), 293.22)

								local ttPickup = Config.TimeToMixFlavour							

								for i=1, (Config.TimeToMixFlavour*1000/5), 1 do
									Citizen.Wait(0)

									ttPickup = (ttPickup-0.015)
									local percentToDisplay = 100-(math.floor(math.floor(ttPickup) / Config.TimeToMixFlavour * 100))
									if percentToDisplay ~= 100 then
										local cord = GetEntityCoords(PlayerPedId())

										DrawText3D(cord.x, cord.y, cord.z+1.0, '~o~['..percentToDisplay..'%]')
									else
										ESX.TriggerServerCallback('exile_baker:changeToAnother', function(resultA)
											ESX.ShowNotification('~o~Wyrobiłeś '..resultA..' porcji ciasta z '..result..' kg mąki.')																					
										end, 'flavour', 'cake')	
										

										ClearPedTasks(PlayerPedId())
										FreezeEntityPosition(PlayerPedId(), false)

										isCurrentlyBusy = false	
										break
									end
								end
							end
						end
					end
				elseif CurrentAction == 'furnace' then
					ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~ aby, wypiec pieczywo, ~INPUT_VEH_DUCK~ aby, ustawić temperaturę pieca.')
					if IsControlJustPressed(0, 73) then -- X
						if not isCurrentlyBusy then
							FreezeEntityPosition(PlayerPedId(), true)
							-- {lib = "mini@safe_cracking", anim = "idle_base"}

							SetEntityHeading(PlayerPedId(), 112.76)

							ESX.UI.Menu.CloseAll()

							ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'furnace',
							{
								title    = 'Temperatura Pieca - '..Config.Zones[4].temp..'°C',
								align    = 'bottom-right',
								elements = Config.Temperatures
							}, function(data, menu)

								Config.Zones[4].temp = data.current.value 
								ClearPedTasks(PlayerPedId())
								mustPlayAnim = false
								FreezeEntityPosition(PlayerPedId(), false)
								ESX.ShowNotification('~o~Ustawiono temperaturę: '..Config.Zones[4].temp..'°C')
							end, function(data, menu)

								mustPlayAnim = false
								ClearPedTasks(PlayerPedId())
								FreezeEntityPosition(PlayerPedId(), false)
								menu.close()
							end)

							PlayAnim('mini@safe_cracking', 'idle_base')
						end
					end

					if IsControlJustPressed(0, 51) then -- E
						if not isCurrentlyBusy then	
							if Config.Zones[4].temp > 100 then
								local inventory = ESX.GetPlayerData().inventory
								local result = 0
								for i=1, #inventory, 1 do
									if inventory[i].name == 'cake' then
										result = inventory[i].count
									end
								end
								if result > 0 then
									ESX.UI.Menu.CloseAll()

									ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'furnace_t',
									{
										title    = 'Piec',
										align    = 'bottom-right',
										elements = {
											{label = "Chleb - 1 porcje ciasta", value = "bread"},
										}
									}, function(data, menu)
										local preChecked = ''


										if data.current.value == 'bread' then
											if result > 1 and not isCurrentlyBusy then
												preChecked = data.current.value 
												menu.close()
											end
										elseif data.current.value == 'roll' and not isCurrentlyBusy then
											if result > 0 then
												preChecked = data.current.value
												menu.close()
											end
										end

										while preChecked == '' do
											Citizen.Wait(10)
										end

										isCurrentlyBusy = true

										--PROP_HUMAN_BBQ

										FreezeEntityPosition(PlayerPedId(), true)

										TaskStartScenarioInPlace(PlayerPedId(), 'PROP_HUMAN_BBQ', -1, true)

										
										local ttPickup = Config.TimeToCookCake							

										for i=1, (Config.TimeToCookCake*1000/5), 1 do
											Citizen.Wait(0)

											ttPickup = (ttPickup-0.015)
											local percentToDisplay = 100-(math.floor(math.floor(ttPickup) / Config.TimeToCookCake * 100))
											if percentToDisplay ~= 100 then
												local cord = GetEntityCoords(PlayerPedId())

												DrawText3D(cord.x, cord.y, cord.z+1.0, '~o~['..percentToDisplay..'%]')
											else	
												if Config.Zones[4].temp == 225 then
													ESX.ShowNotification('~o~Ustawiona temperatura była idealna, wypiekłeś porządne pieczywo!')
													if preChecked == 'bread' then
														ESX.TriggerServerCallback('exile_baker:changeToAnothers', function(resultA)
															ESX.ShowNotification('~o~Wypiekłeś '..resultA..' bochenków chleba z '..result..' porcji ciasta.')																					
														end, 'cake', 'breads', 1)
													else
														ESX.TriggerServerCallback('exile_baker:changeToAnothers', function(resultA)
															ESX.ShowNotification('~o~Wypiekłeś '..resultA..' bułek z '..result..' porcji ciasta.')																					
														end, 'cake', 'roll', 2)
													end
												elseif Config.Zones[4].temp <= 220 then
													ESX.ShowNotification('~o~Ustawiona temperatura była zbyt niska aby, upiec pieczywo.')
												elseif Config.Zones[4].temp > 225 then
													ESX.ShowNotification('~o~Ustawiona temperatura była zbyt wysoka, spaliłes pieczywo!')
													if preChecked == 'bread' then
														TriggerServerEvent('exile_baker:removeItemCount', 'cake', 1)
													else
														TriggerServerEvent('exile_baker:removeItemCount', 'cake', 2)
													end
												end

												ClearPedTasks(PlayerPedId())
												FreezeEntityPosition(PlayerPedId(), false)

												isCurrentlyBusy = false	
												break
											end
										end
									end, function(data, menu)
										menu.close()
									end)
								else
									ESX.ShowNotification('~o~Nie posiadasz ciasta by wypiec pieczywo!')
								end					
							else
								ESX.ShowNotification('~o~Piec ma zbyt małą temperature by wypiec pieczywo.')
							end
						end
					end
				end
			else
				Citizen.Wait(5000)
			end
		else
			Citizen.Wait(5000)
		end
	end
end)
--'mini@safe_cracking', 'idle_base'
function PlayAnim(lib, anim)
	mustPlayAnim = true

	while mustPlayAnim do
		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
		end)

		Citizen.Wait(10)
	end
end

function RegisterJobBlip()
	if PlayerData.job.name == 'baker' then
		if npc == nil then
			TriggerEvent('baker:createped')
		end
		jobBlip = 1
	end
end

function PrepareBlips()
	ESX.ShowNotification('~o~Rozpoczynasz pracę, udaj się do garażu po swój pojazd i ruszaj po mąke!')

	for i=1, #Config.Zones, 1 do
		local blip = AddBlipForCoord(Config.Zones[i].coord)

		SetBlipSprite (blip, Config.Zones[i].sprite)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, Config.Zones[i].bscale)
		SetBlipColour (blip, Config.JobBlip.colour)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.Zones[i].name)
		EndTextCommandSetBlipName(blip)

		table.insert(blips, blip)
	end
end

function RemoveAllBlips()
	--if jobReward > 0 and not (jobReward < 0) then
		--ESX.ShowNotification('~o~Kończysz zmianę i otrzymujesz wypłatę '..jobReward..'$!')
		--TriggerServerEvent(exile_bakerpay, jobReward, donttouchme)
		--jobReward = 0
	--else
		ESX.ShowNotification('~o~Kończysz zmianę.')
	--end

	for i=1, #blips, 1 do
		RemoveBlip(blips[i])
	end
end

function deleteBlips()
	if blips[1] ~= nil then
		for i=1, #blips, 1 do
			RemoveBlip(blips[i])
			blips[i] = nil
		end
	end
end


AddEventHandler('baker:createped', function()
	local model = GetHashKey(Config.Ped.model)
	
	CreateThread(function()
		RequestModel(model)

		while not HasModelLoaded(model) do
			Citizen.Wait(1)
		end

		npc =  CreatePed(5, model, Config.Ped.coord.x, Config.Ped.coord.y, Config.Ped.coord.z, 0.0, false, true)
		SetEntityHeading(npc, 338.0)
		FreezeEntityPosition(npc, true)
		SetEntityInvincible(npc, true)
		SetBlockingOfNonTemporaryEvents(npc, true)
		TaskPlayAnim(npc, "mini@strip_club@idles@bouncer@base", "base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
	end)
end)

function DrawText3D(x, y, z, text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

	SetTextScale(0.4, 0.4)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(1)
	SetTextColour(255, 255, 255, 255)
	SetTextOutline()

	AddTextComponentString(text)
	DrawText(_x, _y)

	local factor = (string.len(text)) / 270
	DrawRect(_x, _y + 0.015, 0.005 + factor, 0.03, 31, 31, 31, 155)
end

function OpenJobMenu()
	local elements = {
		{label = "Rozpocznij prace", value = '1'},
    }
    if PlayerData.job.grade >= 6 then
		table.insert(elements, {label = "Akcje szefa", value = '2'})
		--table.insert(elements, {label = "Lista kursów", value = '3'})
		table.insert(elements, {label = "Zarządzanie frakcją", value = '4'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'piekarz', {
		title    = PlayerData.job.label,
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)

		if data.current.value == '1' then
			ChangeSuit('job_wear')
			isCurrentlyWorking = true
			breadCount = 0
			rollCount = 0
			jobReward = 0
			PrepareBlips()
			menu.close()
			Citizen.Wait(200)
		elseif data.current.value == '2' then
			if PlayerData.job.grade == 6 then
				TriggerEvent('esx_society:openBossMenu', 'baker', function(data, menu)
					menu.close()
				end, { showmoney = false, withdraw = false, deposit = true, wash = false, employees = true})
			elseif PlayerData.job.grade >= 7 then
				TriggerEvent('esx_society:openBossMenu', 'baker', function(data, menu)
					menu.close()
				end, { showmoney = true, withdraw = true, deposit = true, wash = false, employees = true})
			end
		elseif data.current.value == '3' then
			menu.close()
			ESX.TriggerServerCallback('ExileRP:getCourses', function(kursy)
				if kursy then
					local elements = {
						head = {'Imię i nazwisko', 'Liczba kursów', 'Stopień'},
						rows = {}
					}
					for i=1, #kursy, 1 do
						if kursy[i].job_grade == 0 then
							grade = 'Rekrut'
						elseif kursy[i].job_grade == 1 then
							grade = 'Nowicjusz'
						elseif kursy[i].job_grade == 2 then
							grade = 'Pracownik'
						elseif kursy[i].job_grade == 3 then
							grade = 'Fachowiec'
						elseif kursy[i].job_grade == 4 then
							grade = 'Zawodowiec'
						elseif kursy[i].job_grade == 5 then
							grade = 'Specjalista'
						elseif kursy[i].job_grade == 6 then
							grade = 'Manager'
						elseif kursy[i].job_grade == 7 then
							grade = 'Zastępca szefa'
						elseif kursy[i].job_grade == 8 then
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
						ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'baker', elements, function(data, menu)
						end, function(data, menu)
							menu.close()
						end)
                    end
                else
                    ESX.ShowNotification("~r~Lista kursów jest pusta!")
				end
			end, 'baker')
		elseif data.current.value == '4' then
			menu.close()
			exports['exile_legaljobs']:OpenLicensesMenu(PlayerData.job.name)
		end

	end, function(data, menu)
		menu.close()
	end)
end

function ChangeSuit(type)
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		if type == 'citizen_wear' then
			TriggerEvent('skinchanger:loadSkin', skin)
		elseif type == 'job_wear' then
			if skin.sex == 0 then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Clothes.Male)
			else
				TriggerEvent('skinchanger:loadClothes', skin, Config.Clothes.Female)
			end
		end
	end)
end

OpenMobileBakerActionsMenu = function()
	while PlayerData == nil do
		Wait(200)
	end
	ESX.UI.Menu.CloseAll()
	local elements = {}
	local playerPed = PlayerPedId()
	local vehicle   = GetVehiclePedIsIn(playerPed, false)
	if IsVehicleModel(vehicle, `autopiekarz`) then
		if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
			ESX.TriggerServerCallback('exile_baker:checkSiedzacy', function(siedzi)
				if siedzi then
					local plate =  GetVehicleNumberPlateText(vehicle)
					for i=1, #siedzi, 1 do
						if siedzi[i].plate == plate then
							table.insert(elements, {label = siedzi[i].label, value = siedzi[i].plate})	
						end
					end
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lastdriver_'..PlayerData.job.name, {
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
end
end)
