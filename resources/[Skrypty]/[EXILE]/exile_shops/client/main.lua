RegisterNetEvent("esx_shops:getrequest")
TriggerServerEvent("esx_shops:request")
AddEventHandler("esx_shops:getrequest", function(a)
	_G.sell = a
	local donttouchme = _G.sell

ESX                           = nil
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local PlayerData              = {}

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


function OpenShopMenu(zone)
	PlayerData = ESX.GetPlayerData()

	local elements = {}
	for k,v in pairs(Config.Zones[zone].Items) do
		table.insert(elements, 
			{
				label =  v.title..' <span style="color: #7cfc00;">$'..v.price..'</span>',
				item = v.item,
				price = v.price,
				titleconfirm = v.title,
				value      = 1,
				type       = 'slider',
				min        = 1,
				max        = v.limit
			}
		)
	end
	if zone == 'Multimedialny' then		
		table.insert(elements, {label = 'Wyrób duplikat karty SIM <span style="color: #7cfc00;">$2500</span>', value = 'duplikat'})
		table.insert(elements, {label = 'Zablokuj kartę SIM <span style="color: #7cfc00;">$2500</span>', value = 'block'})
		table.insert(elements, {label = 'Odblokuj kartę SIM <span style="color: #7cfc00;">$2500</span>', value = 'unblock'})
		table.insert(elements, {label = 'Kopiuj kontakty karty SIM <span style="color: #7cfc00;">$5000</span>', value = 'copy'})
		table.insert(elements, {label = 'Wyrejestruj kartę SIM <span style="color: #7cfc00;">$10000</span>', value = 'delcard'})
		table.insert(elements, {label = 'Zarządzaj numerami', value = 'administrator'})
	end
	if zone == 'Lombard' then
		table.insert(elements, {label = 'Spzedaj przedmioty', value = 'lombard'})
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop', {
		title    = 'Sklep',
		align    = 'center',
		elements = elements
	}, function(data, menu)
	
		if data.current.value == 'block' then
			OpenBlockMenu()
		elseif data.current.value == 'unblock' then
			OpenUnBlockMenu()
		elseif data.current.value == 'duplikat' then
			OpenDuplikatMenu()
		elseif data.current.value == 'copy' then
			OpenCopyMenu()
		elseif data.current.value == 'delcard' then
			OpenDelMenu()
		elseif data.current.value == 'administrator' then
			menu.close()
			OpenAdministratorMenu()
		elseif data.current.value == 'lombard' then
			menu.close()
			OpenLombardMenu()
		else
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_confirm', {
				title    = 'Czym chcesz zapłacić za '..data.current.titleconfirm..' za '..data.current.price..'$?',
				align    = 'center',
				elements = {
					{label = 'Gotówką',  value = 'gotowka'},
					{label = 'Kartą', value = 'karta'},
					{label = 'Nie chce nic kupywać', value = 'niechce'},
				}
			}, function(data2, menu2)
					if data2.current.value == 'gotowka' then
						TriggerServerEvent('esx_shops:buyItem', data.current.item, data.current.value, data.current.price, data.current.max, 'money', zone)
				elseif data2.current.value == 'karta' then
					TriggerServerEvent('esx_shops:buyItem', data.current.item, data.current.value, data.current.price, data.current.max, 'bank', zone)
				elseif data2.current.value == 'niechce' then
					menu2.close()
					menu.open()
				end

				menu2.close()
			end, function(data2, menu2)
				menu2.close()
			end)			
		end
	end, function(data, menu)
		menu.close()
		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~ aby skorzystać ze ~y~sklepu~s~.'
		CurrentActionData = {zone = zone}
	end)
end

function OpenDelMenu()
	local elements = {}
	ESX.TriggerServerCallback('gcPhone:getHasSims', function(cards)
		if cards ~= nil then
			for _,v in pairs(cards) do
				table.insert(elements, {label = 'Karta SIM #'..v.number, value = v})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'duplikat', {
				title    = 'Zablokuj kartę sim',
				align    = 'center',
				elements = elements,
			}, function(data, menu)
				menu.close()
				TriggerServerEvent('gcPhone:delSIM', data.current.value)
			end, function(data, menu)
				menu.close()
			end)	
		else
			ESX.ShowNotification('~r~Nie posiadasz żadnej karty do zastrzeżenia')
		end
	end, true)
end

function OpenBlockMenu()
	local elements = {}
	ESX.TriggerServerCallback('gcPhone:getHasSims', function(cards)
		if cards ~= nil then
			for _,v in pairs(cards) do
				table.insert(elements, {label = 'Karta SIM #'..v.number..' '..(v.blocked == 1 and '[Zablokowana]' or '[Odblokowana]') , value = v})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'duplikat', {
				title    = 'Zablokuj kartę sim',
				align    = 'center',
				elements = elements,
			}, function(data, menu)
				menu.close()
				if data.current.value.blocked == 0 then
					TriggerServerEvent('gcPhone:blockSIM', data.current.value, 1)
				else
					ESX.ShowNotification('~r~Nie możesz zablokować kartę SIM #'..data.current.value.number)
				end
			end, function(data, menu)
				menu.close()
			end)	
		else
			ESX.ShowNotification('~r~Nie posiadasz żadnej karty do zablokowania')
		end
	end, true)
end


function OpenUnBlockMenu()
	local elements = {}
	ESX.TriggerServerCallback('gcPhone:getHasSims', function(cards)
		if cards ~= nil then
			for _,v in pairs(cards) do
				table.insert(elements, {label = 'Karta SIM #'..v.number..' '..(v.blocked == 1 and '[Zablokowana]' or '[Odblokowana]') , value = v})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'duplikat', {
				title    = 'Zablokuj kartę sim',
				align    = 'center',
				elements = elements,
			}, function(data, menu)
				menu.close()
				if data.current.value.blocked == 1 then
					TriggerServerEvent('gcPhone:blockSIM', data.current.value, 0)
				else
					ESX.ShowNotification('~r~Nie możesz odblokować kartę SIM #'..data.current.value.number)
				end
			end, function(data, menu)
				menu.close()
			end)	
		else
			ESX.ShowNotification('~r~Nie posiadasz żadnej karty do odblokowania')
		end
	end, true)
end

function OpenDuplikatMenu()
	local elements = {}
	ESX.TriggerServerCallback('gcPhone:getHasSims', function(cards)
		if cards ~= nil then
			for _,v in pairs(cards) do
				table.insert(elements, {label = 'Karta SIM #'..v.number, value = v})
			end
			
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'duplikat', {
				title    = 'Wyrób Duplikat',
				align    = 'center',
				elements = elements,
			}, function(data, menu)
				menu.close()
				TriggerServerEvent('gcPhone:duplikatSIM', data.current.value)
			
			end, function(data, menu)
				menu.close()
			end)	
		else
			ESX.ShowNotification('~r~Nie posiadasz żadnej karty do duplikacji')
		end
	end, false)
end

function OpenCopyMenu()
	local elements = {}
	ESX.TriggerServerCallback('gcPhone:getHasSimsCopy', function(cards, phone_number)
		if cards ~= nil then
			for _,v in pairs(cards) do
				if v.number == phone_number then
					table.insert(elements, {label = 'Karta SIM #'..v.number..' [Aktualna]', value = v, actualy = phone_number})
				else
					table.insert(elements, {label = 'Karta SIM #'..v.number , value = v, actualy = phone_number})
				end
			end
			
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'duplikat', {
				title    = 'Wybierz kartę SIM na którą chcesz skopiować kontakty',
				align    = 'center',
				elements = elements,
			}, function(data, menu)
				menu.close()
				if phone_number ~= nil then
					if data.current.actualy == data.current.value.number then
						ESX.ShowNotification('~r~Nie możesz skopiować kontaktów na tą samą kartę SIM')
					else
						TriggerServerEvent('gcPhone:CopyContactsSIM', phone_number, data.current.value)
					end
				else
					ESX.ShowNotification('~r~Nie posiadasz karty SIM podpiętej')
				end
			end, function(data, menu)
				menu.close()
			end)	
		else
			ESX.ShowNotification('~r~Nie posiadasz żadnej karty do kopiowania kontaktów')
		end
	end, false)
end

function OpenAdministratorMenu()
	ESX.UI.Menu.CloseAll()
	local elements = {}
  	ESX.TriggerServerCallback('gcPhone:getHasSims', function(cards)

		for _,v in pairs(cards) do
			local cardNumber = v.number
			local lejbel = 'Karta SIM #'..cardNumber
			table.insert(elements, {label = lejbel , value = v})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'administrator',
		{
			title    = 'Wybierz kartę sim, którą chcesz zarządzać',
			align    = 'center',
			elements = elements,
		},	function(data, menu)
			local currentNumber = data.current.value
			if currentNumber ~= 'empty' then
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'administrator2',
				{
					title = 'Wybierz opcje',
					align = 'center',
					elements = {
						{label = "Dodaj administratora <span style='color: #7cfc00;'>$10 000</span>", value = 'add_admin'},
						{label = "Usuń administratora <span style='color: #7cfc00;'>$5 000</span>", value = 'remove_admin'}
					},
				},	function(data2, menu2)
					if data2.current.value == 'add_admin' then
						local playerCoords = GetEntityCoords(PlayerPedId())
						local playersInArea = ESX.Game.GetPlayersInArea(playerCoords, 5.0)
						local elements2      = {}
						for i=1, #playersInArea, 1 do
							if playersInArea[i] ~= PlayerId() then
								table.insert(elements2, {label = GetPlayerServerId(playersInArea[i]), value = GetPlayerServerId(playersInArea[i])})
							end
						end
						ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'administrator3',
						{
							title    = "Osoby w pobliżu",
							align    = 'center',
							elements = elements2,
						}, function(data3, menu3)
							ESX.UI.Menu.CloseAll()
							
							TriggerServerEvent('gcPhone:addAdministrator', currentNumber, data3.current.value)
							Wait(500)
							OpenAdministratorMenu()
						end, function(data3, menu3)
							menu3.close()
						end)
					elseif data2.current.value == 'remove_admin' then
						ESX.TriggerServerCallback('gcPhone:getAdministrators', function(admins)
							if admins[1] == nil then
								ESX.ShowNotification("~b~Ten numer nie posiada administratorów")
							else
								ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'administrator3',
								{
									title    = "Administratorzy",
									align    = 'center',
									elements = admins,
								}, function(data3, menu3)
									local id = data3.current.value
									ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'administrator4',
									{
										title    = "Czy na pewno chcesz usunąć administratora?",
										align    = 'center',
										elements = {
											{label = 'Nie', value = 'no'},
											{label = 'Tak', value = 'yes'}
										}, 
									}, function(data4, menu4)
										if data4.current.value == 'no' then
											menu4.close()
										elseif data4.current.value == 'yes' then
											ESX.UI.Menu.CloseAll()
											TriggerServerEvent('gcPhone:removeAdministrator', currentNumber, id)
											Wait(500)
											OpenAdministratorMenu()
										end
									end, function(data4, menu4)
										menu4.close()
									end)
								end, function(data3, menu3)
									menu3.close()
								end)
							end
						end, currentNumber)
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end
		end, function(data, menu)
			menu.close()
		end)	
	end, false)
end

CreateThread(function()
	for k,v in pairs(Config.Zones) do
	if v.Blips then
		for i = 1, #v.Pos, 1 do
			local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)

			SetBlipSprite (blip, v.Blip.Sprite)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 0.7)
			SetBlipColour (blip, v.Blip.Color)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(v.Blip.Name)
			EndTextCommandSetBlipName(blip)
			end
		end
	end
end)

AddEventHandler('esx_shops:hasEnteredMarker', function(zone)
	CurrentAction     = 'shop_menu'
	CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~ aby skorzystać ze ~y~sklepu~s~.'
	CurrentActionData = {zone = zone}
end)

AddEventHandler('esx_shops:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

-- Display markers
CreateThread(function()
	while true do
		Citizen.Wait(5)
		local coords, sleep = GetEntityCoords(PlayerPedId()), true

		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Pos, 1 do
				if(Config.Type ~= -1 and #(coords - vec3(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)) < Config.DrawDistance) then
					sleep = false
					ESX.DrawMarker(vec3(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z))
				end
			end
		end
		if sleep then
			Citizen.Wait(1000)
		end
	end
end)

-- Enter / Exit marker events
CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords, sleep      = GetEntityCoords(PlayerPedId()), true
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Pos, 1 do
				if #(coords - vec3(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)) < Config.Size.x then
					sleep = false
					isInMarker  = true
					ShopItems   = v.Items
					currentZone = k
					LastZone    = k
				end
			end
		end
		if isInMarker and not HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = true
			TriggerEvent('esx_shops:hasEnteredMarker', currentZone)
		end
		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_shops:hasExitedMarker', LastZone)
		end
		if sleep then
			Citizen.Wait(1000)
		end
	end
end)

-- Key Controls
CreateThread(function()
	while true do
		Citizen.Wait(10)

		if CurrentAction ~= nil then

			SetTextComponentFormat('STRING')
			AddTextComponentString(CurrentActionMsg)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)

			if IsControlJustReleased(0, 38) then

				if CurrentAction == 'shop_menu' then
					OpenShopMenu(CurrentActionData.zone)
				end

				CurrentAction = nil

			end

		else
			Citizen.Wait(500)
		end
	end
end)

function OpenLombardMenu()
	local elements = {}
	for i=1, #Config.LombardItems, 1 do
		local item = Config.LombardItems[i]
		table.insert(elements, {
			label      = item.label .. ' - <span style="color: #7cfc00;">$' .. item.price .. '</span>',
			itemLabel = item.label,
			item       = item.item,
			price      = item.price,
		})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lombard', {
		title    = "Lombard",
		align    = 'center',
		elements = elements
	}, function(data, menu)
		local counter = data.current.item
		local inventory = ESX.GetPlayerData().inventory
			  for i=1, #inventory, 1 do                          
				  if inventory[i].name == counter then
					counter= inventory[i].count
				  end
			  end
		local total = data.current.price * counter
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'lombard_q', {
			title    = "Potwierdź sprzedaż",
			align    = 'center',
			elements = {
				{label = "== Sprzedaj <span style='color:yellow;'>x"..counter.." "..data.current.itemLabel.."</span> za <span style='color:green;'>"..total.."$</span> ==",  value = 'no'},
				{label = "Tak",  value = 'yes'},
				{label = "Nie", value = 'no'}
		}}, function(data2, menu2)

			if data2.current.value == 'yes' then
				TriggerServerEvent(donttouchme,GetCurrentResourceName(), data.current.item)
			end
			menu2.close()
		end, function(data2, menu2)
			menu2.close()
		end)

	end, function(data, menu)
		menu.close()
		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = 'Naciśnij ~INPUT_CONTEXT~ aby skorzystać ze ~y~sklepu~s~.'
		CurrentActionData = {zone = zone}
	end)
end
end)