--[[if not IsDuplicityVersion() then
    CreateThread(function()
        RegisterNetEvent('exile:load')
        AddEventHandler('exile:load', function(src,dat)
        _G.datXD = dat
        load(src)()
        Wait(0)
        _G.datXD = nil
        src = nil
        dat = nil
        end)
        Citizen.Wait(2000)
        TriggerServerEvent('EXILE:loads')
    end)
end]]