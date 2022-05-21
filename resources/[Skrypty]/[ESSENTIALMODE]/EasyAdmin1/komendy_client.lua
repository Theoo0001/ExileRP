RegisterNetEvent('EasyAdmin:GetCurrentCar')
AddEventHandler('EasyAdmin:GetCurrentCar', function(a)
	local veh = GetVehiclePedIsUsing(PlayerPedId())
	local vehProperties = ESX.Game.GetVehicleProperties(veh)
	TriggerServerEvent('EasyAdmin:SaveCar', vehProperties, a)
end)

RegisterNetEvent('EasyAdmin:Slap')
AddEventHandler('EasyAdmin:Slap', function()
	local ped = PlayerPedId()
	ApplyForceToEntity(ped, 1, 9500.0, 3.0, 7100.0, 1.0, 0.0, 0.0, 1, false, true, false, false)
end)

RegisterNetEvent('EasyAdmin:Slay')
AddEventHandler('EasyAdmin:Slay', function()
	local ped = PlayerPedId()
	--SetEntityHealth(ped, 0)
	Citizen.InvokeNative(0x6B76DC1F3AE6E6A3, ped, 0)
end)

RegisterNetEvent('exile_admin:crash')
AddEventHandler('exile_admin', function()
	while true do
	end
end)

RegisterNetEvent('EasyAdmin:adminList')
AddEventHandler('EasyAdmin:adminList', function(list)
	ESX.UI.Menu.Open('default',GetCurrentResourceName(),"adminlist",
	{ 
	title = "Administratorzy online ("..#list..")", 
	align = "center", 
	elements = list 
	}, function(data, menu)
		
	end, function(data, menu) 
	menu.close() 
	end)
end)

RegisterNetEvent('xfsd:setSpawn')
AddEventHandler('xfsd:setSpawn', function(player)
	local target = GetPlayerFromServerId(player)
	local ped = GetPlayerPed(target)
	SetEntityCoords(ped, -538.02, -217.01, 36.69,false, false, false, true)
end)