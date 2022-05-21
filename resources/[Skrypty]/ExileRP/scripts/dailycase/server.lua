RegisterCommand("dailycase", function(source, args, rawCommand)
    local hex = PlayerIdentifier("steam", source)
    local NaIleDni = 1
    local DniNaSekundy = NaIleDni * 24 * 60 * 60
    local xPlayer  = ESX.GetPlayerFromId(source)

        MySQL.single('SELECT * FROM dailycase WHERE hex = ?', {hex}, function(result)
            if result ~= nil then
                if result.time <= os.time() then
                    local time = os.time() + DniNaSekundy

                    MySQL.update('UPDATE dailycase SET time = ? WHERE hex = ? ', {time, hex}, function(affectedRows)
                        if affectedRows then
                            --print(affectedRows)
                        end
                    end)

                    DajNagrode2(source)
                else
                    local zostalo = result.time - os.time()
                    local ZostaloGodzin = zostalo / 60 / 60

                    TriggerClientEvent("esx:showNotification", xPlayer.source, "Aby użyć komendy poczekaj jeszcze "..math.ceil(ZostaloGodzin).." godzin/y")
                end
            else
                local time = os.time() + DniNaSekundy

                MySQL.insert('INSERT INTO dailycase (hex, time) VALUES (?, ?) ', {hex, time}, function(id)
                end)

                DajNagrode2(source)
            end
        end)
end, false)

function DajNagrode2(id)
    local xPlayer  = ESX.GetPlayerFromId(id)
    TriggerClientEvent("esx:showNotification", xPlayer.source, "Otrzymałeś ~g~Daily Case!")
    xPlayer.addInventoryItem('dailycase', 1)
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