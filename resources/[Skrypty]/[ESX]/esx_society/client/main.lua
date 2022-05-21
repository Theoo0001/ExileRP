ESX = nil
local PlayerData = {}
local level = 0
local workers = 0

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

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx:setHiddenJob')
AddEventHandler('esx:setHiddenJob', function(hiddenjob)
	PlayerData.hiddenjob = hiddenjob
end)

function OpenBossMenu(society, close, options, extras)	
	ESX.TriggerServerCallback('exile_legaljobs:getLicenses', function(licenses)
		level = licenses.level
	end, society)
	ESX.TriggerServerCallback('society:countMembers', function(all)
		workers = all
	end, society)
	local options = options or {}
	
	if options.withdraw ~= nil and options.showmoney == nil then
		options.withdraw = options.withdraw
	end
	
	for k,v in pairs({
		showmoney = true,
		withdraw = true,
		deposit = true,
		employees = true,
		dirty = false,
		wash = false,
		badges = false,
		licenses  = false,
		grades = false	
	}) do
		if options[k] == nil then
			options[k] = v
		end
	end
	
	local elements = {}
	ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
		if options.showmoney then
			table.insert(elements, {label = 'Stan konta frakcji: <span style="color:limegreen;">'..money..'$', value = 'none'})
		end

		if options.withdraw then
			table.insert(elements, {label = _U('withdraw_society_money'), value = 'withdraw_society_money'})
		end

		if options.deposit then
			table.insert(elements, {label = _U('deposit_society_money'), value = 'deposit_money'})
		end

		if options.wash then
			table.insert(elements, {label = _U('wash_money'), value = 'wash_money'})
		end

		if options.employees then
			table.insert(elements, {label = _U('employee_management'), value = 'manage_employees'})
		end

		if options.grades then
			table.insert(elements, {label = _U('salary_management'), value = 'manage_grades'})
		end

		if (society == 'police' and (PlayerData.hiddenjob.name == 'sheriff' and PlayerData.hiddenjob.grade >= 11) or (PlayerData.job.name == 'police' and PlayerData.job.grade >= 11)) then
			table.insert(elements, {label = 'Sheriff Office', value = 'manage_sheriff'})
		end

		if (society == 'police' and (PlayerData.hiddenjob.name == 'dtu' and PlayerData.hiddenjob.grade >= 4) or (PlayerData.job.name == 'police' and PlayerData.job.grade >= 11)) then
			table.insert(elements, {label = 'Detective Tactical Unit', value = 'manage_dtu'})
		end

		--[[if (society == 'police' and (PlayerData.hiddenjob.name == 'hwp' and PlayerData.hiddenjob.grade >= 6) or (PlayerData.job.name == 'police' and PlayerData.job.grade >= 11)) then
			table.insert(elements, {label = 'Highway Patrol', value = 'manage_hwp'})
		end]]

		if (society == 'mechanik' and (PlayerData.job.name == 'mechanik' and PlayerData.job.grade >= 7)) then
			table.insert(elements, {label = 'Lista pracowników na służbie', value = 'duty_list'})
		end

		if (society == 'mechanik2' and (PlayerData.job.name == 'mechanik2' and PlayerData.job.grade >= 7)) then
			table.insert(elements, {label = 'Lista pracowników na służbie', value = 'duty_list2'})
		end	

		if (society == 'police' and (PlayerData.job.name == 'police' and PlayerData.job.grade >= 9)) then
			table.insert(elements, {label = 'Lista pracowników na służbie', value = 'duty_list3'})
		end	

		if extras and extras.main then
			for _, extra in ipairs(extras.main) do
				table.insert(elements, {label = extra.name, value = 'extra', event = extra.event, eventValue = extra.value})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_actions_' .. society,
		{
			title    = _U('boss_menu'),
			align    = 'left',
			elements = elements
		}, function(data, menu)

			if data.current.value == 'extra' then
				TriggerEvent(data.current.event, menu, data.current.eventValue) 
			elseif data.current.value == 'withdraw_society_money' then

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_money_amount_' .. society, {
					title = _U('withdraw_amount')
				}, function(data, menu)

					local amount = tonumber(data.value)

					if amount == nil then
						ESX.ShowNotification(_U('invalid_amount'))
					else
						menu.close()
						TriggerServerEvent('spoleczenstwo:wyplacajSzmato', society, amount)
					end

				end, function(data, menu)
					menu.close()
				end)

			elseif data.current.value == 'manage_sheriff' then
				TriggerEvent('esx_society:openHiddenBossMenu', 'sheriff', 100, function(data, menu)
					menu.close()
				end, { showmoney = false, withdraw = false, deposit = false, wash = false, employees = true })
			elseif data.current.value == 'manage_dtu' then
				TriggerEvent('esx_society:openHiddenBossMenu', 'dtu', 100, function(data, menu)
					menu.close()
				end, { showmoney = false, withdraw = false, deposit = false, wash = false, employees = true })
			--[[elseif data.current.value == 'manage_hwp' then
				TriggerEvent('esx_society:openLicenseBossMenu', 'hwp', 100, function(data, menu)
					menu.close()
				end, { showmoney = false, withdraw = false, deposit = false, wash = false, employees = true })]]
			elseif data.current.value == 'duty_list' then
				OpenDutyListMenu('mechanik')
			elseif data.current.value == 'duty_list2' then
				OpenDutyListMenu2('mechanik2')
			elseif data.current.value == 'duty_list3' then
				OpenDutyListMenu3('police')
			elseif data.current.value == 'deposit_money' then

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_money_amount_' .. society,
				{
					title = _U('deposit_amount')
				}, function(data, menu)

					local amount = tonumber(data.value)

					if amount == nil then
						ESX.ShowNotification(_U('invalid_amount'))
					else
						menu.close()
						TriggerServerEvent('spoleczenstwo:kitrajHajs', society, amount)
					end

				end, function(data, menu)
					menu.close()
				end)

			elseif data.current.value == 'wash_money' then

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'wash_money_amount_' .. society,
				{
					title = _U('wash_money_amount')
				}, function(data, menu)

					local amount = tonumber(data.value)

					if amount == nil then
						ESX.ShowNotification(_U('invalid_amount'))
					else
						menu.close()
						TriggerServerEvent('spoleczenstwo:pierzHajsik', society, amount)
					end

				end, function(data, menu)
					menu.close()
				end)
			elseif data.current.value == 'manage_employees' then
				OpenManageEmployeesMenu(society, options.licenses)
			elseif data.current.value == 'manage_grades' then
				OpenManageGradesMenu(society)
			end

		end, function(data, menu)
			if close then
				close(data, menu)
			end
		end)
	end, society)
end

function OpenDutyListMenu(society) 
	ESX.TriggerServerCallback('csskrouble:societyDutyList', function(list)
		ESX.UI.Menu.CloseAll()
		local elements = {}
		local workers = {}
		for i,v in ipairs(list) do
			local ii = #elements
			table.insert(elements, {label = v[1], value = ii+1})
			table.insert(workers, v)
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(),society.."_dutylist",
		{ 
		title = "Pracownicy na służbie", 
		align = "center", 
		elements = elements 
		}, function(data, menu)
			local worker = workers[data.current.value]
			ESX.ShowNotification('Wyrzucono ze służby '..worker[2][3])
			TriggerServerEvent("csskrouble:kickFromDuty", worker[2][1], society, worker[2][2])
			menu.close()
		end, function(data, menu) 
		menu.close() 
		end)
	end, society)
end 

function OpenDutyListMenu2(society) 
	ESX.TriggerServerCallback('csskrouble:societyDutyList', function(list)
		ESX.UI.Menu.CloseAll()
		local elements = {}
		local workers = {}
		for i,v in ipairs(list) do
			local ii = #elements
			table.insert(elements, {label = v[1], value = ii+1})
			table.insert(workers, v)
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(),society.."_dutylist",
		{ 
		title = "Pracownicy na służbie", 
		align = "center", 
		elements = elements 
		}, function(data, menu)
			local worker = workers[data.current.value]
			ESX.ShowNotification('Wyrzucono ze służby '..worker[2][3])
			TriggerServerEvent("csskrouble:kickFromDuty", worker[2][1], society, worker[2][2])
			menu.close()
		end, function(data, menu) 
		menu.close() 
		end)
	end, society)
end 

function OpenDutyListMenu3(society) 
	ESX.TriggerServerCallback('csskrouble:societyDutyList', function(list)
		ESX.UI.Menu.CloseAll()
		local elements = {}
		local workers = {}
		for i,v in ipairs(list) do
			local ii = #elements
			table.insert(elements, {label = v[1], value = ii+1})
			table.insert(workers, v)
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(),society.."_dutylist",
		{ 
		title = "Pracownicy na służbie", 
		align = "center", 
		elements = elements 
		}, function(data, menu)
			local worker = workers[data.current.value]
			ESX.ShowNotification('Wyrzucono ze służby '..worker[2][3])
			TriggerServerEvent("csskrouble:kickFromDuty", worker[2][1], society, worker[2][2])
			menu.close()
		end, function(data, menu) 
		menu.close() 
		end)
	end, society)
end 

function OpenManageEmployeesMenu(society, licenses)
	local limitworkers = exports['exile_legaljobs']:GetLimits(level)
	local elements = {
		{label = "Zrekrutuj",       value = 'recruit'},
		{label = "Zarządzaj pracownikami", value = 'employee_list'},
	}
	
	if limitworkers ~= nil then
		table.insert(elements, {label = "Zeruj wszystkie kursy tymaczasowe", value = 'zeruj_kursy'})
		table.insert(elements, {label = "Zatrudnionych: "..workers.." / "..limitworkers, value = nil})
	end
	
	if licenses then
		table.insert(elements, {label = "Zarządzaj licencjami", value = 'licenses'})
	end

	if society == 'baker' or society == 'burgershot' or society == 'courier' or society == 'farming' or society == 'fisherman' or society == 'grower' or society == 'kawiarnia' or society == 'krawiec' or society == 'milkman' or society == 'miner' or society == 'pizzeria' or society == 'rafiner' or society == 'slaughter' or society == 'taxi' or society == 'weazel' or society == 'winiarz' then
		table.insert(elements, {label = "Zatrudnianie w urzędzie", value = 'job_center'})
	end

	if society == 'police' or society == 'ambulance' or society == 'fire' or society == 'mechanik' or society == 'doj' or society == 'psycholog' or society == 'dtu' or society == 'mechanik2' then
		table.insert(elements, {label = "Przelej premię", value = 'give_money'})
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_employees_' .. society, {
		title    = _U('employee_management'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'employee_list' then
			OpenEmployeeList(society)
		end

		if data.current.value == 'recruit' then
			for i=1, #Config.LegalJobsList, 1 do
				if society == Config.LegalJobsList[i] then
					ESX.TriggerServerCallback('exile_legaljobs:getLicenses', function(licenses)
						level = licenses.level
						OpenRecruitMenu(society, level, true)
					end, society)
					break
				else
					OpenRecruitMenu(society, level, false)
				end
			end
		end
		
		if data.current.value == 'zeruj_kursy' then
			ESX.TriggerServerCallback('esx_society:zeruj_kursy_all', function(cb)
			end, PlayerData.job.name)
		end

		if data.current.value == 'job_center' then
			OpenJobCenterManage()
		end

		if data.current.value == 'licenses' then
			OpenLicensesMenu(society)
		end

		if data.current.value == 'give_money' then
			OpenGiveMoneyMenu(society)
		end

	end, function(data, menu)
		menu.close()
	end)
end

function OpenGiveMoneyMenu(society)
	local players = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 3.0)
	local elements = {}
	local serverIds = {}
	
	for k,v in ipairs(players) do
		if v ~= PlayerId() then
			table.insert(serverIds, GetPlayerServerId(v))
		end
	end
	
	ESX.TriggerServerCallback("esx_society:getMeNames", function(identities)
		for k,v in pairs(identities) do
			table.insert(elements, {
				player = k,
				label = v
			})
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'obywatele_obok',
		{
			title = "Wybierz obywatela",
			align = 'left',
			elements = elements,
		},
		function(data, menu)
			menu.close()
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'give_money', {
				title    = "Ile pieniędzy chcesz przelać?",
				align    = 'center'
			}, function(data2, menu2)
				menu2.close()
				TriggerServerEvent('esx_society:giveMoney', data.current.player, society, data2.value)
				Citizen.Wait(300)
				OpenGiveMoneyMenu(society)
			end, function(data2, menu2)
				menu2.close()
				OpenGiveMoneyMenu(society)
			end)
		end,
		function(data, menu)
			menu.close()
		end)	
	end, serverIds)
end

function OpenGiveLicenseMenu(employee, society)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'give', {
		title    = 'Jaką licencję chcesz nadać?',
		align    = 'bottom-right',
		elements = employee.available
	}, function(data, menu)
		menu.close()
		TriggerServerEvent('esx_society:giveLicense', employee, data.current.value)
		Citizen.Wait(500)
		OpenLicensesMenu(society)
	end, function(data, menu)
		menu.close()
		OpenLicensesMenu(society)
	end)
end

function OpenGetLicenseMenu(employee, society)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'give', {
		title    = 'Jaką licencję chcesz odebrać?',
		align    = 'bottom-right',
		elements = employee.owned
	}, function(data, menu)
		menu.close()
		TriggerServerEvent('esx_society:getLicense', employee, data.current.value)
		Citizen.Wait(500)
		OpenLicensesMenu(society)
	end, function(data, menu)
		menu.close()
		OpenLicensesMenu(society)
		
	end)
end

function OpenLicensesMenu(society)
	ESX.TriggerServerCallback('flux:pokazLicencje', function(employees)
		local elements = {
			head = {"Pracownik", "TD", "HC", "SEU", "SERT", "SWAT", "USMS", "DTU", "HELI", "SWIM", "AIAD", "HP", "Akcje"},
			rows = {}
		}
		
		for i=1, #employees, 1 do
			local td = '❌'
			local hc = '❌'
			local seu = '❌'
			local sert = '❌'
			local swat = '❌'
			local usms = '❌'
			local dtu = '❌'
			local heli = '❌'
			local nurek = '❌'
			local aiad = '❌'
			local hp = '❌'
			local available = {}
			local owned = {}
			for j=1, #employees[i].licenses, 1 do
				local license = employees[i].licenses[j]
				if license.name == 'td' then
					td = '✔️'
					table.insert(owned, {label = "Licencja TD", value = 'td'})
				elseif license.name == 'hc' then
					hc = '✔️'
					table.insert(owned, {label = "Licencja HC", value = 'hc'})
				elseif license.name == 'seu' then
					seu = '✔️'
					table.insert(owned, {label = "Licencja SEU", value = 'seu'})
				elseif license.name == 'sert' then
					sert = '✔️'
					table.insert(owned, {label = "Licencja SERT", value = 'sert'})
				elseif license.name == 'swat' then
					swat = '✔️'
					table.insert(owned, {label = "Licencja SWAT", value = 'swat'})
				elseif license.name == 'usms' then
					usms = '✔️'
					table.insert(owned, {label = "Licencja USMS", value = 'usms'})
				elseif license.name == 'dtu' then
					dtu = '✔️'
					table.insert(owned, {label = "Licencja DTU", value = 'dtu'})
				elseif license.name == 'heli' then
					heli = '✔️'
					table.insert(owned, {label = "Licencja HELI", value = 'heli'})
				elseif license.name == 'nurek' then
					nurek = '✔️'
					table.insert(owned, {label = "Licencja SWIM", value = 'nurek'})
				elseif license.name == 'aiad' then
					aiad = '✔️'
					table.insert(owned, {label = "Licencja AIAD", value = 'aiad'})
				elseif license.name == 'hp' then
					hp = '✔️'
					table.insert(owned, {label = "Licencja HP", value = 'hp'})
				end
			end
			if td == '❌' then
				table.insert(available, {label = "Licencja TD", value = 'td'})
			end
			if hc == '❌' then
				table.insert(available, {label = "Licencja HC", value = 'hc'})
			end
			if seu == '❌' then
				table.insert(available, {label = "Licencja SEU", value = 'seu'})
			end
			if sert == '❌' then
				table.insert(available, {label = "Licencja SERT", value = 'sert'})
			end
			if swat == '❌' then
				table.insert(available, {label = "Licencja SWAT", value = 'swat'})
			end
			if usms == '❌' then
				table.insert(available, {label = "Licencja USMS", value = 'usms'})
			end
			if dtu == '❌' then
				table.insert(available, {label = "Licencja DTU", value = 'dtu'})
			end
			if heli == '❌' then
				table.insert(available, {label = "Licencja HELI", value = 'heli'})
			end
			if nurek == '❌' then
				table.insert(available, {label = "Licencja SWIM", value = 'nurek'})
			end
			if aiad == '❌' then
				table.insert(available, {label = "Licencja AIAD", value = 'aiad'})
			end
			if hp == '❌' then
				table.insert(available, {label = "Licencja HP", value = 'hp'})
			end
			employees[i].owned = owned
			employees[i].available = available
			table.insert(elements.rows, {
				data = employees[i],
				cols = {
					employees[i].name,
					td,
					hc,
					seu,
					sert,
					swat,
					usms,
					dtu,
					heli,
					nurek,
					aiad,
					hp,
					'{{' .. "Nadaj licencję" .. '|give}} {{' .. "Odbierz licencję" .. '|get}}'
				}
			})
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_' .. society, elements, function(data, menu)
			local employee = data.data
			if data.value == 'give' then
				OpenGiveLicenseMenu(employee, society)
			elseif data.value == 'get' then
				OpenGetLicenseMenu(employee, society)
			end			
		end, function(data, menu)
			menu.close()
		end)
	end, society)
end

function OpenEmployeeList(society)
	ESX.TriggerServerCallback('flux:pokazKlapkow', function(employees)	
	
		local elements = nil
		
		if (PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'police' or PlayerData.job.name == 'fire' or PlayerData.job.name == 'mechanik' or PlayerData.job.name == 'doj' or PlayerData.job.name == 'psycholog' or PlayerData.job.name == 'dtu' or PlayerData.job.name == 'mechanik2' ) then
			elements = {
				head = {_U('employee'), _U('grade'), 'Odznaka', 'Godziny', _U('actions')},
				rows = {}
			}
		else
			elements = {
				head = {_U('employee'), _U('grade'), "Globalne kursy", "Tymaczasowe kursy", _U('actions')},
				rows = {}
			}			
		end

		if (PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'police' or PlayerData.job.name == 'fire' or PlayerData.job.name == 'mechanik' or PlayerData.job.name == 'doj' or PlayerData.job.name == 'psycholog' or PlayerData.job.name == 'dtu' or PlayerData.job.name == 'mechanik2' ) then
			for i=1, #employees, 1 do
				local gradeLabel = (employees[i].job.grade_label == '' and employees[i].job.label or employees[i].job.grade_label)

				local numer
				if employees[i].badge.number > 0 and employees[i].badge.number < 10 then
					numer = '0' .. employees[i].badge.number
				else
					numer = employees[i].badge.number
				end

				local gradeBadge = (tostring(numer))
				local czasufka = string.format("%.02f", employees[i].time) 

				if employees[i].badge.number == 0 then
					gradeBadge = 'Brak Odznaki'
				end
				
				table.insert(elements.rows, {
					data = employees[i],
					cols = {
						employees[i].name,
						gradeLabel,
						gradeBadge,
						czasufka.."H",
						'{{Odznaka |odznaka}} {{' .. _U('promote') .. '|promote}} {{' .. _U('fire') .. '|fire}} {{Zeruj Godziny|clearhours}}'
					}
				})
			end
		else
			for i=1, #employees, 1 do
				local gradeLabel = (employees[i].job.grade_label == '' and employees[i].job.label or employees[i].job.grade_label)
				
				table.insert(elements.rows, {
					data = employees[i],
					cols = {
						employees[i].name,
						gradeLabel,
						employees[i].job.courses,
						employees[i].job.courses2,
						'{{' .. _U('promote') .. '|promote}} {{' .. _U('fire') .. '|fire}} {{Zeruj kursy|zeruj_kursy}}'
					}
				})
			end
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_' .. society, elements, function(data, menu)
			local employee = data.data

			if data.value == 'odznaka' then
				menu.close()
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'odznaki', {
					title = 'Numer Odznaki'
				}, function(data2, menu2)
					local amount = tonumber(data2.value)

					if amount == nil or amount < 1 then
						ESX.ShowNotification('Niepoprawny numer!')
					else
						menu2.close()
						TriggerServerEvent('esx_society:setBadge', employee, amount)
						Citizen.Wait(200)
						OpenBossMenu(society)
					end
				end, function(data2, menu2)
					menu2.close()			
				end)				
			elseif data.value == 'promote' then
				menu.close()
				OpenPromoteMenu(society, employee)
			elseif data.value == 'fire' then
				ESX.ShowNotification(_U('you_have_fired', employee.name))

				ESX.TriggerServerCallback('esx_society:setJob', function()
					OpenEmployeeList(society)
				end, employee.identifier, 'unemployed', 0, 'fire')
			elseif data.value == 'zeruj_kursy' then
				ESX.TriggerServerCallback('esx_society:zeruj_kursy', function()
					OpenEmployeeList(society)
				end, employee)
			elseif data.value == 'clearhours' then
				TriggerServerEvent('esx_society:clearhours', employee.identifier)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, society)
end

function OpenRecruitMenu(society, level, custom)
	if custom then
		ESX.TriggerServerCallback('society:countMembers', function(all)
			if all >= exports['exile_legaljobs']:GetLimits(level) then
				if tonumber(level) == 10 then
					ESX.ShowNotification('~r~Twoja firma posiada już maksymalny poziom i maksymalną ilość członków')
				else
					ESX.UI.Menu.CloseAll()
					ESX.ShowNotification('~r~Aby zatrudnić więcej osób musisz podnieść poziom firmy')
				end
			else
				local players = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 3.0)
				if json.encode(players) ~= '[]' then
					local elements = {}
					local serverIds = {}
					
					for k,v in ipairs(players) do
						if v ~= PlayerId() then
							table.insert(serverIds, GetPlayerServerId(v))
						end
					end
					
					ESX.TriggerServerCallback("esx_society:getMeNames",function(identities)
						for k,v in pairs(identities) do
							table.insert(elements, {
								player = k,
								label = v
							})
						end		
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'special_cop_menu',
						{
							title = _U('recruiting'),
							align = 'left',
							elements = elements,
						},
						function(data, menu)
							ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_confirm_' .. society, {
								title    = _U('do_you_want_to_recruit', data.current.label),
								align    = 'center',
								elements = {
									{label = _U('no'),  value = 'no'},
									{label = _U('yes'), value = 'yes'}
								}
							}, function(data2, menu2)
								menu2.close()

								if data2.current.value == 'yes' then
									ESX.ShowNotification(_U('you_have_hired', data.current.label))
									ESX.TriggerServerCallback('esx_society:setJob', function()
										OpenRecruitMenu(society, level, custom)
									end, data.current.player, society, 0, 'hire', PlayerData.job.name, society)
								end
							end, function(data2, menu2)
								menu2.close()
							end)
						end,
						function(data, menu)
							menu.close()
						end)	
					end, serverIds)
				else
					ESX.ShowNotification('~r~Brak graczy w pobliżu!')
				end
			end
		end, society)
	else
		local players = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 3.0)
		if json.encode(players) ~= '[]' then
			local elements = {}
			local serverIds = {}
			
			for k,v in ipairs(players) do
				if v ~= PlayerId() then
					table.insert(serverIds, GetPlayerServerId(v))
				end
			end
			
			ESX.TriggerServerCallback("esx_society:getMeNames",function(identities)
				for k,v in pairs(identities) do
					table.insert(elements, {
						player = k,
						label = v
					})
				end		
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'special_cop_menu',
				{
					title = _U('recruiting'),
					align = 'left',
					elements = elements,
				},
				function(data, menu)
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_confirm_' .. society, {
						title    = _U('do_you_want_to_recruit', data.current.label),
						align    = 'center',
						elements = {
							{label = _U('no'),  value = 'no'},
							{label = _U('yes'), value = 'yes'}
						}
					}, function(data2, menu2)
						menu2.close()

						if data2.current.value == 'yes' then
							ESX.ShowNotification(_U('you_have_hired', data.current.label))
							ESX.TriggerServerCallback('esx_society:setJob', function()
								OpenRecruitMenu(society, level, custom)
							end, data.current.player, society, 0, 'hire', PlayerData.job.name, society)
						end
					end, function(data2, menu2)
						menu2.close()
					end)
				end,
				function(data, menu)
					menu.close()
				end)	
			end, serverIds)
		else
			ESX.ShowNotification('~r~Brak graczy w pobliżu!')
		end
	end
end

function OpenPromoteMenu(society, employee)

	ESX.TriggerServerCallback('esx_society:getJob', function(job)

		local elements = {}
		for i=1, #job.grades, 1 do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)

			if PlayerData.job.grade >= job.grades[i].grade then
				table.insert(elements, {
					label = gradeLabel,
					value = job.grades[i].grade,
					selected = (employee.job.grade == job.grades[i].grade)
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'promote_employee_' .. society, {
			title    = _U('promote_employee', employee.name),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()
			ESX.ShowNotification(_U('you_have_promoted', employee.name, data.current.label))

			ESX.TriggerServerCallback('esx_society:setJob', function()
				OpenEmployeeList(society)
			end, employee.identifier, society, data.current.value, 'promote')
		end, function(data, menu)
			menu.close()
			OpenEmployeeList(society)
		end)

	end, society)

end

function OpenManageGradesMenu(society)

	ESX.TriggerServerCallback('esx_society:getJob', function(job)

		local elements = {}

		for i=1, #job.grades, 1 do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)

			table.insert(elements, {
				label = ('%s - <span style="color:green;">%s</span>'):format(gradeLabel, _U('money_generic', ESX.Math.GroupDigits(job.grades[i].salary))),
				value = job.grades[i].grade
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_' .. society, {
			title    = _U('salary_management'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'manage_grades_amount_' .. society, {
				title = _U('salary_amount')
			}, function(data2, menu2)

				local amount = tonumber(data2.value)

				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				elseif amount > Config.MaxSalary then
					ESX.ShowNotification(_U('invalid_amount_max'))
				else
					menu2.close()

					ESX.TriggerServerCallback('esx_society:setJobSalary', function()
						OpenManageGradesMenu(society)
					end, society, data.current.value, amount)
				end

			end, function(data2, menu2)
				menu2.close()
			end)

		end, function(data, menu)
			menu.close()
		end)

	end, society)

end

AddEventHandler('esx_society:openBossMenu', function(society, close, options)
	OpenBossMenu(society, close, options)
end)

function OpenHiddenBossMenu(society, level, close, options)
	local options  = options or {}
	local elements = {}
	
	local fractionAccount = 0
    local moneyLoaded = false

	ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
		fractionAccount = money
		moneyLoaded = true
	end, society)

	while not moneyLoaded do
		Citizen.Wait(100)
	end

	local defaultOptions = {
		showmoney = false,
		withdraw  = false,
		deposit   = true,
		wash      = false,
		employees = false,
		grades    = false
	}

	for k,v in pairs(defaultOptions) do
		if options[k] == nil then
			options[k] = v
		end
	end

	if options.showmoney then
		table.insert(elements, {label = ('Saldo: '..fractionAccount..'$'), value = 'none'})
	end

	if options.withdraw then
		table.insert(elements, {label = _U('withdraw_society_money'), value = 'withdraw_society_money'})
	end

	if options.deposit then
		table.insert(elements, {label = _U('deposit_society_money'), value = 'deposit_money'})
	end

	if options.wash then
		table.insert(elements, {label = _U('wash_money'), value = 'wash_money'})
	end

	if options.employees then
		table.insert(elements, {label = _U('employee_management'), value = 'manage_employees'})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_actions_' .. society, {
		title    = _U('boss_menu'),
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'withdraw_society_money' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'withdraw_society_money_amount_' .. society, {
				title = _U('withdraw_amount')
			}, function(data, menu)

				local amount = tonumber(data.value)

				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				else
					menu.close()
					TriggerServerEvent('spoleczenstwo:wyplacajUkryteSzmato', society, amount)
				end

			end, function(data, menu)
				menu.close()
			end)

		elseif data.current.value == 'deposit_money' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'deposit_money_amount_' .. society, {
				title = _U('deposit_amount')
			}, function(data, menu)

				local amount = tonumber(data.value)

				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				else
					menu.close()
					TriggerServerEvent('spoleczenstwo:kitrajUkrytyHajs', society, amount)
				end

			end, function(data, menu)
				menu.close()
			end)

		elseif data.current.value == 'wash_money' then

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'wash_money_amount_' .. society, {
				title = _U('wash_money_amount')
			}, function(data, menu)

				local amount = tonumber(data.value)

				if amount == nil then
					ESX.ShowNotification(_U('invalid_amount'))
				else
					menu.close()
					TriggerServerEvent('esx_society:washHiddenMoney', society, amount)
				end

			end, function(data, menu)
				menu.close()
			end)

		elseif data.current.value == 'manage_employees' then
			OpenHiddenManageEmployeesMenu(society, level)
		end

	end, function(data, menu)
		if close then
			close(data, menu)
		end
	end)

end

function OpenHiddenManageEmployeesMenu(society, level)
	ESX.TriggerServerCallback('society:countHiddenMembers', function(all)
		local maxCount = tonumber(level) * 5

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_employees_' .. society, {
			title    = _U('employee_management'),
			align    = 'top-left',
			elements = {
				{label = _U('employee_list') .. ' <span style="color: #add8e6;">' .. all .. '/' .. maxCount .. '</span>', value = 'employee_list'},
				{label = _U('recruit'),       value = 'recruit'}
			}
		}, function(data, menu)

			if data.current.value == 'employee_list' then
				OpenHiddenEmployeeList(society, level)
			end

			if data.current.value == 'recruit' then
				OpenHiddenRecruitMenu(society, level)
			end

		end, function(data, menu)
			menu.close()
		end)
	end, society)
end

function OpenHiddenEmployeeList(society, level)
	ESX.TriggerServerCallback('flux:pokazUkrytychKlapkow', function(employees)
		local elements = {
			head = {_U('employee'), _U('grade'), _U('actions')},
			rows = {}
		}

		for i=1, #employees, 1 do
			local gradeLabel = (employees[i].hiddenjob.grade_label == '' and employees[i].hiddenjob.label or employees[i].hiddenjob.grade_label)

			table.insert(elements.rows, {
				data = employees[i],
				cols = {
					employees[i].name,
					gradeLabel,
					'{{' .. _U('promote') .. '|promote}} {{' .. _U('fire') .. '|fire}}'
				}
			})
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_' .. society, elements, function(data, menu)
			local employee = data.data

			if data.value == 'promote' then
				menu.close()
				OpenHiddenPromoteMenu(society, employee, level)
			elseif data.value == 'fire' then
				ESX.ShowNotification(_U('you_have_fired', employee.name))

				ESX.TriggerServerCallback('esx_society:setHiddenJob', function()
					OpenHiddenEmployeeList(society, level)
				end, employee.identifier, 'unemployed', 0, 'fire')
			end
		end, function(data, menu)
			menu.close()
			OpenHiddenManageEmployeesMenu(society, level)
		end)

	end, society)

end

function OpenHiddenRecruitMenu(society, level)
	ESX.TriggerServerCallback('society:countMembers', function(all)
		if all >= (tonumber(level) * 5) then
			if tonumber(level) == 20 then
				ESX.ShowNotification('~r~Twoja organizacja posiada już maksymalny poziom i maksymalną ilość członków')
			else
				ESX.ShowNotification('~r~Aby zatrudnić więcej osób musisz podnieść poziom organizacji')
			end
		else
			local players = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 5.0)
			if json.encode(players) ~= '[]' then
				local elements = {}
				local serverIds = {}

				for k,v in ipairs(players) do
					if v ~= PlayerId() then
						table.insert(serverIds, GetPlayerServerId(v))
					end
				end
				ESX.TriggerServerCallback("esx_society:getMeNames",function(identities)
					for k,v in pairs(identities) do
						table.insert(elements, {
							player = k,
							label = v
						})
					end

					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_' .. society, {
						title    = _U('recruiting'),
						align    = 'top-left',
						elements = elements
					}, function(data, menu)

						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_confirm_' .. society, {
							title    = _U('do_you_want_to_recruit', data.current.label),
							align    = 'top-left',
							elements = {
								{label = _U('no'),  value = 'no'},
								{label = _U('yes'), value = 'yes'}
							}
						}, function(data2, menu2)
							menu2.close()

							if data2.current.value == 'yes' then
								ESX.ShowNotification(_U('you_have_hired', data.current.label))

								ESX.TriggerServerCallback('esx_society:setHiddenJob', function()
									OpenHiddenRecruitMenu(society, level)
								end, data.current.player, society, 0, 'hire')
							end
						end, function(data2, menu2)
							menu2.close()
						end)

					end, function(data, menu)
						menu.close()
					end)

				end, serverIds)
			else
				ESX.ShowNotification('~r~Brak graczy w pobliżu!')
			end
		end
	end, society)
end

function OpenHiddenPromoteMenu(society, employee, level)

	ESX.TriggerServerCallback('esx_society:getJob', function(job)

		local elements = {}

		for i=1, #job.grades, 1 do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)

			table.insert(elements, {
				label = gradeLabel,
				value = job.grades[i].grade,
				selected = (employee.hiddenjob.grade == job.grades[i].grade)
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'promote_employee_' .. society, {
			title    = _U('promote_employee', employee.name),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()
			ESX.ShowNotification(_U('you_have_promoted', employee.name, data.current.label))

			ESX.TriggerServerCallback('esx_society:setHiddenJob', function()
				OpenHiddenEmployeeList(society, level)
			end, employee.identifier, society, data.current.value, 'promote')
		end, function(data, menu)
			menu.close()
			OpenHiddenEmployeeList(society, level)
		end)

	end, society)

end

function OpenLicenseBossMenu(society, level, close, options)
	local options  = options or {}
	local elements = {}

	local defaultOptions = {
		showmoney = false,
		withdraw  = false,
		deposit   = true,
		wash      = false,
		employees = false,
		grades    = false
	}

	for k,v in pairs(defaultOptions) do
		if options[k] == nil then
			options[k] = v
		end
	end

	if options.employees then
		table.insert(elements, {label = _U('employee_management'), value = 'manage_employees'})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_actions_' .. society, {
		title    = _U('boss_menu'),
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'manage_employees' then
			OpenLicenseManageEmployeesMenu(society, level)
		end
	end, function(data, menu)
		if close then
			close(data, menu)
		end
	end)

end

function OpenLicenseManageEmployeesMenu(society, level)
	ESX.TriggerServerCallback('society:countLicenseMembers', function(all)
		local maxCount = tonumber(level) * 5

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_employees_' .. society, {
			title    = _U('employee_management'),
			align    = 'top-left',
			elements = {
				{label = _U('employee_list') .. ' <span style="color: #add8e6;">' .. all .. '/' .. maxCount .. '</span>', value = 'employee_list'},
				{label = _U('recruit'),       value = 'recruit'}
			}
		}, function(data, menu)

			if data.current.value == 'employee_list' then
				OpenLicenseEmployeeList(society, level)
			end

			if data.current.value == 'recruit' then
				OpenLicenseRecruitMenu(society, level)
			end

		end, function(data, menu)
			menu.close()
		end)
	end, society)
end

function OpenLicenseEmployeeList(society, level)
	ESX.TriggerServerCallback('flux:pokazLicenseKlapkow', function(employees)
		local elements = {
			head = {_U('employee'), _U('grade'), _U('actions')},
			rows = {}
		}
		for i=1, #employees, 1 do
			local gradeLabel = (employees[i].hiddenjob.grade_label == '' and employees[i].hiddenjob.label or employees[i].hiddenjob.grade_label)

			table.insert(elements.rows, {
				data = employees[i],
				cols = {
					employees[i].name,
					gradeLabel,
					'{{' .. _U('promote') .. '|promote}} {{' .. _U('fire') .. '|fire}}'
				}
			})
		end

		ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'employee_list_' .. society, elements, function(data, menu)
			local employee = data.data

			if data.value == 'promote' then
				menu.close()
				OpenLicensePromoteMenu(society, employee, level)
			elseif data.value == 'fire' then
				ESX.ShowNotification(_U('you_have_fired', employee.name))

				ESX.TriggerServerCallback('esx_society:setLicenseJob', function()
					OpenLicenseEmployeeList(society, level)
				end, employee.identifier, 'unemployed', 0, 'fire')
			end
		end, function(data, menu)
			menu.close()
			OpenLicenseManageEmployeesMenu(society, level)
		end)

	end, society)

end

function OpenLicenseRecruitMenu(society, level)
	ESX.TriggerServerCallback('society:countMembers', function(all)
		local players = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 5.0)
		if json.encode(players) ~= '[]' then
			local elements = {}
			local serverIds = {}

			for k,v in ipairs(players) do
				if v ~= PlayerId() then
					table.insert(serverIds, GetPlayerServerId(v))
				end
			end
			ESX.TriggerServerCallback("esx_society:getMeNames",function(identities)
				for k,v in pairs(identities) do
					table.insert(elements, {
						player = k,
						label = v
					})
				end

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_' .. society, {
					title    = _U('recruiting'),
					align    = 'top-left',
					elements = elements
				}, function(data, menu)

					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'recruit_confirm_' .. society, {
						title    = _U('do_you_want_to_recruit', data.current.label),
						align    = 'top-left',
						elements = {
							{label = _U('no'),  value = 'no'},
							{label = _U('yes'), value = 'yes'}
						}
					}, function(data2, menu2)
						menu2.close()

						if data2.current.value == 'yes' then
							ESX.ShowNotification(_U('you_have_hired', data.current.label))

							ESX.TriggerServerCallback('esx_society:setLicenseJob', function()
								OpenLicenseRecruitMenu(society, level)
							end, data.current.player, society, 0, 'hire')
						end
					end, function(data2, menu2)
						menu2.close()
					end)

				end, function(data, menu)
					menu.close()
				end)

			end, serverIds)
		else
			ESX.ShowNotification('~r~Brak graczy w pobliżu!')
		end
	end, society)
end

function OpenLicensePromoteMenu(society, employee, level)

	ESX.TriggerServerCallback('esx_society:getJob', function(job)

		local elements = {}

		for i=1, #job.grades, 1 do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)

			table.insert(elements, {
				label = gradeLabel,
				value = job.grades[i].grade,
				selected = (employee.hiddenjob.grade == job.grades[i].grade)
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'promote_employee_' .. society, {
			title    = _U('promote_employee', employee.name),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()
			ESX.ShowNotification(_U('you_have_promoted', employee.name, data.current.label))

			ESX.TriggerServerCallback('esx_society:setLicenseJob', function()
				OpenLicenseEmployeeList(society, level)
			end, employee.identifier, society, data.current.value+1, 'promote')
		end, function(data, menu)
			menu.close()
			OpenLicenseEmployeeList(society, level)
		end)

	end, society)

end

AddEventHandler('esx_society:openLicenseBossMenu', function(society, level, close, options)
	OpenLicenseBossMenu(society, level, close, options)
end)

AddEventHandler('esx_society:openHiddenBossMenu', function(society, level, close, options)
	OpenHiddenBossMenu(society, level, close, options)
end)

function OpenJobCenterManage()
	ESX.TriggerServerCallback('xfsd:checkhiringstatus', function(kalbak)
		local status = nil
		if kalbak == true then
			status = 'Wyłączone ❌'
		elseif kalbak == false then
			status = 'Włączone ✔️'
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_center_manage', {
			title    = 'Zatrudnianie się w urzedzie',
			align    = 'center',
			elements = {
				{label = "Status: "..status,	value = ''},
				{label = "Zmień możliwość", value = 'switch'}
			}
		}, function(data, menu)
			if data.current.value == 'switch' then
				if kalbak == true then
					ESX.ShowNotification('Włączyłeś możliwość zatrudniania się w urzędzie pracy')
					TriggerServerEvent('xfsd:changeHiringOption', 0, PlayerData.job.name)
					menu.close()
					Citizen.Wait(500)
					OpenJobCenterManage()
				elseif kalbak == false then
					ESX.ShowNotification('Wyłączyłeś możliwość zatrudniania się w urzędzie pracy')
					TriggerServerEvent('xfsd:changeHiringOption', 1, PlayerData.job.name)
					menu.close()
					Citizen.Wait(500)
					OpenJobCenterManage()
				end
			end
		end, function(data, menu)
			menu.close()
		end)
	end, PlayerData.job.name)
end