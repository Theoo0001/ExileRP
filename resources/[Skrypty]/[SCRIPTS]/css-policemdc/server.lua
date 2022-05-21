ESX = nil
TriggerEvent("hypex:getTwojStarySharedTwojaStaraObject", function(obj) ESX = obj end)

local dispatch = "https://docs.google.com/spreadsheets/d/1G81OpFeEiCdciQlquQtFGF_Z17y5ZluxweCHW7pLMN4/edit"
local hours = "https://docs.google.com/forms/d/e/1FAIpQLSfYanSJ92U0i976YzoRY6NKE-nr5n75ew7A3Ef5ZeYhbAhWvA/viewform"
RegisterServerEvent("csskroubleMdc:fetchLinks", function() 
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer and xPlayer.source ~= 0 then
        if xPlayer.getJob() == "police" or xPlayer.getJob() == "offpolice" then
            TriggerClientEvent("csskroubleMdc:setLinks", src, {dispatch = dispatch, hours = hours})
        end
    end
end)