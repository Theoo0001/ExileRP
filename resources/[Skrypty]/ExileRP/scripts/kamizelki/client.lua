RegisterNetEvent('exile_kamza')
AddEventHandler('exile_kamza', function(typ)
	if typ == 'small' then
        Citizen.InvokeNative(0xCEA04D83135264CC, playerPed, 25)
		ESX.PlayAnim('clothingshirt', 'try_shirt_neutral_c', 8.0, -1, 0)
		Wait(1000)
		SetPedComponentVariation(playerPed, 9, 11, 0, 2)
	elseif typ == 'big' then
        Citizen.InvokeNative(0xCEA04D83135264CC, playerPed, 50)
		ESX.PlayAnim('clothingshirt', 'try_shirt_neutral_c', 8.0, -1, 0)
		Wait(1000)
		SetPedComponentVariation(playerPed, 9, 11, 1, 2)
    elseif typ == 'skarpetka' then
		ESX.PlayAnim('clothingshirt', 'try_shirt_neutral_c', 8.0, -1, 0)
		Wait(1000)
		SetPedComponentVariation(playerPed, 1, 32, 0, 0)
	end
end)

RegisterNetEvent('falszywyy_barylki:mieszaczmenu')
AddEventHandler('falszywyy_barylki:mieszaczmenu', function()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mieszaczmenu', {
		title    = 'Mieszacz Narkotyków',
		align    = 'bottom-right',
		elements = {
			{label = 'Baryłka Marihuany', value = 'barylkaziola'},
			{label = 'Baryłka Metaamfetaminy', value = 'barylkametaamfetaminy'},
			{label = 'Baryłka Kokainy', value = 'barylkakokainy'},
			{label = 'Baryłka Opium', value = 'barylkaopium'},
		}
	}, function(data2, menu2)
		if data2.current.value == 'barylkaziola' then
			ESX.UI.Menu.CloseAll()
			FreezeEntityPosition(playerPed, true)
			TriggerServerEvent('falszywyy_barylki:komunikat', 'Wyjmuje z kieszeni substancje i zaczyna mieszać')
			ESX.PlayAnim('anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 8.0, 30000, 1)
			exports["exile_taskbar"]:taskBar(15000, "Mieszanie substancji", false, true)
			TriggerServerEvent('falszywyy_barylki:komunikat', 'Zaczyna owijać i pakować substancje w baryłke')
			Citizen.Wait(100)
			exports["exile_taskbar"]:taskBar(15000, "Owijanie i pakowanie substancji", false, true)
			Citizen.Wait(100)
			TriggerServerEvent("falszywyy_barylki:mieszacz",'weed')
			FreezeEntityPosition(playerPed, false)
			Citizen.Wait(1500)
		elseif data2.current.value == 'barylkametaamfetaminy' then
			ESX.UI.Menu.CloseAll()
			FreezeEntityPosition(playerPed, true)
			TriggerServerEvent('falszywyy_barylki:komunikat', 'Wyjmuje z kieszeni substancje i zaczyna mieszać')
			ESX.PlayAnim('anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 8.0, 30000, 1)
			exports["exile_taskbar"]:taskBar(15000, "Mieszanie narkotyku", false, true)
			TriggerServerEvent('falszywyy_barylki:komunikat', 'Zaczyna owijać i pakować substancje w baryłke')
			Citizen.Wait(100)
			exports["exile_taskbar"]:taskBar(15000, "Owijanie i pakowanie substancji", false, true)
			Citizen.Wait(100)
			TriggerServerEvent("falszywyy_barylki:mieszacz",'meth')
			FreezeEntityPosition(playerPed, false)
			Citizen.Wait(1500)
		elseif data2.current.value == 'barylkakokainy' then
			ESX.UI.Menu.CloseAll()
			FreezeEntityPosition(playerPed, true)
			TriggerServerEvent('falszywyy_barylki:komunikat', 'Wyjmuje z kieszeni substancje i zaczyna mieszać')
			ESX.PlayAnim('anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 8.0, 30000, 1)
			exports["exile_taskbar"]:taskBar(15000, "Mieszanie narkotyku", false, true)
			TriggerServerEvent('falszywyy_barylki:komunikat', 'Zaczyna owijać i pakować substancje w baryłke')
			Citizen.Wait(100)
			exports["exile_taskbar"]:taskBar(15000, "Owijanie i pakowanie substancji", false, true)
			Citizen.Wait(100)
			TriggerServerEvent("falszywyy_barylki:mieszacz",'coke')
			FreezeEntityPosition(playerPed, false)
			Citizen.Wait(1500)
		elseif data2.current.value == 'barylkaopium' then
			ESX.UI.Menu.CloseAll()
			FreezeEntityPosition(playerPed, true)
			TriggerServerEvent('falszywyy_barylki:komunikat', 'Wyjmuje z kieszeni substancje i zaczyna mieszać')
			ESX.PlayAnim('anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 8.0, 30000, 1)
			exports["exile_taskbar"]:taskBar(15000, "Mieszanie narkotyku", false, true)
			TriggerServerEvent('falszywyy_barylki:komunikat', 'Zaczyna owijać i pakować substancje w baryłke')
			Citizen.Wait(100)
			exports["exile_taskbar"]:taskBar(15000, "Owijanie i pakowanie substancji", false, true)
			Citizen.Wait(100)
			TriggerServerEvent("falszywyy_barylki:mieszacz",'opium')
			FreezeEntityPosition(playerPed, false)
			Citizen.Wait(1500)
		end	
	end, function(data2, menu2)
		menu2.close()
	end)
end)