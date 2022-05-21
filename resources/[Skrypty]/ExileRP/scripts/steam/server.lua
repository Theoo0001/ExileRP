TabelaZWariantami = {
    "ExileRP.eu",
    "exilerp.eu",
    "ExileRP",
    "exilerp"
}

RegisterCommand("nagroda", function(source, args, rawCommand)
    local nick = GetPlayerName(source)
    local znalazl = false
    local hex = PlayerIdentifier("steam", source)
    local NaIleDni = 1 --dni
    local DniNaSekundy = NaIleDni * 24 * 60 * 60
    local xPlayer  = ESX.GetPlayerFromId(source)

    for k, v in pairs(TabelaZWariantami) do
        local jest = string.find(nick, v)
        if jest ~= nil then
            znalazl = true
        end
    end

    if znalazl then --czy znalazł w niku exilrp
        MySQL.single('SELECT * FROM jakastabela WHERE hex = ?', {hex}, function(result)
            if result ~= nil then --Czy użytkownik jest w tabeli
                if result.time <= os.time() then
                    local time = os.time() + DniNaSekundy

                    MySQL.update('UPDATE jakastabela SET time = ? WHERE hex = ? ', {time, hex}, function(affectedRows) -- jebane doksy oxmysql
                        if affectedRows then
                            --print(affectedRows)
                        end
                    end)

                    DajNagrode(source)
                    exports['exile_logs']:SendLog(source, "UDANE: Otrzymał nagrodę za posiadanie w nicku steam odpowiedniego tagu w wysokości: 15.000$", 'nagrodynick', '5793266')
                else
                    local zostalo = result.time - os.time()
                    local ZostaloGodzin = zostalo / 60 / 60

                    TriggerClientEvent("esx:showNotification", xPlayer.source, "Aby użyć komendy poczekaj jeszcze "..math.ceil(ZostaloGodzin).." godzin/y")
                end
            else --Jeśli nie ma gościa w tabeli to daj nagrode i wpisz go
                local time = os.time() + DniNaSekundy

                MySQL.insert('INSERT INTO jakastabela (hex, time) VALUES (?, ?) ', {hex, time}, function(id)
                    --print(id)
                end)

                DajNagrode(source)
            end
        end)
    else
        TriggerClientEvent("esx:showNotification", xPlayer.source, "Nie posiadasz w nicku odpowiedniego tekstu!")
    end
end, false)

-- BATTLEPASS

RegisterCommand("addbattlepass", function(source, args, rawCommand)
    local xPlayer  = ESX.GetPlayerFromId(source)
    local moze = false

    if source == 0 then
        moze = true
    else
        local group = xPlayer.getGroup()
        if group == "mod" then
            moze = true
        elseif group == "admin" then
            moze = true
        elseif group == "superadmin" then
            moze = true
        elseif group == "best" then
            moze = true
        elseif group == "dev" then
            moze = true
        end
    end

    if xPlayer or source == 0 then
        if moze then
            local hex = args[1]

            if string.find(hex, "steam:110000") then --czy dobrze wpisał hexa

                MySQL.single('SELECT * FROM battlepass WHERE hex = ?', {hex}, function(result)
                    if result == nil then -- czy niema battle pasa
                        MySQL.insert('INSERT INTO battlepass (hex) VALUES (?) ', {hex}, function(id)
                            --print(id)
                        end)
                        TriggerClientEvent("esx:showNotification", source, "Dodano Battlepass dla: "..hex)
                        exports['exile_logs']:SendLog(source, "DODANO: Battlepass dla: "..hex, 'battlepass', '5793266')
                    else
                        TriggerClientEvent("esx:showNotification", source, hex.." Ma już Battlepassa")
                    end
                end)

            else
                TriggerClientEvent("esx:showNotification", source, "Nie poprawna forma zapisu!!")
                TriggerClientEvent("esx:showNotification", source, "steam:xxxxxxxxxxxxxxx")
            end
        else
            TriggerClientEvent("esx:showNotification", source, "Nie masz permisji do użycia tego")
        end
    end
end, false)

RegisterCommand("rmbattlepass", function(source, args, rawCommand)
    local xPlayer  = ESX.GetPlayerFromId(source)
    local moze = false

    if source == 0 then
        moze = true
    else
        local group = xPlayer.getGroup()
        if group == "mod" then
            moze = true
        elseif group == "admin" then
            moze = true
        elseif group == "superadmin" then
            moze = true
        elseif group == "best" then
            moze = true
        elseif group == "dev" then
            moze = true
        end
    end

    if xPlayer or source == 0 then
        if moze then
            local hex = args[1]

            if string.find(hex, "steam:110000") then --czy dobrze wpisał hexa

                MySQL.single('SELECT * FROM battlepass WHERE hex = ?', {hex}, function(result)
                    if result ~= nil then -- czy ma battle pasa
                        MySQL.Async.execute('DELETE FROM battlepass WHERE hex = ? ', {hex}, function(id)
                            --print(id)
                        end)
                        TriggerClientEvent("esx:showNotification", source, "Zabrano Battlepass dla: "..hex)
                        exports['exile_logs']:SendLog(source, "ZABRANO: Battlepass dla: "..hex, 'battlepass', '5793266')
                    else
                        TriggerClientEvent("esx:showNotification", source, hex.." Nie ma Battlepass")
                    end
                end)

            else
                TriggerClientEvent("esx:showNotification", source, "Nie poprawna forma zapisu!!")
                TriggerClientEvent("esx:showNotification", source, "steam:xxxxxxxxxxxxxxx")
            end

        else
            TriggerClientEvent("esx:showNotification", source, "Nie masz Permisji do użycia tego")
        end
    end
end, false)

RegisterCommand("checkbattlepass", function(source, args, rawCommand)
    local xPlayer  = ESX.GetPlayerFromId(source)
    local moze = false

    if source == 0 then
        moze = true
    else
        local group = xPlayer.getGroup()
        if group == "mod" then
            moze = true
        elseif group == "admin" then
            moze = true
        elseif group == "superadmin" then
            moze = true
        elseif group == "best" then
            moze = true
        elseif group == "dev" then
            moze = true
        end
    end

    if xPlayer or source == 0 then
        if moze then
            local hex = args[1]

            if string.find(hex, "steam:110000") then --czy dobrze wpisał hexa

                MySQL.single('SELECT * FROM battlepass WHERE hex = ?', {hex}, function(result)
                    if result ~= nil then -- czy ma battle pasa
                        TriggerClientEvent("esx:showNotification", source, hex.." Ma Battlepass ")
                    else
                        TriggerClientEvent("esx:showNotification", source, hex.." Nie ma battlepass")
                    end
                end)

            else
                TriggerClientEvent("esx:showNotification", source, "Nie poprawna forma zapisu!!")
                TriggerClientEvent("esx:showNotification", source, "steam:xxxxxxxxxxxxxxx")
            end

        else
            TriggerClientEvent("esx:showNotification", source, "Nie masz Permisji do użycia tego")
        end
    end
end, false)

RegisterCommand("battlepass", function(source, args, rawCommand)
    local hex = PlayerIdentifier("steam", source)
    local NaIleDni = 1 --dni
    local DniNaSekundy = NaIleDni * 24 * 60 * 60


    MySQL.single('SELECT * FROM battlepass WHERE hex = ?', {hex}, function(result)
        if result ~= nil then --Czy użytkownik ma battlepassa
            if result.time <= os.time() then
                local time = os.time() + DniNaSekundy

                MySQL.update('UPDATE battlepass SET time = ? WHERE hex = ? ', {time, hex}, function(affectedRows) -- jebane doksy oxmysql
                    if affectedRows then
                        --print(affectedRows)
                    end
                end)

                DajNagrodeBattlePass(source)
                exports['exile_logs']:SendLog(source, "ODEBRAL: Battlepass", 'battlepass', '5793266')

            else
                local zostalo = result.time - os.time()
                local ZostaloGodzin = zostalo / 60 / 60

                TriggerClientEvent("esx:showNotification", source, "Aby użyć komendy poczekaj jeszcze "..math.ceil(ZostaloGodzin).." godzin/y")

            end
        else
            TriggerClientEvent("esx:showNotification", source, "Nie posiadasz BattlePass'a")
        end
    end)
end, false)

function DajNagrodeBattlePass(id)
    local xPlayer  = ESX.GetPlayerFromId(id)
    local kasa = 100000
    xPlayer.addMoney(kasa)

    TriggerClientEvent("esx:showNotification", xPlayer.source, "Otrzymałeś nagrodę w wysokości: "..kasa.."$")
end


function DajNagrode(id)
    local xPlayer  = ESX.GetPlayerFromId(id)
    local kasa = 15000
    xPlayer.addMoney(kasa)

    TriggerClientEvent("esx:showNotification", xPlayer.source, "Otrzymałeś nagrodę w wysokości: "..kasa.."$")
end

function PlayerIdentifier(type, id)
    local identifiers = {}
    local numIdentifiers = GetNumPlayerIdentifiers(id)

    for a = 0, numIdentifiers do
        table.insert(identifiers, GetPlayerIdentifier(id, a))
    end

    for b = 1, #identifiers do
        if string.find(identifiers[b], type, 1) then
            return identifiers[b]
        end
    end
    return false
end