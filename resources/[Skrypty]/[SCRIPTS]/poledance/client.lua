ESX = nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) 
		ESX = obj 
		end)
        Citizen.Wait(1000)
    end
end)

bool = false

CreateThread(function()
    while true do
		Citizen.Wait(1)
            if Config['PoleDance']['Enabled'] then
                for k, v in pairs(Config['PoleDance']['Locations']) do
                    if #(GetEntityCoords(PlayerPedId()) - v['Position']) <= 1.0 then
                        ESX.ShowHelpNotification(Strings['Pole_Dance'], v['Position'])
                        if IsControlJustReleased(0, 51) and not bool then
						    bool = true
                            LoadDict('mini@strip_club@pole_dance@pole_dance' .. v['Number'])
                            local scene = NetworkCreateSynchronisedScene(v['Position'], vector3(0.0, 0.0, 0.0), 2, false, false, 1065353216, 0, 1.3)
                            NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, 'mini@strip_club@pole_dance@pole_dance' .. v['Number'], 'pd_dance_0' .. v['Number'], 1.5, -4.0, 1, 1, 1148846080, 0)
                            NetworkStartSynchronisedScene(scene)
						elseif IsControlJustReleased(0, 51) and bool then
						    bool = false
						    ClearPedTasksImmediately(PlayerPedId())
                        end
                    end
                    Wait(15)
                end
            end
    end
end)

LoadDict = function(Dict)
    while not HasAnimDictLoaded(Dict) do 
        Wait(5)
        RequestAnimDict(Dict)
    end
end