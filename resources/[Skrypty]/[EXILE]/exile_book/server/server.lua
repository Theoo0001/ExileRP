ESX = nil
TriggerEvent('hypex:getTwojStarySharedTwojaStaraObject', function(obj) ESX = obj end)

RegisterServerEvent('exilebook:check')
AddEventHandler('exilebook:check', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local item = xPlayer.getInventoryItem('tablet').count
    if item >= 1 then
        TriggerClientEvent('exilebook:open', _source)
    else
        TriggerClientEvent('esx:showNotification', _source, 'Nie posiadasz przy sobie Tabletu aby móc korzystać z platformy Exile-Book.pl')
    end
end)