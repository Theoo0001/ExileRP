RegisterNetEvent("exile_pralnia:getrequest")
TriggerServerEvent("exile_pralnia:request")
AddEventHandler("exile_pralnia:getrequest", function(a)
	_G.donttry = a
	local wypierz = _G.donttry

ESX = nil 
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

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

local onMission = false
local current = nil
local onAction = false
local txt = "rozpocząć"
local currenttarget = {x = 0, y = 0, z = 0}
local target = {}
CreateThread(function()
    local v = Config.Zones
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        if not IsPedSittingInAnyVehicle(ped, false) then
            sleep = true
            if #(coords - vec3(v.Start.x, v.Start.y, v.Start.z)) <= 10 then
                sleep = false
                current = 'Start'
                ESX.DrawMarker(vec3(v.Start.x, v.Start.y, v.Start.z))
            end
        end
        if IsPedSittingInAnyVehicle(ped, false) then
            sleep = true
            if onMission and #(coords - vec3(v.Delete.x, v.Delete.y, v.Delete.z)) <= 10 then
                sleep = false
                current = 'Delete'
                ESX.DrawBigMarker(vec3(v.Delete.x, v.Delete.y, v.Delete.z))
                if #(coords - vec3(v.Delete.x, v.Delete.y, v.Delete.z)) <= 3.5 then
                    ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~ aby oddać pojazd')
                    if IsControlJustPressed(0, 38) and not onAction then
                        onAction = true
                        if IsVehicleModel(GetVehiclePedIsUsing(PlayerPedId()), 'burrito3') then
                            ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()), false)
                            onAction = false
                        else
                            onAction = false
                            ESX.ShowNotification('Możesz oddać jedynie pojazd dostawczy')
                        end
                    end
                end
            else
                Wait(2000)
            end
        end
        if current == 'Start' then
            sleep = true
            if #(coords - vec3(v.Start.x, v.Start.y, v.Start.z)) <= 1.5 then
                sleep = false
                if onMission then 
                    txt = "zakończyć"
                else
                    txt = txt
                end
                ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~ aby ~y~'..txt..' pranie~s~')
                if IsControlJustPressed(0, 38) and not onAction then
                    onAction = true
                    Citizen.Wait(1000)
                    if not onMission then
                        ESX.TriggerServerCallback('exile_pralnia:maBrud', function(money)
                            if money then
                                StartMission(true)
                            else
                                onAction = false
                                ESX.ShowNotification('Nie posiadasz conajmniej ~g~'..Config.MinBrud..'$~r~ brudnej gotówki')
                            end
                        end)
                    else
                        StartMission(false)
                    end
                end
            end
        end
        if sleep then
            Wait(500)
        end
    end
end)

CreateThread(function()
    while true do
        Citizen.Wait(0)
    	if onMission then
            local lastVeh = GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), true))
            local player = GetEntityCoords(PlayerPedId())
			if #(player - vec3(currenttarget.x, currenttarget.y, currenttarget.z)) < 7 then
                ESX.DrawMarker(vec3(currenttarget.x, currenttarget.y, currenttarget.z-0.95))
				if #(player - vec3(currenttarget.x, currenttarget.y, currenttarget.z)) < 1.0 then
					ESX.ShowHelpNotification('Naciśnij ~INPUT_CONTEXT~, aby wyprać brudną gotówke')
					if IsControlPressed(1, 51) and not onAction then
						onAction = true
                        if not IsPedSittingInAnyVehicle(PlayerPedId(), false) then
							if lastVeh == `burrito3` then
							    OpenChoice()
							else
                                onAction = false
								ESX.ShowNotification('Nie przyjechałeś tutaj właściwym pojazdem')
							end
                        else
                            onAction = false
                            ESX.ShowNotification('Tej czynności nie możesz wykonać w pojeździe')
                        end
                        Citizen.Wait(1000)
					end
				end
			end
        else
            Citizen.Wait(2000)
		end
    end
end)

function StartMission(etap)
    if etap then
        local v = Config.Zones
        if not IsAnyVehicleNearPoint(v.Vehicle.x, v.Vehicle.y, v.Vehicle.z,  3.0) then
            ESX.Game.SpawnVehicle("burrito3", v.Vehicle, 180.5, function(vehicle) 
                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            end)
            onMission = true
            current = 'pranie'
            onAction = false
            ESX.ShowAdvancedNotification('Lester','~r~Pranie brudnej gotówki',"Zaznaczyłem ci na GPS'ie~s~ bankomat, udaj się do niego i obrabuj")
            Citizen.Wait(500)
            trasa()
            Citizen.Wait(2000)
            ESX.ShowHelpNotification('~b~Aby zakończyć~s~, oddaj pojazd oraz zakończ pranie w miejscu startu')
        else
            ESX.ShowNotification('Jakiś pojazd zastawia miejsce')
        end
    else
        onMission = false
        onAction = false
        current = nil
        ESX.ShowNotification('Zakończono pranie')
        txt = 'rozpocząć'
        RemoveBlip(target['atm']) 
    end
end


function newTarget()
	local rdm = math.random(1,15)
	if rdm == 1 then
		currenttarget = {x = 146.04, y = -1035.0, z = 29.34}
	elseif rdm == 2 then
		currenttarget = {x = -821.63, y = -1082.07, z = 11.13}
	elseif rdm == 3 then
		currenttarget = {x = -2072.44, y = -317.29, z = 13.32}
	elseif rdm == 4 then
		currenttarget = {x = -710.16, y = -819.18, z = 23.73}
	elseif rdm == 5 then
		currenttarget = {x = -526.59, y = -1222.86, z = 18.45}
	elseif rdm == 6 then
		currenttarget = {x = 89.55, y = 2.27, z = 68.32}
	elseif rdm == 7 then
		currenttarget = {x = -164.82, y = 232.61, z = 94.92}
	elseif rdm == 8 then
		currenttarget = {x = -866.57, y = -187.75, z = 37.83}
	elseif rdm == 9 then
		currenttarget = {x = -256.07, y = -716.16, z = 33.51}
	elseif rdm == 10 then
		currenttarget = {x = -254.33, y = -692.21, z = 33.61}
	elseif rdm == 11 then
		currenttarget = {x = 114.38, y = -776.64, z = 31.42}
	elseif rdm == 12 then
		currenttarget = {x = 112.65, y = -819.25, z = 31.34}
	elseif rdm == 13 then
		currenttarget = {x = 4.91, y = -919.76, z = 29.56}
	elseif rdm == 14 then
		currenttarget = {x = -203.73, y = -861.45, z = 30.27}
	elseif rdm == 15 then
		currenttarget = {x = 1077.71, y = -776.05, z = 58.23}
	end
end
function ForceEnd(val)
    if val then
       TriggerServerEvent(wypierz, GetCurrentResourceName())
       trasa()
    else
        local coords = GetEntityCoords(PlayerPedId())
        TriggerServerEvent('exile_pralnia:alert', coords)
        trasa()
    end
    onAction = false
end
function trasa()
    newTarget()
    Citizen.Wait(1500)
	RemoveBlip(target['atm'])
	target['atm'] = AddBlipForCoord(currenttarget.x, currenttarget.y, currenttarget.z)
	SetBlipRoute(target['atm'], true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('ATM')
	EndTextCommandSetBlipName(target['atm'])
end

RegisterNetEvent('exile_pralnia:trasa')
AddEventHandler('exile_pralnia:trasa', function()
	trasa()
end)

RegisterNetEvent('exile_pralnia:stop')
AddEventHandler('exile_pralnia:stop', function()
	StartMission(false)
end)

function  OpenChoice()
    local elements = {
        {label = '== Metoda obrabowania ==', value = 'null'},
        {label = 'Hackowanie', value = 'hack'},
        {label = 'Włamanie ręczne', value = 'fiz'},
    }
    ESX.UI.Menu.Open('default',GetCurrentResourceName(),'choice_pralnia',
    { 
    title = 'Dokonaj wyboru', 
    align = 'center', 
    elements = elements 
    }, function(data, menu)
        if data.current.value == 'hack' then
            Start(4.5)
            menu.close()
            ESX.UI.Menu.CloseAll()
        elseif data.current.value == 'fiz' then
            menu.close()
            ESX.UI.Menu.CloseAll()
            TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_WELDING',0, false)
            FreezeEntityPosition(PlayerPedId(), true)
            Citizen.Wait(10000)
            FreezeEntityPosition(PlayerPedId(), false)
            ClearPedTasks(PlayerPedId())
            local czysieudalo = math.random(1,100)
            if czysieudalo < 70 then
                ForceEnd(true)
                ESX.ShowAdvancedNotification('Lester','~r~Pranie brudnej gotówki',"Super, kolejny bankomat oznaczony")
            else
                ESX.ShowAdvancedNotification('Lester','~r~Pranie brudnej gotówki',"~r~To nie zabawa!~s~ Uciekaj stamtąd zanim psy cie zgarną")
                ForceEnd(false)
                PlaySoundFrontend(-1, "CHECKPOINT_MISSED", 0, 1)
            end
        end
    end, function(data, menu) 
        onAction = false
      menu.close() 
    end)
end

blips = {}
RegisterNetEvent("exile_pralnia:alert")
AddEventHandler("exile_pralnia:alert", function(coords)
	if PlayerData.job ~= nil and PlayerData.job.name == 'police' then
		local streetHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
		local street = GetStreetNameFromHashKey(streetHash)

        TriggerEvent('chat:addMessage1',"^3Centrala", {0, 0, 0}, "Próba obrabowania bankomatu na ulicy ^5"..street, "fas fa-laptop")
		local blip2 = AddBlipForCoord(coords.x, coords.y, coords.z)
		
		SetBlipSprite(blip2,  431)
		SetBlipColour(blip2,  1)
		SetBlipAsShortRange(blip2,  1)
		
		SetBlipFlashes(blip2, true)
		SetBlipFlashTimer(blip2, 3500)
		
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("# Obrabowanie bankomatu")
		EndTextCommandSetBlipName(blip2)
		
		table.insert(blips, { gone = GetGameTimer() + 12500, blip = blip })
		table.insert(blips, { gone = GetGameTimer() + 12500, blip = blip2 })
	end
end)

CreateThread(function()
	while true do
		Wait(1000)
		for k,v in pairs(blips) do
            if v ~= nil then
                if  GetGameTimer() > v.gone then
                    RemoveBlip(v.blip2)
                    
                    blips[k] = nil
                end
            else
                Citizen.Wait(2000)
            end
		end
	end
end)

end)