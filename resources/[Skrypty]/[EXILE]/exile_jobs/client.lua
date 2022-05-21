local PlayerData = {}
ESX = nil



CreateThread(function()
	while ESX == nil do
		TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) 
			ESX = obj 
		end)
		
		Citizen.Wait(250)
	end
end)

CreateThread(function()
    Citizen.Wait(1000)
	for i=1, #Config.Blipy, 1 do
		local blip = AddBlipForCoord(Config.Blipy[i].Pos)

		SetBlipSprite (blip, Config.Blipy[i].Sprite)
		SetBlipDisplay(blip, Config.Blipy[i].Display)
		SetBlipScale  (blip, Config.Blipy[i].Scale)
		SetBlipColour (blip, Config.Blipy[i].Colour)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.Blipy[i].Label)
		EndTextCommandSetBlipName(blip)
	end
end)

CreateThread(function ()
	while true do
		Citizen.Wait(0)
		ESX.DrawMarker(vec3(Config.Marker.x, Config.Marker.y, Config.Marker.z))
		if #(GetEntityCoords(PlayerPedId()) - vec3(-551.7,-192.38,38.22)) < 1 then
			DisplayHelpText("Nacisnij ~INPUT_PICKUP~ aby się ~g~zatrudnic")
		 if (IsControlJustReleased(1, 51)) then
			SetNuiFocus( true, true )
			SendNUIMessage({
				ativa = true
			})
		 end
		end
	end
end)

RegisterNUICallback('unemployed', function(data, cb)
	TriggerServerEvent('exile_jobs:nadawanie', 'unemployed')
  	cb('ok')
end)

RegisterNUICallback('baker', function(data, cb)
	TriggerServerEvent('exile_jobs:nadawanie', 'baker')
	cb('ok')
end)

RegisterNUICallback('courier', function(data, cb)
	TriggerServerEvent('exile_jobs:nadawanie', 'courier')
	cb('ok')
end)

RegisterNUICallback('fisherman', function(data, cb)
	TriggerServerEvent('exile_jobs:nadawanie', 'fisherman')
	cb('ok')
end)

RegisterNUICallback('grower', function(data, cb)
	TriggerServerEvent('exile_jobs:nadawanie', 'grower')
	cb('ok')
end)

RegisterNUICallback('milkman', function(data, cb)
	TriggerServerEvent('exile_jobs:nadawanie', 'milkman')
	cb('ok')
end)

RegisterNUICallback('kawiarnia', function(data, cb)
	TriggerServerEvent('exile_jobs:nadawanie', 'kawiarnia')
	cb('ok')
end)

RegisterNUICallback('fechar', function(data, cb)
	SetNuiFocus( false )
	SendNUIMessage({
	ativa = false
	})
  	cb('ok')
end)

function DrawSpecialText(m_text, showtime)
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
