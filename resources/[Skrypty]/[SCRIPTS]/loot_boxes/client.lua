ESX = nil
local draw = {}

CreateThread(function()
	while ESX == nil do
		TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end	
end)

RegisterNUICallback('exile_boxes:NUIoff', function(data, cb)
	SetNuiFocus(false,false)
    SendNUIMessage({
        type = "off"
    })
end)

-- [[ SKRZYNKI ]] --

RegisterNetEvent("exile_boxes:openexilecases")
AddEventHandler("exile_boxes:openexilecases", function(chest, win)
	SetNuiFocus(true,true)
	SendNUIMessage({
    type = "ui",
		data = win.data,
		img = win.img,
		win = win.win
  })
	Wait(9000)
	TriggerServerEvent('exile_boxes:giveReward')
end)