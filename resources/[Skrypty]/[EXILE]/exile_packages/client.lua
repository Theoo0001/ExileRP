ESX = nil
local PlayerData = {}

local propLockers = {
    { coords = vector3(417.2494, -991.9, 28.3929), street = 'Mission Row', name = 'Paczkomat #1', id = 1 },
    { coords = vector3(-666.2905, 311.3543, 82.1347), street = 'Eclipse', name = 'Paczkomat #2', id = 2 },
    { coords = vector3(889.4495, -12.918, 77.814), street = 'Casino', name = 'Paczkomat #3', id = 3 },
    { coords = vector3(1130.282, -480.1451, 65.0274), street = 'Mirror Park', name = 'Paczkomat #4', id = 4 },
    { coords = vector3(-263.1639, -821.2453, 30.8299), street = 'Pillbox Hill', name = 'Paczkomat #5', id = 5 },
    { coords = vector3(-475.4159, -291.3597, 34.5849), street = 'Mount Zonah', name = 'Paczkomat #6', id = 6 },
    { coords = vector3(-718.6859, -821.0955, 22.4979), street = 'Little Seoul', name = 'Paczkomat #7', id = 7 },
    { coords = vector3(-1304.6841, -638.525, 25.565), street = 'Del Perro', name = 'Paczkomat #8', id = 8 },
    { coords = vector3(36.4621, -1758.1057, 28.3522), street = 'Davis Ave', name = 'Paczkomat #9', id = 9 },
    { coords = vector3(-1042.4281, -2648.5244, 13.0309), street = 'Airport', name = 'Paczkomat #10', id = 10 },
    { coords = vector3(1163.1674, -1503.9263, 33.744), street = 'St Fiacre', name = 'Paczkomat #11', id = 11 },
    { coords = vector3(1953.0906, 3743.0361, 31.2326), street = 'Sandy Shores', name = 'Paczkomat #12', id = 12 },
    { coords = vector3(2550.1189, 345.2232, 107.5198), street = 'Tataviam Mountains', name = 'Paczkomat #13', id = 13 },
    { coords = vector3(1853.7809, 2624.5691, 44.722), street = 'Prison', name = 'Paczkomat #14', id = 14 },
    { coords = vector3(2742.2053, 3444.1323, 55.1632), street = 'Senora Fwy', name = 'Paczkomat #15', id = 15 },
    { coords = vector3(1693.9713, 4770.1104, 40.9715), street = 'Grapeseed', name = 'Paczkomat #16', id = 16 },
    { coords = vector3(-2960.4558, 469.338, 14.311), street = 'Banham Canyon', name = 'Paczkomat #17', id = 17 },
    { coords = vector3(-204.2306, 6227.4912, 30.7109), street = 'Paleto Bay', name = 'Paczkomat #18', id = 18 },
}

local packageList = {}

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

CreateThread(function()
    Citizen.Wait(1000)
	for i=1, #propLockers, 1 do
		local blip = AddBlipForCoord(propLockers[i].coords)

		SetBlipSprite (blip, 501)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.5)
		SetBlipColour (blip, 43)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Paczkomat')
		EndTextCommandSetBlipName(blip)
	end
end)

RegisterNetEvent('exile_packages:removeList')
AddEventHandler('exile_packages:removeList', function(items)
    if items[1] ~= nil then
        TriggerServerEvent('exile_packages:returnInventory', items)
        for i=1, #items, 1 do
            packageList[i] = nil
        end
    end
end)

CreateThread(function()
    while true do
        local isNear = GetClosestLocker()
        if isNear ~= nil then
            DisplayHelpText("Naciśnij ~INPUT_PICKUP~ aby skorzystać z paczkomatu")

            if IsControlJustPressed(1, 38) then
                ESX.ShowAdvancedNotification('Exilomaty.eu', '~b~Informacja', 'Jeżeli zrezygnujesz z wysyłki ~b~odejdź~w~ od paczkomatu, a my oddamy twoje przedmioty', 5000)
                OpenLockerMenu(isNear.id, isNear.name, isNear.street)
            end
        else
            if packageList[1] ~= nil then
                TriggerServerEvent('exile_packages:returnInventory', packageList)
                for i=1, #packageList, 1 do
                    packageList[i] = nil
                end
            end
            Citizen.Wait(1000)
        end

        Citizen.Wait(10)
    end
end)

GetClosestLocker = function()
    local playerlocation = GetEntityCoords(PlayerPedId())

    local nearObject = nil

    for i=1, #propLockers, 1 do
        if #(playerlocation - propLockers[i].coords) < 2.5 then
            nearObject = { id = propLockers[i].id, name = propLockers[i].name, street =  propLockers[i].street }
            break
        end
    end

    return nearObject
end

local itemsCount = 0

OpenLockerMenu = function(id, name, street)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'locker_' .. id, {
        title    = name .. " (" .. street .. ")",
        align    = 'center',
        elements = {
            {label = "Nadaj paczkę", value = 'send'},
            {label = 'Odbierz paczkę', value = 'receive'},
            --{label = 'Anulowanie wysyłki', value = 'cancel'},
            --{label = 'Poznam paczkomaty', value = 'info'},
        }
    }, function(data, menu)
        menu.close()
        if data.current.value == 'send' then
            OpenSendMenu(id, itemsCount)
        elseif data.current.value == 'receive' then
            OpenReceiveMenu(id, name, street)
        elseif data.current.value == 'cancel' then
            OpenCancelMenu(id, name, street)
        elseif data.current.value == 'info' then
            InfoLockers()
        end
    end, function(data, menu)
        menu.close()
    end)
end

OpenReceiveMenu = function(id, name, street)
    ESX.UI.Menu.CloseAll()
    ESX.TriggerServerCallback('exile_packages:checkLockers', function(data)
        if data then
            local elements = {}
            for i=1, #data, 1 do
                table.insert(elements, { label = 'Paczka #'.. data[i].id ..' (' .. data[i].title .. ')', id = data[i].id, code = data[i].code, price = data[i].price, method = data[i].method, sender = data[i].sender, items = data[i].items })
            end
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ask', {
                title    = "Lista paczek do odbioru",
                align    = 'center',
                elements = elements
            }, function(data, menu)
                menu.close()
                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'receivecode', {
                    title = ('Wprowadź kod odbioru paczki')
                }, function(data2, menu2)
                    menu2.close()
                    local codee, method, price, sender, items = data2.value, data.current.method, data.current.price, data.current.sender, data.current.items
                    if codee == data.current.code then
                        if method == 'cash' then
                            local elements2 = {
                                {label = "Płacę, odbieram", value = 'yes'},
                                {label = 'Nie odbieram', value = 'no'},
                                {label = 'Zwróć paczkę nadawcy', value = 'return'},
                                {label = '== ZAWARTOŚĆ PACZKI ==', value = nil},
                            }
                            for i=1, #items, 1 do
                                table.insert(elements2, { label = items[i].label .. ' x' .. items[i].count, value = i })
                            end
                            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ask', {
                                title    = "Paczka została nadana za pobraniem, aby ją odebrać należy zapłacić " .. price .. '$',
                                align    = 'center',
                                elements = elements2
                            }, function(data3, menu3)
                                menu3.close()
                                if data3.current.value == 'yes' then
                                    TriggerServerEvent('exile_packages:collectPackage', data.current.code, data.current.id, method, price, sender)
                                elseif data3.current.value == 'return' then
                                    TriggerServerEvent('exile_packages:returnPackage', sender, data.current.id, items)
                                end
                            end, function(data3, menu3)
                                menu3.close()
                            end)
                        else
                            local elements2 = {
                                {label = "Odbieram", value = 'yes'},
                                {label = 'Nie odbieram', value = 'no'},
                                {label = 'Zwróć paczkę nadawcy', value = 'return'},
                                {label = '== ZAWARTOŚĆ PACZKI ==', value = nil},
                            }
                            for i=1, #items, 1 do
                                table.insert(elements2, { label = items[i].label .. ' x' .. items[i].count, value = i })
                            end
                            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ask2', {
                                title    = "Czy napewno chcesz odebrać paczkę?",
                                align    = 'center',
                                elements = elements2
                            }, function(data4, menu4)
                                menu4.close()
                                if data4.current.value == 'yes' then
                                    TriggerServerEvent('exile_packages:collectPackage', data.current.code, data.current.id, method, 0, sender)
                                elseif data3.current.value == 'return' then
                                    TriggerServerEvent('exile_packages:returnPackage', sender, data.current.id, items)
                                end
                            end, function(data4, menu4)
                                menu4.close()
                            end)
                        end
                    else
                        ESX.ShowNotification('~r~Podany kod jest nieprawidłowy!')
                    end
                end, function(data2, menu2)
                    menu2.close()
                end)
            end, function(data, menu)
                menu.close()
            end)
        else
            ESX.ShowNotification('~r~Brak paczek do odebrania przy tym paczkomacie')
        end
    end, id)
end

OpenCancelMenu = function(id, name, street)
    ESX.UI.Menu.CloseAll()
    ESX.TriggerServerCallback('exile_packages:checkDeliveries', function(data)
        if data then
            local elements = {}
            for i=1, #data, 1 do
                table.insert(elements, { label = 'Paczka #'.. data[i].id ..' (' .. data[i].title .. ')', id = data[i].id, items = data[i].items, receiver = data[i].receiver })
            end
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ask_cancel', {
                title    = "Lista wysłanych paczek",
                align    = 'center',
                elements = elements
            }, function(data, menu)
                local items = data.current.items
                menu.close()
                local elements2 = {
                    {label = "Tak", value = 'yes'},
                    {label = 'Nie', value = 'no'},
                    {label = '== ZAWARTOŚĆ PACZKI ==', value = nil},
                }
                for i=1, #items, 1 do
                    table.insert(elements2, { label = items[i].label .. ' x' .. items[i].count, value = i })
                end
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ask_cancel2', {
                    title    = "Czy napewno chcesz anulować wysyłkę?",
                    align    = 'center',
                    elements = elements2
                }, function(data2, menu2)
                    menu2.close()
                    if data2.current.value == 'yes' then
                        TriggerServerEvent('exile_packages:cancelDelivery', data.current.id, items, data.current.receiver)
                    end
                end, function(data2, menu2)
                    menu2.close()
                end)
            end, function(data, menu)
                menu.close()
            end)
        else
            ESX.ShowNotification('~r~Brak wysłanych paczek do anulacji')
        end
    end)
end

InfoLockers = function()
    ESX.Scaleform.ShowFreemodeMessage('~b~Exilomaty.eu', 'Witaj w exilomatach, tutaj możesz nadać lub odebrać paczkę od swojego kolegi, badź koleżanki. Kwota wysyłki będzie zależna od ilości przedmiotów. Za każdy przedmiot jest pobierana opłata 5% od wartości przedmiotu', 20)
end

startAnim = function()
	CreateThread(function()
	  RequestAnimDict("mp_common")
	  while not HasAnimDictLoaded("mp_common") do
	    Citizen.Wait(0)
	  end
	  TaskPlayAnim(PlayerPedId(), "mp_common" ,"givetake2_a" ,8.0, -8.0, -1, 0, 0, false, false, false )
	end)
end

OpenSendMenu = function(id, itemsCount)
    local inventory = ESX.GetPlayerData().inventory
    while inventory == nil do
        Wait(100)
    end
    local playerPed = PlayerPedId()
	local elements = {}


	for k,v in ipairs(inventory) do
		if v.count > 0 then

			table.insert(elements, {
				label = ('%s x%s'):format(v.label, v.count),
                onlyLabel = v.label,
				count = v.count,
				type = 'item_standard',
				value = v.name,
				rare = v.rare,
			})
		end
	end

	for k,v in ipairs(Config.Weapons) do
		local weaponHash = GetHashKey(v.name)

		if HasPedGotWeapon(playerPed, weaponHash, false) then
			local ammo, label = GetAmmoInPedWeapon(playerPed, weaponHash)

			if v.ammo then
				label = ('%s - [%s]'):format(v.label, ammo)
			else
				label = v.label
			end

			table.insert(elements, {
				label = label,
                onlyLabel = label,
				count = 1,
				type = 'item_weapon',
				value = v.name,
				rare = false,
				ammo = ammo,
				canGiveAmmo = (v.ammo ~= nil),
			})
		end
	end

	ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'packing', {
		title    = ('Co chcesz zapakować?'),
		align    = 'center',
		elements = elements
	}, function(data, menu)
        menu.close()
        if data.current.type == 'item_weapon' and data.current.canGiveAmmo then
            if data.current.ammo < 1 then
                startAnim()
                itemsCount = itemsCount + 1
                TriggerServerEvent('exile_packages:showNotification', data.current.value, 0, data.current.type)
                table.insert(packageList, { label = data.current.onlyLabel, type = data.current.type, count = 1, value = data.current.value })
                AskForMore(id, itemsCount, packageList)
            else
                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'weapon_ammo', {
                    title = "Ilość"
                }, function(data3, menu3)
                    local quantity = tonumber(data3.value)
                    if quantity and quantity > 0 and data.current.ammo >= quantity then
                        startAnim()
                        itemsCount = itemsCount + 1
                        TriggerServerEvent('exile_packages:showNotification', data.current.value, quantity, data.current.type)
                        table.insert(packageList, { label = data.current.onlyLabel, type = data.current.type, count = quantity, value = data.current.value })
                        AskForMore(id, itemsCount, packageList)
                    else
                        ESX.ShowNotification(_U('amount_invalid'))
                    end
                end, function(data3, menu3)
                    menu3.close()
                end)
            end
        elseif data.current.type == 'item_standard' and data.current.count > 0 then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'inventory_item_count_give', {
                title = _U('amount')
            }, function(data3, menu3)
                local quantity = tonumber(data3.value)

                if quantity and quantity > 0 and data.current.count >= quantity then
                    startAnim()
                    itemsCount = itemsCount + 1
                    TriggerServerEvent('exile_packages:showNotification', data.current.value, quantity, data.current.type)
                    table.insert(packageList, { label = data.current.onlyLabel, type = data.current.type, count = quantity, value = data.current.value })
                    AskForMore(id, itemsCount, packageList)
                    menu3.close()
                else
                    ESX.ShowNotification(_U('amount_invalid'))
                end
            end, function(data3, menu3)
                menu3.close()
            end)
		end
    end, function(data, menu)
        menu.close()
    end)
end

AskForMore = function(id, itemsCount, packageList)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ask', {
        title    = "Czy to wszystko?",
        align    = 'center',
        elements = {
            {label = "Tak, przechodzę dalej", value = 'next'},
            {label = 'Nie, chce spakować więcej', value = 'more'},
        }
    }, function(data, menu)
        menu.close()
        if data.current.value == 'next' then
            NextStep(id, itemsCount, packageList)
        elseif data.current.value == 'more' then
            if itemsCount < 3 then
                OpenSendMenu(id, itemsCount, packageList)
            else
                ESX.ShowNotification('~r~Nie możesz zapakować więcej do paczki')
                NextStep(id, itemsCount)
            end
        end
    end, function(data, menu)
        menu.close()
    end)
end

NextStep = function(id, itemsCount, packageList)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ask', {
        title    = "Wybierz metode wysłki (koszt przesyłki)",
        align    = 'center',
        elements = {
            {label = "Standardowa (5000$)", value = 'default'},
            {label = 'Za Pobraniem (dodatkowe 6000$ od przedmiotu)', value = 'cash'},
        }
    }, function(data, menu)
        menu.close()
        if data.current.value == 'default' then
            PhoneNumber('default', id, itemsCount, packageList)
        elseif data.current.value == 'cash' then
            PhoneNumber('cash', id, itemsCount, packageList)
        end
    end, function(data, menu)
        menu.close()
    end)
end

PhoneNumber = function(method, id, itemsCount, packageList)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'phonee', {
        title = ('Wprowadź numer telefonu odbiorcy')
    }, function(data2, menu2)
        menu2.close()
        local phoneNumber = data2.value
        ESX.TriggerServerCallback('exile_packages:checkNumber', function(exist)
            if exist then
                if phoneNumber ~= nil then
                    if method == 'cash' then
                        SetPrice(method, id, phoneNumber, itemsCount, packageList)
                    else
                        SetTitle(method, id, phoneNumber, 0, itemsCount, packageList)
                    end
                else
                    PhoneNumber(method, id, itemsCount, packageList)
                    ESX.ShowNotification('~r~Niepoprawny numer telefonu')
                end
            else
                PhoneNumber(method, id, itemsCount, packageList)
                ESX.ShowNotification('~r~Podany numer telefonu nie istnieje!')
            end
        end, phoneNumber)
    end, function(data2, menu2)
        menu2.close()
    end)
end

SetPrice = function(method, id, phoneNumber, itemsCount, packageList)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'pricex', {
        title = ('Wprowadź kwotę przesyłki')
    }, function(data2, menu2)
        menu2.close()
        local price = data2.value
        if price ~= nil then
            if string.len(price) < 11 then
                if type(price) == 'number' then
                    SetTitle(method, id, phoneNumber, price, itemsCount, packageList)
                else
                    SetPrice(method, id, phoneNumber, itemsCount, packageList)
                    ESX.ShowNotification('~r~Nieprawidłowa kwota')
                end
            else
                SetPrice(method, id, phoneNumber, itemsCount, packageList)
                ESX.ShowNotification('~r~Podana kwota jest zbyt długa, max 11 cyfr')
            end
        else
            SetPrice(method, id, phoneNumber, itemsCount, packageList)
            ESX.ShowNotification('~r~Nieprawidłowa kwota')
        end
    end, function(data2, menu2)
        menu2.close()
    end)
end

SetTitle = function(method, id, phoneNumber, price, itemsCount, packageList)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'titlex', {
        title = ('Wprowadź tytuł przesyłki (max 20 znaków)')
    }, function(data2, menu2)
        menu2.close()
        local title = data2.value
        if title ~= nil then
            if string.len(tostring(title)) <= 20 then
                SetDeliveryPlace(method, id, phoneNumber, price, itemsCount, packageList, title)
            else
                SetTitle(method, id, phoneNumber, price, itemsCount, packageList)
                ESX.ShowNotification('~r~Podano zbyt długi tytuł przesyłki')
            end
        else
            SetTitle(method, id, phoneNumber, itemsCount, packageList)
            ESX.ShowNotification('~r~Nieprawidłowy tytuł')
        end
    end, function(data2, menu2)
        menu2.close()
    end)
end

SetDeliveryPlace = function(method, id, phoneNumber, price, itemsCount, packageList, title)
    ESX.UI.Menu.CloseAll()
    local elements = {}
    local lockerLabel = nil
    for i=1, #propLockers, 1 do
        local label
        if propLockers[i].id == id then
            label = '>> ' .. propLockers[i].name .. " (" .. propLockers[i].street .. ") <<"
        else
            label = propLockers[i].name .. " (" .. propLockers[i].street .. ")"
        end
        table.insert(elements, { label = label, value = propLockers[i].id, targetLabel = propLockers[i].name .. " (" .. propLockers[i].street .. ")" })
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ask', {
        title    = "Wybierz miejsce dostawy",
        align    = 'center',
        elements = elements
    }, function(data, menu)
        menu.close()
        if data.current.value then
            Submit(method, id, phoneNumber, price, itemsCount, packageList, data.current.targetLabel, title, data.current.value)
        end
    end, function(data, menu)
        menu.close()
    end)
end

Submit = function(method, id, phoneNumber, price, itemsCount, packageList, lockerLabel, title, targetLocker)
    ESX.UI.Menu.CloseAll()
    local deliveryPrice = 5000
    if method == 'cash' then
        deliveryPrice = 6000 * itemsCount
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ask', {
        title    = "Czy napewno chcesz wysłać paczkę?",
        align    = 'center',
        elements = {
            {label = "Tak", value = 'yes'},
            {label = "Nie", value = 'cancel'},
            {label = "Ustaw nowego nadawce", value = 'return'}
        }
    }, function(data, menu)
        menu.close()
        if data.current.value == 'yes' then
            ESX.TriggerServerCallback('exile_packages:checkNigger', function(can)
                if can then
                    TriggerServerEvent('exile_packages:addDelivery', deliveryPrice, price, phoneNumber, id, method, packageList, lockerLabel, title, targetLocker)
                    if packageList[1] ~= nil then
                        for i=1, #packageList, 1 do
                            packageList[i] = nil
                        end
                    end
                else
                    Submit(method, id, phoneNumber, price, itemsCount, packageList, lockerLabel, title, targetLocker)
                    ESX.ShowNotification('~r~Nie możesz wysłać paczki sam do siebie! Aby zwrócić przedmioty, odejdź od paczkomatu')
                end
            end, phoneNumber)
        elseif data.current.value == 'return' then
            PhoneNumber(method, id, itemsCount, packageList)
        --[[elseif data.current.value == 'cancel' then
            if packageList[1] ~= nil then
                TriggerServerEvent('exile_packages:returnInventory', packageList)
                for i=1, #packageList, 1 do
                    packageList[i] = nil
                end
            end]]
        end
    end, function(data, menu)
        menu.close()
    end)
end

DisplayHelpText = function(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
